ITEM.Name = "Orange";
ITEM.Desc = "It's an orange fruit. It's probably spoiled, but it's still food.";
ITEM.Model = "models/props/cs_italy/orange.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 1;

ITEM.Vars.Uses = 1;

ITEM.UseHealth = 15;

function ITEM:GetUseText( item )
	
	return "Eat";
	
end

function ITEM:OnUse( item )
end