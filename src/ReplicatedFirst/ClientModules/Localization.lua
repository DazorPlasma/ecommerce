--!strict

local Localization = {}
export type Platform = "Computer" | "Mobile"

Localization.getUserCurrency = function(): string
	-- TODO
	return "RON"
end

Localization.getPlatform = function(): Platform
	-- TODO
	return "Computer"
end

return Localization
