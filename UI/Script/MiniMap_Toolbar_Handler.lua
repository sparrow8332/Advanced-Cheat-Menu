-- ============================= --
--	Copyright 2019 FiatAccompli  --
-- ============================= --

local minimapBarButtons = {};

function UpdateMinimapWoodBackgroundSize()
  local minimapBar = ContextPtr:LookUpControl("/InGame/MinimapPanel/OptionsStack");
  local minimapWoodBackground = ContextPtr:LookUpControl("/InGame/MinimapPanel/MinimapBacking");
  if minimapWoodBackground and minimapBar then
    minimapBar:CalculateSize();
    minimapBar:ReprocessAnchoring();
    minimapWoodBackground:SetSizeX(minimapBar:GetSizeX() + 75);
  end
end

function OnAddMinimapBarButton(buttonInfo:table) 
  local buttonId = buttonInfo.Id;
  local buttonInstance = minimapBarButtons[buttonId];
  if not buttonInstance then
    buttonInstance = {};
    ContextPtr:BuildInstanceForControl("MinimapBarButtonInstance", buttonInstance, Controls.AdditionalButtons);
    minimapBarButtons[buttonId] = buttonInstance;
    UpdateMinimapWoodBackgroundSize();
  end
  if buttonInfo.Icon then
    buttonInstance.Image:SetIcon(buttonInfo.Icon);
  else
	  buttonInstance.Image:SetTexture(buttonInfo.Texture);
  end
  buttonInstance.Image:SetColor(buttonInfo.Color or 0xFFFFFFFF);
	buttonInstance.Button:LocalizeAndSetToolTip(buttonInfo.Tooltip or "");
	buttonInstance.Button:RegisterCallback(Mouse.eLClick, 
      function()
        LuaEvents.MinimapBar_CustomButtonClicked(buttonId);
      end);
	buttonInstance.Button:RegisterCallback(Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
end
function InitializeUI() 
  local buttonsHolder = Controls.AdditionalButtons;
  local minimapBar = ContextPtr:LookUpControl("/InGame/MinimapPanel/OptionsStack");
  buttonsHolder:ChangeParent(minimapBar);
  UpdateMinimapWoodBackgroundSize();
  LuaEvents.MinimapBar_RegisterAdditions();
end
function OnInit(isReload:boolean)
  if isReload then
    InitializeUI();
  end
end
function OnShutdown()
  local buttonsHolder = Controls.AdditionalButtons;
  buttonsHolder:ChangeParent(ContextPtr);
  UpdateMinimapWoodBackgroundSize();
end

-- ===========================================================================
function Initialize()
  ContextPtr:SetInitHandler(OnInit);
  ContextPtr:SetShutdown(OnShutdown);
  LuaEvents.MinimapBar_AddButton.Add(OnAddMinimapBarButton);
  Events.LoadScreenClose.Add(InitializeUI);
end
print("Sparrow's Cheat Menu Fully initialized!");

Initialize();