--[[
    AcrylicUI - Window Component
    
    The main window container with dragging, resizing, and minimize support.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Create = require(script.Parent.Parent.Utils.Create)
local Tween = require(script.Parent.Parent.Utils.Tween)
local Draggable = require(script.Parent.Parent.Utils.Draggable)
local Device = require(script.Parent.Parent.Utils.Device)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)
local Animation = require(script.Parent.Parent.Constants.Animation)

local AcrylicBlur = require(script.Parent.AcrylicBlur)
local Notification = require(script.Parent.Notification)

local Window = {}
Window.__index = Window

export type WindowConfig = {
    Title: string?,
    Size: { Width: number, Height: number }?,
    ToggleKey: Enum.KeyCode?
}

--[[
    Creates a new window
    
    @param config WindowConfig - Window configuration
    @return Window - Window instance
    
    @example
    local window = Window.new({
        Title = "My Hub",
        Size = { Width = 700, Height = 450 },
        ToggleKey = Enum.KeyCode.RightControl
    })
]]
function Window.new(config: WindowConfig)
    local self = setmetatable({}, Window)
    
    self._title = config.Title or "AcrylicUI"
    self._size = config.Size or { 
        Width = Sizes.Window.Width, 
        Height = Sizes.Window.Height 
    }
    self._toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    self._visible = true
    self._minimized = false
    self._sections = {}
    self._keybinds = {}
    self._connections = {}
    self._currentTab = nil
    self._originalHeight = self._size.Height
    
    self:_CreateGui()
    self:_SetupKeybinds()
    
    if Device.IsMobile() then
        self:_SetupMobileToggle()
    end
    
    return self
end

function Window:_CreateGui()
    local player = Players.LocalPlayer
    
    -- Screen GUI
    self._screenGui = Create.Instance("ScreenGui", {
        Name = "AcrylicUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    -- Main container
    self._container = Create.Instance("Frame", {
        Name = "Container",
        BackgroundColor3 = Colors.Background,
        BackgroundTransparency = 0.05,
        Position = UDim2.new(
            0.5, -self._size.Width / 2,
            0.5, -self._size.Height / 2
        ),
        BorderSizePixel = 0,
        Size = UDim2.new(0, self._size.Width, 0, self._size.Height),
        ClipsDescendants = false,
        Parent = self._screenGui
    })
    
    Create.Corner(self._container, Sizes.Corner.Medium)
    Create.Stroke(self._container)
    
    -- Title
    self._titleLabel = Create.Instance("TextLabel", {
        Name = "Title",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = self._title,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = Fonts.Size.Title,
        Size = UDim2.new(0, 150, 0, 25),
        Parent = self._container
    })
    
    self:_CreateWindowControls()
    self:_CreateContentArea()
    
    -- Make draggable
    self._dragConnection = Draggable.Enable(self._container, self._titleLabel)
    
    -- Acrylic blur effect
    self._acrylicBlur = AcrylicBlur.new(self._container)
    
    -- Notification container
    Notification.CreateContainer(self._screenGui)
end

function Window:_CreateWindowControls()
    -- Minimize button
    local minimizeBtn = Create.Instance("ImageLabel", {
        Name = "Minimize",
        ImageColor3 = Colors.TextDark,
        Image = "rbxassetid://82603981310445",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -35, 0, 15),
        Size = UDim2.new(0, 15, 0, 15),
        Parent = self._container
    })
    
    local minimizeClick = Create.Instance("TextButton", {
        Name = "ClickArea",
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 21, 0, 15),
        Parent = minimizeBtn
    })
    
    minimizeClick.MouseButton1Click:Connect(function()
        self:_ToggleMinimize()
    end)
    
    minimizeBtn.MouseEnter:Connect(function()
        Tween.Create(minimizeBtn, { ImageColor3 = Colors.Text }, "Fast")
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        Tween.Create(minimizeBtn, { ImageColor3 = Colors.TextDark }, "Fast")
    end)
    
    -- Close button
    local closeBtn = Create.Instance("ImageButton", {
        Name = "Close",
        ImageColor3 = Colors.TextDark,
        Image = "rbxassetid://119943770201674",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 15),
        Size = UDim2.new(0, 15, 0, 15),
        Parent = self._container
    })
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Tween.Create(closeBtn, { ImageColor3 = Color3.fromRGB(255, 100, 100) }, "Fast")
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Tween.Create(closeBtn, { ImageColor3 = Colors.TextDark }, "Fast")
    end)
    
    -- Resize handle
    self._resizeBtn = Create.Instance("ImageButton", {
        Name = "Resize",
        ImageColor3 = Color3.fromRGB(110, 110, 110),
        Image = "rbxassetid://120997033468887",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -5, 1, -5),
        Size = UDim2.new(0, 62, 0, 60),
        BorderSizePixel = 0,
        Parent = self._container
    })
    
    self:_SetupResize()
end

function Window:_CreateContentArea()
    -- Header separator
    Create.Instance("Frame", {
        Name = "HeaderSeparator",
        BackgroundColor3 = Colors.Border,
        Position = UDim2.new(0, 0, 0, 45),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Parent = self._container
    })
    
    -- Main content area
    self._mainContent = Create.Instance("Frame", {
        Name = "MainContent",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 46),
        Size = UDim2.new(1, 0, 1, -46),
        ClipsDescendants = true,
        Parent = self._container
    })
    
    -- Sections sidebar
    self._sectionsContainer = Create.Instance("ScrollingFrame", {
        Name = "Sections",
        ScrollBarThickness = 0,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 165, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = self._mainContent
    })
    
    Create.ListLayout(self._sectionsContainer, 0)
    Create.Padding(self._sectionsContainer, 5, 5, 5, 5)
    
    -- Separator
    Create.Instance("Frame", {
        Name = "Separator",
        BackgroundColor3 = Colors.Border,
        Position = UDim2.new(0, 165, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 1, 1, 0),
        Parent = self._mainContent
    })
    
    -- Content area
    self._contentContainer = Create.Instance("ScrollingFrame", {
        Name = "Content",
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 166, 0, 0),
        Size = UDim2.new(1, -166, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = self._mainContent
    })
    
    Create.ListLayout(self._contentContainer, 8)
    Create.Padding(self._contentContainer, 10, 10, 15, 15)
end

function Window:_SetupResize()
    local resizing = false
    local startSize, startInput
    
    self._resizeBtn.MouseEnter:Connect(function()
        Tween.Create(self._resizeBtn, { ImageColor3 = Colors.Text }, "Fast")
    end)
    
    self._resizeBtn.MouseLeave:Connect(function()
        if not resizing then
            Tween.Create(self._resizeBtn, { ImageColor3 = Color3.fromRGB(110, 110, 110) }, "Fast")
        end
    end)
    
    self._resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startSize = self._container.AbsoluteSize
            startInput = input.Position
            self._originalHeight = startSize.Y
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    Tween.Create(self._resizeBtn, { ImageColor3 = Color3.fromRGB(110, 110, 110) }, "Fast")
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end
    end)
    
    table.insert(self._connections, UserInputService.InputChanged:Connect(function(input)
        if resizing and 
           (input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            local newWidth = math.clamp(
                startSize.X + delta.X,
                Sizes.MinWindow.Width,
                Sizes.MaxWindow.Width
            )
            local newHeight = math.clamp(
                startSize.Y + delta.Y,
                Sizes.MinWindow.Height,
                Sizes.MaxWindow.Height
            )
            
            self._container.Size = UDim2.new(0, newWidth, 0, newHeight)
            self._originalHeight = newHeight
        end
    end))
end

function Window:_ToggleMinimize()
    self._minimized = not self._minimized
    
    if self._minimized then
        Tween.Create(self._mainContent, { Size = UDim2.new(1, 0, 0, 0) }, "Slow")
        Tween.Create(self._container, { 
            Size = UDim2.new(0, self._container.AbsoluteSize.X, 0, 45) 
        }, "Slow")
        self._resizeBtn.Visible = false
    else
        Tween.Create(self._container, { 
            Size = UDim2.new(0, self._container.AbsoluteSize.X, 0, self._originalHeight) 
        }, "Slow")
        task.delay(0.1, function()
            Tween.Create(self._mainContent, { Size = UDim2.new(1, 0, 1, -46) }, "Normal")
        end)
        self._resizeBtn.Visible = true
    end
end

function Window:_SetupKeybinds()
    table.insert(self._connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == self._toggleKey then
            self:Toggle()
        end
        
        for _, keybindData in pairs(self._keybinds) do
            if input.KeyCode == keybindData.key then
                keybindData.callback()
            end
        end
    end))
end

function Window:_SetupMobileToggle()
    self._mobileToggle = Create.Instance("ImageButton", {
        Name = "MobileToggle",
        Image = "rbxassetid://112235310154264",
        ImageColor3 = Colors.Text,
        BackgroundColor3 = Colors.Background,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(0, 15, 0.5, -25),
        Size = UDim2.new(0, 50, 0, 50),
        AnchorPoint = Vector2.new(0, 0.5),
        Visible = false,
        Parent = self._screenGui
    })
    
    Create.Corner(self._mobileToggle, 25)
    Create.Stroke(self._mobileToggle)
    
    self._mobileToggle.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

--[[
    Toggles window visibility
]]
function Window:Toggle()
    self._visible = not self._visible
    self._screenGui.Enabled = self._visible
    
    if self._mobileToggle then
        self._mobileToggle.Visible = not self._visible
    end
end

--[[
    Sets the toggle key for showing/hiding the window
    
    @param keyCode Enum.KeyCode - The key to use
]]
function Window:SetToggleKey(keyCode: Enum.KeyCode)
    self._toggleKey = keyCode
end

--[[
    Shows a notification
    
    @param config NotificationConfig - Notification configuration
]]
function Window:Notify(config)
    return Notification.Show(config)
end

--[[
    Creates a new section in the sidebar
    
    @param name string - Section name
    @return Section - Section instance
]]
function Window:CreateSection(name: string)
    local Section = require(script.Parent.Parent.Components.Section)
    local section = Section.new(self, name)
    table.insert(self._sections, section)
    return section
end

--[[
    Selects a tab
    
    @param tab Tab - The tab to select
]]
function Window:SelectTab(tab)
    if self._currentTab then
        self._currentTab:Deselect()
    end
    
    self._currentTab = tab
    tab:Select()
end

--[[
    Registers a keybind
    
    @param id string - Unique identifier
    @param key Enum.KeyCode - The key
    @param callback function - Callback function
]]
function Window:RegisterKeybind(id: string, key: Enum.KeyCode, callback: () -> ())
    self._keybinds[id] = {
        key = key,
        callback = callback
    }
end

--[[
    Updates a registered keybind
    
    @param id string - Keybind identifier
    @param key Enum.KeyCode - New key
]]
function Window:UpdateKeybind(id: string, key: Enum.KeyCode)
    if self._keybinds[id] then
        self._keybinds[id].key = key
    end
end

--[[
    Gets the content container for tabs
    
    @return ScrollingFrame
]]
function Window:GetContentContainer(): ScrollingFrame
    return self._contentContainer
end

--[[
    Gets the sections container
    
    @return ScrollingFrame
]]
function Window:GetSectionsContainer(): ScrollingFrame
    return self._sectionsContainer
end

--[[
    Destroys the window and cleans up resources
]]
function Window:Destroy()
    for _, connection in ipairs(self._connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    
    if self._dragConnection then
        self._dragConnection.Disconnect()
    end
    
    if self._acrylicBlur then
        self._acrylicBlur:Destroy()
    end
    
    if self._screenGui then
        self._screenGui:Destroy()
    end
end

return Window