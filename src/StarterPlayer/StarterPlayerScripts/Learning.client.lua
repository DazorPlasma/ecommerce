--!strict

--// Services

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")

--// Modules

local Lessons = require(ReplicatedFirst.ClientModules.Lessons)

--// Other Variables

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui
local aux = playerGui:WaitForChild("Aux")
local camera = workspace.CurrentCamera
local infoFrame = ReplicatedStorage.Assets.UI.InfoFrame
type infoFrameType = typeof(infoFrame)

--// Main Code

ContentProvider:PreloadAsync(SoundService:GetChildren())
camera.CameraType = Enum.CameraType.Scriptable

local function tweenInfoFrameDown(frame: infoFrameType, newText: string)
	TweenService:Create(
		frame.UIAspectRatioConstraint,
		TweenInfo.new(1, Enum.EasingStyle.Quint),
		{ AspectRatio = 3 }
	):Play()
	task.wait(0.2)
	TweenService:Create(frame.Title, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
	TweenService:Create(frame, TweenInfo.new(1), {
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0.8, 0),
	}):Play()
	TweenService:Create(frame.Description, TweenInfo.new(1), {
		Size = UDim2.new(0.95, 0, 0.95, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
	}):Play()
	task.wait(1)
	TweenService:Create(frame.Description, TweenInfo.new(0.3), {
		TextTransparency = 1,
	}):Play()
	task.wait(0.35)
	frame.Description.Text = newText
	TweenService:Create(frame.Description, TweenInfo.new(0.3), {
		TextTransparency = 0,
	}):Play()
end

local function advanceText(frame: infoFrameType, newText: string)
	TweenService:Create(frame.Description, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
	task.wait(0.5)
	frame.Description.Text = newText
	TweenService:Create(frame.Description, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
end

local function newInfoFrame(title: string, description: string): infoFrameType
	local newFrame = infoFrame:Clone()
	newFrame.Title.Text = title
	newFrame.Description.Text = description
	newFrame.Parent = aux
	return newFrame
end

-- timeline

local continueEvent = Instance.new("BindableEvent")

local function waitContinue()
	continueEvent.Event:Wait()
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Return or input.UserInputType == Enum.UserInputType.MouseButton1 then
		continueEvent:Fire()
	end
end)

task.wait(2)

Lessons.showLesson(1)

local lesson1Pages = Lessons.Pages[1]

task.wait(1)
local lesson1 = newInfoFrame(lesson1Pages[1].Title :: string, lesson1Pages[1].Content)
waitContinue()
tweenInfoFrameDown(lesson1, lesson1Pages[2].Content)

local cam1 = Instance.new("Camera")
aux.Frame1.ViewportFrame.CurrentCamera = cam1
cam1.CFrame = CFrame.new(Vector3.new(2.5, 1.3, 0), aux.Frame1.ViewportFrame.Example1.Position)
cam1.Parent = aux.Frame1.ViewportFrame

TweenService:Create(aux.Frame1, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()
TweenService:Create(aux.Frame1.UIStroke, TweenInfo.new(0.4), { Transparency = 0.2 }):Play()
TweenService:Create(aux.Frame1.ViewportFrame, TweenInfo.new(0.4), { ImageTransparency = 0 }):Play()

task.wait(0.5)

local cam2 = Instance.new("Camera")
aux.Frame2.ViewportFrame.CurrentCamera = cam2
cam2.CFrame = CFrame.new(Vector3.new(1.8, 1.8, 1.8), aux.Frame2.ViewportFrame.Example2.Position)
cam2.Parent = aux.Frame2.ViewportFrame

TweenService:Create(aux.Frame2, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()
TweenService:Create(aux.Frame2.UIStroke, TweenInfo.new(0.4), { Transparency = 0.2 }):Play()
TweenService:Create(aux.Frame2.ViewportFrame, TweenInfo.new(0.4), { ImageTransparency = 0 }):Play()

task.wait(0.5)

local cam3 = Instance.new("Camera")
aux.Frame3.ViewportFrame.CurrentCamera = cam3
cam3.CFrame = CFrame.new(Vector3.new(2, 1, 2), aux.Frame3.ViewportFrame.Example3.Position)
cam3.Parent = aux.Frame3.ViewportFrame

TweenService:Create(aux.Frame3, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()
TweenService:Create(aux.Frame3.UIStroke, TweenInfo.new(0.4), { Transparency = 0.2 }):Play()
TweenService:Create(aux.Frame3.ViewportFrame, TweenInfo.new(0.4), { ImageTransparency = 0 }):Play()

task.wait(0.5)

waitContinue()
advanceText(lesson1, lesson1Pages[3].Content)
waitContinue()
lesson1:Destroy()
aux.StartFill.Visible = false
aux.Frame1.Visible = false
aux.Frame2.Visible = false
aux.Frame3.Visible = false
playerGui.MainInterface.Enabled = true

local function playScene(item: string)
	local root = localPlayer.Character.HumanoidRootPart
	camera.CameraType = Enum.CameraType.Scriptable
	playerGui.MainInterface.Enabled = false
	camera.CFrame = workspace.LessonTwoCamera.CFrame
	local isPackageCollected = false
	root.CFrame = workspace.LessonTwoDoorPlayerPosition.CFrame

	task.spawn(function()
		while not isPackageCollected do
			TweenService:Create(
				camera,
				TweenInfo.new(1 / 15),
				{ CFrame = CFrame.new(workspace.LessonTwoCamera.Position, root.Position) }
			):Play()
			task.wait(1 / 30)
		end
	end)
	SoundService.Bell:Play()
	task.wait(2)
	SoundService.OpenDoor:Play()
	workspace.Door.Transparency = 1
	task.wait(1)
	localPlayer.Character.Humanoid:MoveTo(workspace.Package.Position)
	local package = workspace.Package
	local touchConnection: RBXScriptConnection
	touchConnection = package.Touched:Connect(function(otherPart)
		if not otherPart:IsDescendantOf(localPlayer.Character) then
			return
		end
		touchConnection:Disconnect()
		package:Destroy()
		isPackageCollected = true
	end)
	repeat
		wait()
	until isPackageCollected
	task.wait(0.5)
	localPlayer.Character.Humanoid:MoveTo(workspace.LessonTwoDoorPlayerPosition.Position)
	task.wait(1.5)
	workspace.Door.Transparency = 0
	SoundService.CloseDoor:Play()
	task.wait(1)

	-- part 2: be careful of your purchase!
	if item == "cow" or item == "dorito" then
		error("Prototype doesn't feature this!")
	elseif item == "shampoo" then
		local bathWater = workspace.Bath.Water
		local waterGoalSize = bathWater.Size + Vector3.yAxis * 2
		local waterGoalPosition = bathWater.Position + Vector3.yAxis

		root.CFrame = workspace.Bath.TubPosition.CFrame
		camera.CFrame = workspace.ShampScene.CFrame
		localPlayer.Character.Humanoid.Sit = true
		SoundService.Waterfill:Play()
		TweenService:Create(
			workspace.Bath.Water,
			TweenInfo.new(8, Enum.EasingStyle.Linear),
			{ Size = waterGoalSize, Position = waterGoalPosition }
		):Play()
		task.wait(8)
		SoundService.Waterfill:Stop()
		task.wait(0.5)
		workspace.ShampProp:MoveTo(Vector3.new(-49.677, 3.369, 51.668))
		SoundService.TaDa:Play()
		task.wait(1)
		SoundService.TaDa:Stop()
		workspace.ShampProp:SetPrimaryPartCFrame(workspace.DrinkShampPos.CFrame)
		SoundService.ShampDrink:Play()
		task.wait(1)
		SoundService.ShampDrink:Stop()
		SoundService.Electric:Play()
		workspace.Bath.TubPosition.Electro.Enabled = true
		task.wait(3)
		workspace.Bath.TubPosition.Electro.Enabled = false
		TweenService:Create(Lighting.Blur, TweenInfo.new(1), { Size = 50 }):Play()
		SoundService.Electric:Stop()
		SoundService.WompWomp:Play()
		local shampFail = newInfoFrame(lesson1Pages[4].Title :: string, lesson1Pages[4].Content)
		waitContinue()
		shampFail:Destroy()
		Lighting.Blur.Size = 0
	else
		error(`unknown item: {item}`)
	end
end

local boughtItem = ReplicatedStorage.Bindables.ItemBought.Event:Wait()
playScene(boughtItem)
