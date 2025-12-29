--[[
    Acrylic UI Library
    Services Module - Centralized service management
    
    @author Acrylic Team
    @version 2.0.0
    @license MIT
]]

local Services = {
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    Players = game:GetService("Players"),
    Lighting = game:GetService("Lighting"),
    RunService = game:GetService("RunService"),
    GuiService = game:GetService("GuiService"),
}

--[=[
    @return Player -- Returns the local player instance
]=]
function Services:GetPlayer()
    return self.Players.LocalPlayer
end

--[=[
    @return Camera -- Returns the current camera
]=]
function Services:GetCamera()
    return workspace.CurrentCamera
end

--[=[
    @return boolean -- Returns true if the device is mobile
]=]
function Services:IsMobile()
    return self.UserInputService.TouchEnabled and not self.UserInputService.KeyboardEnabled
end

return Services