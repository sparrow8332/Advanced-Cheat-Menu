-- // ----------------------------------------------------------------------------------------------
-- // Author: Sparrow
-- // DateCreated: 01/24/2019 2:27:04 PM
-- // ----------------------------------------------------------------------------------------------
include("Cheat_Menu_Panel_Functions");

-- // ----------------------------------------------------------------------------------------------
-- // CHEAT MENU CONTROL
-- // ----------------------------------------------------------------------------------------------
local m_CheatMenuState:number		= 0;

local function Hide()
	ContextPtr:SetHide(true);
	UI.PlaySound("UI_Pause_Menu_On");
	if not Controls.SpawnDlgContainer:IsHidden() then
		Controls.SpawnDlg_Anim:Reverse();	
		Controls.SpawnDlgContainer:SetHide( true );
	end
	m_CheatMenuState = 0;
end
local function Show()
	ContextPtr:SetHide(false);
	UI.PlaySound("Tech_Tray_Slide_Open");
	if Controls.SpawnDlgContainer:IsHidden() then
		Controls.SpawnDlg_Anim:SetToBeginning();
		Controls.SpawnDlg_Anim:Play();
		Controls.SpawnDlgContainer:SetHide( false );
	end
	m_CheatMenuState = 1;
end
function OnMenuButtonToggle()
    if(m_CheatMenuState == 0) then
		Show();	
	else
		Hide();
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
	end;
	return false;
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
		Controls.SpawnDlgContainer:SetHide( true );
end
function Initialize()
		
		ContextPtr:SetInputHandler( OnInputHandler, true );
		Events.InputActionTriggered.Add( OnInputActionTriggered );
		LuaEvents.EndGameMenu_Shown.Add( Hide );
		LuaEvents.DiplomacyActionView_HideIngameUI.Add( Hide );
		LuaEvents.WonderRevealPopup_Shown.Add( Hide );
		LuaEvents.NaturalWonderPopup_Shown.Add( Hide );
		LuaEvents.MinimapBar_RegisterAdditions.Add(OnRegisterMinimapBarAdditions);
		LuaEvents.MinimapBar_CustomButtonClicked.Add(OnMinimapBarCustomButtonClicked);

		OnRegisterMinimapBarAdditions();
		InitializeControls();
end
Initialize();