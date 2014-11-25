ITEM.Name = "Jug of Orange Juice";
ITEM.Desc = "Unfortunately, it has pulp.";
ITEM.Model = "models/props_junk/garbage_milkcarton001a.mdl";

ITEM.W = 2;
ITEM.H = 2;

ITEM.Tier = 2;

ITEM.Vars.Uses = 2;

ITEM.UseHealth = 10;

function ITEM:GetUseText( item )
	
	return "Drink (" .. item.Vars.Uses .. "/2)";
	
end

function ITEM:OnUse( item )
end