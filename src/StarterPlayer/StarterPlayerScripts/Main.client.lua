--!strict

--// Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

--// Modules

local Item = require(ReplicatedFirst.ClientModules.Item)
local Localization = require(ReplicatedFirst.ClientModules.Localization)
local Database = require(ReplicatedStorage.SharedModules.Database)

--// Other Variables

local gui = ReplicatedStorage.Assets.UI.MainInterface:Clone()
local mainPage = gui.MainPage
local productPage = gui.ProductPage
local searchTextBox = mainPage.Search.TextBox
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

local productPageItem = productPage.ItemContainer.Item
local function loadProductPage(item: Item.Item)
	productPageItem.Price.TextLabel.Text = tostring(item.Price) .. " " .. Localization.getUserCurrency()
	productPageItem.ImageLabel.Image = item.Image
	productPageItem.ItemName.Text = item.ItemName
	productPageItem.SellerName.Text = Database.getSellerName(item.SellerId)

	productPage.ItemInfo.Item.Description.Text = item.Description
end

productPage.ItemInfo.Buy.TextButton.MouseButton1Click:Connect(function()
	-- TODO
	print("TODO")
end)

local isViewingItem: boolean = false
local currentView: Item.Item?
local function viewItem(item: Item.Item)
	if isViewingItem then
		warn("Can't view item, already viewing one!")
		return
	end
	isViewingItem = true
	currentView = item
	loadProductPage(item)
	productPage.Visible = true
	mainPage.Visible = false
	-- TODO
end

local function unviewItem()
	assert(currentView, "Can't unview since no view is open!")
	assert(isViewingItem == true, "Can't unview; isViewingItem = false")
	currentView = nil
	isViewingItem = false
	mainPage.Visible = true
	productPage.Visible = false
end

productPage.BackButton.TextButton.MouseButton1Click:Connect(function()
	unviewItem()
end)

local function showQueryResults(query: string)
	clearItems()
	query = trimWhitespace(query)
	local foundItems = Database.newQuery(query)
	for itemId, _ in foundItems do
		local newItem = Item.new(itemId)
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