ITEM.Name = "Buckshot";
ITEM.Desc = "Ammunition for tube-fed firearms.";
ITEM.Model = "models/Items/BoxBuckshot.mdl";

ITEM.W = 1;
ITEM.H = 1;

ITEM.Tier = 5;

ITEM.Vars.Ammo = 12;

function ITEM:GetDesc( item )
	
	local str = "Ammunition for tube-fed firearms.\n\n";
	str = str .. "There are " .. item.Vars.Ammo .. " rounds left.";
	
	return str;
	
end