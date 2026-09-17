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
