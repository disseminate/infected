ITEM.Name = "Banana";
ITEM.Desc = "It's a yellow fruit. It's mushy and bruised.";
ITEM.Model = "models/props/cs_italy/bananna.mdl";

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