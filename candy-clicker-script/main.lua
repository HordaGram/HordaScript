-- ====================================================================
-- НАЧАЛО ФАЙЛА MAIN.LUA (ЗАГРУЗИТЕ ЭТОТ КОД НА GITHUB В MAIN.LUA)
-- ====================================================================

-- Удаление старого интерфейса, если он уже запущен в игре
if game.CoreGui:FindFirstChild("CandyChocolateGui") then 
    game.CoreGui.CandyChocolateGui:Destroy() 
end

-- Создание основы ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CandyChocolateGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Глобальная таблица настроек (Config), к которой будут обращаться модули
getgenv().Config = {
    AutoRun = false, WinTargetW1 = "Lvl 1", WinTargetW2 = "Lvl 1", AutoFarmWins = false,
    TweenSpeed = 50, AutoRebirth = false, FreezePosition = false, SelectedAura = "None",
    AutoBuyAura = false, SelectedItem = "None", AutoBuyItem = false, AutoRestockRobux = false, AntiAFK = false
}

-- ГЛАВНОЕ ОКНО ИНТЕРФЕЙСА
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- ШАПКА МЕНЮ (ДЛЯ ПЕРЕТАСКИВАНИЯ)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "Candy & Chocolate Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

-- КНОПКА ЗАКРЫТИЯ (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Header

-- КНОПКА ОТКРЫТИЯ (OPEN)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
OpenBtn.Text = "Open"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 14
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)

-- СИСТЕМА DRAG & DROP (ПЕРЕТАСКИВАНИЕ МЫШКОЙ ИЛИ ПАЛЬЦЕМ)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- БОКОВАЯ ПАНЕЛЬ С КНОПКАМИ ВКЛАДОК
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SideBar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.Parent = SideBar

-- ОСНОВНОЙ КОНТЕЙНЕР ДЛЯ СТРАНИЦ ВКЛАДОК
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -150, 1, -50)
Container.Position = UDim2.new(0, 145, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 500)
    Page.ScrollBarThickness = 4
    Page.Visible = false
    Page.Parent = Container
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = Page
    
    pages[name] = Page
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 120, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.Parent = SideBar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    return Page
end

-- ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ: ТУМБЛЕРЫ (TOGGLES)
local function AddToggle(parent, text, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Frame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 250, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -55, 0, 9)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Frame
    
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(1, 0)
    TCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 3, 0, 3)
    Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Circle.Parent = ToggleBtn
    
    local CCorner = Instance.new("UICorner")
    CCorner.CornerRadius = UDim.new(1, 0)
    CCorner.Parent = Circle
    
    local active = false
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        getgenv().Config[configKey] = active
        if active then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            Circle.Position = UDim2.new(1, -19, 0, 3)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            Circle.Position = UDim2.new(0, 3, 0, 3)
        end
        callback(active)
    end)
end

-- ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ: КНОПКИ (BUTTONS)
local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 105, 190)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
end

-- СОЗДАНИЕ СТРАНИЦ
local PageAuto = CreatePage("Automatically")
local PageAura = CreatePage("Select Aura")
local PageShop = CreatePage("TAB Shop")
local PageMisc = CreatePage("TAB Misc")
pages["Automatically"].Visible = true

-- ====================================================================
-- ДИНАМИЧЕСКАЯ ЗАГРУЗКА ТРЕХ ВАШИХ МОДУЛЕЙ С GITHUB
-- ====================================================================

local AutoModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/HordaGram/HordaScript/refs/heads/main/candy-clicker-script/auto.lua"))()
AutoModule.Load(PageAuto, AddToggle, AddButton, getgenv().Config)

local ShopModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/HordaGram/HordaScript/refs/heads/main/candy-clicker-script/misc.lua"))()
ShopModule.Load(PageAura, PageShop, AddToggle, AddButton, getgenv().Config)

local MiscModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/HordaGram/HordaScript/refs/heads/main/candy-clicker-script/shop.lua"))()
MiscModule.Load(PageMisc, AddToggle, AddButton, getgenv().Config)


-- ====================================================================
-- КОНЕЦ ФАЙЛА MAIN.LUA
-- ====================================================================
