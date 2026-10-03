--[[
    PoC: Race State Manipulation

    Demonstra o uso direto de RemoteEvents relacionados à corrida.
    O objetivo é testar se o servidor valida corretamente essas
    solicitações enviadas pelo cliente.
]]

local modeRemote =
    game.ReplicatedStorage:FindFirstChild("StandingsModeEvent")

local settingsRemote =
    game.ReplicatedStorage:FindFirstChild("StandingsSettingsEvent")


-- Testa a alteração da quantidade de voltas da corrida.
if settingsRemote then
    pcall(function()
        settingsRemote:FireServer("Laps", 999)

        print("[+] Race settings request sent: Laps = 999")
    end)
end


-- Testa a alteração direta do estado da corrida.
if modeRemote then
    pcall(function()
        modeRemote:FireServer("EndRace")

        print("[+] Race state request sent: EndRace")
    end)
end