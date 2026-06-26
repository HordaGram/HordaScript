-- Модуль: Misc
local Module = {}

function Module.Load(Page, AddToggle, AddButton, Config)
    AddToggle(Page, "[+] Anti AFK", "AntiAFK", function(val)
        if val then
            local vu = game:GetService("VirtualUser")
            game.Players.LocalPlayer.Idled:Connect(function()
                if Config.AntiAFK then
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
            print("Anti-AFK успешно активирован")
        end
    end)
end

return Module
