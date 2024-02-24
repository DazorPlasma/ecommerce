--!strict

--// Services

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--// Modules

local Lessons = require(ReplicatedFirst.ClientModules.Lessons)

--// Other Variables

local playerGui = Players.LocalPlayer.PlayerGui
local camera = workspace.CurrentCamera
local infoFrame = ReplicatedStorage.Assets.UI.InfoFrame
type infoFrameType = typeof(infoFrame)

--// Main Code

camera.CameraType = Enum.CameraType.Scriptable

local function tweenInfoFrameDown(frame: infoFrameType, newText: string)
	TweenService:Create(frame.UIAspectRatioConstraint, TweenInfo.new(1, Enum.EasingStyle.Quint), { AspectRatio = 3 }):Play()
	task.wait(0.2)
	TweenService:Create(frame.Title, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
	TweenService:Create(
		frame,
		TweenInfo.new(1),
		{
			Size = UDim2.new(0.5, 0, 0.5, 0),
			Position = UDim2.new(0.5, 0, 0.8, 0)
		}
	):Play()
	TweenService:Create(
		frame.Description,
		TweenInfo.new(1),
		{
			Size = UDim2.new(0.95, 0, 0.95, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
		}
	):Play()
	task.wait(1)
	TweenService:Create(
		frame.Description,
		TweenInfo.new(0.3),
		{
			TextTransparency = 1
		}
	):Play()
	task.wait(0.35)
	frame.Description.Text = newText
	TweenService:Create(
		frame.Description,
		TweenInfo.new(0.3),
		{
			TextTransparency = 0
		}
	):Play()
end

local function advanceText(frame: infoFrameType, newText: string)
	TweenService:Create(
		frame.Description,
		TweenInfo.new(0.5),
		{TextTransparency = 1}
	):Play()
	task.wait(0.5)
	frame.Description.Text = newText
	TweenService:Create(
		frame.Description,
		TweenInfo.new(0.5),
		{TextTransparency = 0}
	):Play()
end

local function newInfoFrame(title: string, description: string): infoFrameType
	local newFrame = infoFrame:Clone()
	newFrame.Title.Text = title
	newFrame.Description.Text = description
	newFrame.Parent = playerGui.Aux
	return newFrame
end

-- timeline

local continueEvent = Instance.new("BindableEvent")

local function waitContinue()
	continueEvent.Event:Wait()
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Return or
		input.UserInputType == Enum.UserInputType.MouseButton1 then
		continueEvent:Fire()
	end
end)

task.wait(2)

Lessons.showLesson(1)

local lesson1Pages = Lessons.Pages[1]

task.wait(1)
local testFrame = newInfoFrame(lesson1Pages[1].Title :: string, lesson1Pages[1].Content)
waitContinue()
tweenInfoFrameDown(testFrame, lesson1Pages[2].Content)
waitContinue()
advanceText(testFrame, lesson1Pages[3].Content)
waitContinue()
testFrame:Destroy()
playerGui.MainInterface.Enabled = true
