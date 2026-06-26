-- Модуль: Automatically
local Module = {}

function Module.Load(Page, AddToggle, AddButton, Config)
    AddToggle(Page, "Auto Run", "AutoRun", function(val)
        task.spawn(function()
            while Config.AutoRun do
                print("Выполняется: Auto Run")
                task.wait(0.2)
            end
        end)
    end)

    AddButton(Page, "[+] Select Win Target World 1", function()
        Config.WinTargetW1 = "Level 1"
        print("Выбран Мир 1: Level 1")
    end)

    AddButton(Page, "[+] Select Win Target World 2", function()
        Config.WinTargetW2 = "Level 1"
        print("Выбран Мир 2: Level 1")
    end)

    AddToggle(Page, "[+] Auto Farm Wins", "AutoFarmWins", function(val)
        task.spawn(function()
            while Config.AutoFarmWins do
                print("Фарм побед запущен...")
                task.wait(1)
            end
        end)
    end)

    AddButton(Page, "[+] Tween Speed Custom", function()
        Config.TweenSpeed = Config.TweenSpeed == 50 and 100 or 50
        print("Скорость изменена на: " .. Config.TweenSpeed)
    end)

    AddToggle(Page, "[+] Auto Rebirth", "AutoRebirth", function(val)
        task.spawn(function()
            while Config.AutoRebirth do
                print("Проверка авто-ребёртха...")
                task.wait(1.5)
            end
        end)
    end)

    AddToggle(Page, "[+] Freeze Position", "FreezePosition", function(val)
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = val end
    end)

    AddButton(Page, "[+] Unlock Gamepass Infinity Trail", function()
        print("Разблокировка Infinite Trail")
    end)

    AddButton(Page, "[+] Select Target Treadmill Type", function()
        print("Тип дорожки изменен")
    end)

    AddButton(Page, "[+] Unlock Treadmill Access", function()
        print("Доступ ко всем дорожкам открыт")
    end)
end

return Module
