--[[
    AcrylicUI - Notification System
    
    Toast-style notifications with auto-dismiss.
]]

local Create = require(script.Parent.Parent.Utils.Create)
local Tween = require(script.Parent.Parent.Utils.Tween)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Notification = {}

local Container: Frame? = nil

export type NotificationConfig = {
    Title: string?,
    Description: string?,
    Duration: number?,
    Icon: string?
}

--[[
    Creates the notification container
    
    @param screenGui ScreenGui - Parent screen gui
    @return Frame - Container frame
]]
function Notification.CreateContainer(screenGui: ScreenGui): Frame
    if Container then return Container end
    
    Container = Create.Instance("Frame", {
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -240, 0, 20),
        Size = UDim2.new(0, 220, 1, -40),
        Parent = screenGui
    })
    
    Create.ListLayout(Container, 10)
    
    return Container
end

--[[
    Shows a notification
    
    @param config NotificationConfig - Notification configuration
    @return Frame - Notification frame
    
    @example
    Notification.Show({
        Title = "Success",
        Description = "Operation completed!",
        Duration = 3,
        Icon = "rbxassetid://10709775704"
    })
]]
function Notification.Show(config: NotificationConfig): Frame
    if not Container then
        warn("AcrylicUI: Notification container not initialized")
        return nil
    end
    
    local title = config.Title or "Notification"
    local description = config.Description or ""
    local duration = config.Duration or 3
    local icon = config.Icon or "rbxassetid://10709775704"
    
    -- Notification frame
    local notification = Create.Instance("Frame", {
        Name = "Notification",
        BackgroundColor3 = Colors.Notification.Background,
        Position = UDim2.new(1, 20, 0, 0),
        Size = UDim2.new(1, 0, 0, Sizes.Notification.Height),
        ClipsDescendants = true,
        Parent = Container
    })
    
    Create.Corner(notification, Sizes.Corner.Small)
    
    Create.Instance("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Colors.Notification.Border,
        Thickness = 1.5,
        Parent = notification
    })
    
    -- Title
    Create.Instance("TextLabel", {
        Name = "Title",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = title,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 16),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(1, -60, 0, 19),
        Parent = notification
    })
    
    -- Description
    Create.Instance("TextLabel", {
        Name = "Description",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.TextDark,
        Text = description,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 38),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(1, -60, 0, 19),
        Parent = notification
    })
    
    -- Icon
    local iconImage = Create.Instance("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = icon,
        Position = UDim2.new(1, -33, 0, 23),
        Size = UDim2.new(0, 19, 0, 19),
        Parent = notification
    })
    
    Create.Instance("UIAspectRatioConstraint", {
        Parent = iconImage
    })
    
    -- Timer bar
    local timerBar = Create.Instance("Frame", {
        Name = "Timer",
        BackgroundColor3 = Colors.Notification.Timer,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        Parent = notification
    })
    
    Create.Corner(timerBar, Sizes.Corner.Full)
    
    -- Animate in
    Tween.Create(
        notification,
        { Position = UDim2.new(0, 0, 0, 0) },
        0.3,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    
    -- Timer animation
    Tween.Create(
        timerBar,
        { Size = UDim2.new(0, 0, 0, 3) },
        duration,
        Enum.EasingStyle.Linear
    )
    
    -- Auto dismiss
    task.delay(duration, function()
        Tween.CreateWithCallback(
            notification,
            { Position = UDim2.new(1, 20, 0, 0) },
            0.3,
            function()
                notification:Destroy()
            end
        )
    end)
    
    return notification
end

return Notification