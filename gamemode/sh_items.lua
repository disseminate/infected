GM.Items = { };

local files = file.Find( GM.FolderName .. "/gamemode/items/*.lua", "LUA", "namedesc" );

if( #files > 0 ) then
	
	for _, v in pairs( files ) do
		
		ITEM = { };
		ITEM.Vars = { };
		ITEM.Vars.Uses = 1;
		
		ITEM.Name = "Item";
		ITEM.Desc = "Description";
		ITEM.Model = "models/kleiner.mdl";
		ITEM.W = 1;
		ITEM.H = 1;
		ITEM.RemoveOnUse = false;
		ITEM.OnUse = function( item ) end
		
		if( SERVER ) then
			
			AddCSLuaFile( "items/" .. v );
			
		end
		
		include( v );
		
		ITEM.Class = string.StripExtension( v );
		
		GM.Items[string.StripExtension( v )] = ITEM;
		
	end
	
end