-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------


-- // ----------------------------------------------------------------------------------------------
-- // Variables
-- // ----------------------------------------------------------------------------------------------
local iPlayer;
local iCity;

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------

function ChangeEraScore(playerID)
	local playerID = Game.GetLocalPlayer()
    local pPlayer = Players[playerID]
	if (Game.ChangePlayerEraScore ~= nil) then
		Game.ChangePlayerEraScore(playerID, 10);
	end
end
function ChangeGold(playerID, pNewGold)
    local pPlayer = Players[playerID]
    local pTreasury = pPlayer:GetTreasury()
    pTreasury:ChangeGoldBalance(pNewGold)
end
function CompleteProduction(playerID)
	local pPlayer = Players[playerID]
	if iPlayer == playerID then
		local pCity = pPlayer:GetCities():FindID(iCity)	
		pCity:GetBuildQueue():FinishProgress()		
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
function ChangeFaith(playerID, pNewReligion)
	local pPlayer = Players[playerID]
    local pReligion = pPlayer:GetReligion()
    pReligion:ChangeFaithBalance(pNewReligion)
end
function ChangePopulation(playerID)
	local pPlayer = Players[playerID]	
	if iPlayer == playerID then
	local pCity = pPlayer:GetCities():FindID(iCity)	
		pCity:ChangePopulation(1)		
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
    end
end
function OnDuplicate(playerID, unitId, unitType)
	local DupeUnit = nil;
	local pUnit = UnitManager.GetUnit( playerID, unitId ); 
	local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
	local pUnitXP = pUnit:GetExperience();
	if pUnit ~= nil and Players[playerID]:IsHuman() then
		DupeUnit = UnitManager.InitUnitValidAdjacentHex(playerID, unitType, pPlot:GetX(), pPlot:GetY(), 1);
	end
end
function UnitHealChange(playerID, unitID)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
    if (pUnit ~= nil) then
		pUnit:SetDamage(0);
	end
end
function ChangeEnvoy(playerID, pNewEnvoy)
	local pPlayer = Players[playerID]
    local pEnvoy = pPlayer:GetInfluence()
    pEnvoy:ChangeTokensToGive(pNewEnvoy)
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
function SetValues(playerID, cityID, DistrictID)
	iPlayer = playerID
	iCity = cityID	
end

-- // ----------------------------------------------------------------------------------------------
-- // Lua Events
-- // ----------------------------------------------------------------------------------------------

	LuaEvents.ChangePlayerGpoints.Add( ChangeGovPoints )
	LuaEvents.ChangePlayerScoreEra.Add( ChangeEraScore )
	LuaEvents.ChangeFOW.Add( RevealAll )
	LuaEvents.ChangePlayerEnvoy.Add( ChangeEnvoy )
	LuaEvents.ChangePlayerLoyalty.Add( ChangeCityLoyalty )
	LuaEvents.ChangePlayerGold.Add( ChangeGold )
	LuaEvents.CompletePlayerProduction.Add( CompleteProduction )
	LuaEvents.CompleteAllPlayerResearch.Add( CompleteAllResearch )
	LuaEvents.CompletePlayerResearch.Add( CompleteResearch )
	LuaEvents.CompleteAllPlayerCivic.Add( CompleteAllCivic )
	LuaEvents.CompletePlayerCivic.Add( CompleteCivic )
	LuaEvents.ChangePlayerFaith.Add( ChangeFaith )
	LuaEvents.ChangePlayerPopulation.Add( ChangePopulation )
	LuaEvents.ChangePromotion.Add( UnitPromote )
	LuaEvents.ChangeUnitMovement.Add( UnitMovementChange )
	LuaEvents.ChangeUnitHealth.Add( UnitHealChange )
	LuaEvents.AddUnitMovement.Add( UnitAddMovement )
	LuaEvents.DuplicateUnit.Add( OnDuplicate )	
	Events.CitySelectionChanged.Add(SetValues)

