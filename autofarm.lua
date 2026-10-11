
-- UGC HUB | Tween Auto Farm
-- File: autofarm.lua

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local Farm = {
    Running = false,
    TweenTime = 2,
    ActiveTween = nil,
    OnStatus = nil,
}

function Farm:SetTweenTime(seconds)
    self.TweenTime = math.clamp(tonumber(seconds) or 2, 0.5, 10)
end

local function findTargets()
    local folder = workspace:FindFirstChild("End")
    if not folder then
        return nil, nil, "Workspace.End not found"
    end

    local trigger = folder:FindFirstChild("FinishTrigger", true)
    local area = folder:FindFirstChild("Area", true)

    if not trigger or not trigger:IsA("BasePart") then
        return nil, nil, "FinishTrigger BasePart not found"
    end

    if not area then
        return nil, nil, "Area not found"
    end

    local destination

    if area:IsA("BasePart") then
        destination = area
    elseif area:IsA("Model") then
        destination = area.PrimaryPart
            or area:FindFirstChildWhichIsA("BasePart", true)
    else
        destination = area:FindFirstChildWhichIsA("BasePart", true)
    end

    if not destination then
        return nil, nil, "No part inside Area"
    end

    return trigger, destination
end

local function status(message)
    if Farm.OnStatus then
        Farm.OnStatus(message)
    end
end

local function tweenTo(root, targetCFrame)
    if not Farm.Running or not root.Parent then
        return false
    end

    local distance = (root.Position - targetCFrame.Position).Magnitude

    -- Scale duration with distance while respecting the chosen setting.
    local duration = math.clamp(
        distance / 60 * Farm.TweenTime,
        0.5,
        10
    )

    local tween = TweenService:Create(
        root,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        ),
        { CFrame = targetCFrame }
    )

    Farm.ActiveTween = tween
    tween:Play()

    local result = tween.Completed:Wait()
    if Farm.ActiveTween == tween then
        Farm.ActiveTween = nil
    end

    return Farm.Running
        and result == Enum.PlaybackState.Completed
end

function Farm:Start(onStatus)
    if self.Running then return end

    self.Running = true
    self.OnStatus = onStatus

    task.spawn(function()
        while self.Running do
            local trigger, destination, err = findTargets()

            if not trigger then
                status(err)
                task.wait(2)
                continue
            end

            local character = player.Character
            local root = character
                and character:FindFirstChild("HumanoidRootPart")

            if not root then
                status("Waiting for character...")
                task.wait(1)
                continue
            end

            status("Tweening to FinishTrigger...")

            local reached = tweenTo(
                root,
                trigger.CFrame + Vector3.new(0, 2, 0)
            )

            if not reached then
                break
            end

            -- Allow the game time to process the trigger.
            status("Waiting for trigger...")
            task.wait(0.75)

            if not self.Running then break end

            character = player.Character
            root = character
                and character:FindFirstChild("HumanoidRootPart")

            if root and destination.Parent then
                status("Tweening to Area...")

                tweenTo(
                    root,
                    destination.CFrame + Vector3.new(0, 3, 0)
                )
            end

            task.wait(1)
        end

        self.Running = false
        self.ActiveTween = nil
        status("Stopped")
    end)
end

function Farm:Stop()
    self.Running = false

    if self.ActiveTween then
        self.ActiveTween:Cancel()
        self.ActiveTween = nil
    end
end

return Farm
