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

    -- [ФАРМ 14 ЭТАПА — РЯДОМ С МЕТКОЙ]
    AddToggle(Page, "[+] Auto Farm Wins", "AutoFarmWins", function(val)
        task.spawn(function()
            while Config.AutoFarmWins do
                local plr = game.Players.LocalPlayer
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    
                    local targetPad = nil
                    
                    -- Строгий поиск: Ищем именно 14 этап
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local name = obj.Name:lower()
                            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                            
                            -- Проверяем, чтобы в названии было "14", но исключаем "140" и т.д.
                            if (name:find("14") or parentName:find("14")) and not name:find("140") then
                                -- Ищем именно финишный триггер этапа (Win, Pad, Finish, Touch, End)
                                if name:find("win") or name:find("pad") or name:find("finish") or name:find("touch") or name:find("end") then
                                    targetPad = obj
                                    break
                                end
                            end
                        end
                    end
                    
                    -- Если 14 этап по имени не нашелся, используем поиск самой дальней зоны на карте (14 уровень всегда в конце)
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

                    -- Логика телепортации РЯДОМ с меткой
                    if targetPad then
                        -- Телепортируем на 4 ступени НАЗАД и чуть ВЫШЕ плиты, чтобы вы не коснулись её сразу
                        -- Vector3.new(0, 3, 4) создает идеальный задел для ручного шага
                        plr.Character.HumanoidRootPart.CFrame = targetPad.CFrame * CFrame.new(0, 3, 4)
                    end
                end
                
                -- Задержка 1.5 секунды, чтобы вы успели наступить, забрать кубки и сервер обновил ваш баланс
                task.wait(1.5) 
            end
        end)
    end)

    -- [АВТО-РЕБЁРТХ]
    AddToggle(Page, "[+] Auto Rebirth", "AutoRebirth", function(val)
        task.spawn(function()
            while Config.AutoRebirth do
                for _, v in pairs(game:GetService("Reendants") or game:GetService("ReplicatedStorage"):GetDescendants()) do
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
