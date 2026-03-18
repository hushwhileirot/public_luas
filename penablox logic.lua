-- Decompiled with Medal in Seliware
-- Cleaned and Formatted 

(function()
    local ShopAssistantLoader = require(game:GetService("ReplicatedStorage"):WaitForChild("ShopAssistant"))

    --@region: SCRIPT_1_ANTICHEAT
    local script1_source = [=[
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local v14 = {
    PartRemoveProtect = { enabled = false },
    PartRenameProtect = { enabled = true },
    HitboxProtect = {
        enabled = true,
        partsSizes = {
            HumanoidRootPart = Vector3.new(2, 2, 1),
            Head = Vector3.new(2, 1, 1),
            Torso = Vector3.new(1.5, 2, 1),
        },
        sizeTolerance = 0,
    },
    WalkspeedProtect = { enabled = true, maxWalkSpeed = 16 },
    HipHeightProtect = { enabled = true, maxAbsHipHeight = 1e-4 },
    PlatformStandProtect = { enabled = true },
    FlyProtect = {
        enabled = false,
        verticalLinear = { windowSec = 1.0, sampleStepSec = 0.1, yRangeThreshold = 100 },
    },
    GravityProtect = { enabled = true, expected = 196.2, tolerance = 0.2 },
    NoClipProtect = { enabled = true, requiredConfirmations = 30 },
    CFrameMonitor = { enabled = true, speedThreshold = 45, requiredSeconds = 0.5, printIntervalSec = 0.25, respawnGraceSec = 2, loopIntervalSec = 0.1 },
    TeleportDetect = { enabled = true, horizontalJumpThreshold = 20, timeWindow = 5, maxJumpsInWindow = 3 },
}

local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
local v15 = {}
local v16 = { "BulletHole", "BulletHoleFlesh", "Tracer", "Bullet", "Handle", "HumanoidRootPart", "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Ignored" }
local v5 = 0
local v17 = { lastPosition = nil, lastTime = tick(), gracePeriodEnd = 0, yWindowStartY = nil, yWindowStartT = nil, ffSamples = {}, ffGroundTimes = {} }
local v18 = {}
local SPEED_THRESHOLD = v14.CFrameMonitor.speedThreshold
local SUSPICIOUS_REQUIRED_SEC = v14.CFrameMonitor.requiredSeconds
local PRINT_INTERVAL_SEC = v14.CFrameMonitor.printIntervalSec
local v6 = 0
local v7 = 0
local v1 = false

local function sendKick(reason)
    game:GetService("ReplicatedStorage"):WaitForChild("MainEvent").Parent = nil
    local plr = game:GetService("Players").LocalPlayer
    local v8 = 0/0
    print(reason)
    pcall(function() game:GetService("Players").LocalPlayer:Kick(reason) end)
    pcall(function() swimmylove() end)
end

function checkCFrameMovement()
    if not v14.CFrameMonitor.enabled then return false end
    
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return end
    
    local character = localPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if v1 then
        v17.lastPosition = humanoidRootPart.Position
        v17.lastTime = tick()
        v6 = 0
        v18 = {}
        return false
    end
    
    local now = tick()
    local dt = math.max(now - v17.lastTime, 1/240)
    local currentPosition = humanoidRootPart.Position
    local ignoreTP = character:FindFirstChild("IgnoreTP")
    local shouldIgnoreTeleport = ignoreTP and ignoreTP.Value == true
    
    if now >= v17.gracePeriodEnd and v17.lastPosition then
        local displacement = (currentPosition - v17.lastPosition)
        local horizontalDisplacement = Vector3.new(displacement.X, 0, displacement.Z)
        local horizontalDistance = horizontalDisplacement.Magnitude
        local horizontalSpeed = horizontalDistance / dt
        
        if v14.TeleportDetect.enabled and not shouldIgnoreTeleport then
            local jumpThreshold = v14.TeleportDetect.horizontalJumpThreshold or 20
            local timeWindow = v14.TeleportDetect.timeWindow or 5
            local maxJumps = v14.TeleportDetect.maxJumpsInWindow or 3
            
            if horizontalDistance > jumpThreshold and dt < 0.5 then
                table.insert(v18, { timestamp = now, distance = horizontalDistance })
                local v19 = {}
                for _, jump in ipairs(v18) do
                    if now - jump.timestamp <= timeWindow then
                        table.insert(v19, jump)
                    end
                end
                v18 = v19
                if #v18 > maxJumps then
                    sendKick("T d: " .. #v18 .. " j i " .. timeWindow .. "s")
                    return true
                end
            end
        end
        
        if v14.FlyProtect.enabled and v14.FlyProtect.verticalLinear then
            local win = v14.FlyProtect.verticalLinear.windowSec or 1.0
            local yThr = v14.FlyProtect.verticalLinear.yRangeThreshold or 5
            local humState = humanoid and humanoid:GetState()
            
            if humState ~= Enum.HumanoidStateType.Freefall then
                table.insert(v17.ffGroundTimes, now)
            else
                table.insert(v17.ffSamples, { t = now, y = currentPosition.Y })
            end
            
            local function prune(list)
                local v20 = {}
                if type(list) ~= "table" then return v20 end
                for _, s in ipairs(list) do
                    local stamp
                    if type(s) == "table" then stamp = s.t
                    elseif type(s) == "number" then stamp = s end
                    if stamp and (now - stamp) <= win then
                        table.insert(v20, s)
                    end
                end
                return v20
            end
            
            v17.ffSamples = prune(v17.ffSamples)
            v17.ffGroundTimes = prune(v17.ffGroundTimes)
            
            if #v17.ffSamples >= 2 then
                local firstT = v17.ffSamples[1].t or now
                local lastT = v17.ffSamples[#v17.ffSamples].t or now
                if (lastT - firstT) >= (win - 1e-2) then
                    local minY, maxY = math.huge, -math.huge
                    for _, s in ipairs(v17.ffSamples) do
                        local y = s.y or 0
                        if y < minY then minY = y end
                        if y > maxY then maxY = y end
                    end
                    local diff = (maxY - minY)
                    if #v17.ffGroundTimes == 0 and diff < yThr then
                        print("Float")
                        return true
                    end
                    v17.ffSamples = { v17.ffSamples[#v17.ffSamples] }
                    v17.ffGroundTimes = {}
                end
            end
        end
        
        if horizontalSpeed > SPEED_THRESHOLD then
            v6 = math.min(SUSPICIOUS_REQUIRED_SEC, v6 + dt)
        else
            v6 = math.max(0, v6 - dt * 2)
        end
        
        if now - v7 >= PRINT_INTERVAL_SEC then v7 = now end
        
        if v6 >= SUSPICIOUS_REQUIRED_SEC then
            sendKick("Horizontal speed sustained: " .. math.floor(horizontalSpeed) .. " studs/s")
            return true
        end
    end
    
    v17.lastPosition = currentPosition
    v17.lastTime = now
    return false
end

local function shouldIgnorePart(part)
    for _, name in ipairs(v16) do
        if part.Name == name then return true end
    end
    local parent = part.Parent
    while parent do
        if parent:IsA("Model") then
            if Players:GetPlayerFromCharacter(parent) then return true
            elseif parent:IsA("Tool") then return true end
        end
        parent = parent.Parent
    end
    return false
end

local function getAllParts(parent)
    local v21 = {}
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Part") and not shouldIgnorePart(child) then
            table.insert(v21, child)
        end
        local childParts = getAllParts(child)
        for _, part in ipairs(childParts) do
            table.insert(v21, part)
        end
    end
    return v21
end

function isPartReallyRemoved(part, originalName)
    local v2 = false
    if Workspace:FindFirstChild(originalName) then v2 = true end
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant == part or (descendant.Name == originalName and descendant:IsA("Part")) then
            v2 = true
            break
        end
    end
    
    local function searchInParent(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child == part or (child.Name == originalName and child:IsA("Part")) then return true end
            if child:IsA("Model") or child:IsA("Folder") then
                if searchInParent(child) then return true end
            end
        end
        return false
    end
    
    if searchInParent(Workspace) then v2 = true end
    return not v2
end

function scanAndCheckParts()
    for part, originalData in pairs(v15) do
        if not part.Parent then
            local path = originalData.fullName or originalData.name or "Unknown"
            sendKick("Part removed: " .. path)
            return true
        end
        if part.Name ~= originalData.name then
            local path = originalData.fullName or originalData.name or "Unknown"
            sendKick("Part renamed: " .. path .. " -> " .. part.Name)
            return true
        end
    end
    return false
end

local function checkCharacterSizes()
    local localPlayer = Players.LocalPlayer
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local char = player.Character
            local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            
            if v14.HitboxProtect.enabled then
                local tol = v14.HitboxProtect.sizeTolerance or 0
                local wantHRP = v14.HitboxProtect.partsSizes.HumanoidRootPart
                local wantHead = v14.HitboxProtect.partsSizes.Head
                local wantTorso = v14.HitboxProtect.partsSizes.Torso
                
                local function sizeMismatch(actual, expected)
                    if not actual or not expected then return false end
                    local dx = math.abs(actual.X - expected.X)
                    local dy = math.abs(actual.Y - expected.Y)
                    local dz = math.abs(actual.Z - expected.Z)
                    return dx > tol or dy > tol or dz > tol
                end
                
                if humanoidRootPart and wantHRP and sizeMismatch(humanoidRootPart.Size, wantHRP) then
                    sendKick("Hitbox expander")
                    return true
                end
                if head and wantHead and sizeMismatch(head.Size, wantHead) then
                    sendKick("Hitbox expander")
                    return true
                end
                if torso and wantTorso and sizeMismatch(torso.Size, wantTorso) then
                    sendKick("Hitbox expander")
                    return true
                end
            end
            
            if player == localPlayer then
                local humanoid = char:FindFirstChild("Humanoid")
                local humanoidState = humanoid and humanoid:GetState()
                local isDead = humanoid and (humanoid.Health <= 0 or humanoidState == Enum.HumanoidStateType.Dead)
                
                if humanoidRootPart and v14.FlyProtect.enabled then
                    for _, child in ipairs(humanoidRootPart:GetChildren()) do
                        if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                            sendKick("Fly detected")
                        end
                    end
                end
                
                if not isDead then
                    if v14.WalkspeedProtect.enabled and humanoid and humanoid.WalkSpeed and humanoid.WalkSpeed > v14.WalkspeedProtect.maxWalkSpeed then
                        sendKick("Walkspeed")
                    end
                    if v14.HipHeightProtect.enabled and humanoid and humanoid.HipHeight and math.abs(humanoid.HipHeight) > (v14.HipHeightProtect.maxAbsHipHeight or 0) then
                        sendKick("HipHeight")
                        return true
                    end
                    if v14.PlatformStandProtect.enabled and humanoid and humanoid.PlatformStand == true then
                        sendKick("Platformstand")
                    end
                    
                    local v3 = true
                    local v9 = 0
                    for _, child in ipairs(char:GetChildren()) do
                        if child:IsA("Part") then
                            v9 = v9 + 1
                            if child.CanCollide == true then
                                v3 = false
                                break
                            end
                        end
                    end
                    
                    if v14.NoClipProtect.enabled and v9 > 0 and v3 then
                        v5 = v5 + 1
                        if v5 >= (v14.NoClipProtect.requiredConfirmations or 15) then
                            sendKick("Noclip autodetection")
                        end
                    else
                        v5 = 0
                    end
                else
                    v5 = 0
                end
            end
        end
    end
    return false
end

local function startPartMonitoring()
    if not (v14.PartRemoveProtect.enabled or v14.PartRenameProtect.enabled) then return end
    local allParts = getAllParts(Workspace)
    for _, part in ipairs(allParts) do
        local v4 = true
        local parent = part.Parent
        while parent do
            if parent:IsA("Model") and Players:GetPlayerFromCharacter(parent) then
                v4 = false
                break
            end
            parent = parent.Parent
        end
        if v4 then
            v15[part] = { name = part.Name, fullName = part:GetFullName() }
        end
    end
    
    local v22 = {}
    for part, _ in pairs(v15) do
        table.insert(v22, part)
    end
    
    local v10 = 1
    while true do
        if #v22 > 0 then
            local part = v22[v10]
            local original = v15[part]
            if not part.Parent and v14.PartRemoveProtect.enabled then
                local path = original.fullName or original.name or "Unknown"
                sendKick("Part lost parent: " .. path)
                break
            end
            if original and part.Name ~= original.name and v14.PartRenameProtect.enabled then
                local path = original.fullName or original.name or "Unknown"
                sendKick("Part renamed autodetection: " .. path .. " -> " .. part.Name)
                break
            end
            v10 = v10 + 1
            if v10 > #v22 then
                v10 = 1
                wait(0.1)
            else
                wait(0.01)
            end
        else
            wait(1)
        end
    end
end

local function startSizeMonitoring()
    while true do
        if checkCharacterSizes() then break end
        wait(0.5)
    end
end

local function startCFrameMonitoring()
    while true do
        local localPlayer = Players.LocalPlayer
        local character = localPlayer and localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if v14.GravityProtect and v14.GravityProtect.enabled then
            local exp = v14.GravityProtect.expected or 196.2
            local tol = v14.GravityProtect.tolerance or 0
            local g = Workspace.Gravity
            if math.abs(g - exp) > tol then
                sendKick("Gravity")
                break
            end
        end
        
        if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
            v17.lastPosition = nil
            v17.lastTime = tick()
            wait(0.1)
        else
            if checkCFrameMovement() then break end
            wait(0.1)
        end
    end
end

wait(2.5)

function startDesyncMonitoring()
    local tmpClones = Workspace:FindFirstChild("tmp_clones")
    local v11 = 10
    local v12 = 3
    local v13 = 5
    local v23 = {}
    local v24 = {}
    
    while true do
        tmpClones = tmpClones or Workspace:FindFirstChild("tmp_clones")
        local localPlayer = Players.LocalPlayer
        local now = tick()
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local hasFF = character and character:FindFirstChildOfClass("ForceField") ~= nil
                
                if character and humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead and not hasFF and tmpClones then
                    local playerCloneFolder = tmpClones:FindFirstChild(player.Name)
                    if playerCloneFolder then
                        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                        local cloneTorso = playerCloneFolder:FindFirstChild("Torso")
                        if torso and cloneTorso then
                            local d = (torso.Position - cloneTorso.Position).Magnitude
                            if d > v11 then
                                v23[player] = (v23[player] or 0) + 1
                                v24[player] = v24[player] or {}
                                table.insert(v24[player], now)
                                
                                while #v24[player] > 0 and now - v24[player][1] > v13 do
                                    table.remove(v24[player], 1)
                                    v23[player] = v23[player] - 1
                                end
                                
                                if v23[player] >= v12 then
                                    sendKick(d, v11)
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end

local localPlayer = Players.LocalPlayer
localPlayer.CharacterAdded:Connect(function(character)
    v1 = true
    v17.lastPosition = nil
    v17.lastTime = tick()
    v17.gracePeriodEnd = tick() + 2
    v18 = {}
    character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")
    wait(1)
    v1 = false
end)

coroutine.wrap(startPartMonitoring)()
coroutine.wrap(startSizeMonitoring)()
coroutine.wrap(startCFrameMonitoring)()
]=]

    local v2, v3 = ShopAssistantLoader(script1_source)
    if v2 then
        local v4, v5 = pcall(v2)
        if not v4 then warn("Error in script 1:", v5) end
    else
        warn("Compile error in script 1:", v3)
    end

    --@region: SCRIPT_2_COMBAT_AND_AIMBOT
    local script2_source = [=[
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local PlayerGui = player:WaitForChild("PlayerGui")
local mainEvent = ReplicatedStorage:WaitForChild("MainEvent")
local holesFolder = ReplicatedStorage:WaitForChild("holes")
local shootSound = ReplicatedStorage:WaitForChild("sounds"):WaitForChild("shoot")
local soundsFolder = ReplicatedStorage:WaitForChild("sounds")
local hitSoundsFolder = soundsFolder:WaitForChild("Hit")
local killSoundsFolder = soundsFolder:WaitForChild("Kill")
local DmgConfig = require(ReplicatedStorage:WaitForChild("DmgConfig"))

local autoStopValue = player:FindFirstChild("AutoStop")
if not autoStopValue then
    autoStopValue = Instance.new("BoolValue")
    autoStopValue.Name = "AutoStop"
    autoStopValue.Value = false
    autoStopValue.Parent = player
end

local shouldStopValue = player:FindFirstChild("ShouldStop")
if not shouldStopValue then
    shouldStopValue = Instance.new("BoolValue")
    shouldStopValue.Name = "ShouldStop"
    shouldStopValue.Value = false
    shouldStopValue.Parent = player
end

local ZERO_VECTOR = Vector3.new(0, 0, 0)
local targetPosValue = player:FindFirstChild("TargetPos")
if not targetPosValue then
    targetPosValue = Instance.new("Vector3Value")
    targetPosValue.Name = "TargetPos"
    targetPosValue.Value = ZERO_VECTOR
    targetPosValue.Parent = player
end

local function encryptArgs(...)
    return "secret"
end

local actriggeredEnv = _G
do
    local ok, env = pcall(function()
        local fn = rawget(_G, "getgenv")
        if type(fn) == "function" then return fn() end
        return nil
    end)
    if ok and type(env) == "table" then
        actriggeredEnv = env
    end
end

local v12 = ""
local function updateActTriggered(value)
    v12 = value or ""
    if actriggeredEnv then actriggeredEnv.v12 = v12 end
end
updateActTriggered("")

local function isActTriggered()
    return v12 ~= ""
end

function sendKick(reason)
    game:GetService("ReplicatedStorage"):WaitForChild("MainEvent").Parent = nil
    updateActTriggered(reason or "Unknown")
    local plr = game:GetService("Players").LocalPlayer
    
    for _, item in pairs(plr.StarterPack:GetChildren()) do item.Parent = nil end
    for _, item in pairs(plr.Backpack:GetChildren()) do item.Parent = nil end
    if plr.Character then
        for _, item in pairs(plr.Character:GetChildren()) do item.Parent = nil end
    end
    
    pcall(function() plr:Kick(reason) end)
    pcall(function() swimmylove() end)
    
    coroutine.wrap(function()
        while true do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(
                    math.random(-100000, 100000),
                    math.random(10000, 50000),
                    math.random(-100000, 100000)
                )
            end
            wait(0.1)
        end
    end)()
end

local function emitShootedEvent(targetPlayerName)
    local cfg = Instance.new("Configuration")
    if targetPlayerName and #targetPlayerName > 0 then
        cfg.Name = "Shooted " .. targetPlayerName
    else
        cfg.Name = "Shooted nobody"
    end
    cfg.Parent = player
    task.delay(0.1, function()
        if cfg and cfg.Parent then cfg:Destroy() end
    end)
end

local v71 = {}
local v16 = 60
task.spawn(function()
    while true do
        task.wait(5)
        local now = tick()
        for i = #v71, 1, -1 do
            if now - v71[i].timestamp > v16 then
                table.remove(v71, i)
            end
        end
    end
end)

function tablesEqual(t1, t2)
    if #t1 ~= #t2 then return false end
    for i = 1, #t1 do
        if t1[i] ~= t2[i] then return false end
    end
    return true
end

function checkArgsInHistory(receivedArgs)
    local now = tick()
    for _, entry in ipairs(v71) do
        if now - entry.timestamp <= v16 then
            if type(entry.args) == "table" and type(receivedArgs) == "table" then
                if #entry.args == 1 and #receivedArgs == 1 then
                    if entry.args[1] == receivedArgs[1] then return true end
                else
                    if tablesEqual(entry.args, receivedArgs) then return true end
                end
            elseif tablesEqual(entry.args, receivedArgs) then
                return true
            end
        end
    end
    return false
end
makerpasta()

local v72 = { BaseSpread = 0.5, MoveSpread = 2.5, MaxJumpSpread = 15, MinSpread = 0.01, MaxSpread = 15, VelocityInfluence = 2, HorizontalInfluence = 0.2, CrouchMultiplier = 0.3 }
local v17 = 3
local v18 = 1
local _lastHRPPos = nil
local _lastHRPTick = nil

local function isCharacterGrounded(character, hrp)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { character }
    local origin = hrp.Position
    local direction = Vector3.new(0, -1000, 0)
    local result = workspace:Raycast(origin, direction, params)
    if result then
        local dist = (origin - result.Position).Magnitude
        return dist <= v17
    end
    return false
end

function getPlanarSpeedEstimate(humanoid, hrp)
    local now = tick()
    local pos = hrp.Position
    local v19 = 0
    if _lastHRPPos and _lastHRPTick then
        local dt = math.max(now - _lastHRPTick, 1e-3)
        local delta = pos - _lastHRPPos
        v19 = Vector3.new(delta.X, 0, delta.Z).Magnitude / dt
    end
    _lastHRPPos, _lastHRPTick = pos, now
    local moveInputSpeed = (humanoid.MoveDirection and humanoid.MoveDirection.Magnitude or 0) * (humanoid.WalkSpeed or 16)
    return math.max(v19, moveInputSpeed)
end

function getVerticalSpeed(hrp)
    local alv = hrp.AssemblyLinearVelocity
    if alv then return math.abs(alv.Y) end
    return 0
end

local function getCurrentSpread()
    local character = player.Character
    if not character then return v72.BaseSpread end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return v72.BaseSpread end
    
    local crouchValue = player:FindFirstChild("Crouch")
    local isCrouching = crouchValue and crouchValue.Value == true
    local linearVelocity = rootPart:FindFirstChildOfClass("LinearVelocity")
    local v20 = 0
    local v21 = 0
    
    if linearVelocity then
        local planeVel = linearVelocity.PlaneVelocity
        v20 = Vector3.new(planeVel.X, 0, planeVel.Y).Magnitude
    else
        local alv = rootPart.AssemblyLinearVelocity
        if alv then v20 = Vector3.new(alv.X, 0, alv.Z).Magnitude end
    end
    
    local alv = rootPart.AssemblyLinearVelocity
    if alv then v21 = math.abs(alv.Y) end
    
    local grounded = isCharacterGrounded(character, rootPart)
    if grounded and v21 > 5 then grounded = false end
    
    local currentSpread = v72.BaseSpread
    if not grounded then
        local jumpSpreadFactor = math.min(v21 * v72.VelocityInfluence, v72.MaxJumpSpread)
        currentSpread = v72.BaseSpread + jumpSpreadFactor
        if v20 > v18 then
            currentSpread = currentSpread + (v20 * v72.HorizontalInfluence * 0.5)
        end
    else
        if v20 > v18 then
            currentSpread = currentSpread + (v20 * v72.HorizontalInfluence)
        end
        if isCrouching then
            currentSpread = currentSpread * v72.CrouchMultiplier
        end
    end
    return math.clamp(currentSpread, v72.MinSpread, v72.MaxSpread)
end

local function applySpread(targetPos, rayOrigin, spread)
    if spread <= 0 then return targetPos end
    local direction = (targetPos - rayOrigin).Unit
    local v59 = (targetPos - rayOrigin).Magnitude
    local randomAngle1 = math.random() * math.pi * 2
    local randomAngle2 = math.acos(2 * math.random() - 1)
    local randomRadius = spread * math.sqrt(math.random())
    
    local right = direction:Cross(Vector3.new(0, 1, 0))
    if right.Magnitude < 0.1 then right = direction:Cross(Vector3.new(1, 0, 0)) end
    right = right.Unit
    
    local up = right:Cross(direction).Unit
    local offset = right * (math.cos(randomAngle1) * math.sin(randomAngle2) * randomRadius) + up * (math.sin(randomAngle1) * math.sin(randomAngle2) * randomRadius) + direction * (math.cos(randomAngle2) * randomRadius)
    return targetPos + offset
end

function canShootWithHitchance()
    local hitchanceValue = player:FindFirstChild("Hitchance")
    local hitchanceOverrideBool = player:FindFirstChild("hitchanceoverride")
    local hitchanceOverrideValue = player:FindFirstChild("hitchanceoverridevalue")
    local activeHitchanceValue = hitchanceValue
    
    if hitchanceOverrideBool and hitchanceOverrideBool.Value and hitchanceOverrideValue and hitchanceOverrideValue:IsA("IntValue") then
        activeHitchanceValue = hitchanceOverrideValue
    end
    
    if not activeHitchanceValue or not activeHitchanceValue:IsA("IntValue") then return true end
    
    local v70 = activeHitchanceValue.Value
    local currentSpread = getCurrentSpread()
    local v22 = 0.2
    local maxAllowedSpread = v22 + (v72.MaxSpread - v22) * (1 - v70 / 100)
    return currentSpread <= maxAllowedSpread
end

local function findSSGTool()
    local character = player.Character
    if character then
        local t = character:FindFirstChild("SSG-08")
        if t then return t end
    end
    local bp = player:FindFirstChild("Backpack")
    return bp and bp:FindFirstChild("SSG-08") or nil
end

local function getSelectedHitSound()
    local hitsoundValue = player:FindFirstChild("Hitsound")
    local soundName = hitsoundValue and hitsoundValue.Value or "Neverlose"
    return hitSoundsFolder:FindFirstChild(soundName)
end

local function getSelectedKillSound()
    local killsoundValue = player:FindFirstChild("Killsound")
    local soundName = killsoundValue and killsoundValue.Value or "Original"
    return killSoundsFolder:FindFirstChild(soundName)
end

local function getSelectedHitEffect()
    local hiteffectValue = player:FindFirstChild("Hiteffect")
    local effectName = hiteffectValue and hiteffectValue.Value or "None"
    if effectName == "None" then return nil end
    local effectsFolder = ReplicatedStorage:FindFirstChild("Effects")
    if not effectsFolder then return nil end
    return effectsFolder:FindFirstChild(effectName)
end

local function getSelectedKillEffect()
    local killeffectValue = player:FindFirstChild("Killeffect")
    local effectName = killeffectValue and killeffectValue.Value or "None"
    if effectName == "None" then return nil end
    local effectsFolder = ReplicatedStorage:FindFirstChild("Effects")
    if not effectsFolder then return nil end
    return effectsFolder:FindFirstChild(effectName)
end

local function createEffectAtPosition(effectTemplate, targetHRP, isKillEffect)
    if not effectTemplate or not targetHRP then return end
    local timeoutValueName = isKillEffect and "KilleffectTimeout" or "HiteffectTimeout"
    local timeoutValue = player:FindFirstChild(timeoutValueName)
    local timeout = (timeoutValue and timeoutValue:IsA("NumberValue") and timeoutValue.Value) or 1.0
    timeout = math.clamp(timeout, 0.1, 3.0)
    
    local effectPart = nil
    if effectTemplate:IsA("BasePart") then
        effectPart = effectTemplate
    else
        for _, child in ipairs(effectTemplate:GetChildren()) do
            if child:IsA("BasePart") then
                effectPart = child
                break
            end
        end
    end
    if not effectPart then return end
    
    local clonedPart = effectPart:Clone()
    clonedPart.Size = Vector3.new(1, 1, 1)
    clonedPart.CanCollide = false
    clonedPart.Transparency = 1
    clonedPart.Anchored = true
    clonedPart.Position = targetHRP.Position
    clonedPart.Parent = workspace
    
    local v73 = {}
    local function findParticleEmitters(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                table.insert(v73, child)
            elseif child:IsA("Model") or child:IsA("Folder") or child:IsA("Attachment") then
                findParticleEmitters(child)
            end
        end
    end
    findParticleEmitters(clonedPart)
    
    for _, emitter in ipairs(v73) do emitter.Enabled = true end
    
    task.delay(timeout, function()
        for _, emitter in ipairs(v73) do
            if emitter and emitter.Parent then emitter.Enabled = false end
        end
        task.delay(timeout, function()
            if clonedPart and clonedPart.Parent then clonedPart:Destroy() end
        end)
    end)
end

local computeNeckFireOrigin
local calculateClientDamage
local calculateClientDamageWithArmor
local v74 = {}
local v23 = 0
local v24 = 0.1

function getCachedPlayersList()
    if not Players then return {} end
    local now = tick()
    if now - v23 > v24 then
        local success, players = pcall(function() return Players:GetPlayers() end)
        if success and players then
            v74 = players
            v23 = now
        end
    end
    return v74
end

local function getClosestPlayer(position)
    local best, bestDist = nil, math.huge
    local v25 = 500
    for _, other in ipairs(getCachedPlayersList()) do
        if other ~= player and other.Character and other.Character.Parent then
            if isHitchamsClone and isHitchamsClone(other.Character) then else
                local myTeam = player:GetAttribute("Team")
                local theirTeam = other:GetAttribute("Team")
                if myTeam and theirTeam and myTeam == theirTeam then else
                    local head = other.Character:FindFirstChild("Head")
                    local humanoid = other.Character:FindFirstChildOfClass("Humanoid")
                    if head and head.Parent and humanoid and humanoid.Parent then
                        if humanoid:GetState() ~= Enum.HumanoidStateType.Dead and humanoid.Health > 0 and not other.Character:FindFirstChildOfClass("ForceField") then
                            local dist = (head.Position - position).Magnitude
                            if dist <= v25 and dist < bestDist then
                                best = other.Character
                                bestDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function setTargetVector(vec)
    if targetPosValue then targetPosValue.Value = vec or ZERO_VECTOR end
end

local v75 = {}

function normalizeAngle(angle)
    angle = angle % 360
    if angle > 180 then angle = angle - 360 end
    if angle < -180 then angle = angle + 360 end
    return angle
end

function getResolverData(targetPlayer)
    if not targetPlayer then return nil end
    local userId = targetPlayer.UserId
    if not v75[userId] then
        v75[userId] = { userId = userId, name = targetPlayer.Name, state = "Standing", lastState = "Standing", stateTime = 0, lastPos = nil, velocity = Vector3.zero, v61 = 0, moveDirAngle = 0, misses = 0, lastHitAngle = nil, side = 1, lbyProxy = 0, lastMovingLBY = 0, lastUpdate = 0 }
    end
    return v75[userId]
end

function updateResolverData(targetPlayer, targetCharacter)
    local data = getResolverData(targetPlayer)
    if not data or not targetCharacter then return end
    local hrp = targetCharacter:FindFirstChild("HumanoidRootPart")
    local humanoid = targetCharacter:FindFirstChild("Humanoid")
    if not hrp then return end
    
    local now = tick()
    local dt = now - data.lastUpdate
    data.lastUpdate = now
    local newPos = hrp.Position
    
    if data.lastPos then
        if dt > 0 then
            local rawVel = (newPos - data.lastPos) / dt
            data.velocity = data.velocity:Lerp(rawVel, 0.5)
        end
    end
    
    data.lastPos = newPos
    data.v61 = Vector3.new(data.velocity.X, 0, data.velocity.Z).Magnitude
    local v1 = false
    if humanoid then
        local s = humanoid:GetState()
        if s == Enum.HumanoidStateType.Freefall or s == Enum.HumanoidStateType.Jumping then v1 = true end
    end
    
    if math.abs(data.velocity.Y) > 5 and not v1 then v1 = true end
    
    local v13 = "Standing"
    if v1 then v13 = "Air"
    elseif data.v61 > 5 then v13 = "Moving"
    else v13 = "Standing" end
    
    if v13 ~= data.state then
        data.stateTime = now
        data.lastState = data.state
        data.state = v13
    end
    
    if data.v61 > 1 then
        local dir = data.velocity.Unit
        data.moveDirAngle = math.deg(math.atan2(dir.X, dir.Z))
        data.lastMovingLBY = data.moveDirAngle
    end
    
    local _, rotY, _ = hrp.CFrame:ToOrientation()
    data.lbyProxy = math.deg(rotY)
end

function registerResolverHit(targetPlayer, didHit, angleUsed)
    local data = getResolverData(targetPlayer)
    if not data then return end
    if didHit then
        data.misses = math.max(0, data.misses - 1)
        data.lastHitAngle = angleUsed
    else
        data.misses = data.misses + 1
        if data.misses % 1 == 0 then data.side = -data.side end
    end
end

function calculateResolverCorrection(targetPlayer, targetCharacter, baseAngle)
    local enabled = player:FindFirstChild("ResolverEnabled") and player:FindFirstChild("ResolverEnabled").Value
    if not enabled then return 0 end
    
    local mode = player:FindFirstChild("ResolverMethod") and player:FindFirstChild("ResolverMethod").Value or "Universal"
    local useStates = player:FindFirstChild("ResolverStateLogic") and player:FindFirstChild("ResolverStateLogic").Value
    local maxAngle = player:FindFirstChild("ResolverAngle") and player:FindFirstChild("ResolverAngle").Value or 58
    local jitter = player:FindFirstChild("ResolverSmoothness") and player:FindFirstChild("ResolverSmoothness").Value or 0
    
    local data = getResolverData(targetPlayer)
    if not data then return 0 end
    updateResolverData(targetPlayer, targetCharacter)
    
    local v26 = 0
    if useStates then
        if data.state == "Moving" then
            local moveDelta = normalizeAngle(data.moveDirAngle - baseAngle)
            v26 = moveDelta
        elseif data.state == "Air" then
            local moveDelta = normalizeAngle(data.moveDirAngle - baseAngle)
            v26 = moveDelta * 0.5
        else
            if mode == "Universal" or mode == "Inverse" then v26 = maxAngle * data.side
            elseif mode == "Bruteforce" then
                local step = data.misses % 3
                if step == 0 then v26 = 0
                elseif step == 1 then v26 = maxAngle
                elseif step == 2 then v26 = -maxAngle end
            elseif mode == "Legit" then v26 = 0 end
        end
    else
        if mode == "Bruteforce" then
            local v43 = {0, maxAngle, -maxAngle, maxAngle/2, -maxAngle/2}
            local idx = (data.misses % #v43) + 1
            v26 = v43[idx]
        elseif mode == "Inverse" then
            v26 = maxAngle * data.side
        else
            if data.v61 > 5 then
                v26 = normalizeAngle(data.moveDirAngle - baseAngle)
            else
                v26 = maxAngle * data.side
            end
        end
    end
    
    if jitter > 0 then
        local noise = (math.random() * 2 - 1) * jitter
        v26 = v26 + noise
    end
    return normalizeAngle(v26)
end

function scanVisiblePoints(targetPart, targetModel, originForVis, numPoints)
    if not targetPart or not targetPart.Parent then return nil end
    if targetModel and isHitchamsClone and isHitchamsClone(targetModel) then return nil end
    
    local partCFrame = targetPart.CFrame
    local partSize = targetPart.Size
    local visParams
    
    if getCachedRaycastParams then
        visParams = getCachedRaycastParams()
    else
        visParams = RaycastParams.new()
        visParams.FilterType = Enum.RaycastFilterType.Exclude
        local v76 = {player.Character}
        for _, nilhit in ipairs(getNilhitpartWhitelist()) do table.insert(v76, nilhit) end
        visParams.FilterDescendantsInstances = v76
    end
    
    local v77 = {}
    local isHead = targetPart.Name == "Head"
    local actualPoints = math.min(numPoints * 2, 20)
    local v27 = 0.4
    
    for i = 1, actualPoints do
        local t = i / actualPoints
        local angle = math.pi * 2 * i * 0.618033988749895
        local yRange = isHead and {0, 1} or {-1, 1}
        local y = yRange[1] + (yRange[2] - yRange[1]) * t
        local v55 = math.sqrt(1 - y * y)
        local x = math.cos(angle) * v55
        local z = math.sin(angle) * v55
        local localPos = Vector3.new(x * partSize.X / 2 * v27, y * partSize.Y / 2 * v27, z * partSize.Z / 2 * v27)
        local worldPos = partCFrame:PointToWorldSpace(localPos)
        table.insert(v77, worldPos)
    end
    
    local bestPoint = nil
    local bestScore = -math.huge
    local partCenter = targetPart.Position
    local v28 = 900
    
    for _, point in ipairs(v77) do
        local dir = point - originForVis
        local dist = dir.Magnitude
        if dist > 1e-3 then
            local res = workspace:Raycast(originForVis, dir.Unit * math.min(dist, 1000), visParams)
            if res and res.Instance then
                local hitInstance = res.Instance
                local hitModel = hitInstance:FindFirstAncestorOfClass("Model")
                if hitModel and isHitchamsClone and isHitchamsClone(hitModel) then
                elseif hitModel == targetModel then
                    local isTargetPart = (hitInstance == targetPart)
                    local v2 = false
                    if not isTargetPart then
                        pcall(function() v2 = hitInstance:IsDescendantOf(targetPart) end)
                    end
                    if isTargetPart or v2 then
                        local rayDirection = dir.Unit
                        local rayDistance = dist
                        local realHitPartName, realHitPoint, hasBodyYaw = nil, nil, false
                        if type(checkRaycastAgainstRealBody) == "function" then
                            realHitPartName, realHitPoint, hasBodyYaw = checkRaycastAgainstRealBody(targetModel, originForVis, rayDirection, rayDistance)
                        end
                        
                        local v29 = 0
                        if hasBodyYaw then
                            if realHitPartName and realHitPoint then v29 = 1000
                            else v29 = -10000 end
                        else
                            v29 = 500
                        end
                        
                        local distanceFromCenter = (point - partCenter).Magnitude
                        local v25 = math.max(partSize.X, partSize.Y, partSize.Z) / 2
                        local centerBonus = (1 - math.min(distanceFromCenter / v25, 1)) * 100
                        v29 = v29 + centerBonus
                        
                        if v29 > bestScore then
                            bestPoint = point
                            bestScore = v29
                            if bestScore >= v28 then break end
                        end
                    end
                end
            end
        end
    end
    return bestPoint
end

function getTargetPosition()
    setTargetVector(ZERO_VECTOR)
    local success, result = pcall(function()
        local char = player.Character
        if not char or not char.Parent then
            local cam = workspace.CurrentCamera
            local mouse = player:GetMouse()
            if cam and mouse and mouse.Hit then
                local dir = mouse.Hit.LookVector
                return cam.CFrame.Position + dir * 1000
            end
            return Vector3.new(0,0,0)
        end
        
        local hitpartsValue = player:FindFirstChild("hitparts")
        local hitpartModeValue = player:FindFirstChild("hitpartMode")
        local selectedHitpartsStr = hitpartsValue and hitpartsValue.Value or "Head"
        local v78 = {}
        
        for part in string.gmatch(selectedHitpartsStr, "([^,]+)") do
            part = part:match("^%s*(.-)%s*$")
            if part and part ~= "" then table.insert(v78, part) end
        end
        if #v78 == 0 then v78 = {"Head"} end
        
        local hitpartMode = hitpartModeValue and hitpartModeValue.Value or "Closest"
        local aimModeValue = char:FindFirstChild("aimMode")
        local aimMode = aimModeValue and aimModeValue.Value or "closest to plr"
        
        local bestTarget = nil
        local bestDistance = math.huge
        local playersList = getCachedPlayersList()
        
        for _, other in ipairs(playersList) do
            if other ~= player and other.Character and other.Character.Parent then
                if isHitchamsClone and isHitchamsClone(other.Character) then else
                    local myTeam = player:GetAttribute("Team")
                    local theirTeam = other:GetAttribute("Team")
                    if myTeam and theirTeam and myTeam == theirTeam then else
                        local humanoid = other.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead and not other.Character:FindFirstChildOfClass("ForceField") then
                            local head = other.Character:FindFirstChild("Head")
                            if head and head.Parent then
                                local rayOrigin
                                if computeNeckFireOrigin then
                                    rayOrigin = computeNeckFireOrigin(head.Position)
                                else
                                    local hrp = char:FindFirstChild("HumanoidRootPart")
                                    rayOrigin = hrp and (hrp.CFrame.Position + Vector3.new(0, 1, 0)) or head.Position
                                end
                                
                                local toHead = head.Position - rayOrigin
                                local v59 = toHead.Magnitude
                                if v59 <= 200 then
                                    local cam = workspace.CurrentCamera
                                    local v30 = 360
                                    if cam then
                                        local forward = cam.CFrame.LookVector
                                        local cosAngle = math.clamp(forward:Dot((head.Position - cam.CFrame.Position).Unit), -1, 1)
                                        local angleDeg = math.deg(math.acos(cosAngle))
                                        v30 = math.max(0, angleDeg - 60) * 5
                                    end
                                    local v31 = v59 + v30
                                    if aimMode == "closest to cursor" then
                                        local mouse = player:GetMouse()
                                        if mouse and mouse.Hit then
                                            v31 = (head.Position - mouse.Hit.Position).Magnitude + v30
                                        end
                                    end
                                    if v31 < bestDistance then
                                        bestDistance = v31
                                        bestTarget = other.Character
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if bestTarget and bestTarget.Parent then
            local function expandHitpartName(hitpartName)
                if hitpartName == "Arms" then return {"Left Arm", "Right Arm"}
                elseif hitpartName == "Legs" then return {"Left Leg", "Right Leg"}
                else return {hitpartName} end
            end
            
            local v79 = {}
            for _, selectedHitpart in ipairs(v78) do
                local expandedParts = expandHitpartName(selectedHitpart)
                for _, partName in ipairs(expandedParts) do
                    local part = bestTarget:FindFirstChild(partName)
                    if part then
                        local v31 = 50
                        if partName == "Head" then v31 = 100
                        elseif partName == "Torso" then v31 = 90
                        elseif partName == "Left Arm" or partName == "Right Arm" then v31 = 60
                        elseif partName == "Left Leg" or partName == "Right Leg" then v31 = 50 end
                        table.insert(v79, {name = partName, v31 = v31, part = part})
                    end
                end
            end
            
            if #v79 > 0 then
                table.sort(v79, function(a, b) return a.v31 > b.v31 end)
                local bestPart = nil
                local bestScore = -math.huge
                local bodyParts = v79
                local headPos = bestTarget:FindFirstChild("Head")
                local originForVis
                if computeNeckFireOrigin and headPos then
                    originForVis = computeNeckFireOrigin(headPos.Position)
                elseif char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    originForVis = hrp and (hrp.CFrame.Position + Vector3.new(0, 1, 0)) or (headPos and headPos.Position or Vector3.new(0, 0, 0))
                else
                    originForVis = headPos and headPos.Position or Vector3.new(0, 0, 0)
                end
                
                local mindmgBool = player:FindFirstChild("MindmgBool")
                local mindmgValue = player:FindFirstChild("Mindmg")
                local mindmgOverrideBool = player:FindFirstChild("mindmgoverride")
                local mindmgOverrideValue = player:FindFirstChild("mindmgoverridevalue")
                local activeMindmgValue = mindmgValue
                if mindmgOverrideBool and mindmgOverrideBool.Value and mindmgOverrideValue and mindmgOverrideValue:IsA("IntValue") then
                    activeMindmgValue = mindmgOverrideValue
                end
                local minDmgThreshold = (mindmgBool and mindmgBool.Value and activeMindmgValue and activeMindmgValue:IsA("IntValue")) and activeMindmgValue.Value or 0
                
                local hitchanceValue = player:FindFirstChild("Hitchance")
                local hitchanceOverrideBool = player:FindFirstChild("hitchanceoverride")
                local hitchanceOverrideValue = player:FindFirstChild("hitchanceoverridevalue")
                local activeHitchanceValue = hitchanceValue
                if hitchanceOverrideBool and hitchanceOverrideBool.Value and hitchanceOverrideValue and hitchanceOverrideValue:IsA("IntValue") then
                    activeHitchanceValue = hitchanceOverrideValue
                end
                
                local currentSpread = getCurrentSpread()
                local maxAllowedSpread = math.huge
                if activeHitchanceValue and activeHitchanceValue:IsA("IntValue") then
                    local v70 = activeHitchanceValue.Value
                    local v22 = 0.2
                    maxAllowedSpread = v22 + (v72.MaxSpread - v22) * (1 - v70 / 100)
                end
                
                local hitpointsValue = player:FindFirstChild("Hitpoints")
                local numPoints = hitpointsValue and hitpointsValue.Value or 15
                local reducedPoints = math.min(numPoints, 8)
                local v32 = 0
                local data = bestTarget:FindFirstChild("Data")
                if data then
                    local armor = data:FindFirstChild("Armor")
                    if armor and armor:IsA("IntValue") then v32 = armor.Value end
                end
                
                local humanoid = bestTarget:FindFirstChildOfClass("Humanoid")
                local currentHealth = humanoid and humanoid.Health or 0
                
                for _, partData in ipairs(bodyParts) do
                    local part = partData.part
                    if part and part.Parent then
                        local pointsToUse = (partData.v31 >= 90) and numPoints or reducedPoints
                        local candidatePoint
                        if scanVisiblePoints then
                            candidatePoint = scanVisiblePoints(part, bestTarget, originForVis, pointsToUse)
                        else
                            candidatePoint = part.Position
                        end
                        
                        if candidatePoint then
                            local dist = (candidatePoint - originForVis).Magnitude
                            local v3 = false
                            local v33 = 0
                            if calculateClientDamage then v33 = calculateClientDamage(dist, v3, partData.name) end
                            
                            local healthDamage = v33
                            if calculateClientDamageWithArmor then
                                _, _, healthDamage, _ = calculateClientDamageWithArmor(v33, v32, partData.name)
                            end
                            
                            local v4 = true
                            if minDmgThreshold > 0 then
                                if healthDamage < minDmgThreshold and healthDamage < currentHealth then v4 = false end
                            end
                            
                            local hitchanceCheckPassed = (currentSpread <= maxAllowedSpread)
                            local v29 = partData.v31
                            v29 = v29 + (healthDamage * 0.1)
                            v29 = v29 - (dist * 0.05)
                            
                            if not v4 then v29 = v29 - 5000 else v29 = v29 + 100 end
                            if not hitchanceCheckPassed then v29 = v29 - 2000 end
                            if healthDamage >= currentHealth then v29 = v29 + 200 end
                            
                            if v29 > bestScore then
                                bestScore = v29
                                bestPart = {part = part, point = candidatePoint}
                                if partData.v31 >= 90 and v4 and hitchanceCheckPassed and v29 > 150 then break end
                            end
                        end
                    end
                end
                
                if bestPart then
                    setTargetVector(bestPart.point)
                    return bestPart.point
                end
            end
        end
        local cam = workspace.CurrentCamera
        local mouse = player:GetMouse()
        if cam and mouse and mouse.Hit then
            local dir = mouse.Hit.LookVector
            return cam.CFrame.Position + dir * 1000
        end
        return Vector3.new(0,0,0)
    end)
    if success then return result else return Vector3.new(0,0,0) end
end

local tool = nil
local debugBeam = nil
local debugAttachment0 = nil
local debugAttachment1 = nil
local v34 = 0
local spreadDebugSphere = nil
local spreadDebugBillboard = nil
local bulletStartDebugPart = nil
local v80 = {}
local v81 = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }

local function destroyRealBodyDebug(plr)
    local entry = v80[plr]
    if entry then
        if entry.model then entry.model:Destroy() end
        v80[plr] = nil
    end
end

local function clearRealBodyDebug()
    for plr in pairs(v80) do destroyRealBodyDebug(plr) end
end

local function ensureRealBodyModel(plr)
    local entry = v80[plr]
    if entry and entry.model and entry.model.Parent then return entry end
    if entry then destroyRealBodyDebug(plr) end
    
    local model = Instance.new("Model")
    model.Name = ""
    model.Parent = workspace
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 130, 0)
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = model
    
    entry = { model = model, parts = {} }
    v80[plr] = entry
    return entry
end

local function ensureRealBodyPart(entry, sourcePartName)
    local part = entry.parts[sourcePartName]
    if part and part.Parent then return part end
    if part then part:Destroy() end
    
    part = Instance.new("Part")
    part.Name = "Ignored"
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(255, 120, 0)
    part.Transparency = 0.4
    part.Parent = entry.model
    entry.parts[sourcePartName] = part
    return part
end

function updateRealBodyDebug()
    local debugValue = player:FindFirstChild("RealHeadDebug")
    local enabled = debugValue and debugValue.Value
    if not enabled then clearRealBodyDebug(); return end
    
    local v82 = {}
    for _, otherPlayer in ipairs(getCachedPlayersList()) do
        if otherPlayer ~= player then
            local character = otherPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local bodyYawValue = character and character:FindFirstChild("BodyYaw")
            if hrp and bodyYawValue and typeof(bodyYawValue.Value) == "number" then
                local entry = ensureRealBodyModel(otherPlayer)
                local yawRad = math.rad(bodyYawValue.Value)
                local realRoot = hrp.CFrame * CFrame.Angles(0, yawRad, 0)
                
                for _, partName in ipairs(v81) do
                    local original = character:FindFirstChild(partName)
                    if original and original:IsA("BasePart") then
                        local relativeCF = hrp.CFrame:ToObjectSpace(original.CFrame)
                        local debugPart = ensureRealBodyPart(entry, partName)
                        if partName == "Head" then debugPart.Size = Vector3.new(1, 1, 1)
                        else debugPart.Size = original.Size end
                        debugPart.CFrame = realRoot * relativeCF
                    else
                        local existing = entry.parts[partName]
                        if existing then existing:Destroy(); entry.parts[partName] = nil end
                    end
                end
                v82[otherPlayer] = true
            end
        end
    end
    for trackedPlayer in pairs(v80) do
        if not v82[trackedPlayer] then destroyRealBodyDebug(trackedPlayer) end
    end
end

local indicatorsFolder = player:FindFirstChild("indicators")
if not indicatorsFolder then
    indicatorsFolder = Instance.new("Folder")
    indicatorsFolder.Name = "indicators"
    indicatorsFolder.Parent = player
end

local mindmgOverrideIndicator = indicatorsFolder:FindFirstChild("MindmgOverride")
if not mindmgOverrideIndicator then
    mindmgOverrideIndicator = Instance.new("BoolValue")
    mindmgOverrideIndicator.Name = "MindmgOverride"
    mindmgOverrideIndicator.Value = false
    mindmgOverrideIndicator.Parent = indicatorsFolder
end

local hitchanceOverrideIndicator = indicatorsFolder:FindFirstChild("HitchanceOverride")
if not hitchanceOverrideIndicator then
    hitchanceOverrideIndicator = Instance.new("BoolValue")
    hitchanceOverrideIndicator.Name = "HitchanceOverride"
    hitchanceOverrideIndicator.Value = false
    hitchanceOverrideIndicator.Parent = indicatorsFolder
end

local function updateMindmgOverrideIndicator()
    local mindmgOverrideBool = player:FindFirstChild("mindmgoverride")
    if mindmgOverrideBool and mindmgOverrideBool:IsA("BoolValue") then
        mindmgOverrideIndicator.Value = mindmgOverrideBool.Value
    else
        mindmgOverrideIndicator.Value = false
    end
end

local function updateHitchanceOverrideIndicator()
    local hitchanceOverrideBool = player:FindFirstChild("hitchanceoverride")
    if hitchanceOverrideBool and hitchanceOverrideBool:IsA("BoolValue") then
        hitchanceOverrideIndicator.Value = hitchanceOverrideBool.Value
    else
        hitchanceOverrideIndicator.Value = false
    end
end

local function setupOverrideListeners()
    local mindmgOverrideBool = player:FindFirstChild("mindmgoverride")
    if mindmgOverrideBool then
        mindmgOverrideBool.Changed:Connect(updateMindmgOverrideIndicator)
        updateMindmgOverrideIndicator()
    end
    local hitchanceOverrideBool = player:FindFirstChild("hitchanceoverride")
    if hitchanceOverrideBool then
        hitchanceOverrideBool.Changed:Connect(updateHitchanceOverrideIndicator)
        updateHitchanceOverrideIndicator()
    end
end

player.ChildAdded:Connect(function(child)
    if child.Name == "mindmgoverride" or child.Name == "hitchanceoverride" then
        task.wait(0.1)
        setupOverrideListeners()
    end
end)
task.delay(0.5, setupOverrideListeners)

local v5 = true
local v35 = 0
local v6 = false
local v36 = 1.5
local v37 = 2
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

computeNeckFireOrigin = function(targetPos)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        local cam = workspace.CurrentCamera
        return cam and cam.CFrame.Position or targetPos
    end
    
    local center = hrp.CFrame.Position + Vector3.new(0, 1, 0)
    local cf = hrp.CFrame
    local right = cf.RightVector
    local forward = cf.LookVector
    local halfX, halfZ = 0.5, 0.5
    local v83 = {
        center,
        center + right * halfX,
        center - right * halfX,
        center + forward * halfZ,
        center - forward * halfZ,
        center + right * halfX + forward * halfZ,
        center + right * halfX - forward * halfZ,
        center - right * halfX + forward * halfZ,
        center - right * halfX - forward * halfZ,
    }
    
    local params = getCachedRaycastParams()
    local function isInsideNonPenetrable(pos)
        local overlap = OverlapParams.new()
        overlap.FilterType = Enum.RaycastFilterType.Exclude
        local v84 = {}
        if player.Character then table.insert(v84, player.Character) end
        overlap.FilterDescendantsInstances = v84
        local parts = workspace:GetPartBoundsInRadius(pos, 0.25, overlap)
        for _, part in ipairs(parts) do
            if part:IsA("BasePart") and part.Name ~= "Penetrable" and part.Name ~= "Nilhitpart" then return true end
        end
        return false
    end
    
    local bestOrigin = center
    local bestClearance = -math.huge
    for _, origin in ipairs(v83) do
        if not isInsideNonPenetrable(origin) then
            local dir = targetPos - origin
            local dist = dir.Magnitude
            if dist > 1e-3 then
                local res = workspace:Raycast(origin, dir.Unit * math.min(dist, 1000), params)
                if not res then return origin else
                    local hitDist = (res.Position - origin).Magnitude
                    if hitDist > bestClearance then
                        bestClearance = hitDist
                        bestOrigin = origin
                    end
                end
            end
        end
    end
    
    if isInsideNonPenetrable(bestOrigin) then
        local nudged = bestOrigin:Lerp(center, 0.5)
        if not isInsideNonPenetrable(nudged) then return nudged end
        local cam = workspace.CurrentCamera
        if cam then
            local try = bestOrigin
            for i = 1, 4 do
                try = try - cam.CFrame.LookVector * 0.25
                if not isInsideNonPenetrable(try) then return try end
            end
        end
        return center
    end
    return bestOrigin
end

local function castAimRay(origin, targetPos)
    if not origin or not targetPos then return nil, origin end
    local dir = targetPos - origin
    local dist = dir.Magnitude
    if dist < 1e-3 then return nil, origin end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local v84 = {}
    for _, inst in ipairs(getCachedBlacklist()) do table.insert(v84, inst) end
    for _, pen in ipairs(getPenetrableWhitelist()) do table.insert(v84, pen) end
    for _, nilhit in ipairs(getNilhitpartWhitelist()) do table.insert(v84, nilhit) end
    params.FilterDescendantsInstances = v84
    
    local result = workspace:Raycast(origin, dir.Unit * math.min(dist, 1000), params)
    local endPos = result and result.Position or (origin + dir.Unit * math.min(dist, 1000))
    return result, endPos
end

function isInJoystickArea(touchPosition)
    if not touchPosition or not touchPosition.X or not touchPosition.Y then return false end
    local screenSize = workspace.CurrentCamera.ViewportSize
    local v85 = { x = 0, y = screenSize.Y * 0.6, width = screenSize.X * 0.3, height = screenSize.Y * 0.4 }
    return touchPosition.X >= v85.x and touchPosition.X <= v85.x + v85.width and touchPosition.Y >= v85.y and touchPosition.Y <= v85.y + v85.height
end

function isCameraControl(touchPosition)
    if not touchPosition or not touchPosition.X or not touchPosition.Y then return false end
    local screenSize = workspace.CurrentCamera.ViewportSize
    local v86 = { x = screenSize.X * 0.7, y = 0, width = screenSize.X * 0.3, height = screenSize.Y * 0.6 }
    return touchPosition.X >= v86.x and touchPosition.X <= v86.x + v86.width and touchPosition.Y >= v86.y and touchPosition.Y <= v86.y + v86.height
end

local function createTempPart(position)
    local part = Instance.new("Part")
    part.Name = "Bullet"
    part.Size = Vector3.new(0.2, 0.2, 0.2)
    part.Position = position
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = true
    part.Parent = workspace
    addTransientToBlacklist(part)
    return part
end

local v87 = {
    Default = "http://www.roblox.com/asset/?id=78260707920108",
    Light = "rbxassetid://90961491521758",
    Lightning = "rbxassetid://247707396",
    ["Tiny Lightning"] = "rbxassetid://7151778302",
    Wave = "rbxassetid://123453630521207",
    Beam = "rbxassetid://6376702661",
    Surge = "rbxassetid://12652034914"
}

local function createBeam(startPart, endPart)
    local beam = Instance.new("Beam")
    local tracerFolder = player:FindFirstChild("Tracers")
    local v14 = "Default"
    local v38 = 0
    local v39 = 0.1
    local v40 = 0
    local tracerColor = Color3.fromRGB(255, 255, 255)
    local v41 = 0.5
    
    if tracerFolder then
        local tracerTypeVal = tracerFolder:FindFirstChild("TracerType")
        if tracerTypeVal and tracerTypeVal:IsA("StringValue") then v14 = tracerTypeVal.Value end
        local lightEmissionVal = tracerFolder:FindFirstChild("LightEmission")
        if lightEmissionVal and lightEmissionVal:IsA("NumberValue") then v38 = lightEmissionVal.Value end
        local lightInfluenceVal = tracerFolder:FindFirstChild("LightInfluence")
        if lightInfluenceVal and lightInfluenceVal:IsA("NumberValue") then v39 = lightInfluenceVal.Value end
        local tracerTransparencyVal = tracerFolder:FindFirstChild("TracerTransparency")
        if tracerTransparencyVal and tracerTransparencyVal:IsA("NumberValue") then v40 = tracerTransparencyVal.Value end
        
        local tracerColorRVal = tracerFolder:FindFirstChild("TracerColorR")
        local tracerColorGVal = tracerFolder:FindFirstChild("TracerColorG")
        local tracerColorBVal = tracerFolder:FindFirstChild("TracerColorB")
        if tracerColorRVal and tracerColorRVal:IsA("IntValue") and tracerColorGVal and tracerColorGVal:IsA("IntValue") and tracerColorBVal and tracerColorBVal:IsA("IntValue") then
            tracerColor = Color3.fromRGB(tracerColorRVal.Value, tracerColorGVal.Value, tracerColorBVal.Value)
        end
        local tracerLifeTimeVal = tracerFolder:FindFirstChild("TracerLifeTime")
        if tracerLifeTimeVal and tracerLifeTimeVal:IsA("NumberValue") then v41 = tracerLifeTimeVal.Value end
    end
    
    local textureId = v87[v14] or v87.Default
    beam.Texture = textureId
    beam.Attachment0 = Instance.new("Attachment", startPart)
    beam.Attachment1 = Instance.new("Attachment", endPart)
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.FaceCamera = true
    beam.LightEmission = math.clamp(v38, 0, 1)
    beam.LightInfluence = math.clamp(v39, 0, 1)
    beam.Color = ColorSequence.new(tracerColor)
    beam.Transparency = NumberSequence.new(math.clamp(v40, 0, 1))
    beam.Parent = workspace
    
    task.spawn(function()
        local v42 = 20
        local v44 = v41 / v42
        local initialTransparency = math.clamp(v40, 0, 1)
        for i = 1, v42 do
            local transparency = initialTransparency + ((1 - initialTransparency) * (i / v42))
            if beam and beam.Parent then beam.Transparency = NumberSequence.new(transparency) end
            task.wait(v44)
        end
        if startPart and startPart.Parent then startPart:Destroy() end
        if endPart and endPart.Parent then endPart:Destroy() end
        if beam and beam.Parent then beam:Destroy() end
    end)
    return beam
end

local function fadeDecals(part)
    task.wait(1.5)
    local v88 = {}
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("Decal") then table.insert(v88, child) end
    end
    local v43 = 8
    local v44 = 0.4 / v43
    local v45 = 1 / v43
    for i = 1, v43 do
        for _, decal in ipairs(v88) do decal.Transparency = decal.Transparency + v45 end
        task.wait(v44)
    end
    part:Destroy()
end

local function createBulletHole(position, normal, hitPart, isCharacter)
    local holeName = isCharacter and "BulletHoleFlesh" or "BulletHole"
    local bulletHoleTemplate = holesFolder:FindFirstChild(holeName)
    if not bulletHoleTemplate then return nil end
    local bulletHole = bulletHoleTemplate:Clone()
    bulletHole.Position = position
    bulletHole.CFrame = CFrame.new(position, position + normal)
    bulletHole.Parent = workspace
    addTransientToBlacklist(bulletHole)
    task.spawn(fadeDecals, bulletHole)
    return bulletHole
end

local v89 = { Default = "rbxassetid://113750946560821", Another = "rbxassetid://15592794444" }

local function createHitMarker(hitPosition)
    local hitMarkerFolder = player:FindFirstChild("HitMarker")
    if not hitMarkerFolder then return end
    local enabledVal = hitMarkerFolder:FindFirstChild("Enabled")
    if not enabledVal or not enabledVal.Value then return end
    
    local typeVal = hitMarkerFolder:FindFirstChild("Type")
    local sizeVal = hitMarkerFolder:FindFirstChild("Size")
    local lifeTimeVal = hitMarkerFolder:FindFirstChild("LifeTime")
    local markerType = typeVal and typeVal.Value or "Default"
    local markerSize = sizeVal and sizeVal.Value or 50
    local lifeTime = lifeTimeVal and lifeTimeVal.Value or 0.3
    local imageId = v89[markerType] or v89.Default
    
    local hitPart = Instance.new("Part")
    hitPart.Name = "Ignored"
    hitPart.Size = Vector3.new(0.01, 0.01, 0.01)
    hitPart.Position = hitPosition
    hitPart.Transparency = 1
    hitPart.CanCollide = false
    hitPart.Anchored = true
    hitPart.Parent = workspace
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, markerSize, 0, markerSize)
    billboardGui.StudsOffset = Vector3.new(0, 0, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Adornee = hitPart
    billboardGui.Parent = hitPart
    
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = imageId
    imageLabel.ImageTransparency = 0
    imageLabel.Parent = billboardGui
    
    task.spawn(function()
        local v42 = 20
        local v44 = lifeTime / v42
        for i = 1, v42 do
            if imageLabel and imageLabel.Parent then
                local transparency = i / v42
                imageLabel.ImageTransparency = transparency
            end
            task.wait(v44)
        end
        if hitPart and hitPart.Parent then hitPart:Destroy() end
    end)
end

hitchamsClones = {}

local function createHitchamsClone(hitModel, duration)
    if not hitModel or not hitModel:FindFirstChild("HumanoidRootPart") then return end
    local hitChamsFolder = player:FindFirstChild("HitChams")
    if not hitChamsFolder then return end
    local enabledVal = hitChamsFolder:FindFirstChild("Enabled")
    if not enabledVal or not enabledVal.Value then return end
    
    local materialVal = hitChamsFolder:FindFirstChild("Material")
    local transparencyVal = hitChamsFolder:FindFirstChild("Transparency")
    local colorRVal = hitChamsFolder:FindFirstChild("ColorR")
    local colorGVal = hitChamsFolder:FindFirstChild("ColorG")
    local colorBVal = hitChamsFolder:FindFirstChild("ColorB")
    local highlightEnabledVal = hitChamsFolder:FindFirstChild("HighlightEnabled")
    local fillTransparencyVal = hitChamsFolder:FindFirstChild("FillTransparency")
    local outlineTransparencyVal = hitChamsFolder:FindFirstChild("OutlineTransparency")
    local fillColorRVal = hitChamsFolder:FindFirstChild("FillColorR")
    local fillColorGVal = hitChamsFolder:FindFirstChild("FillColorG")
    local fillColorBVal = hitChamsFolder:FindFirstChild("FillColorB")
    local outlineColorRVal = hitChamsFolder:FindFirstChild("OutlineColorR")
    local outlineColorGVal = hitChamsFolder:FindFirstChild("OutlineColorG")
    local outlineColorBVal = hitChamsFolder:FindFirstChild("OutlineColorB")
    local alwaysOnTopVal = hitChamsFolder:FindFirstChild("AlwaysOnTop")
    
    local v90 = { Default = nil, ForceField = Enum.Material.ForceField, Neon = Enum.Material.Neon, Solid = Enum.Material.SmoothPlastic }
    local material = v90[materialVal and materialVal.Value or "ForceField"]
    local transparency = transparencyVal and transparencyVal.Value or 0
    local color = Color3.fromRGB(colorRVal and colorRVal.Value or 255, colorGVal and colorGVal.Value or 255, colorBVal and colorBVal.Value or 255)
    
    local durationValue = player:FindFirstChild("HitchamsDuration")
    local hitchamsDuration = durationValue and durationValue.Value or 3.0
    
    local characterClone = Instance.new("Model")
    characterClone.Name = ""
    characterClone.Parent = workspace
    table.insert(hitchamsClones, characterClone)
    
    local function deepClean(obj)
        for _, descendant in ipairs(obj:GetChildren()) do
            if descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") or descendant:IsA("Attachment") or descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") or descendant:IsA("Script") or descendant:IsA("LocalScript") then
                pcall(function() descendant:Destroy() end)
            else
                deepClean(descendant)
            end
        end
    end
    
    for _, child in ipairs(hitModel:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
            local clonedPart = child:Clone()
            deepClean(clonedPart)
            clonedPart.Color = color
            if material then clonedPart.Material = material end
            clonedPart.Transparency = transparency
            clonedPart.CanCollide = false
            clonedPart.Anchored = true
            clonedPart.Parent = characterClone
        elseif child:IsA("Accessory") then
            local clonedAccessory = child:Clone()
            deepClean(clonedAccessory)
            local function setPartProperties(obj)
                for _, part in ipairs(obj:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = color
                        if material then part.Material = material end
                        part.Transparency = transparency
                        part.CanCollide = false
                        part.Anchored = true
                    elseif part:IsA("Model") or part:IsA("Folder") or part:IsA("Accessory") then
                        setPartProperties(part)
                    end
                end
            end
            setPartProperties(clonedAccessory)
            clonedAccessory.Parent = characterClone
        end
    end
    
    if highlightEnabledVal and highlightEnabledVal.Value then
        local highlight = Instance.new("Highlight")
        local fillColor = Color3.fromRGB(fillColorRVal and fillColorRVal.Value or 255, fillColorGVal and fillColorGVal.Value or 255, fillColorBVal and fillColorBVal.Value or 255)
        local outlineColor = Color3.fromRGB(outlineColorRVal and outlineColorRVal.Value or 255, outlineColorGVal and outlineColorGVal.Value or 255, outlineColorBVal and outlineColorBVal.Value or 255)
        highlight.FillColor = fillColor
        highlight.OutlineColor = outlineColor
        highlight.FillTransparency = fillTransparencyVal and fillTransparencyVal.Value or 0.5
        highlight.OutlineTransparency = outlineTransparencyVal and outlineTransparencyVal.Value or 0
        highlight.DepthMode = (alwaysOnTopVal and alwaysOnTopVal.Value) and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        highlight.Parent = characterClone
    end
    
    local customHumanoid = Instance.new("Humanoid")
    customHumanoid.Parent = characterClone
    customHumanoid.PlatformStand = true
    pcall(function()
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        customHumanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    end)
    
    local v91 = {}
    local function cacheParts(obj)
        for _, part in ipairs(obj:GetChildren()) do
            if part:IsA("BasePart") then table.insert(v91, part)
            elseif part:IsA("Model") or part:IsA("Folder") or part:IsA("Accessory") then cacheParts(part) end
        end
    end
    cacheParts(characterClone)
    local cachedHighlight = characterClone:FindFirstChildOfClass("Highlight")
    
    task.spawn(function()
        local v42 = 20
        local v44 = hitchamsDuration / v42
        for i = 1, v42 do
            local transparency = i / v42
            for _, part in ipairs(v91) do
                if part and part.Parent then part.Transparency = transparency end
            end
            if cachedHighlight and cachedHighlight.Parent then
                cachedHighlight.FillTransparency = 0.7 + (transparency * 0.3)
            end
            task.wait(v44)
        end
        for i = #hitchamsClones, 1, -1 do
            if hitchamsClones[i] == characterClone then table.remove(hitchamsClones, i); break end
        end
        characterClone:Destroy()
    end)
end

local v92 = {}
local v46 = 0
local v47 = 0.1
local v93 = {}
local v48 = 0
local v49 = 0.2

local function appendFakePosModels(destination)
    local now = tick()
    if now - v48 > v49 then
        v93 = {}
        local camera = workspace.CurrentCamera
        if camera then table.insert(v93, camera) end
        for _, inst in ipairs(workspace:GetChildren()) do
            if inst:IsA("Model") and inst.Name == "" then table.insert(v93, inst) end
        end
        v48 = now
    end
    for _, inst in ipairs(v93) do table.insert(destination, inst) end
end

local cachedRaycastParams = nil
function getCachedRaycastParams()
    if not cachedRaycastParams then
        cachedRaycastParams = RaycastParams.new()
        cachedRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
    end
    local v99 = getCachedBlacklist()
    for _, nilhit in ipairs(getNilhitpartWhitelist()) do table.insert(v99, nilhit) end
    cachedRaycastParams.FilterDescendantsInstances = v99
    return cachedRaycastParams
end

local v94 = {}
local v95 = {}
local v96 = {}
local v97 = {}
local v98 = {}

function addTransientToBlacklist(part)
    if part then table.insert(v98, part) end
end

local function addPenetrable(inst)
    if inst and inst:IsA("BasePart") and inst.Name == "Penetrable" and not v95[inst] then
        v95[inst] = true
        table.insert(v94, inst)
    end
end

local function removePenetrable(inst)
    if inst and v95[inst] then
        v95[inst] = nil
        for i = #v94, 1, -1 do
            if v94[i] == inst then table.remove(v94, i); break end
        end
    end
end

local function addNilhitpart(inst)
    if inst and inst:IsA("BasePart") and inst.Name == "Nilhitpart" and not v97[inst] then
        v97[inst] = true
        table.insert(v96, inst)
    end
end

local function removeNilhitpart(inst)
    if inst and v97[inst] then
        v97[inst] = nil
        for i = #v96, 1, -1 do
            if v96[i] == inst then table.remove(v96, i); break end
        end
    end
end

local function seedPenetrables(container)
    for _, child in ipairs(container:GetChildren()) do
        addPenetrable(child)
        seedPenetrables(child)
    end
end

local function seedNilhitparts(container)
    for _, child in ipairs(container:GetChildren()) do
        addNilhitpart(child)
        seedNilhitparts(child)
    end
end

seedPenetrables(workspace)
seedNilhitparts(workspace)
workspace.DescendantAdded:Connect(function(inst) addPenetrable(inst); addNilhitpart(inst) end)
workspace.DescendantRemoving:Connect(function(inst) removePenetrable(inst); removeNilhitpart(inst) end)

function getPenetrableWhitelist() return v94 end
function getNilhitpartWhitelist() return v96 end

function getHitchamsBlacklist()
    local v99 = {}
    for _, clone in ipairs(hitchamsClones) do
        if clone and clone.Parent then table.insert(v99, clone) end
    end
    return v99
end

function isHitchamsClone(character)
    if not character then return false end
    if character.Name == "" then
        for _, clone in ipairs(hitchamsClones) do
            if clone == character then return true end
        end
    end
    return false
end

function getCachedBlacklist()
    local now = tick()
    if now - v46 > v47 then
        v92 = {}
        if player.Character then table.insert(v92, player.Character) end
        local tmpClonesFolder = workspace:FindFirstChild("tmp_clones")
        if tmpClonesFolder then table.insert(v92, tmpClonesFolder) end
        local hitchamsBlacklist = getHitchamsBlacklist()
        for _, item in ipairs(hitchamsBlacklist) do table.insert(v92, item) end
        for _, plr in ipairs(getCachedPlayersList()) do
            local char = plr.Character
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("Tool") then table.insert(v92, child) end
                end
            end
        end
        for _, plr in ipairs(getCachedPlayersList()) do
            if plr ~= player then
                local char = plr.Character
                if char then
                    for _, child in ipairs(char:GetChildren()) do
                        if child:IsA("Accessory") then table.insert(v92, child) end
                    end
                end
            end
        end
        for i = #v98, 1, -1 do
            local p = v98[i]
            if p and p.Parent then table.insert(v92, p) else table.remove(v98, i) end
        end
        appendFakePosModels(v92)
        v46 = now
    end
    return v92
end

function getExitPoint(part, entryPos, direction)
    local size = part.Size
    local cf = part.CFrame:Inverse() * CFrame.new(entryPos)
    local localEntry = cf.Position
    local localDir = part.CFrame:VectorToObjectSpace(direction)
    local tMax = math.huge
    local v100 = {"X", "Y", "Z"}
    for _, axis in ipairs(v100) do
        if math.abs(localDir[axis]) > 1e-4 then
            local half = size[axis]/2
            local t1 = ( half - localEntry[axis]) / localDir[axis]
            local t2 = (-half - localEntry[axis]) / localDir[axis]
            local t = math.max(t1, t2)
            if t > 0 and t < tMax then tMax = t end
        end
    end
    local localExit = localEntry + localDir * tMax
    local worldExit = part.CFrame:PointToWorldSpace(localExit)
    return worldExit
end

function checkPenetrableAlongRay(origin, direction, v25, _)
    local wl = getPenetrableWhitelist()
    if #wl == 0 then return nil end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = wl
    local result = workspace:Raycast(origin, direction * v25, params)
    if result and result.Instance and result.Instance.Name == "Penetrable" then
        return result, result.Position, result.Normal
    end
    return nil
end

function getBodyPartName(hitPart)
    local v101 = { ["Head"] = "Head", ["HumanoidRootPart"] = "HumanoidRootPart", ["LeftArm"] = "Left Arm", ["LeftLeg"] = "Left Leg", ["RightArm"] = "Right Arm", ["RightLeg"] = "Right Leg", ["Torso"] = "Torso" }
    return v101[hitPart.Name] or "Default"
end

function calculateRealBodyPartPosition(character, partName)
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local bodyYawValue = character:FindFirstChild("BodyYaw")
    local originalPart = character:FindFirstChild(partName)
    if not hrp or not bodyYawValue or not originalPart then return nil end
    
    local yawRad = math.rad(bodyYawValue.Value)
    local realRoot = hrp.CFrame * CFrame.Angles(0, yawRad, 0)
    local relativeCF = hrp.CFrame:ToObjectSpace(originalPart.CFrame)
    local realPartCFrame = realRoot * relativeCF
    local partSize = originalPart.Size
    if partName == "Head" then partSize = Vector3.new(1, 1, 1) end
    return realPartCFrame, partSize
end

function checkRayIntersectsRealPart(rayOrigin, rayDirection, rayDistance, realPartCFrame, partSize)
    if not realPartCFrame or not partSize then return false, nil end
    local localOrigin = realPartCFrame:PointToObjectSpace(rayOrigin)
    local localDirection = realPartCFrame:VectorToObjectSpace(rayDirection)
    local halfSize = partSize * 0.5
    local tMin = -math.huge
    local tMax = math.huge
    
    for i, axis in ipairs({localOrigin.X, localOrigin.Y, localOrigin.Z}) do
        local dir = ({localDirection.X, localDirection.Y, localDirection.Z})[i]
        local half = ({halfSize.X, halfSize.Y, halfSize.Z})[i]
        if math.abs(dir) < 1e-6 then
            if axis < -half or axis > half then return false, nil end
        else
            local t1 = (-half - axis) / dir
            local t2 = (half - axis) / dir
            if t1 > t2 then t1, t2 = t2, t1 end
            tMin = math.max(tMin, t1)
            tMax = math.min(tMax, t2)
            if tMin > tMax then return false, nil end
        end
    end
    
    if tMin >= 0 and tMin <= rayDistance then
        local hitPoint = rayOrigin + rayDirection * tMin
        return true, hitPoint
    elseif tMax >= 0 and tMax <= rayDistance then
        local hitPoint = rayOrigin + rayDirection * tMax
        return true, hitPoint
    end
    return false, nil
end

function checkRaycastAgainstRealBody(character, rayOrigin, rayDirection, rayDistance)
    if not character then return nil, nil, false end
    local bodyYawValue = character:FindFirstChild("BodyYaw")
    if not bodyYawValue then return nil, nil, false end
    
    local originalBodyYaw = bodyYawValue.Value
    local v50 = 0
    local targetPlayer = Players:GetPlayerFromCharacter(character)
    
    if targetPlayer then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local _, baseYaw, _ = hrp.CFrame:ToOrientation()
            local baseAngle = math.deg(baseYaw)
            v50 = calculateResolverCorrection(targetPlayer, character, baseAngle)
            bodyYawValue.Value = originalBodyYaw + v50
        end
    end
    
    local v102 = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
    local closestHit = nil
    local closestDistance = math.huge
    local closestPartName = nil
    
    for _, partName in ipairs(v102) do
        local realPartCFrame, partSize = calculateRealBodyPartPosition(character, partName)
        if realPartCFrame and partSize then
            local hit, hitPoint = checkRayIntersectsRealPart(rayOrigin, rayDirection, rayDistance, realPartCFrame, partSize)
            if hit and hitPoint then
                local v59 = (hitPoint - rayOrigin).Magnitude
                if v59 < closestDistance then
                    closestDistance = v59
                    closestHit = hitPoint
                    closestPartName = partName
                end
            end
        end
    end
    bodyYawValue.Value = originalBodyYaw
    if targetPlayer then
        local didHit = closestPartName ~= nil
        registerResolverHit(targetPlayer, didHit, v50)
    end
    return closestPartName, closestHit, true
end

calculateClientDamage = function(v59, v3, v15)
    local numericDistance = tonumber(v59) or 0
    local penetrated = (v3 == true) or (tostring(v3) == "true")
    if numericDistance > DmgConfig.DistanceMaxRange then return 0 end
    
    local hitData = DmgConfig.DamageTable[v15] or DmgConfig.DamageTable["Default"]
    local damage = hitData.base * hitData.multiplier
    local v51 = 0
    
    if numericDistance <= 100 then v51 = 0
    elseif numericDistance <= 150 then v51 = 0.15
    elseif numericDistance <= 160 then v51 = 0.25
    else v51 = 0.45 end
    
    damage = damage * (1 - v51)
    if penetrated then damage = damage * DmgConfig.DamageMultiplierAfterWall end
    local v52 = 0.97 + (math.random() * 0.06)
    damage = damage * v52
    return math.floor(damage)
end

calculateClientDamageWithArmor = function(damage, v32, bodyPart)
    local hitData = DmgConfig.DamageTable[bodyPart] or DmgConfig.DamageTable["Default"]
    local armorPenetration = hitData.armorPenetration
    local v53 = 0
    local healthDamage = damage
    local v54 = 0
    
    if v32 > 0 then
        v53 = math.min(v32, damage * DmgConfig.ArmorAbsorptionRate * armorPenetration)
        v54 = math.min(v32, damage * DmgConfig.ArmorLossRate)
        healthDamage = damage * (1 - (DmgConfig.ArmorAbsorptionRate * armorPenetration))
    end
    return math.floor(damage), math.floor(v53), math.floor(healthDamage), math.floor(v54)
end

function isPositionInsidePart(position)
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    local v84 = {}
    if player.Character then table.insert(v84, player.Character) end
    overlapParams.FilterDescendantsInstances = v84
    local v55 = 0.25
    local parts = workspace:GetPartBoundsInRadius(position, v55, overlapParams)
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and part.CanCollide and part.Name ~= "Terrain" then
            local p = part
            local v7 = false
            while p do
                if p:IsA("Tool") then v7 = true; break end
                p = p.Parent
            end
            if not v7 then return true end
        end
    end
    return false
end

function reload()
    if isActTriggered() then return end
    if v6 then return end
    local currentTool = findSSGTool()
    if not currentTool then return end
    local ammoValue = currentTool:FindFirstChild("Ammo")
    if not ammoValue or not ammoValue:IsA("IntValue") then return end
    
    v6 = true
    v5 = false
    local config = Instance.new("Configuration")
    config.Name = "Reload"
    config.Parent = currentTool
    game.ReplicatedStorage.Reload:FireServer()
    task.wait(v37)
    v6 = false
    v5 = true
end

local function canFireShot()
    if isActTriggered() then return false end
    if not v5 then return false end
    local character = player.Character
    if character and character:FindFirstChild("ForceField") then return end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
    if (tick() - v35 < v36) then return false end
    if v6 then return false end
    local currentTool = findSSGTool()
    if not currentTool then return false end
    local ammoValue = currentTool:FindFirstChild("Ammo")
    if not ammoValue or not ammoValue:IsA("IntValue") or ammoValue.Value <= 0 then return false end
    return true
end

function checkPlayerHit(rayOrigin, direction)
    local character = player.Character
    if character and character:FindFirstChild("ForceField") then return false end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Dead then return false end
    
    local bulletRayParams = RaycastParams.new()
    bulletRayParams.FilterType = Enum.RaycastFilterType.Exclude
    local v84 = {}
    for _, inst in ipairs(getCachedBlacklist()) do table.insert(v84, inst) end
    for _, pen in ipairs(getPenetrableWhitelist()) do table.insert(v84, pen) end
    for _, nilhit in ipairs(getNilhitpartWhitelist()) do table.insert(v84, nilhit) end
    bulletRayParams.FilterDescendantsInstances = v84
    
    local bulletRayResult = workspace:Raycast(rayOrigin, direction * 200, bulletRayParams)
    if bulletRayResult then
        local hitModel = bulletRayResult.Instance:FindFirstAncestorOfClass("Model")
        if hitModel and hitModel:FindFirstChildOfClass("Humanoid") then
            local v59 = (bulletRayResult.Position - rayOrigin).Magnitude
            if v59 <= 200 then
                local forceField = hitModel:FindFirstChild("ForceField")
                local targetHumanoid = hitModel:FindFirstChildOfClass("Humanoid")
                local isTargetDead = targetHumanoid and targetHumanoid:GetState() == Enum.HumanoidStateType.Dead
                if forceField or isTargetDead then
                    local alternativeTarget = findAlternativeTarget(rayOrigin, direction, bulletBlacklist)
                    if alternativeTarget then
                        return true, alternativeTarget.Position, alternativeTarget.Model, alternativeTarget.Part
                    end
                    return false
                else
                    return true, bulletRayResult.Position, hitModel, bulletRayResult.Instance
                end
            end
        end
    end
    return false
end

local function findAlternativeTarget(rayOrigin, direction, v99)
    local v25 = 200
    local v56 = 0
    local v57 = 10
    while v56 < v25 do
        local checkPos = rayOrigin + direction * v56
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = v99
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(checkPos, direction * v57, rayParams)
        if result then
            local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
            if hitModel and hitModel:FindFirstChildOfClass("Humanoid") then
                local forceField = hitModel:FindFirstChild("ForceField")
                if not forceField then
                    return { Position = result.Position, Model = hitModel, Part = result.Instance }
                end
            end
        end
        v56 = v56 + v57
    end
    return nil
end

local function checkTargetPositionSync(hitModel)
    if not hitModel then return true end
    local targetPlayer = Players:GetPlayerFromCharacter(hitModel)
    if not targetPlayer then return true end
    local posAttribute = targetPlayer:GetAttribute("Pos")
    if not posAttribute or typeof(posAttribute) ~= "Vector3" then return true end
    
    local hrp = hitModel:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local clientPos = hrp.Position
    local serverPos = posAttribute
    local v59 = (clientPos - serverPos).Magnitude
    if v59 > 10 then return false end
    return true
end

local function performShot(rayOrigin, targetPos, spreadAlreadyApplied, isManualShot, shouldStopRef, overrideHitPartName, useOverride, overrideHitModel, targetModel)
    if isActTriggered() then
        if shouldStopRef then shouldStopRef.Value = false end
        return
    end
    if not canFireShot() then
        if shouldStopRef then shouldStopRef.Value = false end
        return
    end
    
    local originalTargetPos = targetPos
    if not spreadAlreadyApplied then
        local currentSpread = getCurrentSpread()
        targetPos = applySpread(targetPos, rayOrigin, currentSpread)
    end
    
    local direction = (targetPos - rayOrigin).Unit
    local bulletRayParams = getCachedRaycastParams()
    local currentOrigin = rayOrigin
    local currentDirection = direction
    local v58 = 160
    local v3 = false
    local firstRayResult = workspace:Raycast(rayOrigin, direction * 160, bulletRayParams)
    
    local function isPointInsidePartFast(part, worldPos)
        if not part or not part:IsA("BasePart") then return false end
        local localPos = part.CFrame:PointToObjectSpace(worldPos)
        local s = part.Size
        return math.abs(localPos.X) <= s.X * 0.5 and math.abs(localPos.Y) <= s.Y * 0.5 and math.abs(localPos.Z) <= s.Z * 0.5
    end
    
    if firstRayResult and firstRayResult.Instance and isPointInsidePartFast(firstRayResult.Instance, rayOrigin) then
        local exitPoint = getExitPoint(firstRayResult.Instance, rayOrigin, direction)
        if exitPoint then
            local delta = (exitPoint - rayOrigin).Magnitude + 0.01
            currentOrigin = exitPoint + direction * 0.01
            v58 = math.max(0, 160 - delta)
        end
    end
    
    local finalParams = RaycastParams.new()
    finalParams.FilterType = Enum.RaycastFilterType.Exclude
    local v103 = {}
    for _, inst in ipairs(getCachedBlacklist()) do table.insert(v103, inst) end
    for _, pen in ipairs(getPenetrableWhitelist()) do table.insert(v103, pen) end
    for _, nilhit in ipairs(getNilhitpartWhitelist()) do table.insert(v103, nilhit) end
    finalParams.FilterDescendantsInstances = v103
    
    local v104 = {}
    local v105 = {}
    for _, inst in ipairs(getCachedBlacklist()) do table.insert(v105, inst) end
    
    while v58 > 0 do
        local penetrableResult, hitPos, hitNormal = checkPenetrableAlongRay(currentOrigin, currentDirection, v58, v104)
        if penetrableResult then
            v3 = true
            table.insert(v105, penetrableResult.Instance)
            local exitPoint = getExitPoint(penetrableResult.Instance, hitPos, currentDirection)
            if exitPoint then
                currentOrigin = exitPoint + currentDirection * 0.01
                v58 = v58 - (exitPoint - hitPos).Magnitude - 0.01
            else break end
        else break end
    end
    
    local hitModel = nil
    local v15 = "Default"
    local v59 = 160
    local closestRealHit = nil
    local closestRealDistance = math.huge
    
    if useOverride then
        v15 = overrideHitPartName or "Default"
        hitModel = overrideHitModel
        if hitModel and hitModel:FindFirstChild("HumanoidRootPart") then
            v59 = (hitModel.HumanoidRootPart.Position - rayOrigin).Magnitude
        else
            v59 = v58
        end
    else
        local v106 = {}
        if targetModel then
            if not (isHitchamsClone and isHitchamsClone(targetModel)) then table.insert(v106, targetModel) end
        else
            for _, otherPlayer in ipairs(getCachedPlayersList()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character.Parent then
                    if not (isHitchamsClone and isHitchamsClone(otherPlayer.Character)) then
                        table.insert(v106, otherPlayer.Character)
                    end
                end
            end
        end
        
        for _, character in ipairs(v106) do
            if isHitchamsClone and isHitchamsClone(character) then else
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                    local realHitPartName, realHitPoint, hasBodyYaw = checkRaycastAgainstRealBody(character, rayOrigin, currentDirection, v58)
                    if hasBodyYaw then
                        if realHitPartName and realHitPoint then
                            local hitDistance = (realHitPoint - rayOrigin).Magnitude
                            if hitDistance < closestRealDistance then
                                closestRealDistance = hitDistance
                                closestRealHit = { model = character, partName = realHitPartName, v59 = hitDistance }
                            end
                        end
                    else
                        local visualParams = RaycastParams.new()
                        visualParams.FilterType = Enum.RaycastFilterType.Exclude
                        visualParams.FilterDescendantsInstances = v103
                        local visualResult = workspace:Raycast(rayOrigin, currentDirection * v58, visualParams)
                        if visualResult then
                            local visualModel = visualResult.Instance:FindFirstAncestorOfClass("Model")
                            if visualModel and isHitchamsClone and isHitchamsClone(visualModel) then
                            elseif visualModel == character then
                                local hitDistance = (visualResult.Position - rayOrigin).Magnitude
                                local visualPartName = getBodyPartName(visualResult.Instance)
                                if hitDistance < closestRealDistance then
                                    closestRealDistance = hitDistance
                                    closestRealHit = { model = character, partName = visualPartName, v59 = hitDistance }
                                end
                            end
                        end
                    end
                end
            end
        end
        if closestRealHit then
            hitModel = closestRealHit.model
            v15 = closestRealHit.partName
            v59 = closestRealHit.v59
        else
            v59 = v58
        end
    end
    
    if hitModel and hitModel:FindFirstChildOfClass("Humanoid") then
        if not checkTargetPositionSync(hitModel) then
            if shouldStopRef then shouldStopRef.Value = false end
            return
        end
    end
    
    if hitModel and hitModel:FindFirstChildOfClass("Humanoid") then
        local mindmgBool = player:FindFirstChild("MindmgBool")
        local mindmgValue = player:FindFirstChild("Mindmg")
        local mindmgOverrideBool = player:FindFirstChild("mindmgoverride")
        local mindmgOverrideValue = player:FindFirstChild("mindmgoverridevalue")
        local activeMindmgValue = mindmgValue
        local v8 = false
        if mindmgOverrideBool and mindmgOverrideBool.Value and mindmgOverrideValue and mindmgOverrideValue:IsA("IntValue") then
            activeMindmgValue = mindmgOverrideValue
            v8 = true
        end
        
        if mindmgBool and mindmgBool.Value and activeMindmgValue and activeMindmgValue:IsA("IntValue") and activeMindmgValue.Value > 0 then
            local v33 = calculateClientDamage(v59, v3, v15)
            local data = hitModel:FindFirstChild("Data")
            local v32 = 0
            if data then
                local armor = data:FindFirstChild("Armor")
                if armor and armor:IsA("IntValue") then v32 = armor.Value end
            end
            local _, _, healthDamage, _ = calculateClientDamageWithArmor(v33, v32, v15)
            local humanoid = hitModel:FindFirstChildOfClass("Humanoid")
            local currentHealth = humanoid and humanoid.Health or 0
            
            if healthDamage < activeMindmgValue.Value and healthDamage < currentHealth then
                if shouldStopRef then shouldStopRef.Value = false end
                return
            else
                if autoStopValue and autoStopValue.Value and isManualShot then
                    shouldStopValue.Value = true
                    shouldStopRef = shouldStopValue
                end
            end
        end
    end
    
    v35 = tick()
    v5 = false
    local sound = shootSound:Clone()
    sound.Parent = player.Character
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
    
    local directionToTarget = (targetPos - rayOrigin).Unit
    local distanceToTarget = (targetPos - rayOrigin).Magnitude
    local endPosWithSpread = rayOrigin + directionToTarget * math.min(distanceToTarget, 160)
    local endPos = endPosWithSpread
    local v107 = {}
    local bulletBlacklist = getCachedBlacklist()
    local directionToTarget = (targetPos - rayOrigin).Unit
    local firstRayResult = workspace:Raycast(rayOrigin, directionToTarget * 160, bulletRayParams)
    
    local function isPointInsidePartFast(part, worldPos)
        if not part or not part:IsA("BasePart") then return false end
        local localPos = part.CFrame:PointToObjectSpace(worldPos)
        local s = part.Size
        return math.abs(localPos.X) <= s.X * 0.5 and math.abs(localPos.Y) <= s.Y * 0.5 and math.abs(localPos.Z) <= s.Z * 0.5
    end
    
    local currentOrigin = rayOrigin
    local currentDirection = directionToTarget
    local v58 = 160
    
    if firstRayResult and firstRayResult.Instance and isPointInsidePartFast(firstRayResult.Instance, rayOrigin) then
        local exitPoint = getExitPoint(firstRayResult.Instance, rayOrigin, directionToTarget)
        if exitPoint then
            local delta = (exitPoint - rayOrigin).Magnitude + 0.01
            currentOrigin = exitPoint + directionToTarget * 0.01
            v58 = math.max(0, 160 - delta)
        end
    end
    
    local realHitModel = hitModel
    local realHitPartName = v15
    local realDistance
    local realEndPos
    
    if realHitModel and realHitPartName then
        realDistance = v59
        realEndPos = rayOrigin + currentDirection * realDistance
    else
        realDistance = v58
        realEndPos = rayOrigin + currentDirection * v58
    end
    
    v3 = false
    local bulletRayResult = nil
    local finalParams = RaycastParams.new()
    finalParams.FilterType = Enum.RaycastFilterType.Exclude
    local v103 = {}
    for _, inst in ipairs(getCachedBlacklist()) do table.insert(v103, inst) end
    for _, pen in ipairs(getPenetrableWhitelist()) do table.insert(v103, pen) end
    for _, nilhit in ipairs(getNilhitpartWhitelist()) do table.insert(v103, nilhit) end
    finalParams.FilterDescendantsInstances = v103
    
    local finalResult = workspace:Raycast(currentOrigin, currentDirection * v58, finalParams)
    bulletRayResult = finalResult
    local visualHitModel = nil
    
    if bulletRayResult then
        visualHitModel = bulletRayResult.Instance:FindFirstAncestorOfClass("Model")
        v59 = (bulletRayResult.Position - rayOrigin).Magnitude
        if isManualShot and not spreadAlreadyApplied then
            endPos = endPosWithSpread
            v59 = (endPos - rayOrigin).Magnitude
        else
            endPos = bulletRayResult.Position
        end
    else
        if isManualShot and not spreadAlreadyApplied then
            endPos = endPosWithSpread
        else
            endPos = currentOrigin + currentDirection * v58
        end
        v59 = (endPos - rayOrigin).Magnitude
    end
    
    local hitUID = nil
    local intendedUID = nil
    if realHitModel then
        local hitPlayer = Players:GetPlayerFromCharacter(realHitModel)
        if hitPlayer and hitPlayer:FindFirstChild("UID") then hitUID = hitPlayer.UID.Value end
    end
    
    if not hitUID then
        local nearest = getClosestPlayer(targetPos)
        if nearest then
            local pl = Players:GetPlayerFromCharacter(nearest)
            if pl and pl:FindFirstChild("UID") then intendedUID = pl.UID.Value end
        end
    end
    
    while v58 > 0 do
        local penetrableResult, hitPos, hitNormal = checkPenetrableAlongRay(currentOrigin, currentDirection, v58, v107)
        if penetrableResult then
            v3 = true
            local entryHole = createBulletHole(hitPos, hitNormal, penetrableResult.Instance, false)
            if entryHole then
                table.insert(v107, entryHole)
                table.insert(bulletBlacklist, entryHole)
                bulletRayParams.FilterDescendantsInstances = bulletBlacklist
            end
            local exitPoint = getExitPoint(penetrableResult.Instance, hitPos, currentDirection)
            if exitPoint then
                local exitHole = createBulletHole(exitPoint, -hitNormal, penetrableResult.Instance, false)
                if exitHole then
                    table.insert(v107, exitHole)
                    table.insert(bulletBlacklist, exitHole)
                    bulletRayParams.FilterDescendantsInstances = bulletBlacklist
                end
                currentOrigin = exitPoint + currentDirection * 0.01
                v58 = v58 - (exitPoint - hitPos).Magnitude - 0.01
            else break end
        else break end
    end
    
    if bulletRayResult then
        local isCharacter = hitModel and hitModel:FindFirstChildOfClass("Humanoid") ~= nil
        local hitHole = createBulletHole(bulletRayResult.Position, bulletRayResult.Normal, bulletRayResult.Instance, isCharacter)
        if hitHole then table.insert(v107, hitHole) end
    end
    
    local startPart = createTempPart(rayOrigin)
    local endPart = createTempPart(realEndPos)
    startPart.Parent = workspace
    endPart.Parent = workspace
    
    local beam = createBeam(startPart, endPart)
    beam.Parent = workspace
    
    if realHitModel and realHitPartName and realHitPartName ~= "Default" then
        local effectModel = realHitModel
        if effectModel and effectModel:FindFirstChild("HumanoidRootPart") then
            local selectedHitSound = getSelectedHitSound()
            if selectedHitSound then
                local sound = selectedHitSound:Clone()
                local hitVolumeValue = player:FindFirstChild("HitVolume")
                local v60 = 1
                if hitVolumeValue and hitVolumeValue:IsA("NumberValue") then
                    v60 = hitVolumeValue.Value; sound.Volume = v60
                else sound.Volume = 1 end
                local hitSpeedValue = player:FindFirstChild("HitSpeed")
                local v61 = 1
                if hitSpeedValue and hitSpeedValue:IsA("NumberValue") then
                    v61 = hitSpeedValue.Value; sound.PlaybackSpeed = v61
                else sound.PlaybackSpeed = 1 end
                sound.Parent = workspace
                sound:Play()
                sound.Ended:Connect(function() sound:Destroy() end)
            end
            
            local selectedHitEffect = getSelectedHitEffect()
            if selectedHitEffect then
                local targetHRP = effectModel:FindFirstChild("HumanoidRootPart")
                if targetHRP then createEffectAtPosition(selectedHitEffect, targetHRP, false) end
            end
            
            local humanoid = effectModel:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local v9 = false
                local healthConnection
                healthConnection = humanoid.HealthChanged:Connect(function(newHealth)
                    if newHealth <= 0 then
                        if v9 then return end
                        v9 = true
                        if healthConnection then healthConnection:Disconnect() end
                        local selectedKillSound = getSelectedKillSound()
                        if selectedKillSound then
                            local killSoundInstance = selectedKillSound:Clone()
                            local killVolumeValue = player:FindFirstChild("KillVolume")
                            local v60 = 1
                            if killVolumeValue and killVolumeValue:IsA("NumberValue") then
                                v60 = killVolumeValue.Value; killSoundInstance.Volume = v60
                            else killSoundInstance.Volume = 1 end
                            local killSpeedValue = player:FindFirstChild("KillSpeed")
                            local v61 = 1
                            if killSpeedValue and killSpeedValue:IsA("NumberValue") then
                                v61 = killSpeedValue.Value; killSoundInstance.PlaybackSpeed = v61
                            else killSoundInstance.PlaybackSpeed = 1 end
                            killSoundInstance.Parent = workspace
                            killSoundInstance:Play()
                            killSoundInstance.Ended:Connect(function() killSoundInstance:Destroy() end)
                        end
                        local selectedKillEffect = getSelectedKillEffect()
                        if selectedKillEffect then
                            local targetHRP = effectModel:FindFirstChild("HumanoidRootPart")
                            if targetHRP then createEffectAtPosition(selectedKillEffect, targetHRP, true) end
                        end
                    end
                end)
                task.delay(1, function() if healthConnection then healthConnection:Disconnect() end end)
            end
            createHitchamsClone(effectModel, v59)
            local hitMarkerPos = nil
            if bulletRayResult and bulletRayResult.Position then hitMarkerPos = bulletRayResult.Position
            elseif realEndPos then hitMarkerPos = realEndPos end
            if hitMarkerPos then createHitMarker(hitMarkerPos) end
        end
    end
    
    local shotTargetName = nil
    if realHitModel then
        local shotTargetPlayer = Players:GetPlayerFromCharacter(realHitModel)
        if shotTargetPlayer then shotTargetName = shotTargetPlayer.Name end
    end
    emitShootedEvent(shotTargetName)
    
    task.delay(0, function()
        if isActTriggered() then return end
        hitModel = realHitModel
        v15 = realHitPartName
        v59 = realDistance
        local endPos = realEndPos
        local safeHitUID = hitUID or "nil"
        local safeHitPartName = v15 or "Default"
        local safePassedThroughPenetrable = v3 == true
        local safeDistance = v59 or 0
        local safeRayOrigin = rayOrigin or Vector3.new(0, 0, 0)
        local safeEndPos = endPos or Vector3.new(0, 0, 0)
        local safeIntendedUID = intendedUID or "nil"
        
        local encryptedData = encryptArgs("Shoot", safeHitUID, safeHitPartName, safePassedThroughPenetrable, safeDistance, safeRayOrigin, safeEndPos, safeIntendedUID)
        if #encryptedData == 0 then return end
        table.insert(v71, { args = encryptedData, timestamp = tick() })
        mainEvent:FireServer(unpack(encryptedData))
        
        local currentTool = findSSGTool()
        if currentTool then
            local cfg = Instance.new("Configuration")
            cfg.Name = "Shoot"
            cfg.Parent = currentTool
        end
        local shouldStop = shouldStopRef or (autoStopValue and autoStopValue.Value and player:FindFirstChild("ShouldStop"))
        if shouldStop then shouldStop.Value = false end
    end)
    
    task.delay(v36, function() if not v6 then v5 = true end end)
end

local v108 = {}
local currentTool = nil
local autoReloadConnection = nil
local v62 = 0
local v63 = 1.0
local v109 = {}
local v10 = false

local function getLocalHRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart") or nil
end

local function getUID(plr)
    local v = plr and plr:FindFirstChild("UID")
    return v and v.Value or nil
end

local function tryStab()
    if isActTriggered() then return end
    local now = tick()
    if now - v62 < v63 then return end
    local char = player.Character
    if not char then return end
    local localFF = char:FindFirstChildOfClass("ForceField")
    if localFF then return end
    
    local tool = char:FindFirstChild("M9")
    if not tool or not tool:IsA("Tool") or tool.Parent ~= char then return end
    local hrp = getLocalHRP()
    if not hrp then return end
    
    local best, bestDist, bestPlr = nil, math.huge, nil
    for _, pl in ipairs(getCachedPlayersList()) do
        if pl ~= player and pl.Character then
            local myTeam = player:GetAttribute("Team")
            local theirTeam = pl:GetAttribute("Team")
            if myTeam and theirTeam and myTeam == theirTeam then else
                local th = pl.Character:FindFirstChild("Humanoid")
                local thrp = pl.Character:FindFirstChild("HumanoidRootPart")
                local ff = pl.Character:FindFirstChildOfClass("ForceField")
                if th and th.Health > 0 and thrp and not ff then
                    local d = (thrp.Position - hrp.Position).Magnitude
                    if d <= 10 and d < bestDist then
                        best, bestDist, bestPlr = thrp, d, pl
                    end
                end
            end
        end
    end
    
    if best and bestPlr then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local v84 = { player.Character }
        local tmpClones = workspace:FindFirstChild("tmp_clones")
        if tmpClones then table.insert(v84, tmpClones) end
        params.FilterDescendantsInstances = v84
        
        local dir = (best.Position - hrp.Position)
        local dist = dir.Magnitude
        if dist <= 0.01 then return end
        local hit = workspace:Raycast(hrp.Position, dir.Unit * dist, params)
        if hit then
            local hitModel = hit.Instance:FindFirstAncestorOfClass("Model")
            if not hitModel or hitModel ~= bestPlr.Character then return end
        end
        
        local uid = getUID(bestPlr)
        if uid then
            if isActTriggered() then return end
            local enc = encryptArgs("Knife", hrp.Position, best.Position, uid)
            if #enc == 0 then return end
            table.insert(v71, { args = enc, timestamp = tick() })
            mainEvent:FireServer(unpack(enc))
            v62 = now
            
            local knifeHit = soundsFolder:FindFirstChild("Knifehit")
            if knifeHit then
                local s = knifeHit:Clone()
                s.Parent = best
                s:Play()
                s.Ended:Connect(function() if s then s:Destroy() end end)
            end
        end
    end
end

local function onKnifeEquip()
    if v10 then return end
    v10 = true
    local hb = RunService.Heartbeat:Connect(function()
        local c = player.Character
        if not c then return end
        local tool = c:FindFirstChild("M9")
        if tool and tool:IsA("Tool") and tool.Parent == c then tryStab() end
    end)
    table.insert(v109, hb)
end

local function onKnifeUnequip()
    for _, conn in ipairs(v109) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    v109 = {}
    v10 = false
end

local function onEquip()
    local character = player.Character
    if not character then return end
    for _, connection in ipairs(v108) do
        if connection and connection.Connected then pcall(function() connection:Disconnect() end) end
    end
    v108 = {}
    currentTool = findSSGTool()
    
    local autoReloadMonitorConnection = nil
    local function setupAutoReload()
        if autoReloadConnection then autoReloadConnection:Disconnect(); autoReloadConnection = nil end
        local tool = findSSGTool()
        if not tool then return end
        local ammoValue = tool:FindFirstChild("Ammo")
        if not ammoValue or not ammoValue:IsA("IntValue") then return end
        
        local autoReloadValue = player:FindFirstChild("AutoReload")
        if not autoReloadValue or not autoReloadValue:IsA("BoolValue") or not autoReloadValue.Value then return end
        
        autoReloadConnection = ammoValue.Changed:Connect(function(newAmmo)
            local autoReloadValue = player:FindFirstChild("AutoReload")
            if not autoReloadValue or not autoReloadValue:IsA("BoolValue") or not autoReloadValue.Value then return end
            if newAmmo == 0 and not v6 then reload() end
        end)
        
        if ammoValue.Value == 0 and not v6 then
            local autoReloadValue = player:FindFirstChild("AutoReload")
            if autoReloadValue and autoReloadValue:IsA("BoolValue") and autoReloadValue.Value then reload() end
        end
    end
    
    local function monitorAutoReload()
        if autoReloadMonitorConnection then autoReloadMonitorConnection:Disconnect(); autoReloadMonitorConnection = nil end
        local autoReloadValue = player:FindFirstChild("AutoReload")
        if autoReloadValue then
            autoReloadMonitorConnection = autoReloadValue.Changed:Connect(function() setupAutoReload() end)
        end
    end
    
    setupAutoReload()
    player.ChildAdded:Connect(function(child)
        if child.Name == "AutoReload" then monitorAutoReload(); setupAutoReload() end
    end)
    monitorAutoReload()
    
    local heartbeatConnection
    local v64 = 0
    local v65 = 0
    local v66 = 0.1
    local v67 = 0.016
    local cachedRageAim = nil
    local cachedAutoShoot = nil
    local cachedBulletStartDebug = nil
    local cachedRaycastDebug = nil
    local cachedSpreadDebug = nil
    local v68 = 0
    local v69 = 0.1
    local lastTool = currentTool
    
    function checkToolChange()
        local newTool = findSSGTool()
        if newTool ~= lastTool then
            lastTool = newTool
            setupAutoReload()
        end
    end
    
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        local currentTool = findSSGTool()
        if not currentTool or currentTool.Parent ~= character then return end
        if currentTool ~= lastTool then lastTool = currentTool; setupAutoReload() end
        
        local now = tick()
        if now - v68 >= v69 then
            v68 = now
            cachedRageAim = character:FindFirstChild("rageaim")
            cachedAutoShoot = character:FindFirstChild("autoshoot")
            cachedBulletStartDebug = player:FindFirstChild("BulletStartDebug")
            cachedRaycastDebug = player:FindFirstChild("RaycastDebug")
            cachedSpreadDebug = player:FindFirstChild("SpreadDebug")
        end
        
        if cachedRageAim and cachedRageAim:IsA("BoolValue") and cachedRageAim.Value then
            if now - v65 >= v66 then
                v65 = now
                local targetPos = getTargetPosition()
            end
        end
        
        if now - v64 < v67 then return end
        v64 = now
        
        if cachedBulletStartDebug and cachedBulletStartDebug.Value then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local center = hrp.CFrame.Position + Vector3.new(0, 1, 0)
                if not bulletStartDebugPart then
                    bulletStartDebugPart = Instance.new("Part")
                    bulletStartDebugPart.Name = "Ignored"
                    bulletStartDebugPart.BrickColor = BrickColor.new("Bright green")
                    bulletStartDebugPart.Transparency = 0
                    bulletStartDebugPart.Anchored = true
                    bulletStartDebugPart.CanCollide = false
                    bulletStartDebugPart.CastShadow = false
                    bulletStartDebugPart.CanQuery = false
                    bulletStartDebugPart.Parent = workspace
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineTransparency = 0
                    highlight.FillTransparency = 0
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineTransparency = 0
                    highlight.Parent = bulletStartDebugPart
                end
                bulletStartDebugPart.Size = Vector3.new(0.6, 0.1, 0.6)
                bulletStartDebugPart.Position = center
                bulletStartDebugPart.CFrame = CFrame.new(center)
            end
        else
            if bulletStartDebugPart then bulletStartDebugPart:Destroy(); bulletStartDebugPart = nil end
        end
        
        if cachedRaycastDebug and cachedRaycastDebug.Value then
            if not debugBeam or not debugAttachment0 or not debugAttachment1 then
                debugAttachment0 = Instance.new("Attachment")
                debugAttachment1 = Instance.new("Attachment")
                debugAttachment0.Parent = workspace.Terrain
                debugAttachment1.Parent = workspace.Terrain
                debugBeam = Instance.new("Beam")
                debugBeam.Attachment0 = debugAttachment0
                debugBeam.Attachment1 = debugAttachment1
                debugBeam.Width0 = 0.25
                debugBeam.Width1 = 0.25
                debugBeam.FaceCamera = true
                debugBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 255))
                debugBeam.Transparency = NumberSequence.new(0)
                debugBeam.Parent = workspace.Terrain
            end
            
            local targetPos
            local rageAim = character:FindFirstChild("rageaim")
            if rageAim and rageAim:IsA("BoolValue") and rageAim.Value then
                targetPos = getTargetPosition()
            else
                local camera = workspace.CurrentCamera
                local mouse = player:GetMouse()
                if mouse and mouse.Hit then
                    local mouseRayUnit = mouse.Hit.LookVector
                    local mouseRayParams = getCachedRaycastParams()
                    local mouseRayResult = workspace:Raycast(camera.CFrame.Position, mouseRayUnit * 1000, mouseRayParams)
                    targetPos = mouseRayResult and mouseRayResult.Position or (camera.CFrame.Position + mouseRayUnit * 1000)
                end
            end
            
            if targetPos then
                local origin = computeNeckFireOrigin(targetPos)
                debugAttachment0.WorldPosition = origin
                local rayResult, endPos = castAimRay(origin, targetPos)
                debugAttachment1.WorldPosition = endPos
                
                if cachedSpreadDebug and cachedSpreadDebug.Value then
                    local currentSpread = getCurrentSpread()
                    if not spreadDebugSphere then
                        spreadDebugSphere = Instance.new("Part")
                        spreadDebugSphere.Name = "Ignored"
                        spreadDebugSphere.Shape = Enum.PartType.Ball
                        spreadDebugSphere.Material = Enum.Material.ForceField
                        spreadDebugSphere.BrickColor = BrickColor.new("White")
                        spreadDebugSphere.Transparency = 0.7
                        spreadDebugSphere.Anchored = true
                        spreadDebugSphere.CanCollide = false
                        spreadDebugSphere.CastShadow = false
                        spreadDebugSphere.CanQuery = false
                        spreadDebugSphere.Parent = workspace
                        spreadDebugBillboard = Instance.new("BillboardGui")
                        spreadDebugBillboard.Name = "SpreadDebugText"
                        spreadDebugBillboard.Size = UDim2.new(0, 200, 0, 100)
                        spreadDebugBillboard.StudsOffset = Vector3.new(0, 2, 0)
                        spreadDebugBillboard.AlwaysOnTop = true
                        spreadDebugBillboard.Adornee = spreadDebugSphere
                        spreadDebugBillboard.Parent = spreadDebugSphere
                        local textLabel = Instance.new("TextLabel")
                        textLabel.Name = "TextLabel"
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.TextColor3 = Color3.new(1, 1, 1)
                        textLabel.TextStrokeTransparency = 0.5
                        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        textLabel.Font = Enum.Font.SourceSans
                        textLabel.TextSize = 14
                        textLabel.TextWrapped = true
                        textLabel.Parent = spreadDebugBillboard
                    end
                    spreadDebugSphere.Position = endPos
                    spreadDebugSphere.Size = Vector3.new(currentSpread * 2, currentSpread * 2, currentSpread * 2)
                    
                    if spreadDebugBillboard then
                        local textLabel = spreadDebugBillboard:FindFirstChild("TextLabel")
                        if textLabel then
                            local hitchanceValue = player:FindFirstChild("Hitchance")
                            local hitchanceOverrideBool = player:FindFirstChild("hitchanceoverride")
                            local hitchanceOverrideValue = player:FindFirstChild("hitchanceoverridevalue")
                            local activeHitchanceValue = hitchanceValue
                            if hitchanceOverrideBool and hitchanceOverrideBool.Value and hitchanceOverrideValue and hitchanceOverrideValue:IsA("IntValue") then
                                activeHitchanceValue = hitchanceOverrideValue
                            end
                            local v70 = 0
                            if activeHitchanceValue and activeHitchanceValue:IsA("IntValue") then v70 = activeHitchanceValue.Value end
                            local v22 = 0.2
                            local maxAllowedSpread = v22 + (v72.MaxSpread - v22) * (1 - v70 / 100)
                            local currentSpreadRounded = math.floor(currentSpread * 10 + 0.5) / 10
                            local maxAllowedSpreadRounded = math.floor(maxAllowedSpread * 10 + 0.5) / 10
                            textLabel.Text = string.format("Hitchance: %.1f\nCurrent: %.1f", maxAllowedSpreadRounded, currentSpreadRounded)
                        end
                    end
                else
                    if spreadDebugSphere then spreadDebugSphere:Destroy(); spreadDebugSphere = nil; spreadDebugBillboard = nil end
                end
                
                local hitInstance = rayResult and rayResult.Instance
                local hitModel = hitInstance and hitInstance:FindFirstAncestorOfClass("Model")
                local hitIsCharacter = hitModel and hitModel:FindFirstChildOfClass("Humanoid") ~= nil
                local reachedTarget = (rayResult == nil) or ((endPos - targetPos).Magnitude <= 0.3)
                local v11 = true
                
                if hitIsCharacter and hitModel then
                    local mindmgBool = player:FindFirstChild("MindmgBool")
                    local mindmgValue = player:FindFirstChild("Mindmg")
                    local mindmgOverrideBool = player:FindFirstChild("mindmgoverride")
                    local mindmgOverrideValue = player:FindFirstChild("mindmgoverridevalue")
                    local activeMindmgValue = mindmgValue
                    if mindmgOverrideBool and mindmgOverrideBool.Value and mindmgOverrideValue and mindmgOverrideValue:IsA("IntValue") then activeMindmgValue = mindmgOverrideValue end
                    if mindmgBool and mindmgBool.Value and activeMindmgValue and activeMindmgValue:IsA("IntValue") and activeMindmgValue.Value > 0 then
                        local direction = (endPos - origin).Unit
                        local v59 = (endPos - origin).Magnitude
                        local v3 = false
                        local v15 = getBodyPartName(rayResult.Instance)
                        local v33 = calculateClientDamage(v59, v3, v15)
                        local data = hitModel:FindFirstChild("Data")
                        local v32 = 0
                        if data then
                            local armor = data:FindFirstChild("Armor")
                            if armor and armor:IsA("IntValue") then v32 = armor.Value end
                        end
                        local _, _, healthDamage, _ = calculateClientDamageWithArmor(v33, v32, v15)
                        local humanoid = hitModel:FindFirstChildOfClass("Humanoid")
                        local currentHealth = humanoid and humanoid.Health or 0
                        if healthDamage < activeMindmgValue.Value and healthDamage < currentHealth then v11 = false end
                    end
                end
                
                if reachedTarget or hitIsCharacter then
                    if v11 then debugBeam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
                    else debugBeam.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0)) end
                else debugBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)) end
            end
        else
            if debugBeam then
                debugBeam:Destroy(); debugAttachment0:Destroy(); debugAttachment1:Destroy()
                debugBeam, debugAttachment0, debugAttachment1 = nil, nil, nil
            end
            v34 = 0
        end
        
        if cachedSpreadDebug and cachedSpreadDebug.Value then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPos
                local rageAim = character:FindFirstChild("rageaim")
                if rageAim and rageAim:IsA("BoolValue") and rageAim.Value then targetPos = getTargetPosition()
                else
                    local camera = workspace.CurrentCamera
                    local mouse = player:GetMouse()
                    if mouse and mouse.Hit then
                        local mouseRayUnit = mouse.Hit.LookVector
                        local mouseRayParams = getCachedRaycastParams()
                        local mouseRayResult = workspace:Raycast(camera.CFrame.Position, mouseRayUnit * 1000, mouseRayParams)
                        targetPos = mouseRayResult and mouseRayResult.Position or (camera.CFrame.Position + mouseRayUnit * 1000)
                    end
                end
                if targetPos then
                    local origin = computeNeckFireOrigin(targetPos)
                    local rayResult, endPos = castAimRay(origin, targetPos)
                    local currentSpread = getCurrentSpread()
                    if not spreadDebugSphere then
                        spreadDebugSphere = Instance.new("Part")
                        spreadDebugSphere.Name = "Ignored"
                        spreadDebugSphere.Shape = Enum.PartType.Ball
                        spreadDebugSphere.Material = Enum.Material.ForceField
                        spreadDebugSphere.BrickColor = BrickColor.new("White")
                        spreadDebugSphere.Transparency = 0.7
                        spreadDebugSphere.Anchored = true
                        spreadDebugSphere.CanCollide = false
                        spreadDebugSphere.CastShadow = false
                        spreadDebugSphere.CanQuery = false
                        spreadDebugSphere.Parent = workspace
                        spreadDebugBillboard = Instance.new("BillboardGui")
                        spreadDebugBillboard.Name = "SpreadDebugText"
                        spreadDebugBillboard.Size = UDim2.new(0, 200, 0, 100)
                        spreadDebugBillboard.StudsOffset = Vector3.new(0, 2, 0)
                        spreadDebugBillboard.AlwaysOnTop = true
                        spreadDebugBillboard.Adornee = spreadDebugSphere
                        spreadDebugBillboard.Parent = spreadDebugSphere
                        local textLabel = Instance.new("TextLabel")
                        textLabel.Name = "TextLabel"
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.TextColor3 = Color3.new(1, 1, 1)
                        textLabel.TextStrokeTransparency = 0.5
                        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        textLabel.Font = Enum.Font.SourceSans
                        textLabel.TextSize = 14
                        textLabel.TextWrapped = true
                        textLabel.Parent = spreadDebugBillboard
                    end
                    spreadDebugSphere.Position = endPos
                    spreadDebugSphere.Size = Vector3.new(currentSpread * 2, currentSpread * 2, currentSpread * 2)
                    
                    if spreadDebugBillboard then
                        local textLabel = spreadDebugBillboard:FindFirstChild("TextLabel")
                        if textLabel then
                            local hitchanceValue = player:FindFirstChild("Hitchance")
                            local hitchanceOverrideBool = player:FindFirstChild("hitchanceoverride")
                            local hitchanceOverrideValue = player:FindFirstChild("hitchanceoverridevalue")
                            local activeHitchanceValue = hitchanceValue
                            if hitchanceOverrideBool and hitchanceOverrideBool.Value and hitchanceOverrideValue and hitchanceOverrideValue:IsA("IntValue") then
                                activeHitchanceValue = hitchanceOverrideValue
                            end
                            local v70 = 0
                            if activeHitchanceValue and activeHitchanceValue:IsA("IntValue") then v70 = activeHitchanceValue.Value end
                            local v22 = 0.2
                            local maxAllowedSpread = v22 + (v72.MaxSpread - v22) * (1 - v70 / 100)
                            local currentSpreadRounded = math.floor(currentSpread * 10 + 0.5) / 10
                            local maxAllowedSpreadRounded = math.floor(maxAllowedSpread * 10 + 0.5) / 10
                            textLabel.Text = string.format("Hitchance: %.1f\nCurrent: %.1f", maxAllowedSpreadRounded, currentSpreadRounded)
                        end
                    end
                end
            end
        else
            if spreadDebugSphere then spreadDebugSphere:Destroy(); spreadDebugSphere = nil; spreadDebugBillboard = nil end
        end
        
        if not cachedAutoShoot or not cachedAutoShoot:IsA("BoolValue") or not cachedAutoShoot.Value then return end
        
        local targetPos
        if cachedRageAim and cachedRageAim:IsA("BoolValue") and cachedRageAim.Value then
            targetPos = getTargetPosition()
            if targetPos == Vector3.new(0,0,0) then return end
        else
            if isMobile then return else
                local camera = workspace.CurrentCamera
                local mouse = player:GetMouse()
                if mouse and mouse.Hit then
                    local mouseRayUnit = mouse.Hit.LookVector
                    local mouseRayParams = getCachedRaycastParams()
                    local mouseRayResult = workspace:Raycast(camera.CFrame.Position, mouseRayUnit * 1000, mouseRayParams)
                    targetPos = mouseRayResult and mouseRayResult.Position or (camera.CFrame.Position + mouseRayUnit * 1000)
                else return end
            end
        end
        
        local rayOrigin = computeNeckFireOrigin(targetPos)
        local originalTargetPos = targetPos
        local v59 = (targetPos - rayOrigin).Magnitude
        if v59 <= 160 then
            local rayResult = castAimRay(rayOrigin, targetPos)
            local hitModel = nil
            if rayResult then hitModel = rayResult.Instance and rayResult.Instance:FindFirstAncestorOfClass("Model") end
            local isPlayerHit = hitModel and hitModel:FindFirstChildOfClass("Humanoid") ~= nil
            
            if isPlayerHit then
                if not checkTargetPositionSync(hitModel) then
                    local currentAutoStop = player:FindFirstChild("AutoStop")
                    if currentAutoStop and currentAutoStop.Value == true then
                        local currentShouldStop = player:FindFirstChild("ShouldStop")
                        if currentShouldStop then currentShouldStop.Value = false end
                    end
                    return
                end
                
                local v11 = true
                local mindmgBool = player:FindFirstChild("MindmgBool")
                local mindmgValue = player:FindFirstChild("Mindmg")
                local mindmgOverrideBool = player:FindFirstChild("mindmgoverride")
                local mindmgOverrideValue = player:FindFirstChild("mindmgoverridevalue")
                local activeMindmgValue = mindmgValue
                if mindmgOverrideBool and mindmgOverrideBool.Value and mindmgOverrideValue and mindmgOverrideValue:IsA("IntValue") then activeMindmgValue = mindmgOverrideValue end
                
                if mindmgBool and mindmgBool.Value and activeMindmgValue and activeMindmgValue:IsA("IntValue") and activeMindmgValue.Value > 0 then
                    local direction = (targetPos - rayOrigin).Unit
                    local hitDistance = rayResult and (rayResult.Position - rayOrigin).Magnitude or v59
                    local v3 = false
                    local v15 = rayResult and getBodyPartName(rayResult.Instance) or "Default"
                    local v33 = calculateClientDamage(hitDistance, v3, v15)
                    local data = hitModel:FindFirstChild("Data")
                    local v32 = 0
                    if data then
                        local armor = data:FindFirstChild("Armor")
                        if armor and armor:IsA("IntValue") then v32 = armor.Value end
                    end
                    local _, _, healthDamage, _ = calculateClientDamageWithArmor(v33, v32, v15)
                    local humanoid = hitModel:FindFirstChildOfClass("Humanoid")
                    local currentHealth = humanoid and humanoid.Health or 0
                    if healthDamage < activeMindmgValue.Value and healthDamage < currentHealth then v11 = false end
                end
                
                if v11 then
                    local currentSpread = getCurrentSpread()
                    local hitchanceValue = player:FindFirstChild("Hitchance")
                    local hitchanceOverrideBool = player:FindFirstChild("hitchanceoverride")
                    local hitchanceOverrideValue = player:FindFirstChild("hitchanceoverridevalue")
                    local activeHitchanceValue = hitchanceValue
                    if hitchanceOverrideBool and hitchanceOverrideBool.Value and hitchanceOverrideValue and hitchanceOverrideValue:IsA("IntValue") then activeHitchanceValue = hitchanceOverrideValue end
                    local maxAllowedSpread = math.huge
                    if activeHitchanceValue and activeHitchanceValue:IsA("IntValue") then
                        local v70 = activeHitchanceValue.Value
                        local v22 = 0.2
                        maxAllowedSpread = v22 + (v72.MaxSpread - v22) * (1 - v70 / 100)
                    end
                    
                    local currentAutoStop = player:FindFirstChild("AutoStop")
                    if currentAutoStop and currentAutoStop.Value == true then
                        local currentShouldStop = player:FindFirstChild("ShouldStop")
                        if not currentShouldStop then
                            currentShouldStop = Instance.new("BoolValue")
                            currentShouldStop.Name = "ShouldStop"
                            currentShouldStop.Value = false
                            currentShouldStop.Parent = player
                        end
                        if currentSpread > maxAllowedSpread then
                            currentShouldStop.Value = true
                            shouldStopValue = currentShouldStop
                            return
                        else
                            local spreadTargetPos = applySpread(targetPos, rayOrigin, currentSpread)
                            performShot(rayOrigin, spreadTargetPos, true, false, currentShouldStop, nil, false, nil, hitModel)
                        end
                    else
                        if currentSpread <= maxAllowedSpread then
                            local spreadTargetPos = applySpread(targetPos, rayOrigin, currentSpread)
                            performShot(rayOrigin, spreadTargetPos, true, false, nil, nil, false, nil, hitModel)
                        end
                    end
                else
                    local currentAutoStop = player:FindFirstChild("AutoStop")
                    if currentAutoStop and currentAutoStop.Value == true then
                        local currentShouldStop = player:FindFirstChild("ShouldStop")
                        if currentShouldStop then currentShouldStop.Value = false end
                    end
                end
            else
                local currentAutoStop = player:FindFirstChild("AutoStop")
                if currentAutoStop and currentAutoStop.Value == true then
                    local currentShouldStop = player:FindFirstChild("ShouldStop")
                    if currentShouldStop then currentShouldStop.Value = false end
                end
            end
        end
    end)
    table.insert(v108, heartbeatConnection)
    
    local mouseConnection
    if isMobile then
        mouseConnection = UserInputService.TouchStarted:Connect(function(touch, gameProcessedEvent) return end)
    else
        mouseConnection = mouse.Button1Down:Connect(function() return end)
    end
    table.insert(v108, mouseConnection)
    
    local inputConnection
    inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == Enum.KeyCode.R then reload() end
    end)
    table.insert(v108, inputConnection)
end

function onUnequip()
    for _, connection in ipairs(v108) do
        if connection and connection.Connected then pcall(function() connection:Disconnect() end) end
    end
    v108 = {}
    currentTool = nil
    if autoReloadConnection then autoReloadConnection:Disconnect(); autoReloadConnection = nil end
    if spreadDebugSphere then spreadDebugSphere:Destroy(); spreadDebugSphere = nil; spreadDebugBillboard = nil end
    if bulletStartDebugPart then bulletStartDebugPart:Destroy(); bulletStartDebugPart = nil end
end

player.CharacterAdded:Connect(function()
    local character = player.Character
    if character then
        character.ChildAdded:Connect(function(child)
            if child.Name == "SSG-08" and child:IsA("Tool") then onEquip()
            elseif child.Name == "M9" and child:IsA("Tool") then onKnifeEquip() end
        end)
        character.ChildRemoved:Connect(function(child)
            if child.Name == "SSG-08" and child:IsA("Tool") then onUnequip()
            elseif child.Name == "M9" and child:IsA("Tool") then onKnifeUnequip() end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr) destroyRealBodyDebug(plr) end)

if player.Character then
    local character = player.Character
    if character then
        local existingTool = character:FindFirstChild("SSG-08")
        if existingTool and existingTool:IsA("Tool") then onEquip() end
        local existingKnife = character:FindFirstChild("M9")
        if existingKnife and existingKnife:IsA("Tool") then onKnifeEquip() end
        
        character.ChildAdded:Connect(function(child)
            if child.Name == "SSG-08" and child:IsA("Tool") then onEquip()
            elseif child.Name == "M9" and child:IsA("Tool") then onKnifeEquip() end
        end)
        character.ChildRemoved:Connect(function(child)
            if child.Name == "SSG-08" and child:IsA("Tool") then onUnequip()
            elseif child.Name == "M9" and child:IsA("Tool") then onKnifeUnequip() end
        end)
    end
end
]=]

    local v6, v7 = ShopAssistantLoader(script2_source)
    if v6 then
        local v8, v9 = pcall(v6)
        if not v8 then warn("Error in script 2:", v9) end
    else
        warn("Compile error in script 2:", v7)
    end

    --@region: SCRIPT_3_DESYNC_AND_SYNC
    local script3_source = [=[
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local v1 = false
local v5 = {
    RADIUS = 15, DT_RADIUS = 20, DT_SPAM_RADIUS = 10, MISMATCH_THRESHOLD = 2, POS_MISMATCH_TIME = 0.2, RADIUS_KICK = {TIME = 3, DISTANCE = 10}, POS_KICK = {TIME = 3}
}
local v3 = 0
local outTime, missTime, staticTime = 0, 0, 0
local lastSPos = Vector3.new(0,0,0)
local lastTick, lastDTToggle = tick(), 0
local v2 = false

if v1 then
    v1 = Instance.new("ScreenGui")
    v1.Parent = LP:WaitForChild("PlayerGui")
    v1.ResetOnSpawn = false
    v2 = Instance.new("Frame")
    v2.Size = UDim2.new(0,200,0,60)
    v2.Position = UDim2.new(0,10,0.5,-30)
    v2.BackgroundColor3 = Color3.new(0,0,0)
    v2.BackgroundTransparency = 0.3
    v2.BorderSizePixel = 0
    v2.Parent = v1
    v3 = Instance.new("TextLabel")
    v3.Size = UDim2.new(1,0,1,0)
    v3.BackgroundTransparency = 1
    v3.Text = "Radius missmatch\n0 studs 0.0s"
    v3.TextColor3 = Color3.new(1,1,1)
    v3.Font = Enum.Font.Gotham
    v3.TextSize = 14
    v3.Parent = v2
    v4 = Instance.new("Frame")
    v4.Size = UDim2.new(0,200,0,60)
    v4.Position = UDim2.new(1,-210,0.5,-30)
    v4.BackgroundColor3 = Color3.new(0,0,0)
    v4.BackgroundTransparency = 0.3
    v4.BorderSizePixel = 0
    v4.Parent = v1
    v5 = Instance.new("TextLabel")
    v5.Size = UDim2.new(1,0,1,0)
    v5.BackgroundTransparency = 1
    v5.Text = "Pos missmatch\n0 studs 0.0s"
    v5.TextColor3 = Color3.new(1,1,1)
    v5.Font = Enum.Font.Gotham
    v5.TextSize = 14
    v5.Parent = v4
    sph = Instance.new("Part")
    sph.Shape = Enum.PartType.Ball
    sph.Size = Vector3.new(v5.RADIUS*2,v5.RADIUS*2,v5.RADIUS*2)
    sph.Material = Enum.Material.ForceField
    sph.BrickColor = BrickColor.new("Lime green")
    sph.Anchored = true
    sph.CanCollide = false
    sph.CastShadow = false
    sph.Parent = workspace
end

local DT = LP:WaitForChild("DT")
DT:GetPropertyChangedSignal("Value"):Connect(function()
    if not DT.Value then
        if tick() - lastDTToggle < 0.5 then v2 = true end
        lastDTToggle = tick()
        v3 = tick() + 0.5
    end
end)

local function Kick(reason)
    game:GetService("ReplicatedStorage"):WaitForChild("MainEvent").Parent = nil
    local plr = game:GetService("Players").LocalPlayer
    local v4 = 0/0
    print(reason)
    pcall(function() game:GetService("Players").LocalPlayer:Kick(reason) end)
    pcall(function() swimmylove() end)
end

RS.Heartbeat:Connect(function()
    local curTime = tick()
    local delta = curTime - lastTick
    lastTick = curTime
    local curRad = v5.RADIUS
    if tick() < v3 then
        curRad = v2 and v5.DT_SPAM_RADIUS or v5.DT_RADIUS
    else
        v2 = false
    end
    
    local sPos
    repeat
        sPos = LP:GetAttribute("Pos")
        if not sPos then RS.Heartbeat:Wait() end
    until sPos
    
    if v1 then
        sph.Size = Vector3.new(curRad*2,curRad*2,curRad*2)
        sph.Position = sPos
    end
    
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local cPos = LP.Character.HumanoidRootPart.Position
        local dist = (cPos - sPos).Magnitude
        local outDist = math.floor(dist - curRad)
        
        if outDist > 0 then
            outTime = outTime + delta
            if v1 then
                v3.Text = "Radius missmatch\n"..outDist.." studs "..string.format("%.1f", outTime).."s"
                sph.BrickColor = BrickColor.new("Really red")
            end
            if outTime > v5.RADIUS_KICK.TIME and outDist > v5.RADIUS_KICK.DISTANCE then kick("Desync (Radius missmatch: "..outDist.." studs)") end
        else
            outTime = 0
            if v1 then v3.Text = "Radius missmatch\n0 studs 0.0s" end
        end
        
        if sPos == lastSPos then staticTime = staticTime + delta else staticTime = 0 end
        local missDist = math.floor((cPos - sPos).Magnitude)
        
        if staticTime > v5.POS_MISMATCH_TIME and missDist > v5.MISMATCH_THRESHOLD then
            missTime = missTime + delta
            if v1 then
                v5.Text = "Pos missmatch\n"..missDist.." studs "..string.format("%.1f", missTime).."s"
                sph.BrickColor = BrickColor.new("Bright orange")
            end
            if missTime > v5.POS_KICK.TIME then kick("Desync (Pos missmatch: "..missDist.." studs)") end
        else
            missTime = 0
            if v1 then
                v5.Text = "Pos missmatch\n0 studs 0.0s"
                if outDist <= 0 then sph.BrickColor = BrickColor.new("Lime green") end
            end
        end
        lastSPos = sPos
    end
end)

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
RS.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP then
            local serverPos = player:GetAttribute("Pos")
            if serverPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local clientPos = hrp.Position
                if (serverPos - clientPos).Magnitude > 10 then
                    hrp.CFrame = CFrame.new(serverPos) * CFrame.Angles( math.rad(hrp.Orientation.X), math.rad(hrp.Orientation.Y), math.rad(hrp.Orientation.Z) )
                end
            end
        end
    end
end)
]=]

    local v10, v11 = ShopAssistantLoader(script3_source)
    if v10 then
        local v12, v13 = pcall(v10)
        if not v12 then warn("Error in script 3:", v13) return end
    else
        warn("Compile error in script 3:", v11)
    end
end)()
