local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local SlenderUI = {}
SlenderUI.__index = SlenderUI

function SlenderUI.new()
    local self = setmetatable({}, SlenderUI)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SlenderUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    self.ScreenGui = screenGui

    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Size = UDim2.new(0, 500, 0, 400)
    window.Position = UDim2.new(0.5, -250, 0.5, -200)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.BorderSizePixel = 0
    window.Parent = screenGui
    self.Window = window

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = window

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 90)
    stroke.Thickness = 1
    stroke.Parent = window

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }
    gradient.Rotation = 90
    gradient.Parent = window

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    topBar.Parent = window
    self.TopBar = topBar

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 10)
    topCorner.Parent = topBar

    local topStroke = Instance.new("UIStroke")
    topStroke.Color = Color3.fromRGB(90, 90, 90)
    topStroke.Thickness = 1
    topStroke.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "Slender UI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(1, -60, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 22
    closeBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -45, 0, 0)
    closeBtn.Parent = topBar
    closeBtn.AutoButtonColor = true

    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui.Enabled = false
    end)

    -- Drag window support (mouse + touch)
    local dragging = false
    local dragStart = Vector2.new(0,0)
    local startPos = UDim2.new(0,0,0,0)

    local function inputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function inputChanged(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end

    topBar.InputBegan:Connect(inputBegan)
    topBar.InputChanged:Connect(inputChanged)

    self.CurrentY = 0
    self.ElementSpacing = 10

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -30, 1, -60)
    content.Position = UDim2.new(0, 15, 0, 50)
    content.BackgroundTransparency = 1
    content.Parent = window
    self.Content = content

    return self
end

function SlenderUI:_addElement(element, height)
    element.Position = UDim2.new(0, 0, 0, self.CurrentY)
    element.Size = UDim2.new(1, 0, 0, height)
    element.Parent = self.Content

    self.CurrentY = self.CurrentY + height + self.ElementSpacing
end

-- Botão
function SlenderUI:AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = false
    btn.Selectable = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 90)
    stroke.Thickness = 1
    stroke.Parent = btn

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
    }
    gradient.Rotation = 90
    gradient.Parent = btn

    -- Mouse + Touch input
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            if callback then
                callback()
            end
        end
    end)

    self:_addElement(btn, 40)

    return btn
end

-- Texto (label simples)
function SlenderUI:AddText(text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.Text = text
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top

    self:_addElement(label, 24)

    return label
end

-- Slider
function SlenderUI:AddSlider(text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 50)

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0.3, -5, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 5, 0, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container

    local sliderBar = Instance.new("Frame")
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.Size = UDim2.new(1, 0, 0, 6)
    sliderBar.Position = UDim2.new(0, 0, 1, -10)
    sliderBar.AnchorPoint = Vector2.new(0, 1)
    sliderBar.Parent = container

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBar

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(150, 150, 250)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.Parent = sliderBar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local dragging = false

    local function updateSlider(inputPosX)
        local relativeX = math.clamp(inputPosX - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        fill.Size = UDim2.new(relativeX / sliderBar.AbsoluteSize.X, 0, 1, 0)
        local value = math.floor(min + (max - min) * (relativeX / sliderBar.AbsoluteSize.X) + 0.5)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    sliderBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    self:_addElement(container, 50)

    return container, valueLabel
end

-- Valor (label com atualização)
function SlenderUI:AddValue(text, initialValue)
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 30)

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(initialValue)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0.5, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container

    self:_addElement(container, 30)

    return {
        Container = container,
        Update = function(_, newValue)
            valueLabel.Text = tostring(newValue)
        end
    }
end

-- Dropdown
function SlenderUI:AddDropdown(text, options, callback)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    container.Size = UDim2.new(1, 0, 0, 35)
    container.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 6)
    label.Size = UDim2.new(0, 120, 1, -12)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local selectedText = Instance.new("TextLabel")
    selectedText.Text = options[1] or "Nenhum"
    selectedText.Font = Enum.Font.Gotham
    selectedText.TextSize = 16
    selectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
    selectedText.BackgroundTransparency = 1
    selectedText.Position = UDim2.new(0, 140, 0, 6)
    selectedText.Size = UDim2.new(0, 140, 1, -12)
    selectedText.TextXAlignment = Enum.TextXAlignment.Left
    selectedText.Parent = container

    local open = false

    local dropdownList = Instance.new("Frame")
    dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownList.Position = UDim2.new(0, 0, 1, 2)
    dropdownList.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdownList.ClipsDescendants = true
    dropdownList.Visible = false
    dropdownList.Parent = container

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropdownList
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        optionBtn.Size = UDim2.new(1, 0, 0, 30)
        optionBtn.Text = option
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 16
        optionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        optionBtn.AutoButtonColor = false

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 6)
        optionCorner.Parent = optionBtn

        local optionStroke = Instance.new("UIStroke")
        optionStroke.Color = Color3.fromRGB(90, 90, 90)
        optionStroke.Thickness = 1
        optionStroke.Parent = optionBtn

        -- Mouse + Touch input
        optionBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                optionBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end
        end)

        optionBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                optionBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                selectedText.Text = optionBtn.Text
                dropdownList.Visible = false
                open = false
                if callback then callback(optionBtn.Text) end
            end
        end)

        optionBtn.Parent = dropdownList
    end

    -- Toggle open/close on click or touch
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            open = not open
            dropdownList.Visible = open
        end
    end)

    self:_addElement(container, 35)
    return container
end

-- Parágrafo (label grande)
function SlenderUI:AddParagraph(text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Text = text
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, 0, 0, 80)

    self:_addElement(label, 80)

    return label
end

return SlenderUI
