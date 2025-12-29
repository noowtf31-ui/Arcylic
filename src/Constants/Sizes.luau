--[[
    AcrylicUI - Size Constants
    
    Dimension constants for UI components.
    All values are in pixels unless otherwise specified.
]]

local Sizes = {
    -- Window dimensions
    Window = {
        Width = 690,
        Height = 446
    },
    
    -- Minimum window size (for resizing)
    MinWindow = {
        Width = 500,
        Height = 300
    },
    
    -- Maximum window size (for resizing)
    MaxWindow = {
        Width = 1200,
        Height = 800
    },
    
    -- Toggle switch dimensions
    Toggle = {
        Width = 38,
        Height = 21,
        Circle = 13
    },
    
    -- Button dimensions
    Button = {
        Height = 39
    },
    
    -- Slider dimensions
    Slider = {
        Height = 46,
        TrackHeight = 7
    },
    
    -- Dropdown dimensions
    Dropdown = {
        Height = 39,
        OptionHeight = 30,
        MaxVisibleOptions = 5
    },
    
    -- Tab dimensions
    Tab = {
        Width = 135,
        Height = 35
    },
    
    -- Color picker dimensions
    ColorPicker = {
        Width = 160,
        Height = 115
    },
    
    -- Notification dimensions
    Notification = {
        Width = 220,
        Height = 70
    },
    
    -- Corner radius values
    Corner = {
        Small = 4,
        Medium = 5,
        Large = 6,
        Full = 100
    },
    
    -- Padding values
    Padding = {
        Small = 5,
        Medium = 10,
        Large = 15
    }
}

return Sizes