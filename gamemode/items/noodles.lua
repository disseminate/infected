ITEM.Name = "Microwave Ramen";
ITEM.Desc = "It's pretty crunchy without water. Still, it makes do.";
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 1;

ITEM.Vars.Uses = 1;

ITEM.UseHealth = 5;

function ITEM:GetUseText( item )
	
	return "Eat";
	
end

function ITEM:OnUse( item )
end