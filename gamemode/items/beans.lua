ITEM.Name = "Canned Beans";
ITEM.Desc = "A staple of post-apocalyptic diet.";
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 1;

ITEM.Vars.Uses = 2;

ITEM.UseHealth = 10;

function ITEM:GetUseText( item )
	
	return "Eat (" .. item.Vars.Uses .. "/2)";
	
end

function ITEM:OnUse( item )
end