--!strict

--// Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

--// Modules

local Item = require(ReplicatedFirst.ClientModules.Item)
local Database = require(ReplicatedStorage.SharedModules.Database)

--// Other Variables

local gui = ReplicatedStorage.Assets.UI.MainInterface:Clone()
local searchTextBox = gui.Back.Search.TextBox
local lp = Players.LocalPlayer
local playerGui = lp:WaitForChild("PlayerGui")

--// Main Code

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
ContentProvider:PreloadAsync(ReplicatedStorage:GetDescendants())

local possibleDebugInterface = playerGui:WaitForChild("Main", 1)
if possibleDebugInterface then
	possibleDebugInterface:Destroy()
end

local function trimWhitespace(text: string): string
	if type(text) ~= "string" then
		warn(`Invalid text received! Type: {typeof(text)}`)
		return ""
	end
	-- TODO
	return text
end

local currentItems: {Item.Item} = {}
local function clearItems()
	for _, v in currentItems do
		v:destroy()
	end
end

local isViewingItem: boolean = false
local currentView = "TODO"
local function viewItem(item: Item.Item)
	if isViewingItem then
		warn("Can't view item, already viewing one!")
		return
	end
	isViewingItem = true
	-- TODO
end

local function unviewItem()
	assert(currentView ~= nil, "Can't unview since no view is open!")
	assert(isViewingItem == true, "Can't unview; isViewingItem = false")
	-- TODO
end

local function showQueryResults(query: string)
	clearItems()
	local query = trimWhitespace(searchTextBox.Text)
	local foundItems = Database.newQuery(query)
	for _, descriptor in foundItems do
		local newItem = Item.fromItemDescriptor(descriptor)
		table.insert(currentItems, newItem)
		newItem.OnClick.Event:Connect(function()
			if isViewingItem then
				return
			end
			viewItem(newItem)
		end)
	end
end

searchTextBox.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Return then
		showQueryResults(searchTextBox.Text)
	end
end)

gui.Parent = playerGui

showQueryResults("")