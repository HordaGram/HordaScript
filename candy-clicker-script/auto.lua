local Module = {}
function Module.Load(Page, AddToggle, AddButton, Config)
    
    -- Глобальные настройки для спидбуста, если их забыли объявить в main
    if not Config.SpeedBoostValue then Config.SpeedBoostValue = 16 end
    if not Config.UseSpeedBoost then Config.UseSpeedBoost = false end

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

    -- [НАСТРОЙКА СКОРОСТИ БЕГА (SPEEDBOOST)]
    AddToggle(Page, "[+] Enable SpeedBoost", "UseSpeedBoost", function(val)
        -- Постоянно удерживаем скорость, пока включен тумблер
        task.spawn(function()
            while Config.UseSpeedBoost do
                local plr = game.Players.LocalPlayer
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    plr.Character.Humanoid.WalkSpeed = Config.SpeedBoostValue
                end
                task.wait(0.1)
            end
            -- Когда выключаем тумблер — возвращаем стандартную скорость Roblox (16)
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = 16
            end
        end)
    end)

    -- Кнопка быстрой настройки ползунка скорости (Delta UI Slider)
    AddButton(Page, "[+] Set Speed: 100 (Fast)", function()
        Config.SpeedBoostValue = 100
        if Config.UseSpeedBoost then
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = 100
            end
        end
        print("Скорость выставлена на 100")
    end)

    AddButton(Page, "[+] Set Speed: 500 (Sonic)", function()
        Config.SpeedBoostValue = 500
        if Config.UseSpeedBoost then
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = 500
            end
        end
        print("Скорость выставлена на 500")
    end)

    AddButton(Page, "[+] Reset Speed to Normal", function()
        Config.SpeedBoostValue = 16
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 16
        end
        print("Скорость сброшена")
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
end
return Module
