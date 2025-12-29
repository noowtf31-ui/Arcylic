--[[
    Acrylic UI Library
    Theme Configuration - Color schemes and styling
    
    @author Acrylic Team
    @version 2.0.0
    @license MIT
]]

export type ThemeColors = {
    Background: Color3,
    Secondary: Color3,
    Border: Color3,
    Text: Color3,
    TextDark: Color3,
    Accent: Color3,
    Toggle: {
        Enabled: Color3,
        Disabled: Color3,
        Circle: Color3
    },
    Notification: {
        Background: Color3,
        Border: Color3,
        Timer: Color3
    }
}

local Theme = {}

--- Default dark theme colors
Theme.Colors: ThemeColors = {
    Background = Color3.fromRGB(12, 12, 12),
    Secondary = Color3.fromRGB(20, 20, 20),
    Border = Color3.fromRGB(39, 39, 39),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(93, 93, 93),
    Accent = Color3.fromRGB(255, 255, 255),
    Toggle = {
        Enabled = Color3.fromRGB(255, 255, 255),
        Disabled = Color3.fromRGB(32, 32, 32),
        Circle = Color3.fromRGB(20, 20, 20)
    },
    Notification = {
        Background = Color3.fromRGB(11, 11, 11),
        Border = Color3.fromRGB(26, 26, 26),
        Timer = Color3.fromRGB(255, 255, 255)
    }
}

--- Font configurations
Theme.Fonts = {
    Regular = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
    Bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
}

--- Text size presets
Theme.TextSize = {
    Title = 14,
    Normal = 14,
    Small = 13,
    Tiny = 11
}

--[=[
    Updates the theme colors
    
    @param newColors Partial<ThemeColors> -- Colors to override
]=]
function Theme:SetColors(newColors: {[string]: any})S
    for key, value in pairs(newColors) do
        if type(value) == "table" then
            for subKey, subValue in pairs(value) do
                self.Colors[key][subKey] = subValue
            end
        else
            self.Colors[key] = value
        end
    end
end

--[=[
    Sets the accent color
    
    @param color Color3 -- The new accent color
]=]
function Theme:SetAccent(color: Color3)
    self.Colors.Accent = color
end

return Theme