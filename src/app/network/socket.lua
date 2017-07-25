--[[
	粘包处理
    Created by licong on 2017/07/23.
]]

local SimpleTCP = require("framework.SimpleTCP")
local socket = class("socket",SimpleTCP)
local readPack = nil
function socket:ctor(host, port, callback)
	self.pool = ""
	self.__callback = callback
	local func = function(event,data)
		if event ~= SimpleTCP.EVENT_DATA then
			self.__callback(event)
		else
			self.pool = string.format("%s%s",self.pool, data)
			readPack = function(buffer)
				local buffer_len = string.len(buffer)
				if buffer_len >= 4 then
					local index,size = string.unpack(string.sub(self.pool,1,4),">i")
					if size <= (buffer_len - 4) then
						self.__callback(event,string.sub(self.pool,index,index+size-1))
						self.pool = string.sub(self.pool,index+size,-1)
						readPack(self.pool)
					end
				end
			end
			readPack(self.pool)
		end
	end
	socket.super.ctor(self,host, port, func)
end

function socket:send(cmd,content)
	socket.super.send(self,string.pack(">iia",string.len(content)+4,cmd,content))
end

return socket