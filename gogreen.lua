--[[
CREDITS TO
- ORGINIAL SCRIPT: https://raw.githubusercontent.com/ImFloriz/Roblox/refs/heads/main/Amber/Washiez.luau
by github.com/imfloriz - https://guns.lol/bb - realestfloriz on discord
]]--



-- please no magik or rosploiter
-- theres nothing to patch about this anyways

if queue_on_teleport then queue_on_teleport(`loadstring(game:HttpGet("https://raw.githubusercontent.com/ImFloriz/Roblox/refs/heads/main/Amber/Washiez.luau"))()`) end

getgenv().Amber = {
    rjow = false,
    flaura = {
        Enabled = false,
        Visualize = false
    },
    plrNotifier = false,
    rjohr = false
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RayfieldUI = Rayfield:CreateWindow({
    Name = "imfloriz.github.io/amber",
    Icon = 0,
    LoadingTitle = "amber",
    LoadingSubtitle = "imfloriz.github.io/amber",
    Theme = "Serenity",
    DisableBuildWarnings = true,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "floriz",
       FileName = "amber"
    }
})

local AmberW = {}
AmberW.Info = RayfieldUI:CreateTab("Info", "info")
AmberW.Player = RayfieldUI:CreateTab("User", "user")
AmberW.Players = RayfieldUI:CreateTab("Players", "users")
AmberW.Vehicle = RayfieldUI:CreateTab("Car", "car")
AmberW.Misc = RayfieldUI:CreateTab("Misc", "cog")

-- Init
local players = game:GetService("Players")
local player = players.LocalPlayer

function chat(msg)
    if msg == "" then return end

    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
end

function join(jobid)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid)
end

function rj(hop)
    if hop then
		local res = request({
			Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .."/servers/Public?limit=100&excludeFullGames=true"
		})
		local body = game:GetService("HttpService"):JSONDecode(res.Body)

		local jobIds = {}

		if not body or not body.data then return end

		for i, v in pairs(body.data) do
			if v.id and v.id ~= game.JobId then
				table.insert(jobIds, v.id)
			end
		end

		if #jobIds <= 1 then return end

		join(jobIds[math.random(1 ,#jobIds)])
    else
        join(game.JobId)
    end
end

function GetData(player: Player)
    local GroupInfo = player:WaitForChild("GroupInfo")
        local _Rank = GroupInfo.Rank.Value
        local _Role = GroupInfo.Role.Value
    local Warnings = player:WaitForChild("Warnings")
        local _Warns = Warnings.WarningNumber.Value
    local PlrStats = player:WaitForChild("plrStats")
        local _Jails = PlrStats.Jail.JailSentences.Value
        local _Coins = PlrStats.Coins.Value
        local _Skill = PlrStats.Skill.Value
    
    local _Gamepasses = {}

    for i, v in pairs(PlrStats.Gamepasses:GetChildren()) do
        _Gamepasses[v.Name] = {
            Owned = v.Value,
            Price = 0 -- TODO: do this
        }
    end

    local _ChatPresets = {}

    for i, v in pairs(PlrStats.ChatPresets:GetChildren()) do
        table.insert(_ChatPresets, v.Value == "<none>" and "" or v.Value)
    end

        
    return {
        ["Rank"] = _Rank,
        ["Role"] = _Role,
        ["Warns"] = _Warns,
        ["Jails"] = _Jails,
        ["Coins"] = _Coins,
        ["Skill"] = _Skill,
        ["Gamepasses"] = _Gamepasses,
        ["ChatPresets"] = _ChatPresets
    }
end

function notify(txt, dur)
    Rayfield:Notify({
        Title = "Amber",
        Content = txt,
        Duration = dur or 4,
        Image = "flame"
    })
end


local power = 340 -- 350
-- Training center
if game.PlaceId == 6868593153 then power = 1e5 end

function attack(target)
    local char = game:GetService("Players").LocalPlayer.Character

    if not char or not char:FindFirstChild("Humanoid") then return end
    if char.Humanoid.Health <= 0 then return end
            
    local HumanoidRootPart: BasePart = char:FindFirstChild("HumanoidRootPart")
    local st = tick()

    local x = -4

    while tick() - st < 1.7 do
        x += 1
        if x > 14 then x = -4 end
        HumanoidRootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, x, 0)) * CFrame.Angles(90, 0, 90)
        task.wait()
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.one * ((power / 3) - (8 + (math.random() * 3)))  -- fuck you magik, rosploiter and sus.

        game:GetService("RunService").Heartbeat:Wait()
    end
end


task.spawn(function()
    while task.wait(0.3) do
        if getgenv().Amber.rjow then
            local warn = GetData(player).Warns

            if warn == 3 then
                notify("3 warnings, rejoining!", 2)
                rj()
                task.wait(0.4) -- if rj somehow fails? probably wouldn't
            end
        end
    end
end)

-- Connections
if getgenv().__FUN_RCh then getgenv().__FUN_RCh:Disconnect() end
if getgenv().__FUN_RCa then getgenv().__FUN_RCh:Disconnect() end

-- trashiez
local Washiez = {}
function Washiez:GetPlayer() return game:GetService("Players").LocalPlayer end
function Washiez:GetVehicle()
    for i, v in pairs(workspace.SpawnedCars:GetChildren()) do
        if v.Name:match("^" .. Washiez:GetPlayer().Name .. "\-") then return v end
    end

    return nil
end
function Washiez:GetNTag()
    return workspace.Nametags:FindFirstChild(Washiez:GetPlayer().Name)
end
do -- Info
    local self = AmberW.Info

    local Guests = self:CreateLabel("Guests, customers: %"      , "user")
    local Trainees = self:CreateLabel("Trainees: %"      , "user-check")
    local ET = self:CreateLabel("Entry Team: %"      , "shield-check")
    local ST = self:CreateLabel("Supervision Team: %", "shield-ellipsis")
    local MT = self:CreateLabel("Management Team: %" , "shield-alert")
    local CT = self:CreateLabel("Corporate Team: %"  , "shield-ban")
    local LT = self:CreateLabel("Leadership Team: %" , "shield-x")

    -- smart way, i think
    local ranks = {
        --[?T]   = {"TeamName",  first rank id, amount}
        [Guests] = {"Guests, customers",{0,1,10,11},false},
        [Trainees] = {"Trainees",{20},false},
        [ET] = {"Entry", {30,40,50},true},
        [ST] = {"Supervision", {60,70,90,100},true},
        [MT] = {"Management",{110,115,117},true},
        [CT] = {"Corporate",{120,125,130,140},true},
        [LT] = {"Leadership",{145,150,160,170,173,180,255},true} -- Automation included lol
    }

    for team, v in pairs(ranks) do
        -- [1] = team name
        -- [2] = rank id
        task.spawn(function()
            while task.wait(2) do
                task.spawn(function()
                    local amnt = 0

                    for i, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if table.find(v[2],player:WaitForChild("GroupInfo").Rank.Value) then
                            amnt += 1
                        end
                    end

                    team:Set(v[1] .. (v[3] and " Team: " or ": ") .. amnt)
                end)
            end
        end)
    end

    game:GetService("Players").PlayerAdded:Connect(function(player: Player)
        local name = player.Name
        local display = player.DisplayName
        local rankId = player:WaitForChild("GroupInfo").Rank.Value
        local rankName = player:WaitForChild("GroupInfo").Role.Value

        if rankId >= 110 and getgenv().Amber.rjohr then
            rj(true)
        end

        if not getgenv().Amber.plrNotifier then return end

        notify(display .. "(@" .. name .. ") joined with rank " .. rankName .. "(id " .. rankId .. ")", 3)
    end)

    game:GetService("Players").PlayerRemoving:Connect(function(player: Player)
        if not getgenv().Amber.plrNotifier then return end
        local name = player.Name
        local display = player.DisplayName
        -- i dont need waitforchild here, right
        local rankId = player:WaitForChild("GroupInfo").Rank.Value
        local rankName = player:WaitForChild("GroupInfo").Role.Value

        notify(display .. "(@" .. name .. ") left with rank " .. rankName .. "(id " .. rankId .. ")", 3)
    end)
end

do -- Player
    local self = AmberW.Player
    self:CreateLabel("Username: " .. player.Name)
    self:CreateSection("information")
    task.spawn(function()
        local jails = self:CreateLabel("Jails: " .. GetData(player).Jails)

        task.spawn(function()
            while task.wait(1.2) do
                jails:Set("Jails: " .. GetData(player).Jails) 
            end
        end)
    end)
    self:CreateSection("nametag")

    self:CreateInput({
        Name = "Username",
        CurrentValue = Washiez:GetNTag().Username.Text,
        PlaceholderText = "username",
        RemoveTextAfterLostFocus = false,
        Flag = "player.usert",
        Callback = function(txt)
            local NTag = Washiez:GetNTag()

            NTag.Username.Text = txt
        end
    })

    self:CreateInput({
        Name = "Rank",
        CurrentValue = Washiez:GetNTag().Rank.Text,
        PlaceholderText = "rank",
        RemoveTextAfterLostFocus = false,
        Flag = "player.rankt",
        Callback = function(txt)
            local NTag = Washiez:GetNTag()

            NTag.Rank.Text = txt
        end
    })

    self:CreateInput({
        Name = "Message",
        CurrentValue = Washiez:GetNTag().Message.Text,
        PlaceholderText = "message",
        RemoveTextAfterLostFocus = false,
        Flag = "player.messaget",
        Callback = function(txt)
            local NTag = Washiez:GetNTag()

            NTag.Message.Text = txt
        end
    })

    local userColor = self:CreateColorPicker({
        Name = "Username",
        Color = Color3.fromRGB(255,255,255),
        Flag = "playeraaa.userc",
        Callback = function(clr)
            local NTag = Washiez:GetNTag()

            NTag.Username.TextColor3 = clr
        end
    })

    local rankColor = self:CreateColorPicker({
        Name = "Rank",
        Color = Color3.fromRGB(255,255,255),
        Flag = "playeraaa.rankc",
        Callback = function(clr)
            local NTag = Washiez:GetNTag()

            NTag.Rank.TextColor3 = clr
        end
    })

    local msgColor = self:CreateColorPicker({
        Name = "Message",
        Color = Color3.fromRGB(255,255,255),
        Flag = "playeraaa.messagec",
        Callback = function(clr)
            local NTag = Washiez:GetNTag()

            NTag.Message.TextColor3 = clr
        end
    })

    -- input and toggles run on start, but not color pickers :sob:
    task.spawn(function()
        task.wait(0.3)
        local NTag = Washiez:GetNTag()



        NTag.Username.TextColor3 = userColor.Color
        NTag.Rank.TextColor3 = rankColor.Color
        NTag.Message.TextColor3 = msgColor.Color
    end)



    self:CreateSection("exploits") -- why did i put it in THIS tab, TODO: make another tab as i am a lazy idiot
    self:CreateButton({
        Name = "Fling tool",
        CurrentValue = false,
        Callback = function(v)
            local C2F = Instance.new("Tool", Washiez:GetPlayer():FindFirstChildOfClass("Backpack"))
            C2F.CanBeDropped = true
            C2F.Name = "Fling"
            C2F.RequiresHandle = false
            C2F.Activated:Connect(function()
                pcall(function()
                    local m = Washiez:GetPlayer():GetMouse()
                
                    local t = m.Target

                    if t:GetFullName():find("SpawnedCars.") then
                        attack(t)
                    end
                end)
            end)
        end
    })
end

do -- Players
    local self = AmberW.Players

    -- stupid shit
    local labels = {}
    local cur = 1

    function clear()
        for i, v in pairs(labels) do
            v:Set("...")
        end

        cur = 1
    end
    function ins(txt)
        labels[cur]:Set(txt)
        cur += 1
    end

    local PresetDD = self:CreateDropdown({
        Name = "Send chat preset",
        CurrentOption = {"<none>"},
        Options = {"<none>"},
        MultipleOptions = false,
        Callback = function(msg)
            msg = msg[1]
            if msg == "<none>" or msg == "" then return end

            chat(msg)
        end
    })

    self:CreateInput({
        Name = "Username",
        CurrentValue = "",
        PlaceholderText = "username",
        RemoveTextAfterLostFocus = false,
        Callback = function(txt)
            for i, v in pairs(players:GetPlayers()) do
                if v.Name:lower():match("^"..txt:lower()) then
                    clear()

                    local data = GetData(v)

                    print("kool")

                    ins("Total jails: " .. data.Jails .. " - warning " .. data.Warns)
                    ins("Rank: " .. data.Role)-- .. "(#" .. data.Rank .. ")")
                    ins("---= gamepasses =---")
                    local total = 0
                    for name, data in pairs(data.Gamepasses) do
                        ins((data.Owned and "✅ " or "❌ ") .. name .. (data.Owned and ": " .. data.Price or ""))
                        if data.Owned then
                            total += data.Price
                        end
                    end
                    ins("Total for gamepasses: " .. total)
                    PresetDD:Refresh(data.ChatPresets)
                    break
                end
            end
        end
    })

    for i = 1, 32 do
        table.insert(labels, self:CreateLabel("..."))
    end
end

do -- Vehicle
    local self = AmberW.Vehicle

    local aura = Instance.new("Part")
    aura.Transparency = 1 -- ??? why does 1 HIDE the highlight
    aura.CanCollide = false
    aura.Anchored = true
    aura.Size = Vector3.new(0.4,16,16)
    aura.Shape = Enum.PartType.Cylinder
    aura.Parent = player.Character:WaitForChild("HumanoidRootPart", 20)

    local vis = Instance.new("Highlight")
    vis.FillColor = Color3.fromRGB(171, 84, 120)
    vis.FillTransparency = 0.5
    vis.Enabled = false
    vis.Parent = aura

    self:CreateDivider()
    -- fling aura
    self:CreateToggle({
        Name = "Fling aura",
        CurrentValue = false,
        Callback = function(v)
            getgenv().Amber.flaura.Enabled = v
        end
    })
    self:CreateSlider({
        Name = "Fling aura distance",
        Range = {4,128},
        CurrentValue = 16,
        Increment = 1,
        Suffix = "Distance",
        Flag = "vehicle.fad",
        Callback = function(s)
            vis.Enabled = false
            aura.Size = Vector3.new(1,s,s)
            vis.Enabled = true
        end
    })
    
    self:CreateToggle({
        Name = "Visualize fling aura",
        CurrentValue = false,
        Callback = function(v)
            getgenv().Amber.flaura.Visualize = v
            vis.Enabled = v
            aura.Transparency = v and 0.99 or 1
        end
    })

    task.spawn(function()
        while task.wait() do
            if not player.Character then return end
            aura.CFrame = CFrame.new(player.Character:WaitForChild("HumanoidRootPart", 20).CFrame.Position - Vector3.new(0, 2.4, 0))
            aura.Rotation = Vector3.new(0,0,-90)
            vis.Enabled = getgenv().Amber.flaura.Visualize
        end
    end)
    task.spawn(function()
        while task.wait(0.3) do
            if getgenv().Amber.flaura.Enabled then
                for i, v in pairs(workspace:GetPartBoundsInRadius(aura.CFrame.Position, aura.Size.Z)) do
                    if v:IsDescendantOf(workspace.SpawnedCars) then
                        task.spawn(function() attack(v, true) end)
                    end
                end
            end
        end
    end)
    self:CreateDivider()
    -- TODO: Vehicle modifications
end

do -- Misc
    local self = AmberW.Misc

    self:CreateToggle({
        Name = "Rejoin on warn #3",
        CurrentValue = false,
        Flag = "misc.rjow",
        Callback = function(v)
            getgenv().Amber.rjow = v
        end
    })

    self:CreateToggle({
        Name = "Serverhop when MGMT+ join",
        CurrentValue = false,
        Flag = "misc.rjohr",
        Callback = function(v)
            getgenv().Amber.rjohr = v
        end
    })

    self:CreateButton({
        Name = "Rejoin",
        CurrentValue = false,
        Callback = function(v)
            rj()
        end
    })

    self:CreateButton({
        Name = "Server hop",
        CurrentValue = false,
        Callback = function(v)
            rj(true)
        end
    })

    self:CreateInput({
        Name = "Join JobID",
        CurrentValue = "",
        PlaceholderText = "Guest",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            join(Text)
        end
    })

    self:CreateDivider()

    self:CreateToggle({
        Name = "Rainbow character",
        CurrentValue = false,
        Callback = function(bool)
            local plr = Washiez:GetPlayer()
            local speed = 0.01 -- i may or may not make this customizable
            local cou = 0

            if not bool and getgenv().__FUN_RCh then
                getgenv().__FUN_RCh:Disconnect()
                return
            end
            
            getgenv().__FUN_RCh = game:GetService("RunService").RenderStepped:Connect(function(delta: number)
                if plr.Character then
                    for i, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("BasePart") then
                            cou = (cou + delta * speed)
                            
                            if cou > 1 then
                                cou = 0
                            end
                            
                            v.Color = Color3.fromHSV(cou, 1, 1)
                        end
                    end
                end
            end)
        end
    })


    self:CreateToggle({
        Name = "Rainbow car",
        CurrentValue = false,
        Callback = function(bool)
            local veh = Washiez:GetVehicle()
            local speed = 0.01 -- i may or may not make this customizable
            local cou = 0

            if not bool and getgenv().__FUN_RCa then
                getgenv().__FUN_RCa:Disconnect()
                return
            end
            
            getgenv().__FUN_RCa = game:GetService("RunService").RenderStepped:Connect(function(delta: number)
                if veh then
                    for i, v in pairs(veh.Body:GetDescendants()) do
                        if v:IsA("BasePart") or v:IsA("MeshPart") then
                            cou = (cou + delta * speed)
                            
                            if cou > 1 then
                                cou = 0
                            end
                            
                            v.Color = Color3.fromHSV(cou, 1, 1)
                        end
                    end
                end
            end)
        end
    })

    
    self:CreateDivider()

    self:CreateToggle({
        Name = "Player notifier",
        CurrentValue = false,
        Flag = "misc.pnotif",
        Callback = function(bool)
            getgenv().Amber.plrNotifier = bool
        end
    })

    self:CreateButton({
        Name = "PP (deluxe ticket is recommended)",
        Callback = function()
            local cf = CFrame.new(-1.10000002, 1.20000005, 1.20000005, -0.995037198, 0.0361831747, -0.092691794, 0, 0.931541026, 0.363636374, 0.0995037258, 0.361831725, -0.926917911)

            for i, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                v.Grip = cf
            end
        end
    })

    self:CreateButton({
        Name = "Cleanup map",
        Callback = function()
            for i, v in pairs(game.Workspace:GetChildren()) do
                if v.Name == "CarViewportFrameArea" or v.Name == "CarSpawner" then continue end
                if v.ClassName == "Terrain" or v.Name == "Camera" then continue end
                if v.ClassName == "Folder" then
                    local bl = {
                        "Parts",
                        "Shopiez",
                        "BuildingModels",
                        "Zones",
                        "Portals",
                        "HousePlots",
                        "Lanes",
                        "CrateSystem",
                        "Games",
                        "OfficePlots",
                        "ObbyCheckpoints",
                        "Leaderboards",
                        "Doors",
                        "Gates"
                    }
            
                    if table.find(bl, v.Name) then
                        v:Destroy()
                    else continue end
                end
            
                if game:GetService("Players"):GetPlayerFromCharacter(v) ~= nil then continue end
                
                v:Destroy()
            end
            
            if workspace:FindFirstChild("amberfunpart") then return end
            
            local p = Instance.new("Part")
            p.Anchored = true
            p.Name = "amberfunpart"
            p.Position = Vector3.new(0, 0.2, 0)
            p.Size = Vector3.new(100000, 0.2, 100000)
            p.Parent = workspace
        end
    })
end

Rayfield:LoadConfiguration()
