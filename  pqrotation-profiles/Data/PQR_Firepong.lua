local Bleeds = {
	16511, -- Rogue, Hemorrhage
	33876, -- Druid, Cat: Mangle
	33878, -- Druid, Bear: Mangle
	35290, -- Hunter Pet: Gore
	46857, -- Warrior, Trauma
	50271, -- Hunter Pet: Tendon Rip
	57386 -- Hunter Pet: Stampede
}
function PQR_FireBleedDebuff(unit)
	for i=1,#Bleeds do
		if UnitDebuffID(unit, Bleeds[i]) then
			return true
		end
	end
	return false
end

function PQR_FirePlayerBleedDebuff(unit)
	for i=1,#Bleeds do
		if UnitDebuffID(unit, Bleeds[i],"Player") then
			return true 
		end
	end
	return false
end

local mangle = {
	52409, --Ragnaros
	55294 --Ultraxion
}

function PQR_FireTarget(unit)
	for i=1,#mangle do
		local mangleTarget = UnitExists(unit)
		if mangleTarget == 1 then
			local targetid = tonumber(UnitGUID(unit):sub(-13, -9), 16)
			if targetid == mangle[i] then
				return true
			end
		end
	end
	return false
end

local boss = {
	31146, --"Raider's Training Dummy"
	47120, --Argaloth
	52409, --Ragnaros
	55294, --Ultraxion
	52363, --Occu'thar
	55869, --Alizabal
	44600, --Halfus Wyrmbreaker
	45993, --Theralion
	45992, --Valiona
	43324, --Cho'gall
	41570, --Magmaw
	41442, --Atramedes
	43296, --Chimaeron
	41378, --Maloriak
	41376, --Nefarian
	55265, --Morchock
	57773, --Kohcrom
	55308, --Warlord Zon'ozz
	55312, --Yor'sahj the Unsleeping
	55689, --Hagara the Stormbinder
	56427, --Warmaster Blackhorn
	56575, --Burning Tendons
	55167, --Arm Te3ntacle
	55854, --Twilight Elite Dreadblade
	55848, --Twilight Elite Slayer
	56923, --Twilight Sapper
	105651, --Elementium Bolt
	56710, --Elementium Terror
	56724, --Elementium Fragment
	56741, --Mutated Corruption
	52498, --Beth'tilac
	52558, --Lord Rhyolith
	52530, --Alysrazor
	53691, --Shannox
	53494, --Baleroc
	52571, --Majordomo Staghelm
	46753 --Al'Akir

}

function PQR_FireBoss(unit)
	for i=1,#boss do
		local hasTarget = UnitExists(unit)
		if hasTarget == 1 then
			local bossid = tonumber(UnitGUID(unit):sub(-13, -9), 16)
			if bossid == boss[i] then
				return true
			end
		end
	end
	return false
end

local slot = {
	10, --Hands
	13, --Trinket 1
	14 --Trinket 2
}

function PQR_ItemCD()
	for i=1,#slot do
		local item = GetInventoryItemID("Player", slot[i])
		local cd = GetItemCooldown(item)
		local use = GetItemSpell(item)
		if cd == 0 and use ~= nil then
			return true
		end
	end
	return false
end

--num = Number to round
--idp = HOw much places to round to. Negative number not recommended.
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--Var1 = Target
--Var2 = Player
--Var3 = Round Number. Leave blank for 0
function PQR_UnitFlying(var1, var2, var3)
	local targetHeight = select(3, PQR_UnitInfo(var1)) or 0
	local playerHeight = select(3, PQR_UnitInfo(var2))
	
	if UnitExists(var1) and not UnitIsDead(var1) then
		local height = round(targetHeight - playerHeight,var3)
		return height
	end
end