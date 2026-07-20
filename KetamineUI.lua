local KetamineUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuysModz/GuyzModzScheduleITrainer/refs/heads/main/KetamineUI.lua?" .. math.random(1, 99999)))()
local Window = KetamineUI:CreateWindow({
    Name = "Rivals",
    Subtitle = "v1.0 | Ketamine"
})

Window.Scrolling = true
local AimTab = Window:CreateTab("Aimbot")
local ESPTab = Window:CreateTab("ESP")
local MiscTab = Window:CreateTab("Misc")
local UnlockAllTab = Window:CreateTab("Unlock All")
local SpooferTab = Window:CreateTab("Spoofer")
local ExtrasTab = Window:CreateTab("Extras")
local WeaponTab = ExtrasTab
local SilentAimTab = ExtrasTab

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local HttpService = game:GetService("HttpService")

----------------------------------------------------------------------
-- Config
----------------------------------------------------------------------
local config = {
    aimbot = {
        enabled = false,
        fov_enabled = true,
        fov_range = 250,
        smoothing = 2,
        aim_part = "Head",
        keybind = Enum.KeyCode.LeftAlt,
        visible_check = true,
        team_check = true,
    },
    triggerbot = {
        enabled = false,
        delay = 0.03,
    },
    esp = {
        boxes = false,
        names = false,
        tracers = false,
        distance = false,
        healthbar = false,
        highlight = false,
        headdot = false,
        weapon = false,
        skeleton = false,
        viewangles = false,
        offarrows = false,
        brackets = false,
        chams_fill = Color3.new(0,1,0),
        chams_outline = Color3.new(0,0,1),
        chams_trans = 0.5,
    },
    misc = {
        crosshair = false,
        crosshair_size = 10,
        crosshair_color = Color3.fromRGB(0, 255, 0),
        crosshair_gap = 3,
        spinbot = false,
        spin_speed = 15,
        hit_sound = false,
        kill_counter = false,
        fly = false,
        fly_speed = 50,
        noclip = false,
        fov_changer = false,
        fov_value = 70,
        third_person = false,
        tp_distance = 8,
        radar = false,
        radar_size = 120,
        radar_range = 100,
        speed = false,
        speed_value = 16,
        anti_afk = true,
    },
}

----------------------------------------------------------------------
-- Settings Save/Load
----------------------------------------------------------------------
local SETTINGS_FILE = "KetamineRivals.json"

local function saveConfig()
    pcall(function()
        local data = {
            aimbot_enabled = config.aimbot.enabled,
            aimbot_fov_enabled = config.aimbot.fov_enabled,
            aimbot_fov_range = config.aimbot.fov_range,
            aimbot_smoothing = config.aimbot.smoothing,
            aimbot_aim_part = config.aimbot.aim_part,
            aimbot_keybind = config.aimbot.keybind and config.aimbot.keybind.Name or "MouseButton2",
            aimbot_visible_check = config.aimbot.visible_check,
            aimbot_team_check = config.aimbot.team_check,
            triggerbot_enabled = config.triggerbot.enabled,
            triggerbot_delay = config.triggerbot.delay,
            esp_boxes = config.esp.boxes,
            esp_names = config.esp.names,
            esp_tracers = config.esp.tracers,
            esp_distance = config.esp.distance,
            esp_healthbar = config.esp.healthbar,
            esp_highlight = config.esp.highlight,
            esp_headdot = config.esp.headdot,
            esp_weapon = config.esp.weapon,
            esp_skeleton = config.esp.skeleton,
            esp_viewangles = config.esp.viewangles,
            esp_offarrows = config.esp.offarrows,
            esp_brackets = config.esp.brackets,
            esp_chams_fill = config.esp.chams_fill,
            esp_chams_outline = config.esp.chams_outline,
            esp_chams_trans = config.esp.chams_trans,
            misc_crosshair = config.misc.crosshair,
            misc_crosshair_size = config.misc.crosshair_size,
            misc_crosshair_color = config.misc.crosshair_color,
            misc_crosshair_gap = config.misc.crosshair_gap,
            misc_spinbot = config.misc.spinbot,
            misc_spin_speed = config.misc.spin_speed,
            misc_hit_sound = config.misc.hit_sound,
            misc_kill_counter = config.misc.kill_counter,
            misc_fly = config.misc.fly,
            misc_fly_speed = config.misc.fly_speed,
            misc_noclip = config.misc.noclip,
            misc_fov_changer = config.misc.fov_changer,
            misc_fov_value = config.misc.fov_value,
            misc_third_person = config.misc.third_person,
            misc_tp_distance = config.misc.tp_distance,
            misc_radar = config.misc.radar,
            misc_radar_size = config.misc.radar_size,
            misc_radar_range = config.misc.radar_range,
            misc_speed = config.misc.speed,
            misc_speed_value = config.misc.speed_value,
            misc_anti_afk = config.misc.anti_afk,
        }
        writefile(SETTINGS_FILE, HttpService:JSONEncode(data))
    end)
end

pcall(function()
    if isfile(SETTINGS_FILE) then
        local data = HttpService:JSONDecode(readfile(SETTINGS_FILE))
        if data.aimbot_enabled ~= nil then config.aimbot.enabled = data.aimbot_enabled end
        if data.aimbot_fov_enabled ~= nil then config.aimbot.fov_enabled = data.aimbot_fov_enabled end
        if data.aimbot_fov_range then config.aimbot.fov_range = data.aimbot_fov_range end
        if data.aimbot_smoothing then config.aimbot.smoothing = data.aimbot_smoothing end
        if data.aimbot_aim_part then config.aimbot.aim_part = data.aimbot_aim_part end
        if data.aimbot_keybind then
            if data.aimbot_keybind == "MouseButton2" then
                config.aimbot.keybind = nil
            else
                pcall(function() config.aimbot.keybind = Enum.KeyCode[data.aimbot_keybind] end)
            end
        end
        if data.aimbot_visible_check ~= nil then config.aimbot.visible_check = data.aimbot_visible_check end
        if data.aimbot_team_check ~= nil then config.aimbot.team_check = data.aimbot_team_check end
        if data.triggerbot_enabled ~= nil then config.triggerbot.enabled = data.triggerbot_enabled end
        if data.triggerbot_delay then config.triggerbot.delay = data.triggerbot_delay end
        if data.esp_boxes ~= nil then config.esp.boxes = data.esp_boxes end
        if data.esp_names ~= nil then config.esp.names = data.esp_names end
        if data.esp_tracers ~= nil then config.esp.tracers = data.esp_tracers end
        if data.esp_distance ~= nil then config.esp.distance = data.esp_distance end
        if data.esp_healthbar ~= nil then config.esp.healthbar = data.esp_healthbar end
        if data.esp_highlight ~= nil then config.esp.highlight = data.esp_highlight end
        if data.esp_headdot ~= nil then config.esp.headdot = data.esp_headdot end
        if data.esp_weapon ~= nil then config.esp.weapon = data.esp_weapon end
        if data.esp_skeleton ~= nil then config.esp.skeleton = data.esp_skeleton end
        if data.esp_viewangles ~= nil then config.esp.viewangles = data.esp_viewangles end
        if data.esp_offarrows ~= nil then config.esp.offarrows = data.esp_offarrows end
        if data.esp_brackets ~= nil then config.esp.brackets = data.esp_brackets end
        if data.misc_crosshair ~= nil then config.misc.crosshair = data.misc_crosshair end
        if data.misc_crosshair_size then config.misc.crosshair_size = data.misc_crosshair_size end
        if data.misc_crosshair_color then config.misc.crosshair_color = data.misc_crosshair_color end
        if data.misc_crosshair_gap then config.misc.crosshair_gap = data.misc_crosshair_gap end
        if data.misc_spinbot ~= nil then config.misc.spinbot = data.misc_spinbot end
        if data.misc_spin_speed then config.misc.spin_speed = data.misc_spin_speed end
        if data.misc_hit_sound ~= nil then config.misc.hit_sound = data.misc_hit_sound end
        if data.misc_kill_counter ~= nil then config.misc.kill_counter = data.misc_kill_counter end
        if data.misc_fly ~= nil then config.misc.fly = data.misc_fly end
        if data.misc_fly_speed then config.misc.fly_speed = data.misc_fly_speed end
        if data.misc_noclip ~= nil then config.misc.noclip = data.misc_noclip end
        if data.misc_fov_changer ~= nil then config.misc.fov_changer = data.misc_fov_changer end
        if data.misc_fov_value then config.misc.fov_value = data.misc_fov_value end
        if data.misc_third_person ~= nil then config.misc.third_person = data.misc_third_person end
        if data.misc_tp_distance then config.misc.tp_distance = data.misc_tp_distance end
        if data.misc_radar ~= nil then config.misc.radar = data.misc_radar end
        if data.misc_radar_size then config.misc.radar_size = data.misc_radar_size end
        if data.misc_radar_range then config.misc.radar_range = data.misc_radar_range end
        if data.misc_speed ~= nil then config.misc.speed = data.misc_speed end
        if data.misc_speed_value then config.misc.speed_value = data.misc_speed_value end
        if data.misc_anti_afk ~= nil then config.misc.anti_afk = data.misc_anti_afk end
    end
end)

-- State + Drawing + Helpers + ESP + Aimbot + Main Loops
local scriptActive = true
local Holding = false
local Connections = {}
local ESPObjects = {}
local HighlightInstances = {}
local espFrameCounter = 0
local spinAngle = 0
local killCount = 0
local Flying = false
local FlyBody = nil
local FlyGyro = nil
local RadarDots = {}

-- Kill Counter Text (declared early so Destroy Script callback can reference it)
local KillCounterText = Drawing.new("Text")
KillCounterText.Size = 22
KillCounterText.Font = 2
KillCounterText.Color = Color3.fromRGB(255, 50, 50)
KillCounterText.OutlineColor = Color3.new(0, 0, 0)
KillCounterText.Outline = true
KillCounterText.Center = true
KillCounterText.Visible = false

-- FOV CIRCLE: single authoritative instance used by both aimbot and silent aim
-- FIX: was declared twice (once here, once in the Silent Aim module), causing flickering
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(170, 85, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false

-- Separate circle for Silent Aim FOV so they don't conflict
local SilentAimFOVCircle = Drawing.new("Circle")
SilentAimFOVCircle.Thickness = 2
SilentAimFOVCircle.Color = Color3.fromRGB(255, 85, 85)
SilentAimFOVCircle.Filled = false
SilentAimFOVCircle.Transparency = 0.75
SilentAimFOVCircle.Visible = false

local CrosshairLines = {}
for i = 1, 4 do
    CrosshairLines[i] = Drawing.new("Line")
    CrosshairLines[i].Thickness = 1.5
    CrosshairLines[i].Color = config.misc.crosshair_color
    CrosshairLines[i].Visible = false
end

local RadarBG = Drawing.new("Square")
RadarBG.Filled = true
RadarBG.Color = Color3.fromRGB(20, 20, 20)
RadarBG.Transparency = 0.7
RadarBG.Visible = false

local RadarBorder = Drawing.new("Square")
RadarBorder.Filled = false
RadarBorder.Color = Color3.fromRGB(170, 85, 255)
RadarBorder.Thickness = 1.5
RadarBorder.Visible = false

local RadarCenter = Drawing.new("Circle")
RadarCenter.Filled = true
RadarCenter.Color = Color3.fromRGB(0, 255, 0)
RadarCenter.Radius = 3
RadarCenter.Visible = false

local function getCharacter(player)
    local char = player and player.Character
    if char and char.Parent then return char end
    return nil
end

local function isAlive(player)
    local char = getCharacter(player)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health <= 0 then return false end
    if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    if root.Position.Y < -500 then return false end
    return true
end

local function isEnemy(player)
    if player == LocalPlayer then return false end
    if not isAlive(player) then return false end
    if config.aimbot.team_check then
        if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return false end
    end
    return true
end

local function isVisible(origin, targetPart)
    if not config.aimbot.visible_check then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local myChar = getCharacter(LocalPlayer)
    rayParams.FilterDescendantsInstances = myChar and {myChar} or {}
    rayParams.IgnoreWater = true
    local dir = (targetPart.Position - origin)
    local result = Workspace:Raycast(origin, dir, rayParams)
    if not result then return true end
    local hit = result.Instance
    if hit:IsDescendantOf(targetPart.Parent) then return true end
    if hit.Transparency >= 0.5 then return true end
    if not hit.CanCollide then return true end
    local model = hit:FindFirstAncestorOfClass("Model")
    if model and model == targetPart.Parent then return true end
    return false
end

local function getClosestTarget()
    Camera = Workspace.CurrentCamera
    local closest = nil
    local closestDist = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local char = getCharacter(player)
            local targetPart = char and (char:FindFirstChild(config.aimbot.aim_part) or char:FindFirstChild("HumanoidRootPart"))
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < config.aimbot.fov_range and dist < closestDist then
                        if isVisible(Camera.CFrame.Position, targetPart) then
                            closest = targetPart
                            closestDist = dist
                        end
                    end
                end
            end
        end
    end
    return closest
end

----------------------------------------------------------------------
-- HELPERS FOR ESP
----------------------------------------------------------------------
local function WorldToScreen(worldPos)
    local vec, onScreen = Camera:WorldToViewportPoint(worldPos)
    return Vector2.new(vec.X, vec.Y), onScreen
end

local function GetParts(char)
    local parts = {}
    local partNames = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
        "HumanoidRootPart"
    }
    for _, name in ipairs(partNames) do
        parts[name] = char:FindFirstChild(name)
    end
    return parts
end

----------------------------------------------------------------------
-- Hide all ESP drawings (without removing them)
----------------------------------------------------------------------
local function hideESP(esp)
    if not esp then return end

    local topLevelDrawings = {
        "box", "name", "tracer", "distance", "healthBarBG", "healthBar",
        "headdot", "weapon", "viewAngleLine", "viewAngleCircle",
        "offArrow", "offDistText"
    }
    for _, name in ipairs(topLevelDrawings) do
        if esp[name] then
            esp[name].Visible = false
        end
    end

    if esp.skeletonLines then
        for _, line in ipairs(esp.skeletonLines) do
            if line then line.Visible = false end
        end
    end

    if esp.bracketLines then
        for _, line in ipairs(esp.bracketLines) do
            if line then line.Visible = false end
        end
    end

    if esp.flagTexts then
        for _, txt in ipairs(esp.flagTexts) do
            if txt then txt.Visible = false end
        end
    end
end

----------------------------------------------------------------------
-- Cleanup ESP Drawing Objects (properly removes all drawings)
----------------------------------------------------------------------
local function cleanupESPObjects(esp)
    if not esp then return end

    -- Top-level drawing objects
    local topLevelDrawings = {
        "box", "name", "tracer", "distance", "healthBarBG", "healthBar",
        "headdot", "weapon", "viewAngleLine", "viewAngleCircle",
        "offArrow", "offDistText"
    }
    for _, name in ipairs(topLevelDrawings) do
        if esp[name] and esp[name].Remove then
            esp[name].Visible = false
            esp[name]:Remove()
        end
    end

    -- Skeleton lines (table of Line objects)
    if esp.skeletonLines then
        for _, line in ipairs(esp.skeletonLines) do
            if line and line.Remove then
                line.Visible = false
                line:Remove()
            end
        end
        esp.skeletonLines = nil
    end

    -- Bracket lines (table of Line objects)
    if esp.bracketLines then
        for _, line in ipairs(esp.bracketLines) do
            if line and line.Remove then
                line.Visible = false
                line:Remove()
            end
        end
        esp.bracketLines = nil
    end

    -- Flag texts (table of Text objects)
    if esp.flagTexts then
        for _, txt in ipairs(esp.flagTexts) do
            if txt and txt.Remove then
                txt.Visible = false
                txt:Remove()
            end
        end
        esp.flagTexts = nil
    end
end

----------------------------------------------------------------------
-- ESP FEATURE FUNCTIONS (must be defined BEFORE createESP/updateESP)
----------------------------------------------------------------------

-- Skeleton
local function updateSkeleton(esp, char)
    if not config.esp.skeleton then
        for _, line in ipairs(esp.skeletonLines) do line.Visible = false end
        return
    end
    local p = GetParts(char)
    local links = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }
    local lineIdx = 1
    for _, link in ipairs(links) do
        local a = p[link[1]]
        local b = p[link[2]]
        if a and b and a.Parent and b.Parent then
            local aPos, aOn = WorldToScreen(a.Position)
            local bPos, bOn = WorldToScreen(b.Position)
            if aOn and bOn then
                local line = esp.skeletonLines[lineIdx]
                line.From = aPos
                line.To = bPos
                line.Visible = true
            else
                esp.skeletonLines[lineIdx].Visible = false
            end
        else
            esp.skeletonLines[lineIdx].Visible = false
        end
        lineIdx = lineIdx + 1
    end
    for i = lineIdx, #esp.skeletonLines do
        esp.skeletonLines[i].Visible = false
    end
end

-- View Angle
local function updateViewAngle(esp, char)
    if not config.esp.viewangles then
        esp.viewAngleLine.Visible = false
        esp.viewAngleCircle.Visible = false
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not root or not head then
        esp.viewAngleLine.Visible = false
        esp.viewAngleCircle.Visible = false
        return
    end
    local lookVec = root.CFrame.LookVector * 5
    local s, sOn = WorldToScreen(head.Position)
    local e, eOn = WorldToScreen(head.Position + lookVec)
    if sOn and eOn then
        esp.viewAngleLine.From = s
        esp.viewAngleLine.To = e
        esp.viewAngleLine.Visible = true
        esp.viewAngleCircle.Position = e
        esp.viewAngleCircle.Visible = true
    else
        esp.viewAngleLine.Visible = false
        esp.viewAngleCircle.Visible = false
    end
end

-- Off‑Screen Arrow
local function updateOffScreenArrow(esp, char)
    if not config.esp.offarrows then
        esp.offArrow.Visible = false
        esp.offDistText.Visible = false
        return
    end
    local head = char:FindFirstChild("Head")
    if not head then
        esp.offArrow.Visible = false
        esp.offDistText.Visible = false
        return
    end
    local headPos = head.Position
    local screenPos, onScreen = WorldToScreen(headPos)
    if onScreen then
        esp.offArrow.Visible = false
        esp.offDistText.Visible = false
        return
    end

    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local dir = (headPos - cam.CFrame.Position).Unit
    local angle = math.atan2(dir.X, -dir.Z) - math.atan2(cam.CFrame.LookVector.X, -cam.CFrame.LookVector.Z)
    local radius = math.min(cam.ViewportSize.X, cam.ViewportSize.Y) * 0.45
    local edgePos = center + Vector2.new(math.sin(angle), math.cos(angle)) * radius
    local margin = 40
    edgePos = Vector2.new(
        math.clamp(edgePos.X, margin, cam.ViewportSize.X - margin),
        math.clamp(edgePos.Y, margin, cam.ViewportSize.Y - margin)
    )

    local arrowAngle = math.atan2(edgePos.Y - center.Y, edgePos.X - center.X)
    local size = 12
    esp.offArrow.PointA = edgePos + Vector2.new(size * math.cos(arrowAngle), size * math.sin(arrowAngle))
    esp.offArrow.PointB = edgePos + Vector2.new(size * 0.6 * math.cos(arrowAngle + 2.5), size * 0.6 * math.sin(arrowAngle + 2.5))
    esp.offArrow.PointC = edgePos + Vector2.new(size * 0.6 * math.cos(arrowAngle - 2.5), size * 0.6 * math.sin(arrowAngle - 2.5))
    esp.offArrow.Visible = true

    local dist = (headPos - cam.CFrame.Position).Magnitude
    esp.offDistText.Text = string.format("%.0fm", dist / 3)
    esp.offDistText.Position = edgePos + Vector2.new(15, -6)
    esp.offDistText.Visible = true
end

-- Brackets
local function updateBrackets(esp, char)
    if not config.esp.brackets then
        for _, line in ipairs(esp.bracketLines) do line.Visible = false end
        return
    end
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not head or not root then
        for _, line in ipairs(esp.bracketLines) do line.Visible = false end
        return
    end
    local hPos, hOn = WorldToScreen(head.Position)
    local rPos, rOn = WorldToScreen(root.Position)
    if not hOn or not rOn then
        for _, line in ipairs(esp.bracketLines) do line.Visible = false end
        return
    end

    local height = math.abs(hPos.Y - rPos.Y) * 1.5
    local width = height * 0.45
    local topLeft = Vector2.new(hPos.X - width/2, hPos.Y)
    local topRight = Vector2.new(hPos.X + width/2, hPos.Y)
    local bottomLeft = Vector2.new(hPos.X - width/2, rPos.Y)
    local bottomRight = Vector2.new(hPos.X + width/2, rPos.Y)

    local len = 8
    local lines = esp.bracketLines
    lines[1].From = topLeft
    lines[1].To = topLeft + Vector2.new(len, 0)
    lines[1].Visible = true
    lines[2].From = topLeft
    lines[2].To = topLeft + Vector2.new(0, len)
    lines[2].Visible = true
    lines[3].From = topRight
    lines[3].To = topRight - Vector2.new(len, 0)
    lines[3].Visible = true
    lines[4].From = topRight
    lines[4].To = topRight + Vector2.new(0, len)
    lines[4].Visible = true
    lines[5].From = bottomLeft
    lines[5].To = bottomLeft + Vector2.new(len, 0)
    lines[5].Visible = true
    lines[6].From = bottomLeft
    lines[6].To = bottomLeft - Vector2.new(0, len)
    lines[6].Visible = true
    lines[7].From = bottomRight
    lines[7].To = bottomRight - Vector2.new(len, 0)
    lines[7].Visible = true
    lines[8].From = bottomRight
    lines[8].To = bottomRight - Vector2.new(0, len)
    lines[8].Visible = true
end

-- Flags
local function updateFlags(esp, char, player)
    if not (config.esp.names or config.esp.distance or config.esp.healthbar or config.esp.weapon) then
        for _, txt in ipairs(esp.flagTexts) do txt.Visible = false end
        return
    end
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then
        for _, txt in ipairs(esp.flagTexts) do txt.Visible = false end
        return
    end
    local screenPos, onScreen = WorldToScreen(head.Position)
    if not onScreen then
        for _, txt in ipairs(esp.flagTexts) do txt.Visible = false end
        return
    end

    local flags = {}
    if config.esp.names then table.insert(flags, player.Name) end
    if config.esp.distance then
        local dist = (head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
        table.insert(flags, string.format("%.0fm", dist / 3))
    end
    if config.esp.healthbar then
        local hp = humanoid.Health / humanoid.MaxHealth * 100
        table.insert(flags, string.format("HP: %.0f%%", hp))
    end
    if config.esp.weapon then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then table.insert(flags, tool.Name) end
    end

    local txtIndex = 1
    local yOff = 0
    for i, text in ipairs(flags) do
        local txt = esp.flagTexts[txtIndex]
        if not txt then break end
        txt.Text = text
        txt.Position = Vector2.new(screenPos.X + 10, screenPos.Y + yOff)
        if i == 3 and config.esp.healthbar then
            local hp = humanoid.Health / humanoid.MaxHealth
            txt.Color = hp > 0.5 and Color3.new(0,1,0) or (hp > 0.25 and Color3.new(1,1,0) or Color3.new(1,0,0))
        else
            txt.Color = Color3.new(1,1,1)
        end
        txt.Visible = true
        txtIndex = txtIndex + 1
        yOff = yOff + 16
    end
    for i = txtIndex, #esp.flagTexts do
        esp.flagTexts[i].Visible = false
    end
end

-- Update all chams (call when sliders change)
local function UpdateAllChams()
    for _, player in pairs(Players:GetPlayers()) do
        local key = player.UserId
        if HighlightInstances[key] then
            local hl = HighlightInstances[key]
            hl.FillColor = config.esp.chams_fill
            hl.OutlineColor = config.esp.chams_outline
            hl.FillTransparency = config.esp.chams_trans
        end
    end
end

----------------------------------------------------------------------
-- ESP Functions (createESP & updateESP – now all helpers are defined)
----------------------------------------------------------------------
local function createESP(player)
    if player == LocalPlayer then return end
    local key = player.UserId
    if ESPObjects[key] then return end

    local esp = {
        -- existing objects
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        tracer = Drawing.new("Line"),
        distance = Drawing.new("Text"),
        healthBarBG = Drawing.new("Square"),
        healthBar = Drawing.new("Square"),
        headdot = Drawing.new("Square"),
        weapon = Drawing.new("Text"),

        -- NEW: skeleton lines (14 lines)
        skeletonLines = {},
        -- NEW: view angle
        viewAngleLine = Drawing.new("Line"),
        viewAngleCircle = Drawing.new("Circle"),
        -- NEW: off‑screen arrow
        offArrow = Drawing.new("Triangle"),
        offDistText = Drawing.new("Text"),
        -- NEW: bracket lines (8 lines)
        bracketLines = {},
        -- NEW: flag texts (up to 4)
        flagTexts = {},
    }

    -- Initialize skeleton lines (14 lines)
    for i = 1, 14 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Color3.new(0,1,1) -- cyan
        line.Transparency = 1
        line.Visible = false
        table.insert(esp.skeletonLines, line)
    end

    -- View angle
    esp.viewAngleLine.Thickness = 2
    esp.viewAngleLine.Color = Color3.new(1,0.5,0) -- orange
    esp.viewAngleLine.Transparency = 1
    esp.viewAngleLine.Visible = false

    esp.viewAngleCircle.Radius = 3
    esp.viewAngleCircle.Color = Color3.new(1,0.5,0)
    esp.viewAngleCircle.Filled = true
    esp.viewAngleCircle.Transparency = 1
    esp.viewAngleCircle.Visible = false

    -- Off‑screen arrow
    esp.offArrow.Filled = true
    esp.offArrow.Color = Color3.new(1,0,0) -- red
    esp.offArrow.Transparency = 1
    esp.offArrow.Visible = false

    esp.offDistText.Size = 14
    esp.offDistText.Font = 2
    esp.offDistText.Color = Color3.new(1,1,1)
    esp.offDistText.Outline = true
    esp.offDistText.OutlineColor = Color3.new(0,0,0)
    esp.offDistText.Center = false
    esp.offDistText.Visible = false

    -- Bracket lines (8 lines)
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Color3.new(0,1,0) -- green
        line.Transparency = 1
        line.Visible = false
        table.insert(esp.bracketLines, line)
    end

    -- Flag texts (up to 4)
    for i = 1, 4 do
        local txt = Drawing.new("Text")
        txt.Size = 12
        txt.Font = 2
        txt.Color = Color3.new(1,1,1)
        txt.Outline = true
        txt.OutlineColor = Color3.new(0,0,0)
        txt.Center = false
        txt.Visible = false
        table.insert(esp.flagTexts, txt)
    end

    -- Existing init (box, name, etc.)
    esp.box.Thickness = 1.5
    esp.box.Color = Color3.fromRGB(170, 85, 255)
    esp.box.Filled = false
    esp.box.Visible = false

    esp.name.Size = 13
    esp.name.Font = 2
    esp.name.Color = Color3.new(1, 1, 1)
    esp.name.OutlineColor = Color3.new(0, 0, 0)
    esp.name.Outline = true
    esp.name.Center = true
    esp.name.Visible = false

    esp.weapon.Size = 13
    esp.weapon.Font = 2
    esp.weapon.Color = Color3.new(1, 1, 1)
    esp.weapon.OutlineColor = Color3.new(0, 0, 0)
    esp.weapon.Outline = true
    esp.weapon.Center = true
    esp.weapon.Visible = false

    esp.headdot.Size = Vector2.new(4, 4)
    esp.headdot.Color = Color3.fromRGB(170, 85, 255)
    esp.headdot.Filled = true
    esp.headdot.Visible = false

    esp.tracer.Thickness = 1.5
    esp.tracer.Color = Color3.fromRGB(170, 85, 255)
    esp.tracer.Visible = false

    esp.distance.Size = 12
    esp.distance.Font = 2
    esp.distance.Color = Color3.new(1, 1, 1)
    esp.distance.OutlineColor = Color3.new(0, 0, 0)
    esp.distance.Outline = true
    esp.distance.Center = true
    esp.distance.Visible = false

    esp.healthBarBG.Thickness = 1
    esp.healthBarBG.Color = Color3.new(0, 0, 0)
    esp.healthBarBG.Filled = true
    esp.healthBarBG.Visible = false

    esp.healthBar.Thickness = 1
    esp.healthBar.Color = Color3.new(0, 1, 0)
    esp.healthBar.Filled = true
    esp.healthBar.Visible = false

    ESPObjects[key] = esp
end

local function updateESP(player)
    local key = player.UserId
    local esp = ESPObjects[key]
    if not esp then return end

    local char = getCharacter(player)
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local head = char and char:FindFirstChild("Head")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not root or not hum or hum.Health <= 0 then
        hideESP(esp)
        return
    end

    if not isEnemy(player) then
        hideESP(esp)
        return
    end

    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then
        hideESP(esp)
        return
    end

    local headPart = head or root
    local headPos = Camera:WorldToViewportPoint((headPart.CFrame * CFrame.new(0, 0.5, 0)).Position)
    local footPos = Camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, -3, 0)).Position)

    local boxHeight = math.abs(headPos.Y - footPos.Y)
    local boxWidth = boxHeight * 0.55

    esp.box.Size = Vector2.new(boxWidth, boxHeight)
    esp.box.Position = Vector2.new(rootPos.X - boxWidth / 2, headPos.Y)
    esp.box.Visible = config.esp.boxes

    esp.name.Position = Vector2.new(rootPos.X, headPos.Y - 16)
    esp.name.Text = player.DisplayName
    esp.name.Visible = config.esp.names

    esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    esp.tracer.To = Vector2.new(rootPos.X, footPos.Y)
    esp.tracer.Visible = config.esp.tracers

    local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
    esp.distance.Position = Vector2.new(rootPos.X, footPos.Y + 2)
    esp.distance.Text = tostring(dist) .. "m"
    esp.distance.Visible = config.esp.distance

    local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
    local barHeight = boxHeight
    local barWidth = 3
    local barX = rootPos.X - boxWidth / 2 - 6

    esp.healthBarBG.Size = Vector2.new(barWidth, barHeight)
    esp.healthBarBG.Position = Vector2.new(barX, headPos.Y)
    esp.healthBarBG.Visible = config.esp.healthbar

    esp.healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
    esp.healthBar.Position = Vector2.new(barX, headPos.Y + barHeight * (1 - healthPercent))
    esp.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
    esp.healthBar.Visible = config.esp.healthbar
    
    esp.headdot.Position = Vector2.new(headPos.X - 2, headPos.Y - 2)
    esp.headdot.Visible = config.esp.headdot
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        esp.weapon.Text = tool.Name
    else
        esp.weapon.Text = "None"
    end
    esp.weapon.Position = Vector2.new(rootPos.X, footPos.Y + 16)
    esp.weapon.Visible = config.esp.weapon

    -- ========== NEW FEATURES ==========
    updateSkeleton(esp, char)
    updateViewAngle(esp, char)
    updateOffScreenArrow(esp, char)
    updateBrackets(esp, char)
    updateFlags(esp, char, player)
    -- ===================================
end

local function removeESP(player)
    local key = player.UserId
    local esp = ESPObjects[key]
    if esp then
        cleanupESPObjects(esp)
        ESPObjects[key] = nil
    end
    if HighlightInstances[key] then
        HighlightInstances[key]:Destroy()
        HighlightInstances[key] = nil
    end
end

----------------------------------------------------------------------
-- UNLOCK ALL SKIN CHANGER (FULLY FIXED)
----------------------------------------------------------------------
local unlockAllLoaded = false
local function loadUnlockAll(statusLbl, acLbl, libLbl, vmLbl, remLbl)
    if unlockAllLoaded then
        KetamineUI:Notify({Title = "Unlock All", Text = "Already loaded!", Duration = 3})
        return
    end
    unlockAllLoaded = true

    if statusLbl then statusLbl:Set("Status: Initializing...") end
    if acLbl then acLbl:Set("AC Bypass: Active") end

    -- AC Bypass (from the original script)
    local _stbl; _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
        if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
            local tr = debug.traceback()
            if tr:find("MiscellaneousController") then
                return _stbl({1,2,3}, {})
            end
        end
        return _stbl(tbl, mt)
    end))

    coroutine.wrap(function()
        pcall(function()
            local function _proc(o)
                pcall(function()
                    if o:IsA("LocalScript") or o:IsA("ModuleScript") then
                        local _s, nm = pcall(function() return o.Name:lower() end)
                        if not _s or not nm then return end
                        local _tags = {"anticheat","ac","detection","ban","kick","security","moderation"}
                        for _i = 1, #_tags do
                            if nm:find(_tags[_i]) then
                                pcall(function() o.Disabled = true end)
                                break
                            end
                        end
                    end
                end)
            end
            pcall(function()
                local _desc = game:GetDescendants()
                for _i = 1, #_desc do _proc(_desc[_i]) end
            end)
            pcall(function() game.DescendantAdded:Connect(_proc) end)
        end)
        pcall(function()
            local _nc = game:GetService("NetworkClient")
            if not _nc then return end
            _nc.ChildAdded:Connect(function(ch)
                pcall(function()
                    local _ok, _n = pcall(function() return ch.Name:lower() end)
                    if _ok and _n then
                        if _n:find("anticheat") or _n:find("detection") then
                            pcall(function() ch:Destroy() end)
                        end
                    end
                end)
            end)
        end)
    end)()

    local _fakeEv
    pcall(function()
        _fakeEv = Instance.new("RemoteEvent")
        _fakeEv.Name = "ClientAlert"
        _fakeEv.Parent = LocalPlayer
    end)

    pcall(function()
        local _rf = game:GetService("ReplicatedFirst")
        local _tgt = _rf:WaitForChild("LocalScript3", 10)
        local _ct = 0
        local _gc = getgc(false)
        for _i = 1, #_gc do
            local _fn = _gc[_i]
            if type(_fn) ~= "function" then continue end
            local _ok1, _env = pcall(getfenv, _fn)
            if not _ok1 or type(_env) ~= "table" then continue end
            local _ok2, _scr = pcall(function() return rawget(_env, "script") end)
            if not _ok2 or not _scr or typeof(_scr) ~= "Instance" then continue end
            local _ok3, _ss = pcall(tostring, _scr)
            if not _ok3 then continue end
            if not (_scr == _tgt or (type(_ss) == "string" and _ss:find("LoadingScreen"))) then continue end
            local _ok4, _consts = pcall(debug.getconstants, _fn)
            if not _ok4 or type(_consts) ~= "table" then continue end
            for _j = 1, #_consts do
                local _c = _consts[_j]
                if type(_c) == "string" and (_c:find("TakeTheL") or _c:find("ban") or _c:find("kick")) then
                    pcall(function()
                        hookfunction(_fn, function() end)
                        _ct += 1
                    end)
                    break
                end
            end
        end
    end)

    task.wait(4) -- wait for game to fully load

    -- Now the actual unlock all logic (same as original but integrated)
    local _plrs    = game:GetService("Players")
    local _rs      = game:GetService("ReplicatedStorage")
    local _http    = game:GetService("HttpService")
    local _run     = game:GetService("RunService")
    local _ws      = game:GetService("Workspace")
    local _lp      = _plrs.LocalPlayer
    local _pscripts = _lp.PlayerScripts
    local _ctrl    = _pscripts.Controllers
    local _mods    = _rs:WaitForChild("Modules", 10)

    local _enumLib = require(_mods:WaitForChild("EnumLibrary", 10))
    if _enumLib then pcall(function() _enumLib:WaitForEnumBuilder() end) end

    local _cosLib  = require(_mods:WaitForChild("CosmeticLibrary", 10))
    local _itmLib  = require(_mods:WaitForChild("ItemLibrary", 10))
    local _datCtrl = require(_ctrl:WaitForChild("PlayerDataController", 10))

    local _eq, _favs = {}, {}
    local _buildingWep, _viewProf = nil, nil
    local _lastWep = nil

    local function _mkCosmetic(nm, ctype, opts)
        local _base = _cosLib.Cosmetics[nm]
        if not _base then return nil end
        local _d = {}
        for k, v in pairs(_base) do _d[k] = v end
        _d.Name = nm
        _d.Type = _d.Type or ctype
        _d.Seed = _d.Seed or math.random(1, 1000000)
        if _enumLib then
            local _s, _eid = pcall(_enumLib.ToEnum, _enumLib, nm)
            if _s and _eid then
                _d.Enum = _eid
                _d.ObjectID = _d.ObjectID or _eid
            end
        end
        if opts then
            if opts.inverted ~= nil then _d.Inverted = opts.inverted end
            if opts.favoritesOnly ~= nil then _d.OnlyUseFavorites = opts.favoritesOnly end
        end
        return _d
    end

    local _cfgFile = "unlockall/config.json" -- using your existing path
    local _saveLock = false

    local function _stripForSave()
        local _out = {}
        for wn, cos in pairs(_eq) do
            _out[wn] = {}
            for ct, cd in pairs(cos) do
                if cd and cd.Name then
                    _out[wn][ct] = {
                        Name = cd.Name,
                        Inverted = cd.Inverted,
                        OnlyUseFavorites = cd.OnlyUseFavorites
                    }
                end
            end
        end
        return { equipped = _out, favorites = _favs }
    end

    local function _loadCfg()
        if not isfile or not readfile then return end
        local _ok1, _ex = pcall(isfile, _cfgFile)
        if not _ok1 or not _ex then return end
        local _ok2, _raw = pcall(readfile, _cfgFile)
        if not _ok2 or not _raw or _raw == "" then return end
        local _ok3, _dec = pcall(_http.JSONDecode, _http, _raw)
        if not _ok3 or not _dec then return end
        if _dec.favorites then
            _favs = _dec.favorites
        end
        if _dec.equipped then
            _eq = {}
            local _cnt = 0
            for wn, cos in pairs(_dec.equipped) do
                _eq[wn] = {}
                for ct, sd in pairs(cos) do
                    if sd and sd.Name then
                        if _cosLib.Cosmetics[sd.Name] then
                            local _cloned = _mkCosmetic(sd.Name, ct, {
                                inverted = sd.Inverted,
                                favoritesOnly = sd.OnlyUseFavorites
                            })
                            if _cloned then
                                _eq[wn][ct] = _cloned
                                _cnt += 1
                            end
                        end
                    end
                end
                if not next(_eq[wn]) then _eq[wn] = nil end
            end
        end
    end

    local function _saveCfg()
        if not writefile or _saveLock then return end
        _saveLock = true
        task.spawn(function()
            task.wait(1)
            local _payload = _stripForSave()
            local _ok, _enc = pcall(_http.JSONEncode, _http, _payload)
            if _ok then
                pcall(function()
                    makefolder("unlockall")
                    writefile(_cfgFile, _enc)
                end)
            end
            _saveLock = false
        end)
    end

    _loadCfg()

    local _cosTypes = {"Skin","Wrap","Charm","Dance","Emote"}
    local function _isCosType(cosObj)
        if not cosObj then return false end
        for _, t in ipairs(_cosTypes) do
            if cosObj.Type == t then return true end
        end
        return false
    end

    -- Override ownership checks
    _cosLib.OwnsCosmeticNormally = function(self, inv, nm, wep)
        local c = _cosLib.Cosmetics[nm]
        if c and c.Type == "Skin" then return true end
        return false
    end
    _cosLib.OwnsCosmeticUniversally = function(self, inv, nm, wep)
        local c = _cosLib.Cosmetics[nm]
        if c and c.Type == "Skin" then return true end
        return false
    end
    _cosLib.OwnsCosmeticForWeapon = function(self, inv, nm, wep)
        local c = _cosLib.Cosmetics[nm]
        if c and c.Type == "Skin" then return true end
        return false
    end

    local _origOwns = _cosLib.OwnsCosmetic
    _cosLib.OwnsCosmetic = function(self, inv, nm, wep)
        if nm:find("MISSING_") or nm == "Bubble Gun" then
            return _origOwns(self, inv, nm, wep)
        end
        local c = _cosLib.Cosmetics[nm]
        if c and _isCosType(c) then return true end
        return _origOwns(self, inv, nm, wep)
    end

    local _origGet = _datCtrl.Get
    _datCtrl.Get = function(self, key)
        local _val = _origGet(self, key)
        if key == "CosmeticInventory" then
            local _prx = {}
            if _val then
                for k, v in pairs(_val) do
                    local c = _cosLib.Cosmetics[k]
                    if c and _isCosType(c) then _prx[k] = v end
                end
            end
            return setmetatable(_prx, {
                __index = function(t, k)
                    local c = _cosLib.Cosmetics[k]
                    if c and _isCosType(c) then return true end
                    return nil
                end
            })
        end
        if key == "FavoritedCosmetics" then
            local _res = _val and table.clone(_val) or {}
            for wep, fv in pairs(_favs) do
                _res[wep] = _res[wep] or {}
                for nm, isFav in pairs(fv) do
                    local c = _cosLib.Cosmetics[nm]
                    if c and _isCosType(c) then
                        _res[wep][nm] = isFav
                    end
                end
            end
            return _res
        end
        return _val
    end

    local _origGetWep = _datCtrl.GetWeaponData
    _datCtrl.GetWeaponData = function(self, wn)
        local _d = _origGetWep(self, wn)
        if not _d then return nil end
        local _m = {}
        for k, v in pairs(_d) do _m[k] = v end
        _m.Name = wn
        if _eq[wn] then
            for ct, cd in pairs(_eq[wn]) do
                _m[ct] = cd
            end
        end
        return _m
    end

    local _fightCtrl
    pcall(function()
        _fightCtrl = require(_ctrl:WaitForChild("FighterController", 10))
    end)

    if hookmetamethod then
        local _remotes   = _rs:FindFirstChild("Remotes")
        local _dataRem   = _remotes and _remotes:FindFirstChild("Data")
        local _equipRem  = _dataRem and _dataRem:FindFirstChild("EquipCosmetic")
        local _favRem    = _dataRem and _dataRem:FindFirstChild("FavoriteCosmetic")
        local _repRem    = _remotes and _remotes:FindFirstChild("Replication")
        local _fightRem  = _repRem and _repRem:FindFirstChild("Fighter")
        local _useItmRem = _fightRem and _fightRem:FindFirstChild("UseItem")

        if _equipRem then
            local _onc
            _onc = hookmetamethod(game, "__namecall", function(self, ...)
                if getnamecallmethod() ~= "FireServer" then
                    return _onc(self, ...)
                end
                local _a = {...}

                if _useItmRem and self == _useItmRem then
                    local _oid = _a[1]
                    if _fightCtrl then
                        pcall(function()
                            local _f = _fightCtrl:GetFighter(_lp)
                            if _f and _f.Items then
                                for _, itm in pairs(_f.Items) do
                                    if itm:Get("ObjectID") == _oid then
                                        _lastWep = itm.Name
                                        break
                                    end
                                end
                            end
                        end)
                    end
                end

                if self == _equipRem then
                    local _wn   = _a[1]
                    local _ct   = _a[2]
                    local _cn   = _a[3]
                    local _opts = _a[4] or {}
                    if _cn and _cn ~= "None" and _cn ~= "" then
                        local _inv = _datCtrl:Get("CosmeticInventory")
                        if _inv and rawget(_inv, _cn) then
                            return _onc(self, ...)
                        end
                    end
                    _eq[_wn] = _eq[_wn] or {}
                    if not _cn or _cn == "None" or _cn == "" then
                        _eq[_wn][_ct] = nil
                        if not next(_eq[_wn]) then _eq[_wn] = nil end
                    else
                        local _cloned = _mkCosmetic(_cn, _ct, {
                            inverted = _opts.IsInverted,
                            favoritesOnly = _opts.OnlyUseFavorites
                        })
                        if _cloned then _eq[_wn][_ct] = _cloned end
                    end
                    task.defer(function()
                        pcall(function() _datCtrl.CurrentData:Replicate("WeaponInventory") end)
                    end)
                    _saveCfg()
                    return
                end

                if self == _favRem then
                    local _cos = _cosLib.Cosmetics[_a[2]]
                    if _cos then
                        _favs[_a[1]] = _favs[_a[1]] or {}
                        _favs[_a[1]][_a[2]] = _a[3] or nil
                        task.spawn(function()
                            pcall(function() _datCtrl.CurrentData:Replicate("FavoritedCosmetics") end)
                        end)
                        _saveCfg()
                    end
                    return
                end

                return _onc(self, ...)
            end)
        end
    end

    -- ClientItem hook for view model
    local _cliItem
    pcall(function()
        _cliItem = require(_lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
    end)

    if _cliItem and _cliItem._CreateViewModel then
        local _origCVM = _cliItem._CreateViewModel
        _cliItem._CreateViewModel = function(self, vmRef)
            local _wn  = self.Name
            local _wp  = self.ClientFighter and self.ClientFighter.Player
            _buildingWep = (_wp == _lp) and _wn or nil
            if _wp == _lp and _eq[_wn] then
                local _dk = self:ToEnum("Data")
                if vmRef[_dk] then
                    if _eq[_wn].Skin then
                        vmRef[_dk][self:ToEnum("Skin")] = _eq[_wn].Skin
                        vmRef[_dk][self:ToEnum("Name")] = _eq[_wn].Skin.Name
                    end
                    if _eq[_wn].Charm then vmRef[_dk][self:ToEnum("Charm")] = _eq[_wn].Charm end
                    if _eq[_wn].Wrap  then vmRef[_dk][self:ToEnum("Wrap")]  = _eq[_wn].Wrap  end
                elseif vmRef.Data then
                    if _eq[_wn].Skin  then vmRef.Data.Skin  = _eq[_wn].Skin; vmRef.Data.Name = _eq[_wn].Skin.Name end
                    if _eq[_wn].Charm then vmRef.Data.Charm = _eq[_wn].Charm end
                    if _eq[_wn].Wrap  then vmRef.Data.Wrap  = _eq[_wn].Wrap  end
                end
            end
            local _r = _origCVM(self, vmRef)
            _buildingWep = nil
            return _r
        end
    end

    -- ClientViewModel hook
    local _vmMod = _lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
    if _vmMod then
        local _CVM = require(_vmMod)
        local _origNew = _CVM.new
        _CVM.new = function(repData, cliItm)
            local _wp  = cliItm.ClientFighter and cliItm.ClientFighter.Player
            local _wn  = _buildingWep or cliItm.Name
            if _wp == _lp and _eq[_wn] then
                local _RC  = require(_rs.Modules.ReplicatedClass)
                local _dk  = _RC:ToEnum("Data")
                repData[_dk] = repData[_dk] or {}
                local _cos = _eq[_wn]
                if _cos.Skin  then repData[_dk][_RC:ToEnum("Skin")]  = _cos.Skin  end
                if _cos.Charm then repData[_dk][_RC:ToEnum("Charm")] = _cos.Charm end
                if _cos.Wrap  then repData[_dk][_RC:ToEnum("Wrap")]  = _cos.Wrap  end
            end
            return _origNew(repData, cliItm)
        end
    end
    if libLbl then libLbl:Set("Library Hooks: Active") end
    if vmLbl then vmLbl:Set("ViewModel Hooks: Active") end
    if remLbl then remLbl:Set("Remote Intercept: Active") end
    if statusLbl then statusLbl:Set("Status: Active (All Cosmetics Unlocked)") end
    if statusLbl then statusLbl:Set("Status: Active (All Cosmetics Unlocked)") end

    KetamineUI:Notify({Title = "Unlock All", Text = "Successfully loaded! All cosmetics (except Finishers) unlocked.", Duration = 4})
end

----------------------------------------------------------------------
-- SPOOFER
----------------------------------------------------------------------
local spooferLoaded = false
local function loadSpoofer()
    if spooferLoaded then
        KetamineUI:Notify({Title = "Spoofer", Text = "Already loaded!", Duration = 3})
        return
    end
    spooferLoaded = true

    getgenv().NameSpooferConfig = getgenv().NameSpooferConfig or {
        name_spoof = true,
        your_spoofed_name = "Andy",
        spoofed_enemy_names = "Johnny",

        level_spoof = false,
        spoofed_level = 996,

        winstreak_spoof = false,
        spoofed_winstreak = 56,
    }

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Config = getgenv().NameSpooferConfig
    local connections = {}

    local function spoofPlayer(player)
        if not Config.name_spoof then return end
        if player == LocalPlayer then
            pcall(function()
                player.Name = Config.your_spoofed_name
                player.DisplayName = Config.your_spoofed_name
            end)
        else
            pcall(function()
                player.Name = Config.spoofed_enemy_names
                player.DisplayName = Config.spoofed_enemy_names
            end)
        end
    end

    local realLevel = nil
    local realStreak = nil

    local function spoofLeaderstats(player)
        if player ~= LocalPlayer then return end
        local leaderstats = player:FindFirstChild("CustomLeaderstats")
        if not leaderstats then return end
        if Config.level_spoof then
            local levelFolder = leaderstats:FindFirstChild("Level")
            if levelFolder and levelFolder:IsA("Folder") then
                local lvlVal = levelFolder:FindFirstChildWhichIsA("IntValue") or levelFolder:FindFirstChildWhichIsA("StringValue")
                if lvlVal then
                    if lvlVal.Value ~= Config.spoofed_level then realLevel = tostring(lvlVal.Value) end
                    lvlVal.Value = Config.spoofed_level
                end
            elseif levelFolder and (levelFolder:IsA("IntValue") or levelFolder:IsA("StringValue") or levelFolder:IsA("NumberValue")) then
                if levelFolder.Value ~= Config.spoofed_level then realLevel = tostring(levelFolder.Value) end
                levelFolder.Value = Config.spoofed_level
            end
            
            local attrLevel = player:GetAttribute("Level") or player:GetAttribute("StatisticLevel")
            if attrLevel and attrLevel ~= Config.spoofed_level then realLevel = tostring(attrLevel) end
            
            pcall(function() player:SetAttribute("Level", Config.spoofed_level) end)
            pcall(function() player:SetAttribute("StatisticLevel", Config.spoofed_level) end)
        end
        if Config.winstreak_spoof then
            local winStreakFolder = leaderstats:FindFirstChild("Win Streak")
            if winStreakFolder and winStreakFolder:IsA("Folder") then
                local streakVal = winStreakFolder:FindFirstChildWhichIsA("IntValue")
                if streakVal then
                    if streakVal.Value ~= Config.spoofed_winstreak then realStreak = tostring(streakVal.Value) end
                    streakVal.Value = Config.spoofed_winstreak
                end
            elseif winStreakFolder and winStreakFolder:IsA("IntValue") then
                if winStreakFolder.Value ~= Config.spoofed_winstreak then realStreak = tostring(winStreakFolder.Value) end
                winStreakFolder.Value = Config.spoofed_winstreak
            end
            
            local attrStreak = player:GetAttribute("StatisticDuelsWinStreak")
            if attrStreak and attrStreak ~= Config.spoofed_winstreak then realStreak = tostring(attrStreak) end
            
            pcall(function() player:SetAttribute("StatisticDuelsWinStreak", Config.spoofed_winstreak) end)
        end
    end

    local function findAllTitleLabels(instance, results)
        results = results or {}
        if not instance then return results end
        for _, child in ipairs(instance:GetChildren()) do
            if child:IsA("TextLabel") and child.Name == "Title" then
                table.insert(results, child)
            end
            findAllTitleLabels(child, results)
        end
        return results
    end

    local GUI_PATH = {
        "PlayerGui", "MainGui", "PlayerList", "Container",
        "Elements", "Container", "Middle", "List", "Container"
    }

    local function getListContainer()
        local node = LocalPlayer
        for _, name in ipairs(GUI_PATH) do
            if not node then return nil end
            node = node:FindFirstChild(name)
        end
        return node
    end

    local function spoofTitleLabelsInContainer(container)
        if not container then return end
        for _, playerFrame in ipairs(container:GetChildren()) do
            if playerFrame:IsA("Frame") then
                local spoofed = false
                local innerContainer = playerFrame:FindFirstChild("Container")
                if innerContainer and innerContainer:IsA("Frame") then
                    for _, child in ipairs(innerContainer:GetChildren()) do
                        if child:IsA("Frame") then
                            local titleLabel = child:FindFirstChild("Title")
                            if titleLabel and titleLabel:IsA("TextLabel") then
                                local isLocal =
                                    titleLabel.Text == LocalPlayer.Name or
                                    titleLabel.Text == LocalPlayer.DisplayName
                                titleLabel.Text = isLocal
                                    and Config.your_spoofed_name
                                    or Config.spoofed_enemy_names
                                spoofed = true
                            end
                        end
                    end
                end

                if not spoofed then
                    local labels = findAllTitleLabels(playerFrame)
                    for _, titleLabel in ipairs(labels) do
                        local isLocal =
                            titleLabel.Text == LocalPlayer.Name or
                            titleLabel.Text == LocalPlayer.DisplayName
                        titleLabel.Text = isLocal
                            and Config.your_spoofed_name
                            or Config.spoofed_enemy_names
                    end
                end
            end
        end
    end

    local function watchContainerForNewFrames(container)
        if not container then return end
        local conn = container.ChildAdded:Connect(function(child)
            if child:IsA("Frame") then
                task.wait(0.1)
                pcall(spoofTitleLabelsInContainer, container)
            end
        end)
        table.insert(connections, conn)
    end

    local function startGuiSpoofLoop()
        task.spawn(function()
            local playerGui = LocalPlayer:WaitForChild("PlayerGui", 30)
            if not playerGui then return end

            local monitoredContainer = nil

            while task.wait(0.5) do
                if Config.name_spoof then
                    local listContainer = getListContainer()
                    if listContainer and listContainer ~= monitoredContainer then
                        monitoredContainer = listContainer
                        watchContainerForNewFrames(listContainer)
                    end
                    if listContainer then
                        pcall(spoofTitleLabelsInContainer, listContainer)
                    end
                end

                if Config.level_spoof or Config.winstreak_spoof then
                    pcall(function()
                        for _, desc in ipairs(playerGui:GetDescendants()) do
                            if desc:IsA("TextLabel") then
                                if Config.level_spoof then
                                    local isLevel = false
                                    if realLevel and desc.Text == realLevel then isLevel = true
                                    elseif desc.Name:match("Level") and tonumber(desc.Text) then isLevel = true
                                    elseif desc.Parent then
                                        if desc.Parent.Name:match("Level") and tonumber(desc.Text) then isLevel = true
                                        else
                                            for _, sib in ipairs(desc.Parent:GetChildren()) do
                                                if sib:IsA("TextLabel") and sib.Text == "Level" then
                                                    isLevel = true break
                                                end
                                            end
                                        end
                                    end
                                    if isLevel and tonumber(desc.Text) then desc.Text = tostring(Config.spoofed_level) end
                                end
                                if Config.winstreak_spoof then
                                    local isStreak = false
                                    if realStreak and desc.Text == realStreak then isStreak = true
                                    elseif desc.Name:match("Streak") and tonumber(desc.Text) then isStreak = true
                                    elseif desc.Parent then
                                        if desc.Parent.Name:match("Streak") and tonumber(desc.Text) then isStreak = true
                                        else
                                            for _, sib in ipairs(desc.Parent:GetChildren()) do
                                                if sib:IsA("TextLabel") and (sib.Text == "Streak" or sib.Text == "Win Streak") then
                                                    isStreak = true break
                                                end
                                            end
                                        end
                                    end
                                    if isStreak and tonumber(desc.Text) then desc.Text = tostring(Config.spoofed_winstreak) end
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end

    local function watchLeaderstats(player)
        if player ~= LocalPlayer then return end
        local conn
        conn = player.ChildAdded:Connect(function(child)
            if child.Name == "CustomLeaderstats" then
                task.wait(0.1)
                spoofLeaderstats(player)
                if conn then conn:Disconnect() end
            end
        end)
        table.insert(connections, conn)
        spoofLeaderstats(player)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        spoofPlayer(player)
        if player == LocalPlayer then
            watchLeaderstats(player)
        end
    end

    local playerAddedConn = Players.PlayerAdded:Connect(function(player)
        spoofPlayer(player)
    end)
    table.insert(connections, playerAddedConn)

    task.spawn(function()
        while task.wait(3) do
            if Config.level_spoof or Config.winstreak_spoof then
                spoofLeaderstats(LocalPlayer)
            end
        end
    end)

    startGuiSpoofLoop()
    KetamineUI:Notify({Title = "Spoofer", Text = "Spoofer loaded successfully!", Duration = 3})
end

----------------------------------------------------------------------
-- UNLOCK ALL EMOTES
----------------------------------------------------------------------
local unlockEmotesLoaded = false
local function loadUnlockEmotes()
    if unlockEmotesLoaded then
        KetamineUI:Notify({Title = "Unlock Emotes", Text = "Already loaded!", Duration = 3})
        return
    end
    unlockEmotesLoaded = true

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
    local Controllers = PlayerScripts:WaitForChild("Controllers")
    local Modules = ReplicatedStorage:WaitForChild("Modules")

    local CosmeticLibrary = require(Modules:WaitForChild("CosmeticLibrary"))
    local EmoteController = require(Controllers:WaitForChild("EmoteController"))
    local FighterController = require(Controllers:WaitForChild("FighterController"))
    local PlayerDataController = require(Controllers:WaitForChild("PlayerDataController"))

    local isLocalEmoting = false
    local localEmoteObject = nil
    local hookedEntities = setmetatable({}, { __mode = "k" })

    local previousCameraMode = nil
    local previousMinZoom = nil

    local function safeFire(signal)
        if not signal then return end
        if type(signal) == "table" then
            if type(signal.Fire) == "function" then
                pcall(function() signal:Fire() end)
            elseif type(signal.fire) == "function" then
                pcall(function() signal:fire() end)
            end
        elseif typeof(signal) == "Instance" and signal:IsA("BindableEvent") then
            pcall(function() signal:Fire() end)
        end
    end

    local function applyHooksToEntity(entity)
        if not entity or hookedEntities[entity] then return end
        hookedEntities[entity] = true
        local oldIsEmoting = entity.IsEmoting
        if oldIsEmoting then
            entity.IsEmoting = function(self, ...)
                if isLocalEmoting then
                    return true
                end
                return oldIsEmoting(self, ...)
            end
        end
        local oldGetCurrentEmote = entity.GetCurrentEmote
        if oldGetCurrentEmote then
            entity.GetCurrentEmote = function(self, ...)
                if isLocalEmoting and localEmoteObject then
                    return localEmoteObject
                end
                return oldGetCurrentEmote(self, ...)
            end
        end
    end

    local function setupFighter(fighter)
        if fighter.IsLocalPlayer then
            if fighter.Entity then
                applyHooksToEntity(fighter.Entity)
            end
            fighter.EntityAdded:Connect(function(entity)
                applyHooksToEntity(entity)
            end)
        end
    end

    for _, fighter in pairs(FighterController.Objects) do
        setupFighter(fighter)
    end
    FighterController.ObjectAdded:Connect(setupFighter)

    local oldOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
    CosmeticLibrary.OwnsCosmetic = function(self, inventory, cosmeticName)
        local cosmetic = CosmeticLibrary.Cosmetics[cosmeticName]
        if cosmetic and cosmetic.Type == "Emote" then
            return true
        end
        return oldOwnsCosmetic(self, inventory, cosmeticName)
    end

    local oldCanEmote = EmoteController.CanEmote
    EmoteController.CanEmote = function(self, p2)
        local success, result = pcall(oldCanEmote, self, p2)
        if success and result then
            return true
        end
        local fighter = FighterController:GetFighter(LocalPlayer)
        if fighter and fighter.IsLocalPlayer and fighter:IsAlive() then
            local entity = fighter.Entity
            if entity and not entity:Get("IsFrozen") then
                return true
            end
        end
        return false
    end

    local currentLocalEmote = nil
    local runningConnection = nil

    local function stopCurrentLocalEmote()
        isLocalEmoting = false
        localEmoteObject = nil
        pcall(function()
            if previousCameraMode then
                LocalPlayer.CameraMode = previousCameraMode
                previousCameraMode = nil
            end
            if previousMinZoom then
                LocalPlayer.CameraMinZoomDistance = previousMinZoom
                previousMinZoom = nil
            end
        end)
        local fighter = FighterController:GetFighter(LocalPlayer)
        local entity = fighter and fighter.Entity
        if entity and entity.EmoteStatusChanged then
            safeFire(entity.EmoteStatusChanged)
        end
        if currentLocalEmote then
            pcall(function()
                currentLocalEmote:Destroy()
            end)
            currentLocalEmote = nil
        end
    end

    local function setupHumanoidMonitoring(character)
        if not character then return end
        local humanoid = character:WaitForChild("Humanoid", 10)
        if not humanoid then return end
        if runningConnection then
            runningConnection:Disconnect()
        end
        runningConnection = humanoid.Running:Connect(function(speed)
            if speed > 0.1 then
                stopCurrentLocalEmote()
            end
        end)
    end

    setupHumanoidMonitoring(LocalPlayer.Character)
    LocalPlayer.CharacterAdded:Connect(setupHumanoidMonitoring)

    local oldUseEmoteByName = EmoteController.UseEmoteByName
    EmoteController.UseEmoteByName = function(self, emoteName)
        stopCurrentLocalEmote()
        local ownsEmote = oldOwnsCosmetic(CosmeticLibrary, PlayerDataController:Get("CosmeticInventory"), emoteName)
        pcall(function()
            oldUseEmoteByName(self, emoteName)
        end)
        if not ownsEmote then
            task.spawn(function()
                local EmotesFolder = Modules:FindFirstChild("Emotes")
                local emoteModule = EmotesFolder and EmotesFolder:FindFirstChild(emoteName)
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if emoteModule and humanoid then
                    task.wait(0.1)
                    pcall(function()
                        currentLocalEmote = require(emoteModule).new(humanoid)
                        previousCameraMode = LocalPlayer.CameraMode
                        previousMinZoom = LocalPlayer.CameraMinZoomDistance
                        LocalPlayer.CameraMode = Enum.CameraMode.Classic
                        LocalPlayer.CameraMinZoomDistance = 8
                        isLocalEmoting = true
                        localEmoteObject = currentLocalEmote
                        local fighter = FighterController:GetFighter(LocalPlayer)
                        local entity = fighter and fighter.Entity
                        if entity and entity.EmoteStatusChanged then
                            safeFire(entity.EmoteStatusChanged)
                        end
                        task.defer(currentLocalEmote.Simulate, currentLocalEmote)
                        currentLocalEmote.Destroying:Wait()
                        if isLocalEmoting then
                            stopCurrentLocalEmote()
                        end
                    end)
                end
            end)
        end
    end
    KetamineUI:Notify({Title = "Unlock Emotes", Text = "All Emotes have been unlocked!", Duration = 3})
end

----------------------------------------------------------------------
-- Gun Mods Code
----------------------------------------------------------------------
local function loadGunMods()
    loadstring("if game.GameId == 6035872082 then local Storage = game:GetService(\"ReplicatedStorage\") local Items = require(Storage.Modules.ItemLibrary).Items local gunExceptions = {[\"Sniper\"] = false,[\"Crossbow\"] = false,[\"Bow\"] = false,[\"RPG\"] = false,} for name, data in pairs(Items) do if typeof(data) == \"table\" and not gunExceptions[name] then if data.ShootSpread then data.ShootSpread = 0 end if data.ShootAccuracy then data.ShootAccuracy = 0 end if data.ShootRecoil then data.ShootRecoil = 0 end if data.ShootCooldown then data.ShootCooldown = 0.001 end if data.ShootBurstCooldown then data.ShootBurstCooldown = 0.001 end end end for name, data in pairs(Items) do if typeof(data) == \"table\" then if data.AttackCooldown then data.AttackCooldown = 0.001 end if data.SwingCooldown then data.SwingCooldown = 0.001 end if data.MeleeCooldown then data.MeleeCooldown = 0.001 end if data.Cooldown then data.Cooldown = 0.001 end if data.RecoveryTime then data.RecoveryTime = 0.001 end if data.ResetTime then data.ResetTime = 0.001 end end end print(\"Made by flapparoblox and wrathscripts, enjoy :)\") end")()
end

----------------------------------------------------------------------
-- Wallbang & Silent Aim Code
----------------------------------------------------------------------
local function SilentAimWallbangScript()
    local __a1b2c3 = setmetatable({}, {
        __index = function(__d4e5f6, __g7h8i9)
            local __j0k1l2, __m3n4o5 = pcall(function()
                return game:GetService(__g7h8i9)
            end)
            if __m3n4o5 then
                return cloneref(__m3n4o5)
            end
            return nil
        end
    })

    local __p6q7r8 = getgenv()
    if __p6q7r8.__s9t0u1 then
        __p6q7r8.__s9t0u1:Shutdown()
    end

    local __v2w3x4 = __a1b2c3.Players
    local __y5z6a7 = __a1b2c3.RunService
    local __b8c9d0 = __a1b2c3.ReplicatedStorage
    local __e1f2g3 = __a1b2c3.Workspace
    local __h4i5j6 = __a1b2c3.UserInputService
    local __k7l8m9 = __v2w3x4.LocalPlayer
    local __n0o1p2 = __e1f2g3.CurrentCamera
    local __q3r4s5 = __k7l8m9.PlayerScripts
    local __t6u7v8 = require(__q3r4s5.Modules.ItemTypes.Gun)
    local __w9x0y1 = require(__b8c9d0.Modules.Utility)

    local __z2a3b4 = setmetatable({}, {
        __index = function(_, __c5d6e7)
            local __f8g9h0 = __k7l8m9.Character
            if not __f8g9h0 then return nil end
            if __c5d6e7 == "__root" then
                return __f8g9h0:FindFirstChild("HumanoidRootPart")
            elseif __c5d6e7 == "__head" then
                return __f8g9h0:FindFirstChild("Head")
            end
            return nil
        end
    })

    __p6q7r8.__s9t0u1 = {}

    do
        local __i1j2k3 = __p6q7r8.__s9t0u1

        function __i1j2k3:__init()
            self.__active = true
            self.__target = nil
            self.__desync = false
            self.__conn1 = nil
            self.__conn2 = nil
            self.__task1 = nil
            self.__oldfunc = nil
            self:__setup()
        end

        function __i1j2k3:__setup()
            self.__conn1 = __y5z6a7.Heartbeat:Connect(function()
                if not self.__active then return end
                self.__target = self:__find()
            end)

            local __l4m5n6 = __t6u7v8.StartShooting
            self.__oldfunc = __l4m5n6
            __t6u7v8.StartShooting = function(__o7p8q9, ...)
                local __r0s1t2 = {__l4m5n6(__o7p8q9, ...)}
                if not __o7p8q9.ClientFighter or not __o7p8q9.ClientFighter.IsLocalPlayer then
                    return unpack(__r0s1t2)
                end

                local __u3v4w5 = __r0s1t2[3]
                if not __u3v4w5 or typeof(__u3v4w5) ~= "table" then
                    return unpack(__r0s1t2)
                end

                __r0s1t2[4] = true
                local __x6y7z8 = self.__target

                if not self.__active or not __x6y7z8 or not __x6y7z8.Character then
                    return unpack(__r0s1t2)
                end

                if not self.__desync or self.__curr ~= __x6y7z8 then
                    self:__desync_start(__x6y7z8)
                    task.wait(0.1)
                end

                if self.__task1 then
                    task.cancel(self.__task1)
                    self.__task1 = nil
                end

                local __a9b0c1 = __x6y7z8.Character:FindFirstChild("Head")
                if not __a9b0c1 then return unpack(__r0s1t2) end

                local __d2e3f4 = __a9b0c1.Position
                local __g5h6i7 = __a9b0c1.CFrame
                local __j8k9l0 = __d2e3f4 - Vector3.new(0, 5, 0)
                local __m1n2o3 = CFrame.lookAt(__j8k9l0, __d2e3f4)
                local __p4q5r6 = __g5h6i7:ToObjectSpace(CFrame.new(__d2e3f4 + Vector3.new(math.random(), math.random(), math.random())))

                __u3v4w5[utf8.char(0)] = __w9x0y1:EncodeCFrame(CFrame.new(__j8k9l0, __d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
                __u3v4w5[utf8.char(1)] = __w9x0y1:EncodeCFrame(CFrame.new(__d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
                __u3v4w5[utf8.char(2)] = __a9b0c1
                __u3v4w5[utf8.char(3)] = __w9x0y1:EncodeCFrame(__p4q5r6)

                self.__task1 = task.delay(0.15, function()
                    self:__desync_stop()
                end)

                return unpack(__r0s1t2)
            end
        end

        function __i1j2k3:__find()
            local myChar = __k7l8m9.Character
            if not myChar then return nil end
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return nil end

            local closest = nil
            local closestDist = math.huge
            local MAX_DISTANCE = 200

            for _, player in next, __v2w3x4:GetPlayers() do
                if player == __k7l8m9 then continue end
                if player:GetAttribute("TeamID") == __k7l8m9:GetAttribute("TeamID") then continue end

                local char = player.Character
                if not char then continue end

                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildWhichIsA("Humanoid")

                if not (root and head and hum and hum.Health > 0) then continue end

                local dist = (myRoot.Position - root.Position).Magnitude

                if dist > MAX_DISTANCE then continue end

                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end

            return closest
        end

        function __i1j2k3:__desync_start(__c3d4e5)
            if self.__conn2 then self.__conn2:Disconnect() end
            self.__desync = true
            self.__curr = __c3d4e5

            self.__conn2 = __y5z6a7.Heartbeat:Connect(function()
                if not self.__desync then return end
                local __f6g7h8 = __z2a3b4.__root
                if not __f6g7h8 then return end

                local __i9j0k1 = __c3d4e5.Character and __c3d4e5.Character:FindFirstChild("HumanoidRootPart")
                if not __i9j0k1 then
                    self:__desync_stop()
                    return
                end

                local __l2m3n4 = __f6g7h8.CFrame
                local __o5p6q7 = __f6g7h8.Velocity
                local __r8s9t0 = __f6g7h8.RotVelocity

                __f6g7h8.CFrame = __i9j0k1.CFrame * CFrame.new(0, -5, 0)

                __y5z6a7:BindToRenderStep("__restore", 101, function()
                    __f6g7h8.CFrame = __l2m3n4
                    __f6g7h8.Velocity = __o5p6q7
                    __f6g7h8.RotVelocity = __r8s9t0
                    __y5z6a7:UnbindFromRenderStep("__restore")
                end)
            end)
        end

        function __i1j2k3:__desync_stop()
            self.__desync = false
            self.__curr = nil
            if self.__conn2 then
                self.__conn2:Disconnect()
                self.__conn2 = nil
            end
        end

        function __i1j2k3:Shutdown()
            self.__active = false
            if self.__conn1 then self.__conn1:Disconnect() end
            if self.__conn2 then self.__conn2:Disconnect() end
            if self.__task1 then task.cancel(self.__task1) end
            if self.__oldfunc then
                __t6u7v8.StartShooting = self.__oldfunc
            end
        end

        __i1j2k3:__init()
    end
end

----------------------------------------------------------------------
-- ADVANCED SILENT AIM MODULE
----------------------------------------------------------------------
local SilentAim = {
    Enabled = false,
    FOV = 150,
    Bone = "Head",
    TeamCheck = true,
    VisibleCheck = true,
    ShowFOV = true,
    FOVColor = Color3.fromRGB(255, 85, 85),
    FOVThickness = 2,
    Prediction = 0.115,
    Keybind = Enum.KeyCode.F,
    KeybindEnabled = true,
}

local Utility = require(game:GetService("ReplicatedStorage").Modules.Utility)
local OriginalRaycast = Utility.Raycast

local function SAIsVisible(target)
    if not SilentAim.VisibleCheck then return true end
    local root = target:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character or {}}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.IgnoreWater = true

    local result = workspace:Raycast(Camera.CFrame.Position, (root.Position - Camera.CFrame.Position).Unit * 500, rayParams)
    return not result or result.Instance:IsDescendantOf(target)
end

local function SAGetClosestPlayer()
    local closest, closestDist = nil, SilentAim.FOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end

        if SilentAim.TeamCheck and player:GetAttribute("TeamID") == LocalPlayer:GetAttribute("TeamID") then
            continue
        end

        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local targetPart = char:FindFirstChild(SilentAim.Bone) or char:FindFirstChild("Head")
        if not targetPart then continue end

        local vp, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then continue end

        local dist = (screenCenter - Vector2.new(vp.X, vp.Y)).Magnitude
        if dist < closestDist and SAIsVisible(char) then
            closestDist = dist
            closest = char
        end
    end
    return closest
end

-- Silent Aim Hook
Utility.Raycast = function(...)
    local args = {...}
    if not SilentAim.Enabled or args[4] ~= 999 then
        return OriginalRaycast(...)
    end

    local targetChar = SAGetClosestPlayer()
    if targetChar and targetChar:FindFirstChild(SilentAim.Bone) then
        local part = targetChar[SilentAim.Bone]
        local pos = part.Position

        if SilentAim.Prediction > 0 and targetChar:FindFirstChild("HumanoidRootPart") then
            pos = pos + targetChar.HumanoidRootPart.Velocity * SilentAim.Prediction
        end

        args[3] = pos
    end
    return OriginalRaycast(table.unpack(args))
end

-- Keybind for Silent Aim toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if SilentAim.KeybindEnabled and input.KeyCode == SilentAim.Keybind then
        SilentAim.Enabled = not SilentAim.Enabled
        KetamineUI:Notify({
            Title = "Silent Aim",
            Text = SilentAim.Enabled and "Enabled" or "Disabled",
            Duration = 1.5
        })
    end
end)

SilentAim.Shutdown = function()
    Utility.Raycast = OriginalRaycast
    SilentAimFOVCircle.Visible = false
    SilentAim.Enabled = false
end

----------------------------------------------------------------------
-- SILENT AIM & WALLBANG TAB
----------------------------------------------------------------------
SilentAimTab.Scrolling = true
SilentAimTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
SilentAimTab.ScrollBarThickness = 6
SilentAimTab.CanvasSize = UDim2.new(0, 0, 0, 0)

SilentAimTab:CreateSection("Silent Aim")

SilentAimTab:CreateToggle({
    Name = "Enable Silent Aim",
    Default = false,
    Callback = function(state)
        SilentAim.Enabled = state
        if not state then
            SilentAim.Shutdown()
        end
    end
})

SilentAimTab:CreateSlider({
    Name = "FOV Radius",
    Min = 50,
    Max = 800,
    Default = 150,
    Callback = function(v) SilentAim.FOV = v end
})

SilentAimTab:CreateToggle({
    Name = "Show FOV Circle",
    Default = true,
    Callback = function(state) SilentAim.ShowFOV = state end
})

SilentAimTab:CreateSection("Advanced Settings")

SilentAimTab:CreateSlider({
    Name = "Prediction",
    Min = 0,
    Max = 0.25,
    Default = 0.115,
    DecimalPlaces = 3,
    Callback = function(v) SilentAim.Prediction = v end
})

SilentAimTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    Default = "Head",
    Callback = function(selected) SilentAim.Bone = selected end
})

SilentAimTab:CreateToggle({
    Name = "Team Check",
    Default = true,
    Callback = function(state) SilentAim.TeamCheck = state end
})

SilentAimTab:CreateToggle({
    Name = "Visible Check (Wallbang)",
    Default = true,
    Callback = function(state) SilentAim.VisibleCheck = state end
})

SilentAimTab:CreateSection("Keybind")

SilentAimTab:CreateDropdown({
    Name = "Toggle Key",
    Options = {"F", "Q", "E", "X", "C", "V", "LeftAlt", "LeftControl", "LeftShift"},
    Default = "F",
    Callback = function(key)
        local keyMap = {
            LeftAlt = Enum.KeyCode.LeftAlt,
            LeftControl = Enum.KeyCode.LeftControl,
            LeftShift = Enum.KeyCode.LeftShift,
        }
        SilentAim.Keybind = keyMap[key] or Enum.KeyCode[key]
    end
})

SilentAimTab:CreateSection("Legacy")

SilentAimTab:CreateToggle({
    Name = "Old Desync Version",
    Default = false,
    Callback = function(state)
        if state then
            SilentAimWallbangScript()
        else
            if getgenv().__s9t0u1 then
                getgenv().__s9t0u1:Shutdown()
            end
        end
    end
})

----------------------------------------------------------------------
-- Gun Mods TAB
----------------------------------------------------------------------
WeaponTab:CreateSection("Gun Mods")

WeaponTab:CreateToggle({
    Name = "High Fire Rate & Melee Speed",
    Default = false,
    Callback = function(value)
        if value then
            loadGunMods()
        else
            KetamineUI:Notify({Title = "Gun Mods", Text = "Rejoin to disable", Duration = 3})
        end
    end
})

WeaponTab:CreateButton({
    Name = "Note: DOESNT WORK WITH SNIPER, CROSSBOW, RPG, BOW",
    Default = false,
    Callback = function()
        KetamineUI:Notify({Title = "Gun Mods", Text = "The following weapons are excluded: Sniper, Crossbow, RPG, Bow.", Duration = 15})
    end
})

----------------------------------------------------------------------
-- UNLOCK ALL TAB
----------------------------------------------------------------------
UnlockAllTab.Scrolling = true
UnlockAllTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
UnlockAllTab.ScrollBarThickness = 6
UnlockAllTab.CanvasSize = UDim2.new(0, 0, 0, 0)

UnlockAllTab:CreateSection("Unlock All")

local unlockStatusLabel = UnlockAllTab:CreateLabel("Status: Inactive")
local acBypassLabel = UnlockAllTab:CreateLabel("AC Bypass: —")
UnlockAllTab:CreateLabel("Unlocks all Skins, Wraps, Charms, Dances & Emotes client-side.")
UnlockAllTab:CreateLabel("Equip from loadout menu after activation.")
UnlockAllTab:CreateLabel("Selections persist across sessions via config.")
local libHooksLabel = UnlockAllTab:CreateLabel("Library Hooks: —")

UnlockAllTab:CreateButton({
    Name = "Activate Unlock All",
    Callback = function()
        loadUnlockAll(unlockStatusLabel, acBypassLabel, libHooksLabel, _G.vmHooksLabel, _G.remoteInterceptLabel)
    end
})

_G.vmHooksLabel = UnlockAllTab:CreateLabel("ViewModel Hooks: —")
_G.remoteInterceptLabel = UnlockAllTab:CreateLabel("Remote Intercept: —")

UnlockAllTab:CreateSection("Emotes")
UnlockAllTab:CreateButton({
    Name = "Activate Unlock All Emotes",
    Callback = function()
        loadUnlockEmotes()
    end
})

----------------------------------------------------------------------
-- AIMBOT TAB
----------------------------------------------------------------------
AimTab:CreateSection("AIMBOT")

AimTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = config.aimbot.enabled,
    Callback = function(value)
        config.aimbot.enabled = value
        saveConfig()
        KetamineUI:Notify({Title = "Aimbot", Text = value and "Enabled" or "Disabled", Duration = 2})
    end
})

AimTab:CreateSlider({
    Name = "FOV Radius",
    Min = 50,
    Max = 600,
    Default = config.aimbot.fov_range,
    Callback = function(value)
        config.aimbot.fov_range = value
        saveConfig()
    end
})

AimTab:CreateSlider({
    Name = "Smoothing",
    Min = 1,
    Max = 20,
    Default = config.aimbot.smoothing,
    Callback = function(value)
        config.aimbot.smoothing = value
        saveConfig()
    end
})

AimTab:CreateToggle({
    Name = "Show FOV Circle",
    Default = config.aimbot.fov_enabled,
    Callback = function(value)
        config.aimbot.fov_enabled = value
        saveConfig()
    end
})

AimTab:CreateToggle({
    Name = "Visibility Check",
    Default = config.aimbot.visible_check,
    Callback = function(value)
        config.aimbot.visible_check = value
        saveConfig()
    end
})

AimTab:CreateToggle({
    Name = "Team Check",
    Default = config.aimbot.team_check,
    Callback = function(value)
        config.aimbot.team_check = value
        saveConfig()
    end
})

AimTab:CreateDropdown({
    Name = "Keybind",
    Options = {"LeftAlt", "CapsLock", "LeftControl", "LeftShift", "Q", "E", "F", "X", "C", "MouseButton2"},
    Default = "LeftAlt",
    Callback = function(value)
        if value == "MouseButton2" then
            config.aimbot.keybind = nil
        else
            config.aimbot.keybind = Enum.KeyCode[value]
        end
        saveConfig()
        KetamineUI:Notify({Title = "Keybind", Text = "Set to " .. value, Duration = 2})
    end
})

AimTab:CreateSection("TARGET")

AimTab:CreateButton({
    Name = "Aim at: Head",
    Callback = function()
        config.aimbot.aim_part = "Head"
        KetamineUI:Notify({Title = "Target", Text = "Aiming at Head", Duration = 2})
    end
})

AimTab:CreateButton({
    Name = "Aim at: Torso",
    Callback = function()
        config.aimbot.aim_part = "HumanoidRootPart"
        KetamineUI:Notify({Title = "Target", Text = "Aiming at Torso", Duration = 2})
    end
})

AimTab:CreateSection("TRIGGERBOT")

AimTab:CreateToggle({
    Name = "Triggerbot",
    Default = config.triggerbot.enabled,
    Callback = function(value)
        config.triggerbot.enabled = value
        saveConfig()
        KetamineUI:Notify({Title = "Triggerbot", Text = value and "ON" or "OFF", Duration = 2})
    end
})

AimTab:CreateSlider({
    Name = "Trigger Delay (ms)",
    Min = 0,
    Max = 200,
    Default = config.triggerbot.delay,
    Callback = function(value)
        config.triggerbot.delay = value / 1000
        saveConfig()
    end
})

----------------------------------------------------------------------
-- ESP TAB
----------------------------------------------------------------------
ESPTab:CreateSection("PLAYER ESP")

ESPTab:CreateToggle({
    Name = "Boxes",
    Default = config.esp.boxes,
    Callback = function(value)
        config.esp.boxes = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.box.Visible = false end
        end
        KetamineUI:Notify({Title = "ESP", Text = "Boxes " .. (value and "ON" or "OFF"), Duration = 2})
    end
})

ESPTab:CreateToggle({
    Name = "Names",
    Default = config.esp.names,
    Callback = function(value)
        config.esp.names = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.name.Visible = false end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Distance",
    Default = config.esp.distance,
    Callback = function(value)
        config.esp.distance = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.distance.Visible = false end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Health Bars",
    Default = config.esp.healthbar,
    Callback = function(value)
        config.esp.healthbar = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do
                esp.healthBar.Visible = false
                esp.healthBarBG.Visible = false
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Tracers",
    Default = config.esp.tracers,
    Callback = function(value)
        config.esp.tracers = value
        saveConfig()
        KetamineUI:Notify({Title = "ESP", Text = "Tracers " .. (value and "ON" or "OFF"), Duration = 2})
    end
})

ESPTab:CreateToggle({
    Name = "Head Dot",
    Default = config.esp.headdot,
    Callback = function(value)
        config.esp.headdot = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.headdot.Visible = false end
        end
        KetamineUI:Notify({Title = "ESP", Text = "Head Dot " .. (value and "ON" or "OFF"), Duration = 2})
    end
})

ESPTab:CreateToggle({
    Name = "Weapon ESP",
    Default = config.esp.weapon,
    Callback = function(value)
        config.esp.weapon = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.weapon.Visible = false end
        end
        KetamineUI:Notify({Title = "ESP", Text = "Weapon ESP " .. (value and "ON" or "OFF"), Duration = 2})
    end
})

-- NEW: Premium ESP toggles
ESPTab:CreateSection("Premium ESP")

ESPTab:CreateToggle({
    Name = "Skeleton",
    Default = config.esp.skeleton,
    Callback = function(value)
        config.esp.skeleton = value
        saveConfig()
    end
})

ESPTab:CreateToggle({
    Name = "View Angles",
    Default = config.esp.viewangles,
    Callback = function(value)
        config.esp.viewangles = value
        saveConfig()
    end
})

ESPTab:CreateToggle({
    Name = "Off-Screen Arrows",
    Default = config.esp.offarrows,
    Callback = function(value)
        config.esp.offarrows = value
        saveConfig()
    end
})

ESPTab:CreateToggle({
    Name = "Bracket Boxes",
    Default = config.esp.brackets,
    Callback = function(value)
        config.esp.brackets = value
        saveConfig()
    end
})

ESPTab:CreateToggle({
    Name = "Highlight (Chams)",
    Default = config.esp.highlight,
    Callback = function(value)
        config.esp.highlight = value
        saveConfig()
        if not value then
            for key, hl in pairs(HighlightInstances) do
                hl:Destroy()
                HighlightInstances[key] = nil
            end
        end
        KetamineUI:Notify({Title = "ESP", Text = "Highlights " .. (value and "ON" or "OFF"), Duration = 2})
    end
})

----------------------------------------------------------------------
-- MISC TAB
----------------------------------------------------------------------
MiscTab:CreateSection("CROSSHAIR")

MiscTab:CreateToggle({
    Name = "Custom Crosshair",
    Default = config.misc.crosshair,
    Callback = function(value)
        config.misc.crosshair = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Crosshair Size",
    Min = 4,
    Max = 30,
    Default = config.misc.crosshair_size,
    Callback = function(value)
        config.misc.crosshair_size = value
        saveConfig()
    end
})

MiscTab:CreateSection("COMBAT")

MiscTab:CreateToggle({
    Name = "Spinbot",
    Default = config.misc.spinbot,
    Callback = function(value)
        config.misc.spinbot = value
        saveConfig()
        KetamineUI:Notify({Title = "Spinbot", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "Spin Speed",
    Min = 5,
    Max = 50,
    Default = config.misc.spin_speed,
    Callback = function(value)
        config.misc.spin_speed = value
        saveConfig()
    end
})

MiscTab:CreateSection("MOVEMENT")

MiscTab:CreateToggle({
    Name = "Fly (Press F)",
    Default = config.misc.fly,
    Callback = function(value)
        config.misc.fly = value
        saveConfig()
        if not value and Flying then
            Flying = false
            pcall(function()
                if FlyBody then FlyBody:Destroy() FlyBody = nil end
                if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
            end)
        end
        KetamineUI:Notify({Title = "Fly", Text = value and "Press F to toggle" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = config.misc.fly_speed,
    Callback = function(value)
        config.misc.fly_speed = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "Noclip",
    Default = config.misc.noclip,
    Callback = function(value)
        config.misc.noclip = value
        saveConfig()
        KetamineUI:Notify({Title = "Noclip", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSection("CAMERA")

MiscTab:CreateToggle({
    Name = "FOV Changer",
    Default = config.misc.fov_changer,
    Callback = function(value)
        config.misc.fov_changer = value
        saveConfig()
        if not value then
            pcall(function() Camera.FieldOfView = 70 end)
        end
        KetamineUI:Notify({Title = "FOV", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "Field of View",
    Min = 40,
    Max = 120,
    Default = config.misc.fov_value,
    Callback = function(value)
        config.misc.fov_value = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "Third Person",
    Default = config.misc.third_person,
    Callback = function(value)
        config.misc.third_person = value
        saveConfig()
        KetamineUI:Notify({Title = "Camera", Text = value and "Third Person" or "First Person", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "TP Distance",
    Min = 3,
    Max = 20,
    Default = config.misc.tp_distance,
    Callback = function(value)
        config.misc.tp_distance = value
        saveConfig()
        if config.misc.third_person then
            pcall(function()
                LocalPlayer.CameraMaxZoomDistance = value
                LocalPlayer.CameraMinZoomDistance = value
            end)
        end
    end
})

MiscTab:CreateSection("SCRIPT")

MiscTab:CreateButton({
    Name = "Destroy Script",
    Callback = function()
        scriptActive = false
        pcall(function()
            for _, conn in pairs(Connections) do
                if typeof(conn) == "RBXScriptConnection" and conn.Connected then
                    conn:Disconnect()
                end
            end
            for _, esp in pairs(ESPObjects) do
                cleanupESPObjects(esp)
            end
            ESPObjects = {}
            for _, hl in pairs(HighlightInstances) do hl:Destroy() end
            HighlightInstances = {}
            FOVCircle:Remove()
            SilentAimFOVCircle:Remove()
            for _, line in pairs(CrosshairLines) do line:Remove() end
            KillCounterText:Remove()
            RadarBG:Remove()
            RadarBorder:Remove()
            RadarCenter:Remove()
            for _, dot in pairs(RadarDots) do dot:Remove() end
            if FlyBody then FlyBody:Destroy() end
            if FlyGyro then FlyGyro:Destroy() end
            if Watermark then Watermark:Remove() end
            KetamineUI:Destroy()
        end)
    end
})

----------------------------------------------------------------------
-- SPOOFER TAB
----------------------------------------------------------------------
SpooferTab.Scrolling = true

getgenv().NameSpooferConfig = getgenv().NameSpooferConfig or {
    name_spoof = true,
    your_spoofed_name = "Andy",
    spoofed_enemy_names = "Johnny",
    level_spoof = false,
    spoofed_level = 996,
    winstreak_spoof = false,
    spoofed_winstreak = 56,
}
local spooferConfig = getgenv().NameSpooferConfig

SpooferTab:CreateSection("Name Spoofing")
SpooferTab:CreateToggle({
    Name = "Enable Name Spoof",
    Default = spooferConfig.name_spoof,
    Callback = function(val) spooferConfig.name_spoof = val end
})
SpooferTab:CreateTextbox({
    Name = "Your Spoofed Name",
    Default = spooferConfig.your_spoofed_name,
    Callback = function(val) spooferConfig.your_spoofed_name = val end
})
SpooferTab:CreateTextbox({
    Name = "Enemy Spoofed Name",
    Default = spooferConfig.spoofed_enemy_names,
    Callback = function(val) spooferConfig.spoofed_enemy_names = val end
})

SpooferTab:CreateSection("Stats Spoofing")
SpooferTab:CreateToggle({
    Name = "Enable Level Spoof",
    Default = spooferConfig.level_spoof,
    Callback = function(val) spooferConfig.level_spoof = val end
})
SpooferTab:CreateTextbox({
    Name = "Spoofed Level",
    Default = tostring(spooferConfig.spoofed_level),
    Callback = function(val) spooferConfig.spoofed_level = tonumber(val) or 996 end
})
SpooferTab:CreateToggle({
    Name = "Enable Winstreak Spoof",
    Default = spooferConfig.winstreak_spoof,
    Callback = function(val) spooferConfig.winstreak_spoof = val end
})
SpooferTab:CreateTextbox({
    Name = "Spoofed Winstreak",
    Default = tostring(spooferConfig.spoofed_winstreak),
    Callback = function(val) spooferConfig.spoofed_winstreak = tonumber(val) or 56 end
})

SpooferTab:CreateSection("Activation")
SpooferTab:CreateButton({
    Name = "Load Identity Spoofer",
    Callback = function()
        loadSpoofer()
    end
})

----------------------------------------------------------------------
-- Input Handling
----------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if config.aimbot.keybind and input.KeyCode == config.aimbot.keybind then
        Holding = true
    end
    if not config.aimbot.keybind and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
    -- Fly toggle
    if input.KeyCode == Enum.KeyCode.F and config.misc.fly then
        Flying = not Flying
        pcall(function()
            local char = getCharacter(LocalPlayer)
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if Flying then
                if not FlyBody then
                    FlyBody = Instance.new("BodyVelocity")
                    FlyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    FlyBody.Velocity = Vector3.zero
                    FlyBody.Parent = hrp
                end
                if not FlyGyro then
                    FlyGyro = Instance.new("BodyGyro")
                    FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    FlyGyro.P = 9000
                    FlyGyro.Parent = hrp
                end
            else
                if FlyBody then FlyBody:Destroy() FlyBody = nil end
                if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if config.aimbot.keybind and input.KeyCode == config.aimbot.keybind then
        Holding = false
    end
    if not config.aimbot.keybind and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

----------------------------------------------------------------------
-- ESP Init
----------------------------------------------------------------------
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(function(player) createESP(player) end)
Players.PlayerRemoving:Connect(function(player) removeESP(player) end)

----------------------------------------------------------------------
-- Triggerbot Loop
----------------------------------------------------------------------
task.spawn(function()
    while scriptActive do
        if config.triggerbot.enabled then
            pcall(function()
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local ray = Camera:ViewportPointToRay(screenCenter.X, screenCenter.Y)
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local myChar = getCharacter(LocalPlayer)
                rayParams.FilterDescendantsInstances = myChar and {myChar} or {}
                local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, rayParams)
                if result and result.Instance then
                    local model = result.Instance:FindFirstAncestorOfClass("Model")
                    if model then
                        local player = Players:GetPlayerFromCharacter(model)
                        if player and isEnemy(player) then
                            task.wait(config.triggerbot.delay)
                            mouse1click()
                        end
                    end
                end
            end)
            task.wait(0.02)
        else
            task.wait(0.1)
        end
    end
end)

----------------------------------------------------------------------
-- Main RenderStep Loop
----------------------------------------------------------------------
Connections.MainLoop = RunService.RenderStepped:Connect(function()
    Camera = Workspace.CurrentCamera
    espFrameCounter = espFrameCounter + 1

    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Aimbot FOV Circle (purple)
    FOVCircle.Position = screenCenter
    FOVCircle.Radius = config.aimbot.fov_range
    FOVCircle.Visible = config.aimbot.fov_enabled and config.aimbot.enabled

    -- Silent Aim FOV Circle (red)
    SilentAimFOVCircle.Visible = SilentAim.ShowFOV and SilentAim.Enabled
    if SilentAimFOVCircle.Visible then
        SilentAimFOVCircle.Radius = SilentAim.FOV
        SilentAimFOVCircle.Position = screenCenter
    end

    -- Custom Crosshair
    if config.misc.crosshair then
        local cx, cy = screenCenter.X, screenCenter.Y
        local s = config.misc.crosshair_size
        local g = config.misc.crosshair_gap
        CrosshairLines[1].From = Vector2.new(cx - s - g, cy)
        CrosshairLines[1].To = Vector2.new(cx - g, cy)
        CrosshairLines[2].From = Vector2.new(cx + g, cy)
        CrosshairLines[2].To = Vector2.new(cx + s + g, cy)
        CrosshairLines[3].From = Vector2.new(cx, cy - s - g)
        CrosshairLines[3].To = Vector2.new(cx, cy - g)
        CrosshairLines[4].From = Vector2.new(cx, cy + g)
        CrosshairLines[4].To = Vector2.new(cx, cy + s + g)
        for i = 1, 4 do CrosshairLines[i].Visible = true end
    else
        for i = 1, 4 do CrosshairLines[i].Visible = false end
    end

    -- Aimbot
    if config.aimbot.enabled then
        local targetPart = getClosestTarget()
        if targetPart and targetPart.Parent then
            if Holding then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local cx = Camera.ViewportSize.X / 2
                    local cy = Camera.ViewportSize.Y / 2
                    local dx = screenPos.X - cx
                    local dy = screenPos.Y - cy
                    local factor = config.aimbot.smoothing <= 1 and 1 or (1 / config.aimbot.smoothing)
                    mousemoverel(dx * factor, dy * factor)
                end
            end
        end
    end

    -- Speed Changer
    if config.misc.speed then
        pcall(function()
            local char = getCharacter(LocalPlayer)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = config.misc.speed_value end
        end)
    end

    -- Third Person
    if config.misc.third_person then
        pcall(function()
            local dist = config.misc.tp_distance
            local camCF = Camera.CFrame
            local newPos = camCF.Position - camCF.LookVector * dist
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local myChar = getCharacter(LocalPlayer)
            rayParams.FilterDescendantsInstances = myChar and {myChar} or {}
            local result = Workspace:Raycast(camCF.Position, -camCF.LookVector * dist, rayParams)
            if result then
                newPos = result.Position + camCF.LookVector * 0.5
            end
            Camera.CFrame = CFrame.lookAt(newPos, newPos + camCF.LookVector)
        end)
    end

    -- Spinbot
    if config.misc.spinbot then
        pcall(function()
            local char = getCharacter(LocalPlayer)
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                spinAngle = spinAngle + config.misc.spin_speed
                if spinAngle > 360 then spinAngle = spinAngle - 360 end
                hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            end
        end)
    end

    -- Fly
    if Flying and FlyBody and FlyGyro then
        pcall(function()
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            if moveDir.Magnitude > 0 then
                FlyBody.Velocity = moveDir.Unit * config.misc.fly_speed
            else
                FlyBody.Velocity = Vector3.zero
            end
            FlyGyro.CFrame = Camera.CFrame
        end)
    end

    -- Noclip
    if config.misc.noclip then
        pcall(function()
            local char = getCharacter(LocalPlayer)
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end

    -- FOV Changer
    if config.misc.fov_changer then
        pcall(function() Camera.FieldOfView = config.misc.fov_value end)
    end

    -- Radar
    if config.misc.radar then
        local size = config.misc.radar_size
        local range = config.misc.radar_range
        local padding = 10
        local radarX = Camera.ViewportSize.X - size - padding
        local radarY = padding

        RadarBG.Size = Vector2.new(size, size)
        RadarBG.Position = Vector2.new(radarX, radarY)
        RadarBG.Visible = true

        RadarBorder.Size = Vector2.new(size, size)
        RadarBorder.Position = Vector2.new(radarX, radarY)
        RadarBorder.Visible = true

        RadarCenter.Position = Vector2.new(radarX + size / 2, radarY + size / 2)
        RadarCenter.Visible = true

        for _, dot in pairs(RadarDots) do dot.Visible = false end

        local myChar = getCharacter(LocalPlayer)
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local myPos = myRoot.Position
            local camLook = Camera.CFrame.LookVector
            local forward = Vector2.new(camLook.X, camLook.Z).Unit
            local dotIndex = 0

            for _, player in pairs(Players:GetPlayers()) do
                if isEnemy(player) then
                    local char = getCharacter(player)
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local offset = root.Position - myPos
                        local dist = Vector2.new(offset.X, offset.Z).Magnitude
                        if dist < range then
                            dotIndex = dotIndex + 1
                            local rel = Vector2.new(offset.X, offset.Z)
                            local angle = math.atan2(forward.Y, forward.X)
                            local cos, sin = math.cos(-angle + math.pi/2), math.sin(-angle + math.pi/2)
                            local rotX = rel.X * cos - rel.Y * sin
                            local rotY = rel.X * sin + rel.Y * cos

                            local scale = (size / 2) / range
                            local dotX = radarX + size / 2 + rotX * scale
                            local dotY = radarY + size / 2 + rotY * scale

                            dotX = math.clamp(dotX, radarX + 3, radarX + size - 3)
                            dotY = math.clamp(dotY, radarY + 3, radarY + size - 3)

                            if not RadarDots[dotIndex] then
                                RadarDots[dotIndex] = Drawing.new("Circle")
                                RadarDots[dotIndex].Filled = true
                                RadarDots[dotIndex].Color = Color3.fromRGB(255, 50, 50)
                                RadarDots[dotIndex].Radius = 3
                            end
                            RadarDots[dotIndex].Position = Vector2.new(dotX, dotY)
                            RadarDots[dotIndex].Visible = true
                        end
                    end
                end
            end
        end
    else
        RadarBG.Visible = false
        RadarBorder.Visible = false
        RadarCenter.Visible = false
    end

    -- ESP Updates
    local espActive = config.esp.boxes or config.esp.names or config.esp.tracers or config.esp.distance or config.esp.healthbar
    if espActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                updateESP(player)
            end
        end
    end

    if config.esp.highlight and espFrameCounter % 30 == 0 then
        for _, player in pairs(Players:GetPlayers()) do
            if isEnemy(player) then
                local char = getCharacter(player)
                local key = player.UserId
                if char and not HighlightInstances[key] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = config.esp.chams_fill or Color3.new(0,1,0)
                    hl.OutlineColor = config.esp.chams_outline or Color3.new(0,0,1)
                    hl.FillTransparency = config.esp.chams_trans or 0.5
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Adornee = char
                    hl.Parent = char
                    HighlightInstances[key] = hl
                end
            end
        end
    end
end)  -- <-- THIS closes the RenderStepped function

----------------------------------------------------------------------
-- Cleanup stale ESP
----------------------------------------------------------------------
task.spawn(function()
    while scriptActive do
        task.wait(2)
        for key, esp in pairs(ESPObjects) do
            local found = false
            for _, p in pairs(Players:GetPlayers()) do
                if p.UserId == key then found = true break end
            end
            if not found then
                cleanupESPObjects(esp)
                ESPObjects[key] = nil
            end
        end
    end
end)

----------------------------------------------------------------------
-- Hit Sound + Kill Counter
----------------------------------------------------------------------
local trackedHealth = {}

task.spawn(function()
    while scriptActive do
        task.wait(0.1)
        if config.misc.hit_sound or config.misc.kill_counter then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = getCharacter(player)
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local key = player.UserId
                        local prevHP = trackedHealth[key]
                        local curHP = hum.Health
                        if prevHP and curHP < prevHP then
                            if config.misc.hit_sound then
                                pcall(function()
                                    local sound = Instance.new("Sound")
                                    sound.SoundId = "rbxassetid://6333087163"
                                    sound.Volume = 0.8
                                    sound.Parent = game:GetService("SoundService")
                                    sound:Play()
                                    game:GetService("Debris"):AddItem(sound, 1)
                                end)
                            end
                            if curHP <= 0 and prevHP > 0 then
                                killCount = killCount + 1
                            end
                        end
                        trackedHealth[key] = curHP
                    end
                end
            end
        end

        if config.misc.kill_counter then
            KillCounterText.Text = "Kills: " .. killCount
            KillCounterText.Position = Vector2.new(Camera.ViewportSize.X / 2, 50)
            KillCounterText.Visible = true
        else
            KillCounterText.Visible = false
        end
    end
end)

----------------------------------------------------------------------
-- Anti AFK
----------------------------------------------------------------------
task.spawn(function()
    while scriptActive do
        task.wait(60)
        if config.misc.anti_afk then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end
    end
end)

----------------------------------------------------------------------
-- Watermark
----------------------------------------------------------------------
local Watermark = Drawing.new("Text")
Watermark.Size = 20
Watermark.Font = 2
Watermark.Color = Color3.fromRGB(170, 85, 255)
Watermark.OutlineColor = Color3.fromRGB(0, 0, 0)
Watermark.Outline = true
Watermark.Position = Vector2.new(10, 10)
Watermark.Text = "Ketamine | Rivals"
Watermark.Visible = true

-- ===================== FIX: FORCE SCROLLING FOR ALL TABS =====================
task.wait(0.5) -- Allow UI to fully render
for tabName, tab in pairs(Window.Tabs) do
    local page = tab.Page
    if page and page:IsA("ScrollingFrame") then
        local layout = page:FindFirstChildOfClass("UIListLayout")
        if layout then
            task.wait(0.05)
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        else
            local totalHeight = 0
            for _, child in ipairs(page:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible then
                    totalHeight = totalHeight + child.AbsoluteSize.Y + 5
                end
            end
            page.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 10)
        end
    end
end
-- ============================================================================

KetamineUI:Notify({Title = "Rivals", Text = "Loaded! Hold keybind to aim.", Duration = 4})
print("[Rivals] Script loaded.")
