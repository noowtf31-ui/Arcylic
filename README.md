# AcrylicUI
A modern, feature-rich Roblox UI library with acrylic blur effects, smooth animations, and comprehensive functionality.

## Highlights
-  **Modern Design** - Acrylic blur backdrop with smooth animations
-  **Mobile Support** - Built-in mobile toggle button for touch devices
-  **Drag & Resize** - Fully draggable window with smart resizing
-  **Notifications** - Beautiful notification system with icons and timers
-  **Components** - Button, Toggle, Slider, Dropdown, Keybind, ColorPicker, Paragraph
-  **Customizable** - Theme colors, sizes, fonts, and animation speeds
-  **Keybind System** - Custom keybinds with listener support
-  **Sections & Tabs** - Organized layout with collapsible sections

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
local window = Library.new("My Hub")

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

-- Add components
local aimbotEnabled = false
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
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
    Callback = function(value)
        print("Aim speed:", value)
    end
})

AimbotTab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Closest", "Lowest HP", "Highest Threat", "Random"},
    Default = "Closest",
    Callback = function(selected)
        print("Target priority:", selected)
    end
})
```

## API Reference

### Library

#### `Library.new(title)`
Creates a new window instance.

```lua
local window = Library.new("My Hub")
```

**Parameters:**
- `title` (string): The window title

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
Destroys the UI and cleans up all connections.

```lua
window:Destroy()
```

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
    Callback = function(enabled)
        print("Toggle:", enabled)
    end
})
```

**Config:**
- `Name` (string): Toggle name
- `Default` (boolean): Initial state (default: false)
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
    MultiSelect = false, -- optional
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
    Callback = function()
        print("Keybind pressed!")
    end
})
```

**Config:**
- `Name` (string): Keybind name
- `Default` (KeyCode): Initial key
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
    Callback = function(color)
        print("Color:", color)
    end
})
```

**Config:**
- `Name` (string): Color picker name
- `Default` (Color3): Initial color
- `Callback` (function): Function called when color changes

**Methods:**
- `colorPicker:SetColor(color)` - Set color

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

## Complete Example

```lua
-- Load library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/noowtf31-ui/Arcylic/refs/heads/main/src.lua.txt"))()

-- Create window
local window = Library.new("Example Hub")
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

-- Combat Tab
local AimbotTab = CombatSection:CreateTab("Aimbot", "rbxassetid://10723407389")

AimbotTab:CreateSection("Main Settings")

local aimbotEnabled = false
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
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
    Callback = function(value)
        print("Aim speed set to:", value)
    end
})

AimbotTab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Closest", "Lowest HP", "Highest Threat"},
    Default = "Closest",
    Callback = function(selected)
        print("Priority:", selected)
    end
})

-- Player Tab
local MovementTab = PlayerSection:CreateTab("Movement", "rbxassetid://10734898355")

MovementTab:CreateSection("Speed Settings")

MovementTab:CreateToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(enabled)
        print("Speed boost:", enabled)
    end
})

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

MovementTab:CreateKeybind({
    Name = "Fly Toggle",
    Default = Enum.KeyCode.F,
    Callback = function()
        window:Notify({
            Title = "Fly Mode",
            Description = "Flight toggled",
            Duration = 1.5
        })
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

AutoTab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("ESP color:", color)
    end
})

AutoTab:CreateParagraph({
    Title = "About",
    Content = "This is an example hub showcasing all AcrylicUI components and features."
})
```

## Features

### Acrylic Blur Effect
The library automatically creates a beautiful acrylic blur effect behind the UI using depth of field and blur effects.

### Mobile Support
If touch input is detected, a mobile toggle button appears automatically in the bottom-left corner.

### Resizable Window
Click and drag the resize handle in the bottom-right corner to resize the window. Size is constrained between minimum and maximum values.

### Collapsible Sections
Click section headers in the sidebar to collapse/expand tabs within that section.

### Smart Color Picker
The color picker automatically positions itself to stay on screen and closes when you click elsewhere.

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

## Tips

1. **Organize with Sections**: Use sections to group related tabs together
2. **Use Notifications Sparingly**: Don't spam notifications, they queue automatically
3. **Keybind Management**: The library handles keybind conflicts automatically
4. **Component Methods**: Store component references to use SetValue/GetValue methods
5. **Mobile Testing**: Test on mobile devices to ensure touch interactions work properly

## License
MIT License - Feel free to use and modify for your projects.

## Credits
Developed with modern design patterns and smooth user experience in mind.


