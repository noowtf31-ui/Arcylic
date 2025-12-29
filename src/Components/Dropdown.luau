--[[
    AcrylicUI - Dropdown Component
    
    A dropdown menu with single/multi-select support.
]]

local Create = require(script.Parent.Parent.Utils.Create)
local Tween = require(script.Parent.Parent.Utils.Tween)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Dropdown = {}
Dropdown.__index = Dropdown

export type DropdownConfig = {
    Name: string?,
    Options: { string }?,
    Default: string | { string }?,
    MultiSelect: boolean?,
    Callback: ((selected: string | { string }) -> ())?
}

export type DropdownObject = {
    SetValue: (self: DropdownObject, value: string | { string }) -> (),
    GetValue: (self: DropdownObject) -> string | { string },
    Refresh: (self: DropdownObject, options: { string }) -> (),
    Open: (self: DropdownObject) -> (),
    Close: (self: DropdownObject) -> (),
    Destroy: (self: DropdownObject) -> ()
}

--[[
    Creates a new dropdown component
    
    @param parent Instance - Parent container
    @param config DropdownConfig - Dropdown configuration
    @return DropdownObject - Dropdown control object
]]
function Dropdown.new(parent: Instance, config: DropdownConfig): DropdownObject
    local self = setmetatable({}, Dropdown)
    
    local name = config.Name or "Dropdown"
    self._options = config.Options or { "Option 1", "Option 2", "Option 3" }
    self._multiSelect = config.MultiSelect or false
    self._callback = config.Callback or function() end
    self._expanded = false
    
    -- Initialize selected value
    if self._multiSelect then
        self._selected = if type(config.Default) == "table" 
            then config.Default 
            else {}
    else
        self._selected = config.Default or self._options[1]
    end
    
    -- Main container
    self._frame = Create.Instance("Frame", {
        Name = "Dropdown_" .. name,
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, Sizes.Dropdown.Height),
        ClipsDescendants = false,
        ZIndex = 1,
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
        Position = UDim2.new(0, 10, 0, 10),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(0, 200, 0, 20),
        ZIndex = 1,
        Parent = self._frame
    })
    
    -- Selected display
    self._display = Create.Instance("Frame", {
        Name = "Display",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.04,
        Position = UDim2.new(1, -145, 0, 6),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 135, 0, 26),
        ZIndex = 2,
        Parent = self._frame
    })
    
    Create.Corner(self._display, Sizes.Corner.Medium)
    Create.Stroke(self._display)
    
    -- Selected label
    self._selectedLabel = Create.Instance("TextLabel", {
        Name = "SelectedLabel",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = self:_GetDisplayText(),
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        TextSize = Fonts.Size.Small,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
        Parent = self._display
    })
    
    -- Arrow indicator
    self._arrow = Create.Instance("ImageLabel", {
        Name = "Arrow",
        Image = "rbxassetid://105558791071013",
        ImageColor3 = Colors.TextDark,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 0.5, -5),
        Size = UDim2.new(0, 10, 0, 10),
        Rotation = 0,
        ZIndex = 2,
        Parent = self._display
    })
    
    -- Create options container
    self:_CreateOptionsContainer()
    
    -- Toggle button
    local toggleBtn = Create.Instance("TextButton", {
        Name = "ToggleButton",
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 3,
        Parent = self._display
    })
    
    toggleBtn.MouseButton1Click:Connect(function()
        if self._expanded then
            self:Close()
        else
            self:Open()
        end
    end)
    
    return self
end

function Dropdown:_GetDisplayText(): string
    if self._multiSelect then
        if #self._selected == 0 then
            return "None"
        end
        return table.concat(self._selected, ", ")
    end
    return tostring(self._selected)
end

function Dropdown:_CreateOptionsContainer()
    local maxVisible = Sizes.Dropdown.MaxVisibleOptions
    local totalHeight = math.min(
        #self._options * Sizes.Dropdown.OptionHeight,
        maxVisible * Sizes.Dropdown.OptionHeight
    )
    
    self._optionsContainer = Create.Instance("Frame", {
        Name = "OptionsContainer",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.04,
        Position = UDim2.new(1, -145, 0, 38),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 135, 0, totalHeight),
        Visible = false,
        ZIndex = 100,
        ClipsDescendants = true,
        Parent = self._frame
    })
    
    Create.Corner(self._optionsContainer, Sizes.Corner.Medium)
    Create.Stroke(self._optionsContainer)
    
    self._optionsScroll = Create.Instance("ScrollingFrame", {
        Name = "Scroll",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, #self._options * Sizes.Dropdown.OptionHeight),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
        ZIndex = 100,
        Parent = self._optionsContainer
    })
    
    Create.ListLayout(self._optionsScroll, 0)
    
    self:_PopulateOptions()
end

function Dropdown:_PopulateOptions()
    for _, child in ipairs(self._optionsScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, option in ipairs(self._options) do
        local optionBtn = Create.Instance("TextButton", {
            Name = option,
            FontFace = Fonts.Regular,
            TextColor3 = Colors.Text,
            Text = option,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextSize = Fonts.Size.Small,
            Size = UDim2.new(1, 0, 0, Sizes.Dropdown.OptionHeight),
            ZIndex = 100,
            Parent = self._optionsScroll
        })
        
        optionBtn.MouseEnter:Connect(function()
            Tween.Create(optionBtn, { BackgroundTransparency = 0.5 }, "Fast")
        end)
        
        optionBtn.MouseLeave:Connect(function()
            Tween.Create(optionBtn, { BackgroundTransparency = 1 }, "Fast")
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            if self._multiSelect then
                local index = table.find(self._selected, option)
                if index then
                    table.remove(self._selected, index)
                else
                    table.insert(self._selected, option)
                end
                self:_UpdateDisplay()
                self._callback(self._selected)
            else
                self._selected = option
                self:_UpdateDisplay()
                self._callback(self._selected)
                self:Close()
            end
        end)
    end
end

function Dropdown:_UpdateDisplay()
    self._selectedLabel.Text = self:_GetDisplayText()
end

function Dropdown:Open()
    self._expanded = true
    self._optionsContainer.Visible = true
    Tween.Create(self._arrow, { Rotation = 180 }, "Normal")
    self._frame.ZIndex = 10
end

function Dropdown:Close()
    self._expanded = false
    self._optionsContainer.Visible = false
    Tween.Create(self._arrow, { Rotation = 0 }, "Normal")
    self._frame.ZIndex = 1
end

function Dropdown:SetValue(value: string | { string })
    if self._multiSelect and type(value) == "table" then
        self._selected = value
    elseif not self._multiSelect then
        self._selected = value
    end
    self:_UpdateDisplay()
    self._callback(self._selected)
end

function Dropdown:GetValue(): string | { string }
    return self._selected
end

function Dropdown:Refresh(options: { string })
    self._options = options
    self._optionsScroll.CanvasSize = UDim2.new(
        0, 0, 0, 
        #options * Sizes.Dropdown.OptionHeight
    )
    
    local maxVisible = Sizes.Dropdown.MaxVisibleOptions
    local totalHeight = math.min(
        #options * Sizes.Dropdown.OptionHeight,
        maxVisible * Sizes.Dropdown.OptionHeight
    )
    self._optionsContainer.Size = UDim2.new(0, 135, 0, totalHeight)
    
    self:_PopulateOptions()
end

function Dropdown:Destroy()
    self._frame:Destroy()
end

return Dropdown