--!strict

--// Services

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--// Other Variables

local Localization = {}
export type Platform = "Computer" | "Mobile"
local region = LocalizationService:GetCountryRegionForPlayerAsync(Players.LocalPlayer)

local REGION_CURRENCY_HASHMAP = {
	US = "USD",
	RO = "RON",
}

--// Main Code

Localization.userCurrency = REGION_CURRENCY_HASHMAP[region] or "RON"
function Localization.localCurrency(price: number): string
	local c = Localization.userCurrency
	local newPrice
	if c == "USD" then
		newPrice = price
	elseif c == "RON" then
		newPrice = price * 4
	end
	assert(newPrice, "Invalid conversion!")

	return tostring(newPrice) .. " " .. Localization.userCurrency
end

Localization.getPlatform = function(): Platform
	if UserInputService.TouchEnabled then
		return "Mobile"
	else
		return "Computer"
	end
end

return Localization
