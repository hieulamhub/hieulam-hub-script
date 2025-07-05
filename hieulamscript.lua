-- Script: hieulam hub
local player = game.Players.LocalPlayer
local boat = workspace.Boats:FindFirstChild("BeastHunter")
local tikiOutpost = Vector3.new(12345, 100, 67890) -- Thay bằng tọa độ thực tế
local speed = 100
local minBoatHealth = 500

function checkBoatHealth()
    local boatHealth = boat.Health.Value
    if boatHealth < minBoatHealth then
        warn("Máu thuyền thấp: " .. boatHealth .. ". Cần sửa chữa!")
        repairBoat()
    end
end

function repairBoat()
    local shipwright = player.Character:FindFirstChild("ShipwrightSkill")
    if shipwright then
        shipwright:Activate()
        wait(2)
    end
end

function moveBoatTo(targetPos)
    local boatCFrame = boat.PrimaryPart.CFrame
    local direction = (targetPos - boatCFrame.Position).Unit
    boat:SetPrimaryPartCFrame(boatCFrame + direction * speed)
end

function avoidSeaEvents()
    local enemies = workspace:FindFirstChild("SeaEvents")
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy.Name == "Terrorshark" or enemy.Name == "Piranha" then
                local newDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1))
                boat:SetPrimaryPartCFrame(boat.CFrame + newDirection * speed)
            end
        end
    end
end

while true do
    if boat and boat.Health.Value > 0 then
        checkBoatHealth()
        avoidSeaEvents()
        moveBoatTo(tikiOutpost)
        wait(0.1)
    else
        warn("Thuyền bị phá hủy hoặc không tìm thấy!")
        break
    end
end

if (boat.Position - tikiOutpost).Magnitude < 100 then
    print("Đã đến Tiki Outpost với hieulam hub! Giao Leviathan Heart.")
end
