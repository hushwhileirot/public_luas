-- Decompiled with Medal in Seliware

repeat
    task.wait(1)
until game.Workspace:GetAttribute("didPlay") == true
ReplicatedFirst = game:GetService("ReplicatedFirst")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
HttpService = game:GetService("HttpService")
TweenService = game:GetService("TweenService")
TextService = game:GetService("TextService")
UserInputService = game:GetService("UserInputService")
Player = Players.LocalPlayer
ZERO_VECTOR = Vector3.new(0, 0, 0)
ReloadEvent = ReplicatedStorage:FindFirstChild("Reload")
Library = require(script.Library)
AAHandler = require(ReplicatedFirst:WaitForChild("AAHandler"))
DmgConfig = require(ReplicatedStorage:WaitForChild("DmgConfig"))
targetPosValue = Player:FindFirstChild("TargetPos")
if not targetPosValue then
    targetPosValue = Instance.new("Vector3Value")
    targetPosValue.Name = "TargetPos"
    targetPosValue.Value = ZERO_VECTOR
    targetPosValue.Parent = Player
end
enabledVal = Player:FindFirstChild("PeekBotEnabled") or Player:FindFirstChild("ManipulatorEnabled")
if not enabledVal then
    enabledVal = Instance.new("BoolValue")
    enabledVal.Name = "PeekBotEnabled"
    enabledVal.Value = false
    enabledVal.Parent = Player
end
keyVal = Player:FindFirstChild("PeekBotKey") or Player:FindFirstChild("ManipulatorKey")
if not keyVal then
    keyVal = Instance.new("StringValue")
    keyVal.Name = "PeekBotKey"
    keyVal.Value = "E"
    keyVal.Parent = Player
end
modeVal = Player:FindFirstChild("PeekBotMode") or Player:FindFirstChild("ManipulatorMode")
if not modeVal then
    modeVal = Instance.new("StringValue")
    modeVal.Name = "PeekBotMode"
    modeVal.Value = "On disable"
    modeVal.Parent = Player
end
delayVal = Player:FindFirstChild("PeekBotDelay")
if not delayVal then
    delayVal = Instance.new("NumberValue")
    delayVal.Name = "PeekBotDelay"
    delayVal.Value = 0
    delayVal.Parent = Player
end
local v1 = Library
local v2, v3 = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
window = v1:CreateWindow(v2 and v3.Name or "[\226\173\144]Penablox HvH", Enum.KeyCode.Insert)
Combat = window:AddTab("Rage", "rbxassetid://10734977012")
Visuals = window:AddTab("Visuals", "rbxassetid://10723346959")
Misc = window:AddTab("Misc", "rbxassetid://10723407092")
GeneralSubTab = Combat:AddSubTab("General")
AntiAimSubTab = Combat:AddSubTab("AntiAim")
MainLeft = GeneralSubTab:AddPage("left", "Main")
CombatOtherLeft = GeneralSubTab:AddPage("center", "Other")
ResolverPage = GeneralSubTab:AddPage("center", "Resolver")
CombatOtherRight = GeneralSubTab:AddPage("right", "Effects")
AntiAimPage = AntiAimSubTab:AddPage("left", "Anti-Aim")
local v4, v5, v6, v7, v8 = Library:CreateDefaultSettingsTab(window)
Settings = v4
SettingsSubTab = v5
SettingsLeft = v6
SettingsCenter = v7
SettingsRight = v8
resolverEnabled = false
resolverMethod = "Universal"
resolverStateLogic = true
resolverAngle = 58
resolverSmoothness = 0
function updateResolverConfig()
    local function v12(p9, p10)
        local v11 = Player:FindFirstChild(p9)
        if not v11 then
            if type(p10) == "boolean" then
                v11 = Instance.new("BoolValue")
            elseif type(p10) == "string" then
                v11 = Instance.new("StringValue")
            elseif type(p10) == "number" then
                v11 = Instance.new("NumberValue")
            end
            v11.Name = p9
            v11.Parent = Player
        end
        v11.Value = p10
    end
    v12("ResolverEnabled", resolverEnabled)
    v12("ResolverMethod", resolverMethod)
    v12("ResolverStateLogic", resolverStateLogic)
    v12("ResolverAngle", resolverAngle)
    v12("ResolverSmoothness", resolverSmoothness)
end
ResolverPage:AddToggle("Resolver", false, function(p13)
    resolverEnabled = p13
    updateResolverConfig()
end)
ResolverPage:AddDropdown("Mode", {
    "Universal",
    "Bruteforce",
    "Inverse",
    "Legit"
}, "Universal", function(p14)
    resolverMethod = p14
    updateResolverConfig()
end)
ResolverPage:AddToggle("Smart State", true, function(p15)
    resolverStateLogic = p15
    updateResolverConfig()
end)
ResolverPage:AddSlider("Max Desync Angle", 0, 58, 180, 1, function(p16)
    resolverAngle = p16
    updateResolverConfig()
end)
ResolverPage:AddSlider("Jitter/Randomness", 0, 0, 30, 1, function(p17)
    resolverSmoothness = p17
    updateResolverConfig()
end)
updateResolverConfig()
MiscGeneralSubTab = Misc:AddSubTab("Misc")
MiscPage = MiscGeneralSubTab:AddPage("left", "Misc")
otherMisc = MiscGeneralSubTab:AddPage("center", "Other")
debugRaycastEnabled = false
otherMisc:AddToggle("Debug Raycast", false, function(p18)
    debugRaycastEnabled = p18
    local v19 = Player:FindFirstChild("RaycastDebug")
    if debugRaycastEnabled then
        if not v19 then
            v19 = Instance.new("BoolValue")
            v19.Name = "RaycastDebug"
            v19.Parent = Player
        end
        v19.Value = true
    elseif v19 then
        v19:Destroy()
    end
end)
spreadDebugEnabled = false
otherMisc:AddToggle("Spread Debug", false, function(p20)
    spreadDebugEnabled = p20
    local v21 = Player:FindFirstChild("SpreadDebug")
    if spreadDebugEnabled then
        if not v21 then
            v21 = Instance.new("BoolValue")
            v21.Name = "SpreadDebug"
            v21.Parent = Player
        end
        v21.Value = true
    elseif v21 then
        v21:Destroy()
    end
end)
bulletStartDebugEnabled = false
otherMisc:AddToggle("Bullet start debug", false, function(p22)
    bulletStartDebugEnabled = p22
    local v23 = Player:FindFirstChild("BulletStartDebug")
    if bulletStartDebugEnabled then
        if not v23 then
            v23 = Instance.new("BoolValue")
            v23.Name = "BulletStartDebug"
            v23.Parent = Player
        end
        v23.Value = true
    elseif v23 then
        v23:Destroy()
    end
end)
local v_u_24 = Player:FindFirstChild("HItlogs")
if not v_u_24 then
    v_u_24 = Instance.new("BoolValue")
    v_u_24.Name = "HItlogs"
    v_u_24.Value = false
    v_u_24.Parent = Player
end
local v_u_25 = Player:FindFirstChild("HitlogsX")
if not v_u_25 then
    v_u_25 = Instance.new("IntValue")
    v_u_25.Name = "HitlogsX"
    v_u_25.Value = 0
    v_u_25.Parent = Player
end
local v_u_26 = Player:FindFirstChild("HitlogsY")
if not v_u_26 then
    v_u_26 = Instance.new("IntValue")
    v_u_26.Name = "HitlogsY"
    v_u_26.Value = 0
    v_u_26.Parent = Player
end
local v28 = MiscPage:AddToggle("Hit logs", v_u_24.Value, function(p27)
    -- upvalues: (ref) v_u_24
    v_u_24.Value = p27 and true or false
end):AddSettings()
v28:AddSlider("Position X", v_u_25.Value, -1500, 1500, 1, function(p29)
    -- upvalues: (ref) v_u_25
    local v30 = v_u_25
    local v31 = tonumber(p29) or 0
    v30.Value = math.floor(v31)
end)
v28:AddSlider("Position Y", v_u_26.Value, -1500, 1500, 1, function(p32)
    -- upvalues: (ref) v_u_26
    local v33 = v_u_26
    local v34 = tonumber(p32) or 0
    v33.Value = math.floor(v34)
end)
local v_u_35 = false
local v_u_36 = ReplicatedStorage:WaitForChild("Something"):WaitForChild("CamClip")
MiscPage:AddToggle("Camera Clip", false, function(p37)
    -- upvalues: (ref) v_u_35, (copy) v_u_36
    v_u_35 = p37
    v_u_36:FireServer(v_u_35)
end)
local v_u_38 = {
    ["enabled"] = false,
    ["items"] = {},
    ["settings"] = {
        ["os_time"] = true,
        ["player_name"] = true,
        ["date"] = false,
        ["kills"] = false,
        ["killstreak"] = false
    }
}
local function v_u_64()
    -- upvalues: (copy) v_u_38
    if not v_u_38.gui then
        local v39 = Player:WaitForChild("PlayerGui")
        local v_u_40 = workspace.CurrentCamera
        local v41 = Instance.new("ScreenGui")
        v41.Name = "WatermarkGui"
        v41.Parent = v39
        v41.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v41.ResetOnSpawn = false
        v41.Enabled = false
        local v_u_42 = Instance.new("Frame")
        v_u_42.Name = "WatermarkFrame"
        v_u_42.Parent = v41
        v_u_42.Position = UDim2.new(0, 20, 0, 20)
        v_u_42.Size = UDim2.new(0, 200, 0, 30)
        v_u_42.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
        v_u_42.BorderSizePixel = 0
        local v43 = Instance.new("UICorner")
        v43.CornerRadius = UDim.new(0, 10)
        v43.Parent = v_u_42
        local v44 = Instance.new("UIStroke")
        v44.Color = Color3.fromRGB(23, 23, 29)
        v44.Parent = v_u_42
        v44.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        v44.Thickness = 1
        local v45 = Instance.new("UIGradient")
        v45.Rotation = 90
        v45.Parent = v_u_42
        v45.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(66, 66, 66)) })
        local v46 = Instance.new("TextLabel")
        v46.Name = "WatermarkText"
        v46.Parent = v_u_42
        v46.Position = UDim2.new(0, 8, 0, 0)
        v46.Size = UDim2.new(1, -16, 1, 0)
        v46.BackgroundTransparency = 1
        v46.Text = ""
        v46.TextColor3 = Color3.fromRGB(245, 245, 245)
        v46.TextSize = 12
        v46.Font = Enum.Font.Gotham
        v46.TextXAlignment = Enum.TextXAlignment.Center
        v46.TextYAlignment = Enum.TextYAlignment.Center
        v_u_38.gui = v41
        v_u_38.frame = v_u_42
        v_u_38.text = v46
        v_u_38.items = {
            ["gui"] = v41,
            ["frame"] = v_u_42,
            ["text"] = v46
        }
        local v_u_47 = false
        local v_u_48 = nil
        local v_u_49 = nil
        v_u_42.InputBegan:Connect(function(p50)
            -- upvalues: (ref) v_u_47, (ref) v_u_48, (ref) v_u_49, (copy) v_u_42
            if p50.UserInputType == Enum.UserInputType.MouseButton1 or p50.UserInputType == Enum.UserInputType.Touch then
                v_u_47 = true
                v_u_48 = p50.Position
                v_u_49 = v_u_42.AbsolutePosition
            end
        end)
        v_u_42.InputEnded:Connect(function(p51)
            -- upvalues: (ref) v_u_47
            if p51.UserInputType == Enum.UserInputType.MouseButton1 or p51.UserInputType == Enum.UserInputType.Touch then
                v_u_47 = false
            end
        end)
        UserInputService.InputChanged:Connect(function(p52)
            -- upvalues: (ref) v_u_47, (copy) v_u_40, (copy) v_u_42, (ref) v_u_48, (ref) v_u_49
            if v_u_47 and (p52.UserInputType == Enum.UserInputType.MouseMovement or p52.UserInputType == Enum.UserInputType.Touch) then
                local v53 = v_u_40.ViewportSize
                local v54 = v_u_42.AbsoluteSize.X
                local v55 = v_u_42.AbsoluteSize.Y
                local v56 = p52.Position.X - v_u_48.X
                local v57 = p52.Position.Y - v_u_48.Y
                local v58 = v_u_49.X + v56
                local v59 = v53.X - v54
                local v60 = math.clamp(v58, 0, v59)
                local v61 = v_u_49.Y + v57
                local v62 = v53.Y - v55
                local v63 = math.clamp(v61, 0, v62)
                v_u_42.Position = UDim2.new(0, v60, 0, v63)
            end
        end)
    end
end
local function v_u_82()
    -- upvalues: (copy) v_u_38
    if v_u_38.text then
        local v65 = {}
        if v_u_38.settings.os_time then
            local v66 = os.date("%H:%M:%S")
            table.insert(v65, v66)
        end
        if v_u_38.settings.player_name then
            local v67 = Player.Name
            table.insert(v65, v67)
        end
        if v_u_38.settings.date then
            local v68 = os.date
            local v69 = tonumber(v68("%d"))
            local v70 = os.date("%b"):lower()
            local v71 = string.format
            table.insert(v65, v71("%d %s", v69, v70))
        end
        if v_u_38.settings.kills then
            local v72 = Player:FindFirstChild("leaderstats")
            if v72 then
                v72 = v72:FindFirstChild("Kills")
            end
            if v72 and v72:IsA("IntValue") then
                local v73 = string.format
                local v74 = v72.Value
                table.insert(v65, v73("%d kills", v74))
            end
        end
        if v_u_38.settings.killstreak then
            local v75 = Player:FindFirstChild("leaderstats")
            if v75 then
                v75 = v75:FindFirstChild("Killstreak")
            end
            if v75 and v75:IsA("IntValue") then
                local v76 = string.format
                local v77 = v75.Value
                table.insert(v65, v76("%d ks", v77))
            end
        end
        v_u_38.text.Text = #v65 > 0 and table.concat(v65, " | ") or ""
        if v_u_38.frame then
            task.defer(function()
                -- upvalues: (ref) v_u_38
                if v_u_38.text and v_u_38.frame then
                    local v78 = v_u_38.text.TextBounds
                    if (v78.X == 0 or v78.X < 10) and v_u_38.text.Text ~= "" then
                        local v79 = #v_u_38.text.Text * (v_u_38.text.TextSize * 0.6)
                        v78 = Vector2.new(v79, v_u_38.text.TextSize)
                    end
                    local v80 = v78.X + 16
                    local v81 = math.max(200, v80)
                    v_u_38.frame.Size = UDim2.new(0, v81, 0, 30)
                end
            end)
        end
    end
end
local function v_u_89(p83)
    -- upvalues: (copy) v_u_38, (copy) v_u_64, (copy) v_u_82
    v_u_38.enabled = p83
    if not v_u_38.gui then
        v_u_64()
    end
    if v_u_38.gui then
        v_u_38.gui.Enabled = p83
        if p83 then
            v_u_82()
            if v_u_38.update_connection then
                v_u_38.update_connection:Disconnect()
            end
            v_u_38.update_connection = RunService.Heartbeat:Connect(function()
                -- upvalues: (ref) v_u_82
                v_u_82()
            end)
            local function v_u_87()
                -- upvalues: (ref) v_u_38, (ref) v_u_82
                local v84 = Player:FindFirstChild("leaderstats")
                if v84 then
                    local v85 = v84:FindFirstChild("Kills")
                    local v86 = v84:FindFirstChild("Killstreak")
                    if v85 and v85:IsA("IntValue") then
                        if v_u_38.kills_connection then
                            v_u_38.kills_connection:Disconnect()
                        end
                        v_u_38.kills_connection = v85:GetPropertyChangedSignal("Value"):Connect(function()
                            -- upvalues: (ref) v_u_82
                            v_u_82()
                        end)
                    end
                    if v86 and v86:IsA("IntValue") then
                        if v_u_38.killstreak_connection then
                            v_u_38.killstreak_connection:Disconnect()
                        end
                        v_u_38.killstreak_connection = v86:GetPropertyChangedSignal("Value"):Connect(function()
                            -- upvalues: (ref) v_u_82
                            v_u_82()
                        end)
                    end
                end
            end
            v_u_87()
            if v_u_38.leaderstats_connection then
                v_u_38.leaderstats_connection:Disconnect()
            end
            v_u_38.leaderstats_connection = Player.ChildAdded:Connect(function(p88)
                -- upvalues: (copy) v_u_87
                if p88.Name == "leaderstats" then
                    v_u_87()
                end
            end)
            return
        end
        if v_u_38.update_connection then
            v_u_38.update_connection:Disconnect()
            v_u_38.update_connection = nil
        end
        if v_u_38.kills_connection then
            v_u_38.kills_connection:Disconnect()
            v_u_38.kills_connection = nil
        end
        if v_u_38.killstreak_connection then
            v_u_38.killstreak_connection:Disconnect()
            v_u_38.killstreak_connection = nil
        end
        if v_u_38.leaderstats_connection then
            v_u_38.leaderstats_connection:Disconnect()
            v_u_38.leaderstats_connection = nil
        end
    end
end
local v_u_90 = Player:FindFirstChild("Killfeed")
if not v_u_90 then
    v_u_90 = Instance.new("BoolValue")
    v_u_90.Name = "Killfeed"
    v_u_90.Value = true
    v_u_90.Parent = Player
end
local v_u_91 = Player:FindFirstChild("PreserveKillFeed")
if not v_u_91 then
    v_u_91 = Instance.new("BoolValue")
    v_u_91.Name = "PreserveKillFeed"
    v_u_91.Value = false
    v_u_91.Parent = Player
end
local v_u_92 = Player:FindFirstChild("KillfeedX")
if not v_u_92 then
    v_u_92 = Instance.new("IntValue")
    v_u_92.Name = "KillfeedX"
    v_u_92.Value = 0
    v_u_92.Parent = Player
end
local v_u_93 = Player:FindFirstChild("KillfeedY")
if not v_u_93 then
    v_u_93 = Instance.new("IntValue")
    v_u_93.Name = "KillfeedY"
    v_u_93.Value = 0
    v_u_93.Parent = Player
end
local v95 = MiscPage:AddToggle("Killfeed", v_u_90.Value, function(p94)
    -- upvalues: (ref) v_u_90
    v_u_90.Value = p94 and true or false
end):AddSettings()
v95:AddToggle("Preserve", v_u_91.Value, function(p96)
    -- upvalues: (ref) v_u_91
    v_u_91.Value = p96 and true or false
end)
v95:AddSlider("Position X", v_u_92.Value, -1500, 1500, 1, function(p97)
    -- upvalues: (ref) v_u_92
    local v98 = v_u_92
    local v99 = tonumber(p97) or 0
    v98.Value = math.floor(v99)
end)
v95:AddSlider("Position Y", v_u_93.Value, -1500, 1500, 1, function(p100)
    -- upvalues: (ref) v_u_93
    local v101 = v_u_93
    local v102 = tonumber(p100) or 0
    v101.Value = math.floor(v102)
end)
MiscPage:AddToggle("Keybind list", false, function(p103)
    Library:toggle_keybind_list(p103)
end)
local v105 = MiscPage:AddToggle("Watermark", false, function(p104)
    -- upvalues: (copy) v_u_89
    v_u_89(p104)
end):AddSettings()
v105:AddToggle("OS Time", v_u_38.settings.os_time, function(p106)
    -- upvalues: (copy) v_u_38, (copy) v_u_82
    if v_u_38.settings.os_time ~= nil then
        v_u_38.settings.os_time = p106
        if v_u_38.enabled then
            v_u_82()
        end
    end
end)
v105:AddToggle("Player name", v_u_38.settings.player_name, function(p107)
    -- upvalues: (copy) v_u_38, (copy) v_u_82
    if v_u_38.settings.player_name ~= nil then
        v_u_38.settings.player_name = p107
        if v_u_38.enabled then
            v_u_82()
        end
    end
end)
v105:AddToggle("Date", v_u_38.settings.date, function(p108)
    -- upvalues: (copy) v_u_38, (copy) v_u_82
    if v_u_38.settings.date ~= nil then
        v_u_38.settings.date = p108
        if v_u_38.enabled then
            v_u_82()
        end
    end
end)
v105:AddToggle("Kills", v_u_38.settings.kills, function(p109)
    -- upvalues: (copy) v_u_38, (copy) v_u_82
    if v_u_38.settings.kills ~= nil then
        v_u_38.settings.kills = p109
        if v_u_38.enabled then
            v_u_82()
        end
    end
end)
v105:AddToggle("Killstreak", v_u_38.settings.killstreak, function(p110)
    -- upvalues: (copy) v_u_38, (copy) v_u_82
    if v_u_38.settings.killstreak ~= nil then
        v_u_38.settings.killstreak = p110
        if v_u_38.enabled then
            v_u_82()
        end
    end
end)
ESPSubTab = Visuals:AddSubTab("ESP")
SelfVisualsSubTab = Visuals:AddSubTab("Self visuals")
ESPPage = ESPSubTab:AddPage("left", "ESP")
ChamsPage = ESPSubTab:AddPage("center", "Chams")
SelfVisualsPage = SelfVisualsSubTab:AddPage("left", "Self visuals")
CharacterPage = SelfVisualsSubTab:AddPage("center", "Character")
TracersPage = SelfVisualsSubTab:AddPage("center", "Tracers")
ViewModelPage = SelfVisualsSubTab:AddPage("right", "View Model")
tracerFolder = Player:FindFirstChild("Tracers")
if not tracerFolder then
    tracerFolder = Instance.new("Folder")
    tracerFolder.Name = "Tracers"
    tracerFolder.Parent = Player
end
tracerTypeVal = tracerFolder:FindFirstChild("TracerType")
if not tracerTypeVal then
    tracerTypeVal = Instance.new("StringValue")
    tracerTypeVal.Name = "TracerType"
    tracerTypeVal.Value = "Default"
    tracerTypeVal.Parent = tracerFolder
end
lightEmissionVal = tracerFolder:FindFirstChild("LightEmission")
if not lightEmissionVal then
    lightEmissionVal = Instance.new("NumberValue")
    lightEmissionVal.Name = "LightEmission"
    lightEmissionVal.Value = 0
    lightEmissionVal.Parent = tracerFolder
end
lightInfluenceVal = tracerFolder:FindFirstChild("LightInfluence")
if not lightInfluenceVal then
    lightInfluenceVal = Instance.new("NumberValue")
    lightInfluenceVal.Name = "LightInfluence"
    lightInfluenceVal.Value = 0.1
    lightInfluenceVal.Parent = tracerFolder
end
tracerTransparencyVal = tracerFolder:FindFirstChild("TracerTransparency")
if not tracerTransparencyVal then
    tracerTransparencyVal = Instance.new("NumberValue")
    tracerTransparencyVal.Name = "TracerTransparency"
    tracerTransparencyVal.Value = 0
    tracerTransparencyVal.Parent = tracerFolder
end
tracerColorRVal = tracerFolder:FindFirstChild("TracerColorR")
if not tracerColorRVal then
    tracerColorRVal = Instance.new("IntValue")
    tracerColorRVal.Name = "TracerColorR"
    tracerColorRVal.Value = 255
    tracerColorRVal.Parent = tracerFolder
end
tracerColorGVal = tracerFolder:FindFirstChild("TracerColorG")
if not tracerColorGVal then
    tracerColorGVal = Instance.new("IntValue")
    tracerColorGVal.Name = "TracerColorG"
    tracerColorGVal.Value = 255
    tracerColorGVal.Parent = tracerFolder
end
tracerColorBVal = tracerFolder:FindFirstChild("TracerColorB")
if not tracerColorBVal then
    tracerColorBVal = Instance.new("IntValue")
    tracerColorBVal.Name = "TracerColorB"
    tracerColorBVal.Value = 255
    tracerColorBVal.Parent = tracerFolder
end
tracerLifeTimeVal = tracerFolder:FindFirstChild("TracerLifeTime")
if not tracerLifeTimeVal then
    tracerLifeTimeVal = Instance.new("NumberValue")
    tracerLifeTimeVal.Name = "TracerLifeTime"
    tracerLifeTimeVal.Value = 0.5
    tracerLifeTimeVal.Parent = tracerFolder
end
TracersPage:AddDropdown("Tracer", {
    "Default",
    "Light",
    "Lightning",
    "Tiny Lightning",
    "Wave",
    "Beam",
    "Surge"
}, tracerTypeVal.Value, function(p111)
    if type(p111) == "string" then
        tracerTypeVal.Value = p111
    end
end)
TracersPage:AddSlider("Light Emission", lightEmissionVal.Value, 0, 1, 0.1, function(p112)
    local v113 = tonumber(p112)
    if v113 then
        local v114 = lightEmissionVal
        local v115 = v113 * 10 + 0.5
        v114.Value = math.floor(v115) / 10
    end
end)
TracersPage:AddSlider("Light Influence", lightInfluenceVal.Value, 0, 1, 0.1, function(p116)
    local v117 = tonumber(p116)
    if v117 then
        local v118 = lightInfluenceVal
        local v119 = v117 * 10 + 0.5
        v118.Value = math.floor(v119) / 10
    end
end)
TracersPage:AddSlider("Transparency", tracerTransparencyVal.Value, 0, 1, 0.1, function(p120)
    local v121 = tonumber(p120)
    if v121 then
        local v122 = tracerTransparencyVal
        local v123 = v121 * 10 + 0.5
        v122.Value = math.floor(v123) / 10
    end
end)
TracersPage:AddColorPicker("Color", Color3.fromRGB(tracerColorRVal.Value, tracerColorGVal.Value, tracerColorBVal.Value), function(...)
    local v124 = coerceColor3(...)
    if v124 then
        local v125 = tracerColorRVal
        local v126 = v124.R * 255 + 0.5
        local v127 = math.floor(v126)
        v125.Value = math.clamp(v127, 0, 255)
        local v128 = tracerColorGVal
        local v129 = v124.G * 255 + 0.5
        local v130 = math.floor(v129)
        v128.Value = math.clamp(v130, 0, 255)
        local v131 = tracerColorBVal
        local v132 = v124.B * 255 + 0.5
        local v133 = math.floor(v132)
        v131.Value = math.clamp(v133, 0, 255)
    end
end)
TracersPage:AddSlider("Tracer Lifetime", tracerLifeTimeVal.Value, 0.1, 5, 0.1, function(p134)
    local v135 = tonumber(p134)
    if v135 then
        local v136 = tracerLifeTimeVal
        local v137 = v135 * 10 + 0.5
        v136.Value = math.floor(v137) / 10
    end
end)
WorldGeneralSubTab = Visuals:AddSubTab("World")
WorldPage = WorldGeneralSubTab:AddPage("left", "World")
WorldRightPage = WorldGeneralSubTab:AddPage("right", "Lighting")
desiredFov = 70
WorldPage:AddSlider("Field Of View", 70, 50, 120, 1, function(p138)
    desiredFov = tonumber(p138) or 70
    local v139 = workspace.CurrentCamera
    if v139 then
        local v140 = v139.FieldOfView - desiredFov
        if math.abs(v140) > 0.001 then
            v139.FieldOfView = desiredFov
        end
    end
end)
local v_u_141 = 0
local v_u_142 = nil
local v_u_143 = nil
function calculateStretchResScale()
    -- upvalues: (ref) v_u_141
    local v144 = 1 - v_u_141 / 100 * 0.9
    return math.clamp(v144, 0.1, 1)
end
function setupStretchResListener()
    -- upvalues: (ref) v_u_142, (ref) v_u_141, (ref) v_u_143
    if v_u_142 then
        v_u_142:Disconnect()
        v_u_142 = nil
    end
    if v_u_141 <= 0 then
        v_u_143 = nil
        return
    elseif workspace.CurrentCamera then
        v_u_142 = RunService.RenderStepped:Connect(function()
            -- upvalues: (ref) v_u_141, (ref) v_u_143
            if v_u_141 <= 0 then
                return
            else
                local v145 = workspace.CurrentCamera
                if v145 then
                    local v146 = v145.CFrame
                    local v147 = v_u_143 or v146
                    if v_u_143 and (v146.Position - v147.Position).Magnitude <= 0.01 then
                        v146 = v147
                    else
                        v_u_143 = v146
                    end
                    local v148 = calculateStretchResScale()
                    v145.CFrame = v146 * CFrame.new(0, 0, 0, 1, 0, 0, 0, v148, 0, 0, 0, 1)
                end
            end
        end)
    end
end
if workspace.CurrentCamera then
    setupStretchResListener()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    setupStretchResListener()
end)
WorldPage:AddSlider("Aspect Ratio", v_u_141, 0, 100, 1, function(p149)
    -- upvalues: (ref) v_u_141
    local v150 = tonumber(p149) or 0
    v_u_141 = math.floor(v150)
    setupStretchResListener()
end)
local function v_u_156(p151)
    local v152 = game.Lighting
    local v153 = v152:FindFirstChild("Skys")
    for _, v154 in ipairs(v152:GetChildren()) do
        if v154:IsA("Sky") then
            v154:Destroy()
        end
    end
    local v155 = v153 and v153:FindFirstChild(p151)
    if v155 then
        v155:Clone().Parent = v152
    end
end
WorldRightPage:AddDropdown("Skybox", {
    "Default",
    "Classic",
    "Orange",
    "Magenta",
    "Purple Space",
    "Night Cloudy",
    "Night Blue",
    "Anime",
    "Sunset",
    "Starry Night"
}, "Default", function(p157)
    -- upvalues: (copy) v_u_156
    v_u_156(p157)
end)
local v204, v205 = pcall(function()
    local v158 = WorldGeneralSubTab:AddPage("center", "Skybox Rotation")
    local v159 = WorldGeneralSubTab:AddPage("center", "Skybox Rotate")
    local v_u_160 = game:GetService("Lighting")
    local v_u_161 = 0
    local v_u_162 = 0
    local v_u_163 = 0
    local v_u_164 = false
    local v_u_165 = true
    local v_u_166 = true
    local v_u_167 = false
    local v_u_168 = 1
    local function v_u_174()
        -- upvalues: (copy) v_u_160
        local v169 = {}
        local v170 = {}
        for _, v171 in ipairs(v_u_160:GetChildren()) do
            if v171:IsA("Sky") and not v169[v171] then
                table.insert(v170, v171)
                v169[v171] = true
            end
        end
        local v172 = v_u_160:FindFirstChild("Skys")
        if v172 then
            for _, v173 in ipairs(v172:GetChildren()) do
                if v173:IsA("Sky") and not v169[v173] then
                    table.insert(v170, v173)
                    v169[v173] = true
                end
            end
        end
        return v170
    end
    local function v_u_185(p175)
        -- upvalues: (copy) v_u_174, (ref) v_u_165, (ref) v_u_166, (ref) v_u_167, (ref) v_u_161, (ref) v_u_162, (ref) v_u_163
        local v176 = v_u_174()
        if #v176 ~= 0 then
            local v177 = p175 and v_u_165 and (p175.X or 0) or 0
            local v178 = p175 and v_u_166 and (p175.Y or 0) or 0
            local v179 = p175 and (v_u_167 and p175.Z or 0) or 0
            local v180 = v_u_161 + v177
            local v181 = v_u_162 + v178
            local v182 = v_u_163 + v179
            local v_u_183 = Vector3.new(v180, v181, v182)
            for _, v_u_184 in ipairs(v176) do
                pcall(function()
                    -- upvalues: (copy) v_u_184, (copy) v_u_183
                    v_u_184.SkyboxOrientation = v_u_183
                end)
            end
        end
    end
    v158:AddSlider("Rotate X", 0, -180, 180, 1, function(p186)
        -- upvalues: (ref) v_u_161, (copy) v_u_185
        v_u_161 = tonumber(p186) or 0
        v_u_185(nil)
    end)
    v158:AddSlider("Rotate Y", 0, -180, 180, 1, function(p187)
        -- upvalues: (ref) v_u_162, (copy) v_u_185
        v_u_162 = tonumber(p187) or 0
        v_u_185(nil)
    end)
    v158:AddSlider("Rotate Z", 0, -180, 180, 1, function(p188)
        -- upvalues: (ref) v_u_163, (copy) v_u_185
        v_u_163 = tonumber(p188) or 0
        v_u_185(nil)
    end)
    local v_u_189 = game:GetService("RunService")
    local v_u_190 = Vector3.new(0, 0, 0)
    local v_u_191 = nil
    v159:AddToggle("Skybox rotation", false, function(p192)
        -- upvalues: (ref) v_u_164, (ref) v_u_191, (copy) v_u_189, (ref) v_u_165, (ref) v_u_168, (ref) v_u_166, (ref) v_u_167, (ref) v_u_190, (copy) v_u_185
        v_u_164 = p192
        if v_u_164 then
            if not (v_u_191 and v_u_191.Connected) then
                v_u_191 = v_u_189.Heartbeat:Connect(function(p193)
                    -- upvalues: (ref) v_u_164, (ref) v_u_165, (ref) v_u_168, (ref) v_u_166, (ref) v_u_167, (ref) v_u_190, (ref) v_u_185
                    if v_u_164 then
                        local v194 = v_u_166 and v_u_168 or 0
                        local v195 = v_u_167 and v_u_168 or 0
                        local v196 = v_u_190
                        local v197 = (v_u_165 and v_u_168 or 0) * p193 * 60
                        local v198 = v194 * p193 * 60
                        local v199 = v195 * p193 * 60
                        v_u_190 = v196 + Vector3.new(v197, v198, v199)
                        v_u_185(v_u_190)
                    end
                end)
            end
        else
            if v_u_191 and v_u_191.Connected then
                v_u_191:Disconnect()
            end
            v_u_191 = nil
            v_u_190 = Vector3.new(0, 0, 0)
            v_u_185(nil)
            return
        end
    end)
    v159:AddToggle("Axis X", true, function(p200)
        -- upvalues: (ref) v_u_165
        v_u_165 = p200
    end)
    v159:AddToggle("Axis Y", true, function(p201)
        -- upvalues: (ref) v_u_166
        v_u_166 = p201
    end)
    v159:AddToggle("Axis Z", false, function(p202)
        -- upvalues: (ref) v_u_167
        v_u_167 = p202
    end)
    v159:AddSlider("Rotation speed", 1, -5, 5, 0.01, function(p203)
        -- upvalues: (ref) v_u_168
        v_u_168 = tonumber(p203) or 1
    end)
end)
if not v204 then
    warn("Skybox subtab init failed:", v205)
end
local v_u_206 = false
local v_u_207 = 12
local v_u_208 = 3
local v_u_209 = 0
local v_u_210 = 0
local v_u_211 = game:GetService("Lighting")
local v_u_212 = v_u_211:FindFirstChildOfClass("ColorCorrectionEffect")
if not v_u_212 then
    v_u_212 = Instance.new("ColorCorrectionEffect")
    v_u_212.Name = "UI_ColorCorrection"
    v_u_212.Parent = v_u_211
end
local v215 = WorldRightPage:AddToggle("Lightning", false, function(p213)
    -- upvalues: (ref) v_u_206, (copy) v_u_211, (ref) v_u_207, (ref) v_u_208, (ref) v_u_212, (ref) v_u_209, (ref) v_u_210
    v_u_206 = p213
    if v_u_206 then
        local v214 = v_u_207
        v_u_211.TimeOfDay = tostring(v214)
        v_u_211.Brightness = v_u_208
        v_u_212.Contrast = v_u_209
        v_u_212.Saturation = v_u_210
    else
        v_u_211.TimeOfDay = tostring(12)
        v_u_211.Brightness = 3
        v_u_212.Contrast = 0
        v_u_212.Saturation = 0
    end
end):AddSettings()
v215:AddSlider("Time", 12, 0, 24, 1, function(p216)
    -- upvalues: (ref) v_u_207, (ref) v_u_206, (copy) v_u_211
    v_u_207 = tonumber(p216) or 12
    if v_u_206 then
        local v217 = v_u_207
        v_u_211.TimeOfDay = tostring(v217)
    end
end)
v215:AddSlider("Brightness", 3, -1, 5, 0.1, function(p218)
    -- upvalues: (ref) v_u_208, (ref) v_u_206, (copy) v_u_211
    v_u_208 = tonumber(p218) or 3
    if v_u_206 then
        v_u_211.Brightness = v_u_208
    end
end)
v215:AddSlider("Contrast", 0, -1, 1, 0.01, function(p219)
    -- upvalues: (ref) v_u_209, (ref) v_u_206, (ref) v_u_212
    v_u_209 = tonumber(p219) or 0
    if v_u_206 then
        v_u_212.Contrast = v_u_209
    end
end)
v215:AddSlider("Saturation", 0, -1, 1, 0.01, function(p220)
    -- upvalues: (ref) v_u_210, (ref) v_u_206, (ref) v_u_212
    v_u_210 = tonumber(p220) or 0
    if v_u_206 then
        v_u_212.Saturation = v_u_210
    end
end)
local v_u_221 = false
local v_u_222 = nil
local v_u_223 = 0.4
local v_u_224 = 0.25
local v_u_225 = Color3.fromRGB(199, 199, 199)
local v_u_226 = Color3.fromRGB(106, 112, 125)
local v_u_227 = 0
local v_u_228 = 0
local v230 = WorldRightPage:AddToggle("Atmosphere", false, function(p229)
    -- upvalues: (ref) v_u_221, (ref) v_u_222, (copy) v_u_211, (ref) v_u_223, (ref) v_u_224, (ref) v_u_225, (ref) v_u_226, (ref) v_u_227, (ref) v_u_228
    v_u_221 = p229
    if v_u_221 then
        if not v_u_222 then
            v_u_222 = Instance.new("Atmosphere")
            v_u_222.Name = "UI_Atmosphere"
            v_u_222.Parent = v_u_211
        end
        v_u_222.Density = v_u_223
        v_u_222.Offset = v_u_224
        v_u_222.Color = v_u_225
        v_u_222.Decay = v_u_226
        v_u_222.Glare = v_u_227
        v_u_222.Haze = v_u_228
    elseif v_u_222 then
        v_u_222:Destroy()
        v_u_222 = nil
    end
end):AddSettings()
v230:AddSlider("Density", 0.4, 0, 1, 0.01, function(p231)
    -- upvalues: (ref) v_u_223, (ref) v_u_221, (ref) v_u_222
    v_u_223 = tonumber(p231) or 0.4
    if v_u_221 and v_u_222 then
        v_u_222.Density = v_u_223
    end
end)
v230:AddSlider("Offset", 0.25, 0, 1, 0.01, function(p232)
    -- upvalues: (ref) v_u_224, (ref) v_u_221, (ref) v_u_222
    v_u_224 = tonumber(p232) or 0.25
    if v_u_221 and v_u_222 then
        v_u_222.Offset = v_u_224
    end
end)
v230:AddColorPicker("Color", Color3.fromRGB(199, 199, 199), function(...)
    -- upvalues: (ref) v_u_225, (ref) v_u_221, (ref) v_u_222
    local v233 = coerceColor3(...)
    if v233 then
        v_u_225 = v233
        if v_u_221 and v_u_222 then
            v_u_222.Color = v_u_225
        end
    end
end)
v230:AddColorPicker("Decay", Color3.fromRGB(106, 112, 125), function(...)
    -- upvalues: (ref) v_u_226, (ref) v_u_221, (ref) v_u_222
    local v234 = coerceColor3(...)
    if v234 then
        v_u_226 = v234
        if v_u_221 and v_u_222 then
            v_u_222.Decay = v_u_226
        end
    end
end)
v230:AddSlider("Glare", 0, 0, 1, 0.01, function(p235)
    -- upvalues: (ref) v_u_227, (ref) v_u_221, (ref) v_u_222
    v_u_227 = tonumber(p235) or 0
    if v_u_221 and v_u_222 then
        v_u_222.Glare = v_u_227
    end
end)
v230:AddSlider("Haze", 0, 0, 3, 0.01, function(p236)
    -- upvalues: (ref) v_u_228, (ref) v_u_221, (ref) v_u_222
    v_u_228 = tonumber(p236) or 0
    if v_u_221 and v_u_222 then
        v_u_222.Haze = v_u_228
    end
end)
bloomEnabled = false
bloomInstance = nil
bloomIntensity = 1
bloomSize = 24
bloomThreshold = 2
function applyBloom()
    -- upvalues: (copy) v_u_211
    if bloomEnabled then
        if not bloomInstance then
            bloomInstance = Instance.new("BloomEffect")
            bloomInstance.Name = "UI_Bloom"
            bloomInstance.Parent = v_u_211
        end
        bloomInstance.Intensity = bloomIntensity
        bloomInstance.Size = bloomSize
        bloomInstance.Threshold = bloomThreshold
    elseif bloomInstance then
        bloomInstance:Destroy()
        bloomInstance = nil
    end
end
bloomToggle = WorldRightPage:AddToggle("Bloom", false, function(p237)
    bloomEnabled = p237
    applyBloom()
end)
bloomSettings = bloomToggle:AddSettings()
bloomSettings:AddSlider("Intensity", 1, 0, 5, 0.1, function(p238)
    bloomIntensity = tonumber(p238) or 1
    if bloomEnabled and bloomInstance then
        bloomInstance.Intensity = bloomIntensity
    end
end)
bloomSettings:AddSlider("Size", 24, 0, 56, 1, function(p239)
    bloomSize = tonumber(p239) or 24
    if bloomEnabled and bloomInstance then
        bloomInstance.Size = bloomSize
    end
end)
bloomSettings:AddSlider("Threshold", 2, 0, 5, 0.1, function(p240)
    bloomThreshold = tonumber(p240) or 2
    if bloomEnabled and bloomInstance then
        bloomInstance.Threshold = bloomThreshold
    end
end)
fogEnabled = false
fogStart = 0
fogEnd = 500
fogColorR = 255
fogColorG = 255
fogColorB = 255
function applyFog()
    local v241 = game.Lighting
    if fogEnabled then
        v241.FogStart = fogStart
        v241.FogEnd = fogEnd
        v241.FogColor = Color3.fromRGB(fogColorR, fogColorG, fogColorB)
    else
        v241.FogStart = 0
        v241.FogEnd = 100000
    end
end
fogToggle = WorldRightPage:AddToggle("Fog", false, function(p242)
    fogEnabled = p242
    applyFog()
end)
fogSettings = fogToggle:AddSettings()
fogSettings:AddSlider("Start", fogStart, 0, 1000, 1, function(p243)
    fogStart = tonumber(p243) or 0
    if fogEnabled then
        game.Lighting.FogStart = fogStart
    end
end)
fogSettings:AddSlider("End", fogEnd, 0, 10000, 10, function(p244)
    fogEnd = tonumber(p244) or 500
    if fogEnabled then
        game.Lighting.FogEnd = fogEnd
    end
end)
fogSettings:AddColorPicker("Fog Color", Color3.fromRGB(fogColorR, fogColorG, fogColorB), function(p245)
    if typeof(p245) == "Color3" then
        local v246 = p245.R * 255 + 0.5
        local v247 = math.floor(v246)
        fogColorR = math.clamp(v247, 0, 255)
        local v248 = p245.G * 255 + 0.5
        local v249 = math.floor(v248)
        fogColorG = math.clamp(v249, 0, 255)
        local v250 = p245.B * 255 + 0.5
        local v251 = math.floor(v250)
        fogColorB = math.clamp(v251, 0, 255)
        if fogEnabled then
            game.Lighting.FogColor = Color3.fromRGB(fogColorR, fogColorG, fogColorB)
        end
    end
end)
cloudsEnabled = false
cloudsInstance = nil
cloudsCover = 0.5
cloudsDensity = 0.5
cloudsColorR = 255
cloudsColorG = 255
cloudsColorB = 255
function ensureCloudsInstance()
    local v252 = workspace:FindFirstChildOfClass("Terrain")
    if v252 then
        if cloudsEnabled then
            cloudsInstance = v252:FindFirstChildOfClass("Clouds")
            if not cloudsInstance then
                cloudsInstance = Instance.new("Clouds")
                cloudsInstance.Parent = v252
            end
            if cloudsInstance then
                cloudsInstance.Cover = cloudsCover
                cloudsInstance.Density = cloudsDensity
                cloudsInstance.Color = Color3.fromRGB(cloudsColorR, cloudsColorG, cloudsColorB)
                return
            end
        else
            if cloudsInstance and cloudsInstance.Parent then
                cloudsInstance:Destroy()
            end
            cloudsInstance = nil
        end
    end
end
cloudsToggle = WorldPage:AddToggle("Clouds", false, function(p253)
    cloudsEnabled = p253
    ensureCloudsInstance()
end)
local v254 = cloudsToggle:AddSettings()
v254:AddSlider("Cover", cloudsCover, 0, 1, 0.01, function(p255)
    local v256 = tonumber(p255) or 0.5
    cloudsCover = math.clamp(v256, 0, 1)
    if cloudsEnabled then
        if not cloudsInstance then
            ensureCloudsInstance()
        end
        if cloudsInstance then
            cloudsInstance.Cover = cloudsCover
        end
    end
end)
v254:AddSlider("Density", cloudsDensity, 0, 1, 0.01, function(p257)
    local v258 = tonumber(p257) or 0.5
    cloudsDensity = math.clamp(v258, 0, 1)
    if cloudsEnabled then
        if not cloudsInstance then
            ensureCloudsInstance()
        end
        if cloudsInstance then
            cloudsInstance.Density = cloudsDensity
        end
    end
end)
v254:AddColorPicker("Color", Color3.fromRGB(cloudsColorR, cloudsColorG, cloudsColorB), function(...)
    local v259 = coerceColor3(...)
    if v259 then
        local v260 = v259.R * 255 + 0.5
        local v261 = math.floor(v260)
        cloudsColorR = math.clamp(v261, 0, 255)
        local v262 = v259.G * 255 + 0.5
        local v263 = math.floor(v262)
        cloudsColorG = math.clamp(v263, 0, 255)
        local v264 = v259.B * 255 + 0.5
        local v265 = math.floor(v264)
        cloudsColorB = math.clamp(v265, 0, 255)
        if cloudsEnabled then
            if not cloudsInstance then
                ensureCloudsInstance()
            end
            if cloudsInstance then
                cloudsInstance.Color = Color3.fromRGB(cloudsColorR, cloudsColorG, cloudsColorB)
            end
        end
    end
end)
local v_u_266 = false
local v_u_267 = nil
local v_u_268 = {}
local v_u_269 = "Default"
local v_u_270 = 0
local v_u_271 = 0
local v_u_272 = 255
local v_u_273 = 255
local v_u_274 = 255
local v_u_275 = true
local v_u_276 = {
    ["Default"] = nil,
    ["ForceField"] = Enum.Material.ForceField,
    ["Neon"] = Enum.Material.Neon
}
local function v_u_279(p277)
    -- upvalues: (ref) v_u_266, (copy) v_u_268, (ref) v_u_269, (copy) v_u_276, (ref) v_u_270, (ref) v_u_271, (ref) v_u_272, (ref) v_u_273, (ref) v_u_274, (ref) v_u_275
    if v_u_266 then
        if not v_u_268[p277] then
            v_u_268[p277] = {
                ["Material"] = p277.Material,
                ["MaterialVariant"] = p277.MaterialVariant,
                ["Transparency"] = p277.Transparency,
                ["Reflectance"] = p277.Reflectance,
                ["Color"] = p277.Color,
                ["CastShadow"] = p277.CastShadow
            }
        end
        if v_u_269 == "Default" then
            if v_u_268[p277] then
                p277.Material = v_u_268[p277].Material
                p277.MaterialVariant = v_u_268[p277].MaterialVariant
            end
        else
            local v278 = v_u_276[v_u_269]
            if v278 then
                p277.Material = v278
                p277.MaterialVariant = ""
            end
        end
        p277.Transparency = v_u_270
        p277.Reflectance = v_u_271
        if v_u_272 == 255 and (v_u_273 == 255 and v_u_274 == 255) then
            if v_u_268[p277] then
                p277.Color = v_u_268[p277].Color
            end
        else
            p277.Color = Color3.fromRGB(v_u_272, v_u_273, v_u_274)
        end
        p277.CastShadow = v_u_275
    end
end
local function v_u_281(p280)
    -- upvalues: (copy) v_u_268
    if v_u_268[p280] then
        p280.Material = v_u_268[p280].Material
        p280.MaterialVariant = v_u_268[p280].MaterialVariant
        p280.Transparency = v_u_268[p280].Transparency
        p280.Reflectance = v_u_268[p280].Reflectance
        p280.Color = v_u_268[p280].Color
        p280.CastShadow = v_u_268[p280].CastShadow
    end
end
local function v_u_285(p282, p283)
    -- upvalues: (copy) v_u_285
    for _, v284 in ipairs(p282:GetChildren()) do
        if v284:IsA("BasePart") and v284.Name == "Wall" then
            table.insert(p283, v284)
        elseif not v284:IsA("BasePart") then
            v_u_285(v284, p283)
        end
    end
end
function updateAllWalls()
    -- upvalues: (copy) v_u_285, (ref) v_u_266, (copy) v_u_279, (copy) v_u_281
    local v_u_286 = {}
    local v287 = game.Workspace:FindFirstChild("FFA")
    if v287 then
        v_u_285(v287, v_u_286)
    end
    for _, v288 in ipairs(game.Workspace:GetChildren()) do
        if v288:IsA("Model") and v288.Name:match("^Arena_") then
            v_u_285(v288, v_u_286)
        end
    end
    local v289 = game.Workspace:FindFirstChild("Duel Arenas")
    if v289 then
        for _, v290 in ipairs(v289:GetChildren()) do
            if v290:IsA("Model") then
                v_u_285(v290, v_u_286)
            end
        end
    end
    local v_u_291 = v_u_266 and v_u_279 or v_u_281
    local v_u_292 = 1
    local function v_u_297()
        -- upvalues: (ref) v_u_292, (copy) v_u_286, (copy) v_u_291, (copy) v_u_297
        local v293 = v_u_292 + 15 - 1
        local v294 = #v_u_286
        local v295 = math.min(v293, v294)
        for v296 = v_u_292, v295 do
            v_u_291(v_u_286[v296])
        end
        v_u_292 = v295 + 1
        if v_u_292 <= #v_u_286 then
            task.spawn(v_u_297)
        end
    end
    task.spawn(v_u_297)
end
local v_u_298 = {}
local v344 = WorldPage:AddToggle("Custom Walls", false, function(p299)
    -- upvalues: (ref) v_u_266, (ref) v_u_267, (ref) v_u_298, (copy) v_u_279, (copy) v_u_285
    v_u_266 = p299
    updateAllWalls()
    if v_u_266 then
        if v_u_267 then
            v_u_267:Disconnect()
        end
        for _, v300 in pairs(v_u_298) do
            v300:Disconnect()
        end
        v_u_298 = {}
        local v301 = game.Workspace:FindFirstChild("FFA")
        if v301 then
            v_u_267 = v301.DescendantAdded:Connect(function(p302)
                -- upvalues: (ref) v_u_279
                if p302:IsA("BasePart") and p302.Name == "Wall" then
                    v_u_279(p302)
                end
            end)
        end
        v_u_298.WorkspaceMonitor = game.Workspace.ChildAdded:Connect(function(p303)
            -- upvalues: (ref) v_u_285, (ref) v_u_279, (ref) v_u_298
            if p303:IsA("Model") and p303.Name:match("^Arena_") then
                task.wait(0.1)
                local v_u_304 = {}
                v_u_285(p303, v_u_304)
                local v_u_305 = v_u_279
                local v_u_306 = 1
                local function v_u_311()
                    -- upvalues: (ref) v_u_306, (copy) v_u_304, (copy) v_u_305, (copy) v_u_311
                    local v307 = v_u_306 + 15 - 1
                    local v308 = #v_u_304
                    local v309 = math.min(v307, v308)
                    for v310 = v_u_306, v309 do
                        v_u_305(v_u_304[v310])
                    end
                    v_u_306 = v309 + 1
                    if v_u_306 <= #v_u_304 then
                        task.spawn(v_u_311)
                    end
                end
                task.spawn(v_u_311)
                v_u_298[p303.Name .. "_Descendant"] = p303.DescendantAdded:Connect(function(p312)
                    -- upvalues: (ref) v_u_279
                    if p312:IsA("BasePart") and p312.Name == "Wall" then
                        v_u_279(p312)
                    end
                end)
                v_u_298[p303.Name .. "_Child"] = p303.ChildAdded:Connect(function(p313)
                    -- upvalues: (ref) v_u_279
                    if p313:IsA("BasePart") and p313.Name == "Wall" then
                        v_u_279(p313)
                    end
                end)
            elseif p303.Name == "Duel Arenas" and p303:IsA("Folder") then
                v_u_298.DuelArenasMonitor = p303.ChildAdded:Connect(function(p314)
                    -- upvalues: (ref) v_u_285, (ref) v_u_279, (ref) v_u_298
                    if p314:IsA("Model") then
                        task.wait(0.1)
                        local v_u_315 = {}
                        v_u_285(p314, v_u_315)
                        local v_u_316 = v_u_279
                        local v_u_317 = 1
                        local function v_u_322()
                            -- upvalues: (ref) v_u_317, (copy) v_u_315, (copy) v_u_316, (copy) v_u_322
                            local v318 = v_u_317 + 15 - 1
                            local v319 = #v_u_315
                            local v320 = math.min(v318, v319)
                            for v321 = v_u_317, v320 do
                                v_u_316(v_u_315[v321])
                            end
                            v_u_317 = v320 + 1
                            if v_u_317 <= #v_u_315 then
                                task.spawn(v_u_322)
                            end
                        end
                        task.spawn(v_u_322)
                        v_u_298[p314.Name .. "_Descendant"] = p314.DescendantAdded:Connect(function(p323)
                            -- upvalues: (ref) v_u_279
                            if p323:IsA("BasePart") and p323.Name == "Wall" then
                                v_u_279(p323)
                            end
                        end)
                        v_u_298[p314.Name .. "_Child"] = p314.ChildAdded:Connect(function(p324)
                            -- upvalues: (ref) v_u_279
                            if p324:IsA("BasePart") and p324.Name == "Wall" then
                                v_u_279(p324)
                            end
                        end)
                    end
                end)
            end
        end)
        local v325 = game.Workspace:FindFirstChild("Duel Arenas")
        if v325 then
            v_u_298.DuelArenasMonitor = v325.ChildAdded:Connect(function(p326)
                -- upvalues: (ref) v_u_285, (ref) v_u_279, (ref) v_u_298
                if p326:IsA("Model") then
                    task.wait(0.1)
                    local v_u_327 = {}
                    v_u_285(p326, v_u_327)
                    local v_u_328 = v_u_279
                    local v_u_329 = 1
                    local function v_u_334()
                        -- upvalues: (ref) v_u_329, (copy) v_u_327, (copy) v_u_328, (copy) v_u_334
                        local v330 = v_u_329 + 15 - 1
                        local v331 = #v_u_327
                        local v332 = math.min(v330, v331)
                        for v333 = v_u_329, v332 do
                            v_u_328(v_u_327[v333])
                        end
                        v_u_329 = v332 + 1
                        if v_u_329 <= #v_u_327 then
                            task.spawn(v_u_334)
                        end
                    end
                    task.spawn(v_u_334)
                    v_u_298[p326.Name .. "_Descendant"] = p326.DescendantAdded:Connect(function(p335)
                        -- upvalues: (ref) v_u_279
                        if p335:IsA("BasePart") and p335.Name == "Wall" then
                            v_u_279(p335)
                        end
                    end)
                    v_u_298[p326.Name .. "_Child"] = p326.ChildAdded:Connect(function(p336)
                        -- upvalues: (ref) v_u_279
                        if p336:IsA("BasePart") and p336.Name == "Wall" then
                            v_u_279(p336)
                        end
                    end)
                end
            end)
            for _, v337 in ipairs(v325:GetChildren()) do
                if v337:IsA("Model") then
                    v_u_298[v337.Name .. "_Descendant"] = v337.DescendantAdded:Connect(function(p338)
                        -- upvalues: (ref) v_u_279
                        if p338:IsA("BasePart") and p338.Name == "Wall" then
                            v_u_279(p338)
                        end
                    end)
                    v_u_298[v337.Name .. "_Child"] = v337.ChildAdded:Connect(function(p339)
                        -- upvalues: (ref) v_u_279
                        if p339:IsA("BasePart") and p339.Name == "Wall" then
                            v_u_279(p339)
                        end
                    end)
                end
            end
        end
        for _, v340 in ipairs(game.Workspace:GetChildren()) do
            if v340:IsA("Model") and v340.Name:match("^Arena_") then
                v_u_298[v340.Name .. "_Descendant"] = v340.DescendantAdded:Connect(function(p341)
                    -- upvalues: (ref) v_u_279
                    if p341:IsA("BasePart") and p341.Name == "Wall" then
                        v_u_279(p341)
                    end
                end)
                v_u_298[v340.Name .. "_Child"] = v340.ChildAdded:Connect(function(p342)
                    -- upvalues: (ref) v_u_279
                    if p342:IsA("BasePart") and p342.Name == "Wall" then
                        v_u_279(p342)
                    end
                end)
            end
        end
    else
        if v_u_267 then
            v_u_267:Disconnect()
            v_u_267 = nil
        end
        for _, v343 in pairs(v_u_298) do
            v343:Disconnect()
        end
        v_u_298 = {}
    end
end):AddSettings()
v344:AddDropdown("Material", { "Default", "ForceField", "Neon" }, "Default", function(p345)
    -- upvalues: (ref) v_u_269, (ref) v_u_266
    if type(p345) == "string" then
        v_u_269 = p345
        if v_u_266 then
            updateAllWalls()
        end
    end
end)
v344:AddSlider("Transparency", 0, 0, 1, 0.01, function(p346)
    -- upvalues: (ref) v_u_270, (ref) v_u_266
    v_u_270 = tonumber(p346) or 0
    if v_u_266 then
        updateAllWalls()
    end
end)
v344:AddSlider("Reflectance", 0, 0, 1, 0.01, function(p347)
    -- upvalues: (ref) v_u_271, (ref) v_u_266
    v_u_271 = tonumber(p347) or 0
    if v_u_266 then
        updateAllWalls()
    end
end)
v344:AddColorPicker("Color", Color3.fromRGB(255, 255, 255), function(...)
    -- upvalues: (ref) v_u_272, (ref) v_u_273, (ref) v_u_274, (ref) v_u_266, (copy) v_u_285, (copy) v_u_268
    local v348 = coerceColor3(...)
    local v349 = v348.R * 255
    v_u_272 = math.floor(v349)
    local v350 = v348.G * 255
    v_u_273 = math.floor(v350)
    local v351 = v348.B * 255
    v_u_274 = math.floor(v351)
    if v_u_266 then
        local v352 = game.Workspace:FindFirstChild("FFA")
        if v352 then
            local v_u_353 = {}
            v_u_285(v352, v_u_353)
            local function v_u_355(p354)
                -- upvalues: (ref) v_u_268, (ref) v_u_272, (ref) v_u_273, (ref) v_u_274
                if not v_u_268[p354] then
                    v_u_268[p354] = {
                        ["Material"] = p354.Material,
                        ["MaterialVariant"] = p354.MaterialVariant,
                        ["Transparency"] = p354.Transparency,
                        ["Reflectance"] = p354.Reflectance,
                        ["Color"] = p354.Color,
                        ["CastShadow"] = p354.CastShadow
                    }
                end
                if v_u_272 == 255 and (v_u_273 == 255 and v_u_274 == 255) then
                    p354.Color = v_u_268[p354].Color
                else
                    p354.Color = Color3.fromRGB(v_u_272, v_u_273, v_u_274)
                end
            end
            local v_u_356 = 1
            local function v_u_361()
                -- upvalues: (ref) v_u_356, (copy) v_u_353, (copy) v_u_355, (copy) v_u_361
                local v357 = v_u_356 + 15 - 1
                local v358 = #v_u_353
                local v359 = math.min(v357, v358)
                for v360 = v_u_356, v359 do
                    v_u_355(v_u_353[v360])
                end
                v_u_356 = v359 + 1
                if v_u_356 <= #v_u_353 then
                    task.spawn(v_u_361)
                end
            end
            task.spawn(v_u_361)
        end
    else
        return
    end
end)
v344:AddToggle("Cast Shadow", true, function(p362)
    -- upvalues: (ref) v_u_275, (ref) v_u_266
    v_u_275 = p362
    if v_u_266 then
        updateAllWalls()
    end
end)
local v_u_363 = false
local v_u_364 = workspace:FindFirstChild("tmp_clones")
local v_u_365 = nil
local v_u_366 = nil
local v_u_367 = {}
local v_u_368 = {}
local v_u_369 = "Default"
local v_u_370 = 0.7
local v_u_371 = 255
local v_u_372 = 255
local v_u_373 = 255
local v_u_374 = false
local v_u_375 = true
local v_u_376 = 0.5
local v_u_377 = 0
local v_u_378 = Color3.fromRGB(255, 255, 255)
local v_u_379 = Color3.fromRGB(255, 255, 255)
local v_u_380 = nil
local v_u_381 = {
    ["Default"] = nil,
    ["ForceField"] = Enum.Material.ForceField,
    ["Neon"] = Enum.Material.Neon,
    ["Solid"] = Enum.Material.SmoothPlastic
}
local function v_u_385(p382)
    if p382 and p382:IsA("BasePart") then
        if p382:GetAttribute("ServerPosOriginalMaterial") == nil then
            if localPlayerEnabled and Player.Character then
                local v383 = Player.Character:FindFirstChild(p382.Name, true)
                if v383 and (v383:IsA("BasePart") and originalMaterials[v383]) then
                    p382:SetAttribute("ServerPosOriginalMaterial", originalMaterials[v383].Name)
                else
                    p382:SetAttribute("ServerPosOriginalMaterial", p382.Material.Name)
                end
            else
                p382:SetAttribute("ServerPosOriginalMaterial", p382.Material.Name)
            end
        end
        if p382:GetAttribute("ServerPosOriginalColor") == nil then
            if localPlayerEnabled and Player.Character then
                local v384 = Player.Character:FindFirstChild(p382.Name, true)
                if v384 and (v384:IsA("BasePart") and originalColors[v384]) then
                    p382:SetAttribute("ServerPosOriginalColor", originalColors[v384])
                else
                    p382:SetAttribute("ServerPosOriginalColor", p382.Color)
                end
            end
            p382:SetAttribute("ServerPosOriginalColor", p382.Color)
        end
    end
end
local function v_u_393(p386)
    -- upvalues: (copy) v_u_385, (ref) v_u_369, (copy) v_u_381, (ref) v_u_371, (ref) v_u_372, (ref) v_u_373, (ref) v_u_370
    if p386 and p386:IsA("BasePart") then
        v_u_385(p386)
        if v_u_369 == "Default" then
            local v387 = p386:GetAttribute("ServerPosOriginalMaterial")
            if typeof(v387) == "string" and Enum.Material[v387] then
                p386.Material = Enum.Material[v387]
            end
        else
            local v388 = v_u_381[v_u_369]
            if v388 then
                p386.Material = v388
            else
                local v389 = p386:GetAttribute("ServerPosOriginalMaterial")
                if typeof(v389) == "string" and Enum.Material[v389] then
                    p386.Material = Enum.Material[v389]
                end
            end
        end
        local v390
        if v_u_371 >= 255 and v_u_372 >= 255 then
            v390 = v_u_373 >= 255
        else
            v390 = false
        end
        if v390 then
            local v391 = p386:GetAttribute("ServerPosOriginalColor")
            if typeof(v391) == "Color3" then
                p386.Color = v391
            end
        else
            p386.Color = Color3.fromRGB(v_u_371, v_u_372, v_u_373)
        end
        if p386.Name == "HumanoidRootPart" then
            p386.Transparency = 1
        else
            local v392 = v_u_370
            p386.Transparency = math.clamp(v392, 0, 1)
        end
        p386.LocalTransparencyModifier = 0
    end
end
local function v_u_396()
    -- upvalues: (ref) v_u_365, (ref) v_u_369, (ref) v_u_366
    if v_u_365 then
        if v_u_369 == "Neon" then
            if v_u_366 then
                v_u_366:Destroy()
                v_u_366 = nil
                return
            end
        elseif not v_u_366 then
            local v394 = Player.Character
            if v394 then
                v394 = v394:FindFirstChildOfClass("Humanoid")
            end
            if v394 then
                local v395 = v394:Clone()
                v395.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                v395.NameDisplayDistance = 9999999
                v395.DisplayName = ""
                v395.Parent = v_u_365
                v_u_366 = v395
            end
        end
    end
end
local function v_u_402()
    -- upvalues: (ref) v_u_365, (ref) v_u_368, (copy) v_u_393, (copy) v_u_396
    if v_u_365 then
        if #v_u_368 == 0 then
            v_u_368 = {}
            if v_u_365 then
                local function v_u_400(p397)
                    -- upvalues: (ref) v_u_368, (copy) v_u_400
                    for _, v398 in ipairs(p397:GetChildren()) do
                        if v398:IsA("BasePart") then
                            local v399 = v_u_368
                            table.insert(v399, v398)
                        elseif v398:IsA("Model") or (v398:IsA("Folder") or v398:IsA("Accessory")) then
                            v_u_400(v398)
                        end
                    end
                end
                v_u_400(v_u_365)
            end
        end
        for _, v401 in ipairs(v_u_368) do
            if v401 and (v401.Parent and v401:IsA("BasePart")) then
                v_u_393(v401)
                if v401.Name ~= "HumanoidRootPart" then
                    v401.LocalTransparencyModifier = 0
                end
            end
        end
        v_u_396()
        ensureServerPosHighlight()
    end
end
local function v_u_405()
    -- upvalues: (ref) v_u_374, (ref) v_u_365, (ref) v_u_380, (ref) v_u_376, (ref) v_u_377, (ref) v_u_378, (ref) v_u_379, (ref) v_u_375
    if v_u_374 and v_u_365 then
        if not v_u_380 then
            v_u_380 = Instance.new("Highlight")
            v_u_380.Name = "ServerPosHighlight"
            v_u_380.Parent = v_u_365
        end
        v_u_380.Adornee = v_u_365
        local v403 = v_u_376
        v_u_380.FillTransparency = math.clamp(v403, 0, 1)
        local v404 = v_u_377
        v_u_380.OutlineTransparency = math.clamp(v404, 0, 1)
        v_u_380.FillColor = v_u_378
        v_u_380.OutlineColor = v_u_379
        v_u_380.DepthMode = v_u_375 and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    else
        if v_u_380 then
            v_u_380:Destroy()
        end
        v_u_380 = nil
    end
end
local function v_u_407()
    -- upvalues: (ref) v_u_367
    for _, v406 in pairs(v_u_367) do
        if v406 and v406.Disconnect then
            v406:Disconnect()
        end
    end
    v_u_367 = {}
end
local function v_u_422()
    -- upvalues: (copy) v_u_407, (ref) v_u_365, (ref) v_u_368, (ref) v_u_363, (copy) v_u_393, (ref) v_u_367
    v_u_407()
    if v_u_365 then
        local function v414(p408)
            -- upvalues: (ref) v_u_368, (ref) v_u_363, (ref) v_u_393, (ref) v_u_367
            if p408:IsA("BasePart") then
                local v409 = v_u_368
                table.insert(v409, p408)
                if v_u_363 then
                    task.wait(0.05)
                    v_u_393(p408)
                    if p408.Name ~= "HumanoidRootPart" then
                        p408.LocalTransparencyModifier = 0
                        return
                    end
                end
            elseif p408:IsA("Accessory") then
                local v412 = p408.ChildAdded:Connect(function(p410)
                    -- upvalues: (ref) v_u_368, (ref) v_u_363, (ref) v_u_393
                    if p410:IsA("BasePart") then
                        local v411 = v_u_368
                        table.insert(v411, p410)
                        if v_u_363 then
                            task.wait(0.05)
                            v_u_393(p410)
                            p410.LocalTransparencyModifier = 0
                        end
                    end
                end)
                local v413 = v_u_367
                table.insert(v413, v412)
            end
        end
        local v415 = v_u_365.ChildAdded:Connect(v414)
        local v416 = v_u_367
        table.insert(v416, v415)
        for _, v417 in ipairs(v_u_365:GetChildren()) do
            if v417:IsA("Accessory") then
                local v420 = v417.ChildAdded:Connect(function(p418)
                    -- upvalues: (ref) v_u_368, (ref) v_u_363, (ref) v_u_393
                    if p418:IsA("BasePart") then
                        local v419 = v_u_368
                        table.insert(v419, p418)
                        if v_u_363 then
                            task.wait(0.05)
                            v_u_393(p418)
                            p418.LocalTransparencyModifier = 0
                        end
                    end
                end)
                local v421 = v_u_367
                table.insert(v421, v420)
            end
        end
    end
end
local function v_u_431()
    -- upvalues: (copy) v_u_364, (ref) v_u_365, (ref) v_u_366, (ref) v_u_368
    if not v_u_364 then
        return false
    end
    local v423 = v_u_364:FindFirstChild(Player.Name)
    if not v423 then
        return false
    end
    v_u_365 = nil
    v_u_366 = nil
    v_u_368 = {}
    local v424 = {}
    for _, v425 in ipairs(v423:GetChildren()) do
        if v425:IsA("Model") and v425.Name == "" then
            table.insert(v424, v425)
        end
    end
    if #v424 <= 0 then
        return false
    end
    v_u_365 = v424[#v424]
    v_u_366 = v_u_365:FindFirstChildOfClass("Humanoid")
    for v426 = 1, #v424 - 1 do
        v424[v426]:Destroy()
    end
    v_u_368 = {}
    if v_u_365 then
        local function v_u_430(p427)
            -- upvalues: (ref) v_u_368, (copy) v_u_430
            for _, v428 in ipairs(p427:GetChildren()) do
                if v428:IsA("BasePart") then
                    local v429 = v_u_368
                    table.insert(v429, v428)
                elseif v428:IsA("Model") or (v428:IsA("Folder") or v428:IsA("Accessory")) then
                    v_u_430(v428)
                end
            end
        end
        v_u_430(v_u_365)
    end
    return true
end
local function v_u_437()
    -- upvalues: (ref) v_u_363, (ref) v_u_368, (ref) v_u_380, (copy) v_u_407, (copy) v_u_431, (ref) v_u_365, (copy) v_u_402, (copy) v_u_422
    if v_u_363 then
        if v_u_431() then
            v_u_368 = {}
            if v_u_365 then
                local function v_u_435(p432)
                    -- upvalues: (ref) v_u_368, (copy) v_u_435
                    for _, v433 in ipairs(p432:GetChildren()) do
                        if v433:IsA("BasePart") then
                            local v434 = v_u_368
                            table.insert(v434, v433)
                        elseif v433:IsA("Model") or (v433:IsA("Folder") or v433:IsA("Accessory")) then
                            v_u_435(v433)
                        end
                    end
                end
                v_u_435(v_u_365)
            end
            v_u_402()
            v_u_422()
        else
            v_u_368 = {}
        end
    else
        if #v_u_368 > 0 then
            for _, v436 in ipairs(v_u_368) do
                if v436 and (v436.Parent and v436:IsA("BasePart")) then
                    v436.Transparency = 1
                end
            end
        end
        if v_u_380 then
            v_u_380:Destroy()
        end
        v_u_380 = nil
        v_u_407()
        v_u_368 = {}
        return
    end
end
v_u_437()
if v_u_364 then
    local v439 = v_u_364.ChildAdded:Connect(function(p438)
        -- upvalues: (copy) v_u_437
        if p438.Name == Player.Name then
            task.wait(1.2)
            v_u_437()
        end
    end)
    local v440 = v_u_367
    table.insert(v440, v439)
    local v441 = v_u_364:FindFirstChild(Player.Name)
    if v441 then
        local v443 = v441.ChildAdded:Connect(function(p442)
            -- upvalues: (copy) v_u_437
            if p442:IsA("Model") and p442.Name == "" then
                task.wait(0.2)
                v_u_437()
            end
        end)
        local v444 = v_u_367
        table.insert(v444, v443)
        v_u_437()
    end
end
CharacterPage:AddToggle("Self ESP", false, function(p445)
    SELF_ESP_Enabled = p445
    if not SELF_ESP_Enabled then
        clearSelfESP()
    end
    updateESP()
    updateChams()
end)
local v447 = CharacterPage:AddToggle("Server Pos", false, function(p446)
    -- upvalues: (ref) v_u_363, (copy) v_u_437
    v_u_363 = p446
    v_u_437()
end):AddSettings()
v447:AddDropdown("Material", {
    "Default",
    "ForceField",
    "Neon",
    "Solid"
}, v_u_369, function(p448)
    -- upvalues: (ref) v_u_369, (ref) v_u_363, (copy) v_u_402
    if type(p448) == "string" then
        v_u_369 = p448
        if v_u_363 then
            v_u_402()
        end
    end
end)
v447:AddSlider("Transparency", v_u_370, 0, 1, 0.01, function(p449)
    -- upvalues: (ref) v_u_370, (ref) v_u_363, (copy) v_u_402
    local v450 = tonumber(p449)
    if v450 then
        v_u_370 = math.clamp(v450, 0, 1)
        if v_u_363 then
            v_u_402()
        end
    end
end)
v447:AddColorPicker("Color", Color3.fromRGB(v_u_371, v_u_372, v_u_373), function(...)
    -- upvalues: (ref) v_u_371, (ref) v_u_372, (ref) v_u_373, (ref) v_u_363, (copy) v_u_402
    local v451 = coerceColor3(...)
    if v451 then
        local v452 = v451.R * 255 + 0.5
        local v453 = math.floor(v452)
        v_u_371 = math.clamp(v453, 0, 255)
        local v454 = v451.G * 255 + 0.5
        local v455 = math.floor(v454)
        v_u_372 = math.clamp(v455, 0, 255)
        local v456 = v451.B * 255 + 0.5
        local v457 = math.floor(v456)
        v_u_373 = math.clamp(v457, 0, 255)
        if v_u_363 then
            v_u_402()
        end
    end
end)
v447:AddToggle("Highlight", v_u_374, function(p458)
    -- upvalues: (ref) v_u_374, (copy) v_u_405
    v_u_374 = p458
    v_u_405()
end)
v447:AddSlider("Fill Transparency", v_u_376, 0, 1, 0.01, function(p459)
    -- upvalues: (ref) v_u_376, (copy) v_u_405
    local v460 = tonumber(p459)
    if v460 then
        v_u_376 = math.clamp(v460, 0, 1)
        v_u_405()
    end
end)
v447:AddSlider("Outline Transparency", v_u_377, 0, 1, 0.01, function(p461)
    -- upvalues: (ref) v_u_377, (copy) v_u_405
    local v462 = tonumber(p461)
    if v462 then
        v_u_377 = math.clamp(v462, 0, 1)
        v_u_405()
    end
end)
v447:AddColorPicker("Fill Color", v_u_378, function(...)
    -- upvalues: (ref) v_u_378, (copy) v_u_405
    local v463 = coerceColor3(...)
    if v463 then
        v_u_378 = v463
        v_u_405()
    end
end)
v447:AddColorPicker("Outline Color", v_u_379, function(...)
    -- upvalues: (ref) v_u_379, (copy) v_u_405
    local v464 = coerceColor3(...)
    if v464 then
        v_u_379 = v464
        v_u_405()
    end
end)
v447:AddToggle("On Top", v_u_375, function(p465)
    -- upvalues: (ref) v_u_375, (copy) v_u_405
    v_u_375 = p465 and true or false
    v_u_405()
end)
visualizeFakePosEnabled = false
fakePosCloneModel = nil
fakePosCloneHRP = nil
fakePosOriginalHRP = nil
fakePosCloneHumanoid = nil
fakePosPartMap = nil
fakePosHeartbeatConnection = nil
fakePosStepFunc = nil
fakePosHighlight = nil
fakePosAccessoriesCount = 0
fakePosTransparencyValue = 0
fakePosOffset = CFrame.new()
fakePosMaterialOption = "Default"
fakePosColorR = 255
fakePosColorG = 255
fakePosColorB = 255
fakePosHighlightEnabled = false
fakePosHighlightAlwaysOnTop = true
fakePosHighlightFillTransparency = 0.5
fakePosHighlightOutlineTransparency = 0
local v466 = Color3.fromRGB(255, 255, 255)
local v467 = Color3.fromRGB(255, 255, 255)
fakePosHighlightFillColor = v466
fakePosHighlightOutlineColor = v467
fakePosPartsCache = {}
fakePosMaterialMap = {
    ["Default"] = nil,
    ["ForceField"] = Enum.Material.ForceField,
    ["Neon"] = Enum.Material.Neon,
    ["Solid"] = Enum.Material.SmoothPlastic
}
local function v_u_472()
    if fakePosHighlightEnabled and fakePosCloneModel then
        if not fakePosHighlight then
            fakePosHighlight = Instance.new("Highlight")
            fakePosHighlight.Name = "FakePosHighlight"
            fakePosHighlight.Parent = fakePosCloneModel
        end
        fakePosHighlight.Adornee = fakePosCloneModel
        local v468 = fakePosHighlight
        local v469 = fakePosHighlightFillTransparency
        v468.FillTransparency = math.clamp(v469, 0, 1)
        local v470 = fakePosHighlight
        local v471 = fakePosHighlightOutlineTransparency
        v470.OutlineTransparency = math.clamp(v471, 0, 1)
        fakePosHighlight.FillColor = fakePosHighlightFillColor
        fakePosHighlight.OutlineColor = fakePosHighlightOutlineColor
        fakePosHighlight.DepthMode = fakePosHighlightAlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    else
        if fakePosHighlight then
            fakePosHighlight:Destroy()
        end
        fakePosHighlight = nil
    end
end
local function v_u_475()
    if fakePosCloneModel then
        if fakePosMaterialOption == "Neon" then
            if fakePosCloneHumanoid then
                fakePosCloneHumanoid:Destroy()
                fakePosCloneHumanoid = nil
                return
            end
        elseif not fakePosCloneHumanoid then
            local v473 = Player.Character
            if v473 then
                v473 = v473:FindFirstChildOfClass("Humanoid")
            end
            if v473 then
                local v474 = v473:Clone()
                v474.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                v474.NameDisplayDistance = 9999999
                v474.DisplayName = ""
                v474.Parent = fakePosCloneModel
                fakePosCloneHumanoid = v474
            end
        end
    end
end
local function v_u_483(p476)
    if typeof(p476) == "Color3" then
        local v477 = p476.R * 255 + 0.5
        local v478 = math.floor(v477)
        fakePosColorR = math.clamp(v478, 0, 255)
        local v479 = p476.G * 255 + 0.5
        local v480 = math.floor(v479)
        fakePosColorG = math.clamp(v480, 0, 255)
        local v481 = p476.B * 255 + 0.5
        local v482 = math.floor(v481)
        fakePosColorB = math.clamp(v482, 0, 255)
        updateFakePosAppearance()
    end
end
function coerceColor3(p484, p485, p486)
    if typeof(p484) == "Color3" then
        return p484
    else
        if typeof(p484) == "table" then
            local v487 = p484.Color
            if typeof(v487) == "Color3" then
                return p484.Color
            end
            local v488 = p484.R or (p484.r or p484[1])
            local v489 = p484.G or (p484.g or p484[2])
            local v490 = p484.B or (p484.b or p484[3])
            if typeof(v488) == "number" and (typeof(v489) == "number" and typeof(v490) == "number") then
                if v488 <= 1 and (v489 <= 1 and v490 <= 1) then
                    return Color3.new(v488, v489, v490)
                else
                    return Color3.fromRGB(v488, v489, v490)
                end
            end
        end
        if typeof(p484) == "number" and (typeof(p485) == "number" and typeof(p486) == "number") then
            if p484 <= 1 and (p485 <= 1 and p486 <= 1) then
                return Color3.new(p484, p485, p486)
            else
                return Color3.fromRGB(p484, p485, p486)
            end
        else
            return nil
        end
    end
end
function setupFakePosOriginalAttributes(p491)
    if p491 and p491:IsA("BasePart") then
        if p491:GetAttribute("FakePosOriginalMaterial") == nil then
            if localPlayerEnabled and Player.Character then
                local v492 = Player.Character:FindFirstChild(p491.Name)
                if v492 and (v492:IsA("BasePart") and originalMaterials[v492]) then
                    p491:SetAttribute("FakePosOriginalMaterial", originalMaterials[v492].Name)
                else
                    p491:SetAttribute("FakePosOriginalMaterial", p491.Material.Name)
                end
            else
                p491:SetAttribute("FakePosOriginalMaterial", p491.Material.Name)
            end
        end
        if p491:GetAttribute("FakePosOriginalColor") == nil then
            if localPlayerEnabled and Player.Character then
                local v493 = Player.Character:FindFirstChild(p491.Name)
                if v493 and (v493:IsA("BasePart") and originalColors[v493]) then
                    p491:SetAttribute("FakePosOriginalColor", originalColors[v493])
                else
                    p491:SetAttribute("FakePosOriginalColor", p491.Color)
                end
            end
            p491:SetAttribute("FakePosOriginalColor", p491.Color)
        end
    end
end
function applyFakePosAppearance(p494)
    if p494 and p494:IsA("BasePart") then
        setupFakePosOriginalAttributes(p494)
        if fakePosMaterialOption == "Default" then
            local v495 = p494:GetAttribute("FakePosOriginalMaterial")
            if typeof(v495) == "string" and Enum.Material[v495] then
                p494.Material = Enum.Material[v495]
            end
        else
            local v496 = fakePosMaterialMap[fakePosMaterialOption]
            if v496 then
                p494.Material = v496
            else
                local v497 = p494:GetAttribute("FakePosOriginalMaterial")
                if typeof(v497) == "string" and Enum.Material[v497] then
                    p494.Material = Enum.Material[v497]
                end
            end
        end
        local v498
        if fakePosColorR >= 255 and fakePosColorG >= 255 then
            v498 = fakePosColorB >= 255
        else
            v498 = false
        end
        if v498 then
            local v499 = p494:GetAttribute("FakePosOriginalColor")
            if typeof(v499) == "Color3" then
                p494.Color = v499
            end
        else
            p494.Color = Color3.fromRGB(fakePosColorR, fakePosColorG, fakePosColorB)
        end
        local v500 = fakePosTransparencyValue
        p494.Transparency = math.clamp(v500, 0, 1)
        if p494.Name == "HumanoidRootPart" then
            p494.Transparency = 1
        end
    end
end
local function v_u_505()
    fakePosPartsCache = {}
    if fakePosCloneModel then
        local function v_u_504(p501)
            -- upvalues: (copy) v_u_504
            for _, v502 in ipairs(p501:GetChildren()) do
                if v502:IsA("BasePart") then
                    local v503 = fakePosPartsCache
                    table.insert(v503, v502)
                elseif v502:IsA("Model") or (v502:IsA("Folder") or v502:IsA("Accessory")) then
                    v_u_504(v502)
                end
            end
        end
        v_u_504(fakePosCloneModel)
    end
end
local function v_u_507()
    -- upvalues: (copy) v_u_505, (copy) v_u_475, (copy) v_u_472
    if fakePosCloneModel then
        if #fakePosPartsCache == 0 then
            v_u_505()
        end
        for _, v506 in ipairs(fakePosPartsCache) do
            if v506 and (v506.Parent and v506:IsA("BasePart")) then
                applyFakePosAppearance(v506)
            end
        end
        v_u_475()
        v_u_472()
        updateFakePosVisibilityForCamera()
    end
end
local function v_u_508()
    if fakePosHeartbeatConnection then
        fakePosHeartbeatConnection:Disconnect()
        fakePosHeartbeatConnection = nil
    end
    if fakePosCloneModel then
        fakePosCloneModel:Destroy()
    end
    fakePosCloneModel = nil
    fakePosCloneHRP = nil
    fakePosOriginalHRP = nil
    fakePosCloneHumanoid = nil
    fakePosPartMap = nil
    fakePosAccessoriesCount = 0
    fakePosAccessoryMap = {}
    fakePosStepFunc = nil
    fakePosOffset = CFrame.new()
    fakePosPartsCache = {}
    if fakePosHighlight then
        fakePosHighlight:Destroy()
    end
    fakePosHighlight = nil
end
local function v_u_577()
    -- upvalues: (copy) v_u_508, (copy) v_u_505, (copy) v_u_507, (copy) v_u_577
    v_u_508()
    local v509 = Player.Character
    if v509 then
        local v510 = v509:FindFirstChild("HumanoidRootPart")
        if v510 then
            fakePosCloneModel = Instance.new("Model")
            fakePosCloneModel.Name = ""
            fakePosCloneModel.Parent = workspace
            fakePosOriginalHRP = v510
            fakePosCloneHRP = nil
            fakePosCloneHumanoid = nil
            fakePosPartMap = {}
            fakePosAccessoriesCount = 0
            fakePosAccessoryMap = {}
            local function v_u_535(p_u_511)
                if p_u_511:IsA("BasePart") and p_u_511:FindFirstAncestorOfClass("Tool") then
                    return
                else
                    local function v_u_514(p512)
                        -- upvalues: (copy) v_u_514
                        for _, v_u_513 in ipairs(p512:GetChildren()) do
                            if v_u_513:IsA("JointInstance") or (v_u_513:IsA("Decal") or (v_u_513:IsA("WeldConstraint") or (v_u_513:IsA("Attachment") or (v_u_513:IsA("Beam") or (v_u_513:IsA("ParticleEmitter") or (v_u_513:IsA("Script") or v_u_513:IsA("LocalScript"))))))) then
                                pcall(function()
                                    -- upvalues: (copy) v_u_513
                                    v_u_513:Destroy()
                                end)
                            else
                                v_u_514(v_u_513)
                            end
                        end
                    end
                    local function v_u_517(p515)
                        -- upvalues: (copy) v_u_517
                        for _, v_u_516 in ipairs(p515:GetChildren()) do
                            if v_u_516:IsA("JointInstance") or (v_u_516:IsA("Decal") or (v_u_516:IsA("Attachment") or (v_u_516:IsA("Beam") or (v_u_516:IsA("ParticleEmitter") or (v_u_516:IsA("Script") or v_u_516:IsA("LocalScript")))))) then
                                pcall(function()
                                    -- upvalues: (copy) v_u_516
                                    v_u_516:Destroy()
                                end)
                            elseif v_u_516:IsA("Weld") then
                                if v_u_516.Name ~= "AccessoryWeld" then
                                    pcall(function()
                                        -- upvalues: (copy) v_u_516
                                        v_u_516:Destroy()
                                    end)
                                end
                            else
                                v_u_517(v_u_516)
                            end
                        end
                    end
                    if p_u_511:IsA("BasePart") and not p_u_511.Parent:IsA("Accessory") then
                        local v518 = p_u_511:Clone()
                        v_u_514(v518)
                        if v518.Name == "Head" and v518:IsA("MeshPart") then
                            v518.TextureID = ""
                        end
                        if v518:IsA("BasePart") then
                            v518.CanCollide = false
                            v518.Anchored = true
                        end
                        applyFakePosAppearance(v518)
                        if v518.Name == "Head" then
                            v518.Size = Vector3.new(1, 1, 1)
                        end
                        v518.Parent = fakePosCloneModel
                        if v518.Name == "HumanoidRootPart" then
                            fakePosCloneHRP = v518
                        end
                        fakePosPartMap[v518] = p_u_511
                        return
                    elseif p_u_511:IsA("Accessory") then
                        fakePosAccessoriesCount = fakePosAccessoriesCount + 1
                        local v519 = p_u_511:Clone()
                        v_u_517(v519)
                        local v520 = p_u_511:FindFirstChild("Handle")
                        if v520 then
                            v520 = v520:FindFirstChild("AccessoryWeld")
                        end
                        local v_u_521 = nil
                        local function v_u_524(p522)
                            -- upvalues: (copy) p_u_511, (ref) v_u_521, (copy) v_u_524
                            for _, v523 in ipairs(p522:GetChildren()) do
                                if v523:IsA("BasePart") then
                                    applyFakePosAppearance(v523)
                                    if v523.Name == "Handle" then
                                        v523.Name = "Handle_" .. p_u_511.Name .. "_" .. fakePosAccessoriesCount
                                        v_u_521 = v523
                                        v523.CanCollide = false
                                        v523.Anchored = false
                                    end
                                    v_u_524(v523)
                                elseif v523:IsA("Model") or v523:IsA("Folder") then
                                    v_u_524(v523)
                                end
                            end
                        end
                        v_u_524(v519)
                        if v_u_521 then
                            local v525
                            if v520 then
                                v525 = v520.C0
                            else
                                v525 = v520
                            end
                            if v520 then
                                v520 = v520.C1
                            end
                            local v526 = v_u_521:FindFirstChild("AccessoryWeld")
                            if not v526 then
                                v526 = Instance.new("Weld")
                                v526.Name = "AccessoryWeld"
                                v526.Part0 = v_u_521
                                v526.Parent = v_u_521
                            end
                            if v525 then
                                v526.C0 = v525
                            end
                            if v520 then
                                v526.C1 = v520
                            end
                            local v527 = {
                                ["handle"] = v_u_521,
                                ["originalAccessory"] = p_u_511,
                                ["weld"] = v526
                            }
                            fakePosAccessoryMap[v519] = v527
                        end
                        local function v_u_530(p528)
                            -- upvalues: (copy) v_u_530
                            for _, v529 in ipairs(p528:GetChildren()) do
                                if v529:IsA("BasePart") and not v529.Name:match("^Handle_") then
                                    if v529:IsA("BasePart") then
                                        v529.CanCollide = false
                                        v529.Anchored = true
                                    end
                                elseif v529:IsA("Model") or v529:IsA("Folder") then
                                    v_u_530(v529)
                                end
                            end
                        end
                        v_u_530(v519)
                        v519.Parent = fakePosCloneModel
                        return
                    elseif p_u_511:IsA("Shirt") or (p_u_511:IsA("Pants") or p_u_511:IsA("ShirtGraphic")) then
                        local v531 = p_u_511:Clone()
                        local function v_u_534(p532)
                            -- upvalues: (copy) v_u_534
                            for _, v533 in ipairs(p532:GetChildren()) do
                                if v533:IsA("BasePart") then
                                    if v533:IsA("BasePart") then
                                        v533.CanCollide = false
                                        v533.Anchored = true
                                    end
                                elseif v533:IsA("Model") or (v533:IsA("Folder") or v533:IsA("Accessory")) then
                                    v_u_534(v533)
                                end
                            end
                        end
                        v_u_534(v531)
                        v531.Parent = fakePosCloneModel
                        return
                    elseif p_u_511:IsA("CharacterMesh") then
                        p_u_511:Clone().Parent = fakePosCloneModel
                    elseif p_u_511:IsA("Humanoid") then
                        fakePosCloneHumanoid = p_u_511:Clone()
                        fakePosCloneHumanoid.Health = 100
                        fakePosCloneHumanoid.MaxHealth = 100
                        fakePosCloneHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
                        fakePosCloneHumanoid.NameDisplayDistance = 9999999
                        fakePosCloneHumanoid.DisplayName = ""
                        fakePosCloneHumanoid.Parent = fakePosCloneModel
                    end
                end
            end
            local function v_u_538(p536)
                -- upvalues: (copy) v_u_535, (copy) v_u_538
                for _, v537 in ipairs(p536:GetChildren()) do
                    v_u_535(v537)
                    if v537:IsA("Model") or (v537:IsA("Folder") or v537:IsA("Accessory")) then
                        v_u_538(v537)
                    end
                end
            end
            v_u_538(v509);
            (function()
                for v539, v540 in pairs(fakePosAccessoryMap) do
                    if v539 and (v539.Parent and (v540.handle and fakePosCloneModel)) then
                        local v541 = v540.weld or v540.handle:FindFirstChild("AccessoryWeld")
                        if v541 then
                            local v542 = v540.originalAccessory
                            if v542 then
                                v542 = v542:FindFirstChild("Handle", true)
                            end
                            if v542 then
                                v542 = v542:FindFirstChild("AccessoryWeld")
                            end
                            local v543
                            if v542 and v542.Part1 then
                                local v544 = v542.Part1.Name
                                v543 = fakePosCloneModel:FindFirstChild(v544)
                            else
                                v543 = nil
                            end
                            local v545 = v543 or fakePosCloneModel:FindFirstChild("Head")
                            if v545 then
                                v541.Part0 = v540.handle
                                v541.Part1 = v545
                                if v542 then
                                    if v542.C0 then
                                        v541.C0 = v542.C0
                                    end
                                    if v542.C1 then
                                        v541.C1 = v542.C1
                                    end
                                end
                            end
                        end
                        if v540.handle then
                            v540.handle.Anchored = false
                        end
                    end
                end
            end)()
            local function v_u_550(p546)
                -- upvalues: (copy) v_u_550
                for _, v547 in ipairs(p546:GetChildren()) do
                    if v547:IsA("BasePart") and not v547.Name:match("^Handle_") then
                        local v548 = v547.Parent
                        local v549 = false
                        while v548 do
                            if v548:IsA("Accessory") then
                                v549 = true
                                break
                            end
                            v548 = v548.Parent
                        end
                        if not v549 and v547:IsA("BasePart") then
                            v547.CanCollide = false
                            v547.Anchored = true
                        end
                    elseif not v547:IsA("Accessory") then
                        if (v547:IsA("Model") or v547:IsA("Folder")) and not v547:IsA("Accessory") then
                            v_u_550(v547)
                        end
                    end
                end
            end
            v_u_550(fakePosCloneModel)
            for _, v551 in pairs(fakePosAccessoryMap) do
                if v551.handle then
                    v551.handle.Anchored = false
                end
            end
            v_u_505()
            if fakePosCloneHRP then
                fakePosCloneModel.PrimaryPart = fakePosCloneHRP
                fakePosOffset = CFrame.new()
                v_u_505()
                v_u_507()
                task.defer(function()
                    task.wait(0.5)
                    if fakePosCloneModel and fakePosCloneModel.Parent then
                        for v552, v553 in pairs(fakePosAccessoryMap) do
                            if v552 and (v552.Parent and (v553.handle and fakePosCloneModel)) then
                                local v554 = v553.weld or v553.handle:FindFirstChild("AccessoryWeld")
                                if v554 then
                                    local v555 = v553.originalAccessory
                                    if v555 then
                                        v555 = v555:FindFirstChild("Handle", true)
                                    end
                                    if v555 then
                                        v555 = v555:FindFirstChild("AccessoryWeld")
                                    end
                                    if v555 then
                                        if v555.C0 then
                                            v554.C0 = v555.C0
                                        end
                                        if v555.C1 then
                                            v554.C1 = v555.C1
                                        end
                                        if v555.Part1 then
                                            local v556 = v555.Part1.Name
                                            local v557 = fakePosCloneModel:FindFirstChild(v556)
                                            if v557 then
                                                v554.Part0 = v553.handle
                                                v554.Part1 = v557
                                            end
                                        end
                                        v553.handle.Anchored = false
                                    end
                                end
                            end
                        end
                    end
                end)
                local v_u_558 = 0
                local function v576()
                    -- upvalues: (ref) v_u_508, (ref) v_u_577, (ref) v_u_558
                    if fakePosCloneModel and (fakePosCloneHRP and fakePosOriginalHRP) then
                        local v559 = nil
                        local v560 = Player.Character
                        local v561
                        if v560 then
                            local v562 = v560:FindFirstChild("BodyYaw")
                            if v562 then
                                v561 = v562.Value
                                if typeof(v561) ~= "number" then
                                    v561 = v559
                                end
                            else
                                v561 = v559
                            end
                        else
                            v561 = v559
                        end
                        local v563 = fakePosOriginalHRP.CFrame * fakePosOffset
                        if v561 and typeof(v561) == "number" then
                            local v564 = -v561
                            local v565 = math.rad(v564)
                            v563 = v563 * CFrame.Angles(0, v565, 0)
                        end
                        fakePosCloneHRP.CFrame = v563
                        local v566 = tick()
                        if v566 - v_u_558 > 0.5 then
                            v_u_558 = v566
                            for v567, v568 in pairs(fakePosAccessoryMap) do
                                if v567 and (v567.Parent and (v568.handle and fakePosCloneModel)) then
                                    local v569 = v568.weld or v568.handle:FindFirstChild("AccessoryWeld")
                                    if v569 then
                                        local v570 = v568.originalAccessory
                                        if v570 then
                                            v570 = v570:FindFirstChild("Handle", true)
                                        end
                                        if v570 then
                                            v570 = v570:FindFirstChild("AccessoryWeld")
                                        end
                                        if v570 then
                                            if v570.C0 then
                                                v569.C0 = v570.C0
                                            end
                                            if v570.C1 then
                                                v569.C1 = v570.C1
                                            end
                                            if v570.Part1 then
                                                local v571 = v570.Part1.Name
                                                local v572 = fakePosCloneModel:FindFirstChild(v571)
                                                if v572 and v569.Part1 ~= v572 then
                                                    v569.Part1 = v572
                                                end
                                            end
                                            if v569.Part0 ~= v568.handle then
                                                v569.Part0 = v568.handle
                                            end
                                        end
                                        v568.handle.Anchored = false
                                    end
                                end
                            end
                        end
                        for v573, v574 in pairs(fakePosPartMap or {}) do
                            if v573 and (v574 and (v574.Parent and not v573.Name:match("^Handle_"))) then
                                local v575 = fakePosOriginalHRP.CFrame:ToObjectSpace(v574.CFrame)
                                v573.CFrame = fakePosCloneHRP.CFrame * v575
                                if not v573.Name:match("^Handle_") and v573:IsA("BasePart") then
                                    v573.CanCollide = false
                                    v573.Anchored = true
                                end
                                if v573:IsA("BasePart") then
                                    applyFakePosAppearance(v573)
                                end
                                if v573.Name == "Head" then
                                    v573.Size = Vector3.new(1, 1, 1)
                                end
                            end
                        end
                        if fakePosCloneHumanoid then
                            fakePosCloneHumanoid.DisplayName = ""
                        end
                    else
                        v_u_508()
                        if visualizeFakePosEnabled then
                            v_u_577()
                        end
                    end
                end
                fakePosStepFunc = v576
                fakePosHeartbeatConnection = RunService.RenderStepped:Connect(v576)
                updateFakePosVisibilityForCamera()
            else
                fakePosCloneModel:Destroy()
                fakePosCloneModel = nil
            end
        else
            return
        end
    else
        return
    end
end
function updateFakePosVisibilityForCamera()
    -- upvalues: (copy) v_u_505
    if fakePosCloneModel then
        local v578 = workspace.CurrentCamera
        local v579
        if v578 and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            v579 = (v578.CFrame.Position - Player.Character.Head.Position).Magnitude < 3
        else
            v579 = false
        end
        if v579 then
            if fakePosHeartbeatConnection then
                fakePosHeartbeatConnection:Disconnect()
                fakePosHeartbeatConnection = nil
            end
        elseif not fakePosHeartbeatConnection and fakePosStepFunc then
            fakePosHeartbeatConnection = RunService.RenderStepped:Connect(fakePosStepFunc)
        end
        if #fakePosPartsCache == 0 then
            v_u_505()
        end
        for _, v580 in ipairs(fakePosPartsCache) do
            if v580 and (v580.Parent and v580:IsA("BasePart")) then
                if v580.Name == "HumanoidRootPart" then
                    v580.Transparency = 1
                elseif v579 then
                    v580.Transparency = 1
                else
                    v580.Transparency = fakePosTransparencyValue
                end
            end
        end
    end
end
function ensureFakePosClone()
    -- upvalues: (copy) v_u_577
    if visualizeFakePosEnabled then
        v_u_577()
    end
end
local v582 = CharacterPage:AddToggle("Show Fake", false, function(p581)
    -- upvalues: (copy) v_u_577, (copy) v_u_508
    visualizeFakePosEnabled = p581
    if visualizeFakePosEnabled then
        v_u_577()
    else
        v_u_508()
    end
end):AddSettings()
v582:AddDropdown("Material", {
    "Default",
    "ForceField",
    "Neon",
    "Solid"
}, fakePosMaterialOption, function(p583)
    -- upvalues: (copy) v_u_507
    if type(p583) == "string" then
        fakePosMaterialOption = p583
        v_u_507()
    end
end)
v582:AddSlider("Transparency", fakePosTransparencyValue, 0, 1, 0.01, function(p584)
    -- upvalues: (copy) v_u_507
    local v585 = tonumber(p584)
    if v585 then
        fakePosTransparencyValue = math.clamp(v585, 0, 1)
        v_u_507()
    end
end)
v582:AddColorPicker("Color", Color3.fromRGB(fakePosColorR, fakePosColorG, fakePosColorB), function(...)
    -- upvalues: (copy) v_u_483
    local v586 = coerceColor3(...)
    if v586 then
        v_u_483(v586)
    end
end)
v582:AddToggle("Highlight", fakePosHighlightEnabled, function(p587)
    -- upvalues: (copy) v_u_472
    fakePosHighlightEnabled = p587
    v_u_472()
end)
v582:AddSlider("Fill Transparency", fakePosHighlightFillTransparency, 0, 1, 0.01, function(p588)
    -- upvalues: (copy) v_u_472
    local v589 = tonumber(p588)
    if v589 then
        fakePosHighlightFillTransparency = math.clamp(v589, 0, 1)
        v_u_472()
    end
end)
v582:AddSlider("Outline Transparency", fakePosHighlightOutlineTransparency, 0, 1, 0.01, function(p590)
    -- upvalues: (copy) v_u_472
    local v591 = tonumber(p590)
    if v591 then
        fakePosHighlightOutlineTransparency = math.clamp(v591, 0, 1)
        v_u_472()
    end
end)
v582:AddColorPicker("Fill Color", fakePosHighlightFillColor, function(...)
    -- upvalues: (copy) v_u_472
    local v592 = coerceColor3(...)
    if v592 then
        fakePosHighlightFillColor = v592
        v_u_472()
    end
end)
v582:AddColorPicker("Outline Color", fakePosHighlightOutlineColor, function(...)
    -- upvalues: (copy) v_u_472
    local v593 = coerceColor3(...)
    if v593 then
        fakePosHighlightOutlineColor = v593
        v_u_472()
    end
end)
v582:AddToggle("On Top", fakePosHighlightAlwaysOnTop, function(p594)
    -- upvalues: (copy) v_u_472
    fakePosHighlightAlwaysOnTop = p594 and true or false
    v_u_472()
end)
local v_u_595 = Player:FindFirstChild("Viewmodel")
if not v_u_595 then
    v_u_595 = Instance.new("Folder")
    v_u_595.Name = "Viewmodel"
    v_u_595.Parent = Player
end
local v_u_596 = v_u_595:FindFirstChild("ThirdP")
if not v_u_596 then
    v_u_596 = Instance.new("BoolValue")
    v_u_596.Name = "ThirdP"
    v_u_596.Value = false
    v_u_596.Parent = v_u_595
end
local v_u_597 = v_u_595:FindFirstChild("x")
if not v_u_597 then
    v_u_597 = Instance.new("NumberValue")
    v_u_597.Name = "x"
    v_u_597.Value = 0
    v_u_597.Parent = v_u_595
end
local v_u_598 = v_u_595:FindFirstChild("y")
if not v_u_598 then
    v_u_598 = Instance.new("NumberValue")
    v_u_598.Name = "y"
    v_u_598.Value = 0
    v_u_598.Parent = v_u_595
end
local v_u_599 = v_u_595:FindFirstChild("z")
if not v_u_599 then
    v_u_599 = Instance.new("NumberValue")
    v_u_599.Name = "z"
    v_u_599.Value = 0
    v_u_599.Parent = v_u_595
end
local v_u_600 = v_u_595:FindFirstChild("CustomEnabled")
if not v_u_600 then
    v_u_600 = Instance.new("BoolValue")
    v_u_600.Name = "CustomEnabled"
    v_u_600.Value = false
    v_u_600.Parent = v_u_595
end
local v_u_601 = v_u_595:FindFirstChild("ArmsMaterial")
if not v_u_601 then
    v_u_601 = Instance.new("StringValue")
    v_u_601.Name = "ArmsMaterial"
    v_u_601.Value = "Default"
    v_u_601.Parent = v_u_595
end
local v_u_602 = v_u_595:FindFirstChild("WeaponMaterial")
if not v_u_602 then
    v_u_602 = Instance.new("StringValue")
    v_u_602.Name = "WeaponMaterial"
    v_u_602.Value = "Default"
    v_u_602.Parent = v_u_595
end
local v_u_603 = v_u_595:FindFirstChild("ArmsTransparency")
if not v_u_603 then
    v_u_603 = Instance.new("NumberValue")
    v_u_603.Name = "ArmsTransparency"
    v_u_603.Value = 0
    v_u_603.Parent = v_u_595
end
local v_u_604 = v_u_595:FindFirstChild("WeaponTransparency")
if not v_u_604 then
    v_u_604 = Instance.new("NumberValue")
    v_u_604.Name = "WeaponTransparency"
    v_u_604.Value = 0
    v_u_604.Parent = v_u_595
end
local v_u_605 = v_u_595:FindFirstChild("ArmsColorR")
if not v_u_605 then
    v_u_605 = Instance.new("IntValue")
    v_u_605.Name = "ArmsColorR"
    v_u_605.Value = 255
    v_u_605.Parent = v_u_595
end
local v_u_606 = v_u_595:FindFirstChild("ArmsColorG")
if not v_u_606 then
    v_u_606 = Instance.new("IntValue")
    v_u_606.Name = "ArmsColorG"
    v_u_606.Value = 255
    v_u_606.Parent = v_u_595
end
local v_u_607 = v_u_595:FindFirstChild("ArmsColorB")
if not v_u_607 then
    v_u_607 = Instance.new("IntValue")
    v_u_607.Name = "ArmsColorB"
    v_u_607.Value = 255
    v_u_607.Parent = v_u_595
end
local v_u_608 = v_u_595:FindFirstChild("WeaponColorR")
if not v_u_608 then
    v_u_608 = Instance.new("IntValue")
    v_u_608.Name = "WeaponColorR"
    v_u_608.Value = 255
    v_u_608.Parent = v_u_595
end
local v_u_609 = v_u_595:FindFirstChild("WeaponColorG")
if not v_u_609 then
    v_u_609 = Instance.new("IntValue")
    v_u_609.Name = "WeaponColorG"
    v_u_609.Value = 255
    v_u_609.Parent = v_u_595
end
local v_u_610 = v_u_595:FindFirstChild("WeaponColorB")
if not v_u_610 then
    v_u_610 = Instance.new("IntValue")
    v_u_610.Name = "WeaponColorB"
    v_u_610.Value = 255
    v_u_610.Parent = v_u_595
end
local v_u_611 = v_u_595:FindFirstChild("ViewmodelForViewmodel")
if not v_u_611 then
    v_u_611 = Instance.new("BoolValue")
    v_u_611.Name = "ViewmodelForViewmodel"
    v_u_611.Value = true
    v_u_611.Parent = v_u_595
end
local v_u_612 = v_u_595:FindFirstChild("ViewmodelForTool")
if not v_u_612 then
    v_u_612 = Instance.new("BoolValue")
    v_u_612.Name = "ViewmodelForTool"
    v_u_612.Value = false
    v_u_612.Parent = v_u_595
end
ViewModelPage:AddToggle("In Third Person", v_u_596.Value, function(p613)
    -- upvalues: (ref) v_u_596
    v_u_596.Value = p613 and true or false
end)
ViewModelPage:AddSlider("Offset X", v_u_597.Value, -10, 10, 0.01, function(p614)
    -- upvalues: (ref) v_u_597, (ref) v_u_595
    local v615 = v_u_597
    local v616 = (tonumber(p614) or 0) * 100
    v615.Value = math.floor(v616) / 100
    local v617 = Instance.new("Configuration")
    v617.Name = "Update"
    v617.Parent = v_u_595
end)
ViewModelPage:AddSlider("Offset Y", v_u_598.Value, -10, 10, 0.01, function(p618)
    -- upvalues: (ref) v_u_598, (ref) v_u_595
    local v619 = v_u_598
    local v620 = (tonumber(p618) or 0) * 100
    v619.Value = math.floor(v620) / 100
    local v621 = Instance.new("Configuration")
    v621.Name = "Update"
    v621.Parent = v_u_595
end)
ViewModelPage:AddSlider("Offset Z", v_u_599.Value, -10, 10, 0.01, function(p622)
    -- upvalues: (ref) v_u_599, (ref) v_u_595
    local v623 = v_u_599
    local v624 = (tonumber(p622) or 0) * 100
    v623.Value = math.floor(v624) / 100
    local v625 = Instance.new("Configuration")
    v625.Name = "Update"
    v625.Parent = v_u_595
end)
local v628 = ViewModelPage:AddToggle("Custom", v_u_600.Value, function(p626)
    -- upvalues: (ref) v_u_600, (ref) v_u_595
    v_u_600.Value = p626 and true or false
    local v627 = Instance.new("Configuration")
    v627.Name = "Update"
    v627.Parent = v_u_595
end):AddSettings()
v628:AddDropdown("Arms Material", {
    "Default",
    "SmoothPlastic",
    "ForceField",
    "Neon"
}, v_u_601.Value, function(p629)
    -- upvalues: (ref) v_u_601, (ref) v_u_595
    v_u_601.Value = p629 or "Default"
    local v630 = Instance.new("Configuration")
    v630.Name = "Update"
    v630.Parent = v_u_595
end)
v628:AddDropdown("Weapon Material", {
    "Default",
    "SmoothPlastic",
    "ForceField",
    "Neon"
}, v_u_602.Value, function(p631)
    -- upvalues: (ref) v_u_602, (ref) v_u_595
    v_u_602.Value = p631 or "Default"
    local v632 = Instance.new("Configuration")
    v632.Name = "Update"
    v632.Parent = v_u_595
end)
v628:AddSlider("Arms Transparency", v_u_603.Value, 0, 1, 0.01, function(p633)
    -- upvalues: (ref) v_u_603, (ref) v_u_595
    local v634 = v_u_603
    local v635 = tonumber(p633) or 0
    v634.Value = math.clamp(v635, 0, 1)
    local v636 = Instance.new("Configuration")
    v636.Name = "Update"
    v636.Parent = v_u_595
end)
v628:AddSlider("Weapon Transparency", v_u_604.Value, 0, 1, 0.01, function(p637)
    -- upvalues: (ref) v_u_604, (ref) v_u_595
    local v638 = v_u_604
    local v639 = tonumber(p637) or 0
    v638.Value = math.clamp(v639, 0, 1)
    local v640 = Instance.new("Configuration")
    v640.Name = "Update"
    v640.Parent = v_u_595
end)
v628:AddColorPicker("Arms Color", Color3.fromRGB(v_u_605.Value, v_u_606.Value, v_u_607.Value), function(p641)
    -- upvalues: (ref) v_u_605, (ref) v_u_606, (ref) v_u_607, (ref) v_u_595
    if typeof(p641) == "Color3" then
        local v642 = v_u_605
        local v643 = p641.R * 255 + 0.5
        local v644 = math.floor(v643)
        v642.Value = math.clamp(v644, 0, 255)
        local v645 = v_u_606
        local v646 = p641.G * 255 + 0.5
        local v647 = math.floor(v646)
        v645.Value = math.clamp(v647, 0, 255)
        local v648 = v_u_607
        local v649 = p641.B * 255 + 0.5
        local v650 = math.floor(v649)
        v648.Value = math.clamp(v650, 0, 255)
        local v651 = Instance.new("Configuration")
        v651.Name = "Update"
        v651.Parent = v_u_595
    end
end)
v628:AddColorPicker("Weapon Color", Color3.fromRGB(v_u_608.Value, v_u_609.Value, v_u_610.Value), function(p652)
    -- upvalues: (ref) v_u_608, (ref) v_u_609, (ref) v_u_610, (ref) v_u_595
    if typeof(p652) == "Color3" then
        local v653 = v_u_608
        local v654 = p652.R * 255 + 0.5
        local v655 = math.floor(v654)
        v653.Value = math.clamp(v655, 0, 255)
        local v656 = v_u_609
        local v657 = p652.G * 255 + 0.5
        local v658 = math.floor(v657)
        v656.Value = math.clamp(v658, 0, 255)
        local v659 = v_u_610
        local v660 = p652.B * 255 + 0.5
        local v661 = math.floor(v660)
        v659.Value = math.clamp(v661, 0, 255)
        local v662 = Instance.new("Configuration")
        v662.Name = "Update"
        v662.Parent = v_u_595
    end
end)
v628:AddToggle("Viewmodel", v_u_611.Value, function(p663)
    -- upvalues: (ref) v_u_611, (ref) v_u_595
    v_u_611.Value = p663 and true or false
    local v664 = Instance.new("Configuration")
    v664.Name = "Update"
    v664.Parent = v_u_595
end)
v628:AddToggle("Tool", v_u_612.Value, function(p665)
    -- upvalues: (ref) v_u_612, (ref) v_u_595
    v_u_612.Value = p665 and true or false
    local v666 = Instance.new("Configuration")
    v666.Name = "Update"
    v666.Parent = v_u_595
end)
RunService.RenderStepped:Connect(function()
    if visualizeFakePosEnabled and fakePosCloneModel then
        updateFakePosVisibilityForCamera()
    end
end)
MainLeft:AddToggle("Rage Aim", false, function(p667)
    rageAimEnabled = p667
    ensureCharacterValues()
end)
local v_u_668 = { "Head" }
local function v_u_671()
    -- upvalues: (ref) v_u_668
    local v669 = Player:FindFirstChild("hitparts")
    if not v669 then
        v669 = Instance.new("StringValue")
        v669.Name = "hitparts"
        v669.Parent = Player
    end
    v669.Value = table.concat(v_u_668, ",")
    local v670 = Player:FindFirstChild("hitpartMode")
    if not v670 then
        v670 = Instance.new("StringValue")
        v670.Name = "hitpartMode"
        v670.Parent = Player
    end
    v670.Value = "Closest"
end
MainLeft:AddMultiDropdown("Hitparts", {
    "Head",
    "Torso",
    "Arms",
    "Legs"
}, { "Head" }, function(p672)
    -- upvalues: (ref) v_u_668, (copy) v_u_671
    v_u_668 = p672
    v_u_671()
end)
local v_u_673 = Player:FindFirstChild("Hitchance")
if not v_u_673 then
    v_u_673 = Instance.new("IntValue")
    v_u_673.Name = "Hitchance"
    v_u_673.Value = 50
    v_u_673.Parent = Player
end
local v_u_674 = false
local v_u_675 = 50
local v677 = MainLeft:AddToggle("Hitchance", false, function(p676)
    -- upvalues: (ref) v_u_674, (ref) v_u_673, (ref) v_u_675
    v_u_674 = p676
    if p676 then
        v_u_673.Value = v_u_675
    else
        if v_u_673.Value > 0 then
            v_u_675 = v_u_673.Value
        end
        v_u_673.Value = 0
    end
end):AddSettings()
MainLeft:AddSlider("Hitchance", v_u_673.Value, 0, 100, 1, function(p678)
    -- upvalues: (ref) v_u_674, (ref) v_u_673, (ref) v_u_675
    local v679 = tonumber(p678) or 50
    local v680 = math.floor(v679)
    if v_u_674 then
        v_u_673.Value = v680
        v_u_675 = v680
    else
        v_u_673.Value = 0
        v_u_675 = v680
    end
end)
hitchanceOverrideBool = Player:FindFirstChild("hitchanceoverride")
if not hitchanceOverrideBool then
    hitchanceOverrideBool = Instance.new("BoolValue")
    hitchanceOverrideBool.Name = "hitchanceoverride"
    hitchanceOverrideBool.Value = false
    hitchanceOverrideBool.Parent = Player
end
hitchanceOverrideValue = Player:FindFirstChild("hitchanceoverridevalue")
if not hitchanceOverrideValue then
    hitchanceOverrideValue = Instance.new("IntValue")
    hitchanceOverrideValue.Name = "hitchanceoverridevalue"
    hitchanceOverrideValue.Value = 50
    hitchanceOverrideValue.Parent = Player
end
hitchanceOverrideToggleBool = Player:FindFirstChild("hitchanceoverridetoggle")
if not hitchanceOverrideToggleBool then
    hitchanceOverrideToggleBool = Instance.new("BoolValue")
    hitchanceOverrideToggleBool.Name = "hitchanceoverridetoggle"
    hitchanceOverrideToggleBool.Value = false
    hitchanceOverrideToggleBool.Parent = Player
end
v677:AddSlider("Hitchance Override", hitchanceOverrideValue.Value, 0, 100, 1, function(p681)
    -- upvalues: (ref) v_u_674
    if v_u_674 then
        local v682 = hitchanceOverrideValue
        local v683 = tonumber(p681) or 50
        v682.Value = math.floor(v683)
    else
        hitchanceOverrideValue.Value = 0
    end
end)
v677:AddToggle("Override hitchance", hitchanceOverrideToggleBool.Value, function(p684)
    -- upvalues: (ref) v_u_674
    hitchanceOverrideToggleBool.Value = p684
    if not v_u_674 then
        hitchanceOverrideValue.Value = 0
    end
end, {
    ["MobileButton"] = {
        ["Keybind"] = "Hitchance Override Key",
        ["Text"] = "HC",
        ["ForceShow"] = false
    }
})
local v685 = {
    ["condition"] = function()
        -- upvalues: (ref) v_u_674
        if hitchanceOverrideToggleBool.Value then
            return v_u_674 and true or false
        else
            return false
        end
    end
}
v677:AddKeybind("Hitchance Override Key", Enum.KeyCode.V, "Toggle", function(_, p686, p687)
    if p686 == "Hold" then
        if p687 == "press" then
            hitchanceOverrideBool.Value = true
            return
        end
        if p687 == "release" then
            hitchanceOverrideBool.Value = false
            return
        end
    else
        hitchanceOverrideBool.Value = not hitchanceOverrideBool.Value
    end
end, v685)
MainLeft:AddToggle("Autoshoot", false, function(p688)
    autoShootEnabled = p688
    ensureCharacterValues()
end)
mindmgBool = Player:FindFirstChild("MindmgBool")
if not mindmgBool then
    mindmgBool = Instance.new("BoolValue")
    mindmgBool.Name = "MindmgBool"
    mindmgBool.Value = false
    mindmgBool.Parent = Player
end
mindmgValue = Player:FindFirstChild("Mindmg")
if not mindmgValue then
    mindmgValue = Instance.new("IntValue")
    mindmgValue.Name = "Mindmg"
    mindmgValue.Value = 0
    mindmgValue.Parent = Player
end
mindmgToggle = MainLeft:AddToggle("Mindmg", mindmgBool.Value, function(p689)
    mindmgBool.Value = p689
end)
local v690 = mindmgToggle:AddSettings()
MainLeft:AddSlider("Mindmg", mindmgValue.Value, 0, 100, 1, function(p691)
    local v692 = mindmgValue
    local v693 = tonumber(p691) or 0
    v692.Value = math.floor(v693)
end)
mindmgOverrideBool = Player:FindFirstChild("mindmgoverride")
if not mindmgOverrideBool then
    mindmgOverrideBool = Instance.new("BoolValue")
    mindmgOverrideBool.Name = "mindmgoverride"
    mindmgOverrideBool.Value = false
    mindmgOverrideBool.Parent = Player
end
mindmgOverrideValue = Player:FindFirstChild("mindmgoverridevalue")
if not mindmgOverrideValue then
    mindmgOverrideValue = Instance.new("IntValue")
    mindmgOverrideValue.Name = "mindmgoverridevalue"
    mindmgOverrideValue.Value = 50
    mindmgOverrideValue.Parent = Player
end
mindmgOverrideToggleBool = Player:FindFirstChild("mindmgoverridetoggle")
if not mindmgOverrideToggleBool then
    mindmgOverrideToggleBool = Instance.new("BoolValue")
    mindmgOverrideToggleBool.Name = "mindmgoverridetoggle"
    mindmgOverrideToggleBool.Value = false
    mindmgOverrideToggleBool.Parent = Player
end
v690:AddSlider("MinDmg Override", mindmgOverrideValue.Value, 0, 100, 1, function(p694)
    local v695 = mindmgOverrideValue
    local v696 = tonumber(p694) or 0
    v695.Value = math.floor(v696)
end)
v690:AddToggle("Override mindmg", mindmgOverrideToggleBool.Value, function(p697)
    mindmgOverrideToggleBool.Value = p697
end, {
    ["MobileButton"] = {
        ["Keybind"] = "MinDmg Override Key",
        ["Text"] = "MD",
        ["ForceShow"] = false
    }
})
v690:AddKeybind("MinDmg Override Key", Enum.KeyCode.C, "Toggle", function(_, p698, p699)
    if p698 == "Hold" then
        if p699 == "press" then
            mindmgOverrideBool.Value = true
            return
        end
        if p699 == "release" then
            mindmgOverrideBool.Value = false
            return
        end
    else
        mindmgOverrideBool.Value = not mindmgOverrideBool.Value
    end
end, {
    ["condition"] = function()
        if not mindmgOverrideToggleBool.Value then
            return false
        end
        local v700 = Player:FindFirstChild("MindmgBool")
        return v700 and v700.Value and true or false
    end
})
manipEnabledVal = Player:FindFirstChild("PeekBotEnabled") or Player:FindFirstChild("ManipulatorEnabled")
manipKeyVal = Player:FindFirstChild("PeekBotKey") or Player:FindFirstChild("ManipulatorKey")
manipModeVal = Player:FindFirstChild("PeekBotMode") or Player:FindFirstChild("ManipulatorMode")
peekToggle = MainLeft:AddToggle("Peek Assist", manipEnabledVal and manipEnabledVal.Value or false, function(p701)
    if manipEnabledVal then
        manipEnabledVal.Value = p701 and true or false
    end
end, {
    ["MobileButton"] = {
        ["Keybind"] = "Peek Key",
        ["Text"] = "Peek",
        ["ForceShow"] = false
    }
})
peekSettings = peekToggle:AddSettings()
dtEnabledVal = Player:FindFirstChild("DTEnabled")
if not dtEnabledVal then
    dtEnabledVal = Instance.new("BoolValue")
    dtEnabledVal.Name = "DTEnabled"
    dtEnabledVal.Value = false
    dtEnabledVal.Parent = Player
end
sigmaDT = false
local v703 = MainLeft:AddToggle("Double Tap", dtEnabledVal.Value, function(p702)
    sigmaDT = p702
    dtEnabledVal.Value = p702
end, {
    ["MobileButton"] = {
        ["Keybind"] = "DT Key",
        ["Text"] = "DT",
        ["ForceShow"] = false
    }
}):AddSettings()
peekSettings:AddKeybind("Peek Key", Enum.KeyCode.Q, "Toggle", function(_, p704, p705)
    local v706 = game.Players.LocalPlayer:FindFirstChild("manik mobile")
    local v707 = v706 and v706:FindFirstChild("Toggle")
    if v707 then
        if p704 == "Hold" then
            if p705 == "press" then
                v707.Value = true
                return
            end
            if p705 == "release" then
                v707.Value = false
                return
            end
        else
            v707.Value = not v707.Value
        end
    end
end, {
    ["condition"] = function()
        if manipEnabledVal and manipEnabledVal.Value then
            local v708 = game.Players.LocalPlayer:FindFirstChild("manik mobile")
            if v708 then
                return v708:FindFirstChild("Toggle") and true or false
            else
                return false
            end
        else
            return false
        end
    end
})
dtKeyVal = Player:FindFirstChild("DTKey")
existingDTKey = "E"
existingDTMode = "Hold"
if dtKeyVal and dtKeyVal.Value then
    local v709 = string.split(dtKeyVal.Value, " ")
    existingDTKey = v709[1] or "E"
    existingDTMode = v709[2] or "Hold"
end
v703:AddKeybind("DT Key", Enum.KeyCode[existingDTKey] or Enum.KeyCode.E, existingDTMode, function(p710, p711, p712)
    if dtKeyVal and typeof(p710) == "EnumItem" then
        local v713 = dtKeyVal
        local v714 = p710.Name
        v713.Value = tostring(v714) .. " " .. tostring(p711)
    end
    local v715 = game.Players.LocalPlayer:FindFirstChild("DT")
    if v715 then
        if p711 == "Hold" then
            if p712 == "press" then
                v715.Value = true
                return
            end
            if p712 == "release" then
                v715.Value = false
                return
            end
        else
            v715.Value = not v715.Value
        end
    end
end, {
    ["condition"] = function()
        return sigmaDT and true or false
    end
})
peekSettings:AddDropdown("When peek", { "On disable", "On shoot only" }, manipModeVal and manipModeVal.Value or "On disable", function(p716)
    if manipModeVal then
        manipModeVal.Value = p716
    end
end)
autoReloadValue = Instance.new("BoolValue")
autoReloadValue.Name = "AutoReload"
autoReloadValue.Parent = game.Players.LocalPlayer
autoReloadValue.Value = false
CombatOtherLeft:AddToggle("Autoreload", false, function(p717)
    autoReloadValue.Value = p717
end)
hitChamsFolder = Player:FindFirstChild("HitChams")
if not hitChamsFolder then
    hitChamsFolder = Instance.new("Folder")
    hitChamsFolder.Name = "HitChams"
    hitChamsFolder.Parent = Player
end
local v_u_718 = hitChamsFolder:FindFirstChild("Enabled")
if not v_u_718 then
    v_u_718 = Instance.new("BoolValue")
    v_u_718.Name = "Enabled"
    v_u_718.Value = false
    v_u_718.Parent = hitChamsFolder
end
materialVal = hitChamsFolder:FindFirstChild("Material")
if not materialVal then
    materialVal = Instance.new("StringValue")
    materialVal.Name = "Material"
    materialVal.Value = "ForceField"
    materialVal.Parent = hitChamsFolder
end
local v_u_719 = hitChamsFolder:FindFirstChild("Transparency")
if not v_u_719 then
    v_u_719 = Instance.new("NumberValue")
    v_u_719.Name = "Transparency"
    v_u_719.Value = 0
    v_u_719.Parent = hitChamsFolder
end
local v_u_720 = hitChamsFolder:FindFirstChild("ColorR")
local v_u_721 = hitChamsFolder:FindFirstChild("ColorG")
local v_u_722 = hitChamsFolder:FindFirstChild("ColorB")
if not v_u_720 then
    v_u_720 = Instance.new("IntValue")
    v_u_720.Name = "ColorR"
    v_u_720.Value = 255
    v_u_720.Parent = hitChamsFolder
end
if not v_u_721 then
    v_u_721 = Instance.new("IntValue")
    v_u_721.Name = "ColorG"
    v_u_721.Value = 255
    v_u_721.Parent = hitChamsFolder
end
if not v_u_722 then
    v_u_722 = Instance.new("IntValue")
    v_u_722.Name = "ColorB"
    v_u_722.Value = 255
    v_u_722.Parent = hitChamsFolder
end
local v_u_723 = hitChamsFolder:FindFirstChild("HighlightEnabled")
if not v_u_723 then
    v_u_723 = Instance.new("BoolValue")
    v_u_723.Name = "HighlightEnabled"
    v_u_723.Value = true
    v_u_723.Parent = hitChamsFolder
end
local v_u_724 = hitChamsFolder:FindFirstChild("FillTransparency")
local v_u_725 = hitChamsFolder:FindFirstChild("OutlineTransparency")
if not v_u_724 then
    v_u_724 = Instance.new("NumberValue")
    v_u_724.Name = "FillTransparency"
    v_u_724.Value = 0.5
    v_u_724.Parent = hitChamsFolder
end
if not v_u_725 then
    v_u_725 = Instance.new("NumberValue")
    v_u_725.Name = "OutlineTransparency"
    v_u_725.Value = 0
    v_u_725.Parent = hitChamsFolder
end
local v_u_726 = hitChamsFolder:FindFirstChild("FillColorR")
local v_u_727 = hitChamsFolder:FindFirstChild("FillColorG")
local v_u_728 = hitChamsFolder:FindFirstChild("FillColorB")
if not v_u_726 then
    v_u_726 = Instance.new("IntValue")
    v_u_726.Name = "FillColorR"
    v_u_726.Value = 255
    v_u_726.Parent = hitChamsFolder
end
if not v_u_727 then
    v_u_727 = Instance.new("IntValue")
    v_u_727.Name = "FillColorG"
    v_u_727.Value = 255
    v_u_727.Parent = hitChamsFolder
end
if not v_u_728 then
    v_u_728 = Instance.new("IntValue")
    v_u_728.Name = "FillColorB"
    v_u_728.Value = 255
    v_u_728.Parent = hitChamsFolder
end
local v_u_729 = hitChamsFolder:FindFirstChild("OutlineColorR")
local v_u_730 = hitChamsFolder:FindFirstChild("OutlineColorG")
local v_u_731 = hitChamsFolder:FindFirstChild("OutlineColorB")
if not v_u_729 then
    v_u_729 = Instance.new("IntValue")
    v_u_729.Name = "OutlineColorR"
    v_u_729.Value = 255
    v_u_729.Parent = hitChamsFolder
end
if not v_u_730 then
    v_u_730 = Instance.new("IntValue")
    v_u_730.Name = "OutlineColorG"
    v_u_730.Value = 255
    v_u_730.Parent = hitChamsFolder
end
if not v_u_731 then
    v_u_731 = Instance.new("IntValue")
    v_u_731.Name = "OutlineColorB"
    v_u_731.Value = 255
    v_u_731.Parent = hitChamsFolder
end
local v_u_732 = hitChamsFolder:FindFirstChild("AlwaysOnTop")
if not v_u_732 then
    v_u_732 = Instance.new("BoolValue")
    v_u_732.Name = "AlwaysOnTop"
    v_u_732.Value = true
    v_u_732.Parent = hitChamsFolder
end
local v734 = CombatOtherLeft:AddToggle("Hit Chams", v_u_718.Value, function(p733)
    -- upvalues: (ref) v_u_718
    v_u_718.Value = p733
end):AddSettings()
v734:AddDropdown("Material", {
    "Default",
    "ForceField",
    "Neon",
    "Solid"
}, materialVal.Value, function(p735)
    if type(p735) == "string" then
        materialVal.Value = p735
    end
end)
v734:AddSlider("Transparency", v_u_719.Value, 0, 1, 0.01, function(p736)
    -- upvalues: (ref) v_u_719
    local v737 = tonumber(p736)
    if v737 then
        v_u_719.Value = math.clamp(v737, 0, 1)
    end
end)
v734:AddColorPicker("Color", Color3.fromRGB(v_u_720.Value, v_u_721.Value, v_u_722.Value), function(...)
    -- upvalues: (ref) v_u_720, (ref) v_u_721, (ref) v_u_722
    local v738 = coerceColor3(...)
    if v738 then
        local v739 = v_u_720
        local v740 = v738.R * 255
        v739.Value = math.floor(v740)
        local v741 = v_u_721
        local v742 = v738.G * 255
        v741.Value = math.floor(v742)
        local v743 = v_u_722
        local v744 = v738.B * 255
        v743.Value = math.floor(v744)
    end
end)
v734:AddToggle("Highlight", v_u_723.Value, function(p745)
    -- upvalues: (ref) v_u_723
    v_u_723.Value = p745
end)
v734:AddSlider("Fill Transparency", v_u_724.Value, 0, 1, 0.01, function(p746)
    -- upvalues: (ref) v_u_724
    local v747 = tonumber(p746)
    if v747 then
        v_u_724.Value = math.clamp(v747, 0, 1)
    end
end)
v734:AddSlider("Outline Transparency", v_u_725.Value, 0, 1, 0.01, function(p748)
    -- upvalues: (ref) v_u_725
    local v749 = tonumber(p748)
    if v749 then
        v_u_725.Value = math.clamp(v749, 0, 1)
    end
end)
v734:AddColorPicker("Fill Color", Color3.fromRGB(v_u_726.Value, v_u_727.Value, v_u_728.Value), function(...)
    -- upvalues: (ref) v_u_726, (ref) v_u_727, (ref) v_u_728
    local v750 = coerceColor3(...)
    if v750 then
        local v751 = v_u_726
        local v752 = v750.R * 255
        v751.Value = math.floor(v752)
        local v753 = v_u_727
        local v754 = v750.G * 255
        v753.Value = math.floor(v754)
        local v755 = v_u_728
        local v756 = v750.B * 255
        v755.Value = math.floor(v756)
    end
end)
v734:AddColorPicker("Outline Color", Color3.fromRGB(v_u_729.Value, v_u_730.Value, v_u_731.Value), function(...)
    -- upvalues: (ref) v_u_729, (ref) v_u_730, (ref) v_u_731
    local v757 = coerceColor3(...)
    if v757 then
        local v758 = v_u_729
        local v759 = v757.R * 255
        v758.Value = math.floor(v759)
        local v760 = v_u_730
        local v761 = v757.G * 255
        v760.Value = math.floor(v761)
        local v762 = v_u_731
        local v763 = v757.B * 255
        v762.Value = math.floor(v763)
    end
end)
v734:AddToggle("On Top", v_u_732.Value, function(p764)
    -- upvalues: (ref) v_u_732
    v_u_732.Value = p764
end)
local v_u_765 = Player:FindFirstChild("HitchamsDuration")
if not v_u_765 then
    v_u_765 = Instance.new("NumberValue")
    v_u_765.Name = "HitchamsDuration"
    v_u_765.Value = 3
    v_u_765.Parent = Player
end
v734:AddSlider("Duration", v_u_765.Value, 0.5, 10, 0.1, function(p766)
    -- upvalues: (ref) v_u_765
    local v767 = tonumber(p766)
    if v767 then
        v_u_765.Value = math.clamp(v767, 0.5, 10)
    end
end)
hitMarkerFolder = Player:FindFirstChild("HitMarker")
if not hitMarkerFolder then
    hitMarkerFolder = Instance.new("Folder")
    hitMarkerFolder.Name = "HitMarker"
    hitMarkerFolder.Parent = Player
end
hitMarkerEnabledVal = hitMarkerFolder:FindFirstChild("Enabled")
if not hitMarkerEnabledVal then
    hitMarkerEnabledVal = Instance.new("BoolValue")
    hitMarkerEnabledVal.Name = "Enabled"
    hitMarkerEnabledVal.Value = false
    hitMarkerEnabledVal.Parent = hitMarkerFolder
end
hitMarkerTypeVal = hitMarkerFolder:FindFirstChild("Type")
if not hitMarkerTypeVal then
    hitMarkerTypeVal = Instance.new("StringValue")
    hitMarkerTypeVal.Name = "Type"
    hitMarkerTypeVal.Value = "Default"
    hitMarkerTypeVal.Parent = hitMarkerFolder
end
hitMarkerSizeVal = hitMarkerFolder:FindFirstChild("Size")
if not hitMarkerSizeVal then
    hitMarkerSizeVal = Instance.new("NumberValue")
    hitMarkerSizeVal.Name = "Size"
    hitMarkerSizeVal.Value = 50
    hitMarkerSizeVal.Parent = hitMarkerFolder
end
hitMarkerLifeTimeVal = hitMarkerFolder:FindFirstChild("LifeTime")
if not hitMarkerLifeTimeVal then
    hitMarkerLifeTimeVal = Instance.new("NumberValue")
    hitMarkerLifeTimeVal.Name = "LifeTime"
    hitMarkerLifeTimeVal.Value = 0.5
    hitMarkerLifeTimeVal.Parent = hitMarkerFolder
end
local v769 = CombatOtherLeft:AddToggle("Hit Marker", hitMarkerEnabledVal.Value, function(p768)
    hitMarkerEnabledVal.Value = p768
end):AddSettings()
v769:AddDropdown("Type", { "Default", "Another" }, hitMarkerTypeVal.Value, function(p770)
    if type(p770) == "string" then
        hitMarkerTypeVal.Value = p770
    end
end)
v769:AddSlider("Size", hitMarkerSizeVal.Value, 10, 200, 1, function(p771)
    local v772 = tonumber(p771)
    if v772 then
        hitMarkerSizeVal.Value = math.floor(v772)
    end
end)
v769:AddSlider("Lifetime", hitMarkerLifeTimeVal.Value, 0.1, 2, 0.1, function(p773)
    local v774 = tonumber(p773)
    if v774 then
        local v775 = hitMarkerLifeTimeVal
        local v776 = v774 * 10 + 0.5
        v775.Value = math.floor(v776) / 10
    end
end)
hitpointsCount = 1
function updateHitpointsConfig()
    local v777 = Player:FindFirstChild("Hitpoints")
    if not v777 then
        v777 = Instance.new("NumberValue")
        v777.Name = "Hitpoints"
        v777.Parent = Player
    end
    v777.Value = hitpointsCount
end
CombatOtherLeft:AddSlider("Scan points", 1, 1, 15, 1, function(p778)
    local v779 = tonumber(p778) or 15
    hitpointsCount = math.floor(v779)
    updateHitpointsConfig()
end)
updateHitpointsConfig()
hitsoundEnabled = "Neverlose"
killsoundEnabled = "Original"
function getSoundDefaultVolume(p780, p781)
    local v782 = ReplicatedStorage:FindFirstChild("sounds")
    if not v782 then
        return 1
    end
    local v783 = p781 and v782:FindFirstChild("Kill") or v782:FindFirstChild("Hit")
    if not v783 then
        return 1
    end
    local v784 = v783:FindFirstChild(p780)
    return v784 and v784:IsA("Sound") and (v784.Volume or 1) or 1
end
function playSoundPreview(p785, p786, p787, p788)
    local v789 = ReplicatedStorage:FindFirstChild("sounds")
    if v789 then
        local v790 = p788 and v789:FindFirstChild("Kill") or v789:FindFirstChild("Hit")
        if v790 then
            local v791 = v790:FindFirstChild(p785)
            if v791 and v791:IsA("Sound") then
                local v_u_792 = v791:Clone()
                v_u_792.Volume = p786 or 1
                v_u_792.PlaybackSpeed = p787 or 1
                v_u_792.Parent = workspace
                v_u_792:Play()
                v_u_792.Ended:Connect(function()
                    -- upvalues: (copy) v_u_792
                    v_u_792:Destroy()
                end)
            end
        end
    else
        return
    end
end
hitVolume = 1
killVolume = 1
hitSpeed = 1
killSpeed = 1
function updateSoundConfig()
    local v793 = Player:FindFirstChild("Hitsound")
    if not v793 then
        v793 = Instance.new("StringValue")
        v793.Name = "Hitsound"
        v793.Parent = Player
    end
    v793.Value = hitsoundEnabled
    local v794 = Player:FindFirstChild("Killsound")
    if not v794 then
        v794 = Instance.new("StringValue")
        v794.Name = "Killsound"
        v794.Parent = Player
    end
    v794.Value = killsoundEnabled
end
function updateSoundVolumeConfig()
    local v795 = Player:FindFirstChild("HitVolume")
    if not v795 then
        v795 = Instance.new("NumberValue")
        v795.Name = "HitVolume"
        v795.Parent = Player
    end
    v795.Value = hitVolume
    local v796 = Player:FindFirstChild("KillVolume")
    if not v796 then
        v796 = Instance.new("NumberValue")
        v796.Name = "KillVolume"
        v796.Parent = Player
    end
    v796.Value = killVolume
end
function updateSoundSpeedConfig()
    local v797 = Player:FindFirstChild("HitSpeed")
    if not v797 then
        v797 = Instance.new("NumberValue")
        v797.Name = "HitSpeed"
        v797.Parent = Player
    end
    v797.Value = hitSpeed
    local v798 = Player:FindFirstChild("KillSpeed")
    if not v798 then
        v798 = Instance.new("NumberValue")
        v798.Name = "KillSpeed"
        v798.Parent = Player
    end
    v798.Value = killSpeed
end
local v804 = (function()
    local v799 = ReplicatedStorage:FindFirstChild("sounds")
    if not v799 then
        return {}
    end
    local v800 = v799:FindFirstChild("Every")
    if not v800 then
        return {}
    end
    local v801 = {}
    for _, v802 in ipairs(v800:GetChildren()) do
        local v803 = v802.Name
        table.insert(v801, v803)
    end
    table.sort(v801)
    return v801
end)()
if #v804 > 0 then
    hitsoundEnabled = "Neverlose"
    killsoundEnabled = "Original"
end
CombatOtherRight:AddDropdown("Hitsound", v804, "Neverlose", function(p805)
    hitsoundEnabled = p805
    updateSoundConfig()
    playSoundPreview(p805, hitVolume, hitSpeed, false)
end)
CombatOtherRight:AddDropdown("Killsound", v804, "Original", function(p806)
    killsoundEnabled = p806
    updateSoundConfig()
    playSoundPreview(p806, killVolume, killSpeed, true)
end)
CombatOtherRight:AddSlider("Hit volume", hitVolume, 0, 2, 0.01, function(p807)
    local v808 = tonumber(p807) or 1
    hitVolume = math.clamp(v808, 0, 2)
    updateSoundVolumeConfig()
end)
CombatOtherRight:AddSlider("Kill volume", killVolume, 0, 2, 0.01, function(p809)
    local v810 = tonumber(p809) or 1
    killVolume = math.clamp(v810, 0, 2)
    updateSoundVolumeConfig()
end)
CombatOtherRight:AddSlider("Hit sound speed", hitSpeed, 0.1, 2, 0.01, function(p811)
    local v812 = tonumber(p811) or 1
    hitSpeed = math.clamp(v812, 0.1, 2)
    updateSoundSpeedConfig()
end)
CombatOtherRight:AddSlider("Kill sound speed", killSpeed, 0.1, 2, 0.01, function(p813)
    local v814 = tonumber(p813) or 1
    killSpeed = math.clamp(v814, 0.1, 2)
    updateSoundSpeedConfig()
end)
local v_u_815 = "None"
local v_u_816 = "None"
local v_u_817 = 1
local v_u_818 = 1
function getEffectNames()
    local v819, v820 = pcall(function()
        return ReplicatedStorage:WaitForChild("Effects", 0.1)
    end)
    if not (v819 and v820) then
        return { "None" }
    end
    local v821 = {}
    for _, v822 in ipairs(v820:GetChildren()) do
        local v823 = v822.Name
        table.insert(v821, v823)
    end
    table.sort(v821)
    table.insert(v821, 1, "None")
    return v821
end
function updateEffectConfig()
    -- upvalues: (ref) v_u_815, (ref) v_u_816
    local v824 = Player:FindFirstChild("Hiteffect")
    if not v824 then
        v824 = Instance.new("StringValue")
        v824.Name = "Hiteffect"
        v824.Parent = Player
    end
    v824.Value = v_u_815
    local v825 = Player:FindFirstChild("Killeffect")
    if not v825 then
        v825 = Instance.new("StringValue")
        v825.Name = "Killeffect"
        v825.Parent = Player
    end
    v825.Value = v_u_816
end
function updateEffectTimeoutConfig()
    -- upvalues: (ref) v_u_817, (ref) v_u_818
    local v826 = Player:FindFirstChild("HiteffectTimeout")
    if not v826 then
        v826 = Instance.new("NumberValue")
        v826.Name = "HiteffectTimeout"
        v826.Parent = Player
    end
    v826.Value = v_u_817
    local v827 = Player:FindFirstChild("KilleffectTimeout")
    if not v827 then
        v827 = Instance.new("NumberValue")
        v827.Name = "KilleffectTimeout"
        v827.Parent = Player
    end
    v827.Value = v_u_818
end
local v828 = getEffectNames()
CombatOtherRight:AddDropdown("Hiteffect", v828, "None", function(p829)
    -- upvalues: (ref) v_u_815
    v_u_815 = p829
    updateEffectConfig()
end)
CombatOtherRight:AddDropdown("Killeffect", v828, "None", function(p830)
    -- upvalues: (ref) v_u_816
    v_u_816 = p830
    updateEffectConfig()
end)
CombatOtherRight:AddSlider("Hiteffect timeout", 1, 0.1, 3, 0.1, function(p831)
    -- upvalues: (ref) v_u_817
    v_u_817 = tonumber(p831) or 1
    updateEffectTimeoutConfig()
end)
CombatOtherRight:AddSlider("Killeffect timeout", 1, 0.1, 3, 0.1, function(p832)
    -- upvalues: (ref) v_u_818
    v_u_818 = tonumber(p832) or 1
    updateEffectTimeoutConfig()
end)
updateSoundConfig()
updateSoundVolumeConfig()
updateSoundSpeedConfig()
updateEffectConfig()
updateEffectTimeoutConfig()
v_u_671()
cachedPlayersList = {}
lastPlayersListUpdate = 0
PLAYERS_LIST_CACHE_TIME = 0.1
function getCachedPlayersList()
    local v833 = tick()
    if v833 - lastPlayersListUpdate > PLAYERS_LIST_CACHE_TIME then
        cachedPlayersList = Players:GetPlayers()
        lastPlayersListUpdate = v833
    end
    return cachedPlayersList
end
ESP_Enabled = false
HB_Enabled = false
NESP_Enabled = false
ARMOR_Enabled = false
CHAMS_Enabled = false
SELF_ESP_Enabled = false
NameOption = "Username"
boxESPInstances = {}
HP_BAR_Position = "Left"
ARMOR_BAR_Position = "Right"
BarsOrder = "Health, Armor"
HP_BarOffset = 2.25
HP_BarThickness = 2
ARMOR_BarOffset = 2.25
ARMOR_BarThickness = 2
BoxThickness = 1
NameTextOffset = 4.4
BarSpacing = 0.25
BoxColor = Color3.fromRGB(255, 255, 255)
BoxOutlineColor = Color3.fromRGB(0, 0, 0)
BoxFill_Enabled = false
BoxFill_Transparency = 0.5
BoxFill_GradientTop = Color3.fromRGB(255, 255, 255)
BoxFill_GradientMiddle = Color3.fromRGB(200, 200, 200)
BoxFill_GradientBottom = Color3.fromRGB(100, 100, 100)
BoxFill_GradientRotation = 90
HP_GradientTop = Color3.fromRGB(60, 255, 80)
HP_GradientMiddle = Color3.fromRGB(255, 170, 40)
HP_GradientBottom = Color3.fromRGB(255, 30, 30)
ARMOR_GradientTop = Color3.fromRGB(0, 210, 255)
ARMOR_GradientBottom = Color3.fromRGB(30, 90, 255)
NameESPColor = Color3.fromRGB(255, 255, 255)
AvatarIcon_Enabled = false
AvatarIcon_Size = 56
AvatarIcon_Offset = 6
AvatarIcon_CornerRadius = UDim.new(0, 6)
AvatarIconBackground = Color3.fromRGB(15, 15, 15)
AvatarIconBackgroundTransparency = 0
AvatarIconBorderColor = Color3.fromRGB(0, 0, 0)
AvatarIconShape = "Rounded"
avatarThumbnailCache = {}
ChamsFillColor = Color3.fromRGB(255, 255, 255)
ChamsOutlineColor = Color3.fromRGB(255, 255, 255)
ChamsFillTransparency = 0.7
ChamsOutlineTransparency = 0
SKELETON_Enabled = false
SkeletonColor = Color3.fromRGB(255, 255, 255)
SkeletonThickness = 1
SkeletonTransparency = 0
skeletonCache = {}
function getAvatarThumbnail(p_u_834)
    if avatarThumbnailCache[p_u_834] then
        return avatarThumbnailCache[p_u_834]
    end
    local v_u_835 = nil
    local v_u_836 = nil
    if not pcall(function()
        -- upvalues: (ref) v_u_835, (ref) v_u_836, (copy) p_u_834
        local v837, v838 = Players:GetUserThumbnailAsync(p_u_834, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
        v_u_835 = v837
        v_u_836 = v838
    end) or (not v_u_835 or v_u_835 == "") then
        return ""
    end
    avatarThumbnailCache[p_u_834] = v_u_835
    return v_u_835
end
function ensureCorner(p839)
    local v840
    if p839 then
        v840 = p839:FindFirstChildOfClass("UICorner")
    else
        v840 = p839
    end
    if not v840 then
        v840 = Instance.new("UICorner")
        v840.Parent = p839
    end
    return v840
end
function applyAvatarIconStyling(p841)
    if p841 then
        p841.Size = UDim2.new(0, AvatarIcon_Size, 0, AvatarIcon_Size)
        local v842 = AvatarIcon_Offset
        p841.StudsOffset = Vector3.new(0, v842, 0)
        local v843 = p841:FindFirstChild("Background")
        if v843 then
            v843.BackgroundColor3 = AvatarIconBackground
            v843.BackgroundTransparency = AvatarIconBackgroundTransparency
            local v844 = v843:FindFirstChildOfClass("UIStroke")
            if v844 then
                v844.Color = AvatarIconBorderColor
            end
            if AvatarIconShape == "Square" then
                local v845 = v843:FindFirstChildOfClass("UICorner")
                if v845 then
                    v845:Destroy()
                end
            else
                ensureCorner(v843).CornerRadius = AvatarIconShape == "Circle" and UDim.new(1, 0) or AvatarIcon_CornerRadius
            end
            local v846 = v843:FindFirstChild("AvatarImage")
            if v846 then
                if AvatarIconShape == "Square" then
                    local v847 = v846:FindFirstChildOfClass("UICorner")
                    if v847 then
                        v847:Destroy()
                    end
                else
                    ensureCorner(v846).CornerRadius = AvatarIconShape == "Circle" and UDim.new(1, 0) or AvatarIcon_CornerRadius
                end
            end
            for _, v848 in ipairs(v843:GetChildren()) do
                if v848:IsA("UIStroke") then
                    v848.Transparency = AvatarIconBackgroundTransparency
                    v848.Color = AvatarIconBorderColor
                end
            end
        end
    else
        return
    end
end
function createLine(p849, p850, p851, p852)
    local v853 = Instance.new("Frame")
    v853.Size = p850
    v853.Position = p851
    v853.BackgroundColor3 = p852
    v853.BorderSizePixel = 0
    v853.Parent = p849
    return v853
end
function clearBillboard(p854, p855)
    local v856
    if p854 then
        v856 = p854:FindFirstChild("HumanoidRootPart")
    else
        v856 = p854
    end
    if v856 then
        for _, v857 in ipairs(v856:GetChildren()) do
            if v857:IsA("BillboardGui") and v857.Name == p855 then
                v857:Destroy()
            end
        end
    end
    if p855 == "NameESP" then
        if p854 then
            p854 = p854:FindFirstChildOfClass("Humanoid")
        end
        if p854 then
            p854.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
end
function createESP(p858, _)
    local v859 = Players.LocalPlayer
    if not p858 then
        return
    end
    if p858 == v859.Character and not SELF_ESP_Enabled then
        return
    end
    if p858.Name == "" then
        return
    end
    if not Players:GetPlayerFromCharacter(p858) then
        return
    end
    local v860 = p858:FindFirstChild("HumanoidRootPart")
    if not v860 then
        return
    end
    clearBillboard(p858, "BoxESP")
    clearBillboard(p858, "BoxFill")
    clearBillboard(p858, "HealthBar")
    clearBillboard(p858, "NameESP")
    clearBillboard(p858, "ArmorBar")
    clearBillboard(p858, "AvatarIcon")
    clearBillboard(p858, "HealthText")
    clearBillboard(p858, "ArmorText")
    if ESP_Enabled then
        local v861 = Instance.new("BillboardGui")
        v861.Size = UDim2.new(4, 0, 6, 0)
        v861.StudsOffset = Vector3.new(0, 0, 0)
        v861.AlwaysOnTop = true
        v861.Name = "BoxESP"
        v861.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v861.MaxDistance = (1 / 0)
        v861.Parent = v860
        local v862 = BoxThickness
        local v863 = createLine(v861, UDim2.new(0, v862 + v862 * 2, 1, 0), UDim2.new(0, -v862, 0, -v862), BoxOutlineColor)
        local v864 = createLine(v861, UDim2.new(0, v862 + v862 * 2, 1, 0), UDim2.new(1, -1 - v862, 0, -v862), BoxOutlineColor)
        local v865 = createLine(v861, UDim2.new(1, 0, 0, v862 + v862 * 2), UDim2.new(0, -v862, 0, -v862), BoxOutlineColor)
        local v866 = createLine(v861, UDim2.new(1, 0, 0, v862 + v862 * 2), UDim2.new(0, -v862, 1, -1 - v862), BoxOutlineColor)
        v863.ZIndex = 2
        v864.ZIndex = 2
        v865.ZIndex = 2
        v866.ZIndex = 2
        local v867 = createLine(v861, UDim2.new(0, v862, 1, 0), UDim2.new(0, 0, 0, 0), BoxColor)
        local v868 = createLine(v861, UDim2.new(0, v862, 1, 0), UDim2.new(1, -v862, 0, 0), BoxColor)
        local v869 = createLine(v861, UDim2.new(1, 0, 0, v862), UDim2.new(0, 0, 0, 0), BoxColor)
        local v870 = createLine(v861, UDim2.new(1, 0, 0, v862), UDim2.new(0, 0, 1, -v862), BoxColor)
        v867.ZIndex = 3
        v868.ZIndex = 3
        v869.ZIndex = 3
        v870.ZIndex = 3
        if BoxFill_Enabled and ESP_Enabled then
            local v871 = v860:FindFirstChild("BoxFill")
            if v871 then
                v871:Destroy()
            end
            local v872 = Instance.new("Frame")
            v872.Name = "BoxFill"
            v872.Size = UDim2.new(1, 0, 1, 0)
            v872.Position = UDim2.new(0, 0, 0, 0)
            v872.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            v872.BackgroundTransparency = BoxFill_Transparency
            v872.BorderSizePixel = 0
            v872.ZIndex = 1
            v872.Parent = v861
            local v873 = Instance.new("UIGradient")
            v873.Rotation = BoxFill_GradientRotation
            v873.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, BoxFill_GradientTop), ColorSequenceKeypoint.new(0.5, BoxFill_GradientMiddle), ColorSequenceKeypoint.new(1, BoxFill_GradientBottom) })
            v873.Parent = v872
            if not boxESPInstances[p858] then
                boxESPInstances[p858] = {}
            end
            boxESPInstances[p858].fillFrame = v872
            boxESPInstances[p858].fillGradient = v873
        end
        if not boxESPInstances[p858] then
            boxESPInstances[p858] = {}
        end
        boxESPInstances[p858].frames = {
            v867,
            v868,
            v869,
            v870,
            v863,
            v864,
            v865,
            v866
        }
        boxESPInstances[p858].gradient = nil
        boxESPInstances[p858].nameLabel = nil
    end
    if BoxFill_Enabled and not ESP_Enabled then
        local v874 = Instance.new("BillboardGui")
        v874.Size = UDim2.new(4, 0, 6, 0)
        v874.StudsOffset = Vector3.new(0, 0, 0)
        v874.AlwaysOnTop = true
        v874.Name = "BoxFill"
        v874.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v874.MaxDistance = (1 / 0)
        v874.Parent = v860
        local v875 = Instance.new("Frame")
        v875.Name = "FillFrame"
        v875.Size = UDim2.new(1, 0, 1, 0)
        v875.Position = UDim2.new(0, 0, 0, 0)
        v875.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        v875.BackgroundTransparency = BoxFill_Transparency
        v875.BorderSizePixel = 0
        v875.ZIndex = 1
        v875.Parent = v874
        local v876 = Instance.new("UIGradient")
        v876.Rotation = BoxFill_GradientRotation
        v876.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, BoxFill_GradientTop), ColorSequenceKeypoint.new(0.5, BoxFill_GradientMiddle), ColorSequenceKeypoint.new(1, BoxFill_GradientBottom) })
        v876.Parent = v875
        if not boxESPInstances[p858] then
            boxESPInstances[p858] = {}
        end
        boxESPInstances[p858].fillBillboard = v874
        boxESPInstances[p858].fillFrame = v875
        boxESPInstances[p858].fillGradient = v876
    elseif not BoxFill_Enabled and boxESPInstances[p858] then
        boxESPInstances[p858].fillBillboard = nil
        boxESPInstances[p858].fillFrame = nil
        boxESPInstances[p858].fillGradient = nil
    end
    if HB_Enabled then
        local v_u_877 = Instance.new("BillboardGui")
        v_u_877.Size = UDim2.new(0, HP_BarThickness, 6, 0)
        local v878 = HP_BAR_Position == "Left" and -HP_BarOffset or HP_BarOffset
        if ARMOR_Enabled and (HP_BAR_Position == ARMOR_BAR_Position and BarsOrder ~= "Health, Armor") then
            v878 = v878 + (HP_BAR_Position == "Left" and -BarSpacing or BarSpacing)
        end
        v_u_877.StudsOffset = Vector3.new(v878, 0, 0)
        v_u_877.AlwaysOnTop = true
        v_u_877.Name = "HealthBar"
        v_u_877.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v_u_877.MaxDistance = (1 / 0)
        v_u_877.Parent = v860
        local v879 = Instance.new("Frame")
        v879.Size = UDim2.new(1, 0, 1, 0)
        v879.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        v879.BorderSizePixel = 0
        v879.Parent = v_u_877
        local v_u_880 = Instance.new("Frame")
        v_u_880.Size = UDim2.new(1, 0, 1, 0)
        v_u_880.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        v_u_880.BorderSizePixel = 0
        v_u_880.AnchorPoint = Vector2.new(0, 1)
        v_u_880.Position = UDim2.new(0, 0, 1, 0)
        v_u_880.ZIndex = 2
        v_u_880.Parent = v_u_877
        local v881 = Instance.new("UIGradient")
        v881.Rotation = 90
        v881.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, HP_GradientTop), ColorSequenceKeypoint.new(0.5, HP_GradientMiddle), ColorSequenceKeypoint.new(1, HP_GradientBottom) })
        v881.Parent = v_u_880
        local v882 = Instance.new("UIStroke")
        v882.Thickness = 0.5
        v882.Color = Color3.fromRGB(0, 0, 0)
        v882.Parent = v879
        local v883 = v_u_880:FindFirstChildOfClass("UIGradient")
        if not boxESPInstances[p858] then
            boxESPInstances[p858] = {}
        end
        if not boxESPInstances[p858].healthBar then
            boxESPInstances[p858].healthBar = {}
        end
        boxESPInstances[p858].healthBar.gradient = v883
        local v_u_884 = p858:FindFirstChild("Humanoid")
        if v_u_884 then
            local function v888()
                -- upvalues: (copy) v_u_884, (copy) v_u_880
                local v885 = v_u_884.Health
                local v886 = v_u_884.MaxHealth
                local v887 = v885 / math.max(1, v886)
                TweenService:Create(v_u_880, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ["Size"] = UDim2.new(1, 0, v887, 0)
                }):Play()
            end
            v_u_884.HealthChanged:Connect(v888)
            v888()
            v_u_884.AncestryChanged:Connect(function(_, p889)
                -- upvalues: (copy) v_u_877
                if not p889 and v_u_877 then
                    v_u_877:Destroy()
                end
            end)
        end
    end
    if ARMOR_Enabled then
        local v_u_890 = Instance.new("BillboardGui")
        v_u_890.Size = UDim2.new(0, ARMOR_BarThickness, 6, 0)
        local v891 = ARMOR_BAR_Position == "Left" and -ARMOR_BarOffset or ARMOR_BarOffset
        if HB_Enabled and (HP_BAR_Position == ARMOR_BAR_Position and BarsOrder == "Health, Armor") then
            v891 = v891 + (ARMOR_BAR_Position == "Left" and -BarSpacing or BarSpacing)
        end
        v_u_890.StudsOffset = Vector3.new(v891, 0, 0)
        v_u_890.AlwaysOnTop = true
        v_u_890.Name = "ArmorBar"
        v_u_890.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v_u_890.MaxDistance = (1 / 0)
        v_u_890.Parent = v860
        local v892 = Instance.new("Frame")
        v892.Size = UDim2.new(1, 0, 1, 0)
        v892.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        v892.BorderSizePixel = 0
        v892.Parent = v_u_890
        local v_u_893 = Instance.new("Frame")
        v_u_893.Size = UDim2.new(1, 0, 1, 0)
        v_u_893.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        v_u_893.BorderSizePixel = 0
        v_u_893.AnchorPoint = Vector2.new(0, 1)
        v_u_893.Position = UDim2.new(0, 0, 1, 0)
        v_u_893.ZIndex = 2
        v_u_893.Parent = v_u_890
        local v894 = Instance.new("UIGradient")
        v894.Rotation = 90
        v894.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, ARMOR_GradientTop), ColorSequenceKeypoint.new(1, ARMOR_GradientBottom) })
        v894.Parent = v_u_893
        local v895 = Instance.new("UIStroke")
        v895.Thickness = 0.5
        v895.Color = Color3.fromRGB(0, 0, 0)
        v895.Parent = v892
        local v896 = v_u_893:FindFirstChildOfClass("UIGradient")
        if not boxESPInstances[p858] then
            boxESPInstances[p858] = {}
        end
        if not boxESPInstances[p858].armorBar then
            boxESPInstances[p858].armorBar = {}
        end
        boxESPInstances[p858].armorBar.gradient = v896
        local v_u_897 = p858:FindFirstChild("Data")
        if v_u_897 then
            v_u_897 = v_u_897:FindFirstChild("Armor")
        end
        if v_u_897 and v_u_897:IsA("IntValue") then
            local function v899()
                -- upvalues: (copy) v_u_897, (copy) v_u_893
                local v898 = v_u_897.Value / 100
                TweenService:Create(v_u_893, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ["Size"] = UDim2.new(1, 0, v898, 0)
                }):Play()
            end
            v_u_897.Changed:Connect(v899)
            v899()
            p858.AncestryChanged:Connect(function(_, p900)
                -- upvalues: (copy) v_u_890
                if not p900 and v_u_890 then
                    v_u_890:Destroy()
                end
            end)
        end
    end
    if not NESP_Enabled then
        ::l71::
        if AvatarIcon_Enabled then
            if not boxESPInstances[p858] then
                boxESPInstances[p858] = {}
            end
            local v901 = v860:FindFirstChild("AvatarIcon")
            if v901 then
                applyAvatarIconStyling(v901)
                boxESPInstances[p858].avatarIconGui = v901
            else
                local v902 = Instance.new("BillboardGui")
                v902.Name = "AvatarIcon"
                v902.Size = UDim2.new(0, AvatarIcon_Size, 0, AvatarIcon_Size)
                local v903 = AvatarIcon_Offset
                v902.StudsOffset = Vector3.new(0, v903, 0)
                v902.AlwaysOnTop = true
                v902.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                v902.MaxDistance = (1 / 0)
                v902.Parent = v860
                local v904 = Instance.new("Frame")
                v904.Name = "Background"
                v904.Size = UDim2.new(1, 0, 1, 0)
                v904.BackgroundColor3 = AvatarIconBackground
                v904.BackgroundTransparency = AvatarIconBackgroundTransparency
                v904.BorderSizePixel = 0
                v904.ZIndex = 0
                v904.Parent = v902
                Instance.new("UICorner").Parent = v904
                local v905 = Instance.new("UIStroke")
                v905.Thickness = 1
                v905.Color = AvatarIconBorderColor
                v905.Transparency = AvatarIconBackgroundTransparency
                v905.Parent = v904
                local v906 = Instance.new("ImageLabel")
                v906.Name = "AvatarImage"
                v906.BackgroundTransparency = 1
                v906.Size = UDim2.new(1, -4, 1, -4)
                v906.Position = UDim2.new(0, 2, 0, 2)
                v906.ScaleType = Enum.ScaleType.Fit
                v906.ImageColor3 = Color3.new(1, 1, 1)
                v906.ZIndex = 0
                v906.Parent = v904
                Instance.new("UICorner").Parent = v906
                local v907 = Players:GetPlayerFromCharacter(p858)
                if v907 then
                    local v908 = getAvatarThumbnail(v907.UserId)
                    if v908 ~= "" then
                        v906.Image = v908
                    end
                end
                boxESPInstances[p858].avatarIconGui = v902
                applyAvatarIconStyling(v902)
            end
        else
            clearBillboard(p858, "AvatarIcon")
            if boxESPInstances[p858] then
                boxESPInstances[p858].avatarIconGui = nil
            end
            return
        end
    end
    local v_u_909 = Instance.new("BillboardGui")
    v_u_909.Size = UDim2.new(0, 50, 0, 50)
    local v910 = NameTextOffset
    v_u_909.StudsOffset = Vector3.new(0, v910, 0)
    v_u_909.AlwaysOnTop = true
    v_u_909.Name = "NameESP"
    v_u_909.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v_u_909.MaxDistance = (1 / 0)
    v_u_909.Parent = v860
    local v911 = Instance.new("TextLabel")
    v911.Size = UDim2.new(1, 0, 1, 0)
    v911.BackgroundTransparency = 1
    v911.TextColor3 = NameESPColor
    v911.TextScaled = false
    v911.ZIndex = 10
    local v912 = p858.Name
    local v913 = p858:FindFirstChildOfClass("Humanoid")
    local v914 = Players:GetPlayerFromCharacter(p858)
    if NameOption == "Displayname" then
        if v913 then
            local v915 = v913.DisplayName
            if typeof(v915) == "string" and v913.DisplayName ~= "" then
                v912 = v913.DisplayName
                goto l78
            end
        end
        if v914 then
            v912 = v914.DisplayName
        end
    elseif v914 then
        v912 = v914.Name
    end
    ::l78::
    v911.Text = v912
    v911.Parent = v_u_909
    if not boxESPInstances[p858] then
        boxESPInstances[p858] = {}
    end
    boxESPInstances[p858].nameLabel = v911
    local v916 = Instance.new("UIStroke")
    v916.Thickness = 1
    v916.Color = Color3.fromRGB(0, 0, 0)
    v916.Transparency = 0
    v916.Parent = v911
    if v913 then
        v913.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
    p858.AncestryChanged:Connect(function(_, p917)
        -- upvalues: (copy) v_u_909
        if not p917 and v_u_909 then
            v_u_909:Destroy()
        end
    end)
    goto l71
end
function getSkeletonLine(p918)
    local v919 = p918:FindFirstChild(#p918:GetChildren() + 1)
    if not v919 then
        v919 = Instance.new("Frame")
        local v920 = #p918:GetChildren() + 1
        v919.Name = tostring(v920)
        v919.BackgroundColor3 = SkeletonColor
        v919.BorderSizePixel = 0
        v919.AnchorPoint = Vector2.new(0.5, 0.5)
        v919.ZIndex = 1
        v919.Parent = p918
    end
    return v919
end
local v_u_921 = {
    { "Head", "Torso" },
    { "Torso", "Left Arm" },
    { "Torso", "Right Arm" },
    { "Torso", "Left Leg" },
    { "Torso", "Right Leg" }
}
local v_u_922 = nil
function getSkeletonGUI()
    -- upvalues: (ref) v_u_922
    if v_u_922 and v_u_922.Parent then
        return v_u_922
    end
    local v923 = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not v923 then
        return nil
    end
    v_u_922 = v923:FindFirstChild("PenaBloxSkeleton")
    if not v_u_922 then
        v_u_922 = Instance.new("ScreenGui")
        v_u_922.Name = "PenaBloxSkeleton"
        v_u_922.IgnoreGuiInset = true
        v_u_922.ResetOnSpawn = false
        v_u_922.Parent = v923
    end
    return v_u_922
end
local function v_u_937(p924, p925, p926, p927, p928, p929)
    local v930 = Vector2.new(p925.X, p925.Y)
    local v931 = Vector2.new(p926.X, p926.Y)
    local v932 = (v930 - v931).Magnitude
    if v932 > 1 then
        local v933 = (v930 + v931) / 2
        local v934 = v930.Y - v931.Y
        local v935 = v930.X - v931.X
        local v936 = math.atan2(v934, v935)
        p924.Visible = true
        p924.BackgroundColor3 = p928
        p924.BackgroundTransparency = p929
        p924.Size = UDim2.new(0, v932, 0, p927)
        p924.Position = UDim2.new(0, v933.X, 0, v933.Y)
        p924.Rotation = math.deg(v936)
    else
        p924.Visible = false
    end
end
local function v_u_966()
    -- upvalues: (copy) v_u_921, (copy) v_u_937
    local v938 = getSkeletonGUI()
    if v938 then
        if SKELETON_Enabled then
            v938.Enabled = true
            local v939 = workspace.CurrentCamera
            local _ = Players.LocalPlayer.Character
            for _, v940 in ipairs(getCachedPlayersList()) do
                if v940 == Players.LocalPlayer and not SELF_ESP_Enabled or not v940.Character then
                    if skeletonCache[v940] then
                        for _, v941 in ipairs(skeletonCache[v940]:GetChildren()) do
                            v941.Visible = false
                        end
                    end
                else
                    local v942 = v940.Character
                    local v943 = v942:FindFirstChildOfClass("Humanoid")
                    local v944 = v942:FindFirstChild("HumanoidRootPart")
                    if skeletonCache[v940] then
                        if skeletonCache[v940].Parent ~= v938 then
                            skeletonCache[v940].Parent = v938
                        end
                    else
                        skeletonCache[v940] = Instance.new("Folder")
                        skeletonCache[v940].Name = v940.Name
                        skeletonCache[v940].Parent = v938
                    end
                    local v945 = skeletonCache[v940]
                    local v946 = 0
                    if v944 and (v943 and v943.Health > 0) then
                        local v947 = v_u_921
                        for _, v948 in ipairs(v947) do
                            local v949 = v942:FindFirstChild(v948[1])
                            local v950 = v942:FindFirstChild(v948[2])
                            if v949 and v950 then
                                local v951 = v949.Position
                                local v952 = v950.Position
                                if v948[1] == "Torso" and (v948[2] == "Left Arm" or v948[2] == "Right Arm") then
                                    local v953 = v949.CFrame
                                    local v954 = v949.Size.Y / 2 - 0.1
                                    v951 = v953:PointToWorldSpace((Vector3.new(0, v954, 0)))
                                end
                                local v955, v956 = v939:WorldToViewportPoint(v951)
                                local v957, v958 = v939:WorldToViewportPoint(v952)
                                if v956 or v958 then
                                    v946 = v946 + 1
                                    local v959 = v945:FindFirstChild((tostring(v946)))
                                    if not v959 then
                                        v959 = Instance.new("Frame")
                                        v959.Name = tostring(v946)
                                        v959.AnchorPoint = Vector2.new(0.5, 0.5)
                                        v959.BorderSizePixel = 0
                                        v959.ZIndex = 1
                                        v959.Parent = v945
                                    end
                                    v_u_937(v959, v955, v957, SkeletonThickness, SkeletonColor, SkeletonTransparency)
                                end
                            end
                        end
                    end
                    local v960 = v945:GetChildren()
                    for v961 = 1, #v960 do
                        local v962 = v960[v961]
                        local v963 = v962.Name
                        if v946 < tonumber(v963) then
                            v962.Visible = false
                        end
                    end
                end
            end
            for v964, v965 in pairs(skeletonCache) do
                if not v964.Parent then
                    v965:Destroy()
                    skeletonCache[v964] = nil
                end
            end
        else
            v938.Enabled = false
        end
    else
        return
    end
end
local v967 = nil
if not v967 then
    v967 = coroutine.wrap(function()
        -- upvalues: (copy) v_u_966
        while true do
            task.wait(0.01)
            v_u_966()
        end
    end)
    v967()
end
function chamsChecker()
    while CHAMS_Enabled do
        for _, v968 in ipairs(getCachedPlayersList()) do
            if (v968 ~= Player or SELF_ESP_Enabled) and v968.Character then
                local v969 = v968.Character:FindFirstChildOfClass("Highlight")
                if not v969 then
                    v969 = Instance.new("Highlight")
                    v969.Parent = v968.Character
                end
                v969.OutlineColor = ChamsOutlineColor
                v969.FillColor = ChamsFillColor
                v969.FillTransparency = ChamsFillTransparency
                v969.OutlineTransparency = ChamsOutlineTransparency
            end
        end
        task.wait(1)
    end
end
function clearAllChams()
    for _, v970 in ipairs(getCachedPlayersList()) do
        if v970.Character then
            local v971 = v970.Character:FindFirstChildOfClass("Highlight")
            if v971 then
                v971:Destroy()
            end
        end
    end
end
function clearSelfESP()
    if Player.Character then
        if Player.Character:FindFirstChild("HumanoidRootPart") then
            clearBillboard(Player.Character, "BoxESP")
            clearBillboard(Player.Character, "HealthBar")
            clearBillboard(Player.Character, "NameESP")
            clearBillboard(Player.Character, "ArmorBar")
            clearBillboard(Player.Character, "AvatarIcon")
        end
        local v972 = Player.Character:FindFirstChildOfClass("Highlight")
        if v972 then
            v972:Destroy()
        end
    end
end
function updateChams()
    clearAllChams()
    if CHAMS_Enabled then
        coroutine.wrap(chamsChecker)()
    end
end
function updateESP()
    for v973, v974 in pairs(boxESPInstances) do
        if v974.frames then
            local v975 = {
                v974.frames[1],
                v974.frames[2],
                v974.frames[3],
                v974.frames[4]
            }
            for _, v976 in ipairs(v975) do
                if v976 and v976.Parent then
                    v976.BackgroundColor3 = BoxColor
                end
            end
            local v977 = {
                v974.frames[5],
                v974.frames[6],
                v974.frames[7],
                v974.frames[8]
            }
            for _, v978 in ipairs(v977) do
                if v978 and v978.Parent then
                    v978.BackgroundColor3 = BoxOutlineColor
                end
            end
        end
        if v974.healthBar and v974.healthBar.gradient then
            local v979 = v974.healthBar.gradient
            if v979 and v979.Parent then
                v979.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, HP_GradientTop), ColorSequenceKeypoint.new(0.5, HP_GradientMiddle), ColorSequenceKeypoint.new(1, HP_GradientBottom) })
            end
        end
        if v974.armorBar and v974.armorBar.gradient then
            local v980 = v974.armorBar.gradient
            if v980 and v980.Parent then
                v980.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, ARMOR_GradientTop), ColorSequenceKeypoint.new(1, ARMOR_GradientBottom) })
            end
        end
        if BoxFill_Enabled then
            local v981 = v973:FindFirstChild("HumanoidRootPart")
            if v981 then
                local v982 = v981:FindFirstChild("BoxESP")
                local v983 = v981:FindFirstChild("BoxFill")
                if ESP_Enabled and v982 then
                    if v983 then
                        v983:Destroy()
                        v974.fillBillboard = nil
                    end
                    local v984 = v982:FindFirstChild("BoxFill")
                    if not v984 then
                        v984 = Instance.new("Frame")
                        v984.Name = "BoxFill"
                        v984.Size = UDim2.new(1, 0, 1, 0)
                        v984.Position = UDim2.new(0, 0, 0, 0)
                        v984.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        v984.BorderSizePixel = 0
                        v984.ZIndex = 1
                        v984.Parent = v982
                        local v985 = Instance.new("UIGradient")
                        v985.Parent = v984
                        v974.fillGradient = v985
                    end
                    v984.BackgroundTransparency = BoxFill_Transparency
                    if v974.fillGradient and v974.fillGradient.Parent then
                        v974.fillGradient.Rotation = BoxFill_GradientRotation
                        v974.fillGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, BoxFill_GradientTop), ColorSequenceKeypoint.new(0.5, BoxFill_GradientMiddle), ColorSequenceKeypoint.new(1, BoxFill_GradientBottom) })
                    end
                    v974.fillFrame = v984
                else
                    local v986 = v982 and v982:FindFirstChild("BoxFill")
                    if v986 then
                        v986:Destroy()
                        v974.fillFrame = nil
                        v974.fillGradient = nil
                    end
                    if v983 then
                        v974.fillBillboard = v983
                        v974.fillFrame = v983:FindFirstChild("FillFrame")
                        local v987 = v974.fillFrame
                        if v987 then
                            v987 = v974.fillFrame:FindFirstChildOfClass("UIGradient")
                        end
                        v974.fillGradient = v987
                    else
                        local v988 = Instance.new("BillboardGui")
                        v988.Size = UDim2.new(4, 0, 6, 0)
                        v988.StudsOffset = Vector3.new(0, 0, 0)
                        v988.AlwaysOnTop = true
                        v988.Name = "BoxFill"
                        v988.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        v988.MaxDistance = (1 / 0)
                        v988.Parent = v981
                        local v989 = Instance.new("Frame")
                        v989.Name = "FillFrame"
                        v989.Size = UDim2.new(1, 0, 1, 0)
                        v989.Position = UDim2.new(0, 0, 0, 0)
                        v989.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        v989.BorderSizePixel = 0
                        v989.ZIndex = 1
                        v989.Parent = v988
                        local v990 = Instance.new("UIGradient")
                        v990.Parent = v989
                        v974.fillBillboard = v988
                        v974.fillFrame = v989
                        v974.fillGradient = v990
                    end
                    if v974.fillFrame then
                        v974.fillFrame.BackgroundTransparency = BoxFill_Transparency
                        if v974.fillGradient and v974.fillGradient.Parent then
                            v974.fillGradient.Rotation = BoxFill_GradientRotation
                            v974.fillGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, BoxFill_GradientTop), ColorSequenceKeypoint.new(0.5, BoxFill_GradientMiddle), ColorSequenceKeypoint.new(1, BoxFill_GradientBottom) })
                        end
                    end
                end
            end
        else
            local v991 = v973:FindFirstChild("HumanoidRootPart")
            if v991 then
                local v992 = v991:FindFirstChild("BoxFill")
                if v992 then
                    v992:Destroy()
                end
                local v993 = v991:FindFirstChild("BoxESP")
                local v994 = v993 and v993:FindFirstChild("BoxFill")
                if v994 then
                    v994:Destroy()
                end
            end
            v974.fillBillboard = nil
            v974.fillFrame = nil
            v974.fillGradient = nil
        end
        if v974.nameLabel then
            local v995 = v974.nameLabel
            if v995 and v995.Parent then
                v995.TextColor3 = NameESPColor
            end
        end
        if AvatarIcon_Enabled then
            if v974.avatarIconGui and v974.avatarIconGui.Parent then
                v974.avatarIconGui.Size = UDim2.new(0, AvatarIcon_Size, 0, AvatarIcon_Size)
                local v996 = v974.avatarIconGui
                local v997 = AvatarIcon_Offset
                v996.StudsOffset = Vector3.new(0, v997, 0)
                local v998 = v974.avatarIconGui:FindFirstChild("Background")
                if v998 then
                    v998.BackgroundColor3 = AvatarIconBackground
                    local v999 = v998:FindFirstChildOfClass("UICorner")
                    if v999 then
                        v999.CornerRadius = AvatarIcon_CornerRadius
                    end
                    local v1000 = v998:FindFirstChildOfClass("UIStroke")
                    if v1000 then
                        v1000.Color = AvatarIconBorderColor
                    end
                    local v1001 = v998:FindFirstChild("AvatarImage")
                    if v1001 then
                        local v1002 = v1001:FindFirstChildOfClass("UICorner")
                        if v1002 then
                            v1002.CornerRadius = AvatarIcon_CornerRadius
                        end
                    end
                end
            end
        elseif v973 then
            clearBillboard(v973, "AvatarIcon")
            if v974.avatarIconGui then
                v974.avatarIconGui = nil
            end
        end
    end
    for _, v1003 in ipairs(getCachedPlayersList()) do
        if v1003 ~= Player or SELF_ESP_Enabled then
            if v1003.Character then
                createESP(v1003.Character, true)
            end
            v1003.CharacterAdded:Connect(function(p1004)
                task.wait(0.6)
                createESP(p1004, true)
            end)
        end
    end
    if not NESP_Enabled then
        for _, v1005 in ipairs(getCachedPlayersList()) do
            if v1005.Character then
                local v1006 = v1005.Character:FindFirstChildOfClass("Humanoid")
                if v1006 then
                    v1006.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                end
            end
        end
    end
end
function ESPChecker()
    while true do
        task.wait(1)
        for _, v1007 in ipairs(getCachedPlayersList()) do
            if v1007 ~= Player or SELF_ESP_Enabled then
                local v1008 = v1007.Character
                if v1008 and (v1008.Parent and (v1008 ~= Player.Character or SELF_ESP_Enabled)) then
                    local v1009 = v1008:FindFirstChild("HumanoidRootPart")
                    if v1009 then
                        if ESP_Enabled and not v1009:FindFirstChild("BoxESP") then
                            createESP(v1008, true)
                        end
                        if HB_Enabled and not v1009:FindFirstChild("HealthBar") then
                            createESP(v1008, true)
                        end
                        if NESP_Enabled and not v1009:FindFirstChild("NameESP") then
                            createESP(v1008, true)
                        end
                        if ARMOR_Enabled and not v1009:FindFirstChild("ArmorBar") then
                            createESP(v1008, true)
                        end
                    end
                end
            end
        end
    end
end
task.spawn(ESPChecker)
local v1011 = ESPPage:AddToggle("Box ESP", false, function(p1010)
    ESP_Enabled = p1010
    updateESP()
end):AddSettings()
v1011:AddColorPicker("Box color", BoxColor, function(p1012)
    BoxColor = p1012
    updateESP()
end)
v1011:AddColorPicker("Outline color", BoxOutlineColor, function(p1013)
    BoxOutlineColor = p1013
    updateESP()
end)
v1011:AddSlider("Box Thickness", 1, 0.5, 3, 0.01, function(p1014)
    BoxThickness = p1014
    updateESP()
end)
v1011:AddDropdown("Bars order", { "Health, Armor", "Armor, Health" }, "Health, Armor", function(p1015)
    BarsOrder = p1015
    updateESP()
end)
v1011:AddSlider("Offset between bars", 0.25, 0, 1, 0.01, function(p1016)
    BarSpacing = p1016
    updateESP()
end)
local v1018 = ESPPage:AddToggle("Box Fill", false, function(p1017)
    BoxFill_Enabled = p1017
    updateESP()
end):AddSettings()
v1018:AddSlider("Transparency", 0.5, 0, 1, 0.01, function(p1019)
    BoxFill_Transparency = p1019
    updateESP()
end)
v1018:AddColorPicker("Gradient Top", BoxFill_GradientTop, function(p1020)
    BoxFill_GradientTop = p1020
    updateESP()
end)
v1018:AddColorPicker("Gradient Middle", BoxFill_GradientMiddle, function(p1021)
    BoxFill_GradientMiddle = p1021
    updateESP()
end)
v1018:AddColorPicker("Gradient Bottom", BoxFill_GradientBottom, function(p1022)
    BoxFill_GradientBottom = p1022
    updateESP()
end)
v1018:AddSlider("Rotation", 90, 0, 360, 1, function(p1023)
    BoxFill_GradientRotation = p1023
    updateESP()
end)
local v1025 = ESPPage:AddToggle("Healthbar", false, function(p1024)
    HB_Enabled = p1024
    updateESP()
end):AddSettings()
v1025:AddDropdown("Health bar position", { "Left", "Right" }, "Left", function(p1026)
    HP_BAR_Position = p1026
    updateESP()
end)
v1025:AddSlider("Health Bar Offset", 2.25, 0, 5, 0.01, function(p1027)
    HP_BarOffset = p1027
    updateESP()
end)
v1025:AddSlider("Health Bar Thickness", 2, 0.5, 5, 0.01, function(p1028)
    HP_BarThickness = p1028
    updateESP()
end)
v1025:AddColorPicker("Gradient Top", HP_GradientTop, function(p1029)
    HP_GradientTop = p1029
    updateESP()
end)
v1025:AddColorPicker("Gradient Middle", HP_GradientMiddle, function(p1030)
    HP_GradientMiddle = p1030
    updateESP()
end)
v1025:AddColorPicker("Gradient Bottom", HP_GradientBottom, function(p1031)
    HP_GradientBottom = p1031
    updateESP()
end)
local v1033 = ESPPage:AddToggle("Name ESP", false, function(p1032)
    NESP_Enabled = p1032
    updateESP()
end):AddSettings()
v1033:AddSlider("Name Text Offset", 4.4, 0, 10, 0.01, function(p1034)
    NameTextOffset = p1034
    updateESP()
end)
v1033:AddColorPicker("Text color", NameESPColor, function(p1035)
    NameESPColor = p1035
    updateESP()
end)
local v1037 = ESPPage:AddToggle("Avatar Icon", false, function(p1036)
    AvatarIcon_Enabled = p1036
    updateESP()
end):AddSettings()
v1037:AddSlider("Icon Size", AvatarIcon_Size, 24, 280, 1, function(p1038)
    local v1039 = tonumber(p1038) or AvatarIcon_Size
    AvatarIcon_Size = math.floor(v1039)
    updateESP()
end)
v1037:AddSlider("Icon Offset Y", AvatarIcon_Offset, -5, 15, 0.05, function(p1040)
    AvatarIcon_Offset = tonumber(p1040) or AvatarIcon_Offset
    updateESP()
end)
v1037:AddDropdown("Shape", { "Square", "Rounded", "Circle" }, AvatarIconShape, function(p1041)
    AvatarIconShape = p1041 or "Rounded"
    updateESP()
end)
v1037:AddSlider("Background Transparency", AvatarIconBackgroundTransparency, 0, 1, 0.01, function(p1042)
    local v1043 = tonumber(p1042) or AvatarIconBackgroundTransparency
    AvatarIconBackgroundTransparency = math.clamp(v1043, 0, 1)
    updateESP()
end)
local v1045 = ESPPage:AddToggle("Armor", false, function(p1044)
    ARMOR_Enabled = p1044
    updateESP()
end):AddSettings()
v1045:AddDropdown("Armor bar position", { "Left", "Right" }, "Right", function(p1046)
    ARMOR_BAR_Position = p1046
    updateESP()
end)
v1045:AddSlider("Armor Bar Offset", 2.25, 0, 5, 0.01, function(p1047)
    ARMOR_BarOffset = p1047
    updateESP()
end)
v1045:AddSlider("Armor Bar Thickness", 2, 0.5, 5, 0.01, function(p1048)
    ARMOR_BarThickness = p1048
    updateESP()
end)
v1045:AddColorPicker("Gradient Top", ARMOR_GradientTop, function(p1049)
    ARMOR_GradientTop = p1049
    updateESP()
end)
v1045:AddColorPicker("Gradient Bottom", ARMOR_GradientBottom, function(p1050)
    ARMOR_GradientBottom = p1050
    updateESP()
end)
ESPPage:AddDropdown("Use name", { "Username", "Displayname" }, "Username", function(p1051)
    NameOption = tostring(p1051) == "Displayname" and "Displayname" or "Username"
    updateESP()
end)
local v1053 = ESPPage:AddToggle("Skeleton", false, function(p1052)
    SKELETON_Enabled = p1052
end):AddSettings()
v1053:AddColorPicker("Skeleton Color", SkeletonColor, function(p1054)
    SkeletonColor = p1054
end)
v1053:AddSlider("Thickness", 1, 0.5, 5, 0.1, function(p1055)
    SkeletonThickness = p1055
end)
v1053:AddSlider("Transparency", 0, 0, 1, 0.01, function(p1056)
    SkeletonTransparency = p1056
end)
local v1058 = ChamsPage:AddToggle("Chams", false, function(p1057)
    CHAMS_Enabled = p1057
    if CHAMS_Enabled then
        coroutine.wrap(chamsChecker)()
    else
        clearAllChams()
    end
end):AddSettings()
v1058:AddColorPicker("Fill color", ChamsFillColor, function(p1059)
    ChamsFillColor = p1059
    updateChams()
end)
v1058:AddColorPicker("Outline color", ChamsOutlineColor, function(p1060)
    ChamsOutlineColor = p1060
    updateChams()
end)
v1058:AddSlider("Fill transparency", ChamsFillTransparency, 0, 1, 0.01, function(p1061)
    ChamsFillTransparency = p1061
    updateChams()
end)
v1058:AddSlider("Outline transparency", ChamsOutlineTransparency, 0, 1, 0.01, function(p1062)
    ChamsOutlineTransparency = p1062
    updateChams()
end)
auraStates = {
    ["Halo"] = false,
    ["Angel Wings"] = false,
    ["Ambient Aura"] = false,
    ["Ground Tornado"] = false,
    ["Sakura"] = false,
    ["Enchanted"] = false,
    ["Enchanted 2"] = false
}
auraInstances = {}
function clearAura(p1063)
    if auraInstances[p1063] then
        for _, v1064 in ipairs(auraInstances[p1063]) do
            if v1064 and v1064.Parent then
                v1064:Destroy()
            end
        end
        auraInstances[p1063] = nil
    end
end
function applyAura(p1065)
    if Player.Character then
        clearAura(p1065)
        local v1066 = ReplicatedFirst:FindFirstChild("Auras")
        if v1066 then
            local v1067 = v1066:FindFirstChild(p1065)
            if v1067 then
                auraInstances[p1065] = {}
                for _, v1068 in ipairs(v1067:GetChildren()) do
                    if v1068:IsA("BasePart") then
                        local v1069
                        if v1068.Name == "HumanoidRootPart" then
                            v1069 = Player.Character:FindFirstChild("HumanoidRootPart")
                        elseif v1068.Name == "Head" then
                            v1069 = Player.Character:FindFirstChild("Head")
                        elseif v1068.Name == "Torso" then
                            v1069 = Player.Character:FindFirstChild("Torso")
                        else
                            v1069 = Player.Character:FindFirstChild(v1068.Name)
                        end
                        if v1069 then
                            for _, v1070 in ipairs(v1068:GetChildren()) do
                                local v1071 = v1070:Clone()
                                v1071.Parent = v1069
                                local v1072 = auraInstances[p1065]
                                table.insert(v1072, v1071)
                            end
                        end
                    end
                end
            end
        else
            return
        end
    else
        return
    end
end
function updateAura(p1073, p1074)
    if p1074 then
        applyAura(p1073)
    else
        clearAura(p1073)
    end
end
SelfVisualsPage:AddToggle("Halo", false, function(p1075)
    auraStates.Halo = p1075
    updateAura("Halo", p1075)
end)
SelfVisualsPage:AddToggle("Angel Wings", false, function(p1076)
    auraStates["Angel Wings"] = p1076
    updateAura("Angel Wings", p1076)
end)
SelfVisualsPage:AddToggle("Ambient Aura", false, function(p1077)
    auraStates["Ambient Aura"] = p1077
    updateAura("Ambient Aura", p1077)
end)
SelfVisualsPage:AddToggle("Ground Tornado", false, function(p1078)
    auraStates["Ground Tornado"] = p1078
    updateAura("Ground Tornado", p1078)
end)
SelfVisualsPage:AddToggle("Sakura", false, function(p1079)
    auraStates.Sakura = p1079
    updateAura("Sakura", p1079)
end)
SelfVisualsPage:AddToggle("Enchanted", false, function(p1080)
    auraStates.Enchanted = p1080
    updateAura("Enchanted", p1080)
end)
SelfVisualsPage:AddToggle("Enchanted 2", false, function(p1081)
    auraStates["Enchanted 2"] = p1081
    updateAura("Enchanted 2", p1081)
end)
localPlayerEnabled = false
localPlayerHighlightEnabled = false
localPlayerHighlightAlwaysOnTop = true
localPlayerMaterial = "ForceField"
localPlayerTransparency = 0
localPlayerColorR = 255
localPlayerColorG = 255
localPlayerColorB = 255
localPlayerHighlightFillTransparency = 0.5
localPlayerHighlightOutlineTransparency = 0
local v1082 = Color3.fromRGB(255, 255, 255)
local v1083 = Color3.fromRGB(255, 255, 255)
localPlayerHighlightFillColor = v1082
localPlayerHighlightOutlineColor = v1083
localPlayerHighlight = nil
originalColors = {}
originalMaterials = {}
localPlayerMaterialMap = {
    ["Default"] = nil,
    ["ForceField"] = Enum.Material.ForceField,
    ["Neon"] = Enum.Material.Neon,
    ["Solid"] = Enum.Material.SmoothPlastic
}
function saveOriginalAppearance()
    if Player.Character then
        originalColors = {}
        originalMaterials = {}
        for _, v1084 in ipairs(Player.Character:GetChildren()) do
            if v1084:IsA("BasePart") then
                originalColors[v1084] = v1084.Color
                originalMaterials[v1084] = v1084.Material
            end
        end
        for _, v1085 in ipairs(Player.Character:GetChildren()) do
            if v1085:IsA("Accessory") then
                local v1086 = v1085:FindFirstChild("Handle")
                if v1086 and v1086:IsA("BasePart") then
                    originalColors[v1086] = v1086.Color
                    originalMaterials[v1086] = v1086.Material
                end
            end
        end
    end
end
function applyLocalPlayerVisuals()
    -- upvalues: (ref) v_u_363, (copy) v_u_402
    if not Player.Character then
        return
    end
    local v1087 = Color3.fromRGB(localPlayerColorR, localPlayerColorG, localPlayerColorB)
    local v1088 = localPlayerMaterialMap[localPlayerMaterial]
    local v1089 = localPlayerMaterial == "Neon" and true or v1088 == Enum.Material.Neon
    local v1090 = {
        "Torso",
        "Left Leg",
        "Right Leg",
        "Left Arm",
        "Right Arm"
    }
    for _, v1091 in ipairs(Player.Character:GetChildren()) do
        if v1091:IsA("BasePart") and (v1091.Name ~= "HumanoidRootPart" and v1091.Name ~= "Head") then
            v1091.Color = v1087
            if v1088 then
                v1091.Material = v1088
            end
            v1091.Transparency = localPlayerTransparency
            local v1092 = false
            for _, v1093 in ipairs(v1090) do
                if v1091.Name == v1093 then
                    v1092 = true
                    break
                end
            end
            if v1092 then
                local v1094 = v1091:FindFirstChildOfClass("BlockMesh")
                if v1089 then
                    if not v1094 then
                        Instance.new("BlockMesh").Parent = v1091
                    end
                elseif v1094 then
                    v1094:Destroy()
                end
            end
        end
    end
    for _, v1095 in ipairs(Player.Character:GetChildren()) do
        if v1095:IsA("Accessory") then
            local v1096 = v1095:FindFirstChild("Handle")
            if v1096 and v1096:IsA("BasePart") then
                v1096.Color = v1087
                if v1088 then
                    v1096.Material = v1088
                end
                v1096.Transparency = localPlayerTransparency
            end
        end
    end
    ensureLocalPlayerHighlight()
    if v_u_363 then
        v_u_402()
    end
end
function restoreOriginalAppearance()
    if Player.Character then
        for v1097, v1098 in pairs(originalColors) do
            if v1097 and v1097.Parent then
                v1097.Color = v1098
                if originalMaterials[v1097] then
                    v1097.Material = originalMaterials[v1097]
                end
                if v1097.Name == "HumanoidRootPart" then
                    v1097.Transparency = 1
                else
                    v1097.Transparency = 0
                end
            end
        end
        destroyLocalPlayerHighlight()
    end
end
function destroyLocalPlayerHighlight()
    if localPlayerHighlight then
        localPlayerHighlight:Destroy()
    end
    localPlayerHighlight = nil
end
function ensureLocalPlayerHighlight()
    if localPlayerHighlightEnabled and Player.Character then
        if not localPlayerHighlight then
            localPlayerHighlight = Instance.new("Highlight")
            localPlayerHighlight.Name = "LocalPlayerHighlight"
            localPlayerHighlight.Parent = Player.Character
        end
        localPlayerHighlight.Adornee = Player.Character
        local v1099 = localPlayerHighlight
        local v1100 = localPlayerHighlightFillTransparency
        v1099.FillTransparency = math.clamp(v1100, 0, 1)
        local v1101 = localPlayerHighlight
        local v1102 = localPlayerHighlightOutlineTransparency
        v1101.OutlineTransparency = math.clamp(v1102, 0, 1)
        localPlayerHighlight.FillColor = localPlayerHighlightFillColor
        localPlayerHighlight.OutlineColor = localPlayerHighlightOutlineColor
        localPlayerHighlight.DepthMode = localPlayerHighlightAlwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    else
        destroyLocalPlayerHighlight()
    end
end
local v1104 = CharacterPage:AddToggle("Localplayer", false, function(p1103)
    localPlayerEnabled = p1103
    if localPlayerEnabled then
        saveOriginalAppearance()
        applyLocalPlayerVisuals()
    else
        restoreOriginalAppearance()
    end
end):AddSettings()
v1104:AddDropdown("Material", {
    "Default",
    "ForceField",
    "Neon",
    "Solid"
}, localPlayerMaterial, function(p1105)
    if type(p1105) == "string" then
        localPlayerMaterial = p1105
        if localPlayerEnabled then
            applyLocalPlayerVisuals()
        end
    end
end)
v1104:AddSlider("Transparency", localPlayerTransparency, 0, 1, 0.01, function(p1106)
    local v1107 = tonumber(p1106)
    if v1107 then
        localPlayerTransparency = math.clamp(v1107, 0, 1)
        if localPlayerEnabled then
            applyLocalPlayerVisuals()
        end
    end
end)
v1104:AddColorPicker("Color", Color3.fromRGB(localPlayerColorR, localPlayerColorG, localPlayerColorB), function(...)
    local v1108 = coerceColor3(...)
    if v1108 then
        local v1109 = v1108.R * 255
        localPlayerColorR = math.floor(v1109)
        local v1110 = v1108.G * 255
        localPlayerColorG = math.floor(v1110)
        local v1111 = v1108.B * 255
        localPlayerColorB = math.floor(v1111)
        if localPlayerEnabled then
            applyLocalPlayerVisuals()
        end
    end
end)
v1104:AddToggle("Highlight", localPlayerHighlightEnabled, function(p1112)
    localPlayerHighlightEnabled = p1112
    ensureLocalPlayerHighlight()
end)
v1104:AddSlider("Fill Transparency", localPlayerHighlightFillTransparency, 0, 1, 0.01, function(p1113)
    local v1114 = tonumber(p1113)
    if v1114 then
        localPlayerHighlightFillTransparency = math.clamp(v1114, 0, 1)
        ensureLocalPlayerHighlight()
    end
end)
v1104:AddSlider("Outline Transparency", localPlayerHighlightOutlineTransparency, 0, 1, 0.01, function(p1115)
    local v1116 = tonumber(p1115)
    if v1116 then
        localPlayerHighlightOutlineTransparency = math.clamp(v1116, 0, 1)
        ensureLocalPlayerHighlight()
    end
end)
v1104:AddColorPicker("Fill Color", localPlayerHighlightFillColor, function(...)
    local v1117 = coerceColor3(...)
    if v1117 then
        localPlayerHighlightFillColor = v1117
        ensureLocalPlayerHighlight()
    end
end)
v1104:AddColorPicker("Outline Color", localPlayerHighlightOutlineColor, function(...)
    local v1118 = coerceColor3(...)
    if v1118 then
        localPlayerHighlightOutlineColor = v1118
        ensureLocalPlayerHighlight()
    end
end)
v1104:AddToggle("On Top", localPlayerHighlightAlwaysOnTop, function(p1119)
    localPlayerHighlightAlwaysOnTop = p1119 and true or false
    ensureLocalPlayerHighlight()
end)
currentPitchValue = 0
currentPitchMode = "Static"
pitchJitterTimer = 0
pitchJitterFlip = false
pitchSwayMin = -60
pitchSwayMax = 60
pitchSwaySpeed = 1
pitchSwayDirection = 1
pitchSwayCurrent = 0
pitchJitterDelay = 0.05
pitchJitterRandomness = 0
function applyPitch(p1120)
    if AAHandler and AAHandler.SendMotorOverrides then
        AAHandler:SendMotorOverrides(nil, p1120)
    end
end
function getEffectivePitchValue()
    return currentPitchMode ~= "Static" and 0 or currentPitchValue
end
function sendPitchUpdate()
    if AAHandler and AAHandler.SendPitchMode then
        if currentPitchMode == "Static" then
            applyPitch(currentPitchValue)
            return
        elseif currentPitchMode == "Random" then
            AAHandler:SendPitchMode("Random", currentPitchValue)
            return
        elseif currentPitchMode == "Jitter" then
            AAHandler:SendPitchMode("Jitter", currentPitchValue, pitchSwayMin, pitchSwayMax, nil, pitchJitterDelay, pitchJitterRandomness)
            return
        elseif currentPitchMode == "Sway" then
            AAHandler:SendPitchMode("Sway", currentPitchValue, pitchSwayMin, pitchSwayMax, pitchSwaySpeed, nil, nil)
            return
        elseif currentPitchMode == "3 Angles" then
            AAHandler:SendPitchMode("3 Angles", currentPitchValue, pitchSwayMin, pitchSwayMax, nil, pitchJitterDelay, pitchJitterRandomness)
        elseif currentPitchMode == "5 Angles" then
            AAHandler:SendPitchMode("5 Angles", currentPitchValue, pitchSwayMin, pitchSwayMax, nil, pitchJitterDelay, pitchJitterRandomness)
        end
    else
        return
    end
end
AntiAimPage:AddDropdown("Pitch", {
    "Static",
    "Random",
    "Jitter",
    "Sway",
    "3 Angles",
    "5 Angles"
}, "Static", function(p1121)
    local _ = currentPitchMode
    currentPitchMode = p1121 or "Static"
    pitchJitterTimer = 0
    pitchJitterFlip = false
    if currentPitchMode == "Sway" then
        pitchSwayCurrent = 0
        pitchSwayDirection = 1
    end
    sendPitchUpdate()
    ensurePitchLoop()
    if currentPitchMode == "Static" then
        applyPitch(currentPitchValue)
    end
end)
AntiAimPage:AddSlider("Pitch value", 0, -90, 90, 1, function(p1122)
    local v1123 = tonumber(p1122) or 0
    currentPitchValue = math.clamp(v1123, -90, 90)
    if currentPitchMode == "Static" then
        applyPitch(currentPitchValue)
    else
        sendPitchUpdate()
    end
end)
local v1124 = AntiAimPage:AddSettingsGroup("Pitch settings")
v1124:AddSlider("Min Pitch", pitchSwayMin, -90, 90, 1, function(p1125)
    local v1126 = tonumber(p1125) or -60
    pitchSwayMin = math.clamp(v1126, -90, 90)
    if pitchSwayMin > pitchSwayMax then
        pitchSwayMin = pitchSwayMax
    end
    if currentPitchMode == "Sway" or (currentPitchMode == "Jitter" or (currentPitchMode == "3 Angles" or currentPitchMode == "5 Angles")) then
        sendPitchUpdate()
    end
end)
v1124:AddSlider("Max Pitch", pitchSwayMax, -90, 90, 1, function(p1127)
    local v1128 = tonumber(p1127) or 60
    pitchSwayMax = math.clamp(v1128, -90, 90)
    if pitchSwayMax < pitchSwayMin then
        pitchSwayMax = pitchSwayMin
    end
    if currentPitchMode == "Sway" or (currentPitchMode == "Jitter" or (currentPitchMode == "3 Angles" or currentPitchMode == "5 Angles")) then
        sendPitchUpdate()
    end
end)
v1124:AddSlider("Sway Speed", pitchSwaySpeed, 0.1, 10, 0.1, function(p1129)
    local v1130 = tonumber(p1129) or 1
    pitchSwaySpeed = math.clamp(v1130, 0.1, 10)
    if currentPitchMode == "Sway" then
        sendPitchUpdate()
    end
end)
v1124:AddSlider("Jitter Delay", pitchJitterDelay, 0.005, 1, 0.005, function(p1131)
    local v1132 = tonumber(p1131) or 0.05
    pitchJitterDelay = math.clamp(v1132, 0.005, 1)
    if currentPitchMode == "Jitter" or (currentPitchMode == "3 Angles" or currentPitchMode == "5 Angles") then
        sendPitchUpdate()
    end
end)
v1124:AddSlider("Jitter Randomness", pitchJitterRandomness, 0, 3, 0.01, function(p1133)
    local v1134 = tonumber(p1133) or 0
    pitchJitterRandomness = math.clamp(v1134, 0, 3)
    if currentPitchMode == "Jitter" or (currentPitchMode == "3 Angles" or currentPitchMode == "5 Angles") then
        sendPitchUpdate()
    end
end)
local v_u_1135 = nil
function ensurePitchLoop()
    -- upvalues: (ref) v_u_1135
    if v_u_1135 then
        v_u_1135:Disconnect()
        v_u_1135 = nil
    end
end
task.defer(function()
    if currentPitchMode == "Static" then
        applyPitch(currentPitchValue)
    else
        sendPitchUpdate()
    end
end)
currentYawMode = "Static"
currentYawBase = "Local view"
currentYawValue = 0
currentJitterMode = "Off"
currentJitterValue = 30
currentJitterLeft = -30
currentJitterRight = 30
jitterDelay = 0.05
jitterRandomness = 0
jitterTimer = 0
jitterFlip = false
swayMinYaw = -60
swayMaxYaw = 60
swaySpeed = 1
swayDirection = 1
swayCurrentYaw = 0
manualsEnabled = false
function sendYawJitterUpdate()
    if AAHandler and AAHandler.SendYawJitter then
        if currentJitterMode == "Off" then
            AAHandler:SendYawJitter("Off", 0, 0, 0, jitterDelay, jitterRandomness)
        else
            AAHandler:SendYawJitter(currentJitterMode, currentJitterLeft, currentJitterRight, currentJitterValue, jitterDelay, jitterRandomness)
        end
    else
        return
    end
end
local v_u_1136 = {
    ["Left"] = false,
    ["Right"] = false
}
local v_u_1137 = {
    ["Left"] = -90,
    ["Right"] = 90
}
local v_u_1138 = nil
manualKeybindHandles = {}
manualCallbackSuppress = {
    ["Left"] = false,
    ["Right"] = false
}
manualMobileButtons = {}
local v_u_1139 = nil
function refreshHumanoidReference()
    -- upvalues: (ref) v_u_1139
    local v1140 = Player.Character
    if v1140 then
        v1140 = v1140:FindFirstChildOfClass("Humanoid")
    end
    if v1140 ~= v_u_1139 then
        v_u_1139 = v1140
    end
    return v_u_1139
end
function updateManualMobileVisibility()
    for _, v1141 in pairs(manualMobileButtons) do
        if v1141 and v1141.SetVisible then
            v1141:SetVisible(manualsEnabled)
        end
    end
end
function setAutoRotateEnabled(p1142)
    local v1143 = refreshHumanoidReference()
    if v1143 then
        v1143.AutoRotate = p1142 and true or false
    end
end
function getHorizontalDirection(p1144, p1145)
    local v1146 = p1145.X - p1144.X
    local v1147 = p1145.Z - p1144.Z
    local v1148 = Vector3.new(v1146, 0, v1147)
    local v1149 = v1148.Magnitude
    if v1149 < 1e-6 then
        return nil
    else
        return v1148 / v1149
    end
end
function getCameraFacingDirection()
    local v1150 = workspace.CurrentCamera
    if v1150 then
        local v1151 = v1150.CFrame.LookVector
        local v1152 = v1151.X
        local v1153 = v1151.Z
        local v1154 = Vector3.new(v1152, 0, v1153)
        local v1155 = v1154.Magnitude
        if v1155 < 1e-6 then
            return nil
        else
            return v1154 / v1155
        end
    else
        return nil
    end
end
function getBaseDirection(p1156)
    if currentYawBase == "At targets" and targetPosValue then
        local v1157 = targetPosValue.Value
        if typeof(v1157) == "Vector3" and (v1157 - ZERO_VECTOR).Magnitude > 0.001 then
            local v1158 = v1157.X - p1156.Position.X
            local v1159 = v1157.Z - p1156.Position.Z
            local v1160 = Vector3.new(v1158, 0, v1159)
            if v1160.Magnitude > 0.001 then
                return v1160.Unit
            end
        end
    end
    return getCameraFacingDirection()
end
function getEffectiveYawValue()
    -- upvalues: (ref) v_u_1138, (copy) v_u_1137
    if manualsEnabled and v_u_1138 then
        return v_u_1137[v_u_1138] or currentYawValue
    else
        return currentYawValue
    end
end
function resetJitterState()
    jitterTimer = 0
    jitterFlip = false
end
function getJitteredYawValue(p1161)
    if currentJitterMode == "Offset" then
        jitterTimer = jitterTimer + (p1161 or 0)
        if jitterTimer >= 0.05 then
            jitterTimer = 0
            jitterFlip = not jitterFlip
        end
        if jitterFlip then
            return currentJitterValue
        else
            return getEffectiveYawValue()
        end
    else
        return getEffectiveYawValue()
    end
end
function applyStaticYaw(p1162, p1163, p1164)
    local v1165 = getBaseDirection(p1162)
    if v1165 then
        if p1163 == nil then
            if currentJitterMode == "Offset" then
                p1163 = getJitteredYawValue(p1164)
            else
                p1163 = getEffectiveYawValue()
            end
        end
        local v1166 = v1165.X
        local v1167 = v1165.Z
        local v1168 = math.atan2(v1166, v1167) - math.rad(p1163 or 0)
        local v1169 = math.sin(v1168)
        local v1170 = math.cos(v1168)
        local v1171 = Vector3.new(v1169, 0, v1170)
        local v1172 = p1162.AssemblyLinearVelocity
        p1162.CFrame = CFrame.new(p1162.Position, p1162.Position + v1171)
        p1162.AssemblyLinearVelocity = v1172
    end
end
function resetSpinAngle()
    local v1173 = Player.Character
    if v1173 then
        v1173 = Player.Character:FindFirstChild("HumanoidRootPart")
    end
    if v1173 then
        local v1174 = getBaseDirection(v1173)
        if v1174 then
            local v1175 = v1174.X
            local v1176 = v1174.Z
            spinAngle = math.atan2(v1175, v1176)
        else
            local _, v1177 = v1173.CFrame:ToOrientation()
            spinAngle = v1177
        end
    else
        spinAngle = 0
        return
    end
end
function applySpinYaw(p1178, p1179)
    local v1180 = currentYawValue or 0
    local v1181 = math.rad(v1180) * 100
    if v1181 ~= 0 then
        spinAngle = spinAngle + v1181 * p1179
        local v1182 = p1178.AssemblyLinearVelocity
        p1178.CFrame = CFrame.new(p1178.Position) * CFrame.Angles(0, spinAngle, 0)
        p1178.AssemblyLinearVelocity = v1182
    end
end
function applySwayYaw(p1183, p1184)
    local v1185 = getBaseDirection(p1183)
    if v1185 then
        local v1186 = swaySpeed * 60
        local v1187 = math.rad(v1186)
        swayCurrentYaw = swayCurrentYaw + swayDirection * v1187 * p1184
        local v1188 = swayCurrentYaw
        local v1189 = swayMaxYaw
        if math.rad(v1189) < v1188 then
            local v1190 = swayMaxYaw
            swayCurrentYaw = math.rad(v1190)
            swayDirection = -1
        else
            local v1191 = swayCurrentYaw
            local v1192 = swayMinYaw
            if v1191 < math.rad(v1192) then
                local v1193 = swayMinYaw
                swayCurrentYaw = math.rad(v1193)
                swayDirection = 1
            end
        end
        local v1194 = v1185.X
        local v1195 = v1185.Z
        local v1196 = math.atan2(v1194, v1195) - swayCurrentYaw
        local v1197 = math.sin(v1196)
        local v1198 = math.cos(v1196)
        local v1199 = Vector3.new(v1197, 0, v1198)
        local v1200 = p1183.AssemblyLinearVelocity
        p1183.CFrame = CFrame.new(p1183.Position, p1183.Position + v1199)
        p1183.AssemblyLinearVelocity = v1200
    end
end
function ensureYawLoop()
    -- upvalues: (ref) v_u_1138
    if yawConnection then
        yawConnection:Disconnect()
        yawConnection = nil
    end
    setAutoRotateEnabled(false)
    yawConnection = RunService.RenderStepped:Connect(function(p1201)
        -- upvalues: (ref) v_u_1138
        local v1202 = Player.Character
        if v1202 then
            v1202 = Player.Character:FindFirstChild("HumanoidRootPart")
        end
        if v1202 then
            if currentYawMode == "Static" then
                local v1203 = getEffectiveYawValue()
                applyStaticYaw(v1202, v1203)
                return
            elseif currentYawMode == "Spin" then
                if manualsEnabled and v_u_1138 then
                    local v1204 = getEffectiveYawValue()
                    applyStaticYaw(v1202, v1204)
                else
                    applySpinYaw(v1202, p1201)
                end
            else
                if currentYawMode == "Sway" then
                    if manualsEnabled and v_u_1138 then
                        local v1205 = getEffectiveYawValue()
                        applyStaticYaw(v1202, v1205)
                        return
                    end
                    applySwayYaw(v1202, p1201)
                end
                return
            end
        else
            return
        end
    end)
end
function forceKeybindState(p1206, p1207)
    local v1208 = manualKeybindHandles[p1206]
    if v1208 and v1208.GetState then
        local v1209 = v1208:GetState()
        local v1210 = v1208.GetMode
        if v1210 then
            v1210 = v1208:GetMode()
        end
        if v1210 == "Hold" then
            if p1207 and not v1209 then
                manualCallbackSuppress[p1206] = true
                v1208:Trigger("press")
                manualCallbackSuppress[p1206] = false
                return
            end
            if not p1207 and v1209 then
                manualCallbackSuppress[p1206] = true
                v1208:Trigger("release")
                manualCallbackSuppress[p1206] = false
                return
            end
        elseif v1209 ~= p1207 then
            manualCallbackSuppress[p1206] = true
            v1208:Trigger()
            manualCallbackSuppress[p1206] = false
        end
    end
end
function setManualActive(p1211, p1212, p1213)
    -- upvalues: (copy) v_u_1136, (ref) v_u_1138
    local v1214 = p1213 or {}
    if not manualsEnabled then
        p1212 = false
    end
    if p1212 then
        local v1215 = p1211 == "Left" and "Right" or "Left"
        if v_u_1136[v1215] then
            v_u_1136[v1215] = false
            if not v1214.skipForce then
                forceKeybindState(v1215, false)
            end
        end
        v_u_1136[p1211] = true
        v_u_1138 = p1211
    else
        if not v_u_1136[p1211] then
            return
        end
        v_u_1136[p1211] = false
        if v_u_1138 == p1211 then
            v_u_1138 = nil
        end
    end
    updateManualIndicators()
end
local function v_u_1220(p1216, p1217, p1218)
    -- upvalues: (copy) v_u_1136
    if not manualCallbackSuppress[p1216] then
        if p1217 == "Hold" then
            if p1218 == "press" then
                if manualsEnabled then
                    setManualActive(p1216, true)
                end
            end
            if p1218 == "release" then
                setManualActive(p1216, false)
                return
            end
        else
            local v1219 = not v_u_1136[p1216]
            if v1219 and not manualsEnabled then
                forceKeybindState(p1216, false)
                return
            end
            setManualActive(p1216, v1219)
        end
    end
end
local function v1223(p1221, p1222)
    if not manualMobileButtons[p1221] and manualKeybindHandles[p1221] then
        manualMobileButtons[p1221] = window:_createMobileButton({
            ["keybindHandle"] = manualKeybindHandles[p1221],
            ["configKey"] = (manualKeybindHandles[p1221]._configId or p1221) .. "_Mobile",
            ["text"] = p1222 or p1221
        })
        if manualMobileButtons[p1221] then
            manualMobileButtons[p1221]:SetVisible(manualsEnabled)
        end
    end
end
local v_u_1224 = false
local v_u_1225 = 80
local v_u_1226 = 1
local v_u_1227 = nil
local v_u_1228 = nil
local v_u_1229 = nil
local function v_u_1239()
    -- upvalues: (ref) v_u_1227, (ref) v_u_1228, (ref) v_u_1229
    if v_u_1227 and v_u_1227.Parent then
        return
    else
        local v1230 = Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui", 5)
        if v1230 then
            local v1231 = v1230:FindFirstChild("ManualIndicators")
            if v1231 then
                v_u_1227 = v1231
            else
                local v1232 = Instance.new("ScreenGui")
                v1232.Name = "ManualIndicators"
                v1232.ResetOnSpawn = false
                v1232.IgnoreGuiInset = true
                v1232.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                v1232.DisplayOrder = 1005
                v1232.Parent = v1230
                v_u_1227 = v1232
            end
            local function v1238(p1233, p1234)
                -- upvalues: (ref) v_u_1227
                local v1235 = v_u_1227:FindFirstChild(p1233)
                if v1235 and v1235:IsA("TextLabel") then
                    v1235.Text = p1234
                    return v1235
                end
                local v1236 = Instance.new("TextLabel")
                v1236.Name = p1233
                v1236.BackgroundTransparency = 1
                v1236.Text = p1234
                v1236.Font = Enum.Font.GothamBold
                v1236.TextColor3 = Color3.new(1, 1, 1)
                v1236.TextStrokeTransparency = 0.75
                v1236.TextScaled = true
                v1236.Size = UDim2.fromOffset(28, 28)
                v1236.AnchorPoint = Vector2.new(0.5, 0.5)
                v1236.Visible = false
                v1236.Parent = v_u_1227
                local v1237 = Instance.new("UITextSizeConstraint")
                v1237.MaxTextSize = 28
                v1237.Parent = v1236
                return v1236
            end
            v_u_1228 = v1238("Left", "<")
            v_u_1229 = v1238("Right", ">")
        end
    end
end
function updateManualIndicators()
    -- upvalues: (copy) v_u_1239, (ref) v_u_1228, (ref) v_u_1229, (ref) v_u_1226, (ref) v_u_1225, (ref) v_u_1224, (ref) v_u_1138
    v_u_1239()
    if v_u_1228 and v_u_1229 then
        local v1240 = v_u_1226 * 28
        v_u_1228.Size = UDim2.fromOffset(v1240, v1240)
        v_u_1229.Size = UDim2.fromOffset(v1240, v1240)
        local v1241 = v_u_1228:FindFirstChildOfClass("UITextSizeConstraint")
        if v1241 then
            v1241.MaxTextSize = v1240
        end
        local v1242 = v_u_1229:FindFirstChildOfClass("UITextSizeConstraint")
        if v1242 then
            v1242.MaxTextSize = v1240
        end
        local v1243 = v_u_1225
        v_u_1228.Position = UDim2.new(0.5, -math.abs(v1243), 0.5, 0)
        local v1244 = v_u_1225
        v_u_1229.Position = UDim2.new(0.5, math.abs(v1244), 0.5, 0)
        local v1245 = v_u_1224
        if v1245 then
            v1245 = manualsEnabled
        end
        local v1246 = v_u_1228
        local v1247
        if v1245 then
            v1247 = v_u_1138 == "Left"
        else
            v1247 = v1245
        end
        v1246.Visible = v1247
        local v1248 = v_u_1229
        if v1245 then
            v1245 = v_u_1138 == "Right"
        end
        v1248.Visible = v1245
    end
end
AntiAimPage:AddDropdown("Yaw Base", { "Local view", "At targets" }, "Local view", function(p1249)
    currentYawBase = p1249 or "Local view"
    resetSpinAngle()
    ensureYawLoop()
end)
AntiAimPage:AddDropdown("Yaw Mode", { "Static", "Spin", "Sway" }, "Static", function(p1250)
    currentYawMode = p1250 or "Static"
    if currentYawMode == "Spin" then
        resetSpinAngle()
    elseif currentYawMode == "Sway" then
        swayCurrentYaw = 0
        swayDirection = 1
    end
    ensureYawLoop()
end)
AntiAimPage:AddSlider("Yaw Value", 0, -180, 180, 1, function(p1251)
    local v1252 = tonumber(p1251) or 0
    currentYawValue = math.clamp(v1252, -180, 180)
end)
local v1253 = AntiAimPage:AddSettingsGroup("Yaw settings")
v1253:AddSlider("Min Yaw", swayMinYaw, -180, 180, 1, function(p1254)
    local v1255 = tonumber(p1254) or -60
    swayMinYaw = math.clamp(v1255, -180, 180)
    if swayMinYaw > swayMaxYaw then
        swayMinYaw = swayMaxYaw
    end
end)
v1253:AddSlider("Max Yaw", swayMaxYaw, -180, 180, 1, function(p1256)
    local v1257 = tonumber(p1256) or 60
    swayMaxYaw = math.clamp(v1257, -180, 180)
    if swayMaxYaw < swayMinYaw then
        swayMaxYaw = swayMinYaw
    end
end)
v1253:AddSlider("Sway Speed", swaySpeed, 0.1, 10, 0.1, function(p1258)
    local v1259 = tonumber(p1258) or 1
    swaySpeed = math.clamp(v1259, 0.1, 10)
end)
AntiAimPage:AddDropdown("Yaw Jitter", {
    "Off",
    "Offset",
    "Random",
    "Center",
    "3-Way",
    "5-Way"
}, "Off", function(p1260)
    currentJitterMode = p1260 or "Off"
    resetJitterState()
    sendYawJitterUpdate()
end)
v1253:AddSlider("Jitter Delay", jitterDelay, 0.005, 1, 0.005, function(p1261)
    local v1262 = tonumber(p1261) or 0.05
    jitterDelay = math.clamp(v1262, 0.005, 1)
    if currentJitterMode ~= "Off" then
        sendYawJitterUpdate()
    end
end)
v1253:AddSlider("Jitter Randomness", jitterRandomness, 0, 1, 0.01, function(p1263)
    local v1264 = tonumber(p1263) or 0
    jitterRandomness = math.clamp(v1264, 0, 1)
    if currentJitterMode ~= "Off" then
        sendYawJitterUpdate()
    end
end)
v1253:AddSlider("Left Yaw", currentJitterLeft, -180, 180, 1, function(p1265)
    local v1266 = tonumber(p1265) or -30
    currentJitterLeft = math.clamp(v1266, -180, 180)
    if currentJitterMode ~= "Off" then
        sendYawJitterUpdate()
    end
end)
v1253:AddSlider("Right Yaw", currentJitterRight, -180, 180, 1, function(p1267)
    local v1268 = tonumber(p1267) or 30
    currentJitterRight = math.clamp(v1268, -180, 180)
    if currentJitterMode ~= "Off" then
        sendYawJitterUpdate()
    end
end)
AntiAimPage:AddSlider("Jitter Value", 30, -180, 180, 1, function(p1269)
    local v1270 = tonumber(p1269) or 0
    currentJitterValue = math.clamp(v1270, -180, 180)
    local v1271 = currentJitterValue
    currentJitterLeft = -math.abs(v1271)
    local v1272 = currentJitterValue
    currentJitterRight = math.abs(v1272)
    if currentJitterMode ~= "Off" then
        sendYawJitterUpdate()
    end
end)
local v_u_1273 = "Off"
local v_u_1274 = 0
local v_u_1275 = nil
local v_u_1276 = 0
local v_u_1277 = nil
local v_u_1278 = 1
AntiAimPage:AddDropdown("Body Yaw", { "Off", "Static", "Opposite" }, "Off", function(p1279)
    -- upvalues: (ref) v_u_1273, (ref) v_u_1276, (ref) v_u_1278, (ref) v_u_1277, (ref) v_u_1275, (ref) v_u_1274
    v_u_1273 = p1279 or "Off"
    if v_u_1273 == "Opposite" or v_u_1273 == "Static" then
        local v1280 = Player.Character
        if v1280 then
            v1280 = Player.Character:FindFirstChild("HumanoidRootPart")
        end
        if v1280 then
            local _, v1281, _ = v1280.CFrame:ToOrientation()
            v_u_1276 = math.deg(v1281)
            v_u_1278 = 1
        end
        v_u_1277 = nil
    else
        v_u_1277 = 0
        if not AAHandler then
            AAHandler = require(ReplicatedFirst:WaitForChild("AAHandler"))
        end
        if AAHandler and AAHandler.SendBodyYaw then
            AAHandler:SendBodyYaw(0)
        end
    end
    if v_u_1275 then
        v_u_1275:Disconnect()
        v_u_1275 = nil
    end
    if v_u_1273 ~= "Off" then
        v_u_1275 = RunService.Heartbeat:Connect(function(p1282)
            -- upvalues: (ref) v_u_1273, (ref) v_u_1276, (ref) v_u_1274, (ref) v_u_1278, (ref) v_u_1277
            local v_u_1283 = Player.Character
            if v_u_1283 then
                v_u_1283 = Player.Character:FindFirstChild("HumanoidRootPart")
            end
            if not v_u_1283 then
                return
            end
            local v_u_1284 = v_u_1283.CFrame
            local _, v1285, _ = v_u_1284:ToOrientation()
            local v1286 = math.deg(v1285)
            if v_u_1273 == "Static" then
                local v1287 = v1286 - v_u_1274
                while v1287 > 180 do
                    v1287 = v1287 - 360
                end
                while v1287 < -180 do
                    v1287 = v1287 + 360
                end
                v_u_1276 = v1287
            elseif v_u_1273 == "Opposite" then
                local v1288 = nil
                local v1289
                if targetPosValue and targetPosValue.Value then
                    v1289 = targetPosValue.Value
                    if typeof(v1289) == "Vector3" then
                        if (v1289 - ZERO_VECTOR).Magnitude <= 0.001 then
                            v1289 = v1288
                        end
                    else
                        v1289 = v1288
                    end
                else
                    v1289 = v1288
                end
                if v1289 then
                    local v1290 = v_u_1283.Position + Vector3.new(0, 1.5, 0)
                    local v1291 = v1286 - 80
                    while v1291 > 180 do
                        v1291 = v1291 - 360
                    end
                    while v1291 < -180 do
                        v1291 = v1291 + 360
                    end
                    local v1292 = v1286 + 80
                    while v1292 > 180 do
                        v1292 = v1292 - 360
                    end
                    while v1292 < -180 do
                        v1292 = v1292 + 360
                    end
                    local v1293 = math.rad(v1291)
                    local v1294 = math.rad(v1292)
                    local _ = v1290 - v1289
                    local _ = v1290 - v1289
                    local _ = v1290 - v1289
                    local v1295 = math.rad(v1286)
                    local v1296 = math.sin(v1295)
                    local v1297 = math.rad(v1286)
                    local v1298 = math.cos(v1297)
                    local v1299 = Vector3.new(v1296, 0, v1298)
                    local v1300 = math.sin(v1293)
                    local v1301 = math.cos(v1293)
                    local v1302 = Vector3.new(v1300, 0, v1301)
                    local v1303 = math.sin(v1294)
                    local v1304 = math.cos(v1294)
                    local v1305 = Vector3.new(v1303, 0, v1304)
                    local v1306 = v1299.X
                    local v1307 = v1299.Z
                    local v1308 = math.atan2(v1306, v1307)
                    local v1309 = math.deg(v1308)
                    local v1310 = v1302.X
                    local v1311 = v1302.Z
                    local v1312 = math.atan2(v1310, v1311)
                    local v1313 = math.deg(v1312)
                    local v1314 = v1305.X
                    local v1315 = v1305.Z
                    local v1316 = math.atan2(v1314, v1315)
                    local v1317 = math.deg(v1316)
                    local v1318 = v1309 - v1313
                    while v1318 > 180 do
                        v1318 = v1318 - 360
                    end
                    while v1318 < -180 do
                        v1318 = v1318 + 360
                    end
                    local v1319 = math.abs(v1318)
                    local v1320 = v1309 - v1317
                    while v1320 > 180 do
                        v1320 = v1320 - 360
                    end
                    while v1320 < -180 do
                        v1320 = v1320 + 360
                    end
                    local v1321 = math.abs(v1320)
                    local v1322 = (v1290 - v1289).Unit
                    local v1323 = v1302:Dot(v1322)
                    local v1324 = v1305:Dot(v1322)
                    local v1325
                    if v1321 < v1319 then
                        v1325 = true
                    elseif v1319 == v1321 then
                        v1325 = v1323 < v1324
                    else
                        v1325 = false
                    end
                    if v1325 then
                        v_u_1276 = v1291
                    else
                        v_u_1276 = v1292
                    end
                    local v1326 = v1286 - v_u_1276
                    while v1326 > 180 do
                        v1326 = v1326 - 360
                    end
                    while v1326 < -180 do
                        v1326 = v1326 + 360
                    end
                    v_u_1278 = v1326 >= 0 and 1 or -1
                else
                    local v1327 = v1286 - v_u_1276
                    while v1327 > 180 do
                        v1327 = v1327 - 360
                    end
                    while v1327 < -180 do
                        v1327 = v1327 + 360
                    end
                    math.abs(v1327)
                    local v1328 = v1286 - v_u_1276
                    while v1328 > 180 do
                        v1328 = v1328 - 360
                    end
                    while v1328 < -180 do
                        v1328 = v1328 + 360
                    end
                    if math.abs(v1328) > 1 then
                        v_u_1278 = v1328 >= 0 and 1 or -1
                    end
                    local v1329 = v1286 - v_u_1278 * 80
                    while v1329 > 180 do
                        v1329 = v1329 - 360
                    end
                    while v1329 < -180 do
                        v1329 = v1329 + 360
                    end
                    local v1330 = (p1282 or 0.016) * 180
                    local v1331 = math.max(1, v1330)
                    local v1332 = v_u_1276
                    local v1333 = v1329 - v1332
                    while v1333 > 180 do
                        v1333 = v1333 - 360
                    end
                    while v1333 < -180 do
                        v1333 = v1333 + 360
                    end
                    if math.abs(v1333) > v1331 then
                        if v1333 > 0 then
                            v1329 = v1332 + v1331
                            while v1329 > 180 do
                                v1329 = v1329 - 360
                            end
                            while v1329 < -180 do
                                v1329 = v1329 + 360
                            end
                        else
                            v1329 = v1332 - v1331
                            while v1329 > 180 do
                                v1329 = v1329 - 360
                            end
                            while v1329 < -180 do
                                v1329 = v1329 + 360
                            end
                        end
                    end
                    v_u_1276 = v1329
                end
            end
            if v_u_1273 == "Off" then
                v_u_1277 = nil
                goto l114
            end
            local v1334 = Player:FindFirstChild("DoubleTapping")
            if v1334 then
                v1334 = v1334.Value
            end
            local v1335 = v1286 - v_u_1276
            while v1335 > 180 do
                v1335 = v1335 - 360
            end
            while v1335 < -180 do
                v1335 = v1335 + 360
            end
            local v1336 = math.clamp(v1335, -80, 80)
            if v_u_1277 ~= nil then
                local v1337 = v_u_1277 - v1336
                if math.abs(v1337) <= 0.1 then
                    ::l108::
                    if not v1334 then
                        local v1338 = v_u_1284.Position
                        local v_u_1339 = v_u_1283.AssemblyLinearVelocity
                        local v1340 = v_u_1276
                        local v1341 = math.rad(v1340)
                        v_u_1283.CFrame = CFrame.new(v1338) * CFrame.Angles(0, v1341, 0)
                        v_u_1283.AssemblyLinearVelocity = v_u_1339
                        if visualizeFakePosEnabled and fakePosStepFunc then
                            fakePosStepFunc()
                        end
                        task.spawn(function()
                            -- upvalues: (copy) v_u_1283, (copy) v_u_1284, (copy) v_u_1339
                            RunService.RenderStepped:Wait()
                            if v_u_1283 and v_u_1283.Parent then
                                v_u_1283.CFrame = v_u_1284
                                v_u_1283.AssemblyLinearVelocity = v_u_1339
                            end
                        end)
                        return
                    end
                    ::l114::
                    return
                end
            end
            v_u_1277 = v1336
            if not AAHandler then
                AAHandler = require(ReplicatedFirst:WaitForChild("AAHandler"))
            end
            if AAHandler and AAHandler.SendBodyYaw then
                AAHandler:SendBodyYaw(v1336)
            end
            goto l108
        end)
    end
end)
AntiAimPage:AddSlider("Body Yaw Value", 0, -80, 80, 1, function(p1342)
    -- upvalues: (ref) v_u_1274
    local v1343 = tonumber(p1342) or 0
    v_u_1274 = math.clamp(v1343, -80, 80)
end)
local v1347 = AntiAimPage:AddToggle("Manuals", false, function(p1344)
    -- upvalues: (copy) v_u_1136, (ref) v_u_1138
    manualsEnabled = p1344 and true or false
    if not manualsEnabled then
        for v1345, v1346 in pairs(v_u_1136) do
            if v1346 then
                setManualActive(v1345, false, {
                    ["skipForce"] = true
                })
                forceKeybindState(v1345, false)
            end
        end
        v_u_1138 = nil
    end
    updateManualMobileVisibility()
    updateManualIndicators()
end):AddSettings()
v1347:AddToggle("Show indicators", false, function(p1348)
    -- upvalues: (ref) v_u_1224
    v_u_1224 = p1348 and true or false
    updateManualIndicators()
end)
v1347:AddSlider("Indicators offset", v_u_1225, 0, 300, 1, function(p1349)
    -- upvalues: (ref) v_u_1225
    local v1350 = tonumber(p1349) or 80
    v_u_1225 = math.clamp(v1350, 0, 300)
    updateManualIndicators()
end)
v1347:AddSlider("Indicators scale", v_u_1226, 0.1, 5, 0.1, function(p1351)
    -- upvalues: (ref) v_u_1226
    local v1352 = tonumber(p1351) or 1
    v_u_1226 = math.clamp(v1352, 0.1, 5)
    updateManualIndicators()
end)
manualKeybindHandles.Left = v1347:AddKeybind("Left", Enum.KeyCode.X, "Toggle", function(_, p1353, p1354)
    -- upvalues: (copy) v_u_1220
    v_u_1220("Left", p1353, p1354)
end, {
    ["condition"] = function()
        if manualCallbackSuppress.Left then
            return false
        else
            return manualsEnabled and true or false
        end
    end,
    ["ignore_list"] = true
})
v1223("Left", "Yaw L")
manualKeybindHandles.Right = v1347:AddKeybind("Right", Enum.KeyCode.C, "Toggle", function(_, p1355, p1356)
    -- upvalues: (copy) v_u_1220
    v_u_1220("Right", p1355, p1356)
end, {
    ["condition"] = function()
        if manualCallbackSuppress.Right then
            return false
        else
            return manualsEnabled and true or false
        end
    end,
    ["ignore_list"] = true
})
v1223("Right", "Yaw R")
refreshHumanoidReference()
setAutoRotateEnabled(currentYawMode == "Off")
task.defer(ensureYawLoop)
task.defer(updateManualMobileVisibility)
Player.CharacterAdded:Connect(function(p_u_1357)
    -- upvalues: (ref) v_u_1273, (ref) v_u_1276, (ref) v_u_1275, (ref) v_u_1274, (ref) v_u_1278, (ref) v_u_1277, (copy) v_u_437
    task.spawn(function()
        -- upvalues: (copy) p_u_1357, (ref) v_u_1273, (ref) v_u_1276, (ref) v_u_1275, (ref) v_u_1274, (ref) v_u_1278, (ref) v_u_1277
        if p_u_1357 then
            p_u_1357:WaitForChild("Humanoid", 5)
        end
        refreshHumanoidReference()
        setAutoRotateEnabled(currentYawMode == "Off")
        if v_u_1273 == "Opposite" then
            task.wait(0.1)
            local v1358 = p_u_1357:FindFirstChild("HumanoidRootPart")
            if v1358 then
                local _, v1359, _ = v1358.CFrame:ToOrientation()
                v_u_1276 = math.deg(v1359)
            end
            if v_u_1275 then
                v_u_1275:Disconnect()
                v_u_1275 = nil
            end
            if v_u_1273 == "Off" then
                return
            end
            v_u_1275 = RunService.Heartbeat:Connect(function(p1360)
                -- upvalues: (ref) v_u_1273, (ref) v_u_1276, (ref) v_u_1274, (ref) v_u_1278, (ref) v_u_1277
                local v_u_1361 = Player.Character
                if v_u_1361 then
                    v_u_1361 = Player.Character:FindFirstChild("HumanoidRootPart")
                end
                if not v_u_1361 then
                    return
                end
                local v_u_1362 = v_u_1361.CFrame
                local _, v1363, _ = v_u_1362:ToOrientation()
                local v1364 = math.deg(v1363)
                if v_u_1273 == "Static" then
                    local v1365 = v1364 - v_u_1274
                    while v1365 > 180 do
                        v1365 = v1365 - 360
                    end
                    while v1365 < -180 do
                        v1365 = v1365 + 360
                    end
                    v_u_1276 = v1365
                elseif v_u_1273 == "Opposite" then
                    local v1366 = nil
                    local v1367
                    if targetPosValue and targetPosValue.Value then
                        v1367 = targetPosValue.Value
                        if typeof(v1367) == "Vector3" then
                            if (v1367 - ZERO_VECTOR).Magnitude <= 0.001 then
                                v1367 = v1366
                            end
                        else
                            v1367 = v1366
                        end
                    else
                        v1367 = v1366
                    end
                    if v1367 then
                        local v1368 = v_u_1361.Position + Vector3.new(0, 1.5, 0)
                        local v1369 = v1364 - 80
                        while v1369 > 180 do
                            v1369 = v1369 - 360
                        end
                        while v1369 < -180 do
                            v1369 = v1369 + 360
                        end
                        local v1370 = v1364 + 80
                        while v1370 > 180 do
                            v1370 = v1370 - 360
                        end
                        while v1370 < -180 do
                            v1370 = v1370 + 360
                        end
                        local v1371 = math.rad(v1369)
                        local v1372 = math.rad(v1370)
                        local _ = v1368 - v1367
                        local _ = v1368 - v1367
                        local _ = v1368 - v1367
                        local v1373 = math.rad(v1364)
                        local v1374 = math.sin(v1373)
                        local v1375 = math.rad(v1364)
                        local v1376 = math.cos(v1375)
                        local v1377 = Vector3.new(v1374, 0, v1376)
                        local v1378 = math.sin(v1371)
                        local v1379 = math.cos(v1371)
                        local v1380 = Vector3.new(v1378, 0, v1379)
                        local v1381 = math.sin(v1372)
                        local v1382 = math.cos(v1372)
                        local v1383 = Vector3.new(v1381, 0, v1382)
                        local v1384 = v1377.X
                        local v1385 = v1377.Z
                        local v1386 = math.atan2(v1384, v1385)
                        local v1387 = math.deg(v1386)
                        local v1388 = v1380.X
                        local v1389 = v1380.Z
                        local v1390 = math.atan2(v1388, v1389)
                        local v1391 = math.deg(v1390)
                        local v1392 = v1383.X
                        local v1393 = v1383.Z
                        local v1394 = math.atan2(v1392, v1393)
                        local v1395 = math.deg(v1394)
                        local v1396 = v1387 - v1391
                        while v1396 > 180 do
                            v1396 = v1396 - 360
                        end
                        while v1396 < -180 do
                            v1396 = v1396 + 360
                        end
                        local v1397 = math.abs(v1396)
                        local v1398 = v1387 - v1395
                        while v1398 > 180 do
                            v1398 = v1398 - 360
                        end
                        while v1398 < -180 do
                            v1398 = v1398 + 360
                        end
                        local v1399 = math.abs(v1398)
                        local v1400 = (v1368 - v1367).Unit
                        local v1401 = v1380:Dot(v1400)
                        local v1402 = v1383:Dot(v1400)
                        local v1403
                        if v1399 < v1397 then
                            v1403 = true
                        elseif v1397 == v1399 then
                            v1403 = v1401 < v1402
                        else
                            v1403 = false
                        end
                        if v1403 then
                            v_u_1276 = v1369
                        else
                            v_u_1276 = v1370
                        end
                        local v1404 = v1364 - v_u_1276
                        while v1404 > 180 do
                            v1404 = v1404 - 360
                        end
                        while v1404 < -180 do
                            v1404 = v1404 + 360
                        end
                        v_u_1278 = v1404 >= 0 and 1 or -1
                    else
                        local v1405 = v1364 - v_u_1276
                        while v1405 > 180 do
                            v1405 = v1405 - 360
                        end
                        while v1405 < -180 do
                            v1405 = v1405 + 360
                        end
                        math.abs(v1405)
                        local v1406 = v1364 - v_u_1276
                        while v1406 > 180 do
                            v1406 = v1406 - 360
                        end
                        while v1406 < -180 do
                            v1406 = v1406 + 360
                        end
                        if math.abs(v1406) > 1 then
                            v_u_1278 = v1406 >= 0 and 1 or -1
                        end
                        local v1407 = v1364 - v_u_1278 * 80
                        while v1407 > 180 do
                            v1407 = v1407 - 360
                        end
                        while v1407 < -180 do
                            v1407 = v1407 + 360
                        end
                        local v1408 = (p1360 or 0.016) * 180
                        local v1409 = math.max(1, v1408)
                        local v1410 = v_u_1276
                        local v1411 = v1407 - v1410
                        while v1411 > 180 do
                            v1411 = v1411 - 360
                        end
                        while v1411 < -180 do
                            v1411 = v1411 + 360
                        end
                        if math.abs(v1411) > v1409 then
                            if v1411 > 0 then
                                v1407 = v1410 + v1409
                                while v1407 > 180 do
                                    v1407 = v1407 - 360
                                end
                                while v1407 < -180 do
                                    v1407 = v1407 + 360
                                end
                            else
                                v1407 = v1410 - v1409
                                while v1407 > 180 do
                                    v1407 = v1407 - 360
                                end
                                while v1407 < -180 do
                                    v1407 = v1407 + 360
                                end
                            end
                        end
                        v_u_1276 = v1407
                    end
                end
                if v_u_1273 == "Off" then
                    v_u_1277 = nil
                    goto l114
                end
                local v1412 = Player:FindFirstChild("DoubleTapping")
                if v1412 then
                    v1412 = v1412.Value
                end
                local v1413 = v1364 - v_u_1276
                while v1413 > 180 do
                    v1413 = v1413 - 360
                end
                while v1413 < -180 do
                    v1413 = v1413 + 360
                end
                local v1414 = math.clamp(v1413, -80, 80)
                if v_u_1277 ~= nil then
                    local v1415 = v_u_1277 - v1414
                    if math.abs(v1415) <= 0.1 then
                        ::l108::
                        if not v1412 then
                            local v1416 = v_u_1362.Position
                            local v_u_1417 = v_u_1361.AssemblyLinearVelocity
                            local v1418 = v_u_1276
                            local v1419 = math.rad(v1418)
                            v_u_1361.CFrame = CFrame.new(v1416) * CFrame.Angles(0, v1419, 0)
                            v_u_1361.AssemblyLinearVelocity = v_u_1417
                            if visualizeFakePosEnabled and fakePosStepFunc then
                                fakePosStepFunc()
                            end
                            task.spawn(function()
                                -- upvalues: (copy) v_u_1361, (copy) v_u_1362, (copy) v_u_1417
                                RunService.RenderStepped:Wait()
                                if v_u_1361 and v_u_1361.Parent then
                                    v_u_1361.CFrame = v_u_1362
                                    v_u_1361.AssemblyLinearVelocity = v_u_1417
                                end
                            end)
                            return
                        end
                        ::l114::
                        return
                    end
                end
                v_u_1277 = v1414
                if not AAHandler then
                    AAHandler = require(ReplicatedFirst:WaitForChild("AAHandler"))
                end
                if AAHandler and AAHandler.SendBodyYaw then
                    AAHandler:SendBodyYaw(v1414)
                end
                goto l108
            end)
        end
    end)
    task.wait(0.3)
    pcall(function()
        if ensureCharacterValues then
            ensureCharacterValues()
        end
    end)
    task.wait(0.5)
    for v1420, v1421 in pairs(auraStates) do
        if v1421 then
            applyAura(v1420)
        end
    end
    if forceFieldEnabled then
        task.wait(0.1)
        saveOriginalAppearance()
        applyForceField()
    end
    if localPlayerEnabled then
        task.wait(0.1)
        saveOriginalAppearance()
        applyLocalPlayerVisuals()
    end
    task.wait(1.2)
    v_u_437()
    ensureFakePosClone()
    ensurePitchLoop()
    ensureYawLoop()
    updateManualIndicators()
end)
Player.CharacterRemoving:Connect(function()
    -- upvalues: (copy) v_u_508
    v_u_508()
end)
rageAimEnabled = false
autoShootEnabled = false
function ensureCharacterValues()
    if Player.Character then
        local v1422 = Player.Character
        if rageAimEnabled then
            local v1423 = v1422:FindFirstChild("rageaim")
            if not v1423 then
                v1423 = Instance.new("BoolValue")
                v1423.Name = "rageaim"
                v1423.Parent = v1422
            end
            v1423.Value = true
        else
            local v1424 = v1422:FindFirstChild("rageaim")
            if v1424 then
                v1424:Destroy()
            end
        end
        if autoShootEnabled then
            local v1425 = v1422:FindFirstChild("autoshoot")
            if not v1425 then
                v1425 = Instance.new("BoolValue")
                v1425.Name = "autoshoot"
                v1425.Parent = v1422
            end
            v1425.Value = true
        else
            local v1426 = v1422:FindFirstChild("autoshoot")
            if v1426 then
                v1426:Destroy()
            end
        end
        local v1427 = v1422:FindFirstChild("aimMode")
        if not v1427 then
            v1427 = Instance.new("StringValue")
            v1427.Name = "aimMode"
            v1427.Parent = v1422
        end
        v1427.Value = "closest to plr"
    end
end
v_u_437()
ensureCharacterValues()
local v_u_1428 = game:GetService("UserInputService")
local function v1429()
    -- upvalues: (copy) v_u_1428
    v_u_1428.MouseIcon = "rbxassetid://7051824015"
end
v1429()
v_u_1428:GetPropertyChangedSignal("MouseBehavior"):Connect(v1429)
task.spawn(function()
    while script and script.Parent do
        local v1430 = Player:FindFirstChild("PlayerScripts")
        if not v1430 then
            script:Destroy()
            return
        end
        local v1431 = v1430:FindFirstChild(":3")
        if not v1431 then
            script:Destroy()
            return
        end
        if v1431:IsA("LocalScript") and v1431.Enabled == false then
            script:Destroy()
            return
        end
        task.wait(0.5)
    end
end)
