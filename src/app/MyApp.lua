
require("config")
require("cocos.init")
require("framework.init")
require("app.init")
local AppBase = require("framework.AppBase")
local MyApp = class("MyApp", AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
  
    local scene = require("app.gamma.logoscene").new()
    display.replaceScene(scene)
end

return MyApp
