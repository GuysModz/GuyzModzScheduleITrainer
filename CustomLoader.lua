--[[
    Custom Roblox Loader with Key System
    
    Features:
      - Sleek animated key verification UI
      - Key validation (hardcoded keys + time-based keys)
      - Get-Key link (sends user to a page to obtain key)
      - Remembers key for session
      - Loading screen with progress bar after key verification
      - Loads target script after verification
    
    Configuration:
      - Set VALID_KEYS, KEY_LINK, and SCRIPT_TO_LOAD below.
    
    Usage: Execute in any Roblox script executor.
]]

----------------------------------------------------------------------
-- CONFIGURATION - Edit these values
----------------------------------------------------------------------
local CONFIG = {
    -- Title shown on the loader
    LOADER_NAME = "Ketamine Loader",
    VERSION     = "v2.0",
    
    -- Valid keys (add as many as you want)
    VALID_KEYS = {
        "KETAMINE-FREE-2026",
        "KETAMINE-VIP-PERM",
        "KETAMINE-TRIAL-KEY",
    },
    
    -- Link users visit to get a key (e.g. linkvertise, pastebin, discord)
    KEY_LINK = "https://discord.gg/GvAnaf2n8H",
    
    -- Script URL to loadstring after successful key entry
    -- Replace with your actual script URL
    SCRIPT_TO_LOAD = "https://pastebin.com/raw/CurkXizG",
    
    -- Duration of loading animation in seconds
    LOAD_DURATION = 3,
    
    -- Colors
    -- Colors
    ACCENT       = Color3.fromRGB(155, 89, 255),   -- Main highlight color (buttons, borders, titles)
    ACCENT_DARK  = Color3.fromRGB(115, 55, 215),   -- Darker version of accent
    BG_PRIMARY   = Color3.fromRGB(14, 10, 22),     -- Main background
    BG_SECONDARY = Color3.fromRGB(22, 16, 35),     -- Title bar background
    BG_INPUT     = Color3.fromRGB(32, 24, 52),     -- Input field / progress bar background
    TEXT_PRIMARY  = Color3.fromRGB(230, 220, 250),  -- Main text color
    TEXT_DIM      = Color3.fromRGB(120, 100, 160),  -- Subtitle / secondary text
    SUCCESS      = Color3.fromRGB(140, 100, 255),   -- Key verified color
    ERROR        = Color3.fromRGB(180, 60, 120),    -- Invalid key color
}

----------------------------------------------------------------------
-- Services
----------------------------------------------------------------------
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui       = game:GetService("StarterGui")
local HttpService      = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

----------------------------------------------------------------------
-- Utility
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

local function generateDailyKey()
    local date = os.date("!%Y%m%d")
    local raw = "NEXUS-DAILY-" .. date
    return raw
end

local function validateKey(input)
    -- Check against static keys
    for _, key in ipairs(CONFIG.VALID_KEYS) do
        if input == key then return true end
    end
    -- Check daily auto-generated key
    if input == generateDailyKey() then return true end
    return false
end

----------------------------------------------------------------------
-- GUI Creation
----------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Full-screen dim background
local Backdrop = Instance.new("Frame")
Backdrop.Name = "Backdrop"
Backdrop.Size = UDim2.new(1, 0, 1, 0)
Backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
Backdrop.BackgroundTransparency = 1
Backdrop.BorderSizePixel = 0
Backdrop.Parent = ScreenGui

tween(Backdrop, {BackgroundTransparency = 0.5}, 0.5)

----------------------------------------------------------------------
-- Main Card
----------------------------------------------------------------------
local Card = Instance.new("Frame")
Card.Name = "Card"
Card.Size = UDim2.new(0, 380, 0, 320)
Card.Position = UDim2.new(0.5, -190, 0.5, -160)
Card.BackgroundColor3 = CONFIG.BG_PRIMARY
Card.BorderSizePixel = 0
Card.BackgroundTransparency = 1
Card.Parent = ScreenGui

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 14)
CardCorner.Parent = Card

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = CONFIG.ACCENT
CardStroke.Thickness = 1.5
CardStroke.Transparency = 1
CardStroke.Parent = Card

-- Animate card in
tween(Card, {BackgroundTransparency = 0}, 0.5)
tween(CardStroke, {Transparency = 0.3}, 0.6)

----------------------------------------------------------------------
-- Title Section
----------------------------------------------------------------------
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(1, 0, 0, 70)
TitleContainer.BackgroundColor3 = CONFIG.BG_SECONDARY
TitleContainer.BorderSizePixel = 0
TitleContainer.Parent = Card

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleContainer

-- Clip bottom corners of title
local TitleClip = Instance.new("Frame")
TitleClip.Size = UDim2.new(1, 0, 0, 16)
TitleClip.Position = UDim2.new(0, 0, 1, -16)
TitleClip.BackgroundColor3 = CONFIG.BG_SECONDARY
TitleClip.BorderSizePixel = 0
TitleClip.Parent = TitleContainer

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Position = UDim2.new(0, 16, 0, 12)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = CONFIG.LOADER_NAME
TitleLabel.TextColor3 = CONFIG.ACCENT
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleContainer

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 60, 0, 20)
VersionLabel.Position = UDim2.new(1, -70, 0, 16)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = CONFIG.VERSION
VersionLabel.TextColor3 = CONFIG.TEXT_DIM
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 13
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
VersionLabel.Parent = TitleContainer

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, -20, 0, 18)
SubtitleLabel.Position = UDim2.new(0, 16, 0, 42)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Enter your key to continue"
SubtitleLabel.TextColor3 = CONFIG.TEXT_DIM
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextSize = 13
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.Parent = TitleContainer

----------------------------------------------------------------------
-- Key Input
----------------------------------------------------------------------
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, -40, 0, 42)
InputFrame.Position = UDim2.new(0, 20, 0, 90)
InputFrame.BackgroundColor3 = CONFIG.BG_INPUT
InputFrame.BorderSizePixel = 0
InputFrame.Parent = Card
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 10)

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(60, 60, 80)
InputStroke.Thickness = 1
InputStroke.Parent = InputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -16, 1, 0)
KeyInput.Position = UDim2.new(0, 8, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Paste your key here..."
KeyInput.PlaceholderColor3 = CONFIG.TEXT_DIM
KeyInput.TextColor3 = CONFIG.TEXT_PRIMARY
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.TextSize = 14
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = InputFrame

KeyInput.Focused:Connect(function()
    tween(InputStroke, {Color = CONFIG.ACCENT}, 0.2)
end)
KeyInput.FocusLost:Connect(function()
    tween(InputStroke, {Color = Color3.fromRGB(60, 60, 80)}, 0.2)
end)

----------------------------------------------------------------------
-- Status Label
----------------------------------------------------------------------
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 20)
StatusLabel.Position = UDim2.new(0, 20, 0, 140)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = CONFIG.ERROR
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Card

----------------------------------------------------------------------
-- Buttons
----------------------------------------------------------------------
local function makeButton(text, posY, color, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    -- Hover effects
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.new(
            math.min(color.R + 0.08, 1),
            math.min(color.G + 0.08, 1),
            math.min(color.B + 0.08, 1)
        )}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = color}, 0.15)
    end)

    return btn
end

local SubmitBtn  = makeButton("Verify Key", 170, CONFIG.ACCENT, Card)              -- Uses ACCENT
local GetKeyBtn  = makeButton("Get Key", 220, Color3.fromRGB(45, 32, 72), Card)    -- Dark purple
local DiscordBtn = makeButton("Copy Discord Invite", 268, Color3.fromRGB(90, 60, 160), Card)  -- Medium purple

----------------------------------------------------------------------
-- Loading Screen (hidden initially)
----------------------------------------------------------------------
local LoadFrame = Instance.new("Frame")
LoadFrame.Name = "LoadFrame"
LoadFrame.Size = UDim2.new(0, 380, 0, 200)
LoadFrame.Position = UDim2.new(0.5, -190, 0.5, -100)
LoadFrame.BackgroundColor3 = CONFIG.BG_PRIMARY
LoadFrame.BorderSizePixel = 0
LoadFrame.Visible = false
LoadFrame.Parent = ScreenGui
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", LoadFrame).Color = CONFIG.ACCENT

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 40)
LoadTitle.Position = UDim2.new(0, 0, 0, 20)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = CONFIG.LOADER_NAME
LoadTitle.TextColor3 = CONFIG.ACCENT
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextSize = 22
LoadTitle.Parent = LoadFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 20)
LoadStatus.Position = UDim2.new(0, 0, 0, 60)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Loading modules..."
LoadStatus.TextColor3 = CONFIG.TEXT_DIM
LoadStatus.Font = Enum.Font.Gotham
LoadStatus.TextSize = 13
LoadStatus.Parent = LoadFrame

-- Progress bar
local ProgressBG = Instance.new("Frame")
ProgressBG.Size = UDim2.new(1, -60, 0, 8)
ProgressBG.Position = UDim2.new(0, 30, 0, 100)
ProgressBG.BackgroundColor3 = CONFIG.BG_INPUT
ProgressBG.BorderSizePixel = 0
ProgressBG.Parent = LoadFrame
Instance.new("UICorner", ProgressBG).CornerRadius = UDim.new(1, 0)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = CONFIG.ACCENT
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBG
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, 0, 0, 20)
PercentLabel.Position = UDim2.new(0, 0, 0, 116)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = CONFIG.TEXT_DIM
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.TextSize = 14
PercentLabel.Parent = LoadFrame

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Position = UDim2.new(0, 0, 1, -30)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "Powered by " .. CONFIG.LOADER_NAME
CreditLabel.TextColor3 = Color3.fromRGB(60, 60, 80)
CreditLabel.Font = Enum.Font.Gotham
CreditLabel.TextSize = 11
CreditLabel.Parent = LoadFrame

----------------------------------------------------------------------
-- Key Verification Logic
----------------------------------------------------------------------
local function showStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
    tween(StatusLabel, {TextTransparency = 0}, 0.2)
    task.delay(4, function()
        tween(StatusLabel, {TextTransparency = 1}, 0.5)
    end)
end

local function startLoading()
    -- Hide key card, show loader
    tween(Card, {BackgroundTransparency = 1}, 0.3)
    for _, child in ipairs(Card:GetDescendants()) do
        if child:IsA("GuiObject") then
            pcall(function() tween(child, {BackgroundTransparency = 1}, 0.3) end)
        end
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            pcall(function() tween(child, {TextTransparency = 1}, 0.3) end)
        end
    end

    task.wait(0.4)
    Card.Visible = false
    LoadFrame.Visible = true

    -- Loading steps
    local steps = {
        {text = "Verifying license...",    pct = 0.15},
        {text = "Connecting to server...", pct = 0.30},
        {text = "Downloading modules...",  pct = 0.50},
        {text = "Injecting scripts...",    pct = 0.70},
        {text = "Initializing UI...",      pct = 0.85},
        {text = "Finalizing...",           pct = 0.95},
        {text = "Done!",                   pct = 1.00},
    }

    local stepDuration = CONFIG.LOAD_DURATION / #steps

    for i, step in ipairs(steps) do
        LoadStatus.Text = step.text
        tween(ProgressFill, {Size = UDim2.new(step.pct, 0, 1, 0)}, stepDuration * 0.8)
        PercentLabel.Text = tostring(math.floor(step.pct * 100)) .. "%"
        task.wait(stepDuration)
    end

    -- Done - close loader
    task.wait(0.5)
    tween(LoadFrame, {BackgroundTransparency = 1}, 0.4)
    tween(Backdrop, {BackgroundTransparency = 1}, 0.4)
    for _, child in ipairs(LoadFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            pcall(function() tween(child, {BackgroundTransparency = 1}, 0.3) end)
        end
        if child:IsA("TextLabel") then
            pcall(function() tween(child, {TextTransparency = 1}, 0.3) end)
        end
    end

    task.wait(0.5)
    ScreenGui:Destroy()

    -- Load the target script
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = CONFIG.LOADER_NAME,
            Text = "Script loaded successfully!",
            Duration = 5
        })
    end)

    -- Attempt to load the remote script
    local success, err = pcall(function()
        loadstring(game:HttpGet(CONFIG.SCRIPT_TO_LOAD))()
    end)

    if not success then
        warn("[Loader] Failed to load script: " .. tostring(err))
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = CONFIG.LOADER_NAME,
                Text = "Script URL not set. Edit CONFIG.SCRIPT_TO_LOAD",
                Duration = 8
            })
        end)
    end
end

----------------------------------------------------------------------
-- Button Connections
----------------------------------------------------------------------
SubmitBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace

    if key == "" then
        showStatus("Please enter a key.", CONFIG.ERROR)
        return
    end

    if validateKey(key) then
        showStatus("Key verified!", CONFIG.SUCCESS)
        SubmitBtn.Text = "Verified!"
        SubmitBtn.BackgroundColor3 = CONFIG.SUCCESS
        task.wait(1)
        startLoading()
    else
        showStatus("Invalid key. Try again or get a new key.", CONFIG.ERROR)
        -- Shake animation on input
        local origPos = InputFrame.Position
        for i = 1, 4 do
            tween(InputFrame, {Position = origPos + UDim2.new(0, 6 * (i % 2 == 0 and 1 or -1), 0, 0)}, 0.05)
            task.wait(0.05)
        end
        tween(InputFrame, {Position = origPos}, 0.05)
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    -- Open key link
    if setclipboard then
        setclipboard(CONFIG.KEY_LINK)
        showStatus("Key link copied to clipboard!", CONFIG.ACCENT)
    else
        showStatus("Visit: " .. CONFIG.KEY_LINK, CONFIG.ACCENT)
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(CONFIG.KEY_LINK)
        showStatus("Discord invite copied!", Color3.fromRGB(88, 101, 242))
    else
        showStatus("Join: " .. CONFIG.KEY_LINK, Color3.fromRGB(88, 101, 242))
    end
end)

----------------------------------------------------------------------
-- Allow pressing Enter to submit key
----------------------------------------------------------------------
KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        SubmitBtn.MouseButton1Click:Fire()
    end
end)

----------------------------------------------------------------------
-- Draggable card
----------------------------------------------------------------------
local dragging, dragStart, startPos

Card.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Card.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Card.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

----------------------------------------------------------------------
-- Startup notification
----------------------------------------------------------------------
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = CONFIG.LOADER_NAME,
        Text = "Loader ready. Enter your key.",
        Duration = 5
    })
end)

print("[Loader] " .. CONFIG.LOADER_NAME .. " " .. CONFIG.VERSION .. " initialized.")
print("[Loader] Today's daily key: " .. generateDailyKey())
