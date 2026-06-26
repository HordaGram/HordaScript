-- Модуль: Aura & Shop
local Module = {}

function Module.Load(PageAura, PageShop, AddToggle, AddButton, Config)
    -- Раздел Аур
    AddButton(PageAura, "[+] Select Aura Dropdown", function()
        Config.SelectedAura = "Common Aura"
        print("Выбрана аура: " .. Config.SelectedAura)
    end)

    AddToggle(PageAura, "[+] Buy Aura", "AutoBuyAura", function(val)
        task.spawn(function()
            while Config.AutoBuyAura do
                print("Покупка ауры: " .. Config.SelectedAura)
                task.wait(2)
            end
        end)
    end)

    AddButton(PageAura, "[+] Equip Aura", function()
        print("Надета аура: " .. Config.SelectedAura)
    end)

    AddButton(PageAura, "[+] Auto Equip Best Item", function()
        print("Экипированы лучшие предметы")
    end)

    -- Раздел Магазина
    AddButton(PageShop, "[+] Select Target Item", function()
        Config.SelectedItem = "Item 1"
        print("Выбран предмет: " .. Config.SelectedItem)
    end)

    AddToggle(PageShop, "[+] Auto Buy Item", "AutoBuyItem", function(val)
        task.spawn(function()
            while Config.AutoBuyItem do
                print("Покупка предмета...")
                task.wait(1)
            end
        end)
    end)

    AddToggle(PageShop, "[+] Auto Restock Item (Robux)", "AutoRestockRobux", function(val)
        if val then print("Внимание: Активирована закупка за Робуксы!") end
    end)
end

return Module
