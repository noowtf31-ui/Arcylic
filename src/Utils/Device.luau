--[[
    AcrylicUI - Device Detection Utility
    
    Detects device type and capabilities.
]]

local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Device = {}

--[[
    Checks if the current device is mobile (touch only)
    
    @return boolean - True if mobile device
]]
function Device.IsMobile(): boolean
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

--[[
    Checks if the current device is a tablet
    
    @return boolean - True if tablet device
]]
function Device.IsTablet(): boolean
    local viewport = workspace.CurrentCamera.ViewportSize
    return Device.IsMobile() and math.min(viewport.X, viewport.Y) >= 600
end

--[[
    Checks if the current device is a console
    
    @return boolean - True if console device
]]
function Device.IsConsole(): boolean
    return UserInputService.GamepadEnabled and 
           not UserInputService.KeyboardEnabled and 
           not UserInputService.TouchEnabled
end

--[[
    Checks if the current device is desktop
    
    @return boolean - True if desktop device
]]
function Device.IsDesktop(): boolean
    return UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
end

--[[
    Gets the safe area insets (for notched devices)
    
    @return { Top: number, Bottom: number, Left: number, Right: number }
]]
function Device.GetSafeAreaInsets(): { Top: number, Bottom: number, Left: number, Right: number }
    local insets = GuiService:GetGuiInset()
    return {
        Top = insets.Y,
        Bottom = 0,
        Left = 0,
        Right = 0
    }
end

--[[
    Gets the current viewport size
    
    @return Vector2 - Viewport dimensions
]]
function Device.GetViewportSize(): Vector2
    return workspace.CurrentCamera.ViewportSize
end

return Device