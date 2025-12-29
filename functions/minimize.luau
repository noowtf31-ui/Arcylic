local Minimize = {}

-- helper to toggle minimize on a Window instance
function Minimize.toggle(window)
    if window and window._ToggleMinimize then
        window:_ToggleMinimize()
    elseif window and window.Toggle then
        window:Toggle()
    end
end

return Minimize
