-- slender_ui.lua - Biblioteca Slender UI com suporte a abas (tabs)

local UserInputService = game:GetService("UserInputService")

local SlenderUI = {}
SlenderUI.__index = SlenderUI

function SlenderUI.new()
    local self = setmetatable({}, SlenderUI)

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SlenderUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    self.ScreenGui = screenGui

    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
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
    title.Size = UDim2.new(1, -30, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    -- Container lateral para botões das abas (tabs)
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(0, 150, 1, -40)
    tabsContainer.Position = UDim2.new(0, 0, 0, 40)
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.Parent = window
    self.TabsContainer = tabsContainer

    -- Container principal do conteúdo da aba (vai trocar o conteúdo aqui)
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -150, 1, -40)
    contentContainer.Position = UDim2.new(0, 150, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    self.ContentContainer = contentContainer

    -- Guardar abas e botões para controle
    self.Tabs = {}
    self.TabButtons = {}

    return self
end

-- Função para adicionar uma nova aba
function SlenderUI:AddTab(name)
    -- Criar botão da aba no container lateral
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, (#self.TabButtons * 45) + 10)
    btn.Parent = self.TabsContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 90)
    stroke.Thickness = 1
    stroke.Parent = btn

    -- Criar container para conteúdo da aba dentro do contentContainer
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.Position = UDim2.new(0, 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = self.ContentContainer

    -- Adicionar ao controle interno
    table.insert(self.TabButtons, btn)
    self.Tabs[name] = tabFrame

    -- Função para ativar essa aba
    local function activateTab()
        for _, frame in pairs(self.Tabs) do
            frame.Visible = false
        end
        for _, b in pairs(self.TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end

        tabFrame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end

    btn.MouseButton1Click:Connect(activateTab)

    -- Ativar a primeira aba criada automaticamente
    if #self.TabButtons == 1 then
        activateTab()
    end

    return tabFrame
end

-- Função interna pra adicionar elementos com espaçamento vertical dentro de um container (pode usar para abas)
function SlenderUI:_addElementToContainer(container, element, height)
    if not container._currentY then container._currentY = 0 end

    element.Position = UDim2.new(0, 0, 0, container._currentY)
    element.Size = UDim2.new(1, 0, 0, height)
    element.Parent = container

    container._currentY = container._currentY + height + 10 -- spacing
end

-- Botão
function SlenderUI:AddButton(text, callback, parent)
    parent = parent or self.ContentContainer
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.AutoButtonColor = false
    btn.Active = true
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

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    btn.MouseButton1Click:Connect(callback)

    self:_addElementToContainer(parent, btn, 40)

    return btn
end

-- Toggle
function SlenderUI:AddToggle(text, default, callback, parent)
    parent = parent or self.ContentContainer
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 40)

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 24)
    toggleBtn.Position = UDim2.new(1, -50, 0, 8)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(80, 80, 80)
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleBtn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 100, 60)
    stroke.Thickness = 1
    stroke.Parent = toggleBtn

    local toggled = default

    local function updateVisual()
        if toggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateVisual()
        if callback then
            callback(toggled)
        end
    end)

    updateVisual()
    self:_addElementToContainer(parent, container, 40)

    return container, function(newState)
        toggled = newState
        updateVisual()
        if callback then
            callback(toggled)
        end
    end
end

-- Slider
function SlenderUI:AddSlider(text, min, max, default, callback, parent)
    parent = parent or self.ContentContainer
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
    label.Position = UDim2.new(0, 10, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0.3, -15, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 5, 0, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container

    local sliderBar = Instance.new("Frame")
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 1, -15)
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

    local function updateValue(inputPosX)
        local relativeX = math.clamp(inputPosX - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        fill.Size = UDim2.new(relativeX / sliderBar.AbsoluteSize.X, 0, 1, 0)
        local value = math.floor(min + (max - min) * (relativeX / sliderBar.AbsoluteSize.X) + 0.5)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input.Position.X)
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
self:_addElementToContainer(parent, container, 50)
    return container, valueLabel
end

return SlenderUI
