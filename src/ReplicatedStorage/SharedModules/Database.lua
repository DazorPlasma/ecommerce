--!strict

local Database = {}

--[=[
	Returns items that match the given query.
	If the query is empty, return the current top items.
]=]

export type Descriptor = {
	Name: string,
	Image: string,
	Price: number,
	SellerId: number,
	Description: string,
}

local LOCAL_TEMPORARY_ITEMS: {[string]: Descriptor} = {
	["ASDSA"] = {
		Name = "Șampon electric",
		Image = "14319800860",
		Price = 175,
		SellerId = 1,
		Description = "lorem ipsum est"
	},
	["0xffffff"] = {
		Name = "Dorito expirat",
		Image = "1908575682",
		Price = 17,
		SellerId = 2,
		Description = "hello world"
	},
	["asdfghjkl"] = {
		Name = "Doamna învățătoare",
		Image = "13904789599",
		Price = 2,
		SellerId = 3,
		Description = "vă garantez eu că e 100% biodegradabilă"
	}
}

local function refineQuery(query: string?): string
	if not query then
		return ""
	end
	-- TODO (remove accents, whitespace, etc)
	return query
end

local function matchesQuery(query: string, name: string): boolean
	return string.find(name, query) ~= nil
end


function Database.newQuery(query: string?): {[string]: Descriptor}
	local refinedQuery = refineQuery(query)
	if refinedQuery == "" then
		return LOCAL_TEMPORARY_ITEMS
	end

	local foundItems: {[string]: Descriptor} = {}

	for i, v in LOCAL_TEMPORARY_ITEMS do
		if matchesQuery(refinedQuery, v.Name) then
			foundItems[i] = v
		end
	end

	return foundItems
end

local LOCAL_TEMPORARY_SELLER_HASHMAP = {
	[1] = "Admin",
	[2] = "Tom Beron",
	[3] = "Ăla-micu'"
}

function Database.getSellerName(sellerId: number): string
	return LOCAL_TEMPORARY_SELLER_HASHMAP[sellerId]
end

function Database.getItemInfo(itemId: string): Descriptor
	local found = LOCAL_TEMPORARY_ITEMS[itemId]
	assert(found, "Item not found!")
	return found
end

return Database