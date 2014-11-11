ITEM.Name = "Watermelon";
ITEM.Desc = "A large green fruit, implemented in pretty much every RP gamemode.";
ITEM.Model = "models/props_junk/watermelon.mdl";

ITEM.W = 3;
ITEM.H = 3;

ITEM.Vars.Uses = 4;

ITEM.RemoveOnUse = true;

ITEM.OnUse = function( item )
	
	if( SERVER ) then
		
		item.Owner:SetHealth( item.Owner:Health() + 10 );
		-- Play a sound
		
	end
	
end