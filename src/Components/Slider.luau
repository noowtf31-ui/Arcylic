--[[
    AcrylicUI - Slider Component
    
    A draggable slider for numeric value selection.
]]

local UserInputService = game:GetService("UserInputService")

local Create = require(script.Parent.Parent.Utils.Create)
local Tween = require(script.Parent.Parent.Utils.Tween)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Slider = {}
Slider.__index = Slider

export type SliderConfig = {
    Name: string?,
    Min: number?,
    Max: number?,
    Default: number?,
    Increment: number?,
    Callback: ((value: number) -> ())?
}

export type SliderObject = {
    SetValue: (self: SliderObject, value: number) -> (),
    GetValue: (self: SliderObject) -> number,
    SetMin: (self: SliderObject, min: number) -> (),
    SetMax: (self: SliderObject, max: number) -> (),
    Destroy: (self: SliderObject) -> ()
}

--[[
    Creates a new slider component
    
    @param parent Instance - Parent container
    @param config SliderConfig - Slider configuration
    @return SliderObject - Slider control object
]]
function Slider.new(parent: Instance, config: SliderConfig): SliderObject
    local self = setmetatable({}, Slider)
    
    local name = config.Name or "Slider"
    self._min = config.Min or 0
    self._max = config.Max or 100
    self._value = config.Default or 50
    self._increment = config.Increment or 1
    self._callback = config.Callback or function() end
    self._dragging = false
    
    -- Main container
    self._frame = Create.Instance("Frame", {
        Name = "Slider_" .. name,
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, Sizes.Slider.Height),
        Parent = parent
    })
    
    Create.Corner(self._frame, Sizes.Corner.Medium)
    Create.Stroke(self._frame)
    
    -- Label
    Create.Instance("TextLabel", {
        Name = "Label",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(0, 200, 0, 20),
        Parent = self._frame
    })
    
    -- Value display
    self._valueLabel = Create.Instance("TextLabel", {
        Name = "Value",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = tostring(self._value),
        TextXAlignment = Enum.TextXAlignment.Right,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 5),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(0, 50, 0, 20),
        Parent = self._frame
    })
    
    -- Track background
    self._track = Create.Instance("Frame", {
        Name = "Track",
        BackgroundColor3 = Color3.fromRGB(11, 11, 11),
        Position = UDim2.new(0, 10, 0, 29),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, Sizes.Slider.TrackHeight),
        Parent = self._frame
    })
    
    Create.Corner(self._track, Sizes.Corner.Full)
    
    -- Fill bar
    local initialFill = (self._value - self._min) / (self._max - self._min)
    self._fill = Create.Instance("Frame", {
        Name = "Fill",
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(initialFill, 0, 1, 0),
        Parent = self._track
    })
    
    Create.Corner(self._fill, Sizes.Corner.Full)
    
    -- Input handling
    self._track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = true
            self:_UpdateFromInput(input)
        end
    end)
    
    self._track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = false
        end
    end)
    
    self._inputConnection = UserInputService.InputChanged:Connect(function(input)
        if self._dragging and 
           (input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch) then
            self:_UpdateFromInput(input)
        end
    end)
    
    return self
end

function Slider:_UpdateFromInput(input: InputObject)
    local pos = input.Position
    local trackPos = self._track.AbsolutePosition
    local trackSize = self._track.AbsoluteSize
    
    local relativeX = math.clamp((pos.X - trackPos.X) / trackSize.X, 0, 1)
    local rawValue = self._min + (self._max - self._min) * relativeX
    
    -- Apply increment
    self._value = math.floor(rawValue / self._increment + 0.5) * self._increment
    self._value = math.clamp(self._value, self._min, self._max)
    
    self:_UpdateVisual()
    self._callback(self._value)
end

function Slider:_UpdateVisual()
    local fillRatio = (self._value - self._min) / (self._max - self._min)
    Tween.Create(self._fill, { Size = UDim2.new(fillRatio, 0, 1, 0) }, "Instant")
    self._valueLabel.Text = tostring(self._value)
end

function Slider:SetValue(value: number)
    self._value = math.clamp(value, self._min, self._max)
    self:_UpdateVisual()
    self._callback(self._value)
end

function Slider:GetValue(): number
    return self._value
end

function Slider:SetMin(min: number)
    self._min = min
    self._value = math.clamp(self._value, self._min, self._max)
    self:_UpdateVisual()
end

function Slider:SetMax(max: number)
    self._max = max
    self._value = math.clamp(self._value, self._min, self._max)
    self:_UpdateVisual()
end

function Slider:Destroy()
    if self._inputConnection then
        self._inputConnection:Disconnect()
    end
    self._frame:Destroy()
end

return Slider