-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------

include("Civ6Common");
include("InstanceManager");
include("SupportFunctions");
include("PopupDialog");
include("AnimSidePanelSupport");
include("CitySupport");

local playerID 						= Game.GetLocalPlayer();
local pPlayer 						= Players[playerID];
local pTreasury 					= pPlayer:GetTreasury();
local pReligion 					= pPlayer:GetReligion();
local pEnvoy 						= pPlayer:GetInfluence();
local pVis 							= PlayersVisibility[playerID];
local pNewEnvoybasic 					= 5;
local pNewGoldbasic						= 1000;
local m_hideCheatPanelbasic				= false;
local m_IsLoading:boolean			= false;
local m_IsAttached:boolean			= false;

-- // ----------------------------------------------------------------------------------------------
-- // MENU BUTTON FUNCTIONS
-- // ----------------------------------------------------------------------------------------------

function ChangeGoldbasic()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenuBasic.ChangeGoldbasic(playerID, pNewGoldbasic); 
    end
end
function ChangeEnvoybasic()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenuBasic.ChangeEnvoybasic(playerID, pNewEnvoybasic);
    end
end
function ChangeFaithbasic()
	local pNewFaithbasic = 1000;
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenuBasic.ChangeFaithbasic(playerID, pNewFaithbasic);
    end
end
function CompleteProductionbasic()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenuBasic.CompleteProductionbasic(playerID);
	end
end
function CompleteResearchbasic()
 	local pTechs = pPlayer:GetTechs()
	local pRTech = pTechs:GetResearchingTech()	
	if pRTech >= 0 then
		local pCost = pTechs:GetResearchCost(pRTech)	
		local pProgress = pTechs:GetResearchProgress(pRTech)
		local pResearchComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			ExposedMembers.MOD_CheatMenuBasic.CompleteResearchbasic(playerID, pResearchComplete);				
		end		
	end
end
function CompleteCivicbasic()
 	local pCivics = pPlayer:GetCulture()
	local pRCivic = pCivics:GetProgressingCivic()
	if pRCivic >= 0 then		
		local pCost = pCivics:GetCultureCost(pRCivic)	
		local pProgress = pCivics:GetCulturalProgress(pRCivic)
		local pCivicComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			ExposedMembers.MOD_CheatMenuBasic.CompleteCivicbasic(playerID, pCivicComplete);				
		end
	end	
end
function ChangePopulationbasic()
	local pCity = UI.GetHeadSelectedCity();
	if pCity ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenuBasic.ChangePopulationbasic(playerID, pCity, pNewPopulation);
	end
end
function UnitPromotebasic()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		ExposedMembers.MOD_CheatMenuBasic.UnitPromotebasic(playerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitMovementChangebasic()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenuBasic.UnitMovementChangebasic(playerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitHealChangebasic()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenuBasic.UnitHealChangebasic(playerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
