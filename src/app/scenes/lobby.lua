--[[
    Created by licong on 2017/07/27.
]]


local LobbyLayer = class("LobbyLayer",require("app.gamma.baselayer"))

function LobbyLayer:ctor()
	display.addSpriteFrames("resource/lobby/common.plist","resource/lobby/common.png")
	display.addSpriteFrames("resource/lobby/lobby.plist","resource/lobby/lobby.png")
	cc.CSLoader:createNode("files/indexScence.csb"):addTo(self)
end


local LobbyScene = class("LobbyScene",function()
    return display.newScene("MainScene")
end)

function LobbyScene:onEnter()
	self:addChild(LobbyLayer.new())
end

return LobbyScene