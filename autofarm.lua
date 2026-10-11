
-- UGC HUB | Auto Farm Module
-- File: autofarm.lua

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Farm = { Running = false }

local function findTargets()
    local folder = workspace:FindFirstChild("End")
    if not folder then
        return nil, nil, "Workspace.End folder not found"
    end

    local endModel = folder:FindFirstChild("End")
    local board = endModel and endModel:FindFirstChild("Board", true)
    local area = folder:FindFirstChild("Area")

    if not endModel or not endModel:IsA("Model") then
        return nil, nil, "End model not found"
    end

    if not board or not board:IsA("BasePart") then
        return nil, nil, "Board part not found inside End model"
    end

    if not area then
        return nil, nil, "Area not found inside Workspace.End"
    end

    local areaPart
    if area:IsA("BasePart") then
        areaPart = area
    elseif area:IsA("Model") then
        areaPart = area.PrimaryPart
            or area:FindFirstChildWhichIsA("BasePart", true)
    elseif area:IsA("Folder") then
        areaPart = area:FindFirstChildWhichIsA("BasePart", true)
    end

    if not areaPart then
        return nil, nil, "No BasePart found inside Area"
    end

    return board, areaPart
end

function Farm:Start(onStatus)
    if self.Running then return end
    self.Running = true

    task.spawn(function()
        while self.Running do
            local board, areaPart, err = findTargets()
            local character = player.Character
            local root = character
                and character:FindFirstChild("HumanoidRootPart")

            if not board then
                if onStatus then onStatus(err) end
                warn("[UGC HUB] " .. err)
                task.wait(2)
            elseif not root then
                if onStatus then onStatus("Waiting for character...") end
                task.wait(1)
            else
                if onStatus then onStatus("Moving to Board...") end

                root.CFrame = board.CFrame + Vector3.new(0, 3, 0)
                task.wait(1)

                if not self.Running then break end

                -- Optional executor-supported touch request.
                -- The server may not accept client-simulated touches.
                if typeof(firetouchinterest) == "function" then
                    pcall(function()
                        firetouchinterest(root, board, 0)
                        task.wait(0.15)
                        firetouchinterest(root, board, 1)
                    end)
                end

                task.wait(0.5)

                if not self.Running then break end

                character = player.Character
                root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if root and areaPart.Parent then
                    if onStatus then onStatus("Moving to Area...") end
                    root.CFrame = areaPart.CFrame + Vector3.new(0, 3, 0)
                end

                task.wait(1)
            end
        end

        if onStatus then onStatus("Stopped") end
    end)
end

function Farm:Stop()
    self.Running = false
end

return Farm
