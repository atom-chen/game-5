--[[
    Created by licong on 2017/07/25.
]]


local LogoScene = class("LogoScene",function() return display.newScene("MainScene") end)

function LogoScene:ctor()
	-- 存在问题，当有热更时
	protobuf.register_file("res/pb/login.pb")
	protobuf.register_file("res/pb/game.pb")
end

function LogoScene:onEnter()
	display.newSprite("res/logo.jpg"):addTo(self):pos(display.cx,display.cy)
	HttpHelper.sendMessage(CMD_HTTP_CHECKVERSION,{app_id = 1,ver_id = "1.0",p_id = 1},function(data)
		-- dump(data)
	end)

	-- HttpHelper.sendMessage(CMD_HTTP_LOGIN,{open_id = "licong", channel = 4,app_id = 1,device_id = "android",ver_id = "1.0",location = "未知"},function(data)
	-- 	dump(data)
	-- end)
end

return LogoScene