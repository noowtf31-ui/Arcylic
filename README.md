# AcrylicUI
A modern, feature-rich Roblox UI library with acrylic blur effects, smooth animations, and comprehensive functionality.

## Highlights
-  **Modern Design** - Acrylic blur backdrop with smooth animations
-  **Mobile Support** - Built-in draggable mobile toggle button for touch devices
-  **Drag & Resize** - Fully draggable window with smart resizing
-  **Notifications** - Beautiful notification system with icons and timers
-  **Components** - Button, Toggle, Slider, Dropdown, Keybind, ColorPicker, TextBox, Paragraph
-  **Customizable** - Theme colors, sizes, fonts, and animation speeds
-  **Keybind System** - Custom keybinds with listener support
-  **Sections & Tabs** - Organized layout with collapsible sections
-  **Config System** - Save, load, and manage configuration profiles with auto-save support

## Installation

### Method 1: Loadstring (Recommended)
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/noowtf31-ui/Arcylic/refs/heads/main/src.lua.txt"))()
```

### Method 2: Local Module
Drop the library file into your Roblox project (e.g. ReplicatedStorage) and require it:
```lua
local Library = require(game.ReplicatedStorage.AcrylicUI)
```

## Quick Start

```lua
-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/noowtf31-ui/Arcylic/refs/heads/main/src.lua.txt"))()

-- Create the main window
local window = Library.new("My Hub", "MyHubConfigs")

-- Set toggle key (optional, default is RightControl)
window:SetToggleKey(Enum.KeyCode.RightControl)

-- Show welcome notification
window:Notify({
    Title = "Welcome!",
    Description = "Hub loaded successfully",
    Duration = 3,
    Icon = "rbxassetid://10709775704"
})

-- Create sections
local CombatSection = window:CreateSection("Combat")
local PlayerSection = window:CreateSection("Player")

-- Create tabs within sections
local AimbotTab = CombatSection:CreateTab("Aimbot", "rbxassetid://10723407389")
local MovementTab = PlayerSection:CreateTab("Movement", "rbxassetid://10734898355")

-- Add section headers
AimbotTab:CreateSection("Aimbot Settings")

-- Add components with config flags
local aimbotEnabled = false
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Flag = "AimbotEnabled", -- Used for config saving
    Callback = function(enabled)
        aimbotEnabled = enabled
        window:Notify({
            Title = enabled and "Aimbot Enabled" or "Aimbot Disabled",
            Description = enabled and "Auto-aim active" or "Auto-aim deactivated",
            Duration = 2
        })
    end
})

AimbotTab:CreateSlider({
    Name = "Aim Speed",
    Min = 1,
    Max = 100,
    Default = 50,
    Flag = "AimSpeed",
    Callback = function(value)
        print("Aim speed:", value)
    end
})

AimbotTab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Closest", "Lowest HP", "Highest Threat", "Random"},
    Default = "Closest",
    Flag = "TargetPriority",
    Callback = function(selected)
        print("Target priority:", selected)
    end
})
```

## API Reference

### Library

#### `Library.new(title, configFolder)`
Creates a new window instance.

```lua
local window = Library.new("My Hub", "MyHubConfigs")
```

**Parameters:**
- `title` (string): The window title
- `configFolder` (string, optional): Name for config folder (defaults to title)

**Returns:** Window object

---

### Window Methods

#### `window:SetToggleKey(keyCode)`
Sets the keybind to toggle UI visibility.

```lua
window:SetToggleKey(Enum.KeyCode.RightControl)
```

**Parameters:**
- `keyCode` (KeyCode): The key to toggle the UI

---

#### `window:Toggle()`
Manually toggles the UI visibility.

```lua
window:Toggle()
```

---

#### `window:Notify(config)`
Shows a notification.

```lua
window:Notify({
    Title = "Notification Title",
    Description = "Notification description text",
    Duration = 3,
    Icon = "rbxassetid://10709775704" -- optional
})
```

**Parameters:**
- `Title` (string): Notification title
- `Description` (string): Notification description
- `Duration` (number): Duration in seconds (default: 3)
- `Icon` (string): Optional asset ID for icon

---

#### `window:CreateSection(name)`
Creates a collapsible section in the sidebar.

```lua
local section = window:CreateSection("Combat")
```

**Parameters:**
- `name` (string): Section name

**Returns:** Section object

---

#### `window:Destroy()`
Destroys the UI and cleans up all connections. Auto-saves config if auto-save is enabled.

```lua
window:Destroy()
```

---

### Config System Methods

#### `window:SaveConfig(configName)`
Saves the current settings to a config file.

```lua
window:SaveConfig("MyConfig")
```

**Parameters:**
- `configName` (string): Name of the config file

**Returns:** Boolean (success)

---

#### `window:LoadConfig(configName)`
Loads settings from a config file.

```lua
window:LoadConfig("MyConfig")
```

**Parameters:**
- `configName` (string): Name of the config to load

**Returns:** Boolean (success)

---

#### `window:DeleteConfig(configName)`
Deletes a config file.

```lua
window:DeleteConfig("MyConfig")
```

**Parameters:**
- `configName` (string): Name of the config to delete

**Returns:** Boolean (success)

---

#### `window:GetConfigs()`
Returns a list of available config names.

```lua
local configs = window:GetConfigs()
for _, name in ipairs(configs) do
    print(name)
end
```

**Returns:** Table of config names

---

#### `window:SetAutoSave(enabled)`
Enables or disables auto-save (saves every 30 seconds).

```lua
window:SetAutoSave(true)
```

**Parameters:**
- `enabled` (boolean): Enable or disable auto-save

---

### Section Methods

#### `section:CreateTab(name, icon)`
Creates a tab within the section.

```lua
local tab = section:CreateTab("Aimbot", "rbxassetid://10723407389")
```

**Parameters:**
- `name` (string): Tab name
- `icon` (string, optional): Asset ID for tab icon

**Returns:** Tab object

---

### Tab Methods

#### `tab:CreateSection(name)`
Creates a section header/divider within the tab content.

```lua
tab:CreateSection("Settings")
```

**Parameters:**
- `name` (string): Section header text

---

#### `tab:CreateToggle(config)`
Creates a toggle switch.

```lua
local toggle = tab:CreateToggle({
    Name = "Enable Feature",
    Default = false,
    Flag = "FeatureEnabled", -- Optional: for config saving
    Callback = function(enabled)
        print("Toggle:", enabled)
    end
})
```

**Config:**
- `Name` (string): Toggle name
- `Default` (boolean): Initial state (default: false)
- `Flag` (string, optional): Unique identifier for config system
- `Callback` (function): Function called when toggled

**Methods:**
- `toggle:SetValue(value)` - Set toggle state
- `toggle:GetValue()` - Get current state

---

#### `tab:CreateSlider(config)`
Creates a slider.

```lua
local slider = tab:CreateSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "SpeedValue",
    Callback = function(value)
        print("Slider value:", value)
    end
})
```

**Config:**
- `Name` (string): Slider name
- `Min` (number): Minimum value
- `Max` (number): Maximum value
- `Default` (number): Initial value
- `Flag` (string, optional): Unique identifier for config system
- `Callback` (function): Function called when value changes

**Methods:**
- `slider:SetValue(value)` - Set slider value
- `slider:GetValue()` - Get current value

---

#### `tab:CreateDropdown(config)`
Creates a dropdown menu.

```lua
local dropdown = tab:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    MultiSelect = false,
    Flag = "SelectedOption",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

**Config:**
- `Name` (string): Dropdown name
- `Options` (table): Array of option strings
- `Default` (string or table): Initial selection
- `MultiSelect` (boolean, optional): Allow multiple selections (default: false)
- `Flag` (string, optional): Unique identifier for config system
- `Callback` (function): Function called when selection changes

**Methods:**
- `dropdown:SetValue(value)` - Set selected value(s)
- `dropdown:GetValue()` - Get current selection
- `dropdown:Refresh(newOptions)` - Update dropdown options

---

#### `tab:CreateKeybind(config)`
Creates a keybind selector.

```lua
local keybind = tab:CreateKeybind({
    Name = "Fly Toggle",
    Default = Enum.KeyCode.F,
    Flag = "FlyKeybind",
    Callback = function()
        print("Keybind pressed!")
    end
})
```

**Config:**
- `Name` (string): Keybind name
- `Default` (KeyCode): Initial key
- `Flag` (string, optional): Unique identifier for config system
- `Callback` (function): Function called when key is pressed

**Methods:**
- `keybind:SetKey(keyCode)` - Set keybind
- `keybind:GetKey()` - Get current key

---

#### `tab:CreateColorPicker(config)`
Creates a color picker.

```lua
local colorPicker = tab:CreateColorPicker({
    Name = "Team Color",
    Default = Color3.fromRGB(255, 255, 255),
    Flag = "TeamColor",
    Callback = function(color)
        print("Color:", color)
    end
})
```

**Config:**
- `Name` (string): Color picker name
- `Default` (Color3): Initial color
- `Flag` (string, optional): Unique identifier for config system
- `Callback` (function): Function called when color changes

**Methods:**
- `colorPicker:SetColor(color)` - Set color
- `colorPicker:GetColor()` - Get current color

---

#### `tab:CreateButton(config)`
Creates a button.

```lua
local button = tab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

**Config:**
- `Name` (string): Button text
- `Callback` (function): Function called when clicked

**Methods:**
- `button:SetText(text)` - Change button text

---

#### `tab:CreateTextBox(config)`
Creates a text input box.

```lua
local textBox = tab:CreateTextBox({
    Name = "Player Name",
    Default = "",
    Placeholder = "Enter name...",
    ClearOnFocus = false,
    NumbersOnly = false,
    Flag = "PlayerName",
    Callback = function(text, enterPressed)
        print("Text:", text, "Enter pressed:", enterPressed)
    end
})
```

**Config:**
- `Name` (string): TextBox label
- `Default` (string): Initial text value
- `Placeholder` (string): Placeholder text when empty
- `ClearOnFocus` (boolean, optional): Clear text when focused (default: false)
- `NumbersOnly` (boolean, optional): Only allow numeric input (default: false)
- `Flag` (string, optional): Unique identifier for config system
- `Callback` (function): Function called when focus is lost (receives text and enterPressed boolean)

**Methods:**
- `textBox:SetText(text)` - Set the text value
- `textBox:GetText()` - Get current text
- `textBox:SetPlaceholder(placeholder)` - Update placeholder text
- `textBox:Focus()` - Focus the text box

---

#### `tab:CreateParagraph(config)`
Creates an informational text block.

```lua
local paragraph = tab:CreateParagraph({
    Title = "Information",
    Content = "This is some informational text that explains features or provides details."
})
```

**Config:**
- `Title` (string): Paragraph title
- `Content` (string): Paragraph content text

**Methods:**
- `paragraph:SetTitle(title)` - Update title
- `paragraph:SetContent(content)` - Update content

---

#### `tab:CreateConfigSection()`
Creates a pre-built configuration management UI with save, load, delete, and auto-save functionality.

```lua
local configSection = tab:CreateConfigSection()
```

**Returns:** Object with `RefreshConfigs()` method

This creates:
- Config name input box
- Config selector dropdown
- Save, Load, Delete, and Refresh buttons
- Auto-save toggle

---

## Complete Example

```lua
-- Load library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/noowtf31-ui/Arcylic/refs/heads/main/src.lua.txt"))()

-- Create window with config folder
local window = Library.new("Example Hub", "ExampleHubConfigs")
window:SetToggleKey(Enum.KeyCode.RightControl)

-- Welcome notification
window:Notify({
    Title = "Welcome!",
    Description = "Hub loaded successfully",
    Duration = 3,
    Icon = "rbxassetid://10709775704"
})

-- Create sections
local CombatSection = window:CreateSection("Combat")
local PlayerSection = window:CreateSection("Player")
local MiscSection = window:CreateSection("Miscellaneous")
local SettingsSection = window:CreateSection("Settings")

-- Combat Tab
local AimbotTab = CombatSection:CreateTab("Aimbot", "rbxassetid://10723407389")

AimbotTab:CreateSection("Main Settings")

local aimbotEnabled = false
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Flag = "AimbotEnabled",
    Callback = function(enabled)
        aimbotEnabled = enabled
        window:Notify({
            Title = enabled and "Enabled" or "Disabled",
            Description = "Aimbot " .. (enabled and "activated" or "deactivated"),
            Duration = 2
        })
    end
})

AimbotTab:CreateSlider({
    Name = "Aim Speed",
    Min = 1,
    Max = 100,
    Default = 50,
    Flag = "AimSpeed",
    Callback = function(value)
        print("Aim speed set to:", value)
    end
})

AimbotTab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Closest", "Lowest HP", "Highest Threat"},
    Default = "Closest",
    Flag = "TargetPriority",
    Callback = function(selected)
        print("Priority:", selected)
    end
})

AimbotTab:CreateColorPicker({
    Name = "Aim FOV Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "AimFOVColor",
    Callback = function(color)
        print("FOV Color:", color)
    end
})

-- Player Tab
local MovementTab = PlayerSection:CreateTab("Movement", "rbxassetid://10734898355")

MovementTab:CreateSection("Speed Settings")

MovementTab:CreateToggle({
    Name = "Speed Boost",
    Default = false,
    Flag = "SpeedBoost",
    Callback = function(enabled)
        print("Speed boost:", enabled)
    end
})

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

MovementTab:CreateKeybind({
    Name = "Fly Toggle",
    Default = Enum.KeyCode.F,
    Flag = "FlyKeybind",
    Callback = function()
        window:Notify({
            Title = "Fly Mode",
            Description = "Flight toggled",
            Duration = 1.5
        })
    end
})

MovementTab:CreateSection("Teleport")

MovementTab:CreateTextBox({
    Name = "Player Name",
    Default = "",
    Placeholder = "Enter player name...",
    Flag = "TeleportTarget",
    Callback = function(text, enterPressed)
        if enterPressed and text ~= "" then
            print("Teleporting to:", text)
        end
    end
})

-- Misc Tab
local AutoTab = MiscSection:CreateTab("Automation", "rbxassetid://10734898355")

AutoTab:CreateSection("Auto Farm")

AutoTab:CreateButton({
    Name = "Start Auto Farm",
    Callback = function()
        window:Notify({
            Title = "Auto Farm",
            Description = "Started farming",
            Duration = 2
        })
    end
})

AutoTab:CreateTextBox({
    Name = "Farm Amount",
    Default = "100",
    Placeholder = "Enter amount...",
    NumbersOnly = true,
    Flag = "FarmAmount",
    Callback = function(text)
        print("Farm amount:", tonumber(text))
    end
})

AutoTab:CreateParagraph({
    Title = "About",
    Content = "This is an example hub showcasing all AcrylicUI components and features."
})

-- Settings Tab with Config System
local ConfigTab = SettingsSection:CreateTab("Config", "rbxassetid://10734898355")

-- This creates a full config management UI
ConfigTab:CreateConfigSection()

-- Or use individual config methods:
-- window:SaveConfig("MyConfig")
-- window:LoadConfig("MyConfig")
-- window:DeleteConfig("MyConfig")
-- window:SetAutoSave(true)
```

## Features

### Acrylic Blur Effect
The library automatically creates a beautiful acrylic blur effect behind the UI using depth of field and blur effects.

### Mobile Support
If touch input is detected, a draggable mobile toggle button appears automatically in the bottom-left corner. Tap to toggle, drag to reposition.

### Resizable Window
Click and drag the resize handle in the bottom-right corner to resize the window. Size is constrained between minimum and maximum values.

### Collapsible Sections
Click section headers in the sidebar to collapse/expand tabs within that section.

### Smart Color Picker
The color picker automatically positions itself to stay on screen and closes when you click elsewhere.

### Config System
The library includes a full configuration system that allows users to:
- **Save configs** - Save all flagged component values to a JSON file
- **Load configs** - Restore saved settings
- **Delete configs** - Remove unwanted configuration files
- **Auto-save** - Automatically save every 30 seconds
- **Multiple profiles** - Create and manage multiple configuration profiles

Config files are stored in `AcrylicConfigs/` folder.

#### Using the Config System

**Method 1: Pre-built Config UI**
```lua
local ConfigTab = SettingsSection:CreateTab("Config", "rbxassetid://10734898355")
ConfigTab:CreateConfigSection() -- Creates full config management UI
```

**Method 2: Manual Control**
```lua
-- Make sure to add Flag to components you want to save
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    Flag = "AimbotEnabled", -- This flag is used as the save key
    Callback = function(enabled) end
})

-- Save/Load manually
window:SaveConfig("MyProfile")
window:LoadConfig("MyProfile")

-- Enable auto-save
window:SetAutoSave(true)
```

## Customization

### Colors
```lua
-- Access color constants (read-only)
-- Colors are defined in the library source
```

### Sizes
Window sizes and component dimensions are pre-configured for optimal appearance.

### Animations
Animation speeds are tuned for smooth, modern feel:
- Fast: 0.1s
- Normal: 0.15s
- Slow: 0.2s
- Very Slow: 0.3s

## Icons

Common asset IDs used in examples:
- `rbxassetid://10709775704` - Checkmark/Success
- `rbxassetid://10747384394` - Warning/Error
- `rbxassetid://10723407389` - Target/Aim
- `rbxassetid://10734898355` - Settings/Gear
- `rbxassetid://10734950309` - Teleport/Location
- `rbxassetid://10723356507` - Save/Config
- `rbxassetid://93828793199781` - Text/Input
- `rbxassetid://112235310154264` - Menu

## Tips

1. **Organize with Sections**: Use sections to group related tabs together
2. **Use Notifications Sparingly**: Don't spam notifications, they queue automatically
3. **Keybind Management**: The library handles keybind conflicts automatically
4. **Component Methods**: Store component references to use SetValue/GetValue methods
5. **Mobile Testing**: Test on mobile devices to ensure touch interactions work properly
6. **Use Flags**: Always add `Flag` to components you want to save in configs
7. **Unique Flags**: Ensure each Flag is unique across all components
8. **Config Folder**: Use a unique `configFolder` name to avoid conflicts with other scripts

## Executor Requirements

For the config system to work, your executor must support:
- `writefile(path, content)` - Write files
- `readfile(path)` - Read files
- `isfile(path)` - Check if file exists
- `makefolder(path)` - Create folders
- `isfolder(path)` - Check if folder exists
- `listfiles(path)` - List files in folder
- `delfile(path)` - Delete files

Most modern executors (Synapse X, Script-Ware, Fluxus, etc.) support these functions.

## License
MIT License - Feel free to use and modify for your projects.

## Credits
v0rtexd
