local Module = {}
function Module.Load(Page, AddToggle, AddButton, Config)
    -- Универсальный умный автокликер скорости
    AddToggle(Page, "Auto Run", "AutoRun", function(val)
        task.spawn(function()
            while Config.AutoRun do
                -- Автоматический поиск любого RemoteEvent, связанного с кликами/скоростью
                local found = false
                for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("click") or v.Name:lower():find("speed") or v.Name:lower():find("gain")) then
                        v:FireServer()
                        found = true
                    end
                end
                -- Если скрытых событий нет, кликаем инструментом в руках персонажа
                if not found then
                    local plr = game.Players.LocalPlayer
                    if plr.Character and plr.Character:FindFirstChildOfClass("Tool") then
                        plr.Character:FindFirstChildOfClass("Tool"):Activate()
                    end
                end
                task.wait(0.01)
            end
        end)
    end)

    -- Автофарм побед через поиск порталов/триггеров финиша на карте
    AddToggle(Page, "[+] Auto Farm Wins", "AutoFarmWins", function(val)
        task.spawn(function()
            while Config.AutoFarmWins do
                local plr = game.Players.LocalPlayer
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    -- Ищем зоны финиша, дверей или победных платформ по ключевым словам
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("finish") or obj.Name:lower():find("end")) then
                            plr.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            break
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end)

    -- Авто-Ребёртх с перебором событий
    AddToggle(Page, "[+] Auto Rebirth", "AutoRebirth", function(val)
        task.spawn(function()
            while Config.AutoRebirth do
                for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if v:IsA("RemoteEvent") and v.Name:lower():find("rebirth") then
                        v:FireServer(1)
                    end
                end
                task.wait(1)
            end
        end)
    end)

    -- Заморозка
    AddToggle(Page, "[+] Freeze Position", "FreezePosition", function(val)
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = val end
    end)
end
return Module
