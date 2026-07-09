local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local isHarvesting = false

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MaxillaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 70)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(105, 181, 206)
TitleLabel.Text = "Maxilla Hub"
TitleLabel.TextSize = 16
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "HARVEST: OFF"
ToggleBtn.TextSize = 12
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.075, 0, 0, 35)
ToggleBtn.Parent = MainFrame
ToggleBtn.AutoButtonColor = false

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local function startHarvesting()
	while isHarvesting do
		local found = false
		for _, obj in pairs(Workspace:GetDescendants()) do
			if not isHarvesting then break end
			
			local isHarvestPrompt = false
			if obj:IsA("ProximityPrompt") then
				local text = string.lower(obj.ActionText .. obj.ObjectText)
				if string.find(text, "harvest") then
					isHarvestPrompt = true
				end
			elseif obj:IsA("BillboardGui") then
				if string.find(string.lower(obj.Name), "harvest") then
					isHarvestPrompt = true
				end
			end
			
			if isHarvestPrompt then
				local parent = obj:FindFirstAncestorOfClass("Model") or obj.Parent
				if parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local pos = (parent:IsA("Model") and parent:GetPivot().Position) or (parent:IsA("BasePart") and parent.Position)
					if pos then
						LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
						if obj:IsA("ProximityPrompt") then
							fireproximityprompt(obj)
						end
						found = true
						RunService.RenderStepped:Wait()
					end
				end
			end
		end
		
		if not found then
			task.wait(0.5)
		end
	end
end

ToggleBtn.MouseButton1Click:Connect(function()
	isHarvesting = not isHarvesting
	ToggleBtn.Text = isHarvesting and "HARVEST: ON" or "HARVEST: OFF"
	ToggleBtn.BackgroundColor3 = isHarvesting and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(40, 40, 40)
	if isHarvesting then
		task.spawn(startHarvesting)
	end
end)
