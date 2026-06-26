local Module = {}
function Module.Load(Page, AddToggle, AddButton, Config)
    
    -- [АВТОКЛИКЕР СКОРОСТИ]
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
                    
                    -- Строгий перебор всей карты для поиска ТОЧНОГО 14 этапа
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local name = obj.Name:lower()
                            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                            
                            -- Ищем признаки финиша (win, pad, finish, zone, stage)
                            if name:find("win") or name:find("pad") or name:find("finish") or name:find("zone") or name:find("stage") then
                                -- Вытаскиваем только цифры из названия объекта или его папки
                                local stageNum1 = name:gsub("%D", "")
                                local stageNum2 = parentName:gsub("%D", "")
                                
                                -- Проверяем, чтобы цифра была строго равна 14 (не 1, не 6, не 140)
                                if stageNum1 == "14" or stageNum2 == "14" then
                                    targetPad = obj
                                    break
                                end
                            end
                        end
                    end
                    
                    -- Если по именам ничего не нашлось, используем резервный метод (самая высокая/дальняя точка 14 этапа)
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

                    -- Телепортация персонажа РЯДОМ с меткой (на землю/в воздух перед ней)
                    if targetPad then
                        -- Относительное смещение: 3 шага вверх, 5 шагов назад, чтобы вы не коснулись её автоматически
                        plr.Character.HumanoidRootPart.CFrame = targetPad.CFrame * CFrame.new(0, 3, 5)
                    end
                end
                
                -- Задержка 2.5 секунды. Этого времени хватит, чтобы вы упали, сделали шаг, 
                -- забрали кубки и сервер успел сохранить ваш баланс.
                task.wait(2.5) 
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
