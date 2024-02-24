--!strict

local QueryStrip = {}

local tableAccents = {}
tableAccents["ß"] = "s"
tableAccents["ă"] = "a"
tableAccents["à"] = "a"
tableAccents["á"] = "a"
tableAccents["â"] = "a"
tableAccents["ã"] = "a"
tableAccents["ä"] = "a"
tableAccents["å"] = "a"
tableAccents["æ"] = "ae"
tableAccents["ç"] = "c"
tableAccents["è"] = "e"
tableAccents["é"] = "e"
tableAccents["ê"] = "e"
tableAccents["ë"] = "e"
tableAccents["ì"] = "i"
tableAccents["í"] = "i"
tableAccents["î"] = "i"
tableAccents["ï"] = "i"
tableAccents["ð"] = "eth"
tableAccents["ñ"] = "n"
tableAccents["ò"] = "o"
tableAccents["ó"] = "o"
tableAccents["ô"] = "o"
tableAccents["õ"] = "o"
tableAccents["ö"] = "o"
tableAccents["ø"] = "o"
tableAccents["ù"] = "u"
tableAccents["ú"] = "u"
tableAccents["û"] = "u"
tableAccents["ü"] = "u"
tableAccents["ý"] = "y"
tableAccents["þ"] = "p"
tableAccents["ÿ"] = "y"

function QueryStrip.strip(query: string): string
	-- no accents
	query = string.gsub(query, "[%z\1-\127\194-\244][\128-\191]*", tableAccents)
	-- no whitespace
	query = string.gsub(query, "%s+", "")
	-- make lowercase
	query = string.lower(query)

	return query
end

return QueryStrip
