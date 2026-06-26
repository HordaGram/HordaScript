local Module = {}
function Module.Load(Page, AddToggle, AddButton, Config)
    -- Реальный автофарм кликов/бега для симулятора
    AddToggle(Page, "Auto Run", "AutoRun", function(val)
        task.spawn(function()
            while Config.AutoRun do
                -- Отправка серверного события клика/генерации скорости
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ClickRem") or game:GetService("ReplicatedStorage"):FindFirstChild("Click") or game:GetService("ReplicatedStorage"):FindFirstChild("AddSpeed")
                if remote then 
                    remote:FireServer() 
                else
                    -- Альтернативный метод: если это кликер через инструмент
                    local plr = game.Players.LocalPlayer
                    if plr.Character and plr.Character:FindFirstChildOfClass("Tool") then
                        plr.Character:FindFirstChildOfClass("Tool"):Activate()
                    end
                end
                task.wait(0.01) -- Максимальная скорость клика без кика
            end
        end)
    end)

    -- Авто-Фарм Побед (Телепорт по мирам к финишу)
    AddToggle(Page, "[+] Auto Farm Wins", "AutoFarmWins", function(val)
        task.spawn(function()
            while Config.AutoFarmWins do
                local plr = game.Players.LocalPlayer
                -- Поиск финишной черты или портала победы на карте
                local winsZone = workspace:FindFirstChild("WinsZone") or workspace:FindFirstChild("Finish") or workspace:FindFirstChild("WinPad")
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and winsZone then
                    -- Плавный или мгновенный перенос к финишу
                    plr.Character.HumanoidRootPart.CFrame = winsZone:GetModelCFrame() or winsZone.CFrame
                end
                task.wait(0.5)
            end
        end)
    end)

    -- Авто-Ребёртх (Перерождение)
    AddToggle(Page, "[+] Auto Rebirth", "AutoRebirth", function(val)
        task.spawn(function()
            while Config.AutoRebirth do
                local rebirthRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or game:GetService("ReplicatedStorage"):FindFirstChild("RebirthRequest")
                if rebirthRemote then
                    rebirthRemote:FireServer(1) -- Цифра 1 означает количество перерождений за раз
                end
                task.wait(1)
            end
        end)
    end)

    -- Заморозка позиции (уже работала, оставляем)
    AddToggle(Page, "[+] Freeze Position", "FreezePosition", function(val)
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = val end
    end)
    
    -- Кнопки-заглушки (информационные)
    AddButton(Page, "Select Win Target: World 1", function() print("Target set to World 1") end)
    AddButton(Page, "Select Win Target: World 2", function() print("Target set to World 2") end)
end
return Module
