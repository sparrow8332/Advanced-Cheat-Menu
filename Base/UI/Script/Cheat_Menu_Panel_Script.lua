-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------

local iPlayer;
local iCity;

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
function ChangeLUXURYResources(playerID)
	local playerID = Game.GetLocalPlayer()
    local pPlayer = Players[playerID]
	local resourceInfo = GameInfo.Resources();
	local playerResources = Players[playerID]:GetResources();
	local iValue = math.random(1, 3);
	for resource in GameInfo.Resources() do
	  if resource.ResourceClassType == "RESOURCECLASS_LUXURY" then
		playerResources:ChangeResourceAmount(resource.Index, iValue);
	  end
	end
end

function ChangeSTRATEGICResources(playerID)
	local playerID = Game.GetLocalPlayer()
    local pPlayer = Players[playerID]
	local resourceInfo = GameInfo.Resources();
	local playerResources = Players[playerID]:GetResources();
	local iValue = math.random(1, 3);
	for resource in GameInfo.Resources() do
	  if resource.ResourceClassType == "RESOURCECLASS_STRATEGIC" then
		playerResources:ChangeResourceAmount(resource.Index, iValue);
	  end
	end
end
function ChangeEraScore(playerID)
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	if (Game.GetEras ~= nil) then
		Game.GetEras():ChangePlayerEraScore(playerID, 10);
	end
end
function ChangeEraScoreBack(playerID)
	local playerID = Game.GetLocalPlayer()
    local pPlayer = Players[playerID]
	if (Game.GetEras ~= nil) then
		Game.GetEras():ChangePlayerEraScore(playerID, -10);
	end
end
function ChangeGold(playerID, pNewGold)
	local pPlayer = Players[playerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGold)
end
function CompleteProduction(playerID, pNewProduction)
	local pPlayer = Players[playerID]
	local pCity = pPlayer:GetCities():FindID(iCity)	
	local pCityBuildQueue = pCity:GetBuildQueue();
	if iPlayer == playerID then
		--pCityBuildQueue:FinishProgress()	
		pCityBuildQueue:AddProgress(pNewProduction);
	end
end
function CompleteAllResearch(playerID)
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pTechs = pPlayer:GetTechs()
	for kTech in GameInfo.Technologies() do
		pTechs:SetResearchProgress(kTech.Index, pTechs:GetResearchCost(kTech.Index))
	end
end
function CompleteAllCivic(playerID)
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pTechs = pPlayer:GetCulture()
	for kTech in GameInfo.Civics() do
		pTechs:SetCulturalProgress(kTech.Index, pTechs:GetCultureCost(kTech.Index))
	end
end
function CompleteResearch(playerID, pResearchComplete)
    local pPlayer = Players[playerID]
    local pResearch = pPlayer:GetTechs()
    pResearch:ChangeCurrentResearchProgress(pResearchComplete)
end
function CompleteCivic(playerID, pCivicComplete)
    local pPlayer = Players[playerID]
    local pCivics = pPlayer:GetCulture()
    pCivics:ChangeCurrentCulturalProgress(pCivicComplete)
end
function ChangeFaith(playerID, pNewFaith)
	local pPlayer = Players[playerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewFaith)
end
function ChangePopulation(playerID, pCity, pNewPopulation)
	local pPlayer = Players[playerID]	
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)	
		if pCity ~= nil then
			pCity:ChangePopulation(1);
		end
	end
end
function MakeFreeCity(playerID, pCity)
	local pPlayer = Players[playerID]
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)	
		if pCity ~= nil then
			--CityManager.TransferCityToFreeCities(pCity);
		end	
	end
end
function FreeBuilder(playerID, pCity)
	local pPlayer = Players[playerID]
	local DupeUnit = nil;
	local iBuilder = GameInfo.Units["UNIT_BUILDER"].UnitType
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)	
		if pCity ~= nil then
			DupeUnit = UnitManager.InitUnitValidAdjacentHex(playerID, iBuilder, pCity:GetX(), pCity:GetY(), 1);
		end	
	end
end
function FreeSettler(playerID, pCity)
	local pPlayer = Players[playerID]
	local DupeUnit = nil;
	local iSettler = GameInfo.Units["UNIT_SETTLER"].UnitType
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)	
		if pCity ~= nil then
			DupeUnit = UnitManager.InitUnitValidAdjacentHex(playerID, iSettler, pCity:GetX(), pCity:GetY(), 1);
		end	
	end
end
function RestoreCityHealth(playerID)
	local pPlayer = Players[playerID]	
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)	
		if (pCity ~= nil) then
			local pCityDistricts = pCity:GetDistricts();
			if (pCityDistricts ~= nil) then
				local pCityCenter = pCityDistricts:GetDistrictAtLocation(pCity:GetX(), pCity:GetY());
				if (pCityCenter ~= nil) then
					pCityCenter:SetDamage(DefenseTypes.DISTRICT_GARRISON, 0);
					pCityCenter:SetDamage(DefenseTypes.DISTRICT_OUTER, 0);
				end
			end
		end		
	end
end
function ChangeCityLoyalty(playerID)
	local pPlayer = Players[playerID]	
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)
		pCity:ChangeLoyalty(100)		
	end
end
function UnitPromote(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
	local pUnitExp = pUnit:GetExperience():GetExperienceForNextLevel();
	if pUnitExp > 0 then
		pUnit:GetExperience():ChangeExperience(pUnitExp);
		UnitManager.ChangeMovesRemaining(pUnit, 1);
	end
end
function UnitMovementChange(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		UnitManager.RestoreMovement(pUnit);
		UnitManager.RestoreUnitAttacks(pUnit);
    end
end
function UnitAddMovement(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		UnitManager.ChangeMovesRemaining(pUnit, 5);
		UnitManager.RestoreUnitAttacks(pUnit);
    end
end
function OnDuplicate(playerID, unitId, unitType, pRelig)
	local DupeUnit = nil;
	local pPlayer = Players[playerID];
	local pRelig = nil;
	local pUnit = UnitManager.GetUnit( playerID, unitId ); 
	local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
	if pUnit ~= nil and Players[playerID]:IsHuman() then
		DupeUnit = UnitManager.InitUnitValidAdjacentHex(playerID, unitType, pPlot:GetX(), pPlot:GetY(), 1);
		--newUnit = UnitManager.InitUnit(playerID, unitType, pPlot:GetX(), pPlot:GetY());
	end
	if pUnit:GetReligion() ~= nil and DupeUnit:GetReligion() ~= nil and pUnit:GetReligion():GetReligionType() ~= -1 then
		DupeUnit:GetReligion():SetReligionType(pUnit:GetReligion():GetReligionType());
	elseif pRelig ~= nil and DupeUnit:GetReligion() ~= nil and pRelig ~= -1 then
		DupeUnit:GetReligion():SetReligionType( pRelig );
	end
end
function UnitHealChange(playerID, unitID)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		pUnit:SetDamage(0);
	end
end
function UnitHealAllChange(playerID, unitID)
	local z = 1;
	local pPlayer = Players[playerID];
	local pUnits = pPlayer:GetUnits();
	for ii, pUnit in pUnits:Members() do
		UnitManager.RestoreMovementToFormation(pUnit);
	 pUnit:SetDamage(0);
		z = z + 1;			
	end		
end
function UnitFormCorps(playerID, unitID)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		pUnit:SetMilitaryFormation(MilitaryFormationTypes.CORPS_FORMATION);
	end
end
function UnitFormArmy(playerID, unitID)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		pUnit:SetMilitaryFormation(MilitaryFormationTypes.ARMY_FORMATION);
	end
end
function ChangeEnvoy(playerID, pNewEnvoy)
	local pPlayer = Players[playerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoy)
end
function ChangeDiplomaticFavor(playerID, pNewFavor)
	local pPlayer = Players[playerID]
    if pPlayer:GetDiplomacy().ChangeFavor ~= nil then
		pPlayer:GetDiplomacy():ChangeFavor(pNewFavor);
	end	
end
function ChangeGovPoints(playerID, pNewGP)
	local pPlayer = Players[playerID];
	pPlayer:GetGovernors():ChangeGovernorPoints(pNewGP);
end
function RevealAll(playerID)
	local eObserverID = Game.GetLocalObserver();
	if (eObserverID == PlayerTypes.OBSERVER) then
		PlayerManager.SetLocalObserverTo(playerID);
	else
		PlayerManager.SetLocalObserverTo(PlayerTypes.OBSERVER);
	end
end
function SetValues(playerID, cityID)
	iPlayer = playerID
	iCity = cityID	
end

-- // ----------------------------------------------------------------------------------------------
-- // Lua Events
-- // ----------------------------------------------------------------------------------------------
function Initialize()
	print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("      Cheat Panel Script Loaded")          
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	Events.CitySelectionChanged.Add(SetValues);
	if ( not ExposedMembers.MOD_CheatMenu) then ExposedMembers.MOD_CheatMenu = {}; end
	ExposedMembers.MOD_CheatMenu.MakeFreeCity = MakeFreeCity;
	ExposedMembers.MOD_CheatMenu.ChangeLUXURYResources = ChangeLUXURYResources;
	ExposedMembers.MOD_CheatMenu.ChangeSTRATEGICResources = ChangeSTRATEGICResources;
	ExposedMembers.MOD_CheatMenu.ChangeDiplomaticFavor = ChangeDiplomaticFavor;
	ExposedMembers.MOD_CheatMenu.ChangeGold = ChangeGold;
	ExposedMembers.MOD_CheatMenu.ChangeGovPoints = ChangeGovPoints;
	ExposedMembers.MOD_CheatMenu.ChangeResources = ChangeResources;
	ExposedMembers.MOD_CheatMenu.ChangeEraScore = ChangeEraScore;
	ExposedMembers.MOD_CheatMenu.ChangeEraScoreBack = ChangeEraScoreBack;
	ExposedMembers.MOD_CheatMenu.RevealAll = RevealAll;
	ExposedMembers.MOD_CheatMenu.OnDuplicate = OnDuplicate;
	ExposedMembers.MOD_CheatMenu.UnitFormCorps = UnitFormCorps;
	ExposedMembers.MOD_CheatMenu.UnitFormArmy = UnitFormArmy;
	ExposedMembers.MOD_CheatMenu.ChangeEnvoy = ChangeEnvoy;
	ExposedMembers.MOD_CheatMenu.ChangeCityLoyalty = ChangeCityLoyalty;
	ExposedMembers.MOD_CheatMenu.CompleteProduction = CompleteProduction;
	ExposedMembers.MOD_CheatMenu.CompleteAllResearch = CompleteAllResearch;
	ExposedMembers.MOD_CheatMenu.CompleteResearch = CompleteResearch;
	ExposedMembers.MOD_CheatMenu.CompleteAllCivic = CompleteAllCivic;
	ExposedMembers.MOD_CheatMenu.CompleteCivic = CompleteCivic;
	ExposedMembers.MOD_CheatMenu.FreeSettler = FreeSettler;
	ExposedMembers.MOD_CheatMenu.FreeBuilder = FreeBuilder;
	ExposedMembers.MOD_CheatMenu.ChangeFaith = ChangeFaith;
	ExposedMembers.MOD_CheatMenu.ChangePopulation = ChangePopulation;
	ExposedMembers.MOD_CheatMenu.UnitPromote = UnitPromote;
	ExposedMembers.MOD_CheatMenu.UnitMovementChange = UnitMovementChange;
	ExposedMembers.MOD_CheatMenu.UnitHealChange = UnitHealChange;
	ExposedMembers.MOD_CheatMenu.UnitHealAllChange = UnitHealAllChange;
	ExposedMembers.MOD_CheatMenu.UnitAddMovement = UnitAddMovement;
	ExposedMembers.MOD_CheatMenu.RestoreCityHealth = RestoreCityHealth;
	ExposedMembers.MOD_CheatMenu_Initialized = true;
	print( "Cheat Menu Initialization Started" );
end

Initialize();
