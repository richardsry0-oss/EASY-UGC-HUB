
-- Zyori Auto Farm
-- Separate client-side farming logic

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local Farm = {}
Farm.Running = false

local function getTargets()
    local folder = workspace:FindFirstChild("End")
    if not folder then
        return nil, nil
    end

    local endModel = folder:FindFirstChild("End")
    local spawnModel = folder:FindFirstChild("Back2Spawn")

    local board = endModel and endModel:FindFirstChild("Board", true)

    if not board or not board:IsA("BasePart") then
        return nil, nil
    end

    if not spawnModel then
        return nil, nil
    end

    return board, spawnModel
end

function Farm:Start()
    if self.Running then return end
    self.Running = true

    task.spawn(function()
        while self.Running do
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local board, spawnModel = getTargets()

            if root and board and spawnModel then
                -- Client-side movement request.
                root.CFrame = board.CFrame + Vector3.new(0, 3, 0)

                -- Allow the game time to process the interaction.
                task.wait(1)

                -- This does not guarantee that the server accepts a touch.
                if self.Running and root.Parent then
                    local spawnPart =
                        spawnModel.PrimaryPart
                        or spawnModel:FindFirstChildWhichIsA("BasePart", true)

                    if spawnPart then
                        root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            else
                warn("[Zyori Auto Farm] Board or Back2Spawn not found")
            end

            task.wait(1)
        end
    end)
end

function Farm:Stop()
    self.Running = false
end

return Farm
