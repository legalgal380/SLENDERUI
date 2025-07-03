-- slender_ui_mobile.lua - Slender UI com suporte completo para mobile

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local SlenderUI = {}
SlenderUI.__index = SlenderUI

function SlenderUI.new()
    local self = setmetatable({}, SlenderUI)
    
    -- Detectar input type
    self.UsesTouch = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

    self:CreateUI()
    return self
end

function SlenderUI:CreateUI()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SlenderUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = screenGui

    -- Janela principal
    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Size = UDim2.new(0, 500, 0, 400)
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.Position = UDim2.new(0.5, 0.5, 0.5, 0)
    window.BackgroundColor3 = Color3.fromRGB(30,30,30)
    window.ZIndex = 2
    window.Parent = screenGui
    self.Window = window

    -- Estilo
    Instance.new("UICorner", window).CornerRadius = UDim.new(0,10)
    Instance.new("UIStroke", window).Color = Color3.fromRGB(90,90,90)
    Instance.new("UIGradient", window).Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(45,45,45)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(25,25,25))
    }

    -- TopBar (drag)
    local top = Instance.new("Frame", window)
    top.Name, top.Size = "TopBar", UDim2.new(1,0,0,40)
    top.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", top).CornerRadius = UDim.new(0,10)
    Instance.new("UIStroke", top).Color = Color3.fromRGB(90,90,90)
    self.TopBar = top

    local title = Instance.new("TextLabel", top)
    title.BackgroundTransparency, title.Position = 1, UDim2.new(0,15,0,0)
    title.Size, title.Text = UDim2.new(1,-30,1,0), "Slender UI"
    title.Font, title.TextSize, title.TextColor3 = Enum.Font.GothamBold, 20, Color3.fromRGB(220,220,220)
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Botão fechar
    local btnClose = Instance.new("TextButton", top)
    btnClose.Name, btnClose.Text = "Close", "X"
    btnClose.Font, btnClose.TextSize, btnClose.TextColor3 = Enum.Font.GothamBold, 18, Color3.fromRGB(200,50,50)
    btnClose.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btnClose.Size, btnClose.Position = UDim2.new(0,40,1,0), UDim2.new(1,-40,0,0)
    Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0,6)
    local gs = Instance.new("UIGradient", btnClose)
    gs.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(230,70,70)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(180,30,30))
    }

    btnClose.MouseButton1Click:Connect(function()
        window.Visible = false
        self:CreateOpenButton()
    end)

    -- Conteúdo
    local content = Instance.new("Frame", window)
    content.Name, content.Position = "Content", UDim2.new(0,15,0,50)
    content.Size = UDim2.new(1,-30,1,-60)
    content.BackgroundTransparency = 1
    self.Content, self.CurrentY, self.ElementSpacing = content, 0, 10

    -- Drag da janela com toque
    self:_EnableDrag(top, window)
end

function SlenderUI:CreateOpenButton()
    local open = Instance.new("TextButton", self.ScreenGui)
    open.Name, open.Text = "OpenButton", "Abrir UI"
    open.Font, open.TextSize, open.TextColor3 = Enum.Font.GothamBold, 18, Color3.fromRGB(220,220,220)
    open.BackgroundColor3 = Color3.fromRGB(60,60,60)
    open.Size = UDim2.new(0,120,0,40)
    open.Position = UDim2.new(0.5,-60,0.9,-50)
    Instance.new("UICorner", open).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", open).Color = Color3.fromRGB(90,90,90)

    open.MouseButton1Click:Connect(function()
        self.Window.Visible = true
        open:Destroy()
    end)
end

function SlenderUI:_EnableDrag(dragObj, frame)
    local dragging, startPos, startMouse

    local function update(input)
        local delta = input.Position - startMouse
        frame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
    end

    dragObj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startMouse = input.Position
            startPos = frame.AbsolutePosition
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragObj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

function SlenderUI:_addElement(e, h)
    e.Position, e.Size = UDim2.new(0,0,0,self.CurrentY), UDim2.new(1,0,0,h)
    e.Parent = self.Content
    self.CurrentY = self.CurrentY + h + self.ElementSpacing
end

-- Botão interno
function SlenderUI:AddButton(text, cb)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.fromRGB(220,220,220)
    b.Font, b.TextSize, b.Text = Enum.Font.GothamBold, 18, text
    b.AutoButtonColor, b.Selectable = false, true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(90,90,90)
    local g = Instance.new("UIGradient", b)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(80,80,80)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(60,60,60))
    }
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            cb()
        end
    end)
    self:_addElement(b, 40)
    return b
end

-- Texto
function SlenderUI:AddText(text)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency, l.TextColor3 = 1, Color3.fromRGB(200,200,200)
    l.Font, l.TextSize = Enum.Font.Gotham,16
    l.Text, l.TextWrapped, l.TextXAlignment = text, true, Enum.TextXAlignment.Left
    self:_addElement(l,24)
    return l
end

-- Value
function SlenderUI:AddValue(labelText, val)
    local c = Instance.new("Frame", self.Content); c.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", c)
    l.Text, l.Font, l.TextColor3 = labelText, Enum.Font.GothamBold, Color3.fromRGB(220,220,220)
    l.Position, l.Size, l.BackgroundTransparency = UDim2.new(0,0,0,0), UDim2.new(0.5,0,1,0), 1
    local v = Instance.new("TextLabel", c)
    v.Text, v.Font, v.TextColor3 = tostring(val), Enum.Font.GothamBold, Color3.fromRGB(180,180,180)
    v.Position, v.Size, v.BackgroundTransparency = UDim2.new(0.5,0,0,0), UDim2.new(0.5,0,1,0), 1
    self:_addElement(c,30)
    return { Update = function(_,n) v.Text = tostring(n) end }
end

-- Slider
function SlenderUI:AddSlider(text, min, max, def, cb)
    local c = Instance.new("Frame", self.Content); c.BackgroundTransparency = 1
    c.Size = UDim2.new(1,0,0,50)
    local l = Instance.new("TextLabel", c)
    l.Text, l.Font, l.TextColor3 = text, Enum.Font.GothamBold, Color3.fromRGB(220,220,220)
    l.Size, l.Position = UDim2.new(0.7,0,1,0), UDim2.new(0,0,0,0); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    local vv = Instance.new("TextLabel", c)
    vv.Text, vv.Font, vv.TextColor3 = tostring(def), Enum.Font.GothamBold, Color3.fromRGB(180,180,180)
    vv.Size, vv.Position = UDim2.new(0.3,-5,1,0), UDim2.new(0.7,5,0,0); vv.BackgroundTransparency = 1; vv.TextXAlignment = Enum.TextXAlignment.Right
    local sb = Instance.new("Frame", c); sb.Size = UDim2.new(1,0,0,6); sb.Position = UDim2.new(0,0,1,-10); sb.BackgroundColor3 = Color3.fromRGB(60,60,60)
    local fc, bc = Instance.new("UICorner", sb), Instance.new("UICorner", c); fc.CornerRadius, bc.CornerRadius = UDim.new(0,4), UDim.new(0,4)
    local fill = Instance.new("Frame", sb); fill.BackgroundColor3 = Color3.fromRGB(150,150,250)
    fill.Size = UDim2.new((def-min)/(max-min),0,1,0)
    local dragging = false
    sb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sb.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    sb.InputChanged:Connect(function(i)
        if dragging then
            local pos = i.Position.X - sb.AbsolutePosition.X
            pos = math.clamp(pos, 0, sb.AbsoluteSize.X)
            fill.Size = UDim2.new(pos/sb.AbsoluteSize.X,0,1,0)
            local val = math.floor(min + (max-min)*(pos/sb.AbsoluteSize.X) + .5)
            vv.Text = tostring(val)
            cb(val)
        end
    end)
    self:_addElement(c,50)
    return c
end

-- Dropdown
function SlenderUI:AddDropdown(text, options, cb)
    local c = Instance.new("Frame", self.Content); c.BackgroundColor3 = Color3.fromRGB(60,60,60); c.ClipsDescendants = true
    c.Size = UDim2.new(1,0,0,35)
    Instance.new("UICorner", c).CornerRadius = UDim.new(0,8)
    local l = Instance.new("TextLabel", c)
    l.Text, l.Font, l.TextColor3 = text, Enum.Font.GothamBold, Color3.fromRGB(220,220,220)
    l.Position, l.Size, l.BackgroundTransparency, l.TextXAlignment = UDim2.new(0,10,0,6), UDim2.new(0,120,1,-12), 1, Enum.TextXAlignment.Left
    local sel = Instance.new("TextLabel", c)
    sel.Text, sel.Font, sel.TextColor3 = options[1] or "Nenhum", Enum.Font.Gotham, Color3.fromRGB(180,180,180)
    sel.Position, sel.Size, sel.BackgroundTransparency, sel.TextXAlignment = UDim2.new(0,140,0,6), UDim2.new(0,140,1,-12), 1, Enum.TextXAlignment.Left
    local open = false
    local list = Instance.new("Frame", c); list.Position, list.Size, list.BackgroundColor3 = UDim2.new(0,0,1,2), UDim2.new(1,0,0,#options*30), Color3.fromRGB(50,50,50)
    list.ClipsDescendants, list.Visible = true, false
    local layout = Instance.new("UIListLayout", list); layout.SortOrder = Enum.SortOrder.LayoutOrder
    for i,opt in ipairs(options) do
        local b = Instance.new("TextButton", list)
        b.Text, b.Font, b.TextColor3, b.Size = opt, Enum.Font.Gotham, Color3.fromRGB(220,220,220), UDim2.new(1,0,0,30)
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", b).Color = Color3.fromRGB(90,90,90)
        b.InputBegan:Connect(function(i2)
            if i2.UserInputType==Enum.UserInputType.Touch or i2.UserInputType==Enum.UserInputType.MouseButton1 then
                sel.Text = opt
                list.Visible = false
                open = false
                cb(opt)
            end
        end)
    end
    c.InputBegan:Connect(function(i2)
        if i2.UserInputType==Enum.UserInputType.Touch or i2.UserInputType==Enum.UserInputType.MouseButton1 then
            open = not open
            list.Visible = open
        end
    end)
    self:_addElement(c,35)
    return c
end

-- Parágrafo
function SlenderUI:AddParagraph(text)
    local l = Instance.new("TextLabel", self.Content)
    l.BackgroundTransparency, l.TextColor3 = 1, Color3.fromRGB(210,210,210)
    l.Font, l.TextSize, l.TextWrapped, l.TextXAlignment = Enum.Font.Gotham,14,true,Enum.TextXAlignment.Left
    l.Text, l.Size = text, UDim2.new(1,0,0,80)
    self:_addElement(l,80)
    return l
end

return SlenderUI
