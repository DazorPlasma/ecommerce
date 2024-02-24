--!strict

--// Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

--// Modules

local Localization = require(ReplicatedFirst.ClientModules.Localization)
local Database = require(ReplicatedStorage.SharedModules.Database)

--// Other Variables

local ITEM_NAME_MAX_LENGTH: number = 30

local lp = Players.LocalPlayer
local itemFrame = ReplicatedStorage.Assets.UI.ItemContainer

--[=[
    @class Item

    This class manages items in the interface.
    
    @prop Destroyed bool
    Indicates if the item is no longer usable.
]=]
local Item = {}
Item.__index = Item

type self = {
	ItemName: string,
	Price: number,
	Frame: typeof(itemFrame),
	OnClick: BindableEvent,
	Destroyed: boolean
}

export type Item = typeof(setmetatable({} :: self, Item))



local interfaceCache
--[=[
	@yields
]=]
local function getMainInterface(): typeof(ReplicatedStorage.Assets.UI.MainInterface)
	if interfaceCache then
		return interfaceCache
	end
	interfaceCache = lp:WaitForChild("PlayerGui"):WaitForChild("MainInterface")
	return interfaceCache
end

function Item.new(name: string, price: number, image: string?): Item
	assert(price > 0, "Price must be a positive integer!")
	assert(string.len(name) <= ITEM_NAME_MAX_LENGTH, "Item name too long!")

	local self = setmetatable({} :: self, Item)
	self.Frame = itemFrame:Clone()
	self.ItemName = name
	self.Price = price
	self.OnClick = Instance.new("BindableEvent")
	self.Destroyed = false
	
	if image then
		assert(type(image) == "string", "Invalid image id!")
		local isOnlyNumber: boolean = false
		pcall(function()
			local possible = tonumber(image)
			if possible then
				isOnlyNumber = true
			end
		end)
		if isOnlyNumber then
			image = "rbxassetid://"..image
		end
		self.Frame.Item.ImageLabel.Image = image
	end
	
	self.Frame.Item.Price.TextLabel.Text = tostring(price)
		.. " " .. Localization.getUserCurrency()
	self.Frame.Item.ItemName.Text = name
	self.Frame.Parent = getMainInterface().MainPage.List

	self.Frame.InputBegan:Connect(function(input)
		local isMouseClick = input.UserInputType == Enum.UserInputType.MouseButton1
		if not isMouseClick then
			return
		end
		self.OnClick:Fire()
	end)
	
	self.Frame.TouchTap:Connect(function()
		if Localization.getPlatform() ~= "Mobile" then
			warn("User tapped an item but they're not on mobile!")
		end
		self.OnClick:Fire()
	end)
	
	return self
end

function Item.fromItemDescriptor(descriptor: Database.Descriptor): Item
	return Item.new(descriptor.Name, descriptor.Price, descriptor.Image)
end

function Item.destroy(self: Item)
	self.Destroyed = true
	self.Frame:Destroy()
	self.OnClick:Destroy()
end

return Item