local Module = {}
function Module.Load(Page, AddToggle, AddButton, Config)
    
    -- [АВТОКЛИКЕР]
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

    -- [ИСПРАВЛЕННЫЙ БЕЗБАГОВЫЙ ФАРМ ДЛЯ 14 ЭТАПА]
    AddToggle(Page, "[+] Auto Farm Wins", "AutoFarmWins", function(val)
        task.spawn(function()
            while Config.AutoFarmWins do
                local plr = game.Players.LocalPlayer
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    
                    local targetPad = nil
                    
                    -- Сначала ищем в папке уровней (Clone Engine стандарт)
                    local levels = workspace:FindFirstChild("Levels") or workspace:FindFirstChild("Stages") or workspace:FindFirstChild("Worlds")
                    local searchArea = levels and levels:GetDescendants() or workspace:GetDescendants()
                    
                    -- Строгий поиск: ищем объект, у которого в имени есть ТОЧНО "14" (а не просто единица)
                    for _, obj in pairs(searchArea) do
                        if obj:IsA("BasePart") then
                            local name = obj.Name:lower()
                            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                            
                            -- Проверяем, относится ли парт к 14 этапу и является ли он финишем
                            if (name:find("14") or parentName:find("14")) and not name:find("140") then
                                if name:find("win") or name:find("pad") or name:find("finish") or name:find("touch") or name:find("teleport") then
                                    targetPad = obj
                                    break
                                end
                            end
                        end
                    end
                    
                    -- Если точный 14 не найден по имени, берем самый дальний чекпоинт от спавна
                    if not targetPad then
                        local maxDist = 0
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("win") or obj.Name:lower():find("finish")) then
                                local dist = (obj.Position - Vector3.new(0,0,0)).Magnitude
                                if dist > maxDist then
                                    maxDist = dist
                                    targetPad = obj
                                end
                            end
                        end
                    end

                    -- Мгновенная отправка пакета касания БЕЗ ожидания task.wait()
                    if targetPad then
                        -- Жесткий телепорт прямо внутрь плиты
                        plr.Character.HumanoidRootPart.CFrame = targetPad.CFrame
                        
                        -- Мгновенный спам touch-события (сервер засчитывает победу сразу)
                        firetouchinterest(plr.Character.HumanoidRootPart, targetPad, 0)
                        firetouchinterest(plr.Character.HumanoidRootPart, targetPad, 1)
                    end
                end
                -- Задержка цикла — 0.1 секунды для максимальной скорости получения кубков
                task.wait(0.1) 
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
                task.wait(0.5)
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
