--[[
    AcrylicUI - Toggle Component
    
    A toggle switch with smooth animations.
]]

local Create = require(script.Parent.Parent.Utils.Create)
local Tween = require(script.Parent.Parent.Utils.Tween)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Toggle = {}
Toggle.__index = Toggle

export type ToggleConfig = {
    Name: string?,
    Default: boolean?,
    Callback: ((enabled: boolean) -> ())?
}

export type ToggleObject = {
    SetValue: (self: ToggleObject, value: boolean) -> (),
    GetValue: (self: ToggleObject) -> boolean,
    Destroy: (self: ToggleObject) -> ()
}

--[[
    Creates a new toggle component
    
    @param parent Instance - Parent container
    @param config ToggleConfig - Toggle configuration
    @return ToggleObject - Toggle control object
]]
function Toggle.new(parent: Instance, config: ToggleConfig): ToggleObject
    local self = setmetatable({}, Toggle)
    
    local name = config.Name or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    self._enabled = default
    self._callback = callback
    
    -- Main container
    self._frame = Create.Instance("Frame", {
        Name = "Toggle_" .. name,
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, Sizes.Button.Height),
        Parent = parent
    })
    
    Create.Corner(self._frame, Sizes.Corner.Medium)
    Create.Stroke(self._frame)
    
    -- Label
    self._label = Create.Instance("TextLabel", {
        Name = "Label",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0.5, -10),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(1, -60, 0, 20),
        Parent = self._frame
    })
    
    -- Switch background
    self._switchBg = Create.Instance("Frame", {
        Name = "SwitchBackground",
        BackgroundColor3 = self._enabled and Colors.Toggle.Enabled or Colors.Toggle.Disabled,
        Position = UDim2.new(1, -48, 0.5, -10),
        BorderSizePixel = 0,
        Size = UDim2.new(0, Sizes.Toggle.Width, 0, Sizes.Toggle.Height),
        Parent = self._frame
    })
    
    Create.Corner(self._switchBg, Sizes.Corner.Full)
    
    -- Switch circle
    self._circle = Create.Instance("Frame", {
        Name = "Circle",
        BackgroundColor3 = Colors.Toggle.Circle,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = self._enabled 
            and UDim2.new(0, 21, 0.5, 0) 
            or UDim2.new(0, 4, 0.5, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, Sizes.Toggle.Circle, 0, Sizes.Toggle.Circle),
        Parent = self._switchBg
    })
    
    Create.Corner(self._circle, Sizes.Corner.Full)
    
    -- Click area
    local button = Create.Instance("TextButton", {
        Name = "ClickArea",
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self._frame
    })
    
    button.MouseButton1Click:Connect(function()
        self:SetValue(not self._enabled)
    end)
    
    return self
end

function Toggle:_UpdateVisual()
    if self._enabled then
        Tween.Create(self._switchBg, { BackgroundColor3 = Colors.Toggle.Enabled }, "Normal")
        Tween.Create(self._circle, { Position = UDim2.new(0, 21, 0.5, 0) }, "Normal")
    else
        Tween.Create(self._switchBg, { BackgroundColor3 = Colors.Toggle.Disabled }, "Normal")
        Tween.Create(self._circle, { Position = UDim2.new(0, 4, 0.5, 0) }, "Normal")
    end
end

function Toggle:SetValue(value: boolean)
    self._enabled = value
    self:_UpdateVisual()
    self._callback(self._enabled)
end

function Toggle:GetValue(): boolean
    return self._enabled
end

function Toggle:Destroy()
    self._frame:Destroy()
end

return Toggle