local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local isAdmin = player.Name == "Melouxis"

local blacklist = {
    "prizz", "pladmin", "dex", "infiniteyield", "remote spy", "rspy",
    "https://raw.githubusercontent.com/devguy100/PrizzLife/main/pladmin.lua",
    "loadstring", "esp", "aimbot", "fly", "noclip", "kill all", "kill",
    ":fly", ":kill", ":noclip", ":speed", ":cmds", "silentaim", "triggerbot", "reach", "hitbox"
}

StarterGui:SetCore("SendNotification", {
    Title = "Anti-Cheat Activé",
    Text = "Votre code est surveillé. Toute triche sera détectée.",
    Duration = 5
})

if isAdmin then
    StarterGui:SetCore("SendNotification", {
        Title = "Système Anti-Cheat chargé",
        Text = "Surveillance activée.",
        Duration = 6
    })
end

local function scanDescendants()
    player.DescendantAdded:Connect(function(obj)
        for _, keyword in pairs(blacklist) do
            if obj.Name:lower():find(keyword:lower()) then
                StarterGui:SetCore("SendNotification", {
                    Title = "Triche détectée",
                    Text = "Objet suspect : " .. obj.Name,
                    Duration = 5
                })
                warn("[ANTICHEAT] Objet injecté : " .. obj.Name)
            end
        end
    end)
end

local function watchChat()
    player.Chatted:Connect(function(msg)
        for _, keyword in pairs(blacklist) do
            if msg:lower():find(keyword:lower()) then
                StarterGui:SetCore("SendNotification", {
                    Title = "Commande interdite",
                    Text = "Message suspect : " .. msg,
                    Duration = 5
                })
                warn("[ANTICHEAT] Commande détectée : " .. msg)
            end
        end
    end)
end

local function monitorStats()
    player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            RunService.Heartbeat:Connect(function()
                if hum.WalkSpeed > 20 or hum.JumpPower > 55 then
                    StarterGui:SetCore("SendNotification", {
                        Title = "Stats Anormales",
                        Text = "WalkSpeed ou JumpPower modifié",
                        Duration = 5
                    })
                    warn("[ANTICHEAT] Stats suspectes : WalkSpeed=" .. hum.WalkSpeed .. " JumpPower=" .. hum.JumpPower)
                end
            end)
        end
    end)
end

scanDescendants()
watchChat()
monitorStats()
