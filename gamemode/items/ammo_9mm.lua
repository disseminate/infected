ITEM.Name = "9mm Rounds";
ITEM.Desc = "Ammunition for firearms chambered in 9mm.";
ITEM.Model = "models/Items/BoxSRounds.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 5;

ITEM.Vars.Ammo = 30;

function ITEM:GetDesc( item )
	
	local str = "Ammunition for firearms chambered in 9mm.\n\n";
	str = str .. "There are " .. item.Vars.Ammo .. " rounds left.";
	
	return str;
	
end