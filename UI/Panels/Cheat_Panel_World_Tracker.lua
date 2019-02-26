-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
include("Cheat_Menu_Panel_Functions");

local m_CheatPanelState:number		= 0;

function AttachPanelToWorldTracker()
	if (m_IsLoading) then
		return;
	end
	if (not m_IsAttached) then
		local worldTrackerPanel:table = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack");
		if (worldTrackerPanel ~= nil) then
			Controls.CheatPanel:ChangeParent(worldTrackerPanel);
			worldTrackerPanel:AddChildAtIndex(Controls.CheatPanel, 1);
			worldTrackerPanel:CalculateSize();
			worldTrackerPanel:ReprocessAnchoring();
			m_IsAttached = true;
		end
	end
end

-- // ----------------------------------------------------------------------------------------------
-- // Attach Panel To WorldTracker
-- // ----------------------------------------------------------------------------------------------
function OnLoadGameViewStateDone()
	AttachPanelToWorldTracker();
end

-- // ----------------------------------------------------------------------------------------------
-- // Panel Control and Checkbox Attach
-- // ----------------------------------------------------------------------------------------------
function UpdateCheatPanel(hideCheatPanel:boolean)
	m_hideCheatPanel = hideCheatPanel; 
	Controls.CheatPanel:SetHide(m_hideCheatPanel);
	Controls.ToggleCheatPanel:SetCheck(not m_hideCheatPanel);
end
function InitDropdown()
	local parent = ContextPtr:LookUpControl("/InGame/WorldTracker/CivicsCheckButton",	Controls.PanelStack );
	if parent == nil then return end;
	Controls.CheatPanelStack:ChangeParent(parent);
	parent.ReprocessAnchoring();
	Events.LoadGameViewStateDone.Remove(InitDropdown);
end
function OnPanelTitleClicked()
    if(m_CheatPanelState == 0) then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.CheatPanel:SetSizeY(225);
		Controls.ButtonStackMIN:SetHide(false);
		Controls.ButtonSep:SetHide(false);
		m_CheatPanelState = 1;

	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.CheatPanel:SetSizeY(25);
		Controls.ButtonStackMIN:SetHide(true);
		Controls.ButtonSep:SetHide(true);
		m_CheatPanelState = 0;
	end	
end
function KeyHandler( key:number )
	if key == Keys.VK_ESCAPE then
		Hide();
		return true;
	end
	return false;
end
function OnInputHandler( pInputStruct:table )
	local uiMsg = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp then 
		return KeyHandler( pInputStruct:GetKey() ); 
	end
	return false;
end

local function InitializeControls()
	Controls.HeaderTitle:RegisterCallback(Mouse.eLClick, OnPanelTitleClicked);
	--Controls.CheatButtonFreeCity:RegisterCallback(Mouse.eLClick, FreeCity);
	Controls.CheatButtonCityHeal:RegisterCallback(Mouse.eLClick, RestoreCityHealth); 
	Controls.CheatButtonEra2:RegisterCallback(Mouse.eLClick, ChangeEraScoreBack);
	Controls.CheatButtonGov:RegisterCallback(Mouse.eLClick, ChangeGovPoints);
	Controls.CheatButtonEra:RegisterCallback(Mouse.eLClick, ChangeEraScore);
	Controls.CheatButtonGold:RegisterCallback(Mouse.eLClick, ChangeGold);
	Controls.CheatButtonProduction:RegisterCallback(Mouse.eLClick, CompleteProduction);
	Controls.CheatButtonAllTech:RegisterCallback(Mouse.eLClick, CompleteAllResearch);
	Controls.CheatButtonAllCivic:RegisterCallback(Mouse.eLClick, CompleteAllCivic);
	Controls.CheatButtonScience:RegisterCallback(Mouse.eLClick, CompleteResearch);
	Controls.CheatButtonCulture:RegisterCallback(Mouse.eLClick, CompleteCivic);
	Controls.CheatButtonDuplicate:RegisterCallback(Mouse.eLClick, OnDuplicate);
	Controls.CheatButtonFaith:RegisterCallback(Mouse.eLClick, ChangeFaith);
	Controls.CheatButtonPopulation:RegisterCallback(Mouse.eLClick, ChangePopulation);
	Controls.CheatButtonLoyalty:RegisterCallback(Mouse.eLClick, ChangeCityLoyalty);
	Controls.CheatButtonDestroy:RegisterCallback(Mouse.eLClick, DestroyCity);
	Controls.CheatButtonPromote:RegisterCallback(Mouse.eLClick, UnitPromote);
	Controls.CheatButtonUnitMV:RegisterCallback(Mouse.eLClick, UnitMovementChange);
	Controls.CheatButtonAddMovement:RegisterCallback(Mouse.eLClick, UnitAddMovement);
	Controls.CheatButtonHeal:RegisterCallback(Mouse.eLClick, UnitHealChange);
	Controls.CheatButtonEnvoy:RegisterCallback(Mouse.eLClick, ChangeEnvoy);
	Controls.CheatButtonObs:RegisterCallback(Mouse.eLClick, RevealAll);	
	Controls.CheatButtonCorps:RegisterCallback(Mouse.eLClick, UnitFormCorps);
	Controls.CheatButtonArmy:RegisterCallback(Mouse.eLClick, UnitFormArmy);			
	Controls.CheatButtonDiplo:RegisterCallback(Mouse.eLClick, ChangeDiplomaticFavor);
	Controls.CheatButtonCityHeal:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonEra2:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonDuplicate:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
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
	Controls.CheatButtonHeal:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonEnvoy:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonObs:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonGov:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.CheatButtonDiplo:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ToggleCheatPanel:RegisterCheckHandler(function() UpdateCheatPanel(not m_hideCheatPanel); end);
	Controls.ToggleCheatPanel:SetCheck(true);
	UpdateCheatPanel(true);
end

-- // ----------------------------------------------------------------------------------------------
-- // Init
-- // ----------------------------------------------------------------------------------------------
function Initialize()
	m_IsLoading = true;
		Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
		Events.LoadGameViewStateDone.Add(InitDropdown);
		Events.InputActionTriggered.Add( OnInputActionTriggered );
		ContextPtr:SetInputHandler( OnInputHandler, true );
		InitializeControls();
		if  GameConfiguration.IsNetworkMultiplayer() then
			UpdateCheatPanel(true);
			Controls.ToggleCheatPanel:SetHide(true);
		else
			UpdateCheatPanel(false);
		end
	m_IsLoading = false;
end
Initialize();