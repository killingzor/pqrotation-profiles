function ChainHeal()
	if UnitExists(select(2,Fire_Unit())) then
		local Distance = PQR_UnitDistance(select(2,Fire_Unit()),select(2,Fire_Unit()))
		local hpPercent = UnitHealth(select(2,Fire_Unit()))/UnitHealthMax(select(2,Fire_Unit()))*100
		
		if Distance < 11.5 and (hpPercent and hpPercent) < 95 then
			return true
		end
	end
	return false
end

function HealTarget()
	if UnitExists(select(2,Fire_Unit())) then
		local health = UnitHealth(select(2,Fire_Unit()))
		local maxHealth = UnitHealthMax(select(2,Fire_Unit()))
		local allIncomingHeal = UnitGetIncomingHeals(select(2,Fire_Unit())) or 0
		
		if (health + allIncomingHeal) < maxHealth then
			return true
		end
	end
	return false
end

--Var1 == true or false
--Var2 == selected Unit
--Var3 == HP of selected Unit
local list = {
	"Mouseover",
	"Player",
	"Party1",
	"Party2",
	"Party3",
	"Party4",
	"Raid1",
	"Raid2",
	"Raid3",
	"Raid4",
	"Raid5",
	"Raid6",
	"Raid7",
	"Raid8",
	"Raid9",
	"Raid10",
	"Raid11",
	"Raid12",
	"Raid13",
	"Raid14",
	"Raid15",
	"Raid16",
	"Raid17",
	"Raid18",
	"Raid19",
	"Raid20",
	"Raid21",
	"Raid22",
	"Raid23",
	"Raid24",
	"Raid25",
	"Raid26",
	"Raid27",
	"Raid28",
	"Raid29",
	"Raid30",
	"Raid31",
	"Raid32",
	"Raid33",
	"Raid34",
	"Raid35",
	"Raid36",
	"Raid37",
	"Raid38",
	"Raid39",
	"Raid40",
	"Pet"
}

function Fire_Unit()
	for i=1,#list do
		if UnitExists(list[i])
			and not UnitIsDeadOrGhost(list[i])
			and UnitIsVisible(list[i])
			and not PQR_IsOutOfSight(list[i])
			and not UnitIsCharmed(list[i])
		then
			return true, list[i], UnitHealth(list[i]) / UnitHealthMax(list[i]) * 100
		end
	end
	return false
end
		

--Thanks to Gabbz, just changed it to what I wanted and made a function for faster use and be able to last through switching profiles.
function MultiTarget()
	if modkeytime == nil then 
		modkeytime = 0 
	end
	if Selector == nil then
		Selector = 0
	end
	
	if IsRightAltKeyDown() and GetTime() - modkeytime > 0.3  then
		modkeytime = GetTime()
	  	if Selector == 0 then 
	    	Selector = 1 
	    	print("Rotation mode: \124cFFDBFA2AMulti-Target Rotation")
	    	PQR_SwapRotation("KittyAoE (Firekitteh)")
	  	elseif Selector == 1 then
	    	Selector = 0 
	    	print("Rotation mode: \124cFFFA652ASingle Target Rotation")
	    	PQR_SwapRotation("KittyCleave (Firekitteh)")
	  	end
	end
end

local snares = {
	snares = {
		122, --Frost Nova
		102051, --Frostjaw
		116, --Frostbolt Slow
		33395, --Water Elemental Freeze
		64685, --Earth totem
		63685 --Frost Shock Freeze
	},
	slows = {
		102355, --Faerie Swarm
		339, --Roots
		58180, --Infected Wounds
		12323, --Piercing Howl
		1715, --Hamstring
		5116, --Concussive Shot
		110300, --Judgement talent Debuff
		118223,  --Curse of Exhaustion
		120, --Cone of Cold
		31589, --Mage Slow
		8056, --Frost Shock
		116947, --Earthbind totem
		50435, --Chillbanes
		45524, --Chains of Ice
		3409 --Crippling Poison
	}
}

function HasSlow(var1)
	for i=1,#snares do
		local slow = UnitDebuffID(var1,snares.slows[i])
		
		if slow then
			return true
		end
	end
	return false
end

function HasSnare(var1)
	for i=1,#snares do
		local snare = UnitDebuffID(var,snares.snares[i])
		
		if snare then
			return true
		end
	end
	return false
end

local bgArea = {
	401, --Alteric Valley
	443, --Warsong Gulch
	461, --Arathi Basin
	482, --Eye of the Storm
	512, --Strand of the Ancients
	540, --Isle of Conquest
	626, --Twin Peaks
	708, --Tol Barad
	736 --The Battle for Guilneas
}

function PQR_Battleground()
	for i=1,#bgArea do
		local areaID = GetCurrentMapAreaID()
		
		if bgArea[i] == areaID then
			return true
		end
	end
	return false
end

local glyph = {
	1, --Minor Glyph (Top Right)
	2, --Major Glyph (Top)
	3, --Minor Glyph (Top Left)
	4, --Major Glyph (Bottom Left)
	5, --Minor Glyph (Bottom)
	6 --Major Glyph (Bottom Right)
}

function HasGlyph(var1)
	for i=1,#glyph do
		local GlyphSlot = select(4,GetGlyphSocketInfo(glyph[i]))
		
		if GlyphSlot == var1 then
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

--Sheuron's Healing Function's and main Function's turned into a function for easier use.
function SpecialAggro(t)
  local mob
  if GetLocale() == "deDE" then
mob = { "Trainingsattrappe", "Trainingsattrappe des Schlachtzuges", "Verzerrter Geist", "Brutwächter der Amani'shi", 
        "Hakkars Ketten", "Freigelegter Kopf von Magmaul", "Schlachtfeldverwüster", "Ozumat", 
        "Rechter Fuß", "Linker Fuß", "Eisiges Grab", "Auferstandener Ghul", "Manaleere", "Brennende Sehnen", 
        "Schwingententakel", "Armtentakel", "Zwielichtkampfdrache", "Goriona", "Eisgrab", 
        "Zwielichtpionier", "Schwächender Schreckenslord", "Blasiges Tentakel" } 
  elseif GetLocale() == "frFR" then
mob = { "Mannequin d'entraînement", "Mannequin d'entraînement d'écumeur de Raids", "Esprit tordu", "Perce-coque amani'shi", 
        "Chaînes d'Hakkar", "Tête exposée de Magmagueule", "Démolisseur de champ de bataille", "Ozumat", 
        "Pied droit", "Pied gauche", "Tombe glaciale", "Goule ressuscitée", "Vide de mana", "Tendons brûlants", 
        "Tentacule d’aile", "Tentacule de patte", "Drake d’assaut du Crépuscule", "Goriona", "Tombeau de glace", 
        "Sapeur du Crépuscule", "Seigneur de l’effroi débilitant", "Tentacule caustique" } 
  elseif GetLocale() == "esES" then
mob = { "Muñeco de entrenamiento", "Muñeco de entrenamiento de asaltante", "Espíritu alterado", "Criador Amani'shi", 
        "Cadenas de Hakkar", "Cabeza de Faucemagma expuesta", "Demoledor del campo de batalla", "Ozumat", 
        "Pie derecho", "Pie izquierdo", "Tumba helada", "Necrófago resucitado", "Vacío de maná", "Tendones ardientes", 
        "Tentáculo del ala", "Tentáculo", "Draco de asalto Crepuscular", "Goriona", "Tumba de hielo", 
        "Zapador Crepuscular", "Señor del Terror debilitador", "Tentáculo virulento" } 
  elseif GetLocale() == "ruRU" then
mob = { "Тренировочный манекен", "Тренировочный манекен рейдера", "Искаженный дух", "Смотритель кладки из племени Амани", 
        "Цепи Хаккара", "Голова Магмаря", "Боевой разрушитель", "Озумат", 
        "Правая нога", "Левая нога", "Ледяная гробница", "Восставший вурдалак", "Магическая воронка", "Горящие сухожилия", 
        "Крыло", "Громадное щупальце", "Сумеречный штурмовой дракон", "Гориона", "Ледяной склеп", 
        "Сумеречный сапер", "Повелитель ужаса - истощитель", "Раскаленное щупальце" } 
  else
mob = { "Training Dummy", "Raider's Training Dummy", "Twisted Spirit", "Amani´shi Hatcher", 
        "Hakkar's Chains", "Exposed Head of Magmaw", "Battleground Demolisher", "Ozumat", 
        "Right Foot", "Left Foot", "Icy Tomb", "Risen Ghoul", "Mana Void", "Burning Tendons", 
        "Wing Tentacle", "Arm Tentacle", "Twilight Assault Drake", "Goriona", "Ice Tomb", 
        "Twilight Sapper", "Dreadlord Debilitator", "Blistering Tentacle" } 
  end
  for i=1, #mob do if UnitName(t) == mob[i] then return true end end
end

function HoldCooldown(cd)
  local l = 5
  local Deathwing = { "Todesschwinge", "Aile de mort", "Alamuerte", "Смертокрыл", "Deathwing" } 
  local Tendons = { "Brennende Sehnen", "Tendons brûlants", "Tendones ardientes", "Горящие сухожилия", "Burning Tendons" }
  local Zon = { "Kriegsherr Zon'ozz", "Seigneur de guerre Zon’ozz", "Señor de la guerra Zon'ozz", "Полководец Зон'озз", "Warlord Zon'ozz" }
  local Alysrazor = { "Alysrazar", "Alysrazor", "Alysrazor", "Алисразор", "Alysrazor" }
  if GetLocale() == "deDE" then l = 1 elseif GetLocale() == "frFR" then l = 2 elseif GetLocale() == "esES" then l = 3 elseif GetLocale() == "ruRU" then l = 4 end
  if GetMinimapZoneText() == Deathwing[l] and UnitName("target") ~= Tendons[l] and cd >= 1 then return true end
  if UnitName("target") == Zon[l] and not UnitDebuffID("target",104031) and cd >= 3 then return true end
  if UnitName("boss1") == Alysrazor[l] and not UnitDebuffID("boss1",99432) and cd >= 3 then return true end
end

function HaveBuff(UnitID,SpellID,TimeLeft,Filter) 
  if not TimeLeft then TimeLeft = 0 end
  if type(SpellID) == "number" then SpellID = { SpellID } end 
  for i=1,#SpellID do 
local spell, rank = GetSpellInfo(SpellID[i])
if spell then
  local buff = select(7,UnitBuff(UnitID,spell,rank,Filter)) 
  if buff and ( buff == 0 or buff - GetTime() > TimeLeft ) then return true end
end
  end
end

function HaveDebuff(UnitID,SpellID,TimeLeft,Filter) 
  if not TimeLeft then TimeLeft = 0 end
  if type(SpellID) == "number" then SpellID = { SpellID } end 
  for i=1,#SpellID do 
local spell, rank = GetSpellInfo(SpellID[i])
if spell then
  local debuff = select(7,UnitDebuff(UnitID,spell,rank,Filter)) 
  if debuff and ( debuff == 0 or debuff - GetTime() > TimeLeft ) then return true end
end
  end
end

function ImmuneTarget(t) 
  local buff = { 642, 45438, 31224, 23920, 33786, 19263, 97417, 97977, 102915, 100686, 105784, 74938, 
  				 106062, 113309, 117665 } 
  for i=1, #buff do if UnitBuffID(t,buff[i]) then return true end end
end

function BadEffects(t)
  local buff  = { 96328, 96325, 96326, 86788, 30108, 101810 } 
  for i=1, #buff do if UnitDebuffID(t,buff[i]) then return true end end
end

function AboutToDie(t) 
  local pressure = 0
  for i=1,#members do
if UnitGroupRolesAssigned(members[i].Unit) ~= "HEALER" and UnitIsUnit(t,members[i].Unit..t) 
then pressure = pressure + 1 end
  end
  if UnitHealth(t) < UnitHealthMax("player")*pressure and UnitHealthMax(t) ~= 1 
  then return true end
end

function CalculateHP(t)
  incomingheals = UnitGetIncomingHeals(t) or 0
  return 100 * ( UnitHealth(t) + incomingheals ) / UnitHealthMax(t)
end

function CanHeal(t)
  if UnitInRange(t) and UnitCanCooperate("player",t) and not UnitIsEnemy("player",t) 
  and not UnitIsCharmed(t) and not UnitIsDeadOrGhost(t) and not PQR_IsOutOfSight(t) 
  then return true end 
end

function GroupInfo()
  members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } } 
  group.type = IsInRaid() and "raid" or "party" 
  group.number = GetNumGroupMembers()
  for i=1,group.number do if CanHeal(group.type..i) then 
local unit, hp = group.type..i, CalculateHP(group.type..i) 
table.insert( members,{ Unit = unit, HP = hp } ) 
if hp < 90 then group.low = group.low + 1 end 
if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end 
  end end 
  if group.type == "Raid" and #members > 1 then table.remove(members,1) end 
  table.sort(members, function(x,y) return x.HP < y.HP end)
  local customtarget = CanHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover" 
  if customtarget then table.sort(members, function(x) return UnitIsUnit(customtarget,x.Unit) end) end 
end

function ModSwitch(key,var,op1,op2)
  if key and not GetCurrentKeyBoardFocus() and ( not _G[var.."k"] or GetTime() - _G[var.."k"] > 0.3 ) then
_G[var.."k"] = GetTime()
if _G[var] then _G[var] = false xrn:message(op1) else _G[var] = true xrn:message(op2) end
  end
end

function AssistTank() 
  local tank = group.tanks[1] 
  if tank and group.type == "party" 
  and not UnitExists("target") 
  and UnitAffectingCombat(tank) 
  and UnitAffectingCombat(tank.."target") 
  and UnitCanAttack("player",tank.."target")
  then TargetUnit(tank.."target") end
end

function CastClick()
  if IsMouseButtonDown(1) and MainMenuBar:IsShown() then 
local mousefocus = GetMouseFocus() 
if mousefocus and mousefocus.feedback_action 
then SpellCancelQueuedSpell() PQR_DelayRotation(1) end
  end
end

local function onUpdate(self,elapsed) 
  if self.time < GetTime() - 3 then
if self:GetAlpha() == 0 then self:Hide() else self:SetAlpha(self:GetAlpha() - .05) end
  end
end

xrn = CreateFrame("Frame",nil,ChatFrame1) 
xrn:SetSize(ChatFrame1:GetWidth(),30)
xrn:Hide()
xrn:SetScript("OnUpdate",onUpdate)
xrn:SetPoint("TOP",0,0)
xrn.text = xrn:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
xrn.text:SetAllPoints()
xrn.texture = xrn:CreateTexture()
xrn.texture:SetAllPoints()
xrn.texture:SetTexture(0,0,0,.50) 
xrn.time = 0

function xrn:message(message) 
  self.text:SetText(message)
  self:SetAlpha(1)
  self.time = GetTime() 
  self:Show() 
end

--Pulled from HonorBuddy Boss List. Found the ID's for the newest Raid's and Heroics in DBM if they are the right ID's.
local boss = {
		--Ragefire Chasm
	    11517, --Oggleflint
	    11520, --Taragaman the Hungerer
	    11518, --Jergosh the Invoker
	    11519, --Bazzalan
	    17830, --Zelemar the Wrathful

        --The Deadmines
        644, --Rhahk'Zor
        3586, --Miner Johnson
        643, --Sneed
        642, --Sneed's Shredder
        1763, --Gilnid
        646, --Mr. Smite
        645, --Cookie
        647, --Captain Greenskin
        639, --Edwin VanCleef
        596, --Brainwashed Noble, outside
        626, --Foreman Thistlenettle, outside
        599, --Marisa du'Paige, outside
        47162, --Glubtok
        47296, --Helix Gearbreaker
        43778, --Foe Reaper 5000
        47626, --Admiral Ripsnarl
        47739, --"Captain" Cookie
        49541, --Vanessa VanCleef

        --Wailing Caverns
        5775, --Verdan the Everliving
        3670, --Lord Pythas
        3673, --Lord Serpentis
        3669, --Lord Cobrahn
        3654, --Mutanus the Devourer
        3674, --Skum
        3653, --Kresh
        3671, --Lady Anacondra
        5912, --Deviate Faerie Dragon
        3672, --Boahn, outside
        3655, --Mad Magglish, outside
        3652, --Trigore the Lasher, outside

        --Shadowfang Keep
        3914, --Rethilgore
        3886, --Razorclaw the Butcher
        4279, --Odo the Blindwatcher
        3887, --Baron Silverlaine
        4278, --Commander Springvale
        4274, --Fenrus the Devourer
        3927, --Wolf Master Nandos
        14682, --Sever (Scourge invasion only)
        4275, --Archmage Arugal
        3872, --Deathsworn Captain
        46962, --Baron Ashbury
        46963, --Lord Walden
        46964, --Lord Godfrey

        --Blackfathom Deeps
        4887, --Ghamoo-ra
        4831, --Lady Sarevess
        12902, --Lorgus Jett
        6243, --Gelihast
        12876, --Baron Aquanis
        4830, --Old Serra'kis
        4832, --Twilight Lord Kelris
        4829, --Aku'mai

        --Stormwind Stockade
        1716, --Bazil Thredd
        1663, --Dextren Ward
        1717, --Hamhock
        1666, --Kam Deepfury
        1696, --Targorr the Dread
        1720, --Bruegal Ironknuckle

        --Razorfen Kraul
        4421, --Charlga Razorflank
        4420, --Overlord Ramtusk
        4422, --Agathelos the Raging
        4428, --Death Speaker Jargba
        4424, --Aggem Thorncurse
        6168, --Roogug
        4425, --Blind Hunter
        4842, --Earthcaller Halmgar

        --Gnomeregan
        7800, --Mekgineer Thermaplugg
        7079, --Viscous Fallout
        7361, --Grubbis
        6235, --Electrocutioner 6000
        6229, --Crowd Pummeler 9-60
        6228, --Dark Iron Ambassador
        6231, --Techbot, outside

        --Scarlet Monastery: The Graveyard
        3983, --Interrogator Vishas
        6488, --Fallen Champion
        6490, --Azshir the Sleepless
        6489, --Ironspine
        14693, --Scorn
        4543, --Bloodmage Thalnos
        23682, --Headless Horseman
        23800, --Headless Horseman

        --Scarley Monastery: Library
        3974, --Houndmaster Loksey
        6487, --Arcanist Doan

        --Scarley Monastery: Armory
        3975, --Herod

        --Scarley Monastery: Cathedral
        4542, --High Inquisitor Fairbanks
        3976, --Scarlet Commander Mograine
        3977, --High Inquisitor Whitemane

        --Razorfen Downs
        7355, --Tuten'kash
        14686, --Lady Falther'ess
        7356, --Plaguemaw the Rotting
        7357, --Mordresh Fire Eye
        8567, --Glutton
        7354, --Ragglesnout
        7358, --Amnennar the Coldbringer

        --Uldaman
        7057, --Digmaster Shovelphlange
        6910, --Revelosh
        7228, --Ironaya
        7023, --Obsidian Sentinel
        7206, --Ancient Stone Keeper
        7291, --Galgann Firehammer
        4854, --Grimlok
        2748, --Archaedas
        6906, --Baelog

        --Zul'Farrak
        10082, --Zerillis
        10080, --Sandarr Dunereaver
        7272, --Theka the Martyr
        8127, --Antu'sul
        7271, --Witch Doctor Zum'rah
        7274, --Sandfury Executioner
        7275, --PriestShadow Sezz'ziz
        7796, --Nekrum Gutchewer
        7797, --Ruuzlu
        7267, --Chief Ukorz Sandscalp
        10081, --Dustwraith
        7795, --Hydromancer Velratha
        7273, --Gahz'rilla
        7608, --Murta Grimgut
        7606, --Oro Eyegouge
        7604, --Sergeant Bly

        --Maraudon
        --13718, --The Nameless Prophet (Pre-instance)
        13742, --Kolk <The First Khan>
        13741, --Gelk <The Second Khan>
        13740, --Magra <The Third Khan>
        13739, --Maraudos <The Fourth Khan>
        12236, --Lord Vyletongue
        13738, --Veng <The Fifth Khan>
        13282, --Noxxion
        12258, --Razorlash
        12237, --Meshlok the Harvester
        12225, --Celebras the Cursed
        12203, --Landslide
        13601, --Tinkerer Gizlock
        13596, --Rotgrip
        12201, --Princess Theradras

        --Temple of Atal'Hakkar
        1063, --Jade
        5400, --Zekkis
        5713, --Gasher
        5715, --Hukku
        5714, --Loro
        5717, --Mijan
        5712, --Zolo
        5716, --Zul'Lor
        5399, --Veyzhak the Cannibal
        5401, --Kazkaz the Unholy
        8580, --Atal'alarion
        8443, --Avatar of Hakkar
        5711, --Ogom the Wretched
        5710, --Jammal'an the Prophet
        5721, --Dreamscythe
        5720, --Weaver
        5719, --Morphaz
        5722, --Hazzas
        5709, --Shade of Eranikus

        --The Blackrock Depths: Detention Block
        9018, --High Interrogator Gerstahn

        --The Blackrock Depths: Halls of the Law
        9025, --Lord Roccor
        9319, --Houndmaster Grebmar

        --The Blackrock Depths: Ring of Law (Arena)
        9031, --Anub'shiah
        9029, --Eviscerator
        9027, --Gorosh the Dervish
        9028, --Grizzle
        9032, --Hedrum the Creeper
        9030, --Ok'thor the Breaker
        16059, --Theldren

        --The Blackrock Depths: Outer Blackrock Depths
        9024, --Pyromancer Loregrain
        9041, --Warder Stilgiss
        9042, --Verek
        9476, --Watchman Doomgrip
        9056, --Fineous Darkvire
        9017, --Lord Incendius
        9016, --Bael'Gar
        9033, --General Angerforge
        8983, --Golem Lord Argelmach

        --The Blackrock Depths: Grim Guzzler
        9543, --Ribbly Screwspigot
        9537, --Hurley Blackbreath
        9502, --Phalanx
        9499, --Plugger Spazzring
        23872, --Coren Direbrew

        --The Blackrock Depths: Inner Blackrock Depths
        9156, --Ambassador Flamelash
        8923, --Panzor the Invincible
        17808, --Anger'rel
        9039, --Doom'rel
        9040, --Dope'rel
        9037, --Gloom'rel
        9034, --Hate'rel
        9038, --Seeth'rel
        9036, --Vile'rel
        9938, --Magmus
        10076, --High Priestess of Thaurissan
        8929, --Princess Moira Bronzebeard
        9019, --Emperor Dagran Thaurissan

        --Dire Maul: Arena
        11447, --Mushgog
        11498, --Skarr the Unbreakable
        11497, --The Razza

        --Dire Maul: East
        14354, --Pusillin
        14327, --Lethtendris
        14349, --Pimgib
        13280, --Hydrospawn
        11490, --Zevrim Thornhoof
        11492, --Alzzin the Wildshaper
        16097, --Isalien

        --Dire Maul: North
        14326, --Guard Mol'dar
        14322, --Stomper Kreeg
        14321, --Guard Fengus
        14323, --Guard Slip'kik
        14325, --Captain Kromcrush
        14324, --Cho'Rush the Observer
        11501, --King Gordok

        --Dire Maul: West
        11489, --Tendris Warpwood
        11487, --Magister Kalendris
        11467, --Tsu'zee
        11488, --Illyanna Ravenoak
        14690, --Revanchion (Scourge Invasion)
        11496, --Immol'thar
        14506, --Lord Hel'nurath
        11486, --Prince Tortheldrin

        --Lower Blackrock Spire
        10263, --Burning Felguard
        9218, --Spirestone Battle Lord
        9219, --Spirestone Butcher
        9217, --Spirestone Lord Magus
        9196, --Highlord Omokk
        9236, --Shadow Hunter Vosh'gajin
        9237, --War Master Voone
        16080, --Mor Grayhoof
        9596, --Bannok Grimaxe
        10596, --Mother Smolderweb
        10376, --Crystal Fang
        10584, --Urok Doomhowl
        9736, --Quartermaster Zigris
        10220, --Halycon
        10268, --Gizrul the Slavener
        9718, --Ghok Bashguud
        9568, --Overlord Wyrmthalak

        --Stratholme: Scarlet Stratholme
        10393, --Skul
        14684, --Balzaphon (Scourge Invasion)
        --11082, --Stratholme Courier
        11058, --Fras Siabi
        10558, --Hearthsinger Forresten
        10516, --The Unforgiven
        16387, --Atiesh
        11143, --Postmaster Malown
        10808, --Timmy the Cruel
        11032, --Malor the Zealous
        11120, --Crimson Hammersmith
        10997, --Cannon Master Willey
        10811, --Archivist Galford
        10813, --Balnazzar
        16101, --Jarien
        16102, --Sothos

        --Stratholme: Undead Stratholme
        10809, --Stonespine
        10437, --Nerub'enkan
        10436, --Baroness Anastari
        11121, --Black Guard Swordsmith
        10438, --Maleki the Pallid
        10435, --Magistrate Barthilas
        10439, --Ramstein the Gorger
        10440, --Baron Rivendare (Stratholme)

        --Stratholme: Defenders of the Chapel
        17913, --Aelmar the Vanquisher
        17911, --Cathela the Seeker
        17910, --Gregor the Justiciar
        17914, --Vicar Hieronymus
        17912, --Nemas the Arbiter

        --Scholomance
        14861, --Blood Steward of Kirtonos
        10506, --Kirtonos the Herald
        14695, --Lord Blackwood (Scourge Invasion)
        10503, --Jandice Barov
        11622, --Rattlegore
        14516, --Death Knight Darkreaver
        10433, --Marduk Blackpool
        10432, --Vectus
        16118, --Kormok
        10508, --Ras Frostwhisper
        10505, --Instructor Malicia
        11261, --Doctor Theolen Krastinov
        10901, --Lorekeeper Polkelt
        10507, --The Ravenian
        10504, --Lord Alexei Barov
        10502, --Lady Illucia Barov
        1853, --Darkmaster Gandling

        --Upper Blackrock Spire
        9816, --Pyroguard Emberseer
        10264, --Solakar Flamewreath
        10509, --Jed Runewatcher
        10899, --Goraluk Anvilcrack
        10339, --Gyth
        10429, --Warchief Rend Blackhand
        10430, --The Beast
        16042, --Lord Valthalak
        10363, --General Drakkisath

        --Zul'Gurub
        14517, --High Priestess Jeklik
        14507, --High Priest Venoxis
        14510, --High Priestess Mar'li
        11382, --Bloodlord Mandokir
        15114, --Gahz'ranka
        14509, --High Priest Thekal
        14515, --High Priestess Arlokk
        11380, --Jin'do the Hexxer
        14834, --Hakkar
        15082, --Gri'lek
        15083, --Hazza'rah
        15084, --Renataki
        15085, --Wushoolay

        --Onyxia's Lair
        10184, --Onyxia

        --Molten Core
        12118, --Lucifron
        11982, --Magmadar
        12259, --Gehennas
        12057, --Garr
        12056, --Baron Geddon
        12264, --Shazzrah
        12098, --Sulfuron Harbinger
        11988, --Golemagg the Incinerator
        12018, --Majordomo Executus
        11502, --Ragnaros

        --Blackwing Lair
        12435, --Razorgore the Untamed
        13020, --Vaelastrasz the Corrupt
        12017, --Broodlord Lashlayer
        11983, --Firemaw
        14601, --Ebonroc
        11981, --Flamegor
        14020, --Chromaggus
        11583, --Nefarian
        12557, --Grethok the Controller
        10162, --Lord Victor Nefarius <Lord of Blackrock> (Also found in Blackrock Spire)

        --Ruins of Ahn'Qiraj
        15348, --Kurinnaxx
        15341, --General Rajaxx
        15340, --Moam
        15370, --Buru the Gorger
        15369, --Ayamiss the Hunter
        15339, --Ossirian the Unscarred

        --Temple of Ahn'Qiraj
        15263, --The Prophet Skeram
        15511, --Lord Kri
        15543, --Princess Yauj
        15544, --Vem
        15516, --Battleguard Sartura
        15510, --Fankriss the Unyielding
        15299, --Viscidus
        15509, --Princess Huhuran
        15276, --Emperor Vek'lor
        15275, --Emperor Vek'nilash
        15517, --Ouro
        15727, --C'Thun
        15589, --Eye of C'Thun

        --Naxxramas
        30549, --Baron Rivendare (Naxxramas)
        16803, --Death Knight Understudy
        15930, --Feugen
        15929, --Stalagg

        --Naxxramas: Spider Wing
        15956, --Anub'Rekhan
        15953, --Grand Widow Faerlina
        15952, --Maexxna

        --Naxxramas: Abomination Wing
        16028, --Patchwerk
        15931, --Grobbulus
        15932, --Gluth
        15928, --Thaddius

        --Naxxramas: Plague Wing
        15954, --Noth the Plaguebringer
        15936, --Heigan the Unclean
        16011, --Loatheb

        --Naxxramas: Deathknight Wing
        16061, --Instructor Razuvious
        16060, --Gothik the Harvester

        --Naxxramas: The Four Horsemen
        16065, --Lady Blaumeux
        16064, --Thane Korth'azz
        16062, --Highlord Mograine
        16063, --Sir Zeliek

        --Naxxramas: Frostwyrm Lair
        15989, --Sapphiron
        15990, --Kel'Thuzad
        25465, --Kel'Thuzad


        --Hellfire Citadel: Hellfire Ramparts
        17306, --Watchkeeper Gargolmar
        17308, --Omor the Unscarred
        17537, --Vazruden
        17307, --Vazruden the Herald
        17536, --Nazan

        --Hellfire Citadel: The Blood Furnace
        17381, --The Maker
        17380, --Broggok
        17377, --Keli'dan the Breaker

        --Coilfang Reservoir: Slave Pens
        25740, --Ahune
        17941, --Mennu the Betrayer
        17991, --Rokmar the Crackler
        17942, --Quagmirran

        --Coilfang Reservoir: The Underbog
        17770, --Hungarfen
        18105, --Ghaz'an
        17826, --Swamplord Musel'ek
        17827, --Claw <Swamplord Musel'ek's Pet>
        17882, --The Black Stalker

        --Auchindoun: Mana-Tombs
        18341, --Pandemonius
        18343, --Tavarok
        22930, --Yor (Heroic)
        18344, --Nexus-Prince Shaffar

        --Auchindoun: Auchenai Crypts
        18371, --Shirrak the Dead Watcher
        18373, --Exarch Maladaar

        --Caverns of Time: Escape from Durnholde Keep
        17848, --Lieutenant Drake
        17862, --Captain Skarloc
        18096, --Epoch Hunter
        28132, --Don Carlos

        --Auchindoun: Sethekk Halls
        18472, --Darkweaver Syth
        23035, --Anzu (Heroic)
        18473, --Talon King Ikiss

        --Coilfang Reservoir: The Steamvault
        17797, --Hydromancer Thespia
        17796, --Mekgineer Steamrigger
        17798, --Warlord Kalithresh

        --Auchindoun: Shadow Labyrinth
        18731, --Ambassador Hellmaw
        18667, --Blackheart the Inciter
        18732, --Grandmaster Vorpil
        18708, --Murmur

        --Hellfire Citadel: Shattered Halls
        16807, --Grand Warlock Nethekurse
        20923, --Blood Guard Porung (Heroic)
        16809, --Warbringer O'mrogg
        16808, --Warchief Kargath Bladefist

        --Caverns of Time: Opening the Dark Portal
        17879, --Chrono Lord Deja
        17880, --Temporus
        17881, --Aeonus

        --Tempest Keep: The Mechanar
        19218, --Gatewatcher Gyro-Kill
        19710, --Gatewatcher Iron-Hand
        19219, --Mechano-Lord Capacitus
        19221, --Nethermancer Sepethrea
        19220, --Pathaleon the Calculator

        --Tempest Keep: The Botanica
        17976, --Commander Sarannis
        17975, --High Botanist Freywinn
        17978, --Thorngrin the Tender
        17980, --Laj
        17977, --Warp Splinter

        --Tempest Keep: The Arcatraz
        20870, --Zereketh the Unbound
        20886, --Wrath-Scryer Soccothrates
        20885, --Dalliah the Doomsayer
        20912, --Harbinger Skyriss
        20904, --Warden Mellichar

        --Magisters' Terrace
        24723, --Selin Fireheart
        24744, --Vexallus
        24560, --Priestess Delrissa
        24664, --Kael'thas Sunstrider

        --Karazhan
        15550, --Attumen the Huntsman
        16151, --Midnight
        28194, --Tenris Mirkblood (Scourge invasion)
        15687, --Moroes
        16457, --Maiden of Virtue
        15691, --The Curator
        15688, --Terestian Illhoof
        16524, --Shade of Aran
        15689, --Netherspite
        15690, --Prince Malchezaar
        17225, --Nightbane
        17229, --Kil'rek
        --Chess event

        --Karazhan: Servants' Quarters Beasts
        16179, --Hyakiss the Lurker
        16181, --Rokad the Ravager
        16180, --Shadikith the Glider

        --Karazhan: Opera Event
        17535, --Dorothee
        17546, --Roar
        17543, --Strawman
        17547, --Tinhead
        17548, --Tito
        18168, --The Crone
        17521, --The Big Bad Wolf
        17533, --Romulo
        17534, --Julianne

        --Gruul's Lair
        18831, --High King Maulgar
        19044, --Gruul the Dragonkiller

        --Gruul's Lair: Maulgar's Ogre Council
        18835, --Kiggler the Crazed
        18836, --Blindeye the Seer
        18834, --Olm the Summoner
        18832, --Krosh Firehand

        --Hellfire Citadel: Magtheridon's Lair
        17257, --Magtheridon

        --Zul'Aman: Animal Bosses
        29024, --Nalorakk
        28514, --Nalorakk
        23576, --Nalorakk
        23574, --Akil'zon
        23578, --Jan'alai
        28515, --Jan'alai
        29023, --Jan'alai
        23577, --Halazzi
        28517, --Halazzi
        29022, --Halazzi
        24239, --Malacrass

        --Zul'Aman: Final Bosses
        24239, --Hex Lord Malacrass
        23863, --Zul'jin

        --Coilfang Reservoir: Serpentshrine Cavern
        21216, --Hydross the Unstable
        21217, --The Lurker Below
        21215, --Leotheras the Blind
        21214, --Fathom-Lord Karathress
        21213, --Morogrim Tidewalker
        21212, --Lady Vashj
        21875, --Shadow of Leotheras

        --Tempest Keep: The Eye
        19514, --Al'ar
        19516, --Void Reaver
        18805, --High Astromancer Solarian
        19622, --Kael'thas Sunstrider
        20064, --Thaladred the Darkener
        20060, --Lord Sanguinar
        20062, --Grand Astromancer Capernian
        20063, --Master Engineer Telonicus
        21270, --Cosmic Infuser
        21269, --Devastation
        21271, --Infinity Blades
        21268, --Netherstrand Longbow
        21273, --Phaseshift Bulwark
        21274, --Staff of Disintegration
        21272, --Warp Slicer

        --Caverns of Time: Battle for Mount Hyjal
        17767, --Rage Winterchill
        17808, --Anetheron
        17888, --Kaz'rogal
        17842, --Azgalor
        17968, --Archimonde

        --Black Temple
        22887, --High Warlord Naj'entus
        22898, --Supremus
        22841, --Shade of Akama
        22871, --Teron Gorefiend
        22948, --Gurtogg Bloodboil
        23420, --Essence of Anger
        23419, --Essence of Desire
        23418, --Essence of Suffering
        22947, --Mother Shahraz
        23426, --Illidari Council
        22917, --Illidan Stormrage -- Not adding solo quest IDs for now
        22949, --Gathios the Shatterer
        22950, --High Nethermancer Zerevor
        22951, --Lady Malande
        22952, --Veras Darkshadow

        --Sunwell Plateau
        24891, --Kalecgos
        25319, --Kalecgos
        24850, --Kalecgos
        24882, --Brutallus
        25038, --Felmyst
        25165, --Lady Sacrolash
        25166, --Grand Warlock Alythess
        25741, --M'uru
        25315, --Kil'jaeden
        25840, --Entropius
        24892, --Sathrovarr the Corruptor


        --Utgarde Keep: Main Bosses
        23953, --Prince Keleseth (Utgarde Keep)
        27390, --Skarvald the Constructor
        24200, --Skarvald the Constructor
        23954, --Ingvar the Plunderer
        23980, --Ingvar the Plunderer

        --Utgarde Keep: Secondary Bosses
        27389, --Dalronn the Controller
        24201, --Dalronn the Controller

        --The Nexus
        26798, --Commander Kolurg (Heroic)
        26796, --Commander Stoutbeard (Heroic)
        26731, --Grand Magus Telestra
        26832, --Grand Magus Telestra
        26928, --Grand Magus Telestra
        26929, --Grand Magus Telestra
        26930, --Grand Magus Telestra
        26763, --Anomalus
        26794, --Ormorok the Tree-Shaper
        26723, --Keristrasza

        --Azjol-Nerub
        28684, --Krik'thir the Gatewatcher
        28921, --Hadronox
        29120, --Anub'arak

        --Ahn'kahet: The Old Kingdom
        29309, --Elder Nadox
        29308, --Prince Taldaram (Ahn'kahet: The Old Kingdom)
        29310, --Jedoga Shadowseeker
        29311, --Herald Volazj
        30258, --Amanitar (Heroic)

        --Drak'Tharon Keep
        26630, --Trollgore
        26631, --Novos the Summoner
        27483, --King Dred
        26632, --The Prophet Tharon'ja
        27696, --The Prophet Tharon'ja

        --The Violet Hold
        29315, --Erekem
        29313, --Ichoron
        29312, --Lavanthor
        29316, --Moragg
        29266, --Xevozz
        29314, --Zuramat the Obliterator
        31134, --Cyanigosa

        --Gundrak
        29304, --Slad'ran
        29305, --Moorabi
        29307, --Drakkari Colossus
        29306, --Gal'darah
        29932, --Eck the Ferocious (Heroic)

        --Halls of Stone
        27977, --Krystallus
        27975, --Maiden of Grief
        28234, --The Tribunal of Ages
        27978, --Sjonnir The Ironshaper

        --Halls of Lightning
        28586, --General Bjarngrim
        28587, --Volkhan
        28546, --Ionar
        28923, --Loken

        --The Oculus
        27654, --Drakos the Interrogator
        27447, --Varos Cloudstrider
        27655, --Mage-Lord Urom
        27656, --Ley-Guardian Eregos

        --Caverns of Time: Culling of Stratholme
        26529, --Meathook
        26530, --Salramm the Fleshcrafter
        26532, --Chrono-Lord Epoch
        32273, --Infinite Corruptor
        26533, --Mal'Ganis
        29620, --Mal'Ganis

        --Utgarde Pinnacle
        26668, --Svala Sorrowgrave
        26687, --Gortok Palehoof
        26693, --Skadi the Ruthless
        26861, --King Ymiron

        --Trial of the Champion: Alliance
        35617, --Deathstalker Visceri <Grand Champion of Undercity>
        35569, --Eressea Dawnsinger <Grand Champion of Silvermoon>
        35572, --Mokra the Skullcrusher <Grand Champion of Orgrimmar>
        35571, --Runok Wildmane <Grand Champion of the Thunder Bluff>
        35570, --Zul'tore <Grand Champion of Sen'jin>

        --Trial of the Champion: Horde
        34702, --Ambrose Boltspark <Grand Champion of Gnomeregan>
        34701, --Colosos <Grand Champion of the Exodar>
        34705, --Marshal Jacob Alerius <Grand Champion of Stormwind>
        34657, --Jaelyne Evensong <Grand Champion of Darnassus>
        34703, --Lana Stouthammer <Grand Champion of Ironforge>

        --Trial of the Champion: Neutral
        34928, --Argent Confessor Paletress
        35119, --Eadric the Pure
        35451, --The Black Knight

        --Forge of Souls
        36497, --Bronjahm
        36502, --Devourer of Souls

        --Pit of Saron
        36494, --Forgemaster Garfrost
        36477, --Krick
        36476, --Ick <Krick's Minion>
        36658, --Scourgelord Tyrannus

        --Halls of Reflection
        38112, --Falric
        38113, --Marwyn
        37226, --The Lich King
        38113, --Marvyn

        --Obsidian Sanctum
        30451, --Shadron
        30452, --Tenebron
        30449, --Vesperon
        28860, --Sartharion

        --Vault of Archavon
        31125, --Archavon the Stone Watcher
        33993, --Emalon the Storm Watcher
        35013, --Koralon the Flamewatcher
        38433, --Toravon the Ice Watcher

        --The Eye of Eternity
        28859, --Malygos

        --Ulduar: The Siege of Ulduar
        33113, --Flame Leviathan
        33118, --Ignis the Furnace Master
        33186, --Razorscale
        33293, --XT-002 Deconstructor
        33670, --Aerial Command Unit
        33329, --Heart of the Deconstructor
        33651, --VX-001

        --Ulduar: The Antechamber of Ulduar
        32867, --Steelbreaker
        32927, --Runemaster Molgeim
        32857, --Stormcaller Brundir
        32930, --Kologarn
        33515, --Auriaya
        34035, --Feral Defender
        32933, --Left Arm
        32934, --Right Arm
        33524, --Saronite Animus

        --Ulduar: The Keepers of Ulduar
        33350, --Mimiron
        32906, --Freya
        32865, --Thorim
        32845, --Hodir

        --Ulduar: The Descent into Madness
        33271, --General Vezax
        33890, --Brain of Yogg-Saron
        33136, --Guardian of Yogg-Saron
        33288, --Yogg-Saron
        32915, --Elder Brightleaf
        32913, --Elder Ironbranch
        32914, --Elder Stonebark
        32882, --Jormungar Behemoth
        33432, --Leviathan Mk II
        34014, --Sanctum Sentry

        --Ulduar: The Celestial Planetarium
        32871, --Algalon the Observer

        --Trial of the Crusader
        34796, --Gormok
        35144, --Acidmaw
        34799, --Dreadscale
        34797, --Icehowl

        34780, --Jaraxxus

        34461, --Tyrius Duskblade <Death Knight>
        34460, --Kavina Grovesong <Druid>
        34469, --Melador Valestrider <Druid>
        34467, --Alyssia Moonstalker <Hunter>
        34468, --Noozle Whizzlestick <Mage>
        34465, --Velanaa <Paladin>
        34471, --Baelnor Lightbearer <Paladin>
        34466, --Anthar Forgemender <Priest>
        34473, --Brienna Nightfell <Priest>
        34472, --Irieth Shadowstep <Rogue>
        34470, --Saamul <Shaman>
        34463, --Shaabad <Shaman>
        34474, --Serissa Grimdabbler <Warlock>
        34475, --Shocuul <Warrior>

        34458, --Gorgrim Shadowcleave <Death Knight>
        34451, --Birana Stormhoof <Druid>
        34459, --Erin Misthoof <Druid>
        34448, --Ruj'kah <Hunter>
        34449, --Ginselle Blightslinger <Mage>
        34445, --Liandra Suncaller <Paladin>
        34456, --Malithas Brightblade <Paladin>
        34447, --Caiphus the Stern <Priest>
        34441, --Vivienne Blackwhisper <Priest>
        34454, --Maz'dinah <Rogue>
        34444, --Thrakgar	<Shaman>
        34455, --Broln Stouthorn <Shaman>
        34450, --Harkzog <Warlock>
        34453, --Narrhok Steelbreaker <Warrior>

        35610, --Cat <Ruj'kah's Pet / Alyssia Moonstalker's Pet>
        35465, --Zhaagrym <Harkzog's Minion / Serissa Grimdabbler's Minion>

        34497, --Fjola Lightbane
        34496, --Eydis Darkbane
        34564, --Anub'arak (Trial of the Crusader)

        --Icecrown Citadel
        36612, --Lord Marrowgar
        36855, --Lady Deathwhisper

        --Gunship Battle
        37813, --Deathbringer Saurfang
        36626, --Festergut
        36627, --Rotface
        36678, --Professor Putricide
        37972, --Prince Keleseth (Icecrown Citadel)
        37970, --Prince Valanar
        37973, --Prince Taldaram (Icecrown Citadel)
        37955, --Queen Lana'thel
        36789, --Valithria Dreamwalker
        37950, --Valithria Dreamwalker (Phased)
        37868, --Risen Archmage, Valitrhia Add
        36791, --Blazing Skeleton, Valithria Add
        37934, --Blistering Zombie, Valithria Add
        37886, --Gluttonous Abomination, Valithria Add
        37985, --Dream Cloud , Valithria "Add" 
        36853, --Sindragosa
        36597, --The Lich King (Icecrown Citadel)
        37217, --Precious
        37025, --Stinki
        36661, --Rimefang <Drake of Tyrannus>

        --Ruby Sanctum (PTR 3.3.5)
        39746, --Zarithrian
        39747, --Saviana
        39751, --Baltharus
        39863, --Halion
        39899, --Baltharus (Copy has an own id apparently)
        40142, --Halion (twilight realm)

        --Blackrock Mountain: Blackrock Caverns
        39665, --Rom'ogg Bonecrusher
        39679, --Corla, Herald of Twilight
        39698, --Karsh Steelbender
        39700, --Beauty
        39705, --Ascendant Lord Obsidius

        --Abyssal Maw: Throne of the Tides
        40586, --Lady Naz'jar
        40765, --Commander Ulthok
        40825, --Erunak Stonespeaker
        40788, --Mindbender Ghur'sha
        42172, --Ozumat

        --The Stonecore
        43438, --Corborus
        43214, --Slabhide
        42188, --Ozruk
        42333, --High Priestess Azil

        --The Vortex Pinnacle
        43878, --Grand Vizier Ertan
        43873, --Altairus
        43875, --Asaad

        --Grim Batol
        39625, --General Umbriss
        40177, --Forgemaster Throngus
        40319, --Drahga Shadowburner
        40484, --Erudax

        --Halls of Origination
        39425, --Temple Guardian Anhuur
        39428, --Earthrager Ptah
        39788, --Anraphet
        39587, --Isiset
        39731, --Ammunae
        39732, --Setesh
        39378, --Rajh

        --Lost City of the Tolvir
        44577, --General Husam
        43612, --High Prophet Barim
        43614, --Lockmaw
        49045, --Augh
        44819, --Siamat

        --Baradin Hold
        47120, --Argaloth
        52363, -- Occu'thar

        --Blackrock Mountain: Blackwing Descent
        41570, --Magmaw
        42180, --Toxitron
        41378, --Maloriak
        41442, --Atramedes
        43296, --Chimaeron
        41376, --Nefarian

        --Throne of the Four Winds
        45871, --Nezir
        46753, --Al'Akir

        --The Bastion of Twilight
        45992, --Valiona
        45993, --Theralion
        44600, --Halfus Wyrmbreaker
        43735, --Elementium Monstrosity
        43324, --Cho'gall
        45213, --Sinestra (heroic)

        --World Dragons
        14889, --Emeriss
        14888, --Lethon
        14890, --Taerar
        14887, --Ysondre

        --Azshara
        14464, --Avalanchion
        6109, --Azuregos

        --Un'Goro Crater
        14461, --Baron Charr

        --Silithus
        15205, --Baron Kazum <Abyssal High Council>
        15204, --High Marshal Whirlaxis <Abyssal High Council>
        15305, --Lord Skwol <Abyssal High Council>
        15203, --Prince Skaldrenox <Abyssal High Council>
        14454, --The Windreaver

        --Searing Gorge
        9026, --Overmaster Pyron

        --Winterspring
        14457, --Princess Tempestria

        --Hellfire Peninsula
        18728, --Doom Lord Kazzak
        12397, --Lord Kazzak

        --Shadowmoon Valley
        17711, --Doomwalker

        --Nagrand
        18398, --Brokentoe
        18069, --Mogor <Hero of the Warmaul>, friendly
        18399, --Murkblood Twin
        18400, --Rokdar the Sundered Lord
        18401, --Skra'gath
        18402, --Warmaul Champion

        -- Cata Zul'gurub
        52155, --High Priest Venoxis
        52151, --Bloodlord Mandokir
        52271, --Hazza'ra
        52059, --High Priestess Kilnara
        52053, --Zanzil
        52148, --Jin'do the Godbreaker

        -- Well of Eternity
        55085,  -- Peroth'arn
        54853,  -- Queen Azshara
        54969,  -- Mannoroth <The Destructor>
        55419,  -- Captain Varo'then <The Hand of Azshara>

        -- Hour of Twilight
        54590,  -- Arcurion
        54968,  -- Asira Dawnslayer
        54938,  -- Archbishop Benedictus

        -- End Time
        54431,  --  Echo of Baine
        54445,  --  Echo of Jaina
        54123,  --  Echo of Sylvanas
        54544,  --  Echo of Tyrande
        54432,  --  Murozond <The Lord of the Infinite>

        --Firelands
        53691, --Shannox
        52558, --Lord Rhyolith
        52498, --Beth'tilac
        52530, --Alysrazor
        53494, --Baleroc
        52571, --Majordomo Staghelm
        52409, --Ragnaros

        --Dragon Soul
        55265, -- Morchok
        57773, -- Kohcrom (Heroic Morchok encounter)
        55308, -- Zon'ozz
        55312, -- Yor'sahj
        55689, -- Hagara
        55294, -- Ultraxion
        56427, -- Blackhorn

        56846, -- Arm Tentacle -- Madness of DW
        56167, -- Arm Tentacle -- Madness of DW
        56168, -- Wing Tentacle - Madness of DW
        57962, -- Deathwing ----- Madness of DW (his head)

        -- === Pandaria 5-man Dungeons
        -- Gate of the Setting Sun	      
        -- Mogu'shan Palace	          
        -- Scarlet Halls	              
        -- Scarlet Monastery	          
        -- Scholomance	                  
        -- Shado-Pan Monastery	          
        -- Siege of Niuzao Temple	      
        -- SM Cathedral/GY               
        -- Stormstout Brewery	          
        -- Temple of the Jade Serpent

        -- === Pandaria Raids
        -- Heart of Fear
        63191, --Garalon
        62397, --Meljarak
        62837, --Shekzeer
        62543, --Tayak
        62511, --Unsok
        62980, --62980         
        -- Mogu'shan Vaults	
        60410, --Elegon
        60009, --Feng  
        60051, --Stone Guard #1
        60043, --Stone Guard #2
        59915, --Stone Guard #3
        60047, --Stone Guard #4
        60701, --Spirit King's #1
        60708, --Spirit King's #2
        60709, --Spirit King's #3
        60710, --Spirit King's #4
        60143, --Garajal
        60399, --Will of Emperor #1
        60400, --Will of Emperor #2
        -- Terrace of Endless Spring
        62983, --LeiShi
        60583, --(Protector) Kaolan
        60585, --(Protector) Elder Regail
        60586 --(Protector) Elder Asani
}

function PQR_FireBoss(unit)
	for i=1,#boss do
		if HasTarget() then
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
--Credit to Deadpan for the ground work, me for perfecting it.
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
--idp = How much places to round to. Negative number not recommended.
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--Var1 = Target
--Var2 = Player
--Var3 = Round Number. Leave blank for 0
function PQR_UnitFlying(var1, var2, var3)
	local targetHeight = select(3, PQR_UnitInfo(var1))
	local playerHeight = select(3, PQR_UnitInfo(var2))
	local height = round(targetHeight - playerHeight,var3)
	
	if UnitExists(var1) and not UnitIsDead(var1) and height ~= nil then
		return height
	end
end

--Var1 = Target
--Var2 = Player
function PQR_UnitDistance(var1, var2)
	if HasTarget() then
		local a,b,c,d,e,f,g,h,i,j = GetAreaMapInfo(GetCurrentMapAreaID())
		local x1 , y1 = PQR_UnitInfo(var1)
		local x2 , y2 = PQR_UnitInfo(var2)
		local w = (d - e)
		local h = (f - g)
		local distance = sqrt(min(x1 - x2, w - (x1 - x2))^2 + min(y1 - y2, h - (y1-y2))^2)
		
		return distance
	end
end

function HasTarget()
	if UnitExists("Target") then
		return true
	end
	return false
end

function PQR_UnitClass(var1)
	local Class = select(3,UnitClass(var1))

	if Class == 6 then
		function RunesAvailable()
			local blood1 = GetRuneCount(1)
			local blood2 = GetRuneCount(2)
			local unholy1 = GetRuneCount(3)
			local unholy2 = GetRuneCount(4)
			local frost1 = GetRuneCount(5)
			local frost2 = GetRuneCount(6)
			
			return blood1+blood2+unholy1+unholy2+frost1+frost2,blood1+blood2,frost1+frost2,unholy1+unholy2
		end
		
		function RuneCooldown()
			local blood1,a = GetRuneCooldown(1)
			local blood2,a = GetRuneCooldown(2)
			local unholy1,a = GetRuneCooldown(3)
			local unholy2,a = GetRuneCooldown(4)
			local frost1,a = GetRuneCooldown(5)
			local frost2,a = GetRuneCooldown(6)
			
			return blood1+a-GetTime(),blood2+a-GetTime(),frost1+a-GetTime(),frost2+a-GetTime(),unholy1+a-GetTime(),unholy2+a-GetTime()
		end
		
		function RuneType()
			local numBlood = 0
			local numFrost = 0
			local numUnholy = 0
			local numDeath = 0
			
			for i=1,6 do
				local type = GetRuneType(i)
				
				if type == 1 then
					numBlood = numBlood + 1
				end
			end
			for i=1,6 do
				local type = GetRuneType(i)
				
				if type == 2 then
					numUnholy = numUnholy + 1
				end
			end
			for i=1,6 do
				local type = GetRuneType(i)
				
				if type == 3 then
					numFrost = numFrost + 1
				end
			end
			for i=1,6 do
				local type = GetRuneType(i)
				
				if type == 4 then
					numDeath = numDeath + 1
				end
			end
				
			
			return numBlood,numFrost,numUnholy,numDeath
		end
		
		function CastERW()
			local RunesAvailable = RunesAvailable()
			local rPower = UnitPower("Player")
			local erwKnown = IsSpellKnown(47568)
			
			if erwKnown and RunesAvailable == 0 and rPower < 35 then
				CastSpellByName(tostring(GetSpellInfo(47568)))
			end
		end
		
		function CastDiseases()
			--Known Spells
			local rbKnown = IsSpellKnown(108170)
			local plKnown = IsSpellKnown(123693)
			local ubKnown = IsSpellKnown(115989)
			local obKnown = IsSpellKnown(77575)
			--	Buffs/Debuffs/Cooldowns
			local ffDebuff = UnitDebuffID("Target",55095,"Player")
			local bpDebuff = UnitDebuffID("Target",55078,"Player")
			local ubBuff = UnitBuffID("Player",115989)
			local bossHP = 100 * UnitHealth("Target") / UnitHealthMax("Target")
			local UBstart, UBduration = GetSpellCooldown(115989)
			local UBcooldown = (UBstart + UBduration - GetTime())
			local OBstart, OBduration = GetSpellCooldown(77575)
			local OBcooldown = (OBstart + OBduration - GetTime())
				
			if ubKnown or obKnown then
				if UBcooldown < 1 and not (ffDebuff and bpDebuff) and not ubBuff then
					CastSpellByName(tostring(GetSpellInfo(115989)))
				elseif not ubBuff and UBcooldown > 1 and not (ffDebuff and bpDebuff) then
					CastSpellByName(tostring(GetSpellInfo(77575)))
				end
				
				if (UBcooldown > 3 or not ubKnown) and (OBcooldown > 3 or not obKnown) and not ubBuff then
					if not ffDebuff then
						CastSpellByName(tostring(GetSpellInfo(45477)))
					end
					if not bpDebuff then
						CastSpellByName(tostring(GetSpellInfo(45462)))
					end
				end
		--	elseif obKnown and not ubBuff then
		--		if not (ffDebuff or bpDebuff) then
		--			CastSpellByName(tostring(GetSpellInfo(77575)))
		--		end
				
		--		if (UBcooldown > 3 or not ubKnown) and (OBcooldown > 3 or not obKnown) then
		--			if not ffDebuff then
		--				CastSpellByName(tostring(GetSpellInfo(45477)))
		--			end
		--			if not bpDebuff then
		--				CastSpellByName(tostring(GetSpellInfo(45462)))
		--			end
		--		end
			end
		end
		
		function Presences()
			local form = GetShapeshiftForm()
			local unholyKnown = IsSpellKnown(48265)
			local frostKnown = IsSpellKnown(48266)
			
			if unholyKnown and form ~= 3 then
				CastShapeshiftForm(3)
			elseif frostKnown and not unholyKnown and form ~= 2 then
				CastShapeshiftForm(2)
			end
		end
		
		function Pet()
			local hasPet = HasPetSpells()
			local rdCD = GetSpellCooldown(46584)
			
			if not hasPet and rdCD == 0 then
				CastSpellByName(GetSpellInfo(46584))
			end
		end
		
		function CastDCoil()
			local coilBuff = UnitBuffID("Player",81340)
			local rPower = UnitPower("Player")
			local petHP = 100 * UnitHealth("Pet") / UnitHealthMax("Pet")
			local dtTimer = select(7,UnitBuffID("Pet",63560))
			
			if (rPower > 32 and RunesAvailable() == 0) or (RunesAvailable() == 0 and coilBuff) then
				CastSpellByName(tostring(GetSpellInfo(47541)),"Target")
			elseif rPower > 65 or coilBuff then
				if dtTimer and dtTimer - GetTime() < 5 then
					return false
				elseif petHP > 35 then
					CastSpellByName(tostring(GetSpellInfo(47541)),"Target")
				elseif petHP < 35 then
					CastSpellByName(tostring(GetSpellInfo(47541)),"Pet")
				end
			end
		end
		
		function CastDarkT()
			local siStacks = select(4,UnitBuffID("Player",49572))
			local dtBuff = UnitBuffID("Pet",63560)
			
			if siStacks == 5 and not dtBuff then
				CastSpellByName(tostring(GetSpellInfo(63560)))
			end
		end
		
		function CastForS()
			local ffDebuff = select(7,UnitDebuffID("Target",55095,"Player"))
			local bpDebuff = select(7,UnitDebuffID("Target",55078,"Player"))
			
			if ((ffDebuff and ffDebuff - GetTime() < 6) or (bpDebuff and bpDebuff - GetTime() < 6)) then
				return GetSpellInfo(85948)
			elseif select(4,RunesAvailable()) > 0 then
				return GetSpellInfo(55090)
			elseif (select(2,RunesAvailable()) and select(3,RunesAvailable())) > 0 and (select(1,RuneType()) and select(2,RuneType())) > 0 and select(4,RuneType()) < 3 then
				return GetSpellInfo(85948)
			elseif select(4,RuneType()) > 0 and select(3,RuneType()) == 2 then
				return GetSpellInfo(55090)
			elseif select(4,RuneType()) == 3 and select(3,RuneType()) == 2 and (select(1,RuneCooldown()) > 0 or select(2,RuneCooldown()) > 0 or select(3,RuneCooldown()) > 0 or select(4,RuneCooldown()) > 0) then
				return GetSpellInfo(55090)
			elseif select(4,RunesAvailable()) > 0 then
				return GetSpellInfo(55090)
			elseif select(4,RuneType()) < 4 then
				return GetSpellInfo(85948)
			else
				return GetSpellInfo(55090)
			end
		end
		
		function CastFestOrScoourge()
			if CastForS() == GetSpellInfo(55090) then
				CastSpellByName(tostring(GetSpellInfo(55090)))
			elseif CastForS() == GetSpellInfo(85948) then
				CastSpellByName(tostring(GetSpellInfo(85948)))
			end
		end
	elseif Class == 11 then
		--var1 = Target
		--var2 = Player
		function HasThrash(var1,var2)
			local CCasting = UnitBuffID(var2,16870)
			local tBuff = UnitDebuffID(var1, 106830,var2)
			
			if CCasting and not tBuff then
				return true
			elseif CCasting and tBuff then
				local tTimer = select(7,UnitDebuffID(var1, 106830,var2))
				local Timer = (tTimer - GetTime())
				
				if tTimer - GetTime() < 3 then
					return true,Timer
				end
			elseif not CCasting and tBuff then
				local tTimer = select(7,UnitDebuffID(var1, 106830,var2))
				local Timer = (tTimer - GetTime())
				
				return false,Timer
			end
			return false
		end
		
		--var1 = Player
		--var2 = Focus
		--var3 = FocusTarget
		function PQR_FireMangle(var1,var2,var3,var4)
			if UnitExists(var2) then
		--		local facing1 = PQR_UnitFacing(var2,var1)
				local facing2 = PQR_UnitFacing(var2,var3)
				local facing3 = PQR_UnitFacing(var3,var1)
				
				if facing2 == true and facing3 == true then
					return true
				end
				return false
			end
		end
		
		function CanRip(var1)
			local tfStart, tfDuration = GetSpellCooldown(5217)
			local tfCD = tfStart + tfDuration - GetTime()
			local tfBuff = UnitBuffID("Player",5217)
			
			if tfCD < 3 and not tfBuff then
				return false
			elseif tfCD >= 24 and tfBuff then
				return true
			elseif tfCD > 3 and tfCD < 24 then
				return true
			end
			return false
		end
			
		
		local sr = {
			127538,
			52610
		}
		
		--var1 = Player
		function HasSR(var1)
			for i=1,#sr do
				local hasSR = select(7,UnitBuffID(var1,sr[i]))
				
				if hasSR then
					return true,hasSR
				end
			end
			return false
		end
		
		function CastRavage()
			--Variables
			local HasSR = HasSR("Player")
			local HasThrash = select(2,HasThrash("Target","Player"))
			--Misc
			local Incarnation = UnitBuffID("Player", 102543)
			local fbCP = GetComboPoints("Player", "Target")
			local CCasting = UnitBuffID("Player",16870)
			
			if Incarnation ~= nil and fbCP < 5 and HasSR and ((CCasting and HasThrash and HasThrash > 3) or (not CCasting and not HasThash)) then
				CastSpellByName(tostring(GetSpellInfo(6785)))
			end
		end
		
		function HasRake(var1)
			local rake = select(7,UnitDebuffID(var1, 1822, "PLAYER"))
			
			if rake then
				if (rake - GetTime()) > 3 then
					return true
				end
			end
			return false
		end
	elseif Class == 3 then
		return false
	elseif Class == 8 then
		return false
	elseif Class == 2 then
		return false
	elseif Class == 5 then
		return false
	elseif Class == 4 then
		return false
	elseif Class == 7 then
		return false
	elseif Class == 9 then
		return false
	elseif Class == 1 then
		return false
	elseif Class == 12 then
		return false
	else
		return false
	end
end