--[[
    AcrylicUI - Animation Constants
    
    Timing and easing configurations for smooth animations.
]]

local Animation = {
    -- Duration presets (in seconds)
    Duration = {
        Instant = 0.05,
        Fast = 0.1,
        Normal = 0.15,
        Slow = 0.2,
        VerySlow = 0.3
    },
    
    -- Default easing style
    DefaultEasing = Enum.EasingStyle.Quad,
    
    -- Default easing direction
    DefaultDirection = Enum.EasingDirection.Out,
    
    -- Spring configurations for bouncy effects
    Spring = {
        Damping = 1,
        Frequency = 3
    }
}

--[[
    Creates a TweenInfo with preset values
    
    @param duration string | number - Duration preset name or custom value
    @param easing Enum.EasingStyle? - Optional easing style
    @param direction Enum.EasingDirection? - Optional easing direction
    @return TweenInfo
]]
function Animation.CreateTweenInfo(
    duration: string | number,
    easing: Enum.EasingStyle?,
    direction: Enum.EasingDirection?
): TweenInfo
    local actualDuration = if type(duration) == "string" 
        then Animation.Duration[duration] or Animation.Duration.Normal
        else duration
    
    return TweenInfo.new(
        actualDuration,
        easing or Animation.DefaultEasing,
        direction or Animation.DefaultDirection
    )
end

return Animation