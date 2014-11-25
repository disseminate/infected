ITEM.Name = "Liquor";
ITEM.Desc = "40% ABV alcohol. It burns when you drink it, and can sanitize wounds in a pinch.";
ITEM.Model = "models/props_junk/garbage_glassbottle002a.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 2;

ITEM.Vars.Uses = 1;

ITEM.UseHealth = 5;

function ITEM:GetUseText( item )
	
	return "Drink";
	
end

function ITEM:OnUse( item )
end