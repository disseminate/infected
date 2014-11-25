ITEM.Name = "Milk Carton";
ITEM.Desc = "1% milk. Probably spoiled by now.";
ITEM.Model = "models/props_junk/garbage_milkcarton002a.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 1;

ITEM.Vars.Uses = 1;

ITEM.UseHealth = 10;

function ITEM:GetUseText( item )
	
	return "Drink";
	
end

function ITEM:OnUse( item )
end