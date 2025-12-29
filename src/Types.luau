--[[
    AcrylicUI - Type Definitions
    Version: 2.0.0
    Author: AcrylicUI Team
    
    Type definitions for strict type checking across the library.
]]

export type Color3 = Color3
export type UDim2 = UDim2
export type Instance = Instance

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

export type WindowConfig = {
    Title: string?,
    Size: { Width: number, Height: number }?,
    Position: UDim2?,
    Theme: ThemeColors?
}

export type ButtonConfig = {
    Name: string?,
    Callback: (() -> ())?
}

export type ToggleConfig = {
    Name: string?,
    Default: boolean?,
    Callback: ((enabled: boolean) -> ())?
}

export type SliderConfig = {
    Name: string?,
    Min: number?,
    Max: number?,
    Default: number?,
    Callback: ((value: number) -> ())?
}

export type DropdownConfig = {
    Name: string?,
    Options: { string }?,
    Default: string?,
    MultiSelect: boolean?,
    Callback: ((selected: string | { string }) -> ())?
}

export type KeybindConfig = {
    Name: string?,
    Default: Enum.KeyCode?,
    Callback: (() -> ())?
}

export type ColorPickerConfig = {
    Name: string?,
    Default: Color3?,
    Callback: ((color: Color3) -> ())?
}

export type ParagraphConfig = {
    Title: string?,
    Content: string?
}

export type NotificationConfig = {
    Title: string?,
    Description: string?,
    Duration: number?,
    Icon: string?
}

export type Connection = RBXScriptConnection

return nil