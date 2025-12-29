--[[
    AcrylicUI - Button Component
    
    A clickable button with hover effects and icon support.
]]

local Create = require(script.Parent.Parent.Utils.Create)
local Tween = require(script.Parent.Parent.Utils.Tween)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Button = {}
Button.__index = Button

export type ButtonConfig = {
    Name: string?,
    Icon: string?,
    Callback: (() -> ())?
}

export type ButtonObject = {
    SetText: (self: ButtonObject, text: string) -> (),
    SetIcon: (self: ButtonObject, icon: string) -> (),
    SetCallback: (self: ButtonObject, callback: () -> ()) -> (),
    Destroy: (self: ButtonObject) -> ()
}

--[[
    Creates a new button component
    
    @param parent Instance - Parent container
    @param config ButtonConfig - Button configuration
    @return ButtonObject - Button control object
    
    @example
    local button = Button.new(container, {
        Name = "Execute",
        Icon = "rbxassetid://10734898355",
        Callback = function()
            print("Button clicked!")
        end
    })
]]
function Button.new(parent: Instance, config: ButtonConfig): ButtonObject
    local self = setmetatable({}, Button)
    
    local name = config.Name or "Button"
    local icon = config.Icon or "rbxassetid://10734898355"
    local callback = config.Callback or function() end
    
    -- Main container
    self._frame = Create.Instance("Frame", {
        Name = "Button_" .. name,
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, Sizes.Button.Height),
        Parent = parent
    })
    
    Create.Corner(self._frame, Sizes.Corner.Medium)
    Create.Stroke(self._frame)
    
    -- Button label
    self._label = Create.Instance("TextLabel", {
        Name = "Label",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0.5, -10),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(1, -50, 0, 20),
        Parent = self._frame
    })
    
    -- Icon
    self._icon = Create.Instance("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = icon,
        ImageColor3 = Colors.Text,
        Position = UDim2.new(1, -30, 0.5, -10),
        Size = UDim2.new(0, 20, 0, 20),
        Parent = self._frame
    })
    
    Create.Instance("UIAspectRatioConstraint", {
        Parent = self._icon
    })
    
    -- Click button
    self._button = Create.Instance("TextButton", {
        Name = "ClickArea",
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self._frame
    })
    
    self._callback = callback
    
    -- Event handlers
    self._button.MouseButton1Click:Connect(function()
        -- Click animation
        Tween.Create(self._frame, { BackgroundTransparency = 0.2 }, "Fast")
        task.wait(0.1)
        Tween.Create(self._frame, { BackgroundTransparency = 0.4 }, "Fast")
        
        self._callback()
    end)
    
    self._button.MouseEnter:Connect(function()
        Tween.Create(self._frame, { BackgroundTransparency = 0.3 }, "Fast")
    end)
    
    self._button.MouseLeave:Connect(function()
        Tween.Create(self._frame, { BackgroundTransparency = 0.4 }, "Fast")
    end)
    
    return self
end

function Button:SetText(text: string)
    self._label.Text = text
end

function Button:SetIcon(icon: string)
    self._icon.Image = icon
end

function Button:SetCallback(callback: () -> ())
    self._callback = callback
end

function Button:Destroy()
    self._frame:Destroy()
end

return Button