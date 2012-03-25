local Bleeds = {
	16511, -- Rogue, Hemorrhage
	33876, -- Druid, Cat: Mangle
	33878, -- Druid, Bear: Mangle
	35290, -- Hunter Pet: Gore
	46857, -- Warrior, Trauma
	50271, -- Hunter Pet: Tendon Rip
	57386, -- Hunter Pet: Stampede
}
function PQR_BleedDebuff(unit)
	for i=1,#Bleeds do
		if UnitDebuffID(unit,Bleeds[i]) then return true end
	end
	return false
end

function PQR_PlayerBleedDebuff(unit)
	for i=1,#Bleeds do
		if UnitDebuffID(unit,Bleeds[i],"player") then
			return true 
		end
	end
	return false
end

local myTable = {
	"Ultraxion",
	"Raider's Training Dummy"
}

function PQR_Fire(unit)
	for i=1,#myTable do
		if UnitName("Target") == myTable[i] then
			return true
		end
	end
	return false
end
