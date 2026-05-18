--[[
    Ketamine Universal Script
    Works in any Roblox game with player characters.
    
    Features:
      - ESP (Highlight + Name + Health + Distance + Tracers)
      - Aimbot (Smooth / Snap, FOV circle, target part selection)
      - Triggerbot (Auto-shoot when crosshair is on target)
      - Speed Hack (adjustable)
      - Fly (6-axis, adjustable speed)
      - Infinite Jump
      - Noclip
      - God Mode (local heal)
      - Fullbright
      - Anti-AFK
      - Reach (extend melee hitbox)
      - No Fall Damage
      - Teleport to Player
      - Freecam
      - Third Person / FOV Changer
      - Kill Aura (auto-click nearby targets)
    
    Keybinds:
      RightCtrl  = Toggle GUI
      RMB (hold) = Aimbot lock
]]

----------------------------------------------------------------------
-- Services
----------------------------------------------------------------------
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local Lighting           = game:GetService("Lighting")
local StarterGui         = game:GetService("StarterGui")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local Workspace          = game:GetService("Workspace")
local Camera             = Workspace.CurrentCamera
local LocalPlayer        = Players.LocalPlayer
local Mouse              = LocalPlayer:GetMouse()

----------------------------------------------------------------------
-- State
----------------------------------------------------------------------
local State = {
    -- Combat
    ESP            = false,
    Tracers        = false,
    TeamCheck      = false,
    HealthBar      = false,
    BoxESP         = false,
    SkeletonESP    = false,
    ShowTool       = false,
    ChamsFill      = 70,
    Aimbot         = false,
    AimbotSmooth   = 0.2,
    AimbotFOV      = 200,
    AimbotPart     = "Head",
    ShowFOV        = false,
    Triggerbot     = false,
    KillAura       = false,
    KillAuraRange  = 15,
    Reach          = false,
    ReachDistance   = 20,

    -- Movement
    SpeedHack      = false,
    SpeedValue     = 50,
    Fly            = false,
    FlySpeed       = 80,
    InfJump        = false,
    Noclip         = false,
    NoFallDmg      = false,

    -- Visual
    Fullbright     = false,
    Freecam        = false,
    FreecamSpeed   = 60,
    CustomFOV      = false,
    FOVValue       = 70,

    -- Utility
    GodMode        = false,
    AntiAFK        = false,
}

----------------------------------------------------------------------
-- Theme
----------------------------------------------------------------------
local Theme = {
    Accent    = Color3.fromRGB(155, 89, 255),
    AccentDim = Color3.fromRGB(100, 55, 190),
    BG        = Color3.fromRGB(14, 10, 22),
    BG2       = Color3.fromRGB(22, 16, 35),
    BG3       = Color3.fromRGB(32, 24, 52),
    Text      = Color3.fromRGB(230, 220, 250),
    TextDim   = Color3.fromRGB(120, 100, 160),
    On        = Color3.fromRGB(140, 100, 255),
    Off       = Color3.fromRGB(60, 45, 85),
    Error     = Color3.fromRGB(180, 60, 120),
}

----------------------------------------------------------------------
-- Tween Helper
----------------------------------------------------------------------
local function tween(obj, props, duration, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

----------------------------------------------------------------------
-- GUI
----------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KetamineUniversal"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Dim backdrop
local Backdrop = Instance.new("Frame")
Backdrop.Name = "Backdrop"
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
Backdrop.BackgroundTransparency = 1
Backdrop.BorderSizePixel = 0
Backdrop.Parent = ScreenGui
tween(Backdrop, {BackgroundTransparency = 0.6}, 0.5)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 460, 0, 530)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -265)
MainFrame.BackgroundColor3 = Theme.BG
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.5
mainStroke.Transparency = 1

-- Animate card in
tween(MainFrame, {BackgroundTransparency = 0}, 0.5)
tween(mainStroke, {Transparency = 0.3}, 0.6)

-- Title Section (matches loader style)
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(1, 0, 0, 70)
TitleContainer.BackgroundColor3 = Theme.BG2
TitleContainer.BorderSizePixel = 0
TitleContainer.Parent = MainFrame
Instance.new("UICorner", TitleContainer).CornerRadius = UDim.new(0, 14)

local TitleClip = Instance.new("Frame")
TitleClip.Size = UDim2.new(1, 0, 0, 16)
TitleClip.Position = UDim2.new(0, 0, 1, -16)
TitleClip.BackgroundColor3 = Theme.BG2
TitleClip.BorderSizePixel = 0
TitleClip.Parent = TitleContainer

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 0, 30)
TitleLabel.Position = UDim2.new(0, 16, 0, 12)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Ketamine Universal"
TitleLabel.TextColor3 = Theme.Accent
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleContainer

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 60, 0, 20)
VersionLabel.Position = UDim2.new(1, -70, 0, 16)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0"
VersionLabel.TextColor3 = Theme.TextDim
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 13
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
VersionLabel.Parent = TitleContainer

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, -20, 0, 18)
SubtitleLabel.Position = UDim2.new(0, 16, 0, 42)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Universal script hub for all games"
SubtitleLabel.TextColor3 = Theme.TextDim
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextSize = 13
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.Parent = TitleContainer

-- Close / Minimize buttons
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 5)
CloseBtn.BackgroundColor3 = Theme.Error
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleContainer
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(220, 80, 140)}, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.15)
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -66, 0, 5)
MinBtn.BackgroundColor3 = Theme.BG3
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 17
MinBtn.AutoButtonColor = false
MinBtn.Parent = TitleContainer
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

MinBtn.MouseEnter:Connect(function()
    tween(MinBtn, {BackgroundColor3 = Theme.AccentDim}, 0.15)
end)
MinBtn.MouseLeave:Connect(function()
    tween(MinBtn, {BackgroundColor3 = Theme.BG3}, 0.15)
end)

----------------------------------------------------------------------
-- Tab System
----------------------------------------------------------------------
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, 34)
TabBar.Position = UDim2.new(0, 12, 0, 78)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -24, 1, -122)
ContentFrame.Position = UDim2.new(0, 12, 0, 118)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

local tabs = {}
local pages = {}
local activeTab = nil

local function createPage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = name
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.Accent
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Visible = false
    scroll.Parent = ContentFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingRight = UDim.new(0, 4)
    padding.Parent = scroll

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    pages[name] = scroll
    return scroll
end

local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 68, 1, 0)
    btn.BackgroundColor3 = Theme.BG3
    btn.Text = name
    btn.TextColor3 = Theme.TextDim
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Theme.BG3
    tabStroke.Thickness = 1
    tabStroke.Transparency = 0.5
    tabStroke.Parent = btn

    tabs[name] = btn

    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            tween(btn, {BackgroundColor3 = Theme.AccentDim}, 0.15)
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            tween(btn, {BackgroundColor3 = Theme.BG3}, 0.15)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for n, t in pairs(tabs) do
            tween(t, {BackgroundColor3 = Theme.BG3}, 0.2)
            t.TextColor3 = Theme.TextDim
            pages[n].Visible = false
        end
        tween(btn, {BackgroundColor3 = Theme.Accent}, 0.2)
        btn.TextColor3 = Color3.new(1,1,1)
        pages[name].Visible = true
        activeTab = name
    end)
end

----------------------------------------------------------------------
-- Widget Builders
----------------------------------------------------------------------
local widgetOrder = 0
local function nextOrder()
    widgetOrder = widgetOrder + 1
    return widgetOrder
end

local function addSection(page, text)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 24)
    container.BackgroundTransparency = 1
    container.LayoutOrder = nextOrder()
    container.Parent = page

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Theme.BG3
    line.BorderSizePixel = 0
    line.Parent = container

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.BackgroundColor3 = Theme.BG
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. text .. "  "
    lbl.TextColor3 = Theme.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.Parent = container
end

local function addToggle(page, name, stateKey, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Theme.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = nextOrder()
    row.Parent = page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Theme.BG3
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.5
    rowStroke.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.Text = State[stateKey] and "ON" or "OFF"
    btn.TextColor3 = State[stateKey] and Theme.On or Theme.Error
    btn.BackgroundColor3 = State[stateKey] and Color3.fromRGB(40, 28, 70) or Theme.Off
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        btn.Text = State[stateKey] and "ON" or "OFF"
        tween(btn, {
            TextColor3 = State[stateKey] and Theme.On or Theme.Error,
            BackgroundColor3 = State[stateKey] and Color3.fromRGB(40, 28, 70) or Theme.Off
        }, 0.2)
        if callback then callback(State[stateKey]) end
    end)
end

local function addSlider(page, name, stateKey, min, max, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = Theme.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = nextOrder()
    row.Parent = page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Theme.BG3
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.5
    rowStroke.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 20)
    label.Position = UDim2.new(0, 14, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(State[stateKey])
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -28, 0, 6)
    track.Position = UDim2.new(0, 14, 0, 32)
    track.BackgroundColor3 = Theme.BG3
    track.BorderSizePixel = 0
    track.Parent = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((State[stateKey] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (max - min) * pos)
            State[stateKey] = value
            label.Text = name .. ": " .. tostring(value)
            if callback then callback(value) end
        end
    end)
end

local function addButton(page, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Theme.AccentDim
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = nextOrder()
    btn.AutoButtonColor = false
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = Theme.AccentDim}, 0.15)
    end)
    btn.MouseButton1Click:Connect(callback)
end

local function addDropdown(page, name, stateKey, options)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Theme.BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = nextOrder()
    row.Parent = page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Theme.BG3
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.5
    rowStroke.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0, 26)
    btn.Position = UDim2.new(0.55, 0, 0.5, -13)
    btn.BackgroundColor3 = Theme.BG3
    btn.Text = State[stateKey]
    btn.TextColor3 = Theme.Accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local idx = 1
    for i, v in ipairs(options) do
        if v == State[stateKey] then idx = i end
    end

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        State[stateKey] = options[idx]
        tween(btn, {TextColor3 = Color3.new(1,1,1)}, 0.1)
        btn.Text = options[idx]
        task.delay(0.15, function()
            tween(btn, {TextColor3 = Theme.Accent}, 0.2)
        end)
    end)
end

----------------------------------------------------------------------
-- Create Pages
----------------------------------------------------------------------
local combatPage   = createPage("Combat")
local movementPage = createPage("Movement")
local visualPage   = createPage("Visual")
local utilityPage  = createPage("Utility")
local playerPage   = createPage("Players")
local configPage   = createPage("Config")

createTab("Combat", 1)
createTab("Movement", 2)
createTab("Visual", 3)
createTab("Utility", 4)
createTab("Players", 5)
createTab("Config", 6)

----------------------------------------------------------------------
-- COMBAT TAB
----------------------------------------------------------------------
widgetOrder = 0
addSection(combatPage, "ESP")
addToggle(combatPage, "Player ESP", "ESP", function(on) refreshESP() end)
addToggle(combatPage, "Tracers", "Tracers")
addToggle(combatPage, "Box ESP", "BoxESP")
addToggle(combatPage, "Health Bar", "HealthBar")
addToggle(combatPage, "Skeleton ESP", "SkeletonESP")
addToggle(combatPage, "Show Tool/Weapon", "ShowTool")
addToggle(combatPage, "Team Check", "TeamCheck")
addSlider(combatPage, "Chams Fill %", "ChamsFill", 0, 100, nil)

addSection(combatPage, "Aimbot")
addToggle(combatPage, "Aimbot (Hold RMB)", "Aimbot")
addSlider(combatPage, "Smoothness", "AimbotSmooth", 0, 100, nil)
addSlider(combatPage, "FOV Radius", "AimbotFOV", 50, 800, nil)
addDropdown(combatPage, "Target Part", "AimbotPart", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"})
addToggle(combatPage, "Show FOV Circle", "ShowFOV")

addSection(combatPage, "Auto")
addToggle(combatPage, "Triggerbot", "Triggerbot")
addToggle(combatPage, "Kill Aura", "KillAura")
addSlider(combatPage, "Aura Range", "KillAuraRange", 5, 50, nil)
addToggle(combatPage, "Reach", "Reach")
addSlider(combatPage, "Reach Distance", "ReachDistance", 10, 60, nil)

----------------------------------------------------------------------
-- MOVEMENT TAB
----------------------------------------------------------------------
widgetOrder = 0
addSection(movementPage, "Speed")
addToggle(movementPage, "Speed Hack", "SpeedHack", function(on)
    if not on then
        local c = LocalPlayer.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
end)
addSlider(movementPage, "Walk Speed", "SpeedValue", 16, 500, nil)

addSection(movementPage, "Flight")
addToggle(movementPage, "Fly", "Fly", function(on)
    if on then startFly() else stopFly() end
end)
addSlider(movementPage, "Fly Speed", "FlySpeed", 10, 400, nil)

addSection(movementPage, "Other")
addToggle(movementPage, "Infinite Jump", "InfJump")
addToggle(movementPage, "Noclip", "Noclip")
addToggle(movementPage, "No Fall Damage", "NoFallDmg")

----------------------------------------------------------------------
-- VISUAL TAB
----------------------------------------------------------------------
widgetOrder = 0
addSection(visualPage, "Lighting")
addToggle(visualPage, "Fullbright", "Fullbright", function(on)
    if on then enableFullbright() else disableFullbright() end
end)

addSection(visualPage, "Camera")
addToggle(visualPage, "Freecam", "Freecam", function(on)
    if on then startFreecam() else stopFreecam() end
end)
addSlider(visualPage, "Freecam Speed", "FreecamSpeed", 10, 200, nil)
addToggle(visualPage, "Custom FOV", "CustomFOV")
addSlider(visualPage, "FOV Value", "FOVValue", 30, 120, nil)

----------------------------------------------------------------------
-- UTILITY TAB
----------------------------------------------------------------------
widgetOrder = 0
addSection(utilityPage, "Survival")
addToggle(utilityPage, "God Mode (Local)", "GodMode")
addToggle(utilityPage, "Anti-AFK", "AntiAFK", function(on)
    if on then enableAntiAFK() else disableAntiAFK() end
end)

addSection(utilityPage, "Actions")
addButton(utilityPage, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
addButton(utilityPage, "Copy Server Link", function()
    if setclipboard then
        setclipboard("roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId)
        notify("Server link copied!")
    end
end)
addButton(utilityPage, "Reset Character", function()
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Health = 0 end
end)

----------------------------------------------------------------------
-- CONFIG SYSTEM
----------------------------------------------------------------------
local CONFIG_FOLDER = "KetamineUniversal"

local function ensureFolder()
    if isfolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end

local function getConfigPath(name)
    return CONFIG_FOLDER .. "/" .. name .. ".json"
end

local function saveConfig(name)
    ensureFolder()
    local data = {}
    for k, v in pairs(State) do
        data[k] = v
    end
    local json = HttpService:JSONEncode(data)
    writefile(getConfigPath(name), json)
end

local function loadConfig(name)
    local path = getConfigPath(name)
    if not isfile or not isfile(path) then return false end
    local json = readfile(path)
    local data = HttpService:JSONDecode(json)
    for k, v in pairs(data) do
        if State[k] ~= nil then
            State[k] = v
        end
    end
    return true
end

local function deleteConfig(name)
    local path = getConfigPath(name)
    if isfile and isfile(path) then
        delfile(path)
    end
end

local function listConfigs()
    ensureFolder()
    if not listfiles then return {} end
    local files = listfiles(CONFIG_FOLDER)
    local names = {}
    for _, f in ipairs(files) do
        local name = f:match("([^/\\]+)%.json$")
        if name then table.insert(names, name) end
    end
    return names
end

-- Refresh all GUI toggles to match State after loading a config
local function refreshAllToggles()
    -- Re-trigger ESP
    if State.ESP then refreshESP() end
    -- Re-trigger fly
    if State.Fly then startFly() else stopFly() end
    -- Re-trigger freecam
    if State.Freecam then startFreecam() else stopFreecam() end
    -- Re-trigger fullbright
    if State.Fullbright then enableFullbright() else disableFullbright() end
    -- Re-trigger anti-afk
    if State.AntiAFK then enableAntiAFK() else disableAntiAFK() end
    -- Speed
    if not State.SpeedHack then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
end

----------------------------------------------------------------------
-- CONFIG TAB
----------------------------------------------------------------------
widgetOrder = 0
addSection(configPage, "Save / Load Configs")

-- Config name input
local cfgInputRow = Instance.new("Frame")
cfgInputRow.Size = UDim2.new(1, 0, 0, 42)
cfgInputRow.BackgroundColor3 = Theme.BG2
cfgInputRow.BorderSizePixel = 0
cfgInputRow.LayoutOrder = 2
cfgInputRow.Parent = configPage
Instance.new("UICorner", cfgInputRow).CornerRadius = UDim.new(0, 10)

local cfgInputStroke = Instance.new("UIStroke")
cfgInputStroke.Color = Theme.BG3
cfgInputStroke.Thickness = 1
cfgInputStroke.Transparency = 0.5
cfgInputStroke.Parent = cfgInputRow

local cfgLabel = Instance.new("TextLabel")
cfgLabel.Size = UDim2.new(0, 100, 1, 0)
cfgLabel.Position = UDim2.new(0, 14, 0, 0)
cfgLabel.BackgroundTransparency = 1
cfgLabel.Text = "Config Name:"
cfgLabel.TextColor3 = Theme.Text
cfgLabel.Font = Enum.Font.GothamMedium
cfgLabel.TextSize = 13
cfgLabel.TextXAlignment = Enum.TextXAlignment.Left
cfgLabel.Parent = cfgInputRow

local cfgInputBG = Instance.new("Frame")
cfgInputBG.Size = UDim2.new(1, -130, 0, 28)
cfgInputBG.Position = UDim2.new(0, 118, 0.5, -14)
cfgInputBG.BackgroundColor3 = Theme.BG3
cfgInputBG.BorderSizePixel = 0
cfgInputBG.Parent = cfgInputRow
Instance.new("UICorner", cfgInputBG).CornerRadius = UDim.new(0, 8)

local cfgInputS = Instance.new("UIStroke")
cfgInputS.Color = Color3.fromRGB(50, 40, 75)
cfgInputS.Thickness = 1
cfgInputS.Parent = cfgInputBG

local cfgInput = Instance.new("TextBox")
cfgInput.Size = UDim2.new(1, -12, 1, 0)
cfgInput.Position = UDim2.new(0, 6, 0, 0)
cfgInput.BackgroundTransparency = 1
cfgInput.Text = "default"
cfgInput.PlaceholderText = "Config name..."
cfgInput.PlaceholderColor3 = Theme.TextDim
cfgInput.TextColor3 = Theme.Text
cfgInput.Font = Enum.Font.GothamMedium
cfgInput.TextSize = 13
cfgInput.TextXAlignment = Enum.TextXAlignment.Left
cfgInput.ClearTextOnFocus = false
cfgInput.Parent = cfgInputBG

cfgInput.Focused:Connect(function() tween(cfgInputS, {Color = Theme.Accent}, 0.2) end)
cfgInput.FocusLost:Connect(function() tween(cfgInputS, {Color = Color3.fromRGB(50, 40, 75)}, 0.2) end)

-- Action buttons
local cfgBtnRow = Instance.new("Frame")
cfgBtnRow.Size = UDim2.new(1, 0, 0, 38)
cfgBtnRow.BackgroundTransparency = 1
cfgBtnRow.LayoutOrder = 3
cfgBtnRow.Parent = configPage

local cfgBtnLayout = Instance.new("UIListLayout")
cfgBtnLayout.FillDirection = Enum.FillDirection.Horizontal
cfgBtnLayout.Padding = UDim.new(0, 6)
cfgBtnLayout.Parent = cfgBtnRow

local function makeCfgBtn(text, color, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Parent = cfgBtnRow
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local lighter = Color3.new(
        math.min(color.R + 0.08, 1),
        math.min(color.G + 0.08, 1),
        math.min(color.B + 0.08, 1)
    )
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = lighter}, 0.15) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = color}, 0.15) end)
    return btn
end

local saveBtn   = makeCfgBtn("Save", Theme.Accent, 1)
local loadBtn   = makeCfgBtn("Load", Color3.fromRGB(45, 32, 72), 2)
local deleteBtn = makeCfgBtn("Delete", Theme.Error, 3)

-- Config list
addSection(configPage, "Saved Configs")

local cfgListFrame = Instance.new("Frame")
cfgListFrame.Size = UDim2.new(1, 0, 0, 0)
cfgListFrame.AutomaticSize = Enum.AutomaticSize.Y
cfgListFrame.BackgroundColor3 = Theme.BG2
cfgListFrame.BorderSizePixel = 0
cfgListFrame.LayoutOrder = 100
cfgListFrame.Parent = configPage
Instance.new("UICorner", cfgListFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIPadding", cfgListFrame).PaddingBottom = UDim.new(0, 6)

local cfgListStroke = Instance.new("UIStroke")
cfgListStroke.Color = Theme.BG3
cfgListStroke.Thickness = 1
cfgListStroke.Transparency = 0.5
cfgListStroke.Parent = cfgListFrame

local cfgListLayout = Instance.new("UIListLayout")
cfgListLayout.Padding = UDim.new(0, 4)
cfgListLayout.SortOrder = Enum.SortOrder.LayoutOrder
cfgListLayout.Parent = cfgListFrame

local noConfigLabel = Instance.new("TextLabel")
noConfigLabel.Size = UDim2.new(1, 0, 0, 30)
noConfigLabel.BackgroundTransparency = 1
noConfigLabel.Text = "No configs saved yet"
noConfigLabel.TextColor3 = Theme.TextDim
noConfigLabel.Font = Enum.Font.Gotham
noConfigLabel.TextSize = 12
noConfigLabel.LayoutOrder = 1
noConfigLabel.Parent = cfgListFrame

local function refreshConfigList()
    for _, c in ipairs(cfgListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    local configs = listConfigs()
    noConfigLabel.Visible = #configs == 0

    for i, name in ipairs(configs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -12, 0, 30)
        btn.Position = UDim2.new(0, 6, 0, 0)
        btn.BackgroundColor3 = Theme.BG3
        btn.Text = "  " .. name
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = i + 1
        btn.Parent = cfgListFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Theme.AccentDim}, 0.15) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Theme.BG3}, 0.15) end)

        btn.MouseButton1Click:Connect(function()
            cfgInput.Text = name
        end)
    end
end

-- Button connections
saveBtn.MouseButton1Click:Connect(function()
    local name = cfgInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then notify("Enter a config name!"); return end

    local ok, err = pcall(function() saveConfig(name) end)
    if ok then
        notify("Config '" .. name .. "' saved!")
        tween(saveBtn, {BackgroundColor3 = Color3.fromRGB(100, 220, 140)}, 0.2)
        task.delay(0.5, function() tween(saveBtn, {BackgroundColor3 = Theme.Accent}, 0.3) end)
        refreshConfigList()
    else
        notify("Save failed: " .. tostring(err))
    end
end)

loadBtn.MouseButton1Click:Connect(function()
    local name = cfgInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then notify("Enter a config name!"); return end

    local ok, err = pcall(function()
        local success = loadConfig(name)
        if not success then error("Config not found") end
    end)

    if ok then
        notify("Config '" .. name .. "' loaded!")
        tween(loadBtn, {BackgroundColor3 = Color3.fromRGB(100, 220, 140)}, 0.2)
        task.delay(0.5, function() tween(loadBtn, {BackgroundColor3 = Color3.fromRGB(45, 32, 72)}, 0.3) end)

        -- Refresh GUI toggles to match loaded state
        -- Update all toggle buttons in every page
        for _, page in pairs(pages) do
            for _, widget in ipairs(page:GetDescendants()) do
                -- This is handled by re-reading State on next frame
            end
        end
        pcall(refreshAllToggles)
        notify("Tip: Re-toggle features to sync GUI buttons")
    else
        notify("Load failed: " .. tostring(err))
    end
end)

deleteBtn.MouseButton1Click:Connect(function()
    local name = cfgInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then notify("Enter a config name!"); return end

    local ok, err = pcall(function() deleteConfig(name) end)
    if ok then
        notify("Config '" .. name .. "' deleted!")
        tween(deleteBtn, {BackgroundColor3 = Color3.fromRGB(220, 80, 80)}, 0.2)
        task.delay(0.5, function() tween(deleteBtn, {BackgroundColor3 = Theme.Error}, 0.3) end)
        refreshConfigList()
    else
        notify("Delete failed: " .. tostring(err))
    end
end)

-- Auto-load default config on start
pcall(function()
    if isfile and isfile(getConfigPath("default")) then
        loadConfig("default")
        pcall(refreshAllToggles)
    end
end)

-- Initial config list
pcall(refreshConfigList)

----------------------------------------------------------------------
-- PLAYERS TAB
----------------------------------------------------------------------
local function refreshPlayerList()
    for _, c in ipairs(playerPage:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    widgetOrder = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            addButton(playerPage, "TP -> " .. p.Name, function()
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myHrp then
                    myHrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                    notify("Teleported to " .. p.Name)
                end
            end)
        end
    end
end

----------------------------------------------------------------------
-- Activate first tab
----------------------------------------------------------------------
tabs["Combat"].BackgroundColor3 = Theme.Accent
tabs["Combat"].TextColor3 = Color3.new(1,1,1)
pages["Combat"].Visible = true
activeTab = "Combat"

----------------------------------------------------------------------
-- Notification helper
----------------------------------------------------------------------
function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Ketamine Universal",
            Text = text,
            Duration = 4
        })
    end)
end

----------------------------------------------------------------------
-- ESP SYSTEM
----------------------------------------------------------------------
local espFolder = Instance.new("Folder", ScreenGui)
espFolder.Name = "ESP"

local tracerFolder = Instance.new("Folder", ScreenGui)
tracerFolder.Name = "Tracers"

local function clearESP()
    for _, v in ipairs(espFolder:GetChildren()) do v:Destroy() end
    for _, v in ipairs(tracerFolder:GetChildren()) do v:Destroy() end
end

local function isTeammate(player)
    if not State.TeamCheck then return false end
    if not LocalPlayer.Team or not player.Team then return false end
    return LocalPlayer.Team == player.Team
end

local function drawLine(folder, name, x1, y1, x2, y2, color, thickness)
    local line = folder:FindFirstChild(name)
    if not line then
        line = Instance.new("Frame")
        line.Name = name
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Parent = folder
    end
    line.BackgroundColor3 = color or Theme.Accent
    local dX = x2 - x1
    local dY = y2 - y1
    local len = math.sqrt(dX * dX + dY * dY)
    line.Size = UDim2.new(0, thickness or 1, 0, len)
    line.Position = UDim2.new(0, (x1 + x2) / 2, 0, (y1 + y2) / 2)
    line.Rotation = math.deg(math.atan2(dX, -dY))
    line.Visible = true
    return line
end

local SKELETON_CONNECTIONS = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

-- Fallback for R6 rigs
local SKELETON_R6 = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

local function createESPFor(player)
    if player == LocalPlayer then return end

    -- Highlight / Chams
    local highlight = Instance.new("Highlight")
    highlight.Name = "H_" .. player.Name
    highlight.FillColor = Color3.fromRGB(155, 89, 255)
    highlight.FillTransparency = State.ChamsFill / 100
    highlight.OutlineColor = Color3.fromRGB(200, 180, 255)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = espFolder

    -- Billboard: name + info + tool
    local bb = Instance.new("BillboardGui")
    bb.Name = "BB_" .. player.Name
    bb.Size = UDim2.new(0, 200, 0, 70)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = espFolder

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, 0, 0, 18)
    nameL.BackgroundTransparency = 1
    nameL.Text = player.Name
    nameL.TextColor3 = Color3.new(1,1,1)
    nameL.TextStrokeTransparency = 0.3
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 14
    nameL.Parent = bb

    local infoL = Instance.new("TextLabel")
    infoL.Size = UDim2.new(1, 0, 0, 14)
    infoL.Position = UDim2.new(0, 0, 0, 18)
    infoL.BackgroundTransparency = 1
    infoL.TextColor3 = Color3.fromRGB(200, 180, 255)
    infoL.TextStrokeTransparency = 0.4
    infoL.Font = Enum.Font.Gotham
    infoL.TextSize = 12
    infoL.Parent = bb

    local toolL = Instance.new("TextLabel")
    toolL.Name = "ToolLabel"
    toolL.Size = UDim2.new(1, 0, 0, 14)
    toolL.Position = UDim2.new(0, 0, 0, 32)
    toolL.BackgroundTransparency = 1
    toolL.TextColor3 = Color3.fromRGB(255, 200, 100)
    toolL.TextStrokeTransparency = 0.4
    toolL.Font = Enum.Font.GothamBold
    toolL.TextSize = 11
    toolL.Text = ""
    toolL.Parent = bb

    -- Health bar billboard
    local hpBB = Instance.new("BillboardGui")
    hpBB.Name = "HP_" .. player.Name
    hpBB.Size = UDim2.new(0, 60, 0, 8)
    hpBB.StudsOffset = Vector3.new(0, 3.0, 0)
    hpBB.AlwaysOnTop = true
    hpBB.Parent = espFolder

    local hpBG = Instance.new("Frame")
    hpBG.Size = UDim2.new(1, 0, 1, 0)
    hpBG.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
    hpBG.BorderSizePixel = 0
    hpBG.Parent = hpBB
    Instance.new("UICorner", hpBG).CornerRadius = UDim.new(1, 0)

    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBG
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

    -- Tracer line
    local tracer = Instance.new("Frame")
    tracer.Name = "TR_" .. player.Name
    tracer.BackgroundColor3 = Theme.Accent
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.Visible = false
    tracer.Parent = tracerFolder

    -- Box ESP frames (4 edges)
    local boxFolder = Instance.new("Folder")
    boxFolder.Name = "BOX_" .. player.Name
    boxFolder.Parent = espFolder

    local boxEdges = {}
    for i = 1, 4 do
        local edge = Instance.new("Frame")
        edge.Name = "Edge" .. i
        edge.BackgroundColor3 = Theme.Accent
        edge.BorderSizePixel = 0
        edge.Visible = false
        edge.Parent = boxFolder
        boxEdges[i] = edge
    end

    -- Skeleton folder
    local skelFolder = Instance.new("Folder")
    skelFolder.Name = "SKEL_" .. player.Name
    skelFolder.Parent = espFolder

    -- Main update loop
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not State.ESP then conn:Disconnect() return end

        -- Team check
        if isTeammate(player) then
            highlight.Enabled = false
            bb.Enabled = false
            hpBB.Enabled = false
            tracer.Visible = false
            for _, e in ipairs(boxEdges) do e.Visible = false end
            for _, c in ipairs(skelFolder:GetChildren()) do c.Visible = false end
            return
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if hrp and hum then
            -- Chams
            highlight.Adornee = char
            highlight.FillTransparency = State.ChamsFill / 100
            highlight.Enabled = true

            -- Billboard info
            bb.Adornee = hrp
            bb.Enabled = true
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            infoL.Text = string.format("HP: %d/%d | %dm", math.floor(hum.Health), math.floor(hum.MaxHealth), dist)

            -- Tool display
            if State.ShowTool then
                local tool = char:FindFirstChildOfClass("Tool")
                toolL.Text = tool and ("[" .. tool.Name .. "]") or ""
                toolL.Visible = true
            else
                toolL.Visible = false
            end

            -- Health bar
            if State.HealthBar then
                hpBB.Adornee = hrp
                hpBB.Enabled = true
                local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                hpFill.Size = UDim2.new(pct, 0, 1, 0)
                -- Color: green -> yellow -> red
                if pct > 0.5 then
                    hpFill.BackgroundColor3 = Color3.fromRGB(
                        math.floor(255 * (1 - pct) * 2),
                        255,
                        50
                    )
                else
                    hpFill.BackgroundColor3 = Color3.fromRGB(
                        255,
                        math.floor(255 * pct * 2),
                        50
                    )
                end
            else
                hpBB.Enabled = false
            end

            -- Tracer
            if State.Tracers then
                local screenPos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local inset = game:GetService("GuiService"):GetGuiInset()
                    local startX = Camera.ViewportSize.X / 2
                    local startY = Camera.ViewportSize.Y + inset.Y
                    local endX = screenPos.X
                    local endY = screenPos.Y + inset.Y
                    local dX = endX - startX
                    local dY = endY - startY
                    local len = math.sqrt(dX * dX + dY * dY)
                    tracer.Size = UDim2.new(0, 2, 0, len)
                    tracer.Position = UDim2.new(0, (startX + endX) / 2, 0, (startY + endY) / 2)
                    tracer.Rotation = math.deg(math.atan2(dX, -dY))
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end

            -- Box ESP
            if State.BoxESP then
                local head = char:FindFirstChild("Head")
                local rootPart = hrp
                if head and rootPart then
                    local top = head.Position + Vector3.new(0, 1.5, 0)
                    local bottom = rootPart.Position - Vector3.new(0, 3, 0)
                    local topSP, topOn = Camera:WorldToScreenPoint(top)
                    local botSP, botOn = Camera:WorldToScreenPoint(bottom)
                    if topOn and botOn then
                        local inset = game:GetService("GuiService"):GetGuiInset()
                        local tY = topSP.Y + inset.Y
                        local bY = botSP.Y + inset.Y
                        local height = math.abs(bY - tY)
                        local width = height * 0.6
                        local centerX = (topSP.X + botSP.X) / 2
                        local left = centerX - width / 2
                        local right = centerX + width / 2

                        -- Top edge
                        boxEdges[1].Size = UDim2.new(0, width, 0, 2)
                        boxEdges[1].Position = UDim2.new(0, left, 0, tY)
                        boxEdges[1].Visible = true
                        -- Bottom edge
                        boxEdges[2].Size = UDim2.new(0, width, 0, 2)
                        boxEdges[2].Position = UDim2.new(0, left, 0, bY)
                        boxEdges[2].Visible = true
                        -- Left edge
                        boxEdges[3].Size = UDim2.new(0, 2, 0, height)
                        boxEdges[3].Position = UDim2.new(0, left, 0, tY)
                        boxEdges[3].Visible = true
                        -- Right edge
                        boxEdges[4].Size = UDim2.new(0, 2, 0, height)
                        boxEdges[4].Position = UDim2.new(0, right, 0, tY)
                        boxEdges[4].Visible = true
                    else
                        for _, e in ipairs(boxEdges) do e.Visible = false end
                    end
                else
                    for _, e in ipairs(boxEdges) do e.Visible = false end
                end
            else
                for _, e in ipairs(boxEdges) do e.Visible = false end
            end

            -- Skeleton ESP
            if State.SkeletonESP then
                local bones = SKELETON_CONNECTIONS
                -- Detect R6 vs R15
                if char:FindFirstChild("Torso") and not char:FindFirstChild("UpperTorso") then
                    bones = SKELETON_R6
                end
                local inset = game:GetService("GuiService"):GetGuiInset()
                for i, bone in ipairs(bones) do
                    local p1 = char:FindFirstChild(bone[1])
                    local p2 = char:FindFirstChild(bone[2])
                    if p1 and p2 then
                        local sp1, on1 = Camera:WorldToScreenPoint(p1.Position)
                        local sp2, on2 = Camera:WorldToScreenPoint(p2.Position)
                        if on1 and on2 then
                            drawLine(
                                skelFolder,
                                "bone_" .. i,
                                sp1.X, sp1.Y + inset.Y,
                                sp2.X, sp2.Y + inset.Y,
                                Color3.fromRGB(200, 180, 255),
                                1
                            )
                        else
                            local l = skelFolder:FindFirstChild("bone_" .. i)
                            if l then l.Visible = false end
                        end
                    else
                        local l = skelFolder:FindFirstChild("bone_" .. i)
                        if l then l.Visible = false end
                    end
                end
                -- Hide extra bones if switching rig type
                for _, c in ipairs(skelFolder:GetChildren()) do
                    local idx = tonumber(c.Name:match("bone_(%d+)"))
                    if idx and idx > #bones then c.Visible = false end
                end
            else
                for _, c in ipairs(skelFolder:GetChildren()) do c.Visible = false end
            end

        else
            highlight.Enabled = false
            bb.Enabled = false
            hpBB.Enabled = false
            tracer.Visible = false
            for _, e in ipairs(boxEdges) do e.Visible = false end
            for _, c in ipairs(skelFolder:GetChildren()) do c.Visible = false end
        end
    end)
end

function refreshESP()
    clearESP()
    if not State.ESP then return end
    for _, p in ipairs(Players:GetPlayers()) do createESPFor(p) end
end

Players.PlayerAdded:Connect(function(p)
    if State.ESP then createESPFor(p) end
    if activeTab == "Players" then refreshPlayerList() end
end)
Players.PlayerRemoving:Connect(function(p)
    for _, v in ipairs(espFolder:GetChildren()) do
        if v.Name:find(p.Name) then v:Destroy() end
    end
    for _, v in ipairs(tracerFolder:GetChildren()) do
        if v.Name:find(p.Name) then v:Destroy() end
    end
    if activeTab == "Players" then refreshPlayerList() end
end)

----------------------------------------------------------------------
-- FOV Circle
----------------------------------------------------------------------
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.BackgroundTransparency = 1
fovCircle.Size = UDim2.new(0, State.AimbotFOV * 2, 0, State.AimbotFOV * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Parent = ScreenGui
fovCircle.Visible = false

local circleImg = Instance.new("UIStroke")
circleImg.Color = Theme.Accent
circleImg.Thickness = 1
circleImg.Transparency = 0.5
circleImg.Parent = fovCircle
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

local guiInset = game:GetService("GuiService"):GetGuiInset()

RunService.RenderStepped:Connect(function()
    if State.ShowFOV and State.Aimbot then
        fovCircle.Visible = true
        fovCircle.Size = UDim2.new(0, State.AimbotFOV * 2, 0, State.AimbotFOV * 2)
        -- Center on screen crosshair (works for FPS games like Rivals)
        local cx = Camera.ViewportSize.X / 2
        local cy = Camera.ViewportSize.Y / 2 + guiInset.Y
        fovCircle.Position = UDim2.new(0, cx, 0, cy)
    else
        fovCircle.Visible = false
    end
end)

----------------------------------------------------------------------
-- AIMBOT (FPS-compatible — works in Rivals, Arsenal, etc.)
----------------------------------------------------------------------
local function findTargetPart(char)
    -- Try the selected part first, then fallbacks
    local part = char:FindFirstChild(State.AimbotPart)
    if part then return part end
    -- Fallback order for different game rigs
    for _, name in ipairs({"Head", "HumanoidRootPart", "UpperTorso", "Torso"}) do
        part = char:FindFirstChild(name)
        if part then return part end
    end
    return nil
end

local function isAlive(player)
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    return true
end

local function getAimbotTarget()
    local closest, minDist = nil, State.AimbotFOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) then
            -- Skip teammates if team check is on
            if State.TeamCheck and LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then
                continue
            end

            local char = p.Character
            local part = findTargetPart(char)
            if part then
                local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    local screenPt = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (screenPt - screenCenter).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if State.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getAimbotTarget()
        if target then
            local screenPos = Camera:WorldToScreenPoint(target.Position)
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local targetScreen = Vector2.new(screenPos.X, screenPos.Y)
            local delta = targetScreen - screenCenter

            local smooth = 1 - (State.AimbotSmooth / 100)
            if smooth < 0.05 then smooth = 0.05 end

            local moveX = delta.X * smooth
            local moveY = delta.Y * smooth

            -- Use mousemoverel for FPS games (Rivals, Arsenal, etc.)
            if mousemoverel then
                mousemoverel(moveX, moveY)
            else
                -- Fallback: CFrame method for non-FPS games
                local goal = CFrame.new(Camera.CFrame.Position, target.Position)
                Camera.CFrame = Camera.CFrame:Lerp(goal, smooth)
            end
        end
    end
end)

----------------------------------------------------------------------
-- TRIGGERBOT
----------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if State.Triggerbot then
        local target = Mouse.Target
        if target then
            local model = target:FindFirstAncestorOfClass("Model")
            if model then
                local player = Players:GetPlayerFromCharacter(model)
                if player and player ~= LocalPlayer then
                    mouse1click()
                end
            end
        end
    end
end)

----------------------------------------------------------------------
-- KILL AURA
----------------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if State.KillAura then
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (myHrp.Position - hrp.Position).Magnitude <= State.KillAuraRange then
                    -- Simulate click towards target
                    pcall(function() mouse1click() end)
                end
            end
        end
    end
end)

----------------------------------------------------------------------
-- REACH
----------------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if State.Reach then
        local char = LocalPlayer.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        handle.Size = Vector3.new(State.ReachDistance, State.ReachDistance, State.ReachDistance)
                        handle.Transparency = 1
                        handle.CanCollide = false
                        handle.Massless = true
                    end
                end
            end
        end
    end
end)

----------------------------------------------------------------------
-- SPEED HACK
----------------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if State.SpeedHack then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = State.SpeedValue end
    end
end)

----------------------------------------------------------------------
-- FLY
----------------------------------------------------------------------
local flyBV, flyBG, flyConn

function startFly()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBG.D = 200
    flyBG.P = 10000
    flyBG.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not State.Fly then return end
        flyBG.CFrame = Camera.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        flyBV.Velocity = dir * State.FlySpeed
    end)
end

function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

----------------------------------------------------------------------
-- INFINITE JUMP
----------------------------------------------------------------------
UserInputService.JumpRequest:Connect(function()
    if State.InfJump then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

----------------------------------------------------------------------
-- NOCLIP
----------------------------------------------------------------------
RunService.Stepped:Connect(function()
    if State.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

----------------------------------------------------------------------
-- NO FALL DAMAGE
----------------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if State.NoFallDmg then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end)

----------------------------------------------------------------------
-- GOD MODE
----------------------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if State.GodMode then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health = h.MaxHealth end
    end
end)

----------------------------------------------------------------------
-- FULLBRIGHT
----------------------------------------------------------------------
local savedLighting = {}

function enableFullbright()
    savedLighting.Ambient = Lighting.Ambient
    savedLighting.Brightness = Lighting.Brightness
    savedLighting.FogEnd = Lighting.FogEnd
    savedLighting.GlobalShadows = Lighting.GlobalShadows
    Lighting.Ambient = Color3.new(1,1,1)
    Lighting.Brightness = 2
    Lighting.FogEnd = 1e9
    Lighting.GlobalShadows = false
    for _, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end
end

function disableFullbright()
    Lighting.Ambient = savedLighting.Ambient or Color3.fromRGB(127,127,127)
    Lighting.Brightness = savedLighting.Brightness or 1
    Lighting.FogEnd = savedLighting.FogEnd or 100000
    Lighting.GlobalShadows = savedLighting.GlobalShadows ~= false
    for _, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
            v.Enabled = true
        end
    end
end

----------------------------------------------------------------------
-- FREECAM
----------------------------------------------------------------------
local freecamConn
local savedCamType

function startFreecam()
    savedCamType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable
    local pos = Camera.CFrame

    freecamConn = RunService.RenderStepped:Connect(function()
        if not State.Freecam then return end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        Camera.CFrame = Camera.CFrame + dir * State.FreecamSpeed * 0.016
    end)
end

function stopFreecam()
    if freecamConn then freecamConn:Disconnect(); freecamConn = nil end
    Camera.CameraType = savedCamType or Enum.CameraType.Custom
end

----------------------------------------------------------------------
-- CUSTOM FOV
----------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if State.CustomFOV then
        Camera.FieldOfView = State.FOVValue
    end
end)

----------------------------------------------------------------------
-- ANTI-AFK
----------------------------------------------------------------------
local antiAfkConn

function enableAntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    antiAfkConn = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end)
end

function disableAntiAFK()
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
end

----------------------------------------------------------------------
-- GUI Controls
----------------------------------------------------------------------
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TabBar.Visible = not minimized
    ContentFrame.Visible = not minimized
    if minimized then
        tween(MainFrame, {Size = UDim2.new(0, 460, 0, 70)}, 0.3)
    else
        tween(MainFrame, {Size = UDim2.new(0, 460, 0, 530)}, 0.3)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    -- Cleanup state
    State.ESP = false; clearESP()
    State.Fly = false; stopFly()
    State.Freecam = false; stopFreecam()
    State.Noclip = false
    State.GodMode = false
    State.SpeedHack = false
    if State.Fullbright then disableFullbright() end
    if State.AntiAFK then disableAntiAFK() end
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 16 end
    Camera.FieldOfView = 70

    -- Animate out
    tween(Backdrop, {BackgroundTransparency = 1}, 0.4)
    tween(MainFrame, {BackgroundTransparency = 1}, 0.4)
    tween(mainStroke, {Transparency = 1}, 0.3)
    for _, child in ipairs(MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            pcall(function() tween(child, {BackgroundTransparency = 1}, 0.3) end)
        end
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            pcall(function() tween(child, {TextTransparency = 1}, 0.3) end)
        end
    end
    task.delay(0.5, function()
        ScreenGui:Destroy()
    end)
end)

local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
        Backdrop.Visible = guiVisible
    end
end)

-- Refresh player list when Players tab is clicked
tabs["Players"].MouseButton1Click:Connect(refreshPlayerList)

----------------------------------------------------------------------
-- Init
----------------------------------------------------------------------
refreshPlayerList()

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Ketamine Universal",
        Text = "Loaded! Press RightCtrl to toggle.",
        Duration = 5
    })
end)

print("[KetamineUniversal] Loaded. RightCtrl to toggle GUI.")
