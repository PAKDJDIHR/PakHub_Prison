--[[
    ██████╗  █████╗ ██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██╔══██╗██║ ██╔╝    ██║  ██║██║   ██║██╔══██╗
    ██████╔╝███████║█████╔╝     ███████║██║   ██║██████╔╝
    ██╔═══╝ ██╔══██║██╔═██╗     ██╔══██║██║   ██║██╔══██╗
    ██║     ██║  ██║██║  ██╗    ██║  ██║╚██████╔╝██████╔╝
    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
            PAK HUB PRISON - SILENT AIM EDITION
]]

--// SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Teams = game:GetService("Teams")

--// CONFIGURAÇÕES
local CONFIG = {
    KEY_CORRETA = "PakPrison",
    CRIADOR = "PAKDJDIHR",
    URL_IMAGEM = "https://raw.githubusercontent.com/PAKDJDIHR/PakHubv2/main/fundo.png",
    COR_PRIMARIA = Color3.fromRGB(138, 43, 226),
    COR_SECUNDARIA = Color3.fromRGB(180, 80, 255),
    COR_FUNDO = Color3.fromRGB(20, 15, 30),
    COR_PAINEL = Color3.fromRGB(30, 22, 45),
    COR_SIDEBAR = Color3.fromRGB(25, 18, 38),
    COR_TEXTO = Color3.fromRGB(240, 240, 255),
    COR_SUBTEXTO = Color3.fromRGB(160, 150, 180),
    FONTE = Enum.Font.GothamMedium,
    FONTE_BOLD = Enum.Font.GothamBold,
}

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--// TIMES DO PRISON LIFE (dropdowns fixos)
local TIMES_PRISON = {
    "None",
    "Guards",
    "Inmates",
    "Criminals",
}

--// ESTADOS
local State = {
    SilentAimbot = false,
    AimbotFOV = 120,
    VerificarParedes = false,
    IgnorarCorpos = false,
    IgnorarTime = "None",
    FocarTime = "None",
    MostrarFOV = true,
    ESP = false,
    Box = false,
    Lines = false,
    Name = false,
    Distance = false,
    Health = false,
    Speed = false,
    SpeedValue = 25,
    Noclip = false,
    JumpInfinito = false,
    Spinbot = false,
    SpinSpeed = 10,
}

--// LIMPAR GUI ANTERIOR
pcall(function()
    if CoreGui:FindFirstChild("PAK_HUB_PRISON") then
        CoreGui:FindFirstChild("PAK_HUB_PRISON"):Destroy()
    end
end)
pcall(function()
    if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("PAK_HUB_PRISON") then
        LocalPlayer.PlayerGui:FindFirstChild("PAK_HUB_PRISON"):Destroy()
    end
end)

--// CRIAR GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PAK_HUB_PRISON"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentGui = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
ScreenGui.Parent = parentGui

--// FUNÇÕES UTILITÁRIAS
local function criar(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

local function arredondar(inst, raio)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, raio or 8)
    corner.Parent = inst
end

local function gradiente(inst, c1, c2, rotacao)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(c1, c2)
    grad.Rotation = rotacao or 90
    grad.Parent = inst
end

local function sombra(inst)
    local shadow = Instance.new("UIStroke")
    shadow.Color = CONFIG.COR_PRIMARIA
    shadow.Thickness = 1
    shadow.Transparency = 0.5
    shadow.Parent = inst
end

--// TELA DE KEY
local KeyScreen = criar("Frame", {
    Size = UDim2.new(0, 340, 0, 260),
    Position = UDim2.new(0.5, -170, 0.5, -130),
    BackgroundColor3 = CONFIG.COR_PAINEL,
    BorderSizePixel = 0,
    Parent = ScreenGui,
    ClipsDescendants = true,
})
arredondar(KeyScreen, 14)
gradiente(KeyScreen, CONFIG.COR_PAINEL, CONFIG.COR_FUNDO, 135)
sombra(KeyScreen)

criar("Frame", {
    Size = UDim2.new(1, 0, 0, 4),
    BackgroundColor3 = CONFIG.COR_PRIMARIA,
    BorderSizePixel = 0,
    Parent = KeyScreen,
})

local logoLabel = criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 25),
    BackgroundTransparency = 1,
    Text = "PAK HUB PRISON",
    TextColor3 = CONFIG.COR_TEXTO,
    Font = CONFIG.FONTE_BOLD,
    TextSize = 26,
    Parent = KeyScreen,
})
gradiente(logoLabel, CONFIG.COR_PRIMARIA, CONFIG.COR_SECUNDARIA, 0)

criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 72),
    BackgroundTransparency = 1,
    Text = "SILENT AIM EDITION",
    TextColor3 = CONFIG.COR_SUBTEXTO,
    Font = CONFIG.FONTE,
    TextSize = 11,
    Parent = KeyScreen,
})

local keyBox = criar("TextBox", {
    Size = UDim2.new(0, 260, 0, 46),
    Position = UDim2.new(0.5, -130, 0, 110),
    BackgroundColor3 = CONFIG.COR_FUNDO,
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "Digite sua Key...",
    PlaceholderColor3 = CONFIG.COR_SUBTEXTO,
    TextColor3 = CONFIG.COR_TEXTO,
    Font = CONFIG.FONTE,
    TextSize = 15,
    Parent = KeyScreen,
    ClearTextOnFocus = false,
})
arredondar(keyBox, 10)
local keyStroke = criar("UIStroke", {
    Color = CONFIG.COR_PRIMARIA,
    Thickness = 1,
    Transparency = 0.6,
    Parent = keyBox,
})
criar("UIPadding", {
    PaddingLeft = UDim.new(0, 14),
    PaddingRight = UDim.new(0, 14),
    Parent = keyBox,
})

local confirmBtn = criar("TextButton", {
    Size = UDim2.new(0, 260, 0, 46),
    Position = UDim2.new(0.5, -130, 0, 175),
    BackgroundColor3 = CONFIG.COR_PRIMARIA,
    BorderSizePixel = 0,
    Text = "CONFIRMAR",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = CONFIG.FONTE_BOLD,
    TextSize = 15,
    Parent = KeyScreen,
    AutoButtonColor = false,
})
arredondar(confirmBtn, 10)
gradiente(confirmBtn, CONFIG.COR_PRIMARIA, CONFIG.COR_SECUNDARIA, 0)

local errorLabel = criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 1, -22),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Color3.fromRGB(255, 80, 80),
    Font = CONFIG.FONTE,
    TextSize = 12,
    Parent = KeyScreen,
})

confirmBtn.MouseEnter:Connect(function()
    TweenService:Create(confirmBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COR_SECUNDARIA}):Play()
end)
confirmBtn.MouseLeave:Connect(function()
    TweenService:Create(confirmBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COR_PRIMARIA}):Play()
end)

--// HUB PRINCIPAL
local Hub = criar("Frame", {
    Size = UDim2.new(0, 520, 0, 360),
    Position = UDim2.new(0.5, -260, 0.5, -180),
    BackgroundColor3 = CONFIG.COR_PAINEL,
    BorderSizePixel = 0,
    Parent = ScreenGui,
    Visible = false,
    ClipsDescendants = true,
    Active = true,
    BackgroundTransparency = 0.15,
})
arredondar(Hub, 14)
sombra(Hub)

local bgImage = criar("ImageLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image = CONFIG.URL_IMAGEM,
    ImageTransparency = 0.35,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0,
    Parent = Hub,
})
arredondar(bgImage, 14)

local bgOverlay = criar("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(15, 10, 25),
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = Hub,
})
arredondar(bgOverlay, 14)
gradiente(bgOverlay, Color3.fromRGB(40, 20, 70), Color3.fromRGB(15, 10, 25), 135)

local hubTopBar = criar("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = CONFIG.COR_FUNDO,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = Hub,
    ZIndex = 5,
})
arredondar(hubTopBar, 14)
criar("Frame", {
    Size = UDim2.new(1, 0, 0.5, 0),
    Position = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = CONFIG.COR_FUNDO,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Parent = hubTopBar,
    ZIndex = 5,
})

local hubTitle = criar("TextLabel", {
    Size = UDim2.new(0, 260, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Text = "PAK HUB PRISON",
    TextColor3 = CONFIG.COR_TEXTO,
    Font = CONFIG.FONTE_BOLD,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = hubTopBar,
    ZIndex = 6,
})
gradiente(hubTitle, CONFIG.COR_PRIMARIA, CONFIG.COR_SECUNDARIA, 0)

local minimBtn = criar("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -74, 0.5, -15),
    BackgroundColor3 = CONFIG.COR_PAINEL,
    BorderSizePixel = 0,
    Text = "−",
    TextColor3 = CONFIG.COR_TEXTO,
    Font = CONFIG.FONTE_BOLD,
    TextSize = 20,
    Parent = hubTopBar,
    AutoButtonColor = false,
    ZIndex = 6,
})
arredondar(minimBtn, 8)

local closeBtn = criar("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -38, 0.5, -15),
    BackgroundColor3 = CONFIG.COR_PAINEL,
    BorderSizePixel = 0,
    Text = "×",
    TextColor3 = CONFIG.COR_TEXTO,
    Font = CONFIG.FONTE_BOLD,
    TextSize = 20,
    Parent = hubTopBar,
    AutoButtonColor = false,
    ZIndex = 6,
})
arredondar(closeBtn, 8)

minimBtn.MouseEnter:Connect(function() minimBtn.BackgroundColor3 = CONFIG.COR_PRIMARIA end)
minimBtn.MouseLeave:Connect(function() minimBtn.BackgroundColor3 = CONFIG.COR_PAINEL end)
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40) end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = CONFIG.COR_PAINEL end)

-- SIDEBAR
local Sidebar = criar("Frame", {
    Size = UDim2.new(0, 130, 1, -52),
    Position = UDim2.new(0, 10, 0, 48),
    BackgroundColor3 = CONFIG.COR_SIDEBAR,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Parent = Hub,
    ZIndex = 5,
})
arredondar(Sidebar, 10)
criar("UIStroke", {
    Color = CONFIG.COR_PRIMARIA,
    Thickness = 1,
    Transparency = 0.7,
    Parent = Sidebar,
})
criar("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Sidebar,
})
criar("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
    Parent = Sidebar,
})

-- ÁREA DE CONTEÚDO
local ContentArea = criar("Frame", {
    Size = UDim2.new(1, -150, 1, -52),
    Position = UDim2.new(0, 148, 0, 48),
    BackgroundColor3 = CONFIG.COR_FUNDO,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    Parent = Hub,
    ClipsDescendants = true,
    ZIndex = 5,
})
arredondar(ContentArea, 10)
criar("UIStroke", {
    Color = CONFIG.COR_PRIMARIA,
    Thickness = 1,
    Transparency = 0.7,
    Parent = ContentArea,
})

local pageTitle = criar("TextLabel", {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = CONFIG.COR_PRIMARIA,
    Font = CONFIG.FONTE_BOLD,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ContentArea,
    ZIndex = 6,
})

local ContentScroll = criar("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -48),
    Position = UDim2.new(0, 8, 0, 42),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = CONFIG.COR_PRIMARIA,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = ContentArea,
    ZIndex = 6,
})
criar("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = ContentScroll,
})

-- BOLA FLUTUANTE
local FloatingBall = criar("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 20, 0.5, -25),
    BackgroundColor3 = CONFIG.COR_PRIMARIA,
    BorderSizePixel = 0,
    Text = "P",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = CONFIG.FONTE_BOLD,
    TextSize = 20,
    Parent = ScreenGui,
    Visible = false,
    AutoButtonColor = false,
})
arredondar(FloatingBall, 25)
gradiente(FloatingBall, CONFIG.COR_PRIMARIA, CONFIG.COR_SECUNDARIA, 45)
sombra(FloatingBall)
--// SISTEMA DE PÁGINAS
local Pages = {}
local CurrentPage = nil
local SidebarButtons = {}

local function criarCategoria(nome, icone)
    local btn = criar("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = CONFIG.COR_PAINEL,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = Sidebar,
        ZIndex = 6,
    })
    arredondar(btn, 6)

    local iconLabel = criar("TextLabel", {
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = icone or "▸",
        TextColor3 = CONFIG.COR_PRIMARIA,
        Font = CONFIG.FONTE_BOLD,
        TextSize = 14,
        Parent = btn,
        ZIndex = 7,
    })
    local nameLabel = criar("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = nome,
        TextColor3 = CONFIG.COR_TEXTO,
        Font = CONFIG.FONTE,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn,
        ZIndex = 7,
    })

    local page = criar("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Visible = false,
        Parent = ContentScroll,
        ZIndex = 7,
    })
    criar("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })

    Pages[nome] = page
    SidebarButtons[nome] = { btn = btn, icon = iconLabel, label = nameLabel }

    btn.MouseEnter:Connect(function()
        if CurrentPage ~= nome then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COR_SIDEBAR}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentPage ~= nome then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COR_PAINEL}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = false end
        for n, b in pairs(SidebarButtons) do
            TweenService:Create(b.btn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COR_PAINEL}):Play()
            b.icon.TextColor3 = CONFIG.COR_PRIMARIA
            b.label.TextColor3 = CONFIG.COR_TEXTO
        end
        Pages[nome].Visible = true
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COR_PRIMARIA}):Play()
        iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        pageTitle.Text = nome
        CurrentPage = nome
    end)

    return page
end

--// FUNÇÃO TOGGLE
local function criarToggle(parent, nome, descricao, callback)
    local container = criar("Frame", {
        Size = UDim2.new(1, -6, 0, 46),
        BackgroundColor3 = CONFIG.COR_PAINEL,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent,
        ZIndex = 7,
    })
    arredondar(container, 8)
    criar("UIStroke", {
        Color = CONFIG.COR_PRIMARIA,
        Thickness = 1,
        Transparency = 0.85,
        Parent = container,
    })

    criar("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 20),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = nome,
        TextColor3 = CONFIG.COR_TEXTO,
        Font = CONFIG.FONTE_BOLD,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
        ZIndex = 8,
    })
    if descricao then
        criar("TextLabel", {
            Size = UDim2.new(0.7, 0, 0, 16),
            Position = UDim2.new(0, 12, 0, 24),
            BackgroundTransparency = 1,
            Text = descricao,
            TextColor3 = CONFIG.COR_SUBTEXTO,
            Font = CONFIG.FONTE,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
            ZIndex = 8,
        })
    end

    local toggleBg = criar("Frame", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -52, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(60, 55, 75),
        BorderSizePixel = 0,
        Parent = container,
        ZIndex = 8,
    })
    arredondar(toggleBg, 10)

    local circle = criar("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = toggleBg,
        ZIndex = 9,
    })
    arredondar(circle, 8)

    local ativo = false
    local btn = criar("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = container,
        ZIndex = 9,
    })

    btn.MouseButton1Click:Connect(function()
        ativo = not ativo
        if ativo then
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COR_PRIMARIA}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 55, 75)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
        if callback then callback(ativo) end
    end)

    return container
end

--// FUNÇÃO SLIDER
local function criarSlider(parent, nome, min, max, padrao, callback)
    local container = criar("Frame", {
        Size = UDim2.new(1, -6, 0, 50),
        BackgroundColor3 = CONFIG.COR_PAINEL,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent,
        ZIndex = 7,
    })
    arredondar(container, 8)
    criar("UIStroke", {
        Color = CONFIG.COR_PRIMARIA,
        Thickness = 1,
        Transparency = 0.85,
        Parent = container,
    })

    criar("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 18),
        Position = UDim2.new(0, 12, 0, 4),
        BackgroundTransparency = 1,
        Text = nome,
        TextColor3 = CONFIG.COR_TEXTO,
        Font = CONFIG.FONTE,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
        ZIndex = 8,
    })

    local valorLabel = criar("TextLabel", {
        Size = UDim2.new(0.25, 0, 0, 18),
        Position = UDim2.new(0.7, 0, 0, 4),
        BackgroundTransparency = 1,
        Text = tostring(padrao),
        TextColor3 = CONFIG.COR_PRIMARIA,
        Font = CONFIG.FONTE_BOLD,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container,
        ZIndex = 8,
    })

    local barBg = criar("Frame", {
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 0, 32),
        BackgroundColor3 = CONFIG.COR_FUNDO,
        BorderSizePixel = 0,
        Parent = container,
        ZIndex = 8,
    })
    arredondar(barBg, 3)

    local fill = criar("Frame", {
        Size = UDim2.new((padrao - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = CONFIG.COR_PRIMARIA,
        BorderSizePixel = 0,
        Parent = barBg,
        ZIndex = 8,
    })
    arredondar(fill, 3)
    gradiente(fill, CONFIG.COR_PRIMARIA, CONFIG.COR_SECUNDARIA, 0)

    local knob = criar("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((padrao - min) / (max - min), -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = barBg,
        ZIndex = 9,
    })
    arredondar(knob, 7)

    local dragging = false
    local btn = criar("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = barBg,
        ZIndex = 10,
    })

    local function update(input)
        local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        valorLabel.Text = tostring(val)
        TweenService:Create(fill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.05), {Position = UDim2.new(pos, -7, 0.5, -7)}):Play()
        if callback then callback(val) end
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return container
end

--// FUNÇÃO BOTÃO
local function criarBotao(parent, nome, callback)
    local btn = criar("TextButton", {
        Size = UDim2.new(1, -6, 0, 36),
        BackgroundColor3 = CONFIG.COR_PAINEL,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Text = nome,
        TextColor3 = CONFIG.COR_TEXTO,
        Font = CONFIG.FONTE,
        TextSize = 12,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent,
        AutoButtonColor = false,
        ZIndex = 7,
    })
    arredondar(btn, 8)
    criar("UIStroke", {
        Color = CONFIG.COR_PRIMARIA,
        Thickness = 1,
        Transparency = 0.7,
        Parent = btn,
    })

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COR_PRIMARIA}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COR_PAINEL}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return btn
end

--// FUNÇÃO DROPDOWN (NOVO)
local function criarDropdown(parent, nome, opcoes, padrao, callback)
    local aberto = false
    local selecionado = padrao

    local container = criar("Frame", {
        Size = UDim2.new(1, -6, 0, 46),
        BackgroundColor3 = CONFIG.COR_PAINEL,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent,
        ZIndex = 7,
        ClipsDescendants = false,
    })
    arredondar(container, 8)
    criar("UIStroke", {
        Color = CONFIG.COR_PRIMARIA,
        Thickness = 1,
        Transparency = 0.85,
        Parent = container,
    })

    criar("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 18),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = nome,
        TextColor3 = CONFIG.COR_TEXTO,
        Font = CONFIG.FONTE_BOLD,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
        ZIndex = 8,
    })

    local valorBtn = criar("TextButton", {
        Size = UDim2.new(0.6, 0, 0, 22),
        Position = UDim2.new(0, 12, 0, 20),
        BackgroundColor3 = CONFIG.COR_FUNDO,
        BorderSizePixel = 0,
        Text = " " .. selecionado .. "  ▾",
        TextColor3 = CONFIG.COR_PRIMARIA,
        Font = CONFIG.FONTE_BOLD,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
        AutoButtonColor = false,
        ZIndex = 8,
    })
    arredondar(valorBtn, 6)
    criar("UIStroke", {
        Color = CONFIG.COR_PRIMARIA,
        Thickness = 1,
        Transparency = 0.5,
        Parent = valorBtn,
    })
    criar("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        Parent = valorBtn,
    })

    local lista = criar("ScrollingFrame", {
        Size = UDim2.new(0, 200, 0, math.min(#opcoes * 24 + 6, 130)),
        Position = UDim2.new(0, 12, 1, 4),
        BackgroundColor3 = CONFIG.COR_FUNDO,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CONFIG.COR_PRIMARIA,
        CanvasSize = UDim2.new(0, 0, 0, #opcoes * 24),
        Parent = container,
        Visible = false,
        ZIndex = 15,
    })
    arredondar(lista, 6)
    criar("UIStroke", {
        Color = CONFIG.COR_PRIMARIA,
        Thickness = 1,
        Transparency = 0.3,
        Parent = lista,
    })
    criar("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = lista,
    })
    criar("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        Parent = lista,
    })

    for _, opcao in ipairs(opcoes) do
        local optBtn = criar("TextButton", {
            Size = UDim2.new(1, -4, 0, 22),
            BackgroundColor3 = CONFIG.COR_PAINEL,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Text = opcao,
            TextColor3 = CONFIG.COR_TEXTO,
            Font = CONFIG.FONTE,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1,
            Parent = lista,
            AutoButtonColor = false,
            ZIndex = 16,
        })
        arredondar(optBtn, 4)
        criar("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            Parent = optBtn,
        })

        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COR_PRIMARIA, BackgroundTransparency = 0}):Play()
        end)
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COR_PAINEL, BackgroundTransparency = 0.3}):Play()
        end)

        optBtn.MouseButton1Click:Connect(function()
            selecionado = opcao
            valorBtn.Text = " " .. selecionado .. "  ▾"
            lista.Visible = false
            aberto = false
            if callback then callback(selecionado) end
        end)
    end

    valorBtn.MouseButton1Click:Connect(function()
        aberto = not aberto
        lista.Visible = aberto
    end)

    container.Size = UDim2.new(1, -6, 0, 46)

    return container
end
--// CONSTRUÇÃO DAS PÁGINAS

-- PÁGINA: COMBAT
local pageCombat = criarCategoria("COMBAT", "⚔")
criarToggle(pageCombat, "Silent Aimbot", "Balas vão no alvo sem mexer a câmera", function(v) State.SilentAimbot = v end)
criarSlider(pageCombat, "Aimbot FOV", 30, 500, 120, function(v) State.AimbotFOV = v end)
criarToggle(pageCombat, "Verificar Paredes", "Aimbot só atira se estiver visível", function(v) State.VerificarParedes = v end)
criarToggle(pageCombat, "Ignorar Corpos", "Não mira em jogadores mortos", function(v) State.IgnorarCorpos = v end)
criarDropdown(pageCombat, "Ignorar Time", TIMES_PRISON, "None", function(v) State.IgnorarTime = v end)
criarDropdown(pageCombat, "Focar Time", TIMES_PRISON, "None", function(v) State.FocarTime = v end)
criarToggle(pageCombat, "Mostrar FOV Circle", "Círculo fixo no centro da tela", function(v) State.MostrarFOV = v end)

-- PÁGINA: VISUALS
local pageVisuals = criarCategoria("VISUALS", "👁")
criarToggle(pageVisuals, "ESP Geral", "Liga/desliga todos os ESP", function(v) State.ESP = v end)
criarToggle(pageVisuals, "Caixas / Box", "Caixa ao redor do jogador", function(v) State.Box = v end)
criarToggle(pageVisuals, "Linhas (ESP Lines)", "Linhas do centro da tela até o jogador", function(v) State.Lines = v end)
criarToggle(pageVisuals, "Mostrar Nomes", "Nome do jogador acima", function(v) State.Name = v end)
criarToggle(pageVisuals, "Mostrar Distância", "Distância em metros", function(v) State.Distance = v end)
criarToggle(pageVisuals, "Mostrar Vida", "Barra de vida colorida", function(v) State.Health = v end)

-- PÁGINA: MOVEMENT
local pageMovement = criarCategoria("MOVEMENT", "🏃")
criarToggle(pageMovement, "Speed", "Aumenta a velocidade", function(v) State.Speed = v end)
criarSlider(pageMovement, "Speed Value", 16, 200, 25, function(v) State.SpeedValue = v end)
criarToggle(pageMovement, "Noclip", "Atravessar paredes", function(v) State.Noclip = v end)
criarToggle(pageMovement, "Jump Infinito", "Pular sem parar", function(v) State.JumpInfinito = v end)
criarToggle(pageMovement, "Spinbot", "Girar personagem", function(v) State.Spinbot = v end)
criarSlider(pageMovement, "Spin Speed", 1, 50, 10, function(v) State.SpinSpeed = v end)

-- PÁGINA: CRÉDITOS
local pageCredits = criarCategoria("CRÉDITOS", "★")
local credContainer = criar("Frame", {
    Size = UDim2.new(1, -6, 0, 200),
    BackgroundColor3 = CONFIG.COR_PAINEL,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    LayoutOrder = 1,
    Parent = pageCredits,
    ZIndex = 7,
})
arredondar(credContainer, 8)
criar("UIStroke", {
    Color = CONFIG.COR_PRIMARIA,
    Thickness = 1,
    Transparency = 0.7,
    Parent = credContainer,
})

local avatar = criar("ImageLabel", {
    Size = UDim2.new(0, 70, 0, 70),
    Position = UDim2.new(0.5, -35, 0, 20),
    BackgroundColor3 = CONFIG.COR_FUNDO,
    BorderSizePixel = 0,
    Parent = credContainer,
    ZIndex = 8,
})
arredondar(avatar, 35)

pcall(function()
    local id = Players:GetUserIdFromNameAsync(CONFIG.CRIADOR)
    local thumb = Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    avatar.Image = thumb
end)

criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0, 100),
    BackgroundTransparency = 1,
    Text = CONFIG.CRIADOR,
    TextColor3 = CONFIG.COR_TEXTO,
    Font = CONFIG.FONTE_BOLD,
    TextSize = 16,
    Parent = credContainer,
    ZIndex = 8,
})
criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 125),
    BackgroundTransparency = 1,
    Text = "Criador do PAK HUB PRISON",
    TextColor3 = CONFIG.COR_SUBTEXTO,
    Font = CONFIG.FONTE,
    TextSize = 11,
    Parent = credContainer,
    ZIndex = 8,
})
criar("TextLabel", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0, 155),
    BackgroundTransparency = 1,
    Text = "Obrigado por usar!",
    TextColor3 = CONFIG.COR_PRIMARIA,
    Font = CONFIG.FONTE_BOLD,
    TextSize = 13,
    Parent = credContainer,
    ZIndex = 8,
})

-- Abrir primeira página automaticamente
task.wait(0.1)
if SidebarButtons["COMBAT"] then
    for n, p in pairs(Pages) do p.Visible = false end
    Pages["COMBAT"].Visible = true
    TweenService:Create(SidebarButtons["COMBAT"].btn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COR_PRIMARIA}):Play()
    SidebarButtons["COMBAT"].icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    SidebarButtons["COMBAT"].label.TextColor3 = Color3.fromRGB(255, 255, 255)
    pageTitle.Text = "COMBAT"
    CurrentPage = "COMBAT"
end

--// MENSAGEM DE BOAS-VINDAS
local function mostrarBoasVindas()
    local welcome = criar("Frame", {
        Size = UDim2.new(0, 300, 0, 70),
        Position = UDim2.new(0.5, -150, 0, -80),
        BackgroundColor3 = CONFIG.COR_PAINEL,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ZIndex = 20,
    })
    arredondar(welcome, 12)
    gradiente(welcome, CONFIG.COR_PAINEL, CONFIG.COR_FUNDO, 135)
    sombra(welcome)

    criar("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Text = "Bem-vindo à prisão",
        TextColor3 = CONFIG.COR_PRIMARIA,
        Font = CONFIG.FONTE_BOLD,
        TextSize = 15,
        Parent = welcome,
        ZIndex = 21,
    })
    criar("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundTransparency = 1,
        Text = "E aí, " .. LocalPlayer.Name .. "!",
        TextColor3 = CONFIG.COR_TEXTO,
        Font = CONFIG.FONTE,
        TextSize = 13,
        Parent = welcome,
        ZIndex = 21,
    })

    TweenService:Create(welcome, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()

    task.wait(3.5)
    local out = TweenService:Create(welcome, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -150, 0, -80),
        BackgroundTransparency = 1
    })
    out:Play()
    for _, v in pairs(welcome:GetDescendants()) do
        if v:IsA("TextLabel") then
            TweenService:Create(v, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        end
    end
    out.Completed:Connect(function() welcome:Destroy() end)
end

--// DRAG
local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(Hub, hubTopBar)
makeDraggable(KeyScreen, KeyScreen)
makeDraggable(FloatingBall)

--// VERIFICAÇÃO DA KEY
confirmBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == CONFIG.KEY_CORRETA then
        local out = TweenService:Create(KeyScreen, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -170, 0.5, 400),
            BackgroundTransparency = 1
        })
        out:Play()
        for _, v in pairs(KeyScreen:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                TweenService:Create(v, TweenInfo.new(0.4), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            end
        end
        out.Completed:Connect(function()
            KeyScreen:Destroy()
            Hub.Visible = true
            Hub.Position = UDim2.new(0.5, -260, 0.5, 300)
            TweenService:Create(Hub, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -260, 0.5, -180)
            }):Play()
            mostrarBoasVindas()
        end)
    else
        errorLabel.Text = "✗ Key inválida. Tente novamente."
        keyStroke.Color = Color3.fromRGB(255, 60, 60)
        TweenService:Create(keyBox, TweenInfo.new(0.1), {Position = UDim2.new(0.5, -135, 0, 110)}):Play()
        task.wait(0.1)
        TweenService:Create(keyBox, TweenInfo.new(0.1), {Position = UDim2.new(0.5, -125, 0, 110)}):Play()
        task.wait(0.1)
        TweenService:Create(keyBox, TweenInfo.new(0.1), {Position = UDim2.new(0.5, -130, 0, 110)}):Play()
        task.wait(0.5)
        keyStroke.Color = CONFIG.COR_PRIMARIA
        errorLabel.Text = ""
    end
end)

--// MINIMIZAR / RESTAURAR
minimBtn.MouseButton1Click:Connect(function()
    Hub.Visible = false
    FloatingBall.Visible = true
end)

FloatingBall.MouseButton1Click:Connect(function()
    FloatingBall.Visible = false
    Hub.Visible = true
end)

--// FECHAR
closeBtn.MouseButton1Click:Connect(function()
    Hub.Visible = false
    FloatingBall.Visible = true
    local confirm = criar("Frame", {
        Size = UDim2.new(0, 220, 0, 100),
        Position = UDim2.new(0.5, -110, 0.5, -50),
        BackgroundColor3 = CONFIG.COR_PAINEL,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ZIndex = 30,
    })
    arredondar(confirm, 12)
    sombra(confirm)

    criar("TextLabel", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Text = "Deseja realmente fechar?",
        TextColor3 = CONFIG.COR_TEXTO,
        Font = CONFIG.FONTE,
        TextSize = 13,
        Parent = confirm,
        ZIndex = 31,
    })

    local sim = criar("TextButton", {
        Size = UDim2.new(0, 90, 0, 32),
        Position = UDim2.new(0, 15, 0, 55),
        BackgroundColor3 = Color3.fromRGB(200, 40, 40),
        BorderSizePixel = 0,
        Text = "SIM",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = CONFIG.FONTE_BOLD,
        TextSize = 12,
        Parent = confirm,
        ZIndex = 31,
    })
    arredondar(sim, 8)

    local nao = criar("TextButton", {
        Size = UDim2.new(0, 90, 0, 32),
        Position = UDim2.new(1, -105, 0, 55),
        BackgroundColor3 = CONFIG.COR_PRIMARIA,
        BorderSizePixel = 0,
        Text = "NÃO",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = CONFIG.FONTE_BOLD,
        TextSize = 12,
        Parent = confirm,
        ZIndex = 31,
    })
    arredondar(nao, 8)

    sim.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    nao.MouseButton1Click:Connect(function() confirm:Destroy() end)
end)
