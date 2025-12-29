--[[
    AcrylicUI - Tween Utilities
    
    Animation helper functions using TweenService.
]]

local TweenService = game:GetService("TweenService")
local Animation = require(script.Parent.Parent.Constants.Animation)

local Tween = {}

-- Active tweens cache for cleanup
local ActiveTweens: { [Instance]: Tween } = {}

--[[
    Creates and plays a tween animation
    
    @param instance Instance - The instance to animate
    @param properties table - Properties to animate
    @param duration number | string? - Duration or preset name
    @param easingStyle Enum.EasingStyle? - Easing style
    @param easingDirection Enum.EasingDirection? - Easing direction
    @return Tween - The created tween
    
    @example
    Tween.Create(button, { BackgroundTransparency = 0.5 }, "Fast")
]]
function Tween.Create(
    instance: Instance,
    properties: { [string]: any },
    duration: (number | string)?,
    easingStyle: Enum.EasingStyle?,
    easingDirection: Enum.EasingDirection?
): Tween
    -- Cancel existing tween on same instance
    if ActiveTweens[instance] then
        ActiveTweens[instance]:Cancel()
    end
    
    local tweenInfo = Animation.CreateTweenInfo(
        duration or Animation.Duration.Normal,
        easingStyle,
        easingDirection
    )
    
    local tween = TweenService:Create(instance, tweenInfo, properties)
    ActiveTweens[instance] = tween
    
    tween.Completed:Connect(function()
        if ActiveTweens[instance] == tween then
            ActiveTweens[instance] = nil
        end
    end)
    
    tween:Play()
    return tween
end

--[[
    Creates a tween with callback on completion
    
    @param instance Instance - The instance to animate
    @param properties table - Properties to animate
    @param duration number | string? - Duration or preset name
    @param callback function - Function to call on completion
    @return Tween
]]
function Tween.CreateWithCallback(
    instance: Instance,
    properties: { [string]: any },
    duration: (number | string)?,
    callback: () -> ()
): Tween
    local tween = Tween.Create(instance, properties, duration)
    tween.Completed:Connect(callback)
    return tween
end

--[[
    Cancels all active tweens
]]
function Tween.CancelAll()
    for _, tween in pairs(ActiveTweens) do
        tween:Cancel()
    end
    table.clear(ActiveTweens)
end

--[[
    Cancels tween for specific instance
    
    @param instance Instance - The instance to cancel tween for
]]
function Tween.Cancel(instance: Instance)
    if ActiveTweens[instance] then
        ActiveTweens[instance]:Cancel()
        ActiveTweens[instance] = nil
    end
end

return Tween