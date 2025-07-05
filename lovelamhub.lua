local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local position = humanoidRootPart.Position
print("Tọa độ hiện tại: " .. position.X .. ", " .. position.Y .. ", " .. position.Z)
