# AcrylicUI

## Highlights
- **Window/Section/Tab** layout with draggable, resizable window
- **Components**: Button, Toggle, Slider, Dropdown, Keybind, ColorPicker, Paragraph
- **Acrylic blur** backdrop and **Notification** system
- **Configurable** theme, sizes, fonts, and animation speeds
- **Mobile-friendly** toggle button

## Installation
Drop the `src` folder into your Roblox project (e.g. ReplicatedStorage as `AcrylicUI`). Require `init.luau` as the entry.

```
local AcrylicUI = require(path.to.src)
```

## Quick Start
```
local AcrylicUI = require(path.to.src)

local window = AcrylicUI.CreateWindow({
    Title = "My Hub",
    ToggleKey = Enum.KeyCode.RightControl,
})

local section = window:CreateSection("Combat")
local tab = section:CreateTab("Aimbot", "rbxassetid://10723407389")

local aimbotEnabled = false

tab:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(enabled)
        aimbotEnabled = enabled
        window:Notify({ Title = enabled and "Aimbot Enabled" or "Aimbot Disabled", Duration = 2 })
    end,
})

tab:CreateSlider({ Name = "Aim Speed", Min = 1, Max = 100, Default = 50 })

tab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Closest","Lowest HP","Highest Threat","Random"},
    Default = "Closest",
})

tab:CreateKeybind({ Name = "Fly Toggle", Default = Enum.KeyCode.F, Callback = function() end })

tab:CreateColorPicker({ Name = "Accent", Default = Color3.fromRGB(255,255,255) })
```

## API
- **AcrylicUI.CreateWindow(config)** → Window
- **Window:CreateSection(name)** → Section
- **Section:CreateTab(name, icon?)** → Tab
- **Tab:CreateButton/Toggle/Slider/Dropdown/Keybind/ColorPicker/Paragraph** → Component
- **Window:Notify(config)** → Notification

## Theming
```
local theme = AcrylicUI.CreateTheme({ Accent = Color3.fromRGB(138,43,226) })
AcrylicUI.Colors = theme
```

## Repo Structure
- `src/` entry: `init.luau`
- `src/Core`: `Window`, `AcrylicBlur`, `Notification`
- `src/Components`: UI components
- `src/Constants`: Colors, Sizes, Fonts, Animation
- `src/Utils`: Create, Tween, Draggable, Device, Services
- `functions/minimize.luau`: helper for minimize toggle

## License
MIT — see LICENSE.
