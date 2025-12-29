local Create = require(script.Parent.Parent.Utils.Create)
local Colors = require(script.Parent.Parent.Constants.Colors)
local Sizes = require(script.Parent.Parent.Constants.Sizes)
local Fonts = require(script.Parent.Parent.Constants.Fonts)

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(parent: Instance, config)
    local self = setmetatable({}, Paragraph)
    local title = (config and config.Title) or "Paragraph"
    local content = (config and config.Content) or "Description text here."

    self._frame = Create.Instance("Frame", {
        Name = "Paragraph",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = parent
    })

    Create.Corner(self._frame, Sizes.Corner.Medium)
    Create.Stroke(self._frame)
    Create.Padding(self._frame, 10, 10, 10, 10)

    self._title = Create.Instance("TextLabel", {
        Name = "Title",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.Text,
        Text = title,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        TextSize = Fonts.Size.Normal,
        Size = UDim2.new(1, 0, 0, 20),
        Parent = self._frame
    })

    self._content = Create.Instance("TextLabel", {
        Name = "Content",
        FontFace = Fonts.Regular,
        TextColor3 = Colors.TextDark,
        Text = content,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        TextSize = Fonts.Size.Small,
        Position = UDim2.new(0, 0, 0, 22),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = self._frame
    })

    return self
end

function Paragraph:SetTitle(text: string)
    self._title.Text = text
end

function Paragraph:SetContent(text: string)
    self._content.Text = text
end

return Paragraph
