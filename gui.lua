
-- UGC HUB | Dashboard
-- File: gui.lua

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local FARM_URL =
    "https://raw.githubusercontent.com/richardsry0-oss/EASY-UGC-HUB/main/autofarm.lua"

local old = playerGui:FindFirstChild("UGCHub")
if old then old:Destroy() end

local themes = {
    Purple = Color3.fromRGB(145, 91, 255),
    Blue   = Color3.fromRGB(60, 145, 255),
    Green  = Color3.fromRGB(45, 190, 125),
    Pink   = Color3.fromRGB(255, 85, 165),
    Orange = Color3.fromRGB(255, 145, 65),
}

local themeNames = {"Purple", "Blue", "Green", "Pink", "Orange"}
local themeIndex = 1
local currentSize = 100
local tweenSeconds = 2
local farm
local loading = false

local gui = Instance.new("ScreenGui")
gui.Name = "UGCHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for key, value in pairs(props) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function stroke(obj, color, thickness)
    return make("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = 0.15
    }, obj)
end

local frame = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(420, 290),
    Position = UDim2.new(0.5, -210, 0.5, -145),
    BackgroundColor3 = Color3.fromRGB(23, 24, 34),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    ClipsDescendants = true
}, gui)
corner(frame, 14)

local scale = make("UIScale", {
    Scale = 1
}, frame)

local accent = themes.Purple

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 53),
    BackgroundColor3 = Color3.fromRGB(30, 31, 44),
    BorderSizePixel = 0
}, frame)

local title = make("TextLabel", {
    Position = UDim2.fromOffset(16, 5),
    Size = UDim2.new(1, -70, 0, 27),
    BackgroundTransparency = 1,
    Text = "UGC HUB",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local subtitle = make("TextLabel", {
    Position = UDim2.fromOffset(17, 30),
    Size = UDim2.new(1, -75, 0, 15),
    BackgroundTransparency = 1,
    Text = "TWEEN AUTO FARM",
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(170, 174, 195),
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local close = make("TextButton", {
    Position = UDim2.new(1, -43, 0, 10),
    Size = UDim2.fromOffset(30, 30),
    Text = "×",
    TextSize = 22,
    Font = Enum.Font.Gotham,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(60, 61, 78),
    BorderSizePixel = 0
}, header)
corner(close, 8)

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(10, 63),
    Size = UDim2.new(0, 112, 1, -73),
    BackgroundColor3 = Color3.fromRGB(29, 30, 43),
    BorderSizePixel = 0
}, frame)
corner(sidebar, 10)

local content = make("Frame", {
    Position = UDim2.fromOffset(132, 63),
    Size = UDim2.new(1, -142, 1, -73),
    BackgroundTransparency = 1
}, frame)

local function label(parent, text, pos, size, textSize)
    return make("TextLabel", {
        Position = pos,
        Size = size,
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = textSize or 12,
        TextColor3 = Color3.fromRGB(225, 227, 240),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    }, parent)
end

local function button(parent, text, pos, size)
    local b = make("TextButton", {
        Position = pos,
        Size = size,
        BackgroundColor3 = Color3.fromRGB(46, 47, 64),
        BorderSizePixel = 0,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        AutoButtonColor = true
    }, parent)
    corner(b, 8)
    return b
end

local farmTab = button(
    sidebar, "⚒  Farm",
    UDim2.fromOffset(7, 12),
    UDim2.new(1, -14, 0, 38)
)

local settingsTab = button(
    sidebar, "⚙  Settings",
    UDim2.fromOffset(7, 56),
    UDim2.new(1, -14, 0, 38)
)

local statusLabel = label(
    sidebar, "● Ready",
    UDim2.fromOffset(9, 111),
    UDim2.new(1, -18, 0, 42), 10
)
statusLabel.TextColor3 = Color3.fromRGB(120, 220, 165)

local farmPage = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1
}, content)

local settingsPage = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Visible = false
}, content)

label(farmPage, "FARM CONTROL", UDim2.fromOffset(4, 4),
    UDim2.new(1, -8, 0, 24), 15)

label(farmPage, "Tween to FinishTrigger, then return to Area.",
    UDim2.fromOffset(4, 31),
    UDim2.new(1, -8, 0, 34), 11)

local startButton = button(
    farmPage, "▶   START AUTO FARM",
    UDim2.fromOffset(4, 78),
    UDim2.new(1, -8, 0, 42)
)

local stopButton = button(
    farmPage, "■   STOP FARM",
    UDim2.fromOffset(4, 128),
    UDim2.new(1, -8, 0, 42)
)

label(farmPage, "Use only where you have permission.",
    UDim2.fromOffset(4, 185),
    UDim2.new(1, -8, 0, 30), 10)

label(settingsPage, "SETTINGS", UDim2.fromOffset(4, 4),
    UDim2.new(1, -8, 0, 24), 15)

label(settingsPage, "UI SIZE", UDim2.fromOffset(4, 34),
    UDim2.new(0.5, -4, 0, 20), 11)

local sizeDown = button(
    settingsPage, "−",
    UDim2.new(0, 4, 0, 57),
    UDim2.fromOffset(35, 30)
)

local sizeValue = label(
    settingsPage, "100%",
    UDim2.new(0, 44, 0, 57),
    UDim2.fromOffset(55, 30), 12
)
sizeValue.TextXAlignment = Enum.TextXAlignment.Center

local sizeUp = button(
    settingsPage, "+",
    UDim2.new(0, 104, 0, 57),
    UDim2.fromOffset(35, 30)
)

label(settingsPage, "TWEEN DURATION",
    UDim2.fromOffset(4, 96),
    UDim2.new(1, -8, 0, 20), 11)

local tweenDown = button(
    settingsPage, "−",
    UDim2.new(0, 4, 0, 119),
    UDim2.fromOffset(35, 30)
)

local tweenValue = label(
    settingsPage, "2.0 sec",
    UDim2.new(0, 44, 0, 119),
    UDim2.fromOffset(95, 30), 12
)
tweenValue.TextXAlignment = Enum.TextXAlignment.Center

local tweenUp = button(
    settingsPage, "+",
    UDim2.new(0, 144, 0, 119),
    UDim2.fromOffset(35, 30)
)

label(settingsPage, "THEME COLOR",
    UDim2.fromOffset(4, 159),
    UDim2.new(1, -8, 0, 20), 11)

local themeButton = button(
    settingsPage, "Purple  ●",
    UDim2.fromOffset(4, 182),
    UDim2.new(1, -8, 0, 34)
)

local function applyTheme()
    accent = themes[themeNames[themeIndex]]
    farmTab.BackgroundColor3 = accent
    settingsTab.BackgroundColor3 = Color3.fromRGB(46, 47, 64)
    stroke(frame, accent, 1.5).Color = accent
    themeButton.Text = themeNames[themeIndex] .. "  ●"
    themeButton.BackgroundColor3 = accent
    startButton.BackgroundColor3 = accent
end

local function setStatus(message)
    statusLabel.Text = "● " .. tostring(message)
end

local function showPage(page)
    farmPage.Visible = page == "Farm"
    settingsPage.Visible = page == "Settings"

    farmTab.BackgroundColor3 = page == "Farm"
        and accent or Color3.fromRGB(46, 47, 64)

    settingsTab.BackgroundColor3 = page == "Settings"
        and accent or Color3.fromRGB(46, 47, 64)
end

farmTab.Activated:Connect(function()
    showPage("Farm")
end)

settingsTab.Activated:Connect(function()
    showPage("Settings")
end)

local function updateTweenTime()
    tweenValue.Text = string.format("%.1f sec", tweenSeconds)
    if farm then
        farm:SetTweenTime(tweenSeconds)
    end
end

sizeDown.Activated:Connect(function()
    currentSize = math.max(70, currentSize - 10)
    sizeValue.Text = currentSize .. "%"
    TweenService:Create(scale, TweenInfo.new(0.12), {
        Scale = currentSize / 100
    }):Play()
end)

sizeUp.Activated:Connect(function()
    currentSize = math.min(140, currentSize + 10)
    sizeValue.Text = currentSize .. "%"
    TweenService:Create(scale, TweenInfo.new(0.12), {
        Scale = currentSize / 100
    }):Play()
end)

tweenDown.Activated:Connect(function()
    tweenSeconds = math.max(0.5, tweenSeconds - 0.5)
    updateTweenTime()
end)

tweenUp.Activated:Connect(function()
    tweenSeconds = math.min(10, tweenSeconds + 0.5)
    updateTweenTime()
end)

themeButton.Activated:Connect(function()
    themeIndex = themeIndex % #themeNames + 1
    applyTheme()
    showPage(settingsPage.Visible and "Settings" or "Farm")
end)

local function loadFarm()
    if farm then return farm end
    if loading then return nil end

    loading = true
    setStatus("Loading...")

    local ok, result = pcall(function()
        local source = game:HttpGet(FARM_URL)
        local chunk = loadstring(source)
        assert(chunk, "Could not compile autofarm.lua")
        return chunk()
    end)

    loading = false

    if not ok then
        warn("[UGC HUB] Load error:", result)
        setStatus("Load failed")
        return nil
    end

    if type(result) ~= "table"
        or type(result.Start) ~= "function"
        or type(result.Stop) ~= "function"
        or type(result.SetTweenTime) ~= "function" then
        setStatus("Invalid farm module")
        return nil
    end

    farm = result
    farm:SetTweenTime(tweenSeconds)
    return farm
end

startButton.Activated:Connect(function()
    task.spawn(function()
        local module = loadFarm()
        if not module then return end

        module:SetTweenTime(tweenSeconds)
        module:Start(setStatus)
    end)
end)

stopButton.Activated:Connect(function()
    if farm then
        farm:Stop()
    end
    setStatus("Stopped")
end)

close.Activated:Connect(function()
    if farm then farm:Stop() end
    gui:Destroy()
end)

applyTheme()
showPage("Farm")
