
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    display.newTTFLabel({text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
end

function MainScene:onEnter()
	protobuf.register_file("res/addressbook.pb")

	local person = {
		name = "licong's client",
		id = 123,
		phone = {
			{ number = "123456" , type = "WORK" },
			{ number = "123456" , type = "HOME" },
		}
	}
	local buffer,size = nil
	local buffer = protobuf.encode("tutorial.Person", person)
	

	-- dump(old)
	-- pack(string.format(">i%ds",size),size,buffer)
	-- local begin = os.time()
	-- local buffer = nil
	-- for i=1,1000000 do
	
	-- end
	-- local endtime = os.time()

	-- print("encode time:",endtime-begin)

	-- for i=1,1000000 do 
	-- 	local t = protobuf.decode("tutorial.Person", buffer)
	-- end

	-- print("decode time:",os.time()-endtime)
	-- print(endtime - begin,begin)
		-- local t = protobuf.decode("tutorial.Person", buffer)
		-- print((t["phone"][1]["type"]))
		-- dump(t["phone"][1])

	-- local pack = require("pack")
	-- print(bpack)

	-- local recvsize = 1
	-- -- print ("<"+recvsize+"s")
	-- print(string.sub("helloworld",4,string.len("helloworld")))
	-- local sock = nil
	-- local _fmt = string.format(">i%d",size)
	-- print(string.len(buffer))
	-- local newbuffer = string.format("%s%s","",buffer)
	-- print(string.len(newbuffer))
	-- -- local buf = string.pack("aa","hello","world")
	-- -- print(string.len(buf))
	-- -- local buf = string.pack("a","helloworld")
	-- -- print(string.len(buf))
	-- -- dump(string)
	-- do return end
	local _fmt = ">ia"
	local bb = string.pack(_fmt,string.len(buffer),buffer)
	-- print(string.len(bb))
	-- print(string.unpack(bb,">P"))

	local times = 0
	self.sock = require("app.network.socket").new("192.168.0.101",8010,function (event,data)
		-- print(event)
		if event == "Data" then
			local ne,s = string.unpack(data,">i")
			local t = protobuf.decode("tutorial.Person",string.sub(data,ne,-1),string.len(data)-4)

			print("times:",t.id," name:",t.name)
	
			self.sock:send(1,bb)
		end
	end)
	self.sock:connect()
end


function MainScene:onExit()
end

return MainScene
