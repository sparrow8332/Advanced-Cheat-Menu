-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------

local iPlayer;
local iCity;

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------

function ChangeGoldbasic(playerID, pNewGoldbasic)
	local pPlayer = Players[playerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGoldbasic)
end
function ChangeFaithbasic(playerID, pNewFaithbasic)
	local pPlayer = Players[playerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewFaithbasic)
end
function ChangeEnvoybasic(playerID, pNewEnvoybasic)
	local pPlayer = Players[playerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoybasic)
end
function CompleteProductionbasic(playerID)
	local pPlayer = Players[playerID]
	local pCity = pPlayer:GetCities():FindID(iCity)	
	local pCityBuildQueue = pCity:GetBuildQueue();
	if iPlayer == playerID then
		pCityBuildQueue:FinishProgress()	
	end
end
function CompleteResearchbasic(playerID, pResearchComplete)
    local pPlayer = Players[playerID]
    local pResearch = pPlayer:GetTechs()
    pResearch:ChangeCurrentResearchProgress(pResearchComplete)
end
function CompleteCivicbasic(playerID, pCivicComplete)
    local pPlayer = Players[playerID]
    local pCivics = pPlayer:GetCulture()
    pCivics:ChangeCurrentCulturalProgress(pCivicComplete)
end

function ChangePopulationbasic(playerID, pCity, pNewPopulation)
	local pPlayer = Players[playerID]	
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)	
		if pCity ~= nil then
			pCity:ChangePopulation(1);
		end
	end
end
function UnitPromotebasic(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
	local pUnitExp = pUnit:GetExperience():GetExperienceForNextLevel();
	if pUnitExp > 0 then
		pUnit:GetExperience():ChangeExperience(pUnitExp);
		UnitManager.ChangeMovesRemaining(pUnit, 1);
	end
end
function UnitMovementChangebasic(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		UnitManager.RestoreMovement(pUnit);
		UnitManager.RestoreUnitAttacks(pUnit);
    end
end
function UnitHealChangebasic(playerID, unitID)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		pUnit:SetDamage(0);
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
    print("      Cheat Panel Basic Script Loaded")          
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	Events.CitySelectionChanged.Add(SetValues);
	if ( not ExposedMembers.MOD_CheatMenuBasic) then ExposedMembers.MOD_CheatMenuBasic = {}; end
	ExposedMembers.MOD_CheatMenuBasic.ChangeGoldbasic = ChangeGoldbasic;
	ExposedMembers.MOD_CheatMenuBasic.ChangeEnvoybasic = ChangeEnvoybasic;
	ExposedMembers.MOD_CheatMenuBasic.CompleteProductionbasic = CompleteProductionbasic;
	ExposedMembers.MOD_CheatMenuBasic.CompleteResearchbasic = CompleteResearchbasic;
	ExposedMembers.MOD_CheatMenuBasic.CompleteCivicbasic = CompleteCivicbasic;
	ExposedMembers.MOD_CheatMenuBasic.ChangeFaithbasic = ChangeFaithbasic;
	ExposedMembers.MOD_CheatMenuBasic.ChangePopulationbasic = ChangePopulationbasic;
	ExposedMembers.MOD_CheatMenuBasic.UnitPromotebasic = UnitPromotebasic;
	ExposedMembers.MOD_CheatMenuBasic.UnitMovementChangebasic = UnitMovementChangebasic;
	ExposedMembers.MOD_CheatMenuBasic.UnitHealChangebasic = UnitHealChangebasic;
	ExposedMembers.MOD_CheatMenuBasic_Initialized = true;
	print( "Cheat Menu Initialization Started" );
end

Initialize();
