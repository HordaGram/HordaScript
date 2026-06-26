local Module = {}
function Module.Load(PageAura, PageShop, AddToggle, AddButton, Config)
    -- Авто-покупка Аур/Яиц
    AddToggle(PageAura, "[+] Auto Buy Aura/Egg", "AutoBuyAura", function(val)
        task.spawn(function()
            while Config.AutoBuyAura do
                -- Ищет удаленное событие для покупки питомца/ауры
                local buyRemote = game:GetService("ReplicatedStorage"):FindFirstChild("BuyEgg") or game:GetService("ReplicatedStorage"):FindFirstChild("OpenEgg") or game:GetService("ReplicatedStorage"):FindFirstChild("BuyAura")
                if buyRemote then
                    -- Отправляем запрос на покупку стартовой или выбранной ауры
                    buyRemote:FireServer("Common", false) -- Измените "Common" на нужный тип яйца
                end
                task.wait(0.5)
            end
        end)
    end)

    -- Экипировка лучшего
    AddButton(PageAura, "[+] Auto Equip Best", function()
        local equipRemote = game:GetService("ReplicatedStorage"):FindFirstChild("EquipBest") or game:GetService("ReplicatedStorage"):FindFirstChild("AutoEquip")
        if equipRemote then
            equipRemote:FireServer()
        end
    end)

    -- Авто-покупка предметов из магазина
    AddToggle(PageShop, "[+] Auto Buy Item", "AutoBuyItem", function(val)
        task.spawn(function()
            while Config.AutoBuyItem do
                local shopRemote = game:GetService("ReplicatedStorage"):FindFirstChild("BuyItem") or game:GetService("ReplicatedStorage"):FindFirstChild("ShopBuy")
                if shopRemote then
                    shopRemote:FireServer("Chocolate")
                end
                task.wait(1)
            end
        end)
    end)
end
return Module
