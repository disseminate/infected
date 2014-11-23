ITEM.Name = "5.56mm Rounds";
ITEM.Desc = "Ammunition for firearms chambered in 5.56mm.";
ITEM.Model = "models/Items/BoxSRounds.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 5;

ITEM.Vars.Ammo = 60;

function ITEM:GetDesc( item )
	
	local str = "Ammunition for firearms chambered in 5.56mm.\n\n";
	str = str .. "There are " .. item.Vars.Ammo .. " rounds left.";
	
	return str;
	
end