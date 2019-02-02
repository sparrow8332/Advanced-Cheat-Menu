-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
include("Civ6Common");
include("InstanceManager");
include("SupportFunctions");
include("PopupDialog");
include("AnimSidePanelSupport");

-- // ----------------------------------------------------------------------------------------------
-- // Variables
-- // ----------------------------------------------------------------------------------------------
local m_CheatPanelState:number			= 0;
local playerID = Game.GetLocalPlayer()
local pPlayer = Players[playerID]

-- // ----------------------------------------------------------------------------------------------
-- // Functions
-- // ----------------------------------------------------------------------------------------------
function AttachPanelToOptionsStack()
	local CheatMenuButton:table = ContextPtr:LookUpControl("/InGame/MinimapPanel/OptionsStack");
	if (CheatMenuButton ~= nil) then
		Controls.CheatButtonMenu:ChangeParent(CheatMenuButton);
		CheatMenuButton:CalculateSize();
		CheatMenuButton:ReprocessAnchoring();
	end
end
function OnLoadGameViewStateDone()
	AttachPanelToOptionsStack();
end

-- // ----------------------------------------------------------------------------------------------
-- // Event Handlers
-- // ----------------------------------------------------------------------------------------------
function ChangeEraScore()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	if pPlayer:IsHuman() then
        LuaEvents.ChangePlayerScoreEra(playerID)
    end
	Refresh();
end
function ChangeGold()
	local pTreasury = pPlayer:GetTreasury()	
	local pNewGold = 1000
	if pPlayer:IsHuman() then
        LuaEvents.ChangePlayerGold(playerID, pNewGold)
    end
end
function CompleteProduction()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]	
	if pPlayer:IsHuman() then
		LuaEvents.CompletePlayerProduction(playerID)
	end
end
function CompleteAllResearch()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pTechs = pPlayer:GetTechs()
	if pPlayer:IsHuman() then		
		LuaEvents.CompleteAllPlayerResearch(playerID)	
	end		
end
function CompleteAllCivic()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pTechs = pPlayer:GetCulture()
	if pPlayer:IsHuman() then		
		LuaEvents.CompleteAllPlayerCivic(playerID)	
	end		
end
function CompleteResearch()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pTechs = pPlayer:GetTechs()
	local pRTech = pTechs:GetResearchingTech()	
	if pRTech >= 0 then
		local pCost = pTechs:GetResearchCost(pRTech)	
		local pProgress = pTechs:GetResearchProgress(pRTech)
		local pResearchComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			LuaEvents.CompletePlayerResearch(playerID, pResearchComplete)	
		end		
	end
end
function CompleteCivic()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pCivics = pPlayer:GetCulture()
	local pRCivic = pCivics:GetProgressingCivic()
	if pRCivic >= 0 then		
		local pCost = pCivics:GetCultureCost(pRCivic)	
		local pProgress = pCivics:GetCulturalProgress(pRCivic)
		local pCivicComplete = (pCost - pProgress)
		if pPlayer:IsHuman() then		
			LuaEvents.CompletePlayerCivic(playerID, pCivicComplete)	
		end
	end	
end
function ChangeFaith()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pReligion = pPlayer:GetReligion()	
	local pNewReligion = 1000
	if pPlayer:IsHuman() then
        LuaEvents.ChangePlayerFaith(playerID, pNewReligion)
    end
end
function ChangePopulation()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	if pPlayer:IsHuman() then		
		LuaEvents.ChangePlayerPopulation(playerID)
	end
end
function ChangeCityLoyalty()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	if pPlayer:IsHuman() then		
		LuaEvents.ChangePlayerLoyalty(playerID)	
	end
end
function DestroyCity()
	local playerID = Game.GetLocalPlayer();
	local pPlayer = Players[playerID];
	local pCity  = UI.GetHeadSelectedCity();
	local pCityName:string = Locale.Lookup(pCity:GetName());
	local pCityPop:string = Locale.Lookup(pCity:GetPopulation());
	if pPlayer:IsHuman(pCity == nil) then
		LuaEvents.ShowRazeCityReminderPopup(playerID);
	end
end
function UnitPromote()
	local playerID = Game.GetLocalPlayer();
    local pPlayer = Players[playerID];
    local pUnit = UI.GetHeadSelectedUnit();
    local unitID = pUnit:GetID();
    if pPlayer:IsHuman() then
        LuaEvents.ChangePromotion(playerID, unitID)
    end
	UI:DeselectUnitID(unitID);
	UI:SelectUnitID(unitID);
end
function UnitMovementChange()
    local playerID = Game.GetLocalPlayer();
    local pPlayer = Players[playerID];
    local pUnit = UI.GetHeadSelectedUnit();
    local unitID = pUnit:GetID();
    if pPlayer:IsHuman() then
        LuaEvents.ChangeUnitMovement(playerID, unitID)
    end
	UI:DeselectUnitID(unitID);
	UI:SelectUnitID(unitID);
end
function UnitAddMovement()
    local playerID = Game.GetLocalPlayer();
    local pPlayer = Players[playerID];
    local pUnit = UI.GetHeadSelectedUnit();
    local unitID = pUnit:GetID();
    if pPlayer:IsHuman() then
        LuaEvents.AddUnitMovement(playerID, unitID)
    end
	UI:DeselectUnitID(unitID);
	UI:SelectUnitID(unitID);
end
function OnDuplicate()
	local playerID = Game.GetLocalPlayer();
    local pPlayer = Players[playerID];
    local pUnit = UI.GetHeadSelectedUnit();
    local unitID = pUnit:GetID();
	local unitType:string = GameInfo.Units[pUnit:GetUnitType()].UnitType;
	if pPlayer:IsHuman() then
		LuaEvents.DuplicateUnit(playerID, unitID, unitType)
    end
end
function UnitHealChange()
    local playerID = Game.GetLocalPlayer()
    local pPlayer = Players[playerID]
    local pUnit = UI.GetHeadSelectedUnit();
    local unitID = pUnit:GetID()
    if pPlayer:IsHuman() then
        LuaEvents.ChangeUnitHealth(playerID, unitID)
    end
	UI:DeselectUnitID(unitID);
	UI:SelectUnitID(unitID);
end
function ChangeEnvoy()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pEnvoy = pPlayer:GetInfluence()
	local pNewEnvoy = 5
	if pPlayer:IsHuman() then
        LuaEvents.ChangePlayerEnvoy(playerID, pNewEnvoy)
    else end
end
function ChangeGovPoints()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pNewGP = 1
	if pPlayer:IsHuman() then
        LuaEvents.ChangePlayerGpoints(playerID, pNewGP)
    end
end
function RevealAll()
	local playerID = Game.GetLocalPlayer()
	local pPlayer = Players[playerID]
	local pVis = PlayersVisibility[playerID]
	if pPlayer:IsHuman() then		
		LuaEvents.ChangeFOW(playerID)	
	end		
end
--******************************************************************************

function Refresh()
	if pPlayer:IsHuman() then
		local UPContextPtr :table = ContextPtr:LookUpControl("/InGame/ActionPanel");
		if UPContextPtr ~= nil then
			UPContextPtr:RequestRefresh(); 
		end
	end
	ContextPtr:RequestRefresh(); 
end
local function OnRefresh()
	ContextPtr:ClearRequestRefresh();   
	Refresh(playerID);
end
--******************************************************************************
local function Hide()
	UI.PlaySound("Tech_Tray_Slide_Closed");
	if not Controls.SpawnDlgContainer:IsHidden() then
		Controls.SpawnDlg_Anim:Reverse();	
		Controls.SpawnDlgContainer:SetHide( true );
	end
	m_CheatPanelState = 0;
end
local function Show()
	UI.PlaySound("Tech_Tray_Slide_Open");
	if Controls.SpawnDlgContainer:IsHidden() then
		Controls.SpawnDlg_Anim:SetToBeginning();
		Controls.SpawnDlg_Anim:Play();
		Controls.SpawnDlgContainer:SetHide( false );
	end
	m_CheatPanelState = 1;
end
function OnMenuButtonToggle()
    if(m_CheatPanelState == 0) then
		Show();	
	else
		Hide();
	end	
end
--******************************************************************************
function OnInputActionTriggered( actionId )
	if ( actionId == Input.GetActionId("ToggleGold") ) then
		ChangeGold();
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
		OnMenuButtonToggle();
	end
end

-- // ----------------------------------------------------------------------------------------------
-- // Int
-- // ----------------------------------------------------------------------------------------------
local function InitializeControls()

		Controls.CheatButtonGov:RegisterCallback(Mouse.eLClick, ChangeGovPoints);
		Controls.CheatButtonEra:RegisterCallback(Mouse.eLClick, ChangeEraScore);
		Controls.CheatButtonGold:RegisterCallback(Mouse.eLClick, ChangeGold);
		Controls.CheatButtonProduction:RegisterCallback(Mouse.eLClick, CompleteProduction);
		Controls.CheatButtonAllTech:RegisterCallback(Mouse.eLClick, CompleteAllResearch);
		Controls.CheatButtonAllCivic:RegisterCallback(Mouse.eLClick, CompleteAllCivic);
		Controls.CheatButtonScience:RegisterCallback(Mouse.eLClick, CompleteResearch);
		Controls.CheatButtonCulture:RegisterCallback(Mouse.eLClick, CompleteCivic);
		Controls.CheatButtonFaith:RegisterCallback(Mouse.eLClick, ChangeFaith);
		Controls.CheatButtonPopulation:RegisterCallback(Mouse.eLClick, ChangePopulation);
		Controls.CheatButtonLoyalty:RegisterCallback(Mouse.eLClick, ChangeCityLoyalty);
		Controls.CheatButtonDestroy:RegisterCallback(Mouse.eLClick, DestroyCity);
		Controls.CheatButtonPromote:RegisterCallback(Mouse.eLClick, UnitPromote);
		Controls.CheatButtonUnitMV:RegisterCallback(Mouse.eLClick, UnitMovementChange);
		Controls.CheatButtonAddMovement:RegisterCallback(Mouse.eLClick, UnitAddMovement);
		Controls.CheatButtonDuplicate:RegisterCallback(Mouse.eLClick, OnDuplicate);
		Controls.CheatButtonHeal:RegisterCallback(Mouse.eLClick, UnitHealChange);
		Controls.CheatButtonEnvoy:RegisterCallback(Mouse.eLClick, ChangeEnvoy);
		Controls.CheatButtonObs:RegisterCallback(Mouse.eLClick, RevealAll);		
		Controls.CheatButtonMenu:RegisterCallback( Mouse.eLClick, OnMenuButtonToggle );
		Controls.CheatButtonMenu:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
		Controls.CheatButtonEra:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonGold:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonProduction:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonAllTech:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonAllCivic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonScience:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonCulture:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonFaith:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonPopulation:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonLoyalty:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonDestroy:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonPromote:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonUnitMV:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonAddMovement:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonDuplicate:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonHeal:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonEnvoy:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonObs:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
		Controls.CheatButtonGov:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
		Controls.SpawnDlgContainer:SetHide( true );
end

function Initialize()

		ContextPtr:SetInputHandler( OnInputHandler, true );
		ContextPtr:SetRefreshHandler( OnRefresh );
		Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
		LuaEvents.EndGameMenu_Shown.Add( Hide );
		LuaEvents.DiplomacyActionView_HideIngameUI.Add( Hide );
		LuaEvents.WonderRevealPopup_Shown.Add( Hide );
		LuaEvents.NaturalWonderPopup_Shown.Add( Hide );
		Events.InputActionTriggered.Add( OnInputActionTriggered );
	
	InitializeControls();

end
Initialize();