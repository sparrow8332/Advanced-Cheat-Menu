-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------

include("Cheat_Menu_Panel_Functionsbasic");

-- ===========================================================================

local m_CheatPanelStatebasic:number		= 0;

-- ===========================================================================

function AttachPanelToWorldTracker()
	if (IsLoading) then
		return;
	end
	if not isAttached then
		local worldTrackerPanel:table = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack");		
		Controls.CheatPanelbasic:ChangeParent(worldTrackerPanel);
		worldTrackerPanel:AddChildAtIndex(Controls.CheatPanelbasic, 1);
		worldTrackerPanel:CalculateSize();
		worldTrackerPanel:ReprocessAnchoring();
		isAttached = true;
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
function UpdateCheatPanelbasic(hideCheatPanelbasic:boolean)
	m_hideCheatPanelbasic = hideCheatPanelbasic; 
	Controls.CheatPanelbasic:SetHide(m_hideCheatPanelbasic);
	Controls.ToggleCheatPanelbasic:SetCheck(not m_hideCheatPanelbasic);
end
function InitDropdown()
	local parent = ContextPtr:LookUpControl("/InGame/WorldTracker/CivicsCheckButton",	Controls.PanelStack );
	if parent == nil then return end;
	Controls.CheatPanelStackbasic:ChangeParent(parent);
	parent.ReprocessAnchoring();
	Events.LoadGameViewStateDone.Remove(InitDropdown);
end

-- ====================================================================================================

function OnPanelTitleClickedbasic()
	if(m_CheatPanelStatebasic == 0) then
		UI.PlaySound("Tech_Tray_Slide_Open");
		Controls.CheatPanelbasic:SetSizeY(108);
		Controls.ButtonStackbasic:SetHide(false);
		Controls.ButtonSep2basic:SetHide(false);
		m_CheatPanelStatebasic = 1;
	else
		UI.PlaySound("Tech_Tray_Slide_Closed");
		Controls.CheatPanelbasic:SetSizeY(25);
		Controls.ButtonStackbasic:SetHide(true);
		Controls.ButtonSep2basic:SetHide(true);
		m_CheatPanelStatebasic = 0;
	end	
end
 
local function InitializeControls()
	Controls.HeaderTitlebasic:RegisterCallback(Mouse.eLClick, OnPanelTitleClickedbasic);
	Controls.CheatButtonGoldbasic:RegisterCallback(Mouse.eLClick, ChangeGoldbasic);
	Controls.CheatButtonProductionbasic:RegisterCallback(Mouse.eLClick, CompleteProductionbasic);
	Controls.CheatButtonSciencebasic:RegisterCallback(Mouse.eLClick, CompleteResearchbasic);
	Controls.CheatButtonCulturebasic:RegisterCallback(Mouse.eLClick, CompleteCivicbasic);
	Controls.CheatButtonFaithbasic:RegisterCallback(Mouse.eLClick, ChangeFaithbasic);
	Controls.CheatButtonPopulationbasic:RegisterCallback(Mouse.eLClick, ChangePopulationbasic);
	Controls.CheatButtonPromotebasic:RegisterCallback(Mouse.eLClick, UnitPromotebasic);
	Controls.CheatButtonUnitMVbasic:RegisterCallback(Mouse.eLClick, UnitMovementChangebasic);
	Controls.CheatButtonHealbasic:RegisterCallback(Mouse.eLClick, UnitHealChangebasic);
	Controls.CheatButtonEnvoybasic:RegisterCallback(Mouse.eLClick, ChangeEnvoybasic);
	Controls.CheatButtonGoldbasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonProductionbasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonSciencebasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonCulturebasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonFaithbasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonPopulationbasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonPromotebasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonUnitMVbasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonHealbasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);
	Controls.CheatButtonEnvoybasic:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end);

	Controls.ToggleCheatPanelbasic:RegisterCheckHandler(function() UpdateCheatPanelbasic(not m_hideCheatPanelbasic); end);
	Controls.ToggleCheatPanelbasic:SetCheck(true);
	UpdateCheatPanelbasic(true);
end

-- // ----------------------------------------------------------------------------------------------
-- // Init
-- // ----------------------------------------------------------------------------------------------
function Initialize()
	print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("        Cheat Panel Basic UI Loaded")          
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	IsLoading = true;
		Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone);
		Events.LoadGameViewStateDone.Add(InitDropdown);
		InitializeControls();
		UpdateCheatPanelbasic(false);
	IsLoading = false;
	
end
Initialize();