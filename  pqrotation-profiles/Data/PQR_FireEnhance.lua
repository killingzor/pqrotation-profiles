local deepc = {
	105171,
	109390,
	108220
}

function PQR_FireCorruption(unit)
	for i=1,#deepc do
		if UnitDebuffID(unit, deepc[i]) == nil then
			return false
		end
	end
	return nil
end

local slot = {
	10, --Hands
	13, --Trinket 1
	14 --Trinket 2
}

function PQR_ItemCD(unit)
	for i=1,#slot do
		local item = GetInventoryItemID(unit, slot[i])
		local cd = GetItemCooldown(item)
		local use = GetItemSpell(item)
		if cd == 0 and use ~= nil then
			return true
		end
	end
	return false
end