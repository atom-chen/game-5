--[[
    Created by licong on 2017/07/26.
]]
local UpdateCheck = class("UpdateCheck")

--[[
online_verison 线上版本
callback(event) 回调 
回调参数 event{
	name = "fail","success","progress",
	data = 进度
}
]]
function UpdateCheck:ctor(online_version,callback)
	self.online_version = online_version
	self.callback = callback

	self:init()


end

function UpdateCheck:init()
	self.respath = nil
	if device.platform == "windows" then
		self.respath = device.writablePath .. "hotres/"
	else
		self.respath = device.writablePath .. "res/"
	end
	if not io.exists(self.respath) then
		cc.FileUtils:getInstance():createDirectory(self.respath)
	end
end

function UpdateCheck:checkVersion()
end

function UpdateCheck:downVersionFile()
	local filename = "version"
	local path = self.respath .. filename
	local check = false

	if not io.exists(path) then
		check = true
	else

	end

	if check then
		HttpHelper.download(filename,function(request)
			-- print
			-- print(device.writablePath)
			-- local uncompress = zlib.inflate()
			-- local inflated, eof, bytes_in, bytes_out = uncompress(request:getResponseData()) 
			-- print(inflated, eof, bytes_in, bytes_out)
			-- print(request:getResponseData())
			request:saveResponseData(path)
		end)
	end
end

function UpdateCheck:start()
	if self.online_version == VERSION then
		self.callback({name = "success",data = false})
	else
		self:downVersionFile()
	end
end


return UpdateCheck