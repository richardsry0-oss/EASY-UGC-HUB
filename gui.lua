
-- Zyori Auto Farm GUI
-- Loads autofarm.lua separately from GitHub

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local FARM_URL =
    "https://raw.githubusercontent.com/richardsry0-oss/EASY-UGC-HUB/main/autofarm.lua"

local gui = Instance.new("ScreenGui")
gui.Name = "ZyoriAutoFarmGUI"
gui.ResetOnSpawn = false

local parent = player:WaitForChild("PlayerGui")
gui.Parent = parent

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 155)
frame.Position = UDim2.new(0.5, -115, 0.5, -77)
frame.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "ZYORI | AUTO FARM"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 17
title.Parent = frame

local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(10, 37)
status.Size = UDim2.new(1, -20, 0, 25)
status.BackgroundTransparency = 1
status.Text = "Status: Stopped"
status.TextColor3 = Color3.fromRGB(210, 210, 210)
status.TextSize = 13
status.Parent = frame

local function makeButton(text, y, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 36)
    button.Position = UDim2.fromOffset(12, y)
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 15
    button.Text = text
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

local start = makeButton(
    "START AUTO FARM", 65, Color3.fromRGB(40, 145, 85)
)

local stop = makeButton(
    "STOP AUTO FARM", 108, Color3.fromRGB(175, 55, 55)
)

local farm

local function loadFarm()
    if farm then return farm end

    local ok, result = pcall(function()
        local source = game:HttpGet(FARM_URL)
        local loader = loadstring(source)
        assert(loader, "Could not compile autofarm.lua")
        return loader()
    end)

    if not ok then
        warn("[Zyori GUI] Farm load failed:", result)
        status.Text = "Status: Load failed"
        return nil
    end

    if type(result) ~= "table"
        or type(result.Start) ~= "function"
        or type(result.Stop) ~= "function" then
        warn("[Zyori GUI] autofarm.lua returned an invalid module")
        status.Text = "Status: Invalid farm file"
        return nil
    end

    farm = result
    return farm
end

start.Activated:Connect(function()
    status.Text = "Status: Loading..."
    task.spawn(function()
        local module = loadFarm()
        if not module then return end

        local ok, err = pcall(function()
            module:Start()
        end)

        if ok then
            status.Text = "Status: Running"
        else
            status.Text = "Status: Error"
            warn("[Zyori GUI] Start failed:", err)
        end
    end)
end)

stop.Activated:Connect(function()
    if farm then
        pcall(function()
            farm:Stop()
        end)
    end
    status.Text = "Status: Stopped"
end)

