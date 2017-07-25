--[[
    Created by licong on 2017/07/25.
]]
HttpHelper = {}

local login_server  = "http://192.168.41.141:9700/"

local function send(url,data,callback)
	local request = network.createHTTPRequest(callback,url,"POST")
	request:setTimeout(5)
	request:setPOSTData(data)
	request:start()
end

local function encode(data)
end

local function decode(data)
	return crypto.decodeBase64(data)
end

function HttpHelper.sendMessage(cmd,data,callback)
	local conf = clone(cmd)
	print("requst:",cmd.request)
	send(login_server..conf.domain,protobuf.encode(conf.request, data),function(event)
		
		if event.name == "completed" then
			local request = event.request
			if request:getResponseStatusCode() == 200 then
				if callback then
					local d = decode(request:getResponseData())
					local response,errormsg = protobuf.decode(conf.response,d,string.len(d))
					if response == false then
						print(string.format("############response error: %s",conf.response),errormsg)
					else
						callback(response)
					end
				end
			end
		end

	end)
end