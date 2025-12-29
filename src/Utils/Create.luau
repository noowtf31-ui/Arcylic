--[[
    AcrylicUI - Instance Creation Utilities
    
    Helper functions for creating and configuring UI instances.
]]

local Constants = {
    Colors = require(script.Parent.Parent.Constants.Colors),
    Sizes = require(script.Parent.Parent.Constants.Sizes)
}

local Create = {}

--[[
    Creates a new instance with properties
    
    @param className string - The class name of the instance
    @param properties table - Properties to apply
    @return Instance - The created instance
    
    @example
    local frame = Create.Instance("Frame", {
        Name = "Container",
        BackgroundColor3 = Colors.Background,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = screenGui
    })
]]
function Create.Instance(className: string, properties: { [string]: any }): Instance
    local instance = Instance.new(className)
    
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    
    -- Set parent last to avoid unnecessary property updates
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

--[[
    Creates a UICorner with specified radius
    
    @param parent Instance - Parent to attach corner to
    @param radius number? - Corner radius in pixels (default: 5)
    @return UICorner
]]
function Create.Corner(parent: Instance, radius: number?): UICorner
    return Create.Instance("UICorner", {
        CornerRadius = UDim.new(0, radius or Constants.Sizes.Corner.Medium),
        Parent = parent
    }) :: UICorner
end

--[[
    Creates a UIStroke border
    
    @param parent Instance - Parent to attach stroke to
    @param color Color3? - Stroke color (default: Border color)
    @param transparency number? - Stroke transparency (default: 0)
    @param thickness number? - Stroke thickness (default: 1)
    @return UIStroke
]]
function Create.Stroke(
    parent: Instance,
    color: Color3?,
    transparency: number?,
    thickness: number?
): UIStroke
    return Create.Instance("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color or Constants.Colors.Border,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        Parent = parent
    }) :: UIStroke
end

--[[
    Creates a UIPadding
    
    @param parent Instance - Parent to attach padding to
    @param top number? - Top padding
    @param bottom number? - Bottom padding
    @param left number? - Left padding
    @param right number? - Right padding
    @return UIPadding
]]
function Create.Padding(
    parent: Instance,
    top: number?,
    bottom: number?,
    left: number?,
    right: number?
): UIPadding
    return Create.Instance("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = parent
    }) :: UIPadding
end

--[[
    Creates a UIListLayout
    
    @param parent Instance - Parent to attach layout to
    @param padding number? - Padding between elements
    @param sortOrder Enum.SortOrder? - Sort order
    @param direction Enum.FillDirection? - Fill direction
    @return UIListLayout
]]
function Create.ListLayout(
    parent: Instance,
    padding: number?,
    sortOrder: Enum.SortOrder?,
    direction: Enum.FillDirection?
): UIListLayout
    return Create.Instance("UIListLayout", {
        Padding = UDim.new(0, padding or 0),
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
        FillDirection = direction or Enum.FillDirection.Vertical,
        Parent = parent
    }) :: UIListLayout
end

--[[
    Creates a UIGridLayout
    
    @param parent Instance - Parent to attach layout to
    @param cellSize UDim2 - Size of each cell
    @param cellPadding UDim2? - Padding between cells
    @return UIGridLayout
]]
function Create.GridLayout(
    parent: Instance,
    cellSize: UDim2,
    cellPadding: UDim2?
): UIGridLayout
    return Create.Instance("UIGridLayout", {
        CellSize = cellSize,
        CellPadding = cellPadding or UDim2.new(0, 5, 0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = parent
    }) :: UIGridLayout
end

return Create