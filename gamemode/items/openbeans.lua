ITEM.Name = "Opened Canned Beans";
ITEM.Desc = "A staple of post-apocalyptic diet. Someone's had some already.";
ITEM.Model = "models/props_junk/garbage_metalcan002a.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 1;

ITEM.Vars.Uses = 1;

ITEM.UseHealth = 10;

function ITEM:GetUseText( item )
	
	return "Eat";
	
end

function ITEM:OnUse( item )
end