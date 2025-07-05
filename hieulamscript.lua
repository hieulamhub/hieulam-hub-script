-- Script: hieulam hub with UI, Avatar Image, Auto Farm Level, and Auto Sea Event
local player = game.Players.LocalPlayer
local boat = workspace.Boats:FindFirstChild("BeastHunter")
local tikiOutpost = Vector3.new(12345, 100, 67890) -- Thay bằng tọa độ thực tế
local speed = 100
local minBoatHealth = 500
local autoFarmEnabled = false
local autoSeaEventEnabled = false

-- Tạo giao diện UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local TitleLabel = Instance.new("TextLabel")
local FarmButton = Instance.new("TextButton")
local SeaEventButton = Instance.new("TextButton")

-- Thiết lập ScreenGui
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "HieulamHubUI"

-- Thiết lập Frame
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu nền tối
Frame.Size = UDim2.new(0, 300, 0, 250) -- Kích thước cửa sổ
Frame.Position = UDim2.new(0.5, -150, 0.5, -125) -- Vị trí giữa màn hình
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)

-- Thiết lập ImageLabel (Ảnh đại diện)
ImageLabel.Parent = Frame
ImageLabel.Size = UDim2.new(0, 100, 0, 100) -- Kích thước ảnh
ImageLabel.Position = UDim2.new(0, 10, 0, 10) -- Vị trí ảnh trong Frame
ImageLabel.Image = "https://www.dropbox.com/scl/fi/h9smtogkabe4gsj0sx49v/preview-image.png?rlkey=mt627ycts4a3rajgfixvlvbgz&st=glshuf6t&dl=1" -- URL ảnh trực tiếp
ImageLabel.BackgroundTransparency = 1 -- Xóa nền ảnh

-- Thiết lập TitleLabel (Tiêu đề)
TitleLabel.Parent = Frame
TitleLabel.Size = UDim2.new(0, 280, 0, 50)
TitleLabel.Position = UDim2.new(0, 10, 0, 120)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Hieulam Hub - Blox Fruit"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSansBold

-- Thiết lập FarmButton (Nút Auto Farm Level)
FarmButton.Parent = Frame
FarmButton.Size = UDim2.new(0, 120, 0, 50)
FarmButton.Position = UDim2.new(0, 10, 0, 180)
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
FarmButton.Text = "Auto Farm Level: OFF"
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    FarmButton.Text = "Auto Farm Level: " .. (autoFarmEnabled and "ON" or "OFF")
    if autoFarmEnabled then
        spawn(autoFarmLevel)
    end
end)

-- Thiết lập SeaEventButton (Nút Auto Sea Event)
SeaEventButton.Parent = Frame
SeaEventButton.Size = UDim2.new(0, 120, 0, 50)
SeaEventButton.Position = UDim2.new(0, 140, 0, 180)
SeaEventButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
SeaEventButton.Text = "Auto Sea Event: OFF"
SeaEventButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SeaEventButton.Font = Enum.Font.SourceSansBold
SeaEventButton.MouseButton1Click:Connect(function()
    autoSeaEventEnabled = not autoSeaEventEnabled
    SeaEventButton.Text = "Auto Sea Event: " .. (autoSeaEventEnabled and "ON" or "OFF")
    if autoSeaEventEnabled then
        spawn(autoSeaEvent)
    end
end)

-- Hàm kiểm tra máu thuyền
function checkBoatHealth()
    local boatHealth = boat.Health.Value
    if boatHealth < minBoatHealth then
        warn("Máu thuyền thấp: " .. boatHealth .. ". Cần sửa chữa!")
        repairBoat()
    end
end

-- Hàm sửa chữa thuyền
function repairBoat()
    local shipwright = player.Character:FindFirstChild("ShipwrightSkill")
    if shipwright then
        shipwright:Activate()
        wait(2)
    end
end

-- Hàm di chuyển thuyền
function moveBoatTo(targetPos)
    local boatCFrame = boat.PrimaryPart.CFrame
    local direction = (targetPos - boatCFrame.Position).Unit
    boat:SetPrimaryPartCFrame(boatCFrame + direction * speed)
end

-- Hàm tránh sự kiện biển
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

-- Hàm Auto Farm Level
function autoFarmLevel()
    while autoFarmEnabled and wait(0.1) do
        local enemies = workspace.Mobs:GetChildren() -- Giả định mobs nằm trong workspace.Mobs
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                wait(0.5) -- Đợi để tấn công
            end
        end
    end
end

-- Hàm Auto Sea Event
function autoSeaEvent()
    while autoSeaEventEnabled and wait(0.1) do
        local seaEvents = workspace:FindFirstChild("SeaEvents")
        if seaEvents then
            for _, event in pairs(seaEvents:GetChildren()) do
                if event:FindFirstChild("Humanoid") and event.Humanoid.Health > 0 then
                    player.Character.HumanoidRootPart.CFrame = event.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                    wait(0.5) -- Đợi để tấn công
                end
            end
        end
    end
end

-- Vòng lặp chính
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

-- Kiểm tra đến Tiki Outpost
if (boat.Position - tikiOutpost).Magnitude < 100 then
    print("Đã đến Tiki Outpost với hieulam hub! Giao Leviathan Heart.")
end
