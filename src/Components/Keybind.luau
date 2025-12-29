local UserInputService = game:GetService("UserInputService")

local Create = require(script.Parent.Parent.Utils.Create)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(parent: Instance, config, window)
    local self = setmetatable({}, Keybind)

    local name = (config and config.Name) or "Keybind"
    local default = (config and config.Default) or Enum.KeyCode.F
    local callback = (config and config.Callback) or function() end

    self._frame = Create.Instance("Frame", {
        Name = "Keybind_" .. name,
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, Sizes.Button.Height),
        Parent = parent
    })

    Create.Corner(self._frame, Sizes.Corner.Medium)
    Create.Stroke(self._frame)

    Create.Instance("TextLabel", {
        Name = "Name",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0.5, -10),
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(0, 200, 0, 20),
        Parent = self._frame
    })

    self._box = Create.Instance("Frame", {
        Name = "KeyBox",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.04,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 30, 0, 26),
        Parent = self._frame
    })

    Create.Corner(self._box, Sizes.Corner.Small)
    Create.Stroke(self._box)

    self._label = Create.Instance("TextLabel", {
        Name = "Key",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = default.Name,
        BackgroundTransparency = 1,
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self._box
    })

    self._listenBtn = Create.Instance("TextButton", {
        Name = "Listen",
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self._box
    })

    self._currentKey = default
    self._listening = false

    local id = name .. "_" .. tostring(math.floor(os.clock() * 1000))
    window:RegisterKeybind(id, self._currentKey, callback)

    local function refresh()
        if self._listening then
            self._label.Text = "..."
            self._box.Size = UDim2.new(0, 43, 0, 26)
        else
            local keyName = self._currentKey.Name
            local w = math.max(#keyName * 9 + 10, 24)
            self._box.Size = UDim2.new(0, w, 0, 26)
            self._label.Text = keyName
        end
    end

    self._listenBtn.MouseButton1Click:Connect(function()
        self._listening = true
        refresh()
    end)

    self._inputConn = UserInputService.InputBegan:Connect(function(input, gp)
        if not self._listening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            self._currentKey = input.KeyCode
            self._listening = false
            window:UpdateKeybind(id, self._currentKey)
            refresh()
        end
    end)

    refresh()
    return self
end

function Keybind:SetKey(key: Enum.KeyCode)
    self._currentKey = key
    self._label.Text = key.Name
end

function Keybind:Destroy()
    if self._inputConn then self._inputConn:Disconnect() end
    self._frame:Destroy()
end

return Keybind
