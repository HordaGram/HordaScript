-- Этот кусок кода находится в самом низу вашего файла main.lua на GitHub:
local AutoModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/HordaGram/HordaScript/refs/heads/main/candy-clicker-script/auto.lua"))()
AutoModule.Load(PageAuto, AddToggle, AddButton, getgenv().Config)

local ShopModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/HordaGram/HordaScript/refs/heads/main/candy-clicker-script/misc.lua"))()
ShopModule.Load(PageAura, PageShop, AddToggle, AddButton, getgenv().Config)

local MiscModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/HordaGram/HordaScript/refs/heads/main/candy-clicker-script/shop.lua"))()
MiscModule.Load(PageMisc, AddToggle, AddButton, getgenv().Config)
