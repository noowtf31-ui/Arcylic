--[[
    AcrylicUI - Color Constants
    
    Default theme colors for the UI library.
    Supports dark mode with acrylic/glass aesthetics.
]]

local Colors = {
    -- Primary colors
    Background = Color3.fromRGB(12, 12, 12),
    Secondary = Color3.fromRGB(20, 20, 20),
    Border = Color3.fromRGB(39, 39, 39),
    
    -- Text colors
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(93, 93, 93),
    
    -- Accent color (customizable)
    Accent = Color3.fromRGB(255, 255, 255),
    
    -- Toggle specific colors
    Toggle = {
        Enabled = Color3.fromRGB(255, 255, 255),
        Disabled = Color3.fromRGB(32, 32, 32),
        Circle = Color3.fromRGB(20, 20, 20)
    },
    
    -- Notification specific colors
    Notification = {
        Background = Color3.fromRGB(11, 11, 11),
        Border = Color3.fromRGB(26, 26, 26),
        Timer = Color3.fromRGB(255, 255, 255)
    }
}

--[[
    Creates a custom theme by merging with default colors
    
    @param overrides table - Partial color overrides
    @return table - Complete theme colors
]]
function Colors.CreateTheme(overrides: { [string]: any }?): typeof(Colors)
    if not overrides then
        return Colors
    end
    
    local theme = table.clone(Colors)
    for key, value in pairs(overrides) do
        if type(value) == "table" and type(theme[key]) == "table" then
            theme[key] = table.clone(theme[key])
            for subKey, subValue in pairs(value) do
                theme[key][subKey] = subValue
            end
        else
            theme[key] = value
        end
    end
    
    return theme
end

return Colors