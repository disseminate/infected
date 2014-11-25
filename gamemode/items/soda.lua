ITEM.Name = "Soda";
ITEM.Desc = "Unhealthy for you in the long term. Tastes pretty good, though.";
ITEM.Model = "models/props_junk/PopCan01a.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 1;

ITEM.Vars.Uses = 1;

ITEM.UseHealth = 5;

function ITEM:GetUseText( item )
	
	return "Drink";
	
end

function ITEM:OnUse( item )
end