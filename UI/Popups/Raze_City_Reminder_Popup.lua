local g_pSelectedCity;

function OnButton1()
	local tParameters = {};
	tParameters[UnitOperationTypes.PARAM_FLAGS] = 0;
	if (CityManager.CanStartCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters)) then
		UI.DeselectAllCities();
		CityManager.RequestCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters);
	end
	OnClose();
end
function OnButton2()
	local tParameters = {};
	tParameters[UnitOperationTypes.PARAM_FLAGS] = 1;
	if (CityManager.CanStartCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters)) then
		UI.DeselectAllCities();
		CityManager.RequestCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters);
	end
	OnClose();
end
function OnButton3()
	local tParameters = {};
	tParameters[UnitOperationTypes.PARAM_FLAGS] = 2;
	if (CityManager.CanStartCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters)) then
		CityManager.RequestCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters);
	end
	OnClose();
end
function OnButton4()
	local tParameters = {};
	tParameters[UnitOperationTypes.PARAM_FLAGS] = 3;
	if (CityManager.CanStartCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters)) then
		UI.DeselectAllCities();
		CityManager.RequestCommand( g_pSelectedCity, CityCommandTypes.DESTROY, tParameters);
       UI.PlaySound("RAZE_CITY");
	end
	OnClose();
end
function OnClose()
  UIManager:DequeuePopup( ContextPtr );
  ContextPtr:SetHide(true);
end

function ShowRazeCityReminderPopup(player:number)
	local localPlayerID = Game.GetLocalPlayer();
	local localPlayer = Players[localPlayerID];
	if (localPlayer == nil) then
		return;
	end 
	g_pSelectedCity  = UI.GetHeadSelectedCity();
	Controls.PanelHeader:LocalizeAndSetText("LOC_DESTROY_CITY_HEADER");
    Controls.CityHeader:LocalizeAndSetText("LOC_RAZE_CITY_NAME_LABEL");
    Controls.CityName:LocalizeAndSetText(g_pSelectedCity:GetName());
    Controls.CityPopulation:LocalizeAndSetText("LOC_RAZE_CITY_POPULATION_LABEL");
    Controls.NumPeople:SetText(tostring(g_pSelectedCity:GetPopulation()));
    Controls.CityDistricts:LocalizeAndSetText("LOC_DESTROY_CITY_DISTRICTS_LABEL");
	local iNumDistricts = g_pSelectedCity:GetDistricts():GetNumZonedDistrictsRequiringPopulation();
    Controls.NumDistricts:SetText(tostring(iNumDistricts));
	local szWarmongerString;
	local eOriginalOwner = g_pSelectedCity:GetOriginalOwner();
	local originalOwnerPlayer = Players[eOriginalOwner];
	local eOwnerBeforeOccupation = g_pSelectedCity:GetOwnerBeforeOccupation();
	local bWipedOut = (originalOwnerPlayer:GetCities():GetCount() < 1);
	local eLastTransferType = g_pSelectedCity:GetLastTransferType();
	if (localPlayer:GetDiplomacy():CanLiberateCityTo(eOwnerBeforeOccupation)) then
		Controls.Button2:LocalizeAndSetText("LOC_RAZE_CITY_LIBERATE_FOUNDER_BUTTON_LABEL", PlayerConfigurations[eOwnerBeforeOccupation]:GetCivilizationShortDescription());
		Controls.Button2:LocalizeAndSetToolTip("LOC_DESTROY_CITY_LIBERATE_EXPLANATION");
		Controls.Button2:SetHide(false);
	else
		Controls.Button2:SetHide(true);
	end
	Controls.Button3:LocalizeAndSetText("LOC_RAZE_CITY_KEEP_BUTTON_LABEL");
	if (eLastTransferType == CityTransferTypes.BY_GIFT) then
		Controls.Button3:LocalizeAndSetToolTip("LOC_KEEP_CITY_EXPLANATION");
	elseif (bWipedOut ~= true) then
		Controls.Button3:LocalizeAndSetToolTip("LOC_KEEP_CITY_EXPLANATION");
	else
		Controls.Button3:LocalizeAndSetToolTip("LOC_KEEP_CITY_EXPLANATION");
	end
	Controls.Button4:LocalizeAndSetText("LOC_RAZE_CITY_RAZE_BUTTON_LABEL");
	if g_pSelectedCity:IsCapital() then
		Controls.Button4:LocalizeAndSetToolTip("LOC_RAZE_CITY_RAZE_DISABLED_EXPLANATION");
		Controls.Button4:SetDisabled(true);
	else
		Controls.Button4:LocalizeAndSetToolTip("LOC_RAZE_CITY_EXPLANATION");
		Controls.Button4:SetDisabled(false);
	end
	Controls.PopupStack:CalculateSize();
	Controls.PopupStack:ReprocessAnchoring();
	Controls.RazeCityPanel:ReprocessAnchoring();
	ContextPtr:SetHide(false);
	ContextPtr:SetInputHandler(OnInputHandler);
end
function OnInputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyUp then
        if wParam == Keys.VK_ESCAPE then
            OnClose();
        end
    end
    return true;
end
function OnShowRazeCityReminderPopup( player:number, civic:number)
  if player == Game.GetLocalPlayer() then
    ShowRazeCityReminderPopup(player);
    UIManager:QueuePopup( ContextPtr, PopupPriority.Current);
  end
end

function Initialize()
	ContextPtr:SetHide(true)
	ContextPtr:SetInputHandler( OnInputHandler, true );
	Controls.Button1:RegisterCallback(Mouse.eLClick, OnButton1);
	Controls.Button2:RegisterCallback(Mouse.eLClick, OnButton2);
	Controls.Button3:RegisterCallback(Mouse.eLClick, OnButton3);
	Controls.Button4:RegisterCallback(Mouse.eLClick, OnButton4);
	LuaEvents.NotificationPanel_OpenRazeCityChooser.Add(OnShowRazeCityReminderPopup);
	Controls.ModalScreenClose:RegisterCallback(Mouse.eLClick, OnClose);
	LuaEvents.ShowRazeCityReminderPopup.Add(OnShowRazeCityReminderPopup);
	if ( not ExposedMembers.MOD_CheatMenu) then ExposedMembers.MOD_CheatMenu = {}; end
	ExposedMembers.MOD_CheatMenu.DestroyCity = OnShowRazeCityReminderPopup;
	ExposedMembers.MOD_CheatMenu_Initialized = true;
end
Initialize();
