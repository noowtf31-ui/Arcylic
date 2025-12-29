local Create = require(script.Parent.Parent.Utils.Create)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local ColorPicker = {}
ColorPicker.__index = ColorPicker

-- Minimal color picker: preview + simple palette popup
local PRESETS = {
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 128, 255),
    Color3.fromRGB(255, 128, 0),
    Color3.fromRGB(255, 0, 255),
}

function ColorPicker.new(parent: Instance, config)
    local self = setmetatable({}, ColorPicker)
    local name = (config and config.Name) or "Color Picker"
    self._callback = (config and config.Callback) or function() end
    self._color = (config and config.Default) or PRESETS[1]

    self._frame = Create.Instance("Frame", {
        Name = "ColorPicker_" .. name,
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, Sizes.Button.Height),
        Parent = parent
    })

    Create.Corner(self._frame, Sizes.Corner.Medium)
    Create.Stroke(self._frame)

    Create.Instance("TextLabel", {
        Name = "Name",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(1, -50, 1, 0),
        Parent = self._frame
    })

    self._preview = Create.Instance("Frame", {
        Name = "Preview",
        BackgroundColor3 = self._color,
        Position = UDim2.new(1, -45, 0.5, -8),
        Size = UDim2.new(0, 35, 0, 16),
        Parent = self._frame
    })
    Create.Corner(self._preview, Sizes.Corner.Small)
    Create.Stroke(self._preview)

    local previewBtn = Create.Instance("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self._preview
    })

    -- Palette popup
    self._palette = Create.Instance("Frame", {
        Name = "Palette",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 160, 0, 52),
        Visible = false,
        ZIndex = 2000,
        Parent = parent
    })
    Create.Corner(self._palette, Sizes.Corner.Medium)
    Create.Stroke(self._palette)
    Create.Padding(self._palette, 8, 8, 8, 8)

    local grid = Create.Instance("UIGridLayout", {
        CellPadding = UDim2.new(0, 8, 0, 8),
        CellSize = UDim2.new(0, 24, 0, 24),
        Parent = self._palette
    })

    for _, col in ipairs(PRESETS) do
        local swatch = Create.Instance("TextButton", {
            BackgroundColor3 = col,
            Text = "",
            Size = UDim2.new(0, 24, 0, 24),
            Parent = self._palette
        })
        Create.Corner(swatch, Sizes.Corner.Small)
        Create.Stroke(swatch)
        swatch.MouseButton1Click:Connect(function()
            self:SetColor(col)
            self._palette.Visible = false
        end)
    end

    local function open()
        local p = self._preview.AbsolutePosition
        self._palette.Position = UDim2.new(0, p.X - 160 + 35, 0, p.Y + 22)
        self._palette.Visible = true
    end

    previewBtn.MouseButton1Click:Connect(function()
        self._palette.Visible = not self._palette.Visible
        if self._palette.Visible then open() end
    end)

    return self
end

function ColorPicker:SetColor(color: Color3)
    self._color = color
    self._preview.BackgroundColor3 = color
    self._callback(color)
end

function ColorPicker:GetColor(): Color3
    return self._color
end

function ColorPicker:Destroy()
    if self._palette then self._palette:Destroy() end
    self._frame:Destroy()
end

return ColorPicker
