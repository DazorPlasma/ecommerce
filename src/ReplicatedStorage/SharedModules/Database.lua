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
}

local LOCAL_TEMPORARY_ITEMS: {Descriptor} = {
	{
		Name = "Șampon electric",
		Image = "14319800860",
		Price = 175,
		SellerId = 2,
	},
	{
		Name = "Dorito expirat",
		Image = "1908575682",
		Price = 17,
		SellerId = 3,
	},
	{
		Name = "Doamna învățătoare",
		Image = "13904789599",
		Price = 2,
		SellerId = 3,
	}
}

function Database.newQuery(query: string?): {Descriptor}
	local foundItems: {Descriptor} = {}
	
	-- TODO; remove this line after database connection is done
	foundItems = LOCAL_TEMPORARY_ITEMS
	
	return foundItems
end

local LOCAL_TEMPORARY_SELLER_HASHMAP = {
	[1] = "Admin",
	[2] = "Tom Beron",
	[3] = "Ăla-micu'"
}

function Database.getSellerName(sellerId: number): string
	-- TODO
	return LOCAL_TEMPORARY_SELLER_HASHMAP[sellerId]
end

return Database