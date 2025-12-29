--[[
     Version: 2.0.0                                              
     License: MIT                                                
    
    
    @module AcrylicUI
    @author AcrylicUI Team
    @version 2.0.0
    
    @example
    local AcrylicUI = require(path.to.AcrylicUI)
    
    local window = AcrylicUI.CreateWindow({
        Title = "My Hub",
        ToggleKey = Enum.KeyCode.RightControl
    })
    
    local section = window:CreateSection("Combat")
    local tab = section:CreateTab("Aimbot", "rbxassetid://10723407389")
    
    tab:CreateToggle({
        Name = "Enable Aimbot",
        Default = false,
        Callback = function(enabled)
            print("Aimbot:", enabled)
        end
    })
]]

local AcrylicUI = {}
AcrylicUI.__index = AcrylicUI

-- Version info
AcrylicUI.Version = "2.0.0"
AcrylicUI.Author = "Acrylic"

-- Core modules
local Window = require(script.Core.Window)

-- Constants (exposed for customization)
AcrylicUI.Colors = require(script.Constants.Colors)
AcrylicUI.Sizes = require(script.Constants.Sizes)
AcrylicUI.Fonts = require(script.Constants.Fonts)
AcrylicUI.Animation = require(script.Constants.Animation)

-- Utilities (exposed for advanced usage)
AcrylicUI.Utils = {
    Create = require(script.Utils.Create),
    Tween = require(script.Utils.Tween),
    Draggable = require(script.Utils.Draggable),
    Device = require(script.Utils.Device)
}

--[[
    Creates a new window
    
    @param config WindowConfig - Configuration options
    @return Window - The created window instance
    
    @example
    local window = AcrylicUI.CreateWindow({
        Title = "My Hub",
        Size = { Width = 700, Height = 450 },
        ToggleKey = Enum.KeyCode.RightControl
    })
]]
function AcrylicUI.CreateWindow(config: Window.WindowConfig)
    return Window.new(config)
end

--[[
    Creates a custom theme
    
    @param overrides table - Color overrides
    @return table - Complete theme colors
    
    @example
    local customTheme = AcrylicUI.CreateTheme({
        Accent = Color3.fromRGB(138, 43, 226),
        Background = Color3.fromRGB(20, 20, 30)
    })
]]
function AcrylicUI.CreateTheme(overrides: { [string]: any })
    return AcrylicUI.Colors.CreateTheme(overrides)
end

--[[
    Gets library information
    
    @return table - Library info
]]
function AcrylicUI.GetInfo()
    return {
        Version = AcrylicUI.Version,
        Author = AcrylicUI.Author,
        Components = {
            "Window", "Section", "Tab",
            "Button", "Toggle", "Slider",
            "Dropdown", "Keybind", "ColorPicker",
            "Paragraph", "Notification"
        }
    }
end

return AcrylicUI