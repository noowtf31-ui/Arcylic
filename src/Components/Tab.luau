local Create = require(script.Parent.Parent.Utils.Create)
local Tween = require(script.Parent.Parent.Utils.Tween)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Button = require(script.Parent.Button)
local Toggle = require(script.Parent.Toggle)
local Slider = require(script.Parent.Slider)
local Dropdown = require(script.Parent.Dropdown)

local Tab = {}
Tab.__index = Tab

function Tab.new(window, section, name: string, icon: string?)
    local self = setmetatable({}, Tab)
    self._window = window
    self._section = section
    self._name = name

    -- Button in sidebar
    self._button = Create.Instance("Frame", {
        Name = name,
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, Sizes.Tab.Width, 0, Sizes.Tab.Height),
        Parent = section._tabsContainer
    })

    Create.Corner(self._button, Sizes.Corner.Medium)
    self._stroke = Create.Stroke(self._button, Colors.Border, 1)

    self._icon = Create.Instance("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = icon or "rbxassetid://112235310154264",
        ImageColor3 = Colors.TextDark,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 11, 0.5, 0),
        Size = UDim2.new(0, 15, 0, 15),
        Parent = self._button
    })

    self._text = Create.Instance("TextLabel", {
        Name = "TabText",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.TextDark,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 33, 0, 0),
        Size = UDim2.new(1, -42, 1, 0),
        TextSize = Fonts.Size.Small,
        Parent = self._button
    })

    Create.Instance("UIPadding", { PaddingRight = UDim.new(0, 9), Parent = self._text })

    local click = Create.Instance("TextButton", {
        Name = "Click",
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self._button
    })

    -- Content frame
    self._content = Create.Instance("Frame", {
        Name = name .. "_Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = window:GetContentContainer()
    })

    Create.ListLayout(self._content, 8)

    click.MouseButton1Click:Connect(function()
        window:SelectTab(self)
    end)

    click.MouseEnter:Connect(function()
        if window._currentTab ~= self then
            Tween.Create(self._button, { BackgroundTransparency = 0.7 }, "Fast")
        end
    end)

    click.MouseLeave:Connect(function()
        if window._currentTab ~= self then
            Tween.Create(self._button, { BackgroundTransparency = 1 }, "Fast")
        end
    end)

    return self
end

function Tab:Select()
    self._content.Visible = true
    Tween.Create(self._button, { BackgroundTransparency = 0.4 }, "Fast")
    Tween.Create(self._text, { TextColor3 = Colors.Text }, "Fast")
    Tween.Create(self._icon, { ImageColor3 = Colors.Text }, "Fast")
    self._stroke.Transparency = 0
end

function Tab:Deselect()
    self._content.Visible = false
    Tween.Create(self._button, { BackgroundTransparency = 1 }, "Fast")
    Tween.Create(self._text, { TextColor3 = Colors.TextDark }, "Fast")
    Tween.Create(self._icon, { ImageColor3 = Colors.TextDark }, "Fast")
    self._stroke.Transparency = 1
end

-- Content helpers
function Tab:CreateSection(title: string)
    local label = Create.Instance("TextLabel", {
        Name = "Section" .. title,
        FontFace = Fonts.Regular,
        TextColor3 = Colors.TextDark,
        Text = title,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        TextSize = 15,
        Size = UDim2.new(1, 0, 0, 25),
        Parent = self._content
    })
    return label
end

function Tab:CreateParagraph(config)
    local Paragraph = require(script.Parent.Paragraph)
    return Paragraph.new(self._content, config)
end

function Tab:CreateButton(config)
    return Button.new(self._content, config)
end

function Tab:CreateToggle(config)
    return Toggle.new(self._content, config)
end

function Tab:CreateSlider(config)
    return Slider.new(self._content, config)
end

function Tab:CreateDropdown(config)
    return Dropdown.new(self._content, config)
end

function Tab:CreateKeybind(config)
    local Keybind = require(script.Parent.Keybind)
    return Keybind.new(self._content, config, self._window)
end

function Tab:CreateColorPicker(config)
    local ColorPicker = require(script.Parent.ColorPicker)
    return ColorPicker.new(self._content, config)
end

return Tab
