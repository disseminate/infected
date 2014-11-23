ITEM.Name = "Beer";
ITEM.Desc = "A generic 4% ABV domestic beer.";
ITEM.Model = "models/props_junk/garbage_glassbottle003a.mdl";

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