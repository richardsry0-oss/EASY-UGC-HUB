
-- UGC HUB | Animated Mobile UI
-- File: gui.lua

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local FARM_URL =
    "https://raw.githubusercontent.com/richardsry0-oss/EASY-UGC-HUB/main/autofarm.lua"

local old = player.PlayerGui:FindFirstChild("UGCHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "UGCHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local function tween(object, info, properties)
    local t = TweenService:Create(object, info, properties)
    t:Play()
    return t
end

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(280, 220)
frame.Position = UDim2.new(0.5, -140, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(19, 21, 29)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Parent = gui
corner(frame, 16)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(91, 101, 150)
stroke.Thickness = 1.3
stroke.Transparency = 0.15
stroke.Parent = frame

local scale = Instance.new("UIScale")
scale.Scale = 0.82
scale.Parent = frame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundColor3 = Color3.fromRGB(32, 35, 49)
header.BorderSizePixel = 0
header.Parent = frame

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(15, 4)
title.Size = UDim2.new(1, -65, 0, 28)
title.BackgroundTransparency = 1
title.Text = "UGC HUB"
title.TextColor3 = Color3.fromRGB(245, 246, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Position = UDim2.fromOffset(16, 30)
subtitle.Size = UDim2.new(1, -70, 0, 16)
subtitle.BackgroundTransparency = 1
subtitle.Text = "AUTO FARM  •  MOBILE"
subtitle.TextColor3 = Color3.fromRGB(157, 165, 195)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 34)
close.Position = UDim2.new(1, -44, 0, 10)
close.Text = "×"
close.TextSize = 25
close.Font = Enum.Font.Gotham
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(65, 68, 86)
close.BorderSizePixel = 0
close.Parent = header
corner(close, 10)

local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(16, 67)
status.Size = UDim2.new(1, -32, 0, 29)
status.BackgroundColor3 = Color3.fromRGB(31, 34, 46)
status.Text = "●  Ready"
status.TextColor3 = Color3.fromRGB(190, 198, 220)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame
corner(status, 8)

local function makeButton(text, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -32, 0, 39)
    b.Position = UDim2.fromOffset(16, y)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = true
    b.Parent = frame
    corner(b, 10)
    return b
end

local start = makeButton(
    "▶   START AUTO FARM", 108, Color3.fromRGB(53, 139, 103)
)

local stop = makeButton(
    "■   STOP AUTO FARM", 154, Color3.fromRGB(164, 69, 78)
)

local footer = Instance.new("TextLabel")
footer.Position = UDim2.new(0, 12, 1, -24)
footer.Size = UDim2.new(1, -24, 0, 18)
footer.BackgroundTransparency = 1
footer.Text = "UGC HUB  •  v1.1"
footer.TextColor3 = Color3.fromRGB(117, 124, 150)
footer.Font = Enum.Font.Gotham
footer.TextSize = 10
footer.Parent = frame

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(54, 54)
reopen.Position = UDim2.new(1, -70, 0.5, -27)
reopen.BackgroundColor3 = Color3.fromRGB(48, 55, 86)
reopen.Text = "UGC"
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 14
reopen.Visible = false
reopen.Parent = gui
corner(reopen, 18)

local function setStatus(message, color)
    status.Text = "●  " .. message
    if color then status.TextColor3 = color end
end

local function openUI()
    reopen.Visible = false
    frame.Visible = true
    scale.Scale = 0.82
    frame.BackgroundTransparency = 0.15

    tween(scale, TweenInfo.new(
        0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out
    ), {Scale = 1})

    tween(frame, TweenInfo.new(0.18), {
        BackgroundTransparency = 0
    })
end

local function closeUI()
    local t = tween(scale, TweenInfo.new(
        0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In
    ), {Scale = 0.78})

    tween(frame, TweenInfo.new(0.16), {
        BackgroundTransparency = 0.3
    })

    t.Completed:Once(function()
        frame.Visible = false
        frame.BackgroundTransparency = 0
        reopen.Visible = true
    end)
end

close.Activated:Connect(closeUI)
reopen.Activated:Connect(openUI)

local farm
local loading = false

local function loadFarm()
    if farm then return farm end
    if loading then return nil end
    loading = true
    setStatus("Loading farm script...")

    local ok, result = pcall(function()
        local source = game:HttpGet(FARM_URL)
        local chunk = loadstring(source)
        assert(chunk, "Lua compilation failed")
        return chunk()
    end)

    loading = false

    if not ok then
        warn("[UGC HUB] Load error:", result)
        setStatus("Load failed - check console",
            Color3.fromRGB(255, 130, 130))
        return nil
    end

    if type(result) ~= "table"
        or type(result.Start) ~= "function"
        or type(result.Stop) ~= "function" then
        setStatus("Invalid farm module",
            Color3.fromRGB(255, 130, 130))
        return nil
    end

    farm = result
    return farm
end

start.Activated:Connect(function()
    task.spawn(function()
        local module = loadFarm()
        if not module then return end

        local ok, err = pcall(function()
            module:Start(function(message)
                setStatus(message)
            end)
        end)

        if not ok then
            warn("[UGC HUB] Start error:", err)
            setStatus("Start failed",
                Color3.fromRGB(255, 130, 130))
        end
    end)
end)

stop.Activated:Connect(function()
    if farm then
        pcall(function() farm:Stop() end)
    end
    setStatus("Stopped")
end)

openUI()
