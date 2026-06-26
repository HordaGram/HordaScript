local Module = {}
function Module.Load(Page, AddToggle, AddButton, Config)
    
    -- [ФУНКЦИЯ АВТОРАНА]
    AddToggle(Page, "Auto Run", "AutoRun", function(val)
        task.spawn(function()
            while Config.AutoRun do
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ClickRem") or game:GetService("ReplicatedStorage"):FindFirstChild("Click") or game:GetService("ReplicatedStorage"):FindFirstChild("AddSpeed")
                if remote then 
                    remote:FireServer() 
                else
                    local plr = game.Players.LocalPlayer
                    if plr.Character and plr.Character:FindFirstChildOfClass("Tool") then
                        plr.Character:FindFirstChildOfClass("Tool"):Activate()
                    end
                end
                task.wait(0.01)
            end
        end)
    end)

    -- [БЕЗБАГОВЫЙ ФАРМ ПОБЕД (14 ЭТАП)]
    AddToggle(Page, "[+] Auto Farm Wins", "AutoFarmWins", function(val)
        task.spawn(function()
            while Config.AutoFarmWins do
                local plr = game.Players.LocalPlayer
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    
                    -- Ищем плиту финиша, которая относится к 14 этапу (Stage 14 / Zone 14)
                    local targetPad = nil
                    
                    -- Ищем по всей карте плиту с цифрой 14 или именем "14"
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:find("14") or (obj.Parent and obj.Parent.Name:find("14"))) then
                            -- Проверяем, что это финишная зона/чекпоинт (обычно содержит в имени Win, Pad, Touch, Finish или Line)
                            local name = obj.Name:lower()
                            if name:find("win") or name:find("pad") or name:find("touch") or name:find("finish") or name:find("part") then
                                targetPad = obj
                                break
                            end
                        end
                    end
                    
                    -- Если точную плиту "14" не нашли, берем общую логику поиска самой дальней победной зоны
                    if not targetPad then
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("finish")) then
                                targetPad = obj
                            end
                        end
                    end

                    -- Самый стабильный метод забора победы БЕЗ БАГОВ:
                    if targetPad then
                        -- 1. Сначала подтягиваем персонажа чуть ближе к зоне (чтобы сервер поверил)
                        plr.Character.HumanoidRootPart.CFrame = targetPad.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.05)
                        
                        -- 2. Симулируем идеальный физический нажим на плиту (0 - коснулся, 1 - убрал ногу)
                        firetouchinterest(plr.Character.HumanoidRootPart, targetPad, 0)
                        task.wait(0.05)
                        firetouchinterest(plr.Character.HumanoidRootPart, targetPad, 1)
                    end
                end
                -- Задержка между кругами фарма (0.3 сек идеальна, чтобы игра успевала выдавать кубки)
                task.wait(0.3) 
            end
        end)
    end)

    -- [АВТО-РЕБЁРТХ]
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

    -- [ЗАМОРОЗКА]
    AddToggle(Page, "[+] Freeze Position", "FreezePosition", function(val)
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = val end
    end)
    
    AddButton(Page, "Select Win Target: World 1", function() print("Target World 1") end)
    AddButton(Page, "Select Win Target: World 2", function() print("Target World 2") end)
end
return Module
