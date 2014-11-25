ITEM.Name = "Watermelon";
ITEM.Desc = "A large green fruit, implemented in pretty much every RP gamemode.";
ITEM.Model = "models/props_junk/watermelon01.mdl";

ITEM.W = 3;
ITEM.H = 3;

ITEM.Tier = 2;

ITEM.Vars.Uses = 4;

ITEM.UseHealth = 10;

function ITEM:GetUseText( item )
	
	return "Eat (" .. item.Vars.Uses .. "/4)";
	
end

function ITEM:OnUse( item )
end