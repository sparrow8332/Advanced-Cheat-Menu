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
local pNewGP 						= 1;
local pNewEnvoy 					= 5;
local pNewFavor						= 100;
local m_hideCheatPanel				= false;
local m_IsLoading:boolean			= false;
local m_IsAttached:boolean			= false;

-- // ----------------------------------------------------------------------------------------------
-- // MENU BUTTON FUNCTIONS
-- // ----------------------------------------------------------------------------------------------

function ChangeLUXURYResources(playerID)
 	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.ChangeLUXURYResources(playerID);
	end
end
function ChangeSTRATEGICResources(playerID)
 	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.ChangeSTRATEGICResources(playerID);
	end
end
function ChangeEraScore()
	if pPlayer:IsHuman() then
        ExposedMembers.MOD_CheatMenu.ChangeEraScore(playerID);
    end
	RefreshActionPanel();
end
function ChangeEraScoreBack()
	if pPlayer:IsHuman() then
        ExposedMembers.MOD_CheatMenu.ChangeEraScoreBack(playerID);
    end
	RefreshActionPanel();
end
function ChangeGold()
	local pNewGold:number = tonumber(Controls.GoldAmount:GetText());
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeGold(playerID, pNewGold); 
    end
end
function ChangeGoldMore()
	local pNewGold = 100000;
	if pPlayer:IsHuman() then
        ExposedMembers.MOD_CheatMenu.ChangeGold(playerID, pNewGold); 
    end
end
function CompleteProduction()
	local pNewProduction:number = tonumber(Controls.ProductionAmount:GetText());
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.CompleteProduction(playerID, pNewProduction);
	end
end
function CompleteAllResearch()
 	local pTechs = pPlayer:GetTechs()
	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.CompleteAllResearch(playerID);	
	end		
end
function CompleteAllCivic()
 	local pTechs = pPlayer:GetCulture()
	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.CompleteAllCivic(playerID);	
	end		
end
function CompleteResearch()
 	local pTechs = pPlayer:GetTechs()
	local pRTech = pTechs:GetResearchingTech()	
	if pRTech >= 0 then
		local pCost = pTechs:GetResearchCost(pRTech)	
		local pProgress = pTechs:GetResearchProgress(pRTech)
		local pResearchComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			ExposedMembers.MOD_CheatMenu.CompleteResearch(playerID, pResearchComplete);				
		end		
	end
end
function CompleteCivic()
 	local pCivics = pPlayer:GetCulture()
	local pRCivic = pCivics:GetProgressingCivic()
	if pRCivic >= 0 then		
		local pCost = pCivics:GetCultureCost(pRCivic)	
		local pProgress = pCivics:GetCulturalProgress(pRCivic)
		local pCivicComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			ExposedMembers.MOD_CheatMenu.CompleteCivic(playerID, pCivicComplete);				
		end
	end	
end
function ChangeFaith()
	local pNewFaith:number = tonumber(Controls.FaithAmount:GetText());
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeFaith(playerID, pNewFaith);
    end
end
function ChangePopulation()
	local pCity = UI.GetHeadSelectedCity();
	if pCity ~= nil and pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangePopulation(playerID, pCity, pNewPopulation);
	end
end
function RestoreCityHealth()
 	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.RestoreCityHealth(playerID);
	end
end
function ChangeCityLoyalty()
 	if pPlayer:IsHuman() then		
		ExposedMembers.MOD_CheatMenu.ChangeCityLoyalty(playerID);
	end
end
function DestroyCity()
	local pCity = UI.GetHeadSelectedCity();
	if pCity ~= nil and pPlayer:IsHuman() then
		local pCityName:string = Locale.Lookup(pCity:GetName());
		local pCityPop:string = Locale.Lookup(pCity:GetPopulation());
		ExposedMembers.MOD_CheatMenu.DestroyCity(playerID);	
	end
end
function UnitPromote()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		ExposedMembers.MOD_CheatMenu.UnitPromote(playerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitMovementChange()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenu.UnitMovementChange(playerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitAddMovement()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenu.UnitAddMovement(playerID, unitID);
		UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
    end
end
function OnDuplicate()
	local pRelig = nil;
	if pPlayer:GetReligion() ~= nil and pPlayer:GetReligion():GetReligionTypeCreated() ~= -1 then
		pRelig = pPlayer:GetReligion():GetReligionTypeCreated();
	end
	local pUnit = UI.GetHeadSelectedUnit();
	if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
		local unitType:string = GameInfo.Units[pUnit:GetUnitType()].UnitType;
		ExposedMembers.MOD_CheatMenu.OnDuplicate(playerID, unitID, unitType, pRelig);
    end
end

function UnitHealChange()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenu.UnitHealChange(playerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitHealAllChange()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenu.UnitHealAllChange(playerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitFormCorps()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenu.UnitFormCorps(playerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function UnitFormArmy()
	local pUnit = UI.GetHeadSelectedUnit();
    if pUnit ~= nil and pPlayer:IsHuman() then
		local unitID = pUnit:GetID();
        ExposedMembers.MOD_CheatMenu.UnitFormArmy(playerID, unitID);
    	UI:DeselectUnitID(unitID);
		UI:SelectUnitID(unitID);
	end
end
function MakeFreeCity()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.MakeFreeCity(playerID, pCity);
    end
end
function FreeBuilder()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.FreeBuilder(playerID, pCity);
    end
end
function FreeSettler()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.FreeSettler(playerID, pCity);
    end
end
function ChangeEnvoy()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeEnvoy(playerID, pNewEnvoy);
    end
end

function ChangeDiplomaticFavor()
	local pNewFavor:number = tonumber(Controls.DiploAmount:GetText());
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeDiplomaticFavor(playerID, pNewFavor);
    end
end
function ChangeGovPoints()
	if pPlayer:IsHuman() then
		ExposedMembers.MOD_CheatMenu.ChangeGovPoints(playerID, pNewGP);
    end
end
function RevealAll()
	if pPlayer:IsHuman() then		
		LuaEvents.ChangeFOW(playerID)	
		ExposedMembers.MOD_CheatMenu.RevealAll(playerID);
	end		
end

function RefreshActionPanel()
	if pPlayer:IsHuman() then
		local UPContextPtr :table = ContextPtr:LookUpControl("/InGame/ActionPanel");
		if UPContextPtr ~= nil then
			UPContextPtr:RequestRefresh(); 
		end
	end
	ContextPtr:RequestRefresh(); 
end

-- // ----------------------------------------------------------------------------------------------
-- // HOTKEYS
-- // ----------------------------------------------------------------------------------------------
function OnInputActionTriggered( actionId )
	if ( actionId == Input.GetActionId("ToggleGold") ) then
		ChangeGold();
	end
	if ( actionId == Input.GetActionId("ToggleGoldMore") ) then
		ChangeGoldMore();
	end
	if ( actionId == Input.GetActionId("ToggleFaith") ) then
		ChangeFaith();
	end
	if ( actionId == Input.GetActionId("ToggleCProduction") ) then
		CompleteProduction();
	end
	if ( actionId == Input.GetActionId("ToggleCCivic") ) then
		CompleteCivic();
	end
	if ( actionId == Input.GetActionId("ToggleCResearch") ) then
		CompleteResearch();
	end
	if ( actionId == Input.GetActionId("ToggleEnvoy") ) then
		ChangeEnvoy();
	end
	if ( actionId == Input.GetActionId("ToggleEra") ) then
		ChangeEraScore();
	end
	if ( actionId == Input.GetActionId("ToggleObs") ) then
		RevealAll();
	end
	if ( actionId == Input.GetActionId("ToggleUnitMovementChange") ) then
		UnitMovementChange();
	end
	if ( actionId == Input.GetActionId("ToggleUnitHealChange") ) then
		UnitHealChange();
	end
		if ( actionId == Input.GetActionId("ToggleUnitHealChange") ) then
		UnitHealAllChange();
	end
	if ( actionId == Input.GetActionId("ToggleUnitPromote") ) then
		UnitPromote();
	end
	if ( actionId == Input.GetActionId("ToggleDuplicate") ) then
		OnDuplicate();
	end
	if ( actionId == Input.GetActionId("ToggleChangePopulation") ) then
		ChangePopulation();
	end
	if ( actionId == Input.GetActionId("ToggleChangeCityLoyalty") ) then
		ChangeCityLoyalty();
	end
	if ( actionId == Input.GetActionId("ToggleCompleteAllResearch") ) then
		CompleteAllResearch();
	end
	if ( actionId == Input.GetActionId("ToggleCompleteAllCivic") ) then
		CompleteAllCivic();
	end
	if ( actionId == Input.GetActionId("ToggleMenu") ) then
		OnPanelTitleClicked();
	end
	if ( actionId == Input.GetActionId("ToggleDiplomaticFavor") ) then
		ChangeDiplomaticFavor();
	end
end

