local meta = FindMetaTable( "Player" );

GM.MetaItems = { };

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
		
		include( "items/" .. v );
		
		ITEM.Class = string.StripExtension( v );
		
		GM.MetaItems[string.StripExtension( v )] = ITEM;
		
	end
	
end

function GM:GetMetaItem( class )
	
	return self.MetaItems[class];
	
end

function GM:Item( class )
	
	local tab = { };
	tab.Class = class;
	tab.Vars = table.Copy( self:GetMetaItem( class ).Vars ); -- Initialize default variables
	
	return tab;
	
end

function meta:CheckInventory()
	
	if( !self.Inventory ) then
		
		self.Inventory = { };
		
	end
	
end

function meta:IsInventorySlotOccupiedItem( i, j, w, h )
	
	self:CheckInventory();
	
	if( i + w - 1 <= 6 and j + h - 1 <= 10 ) then -- If the item could potentially fit here
		
		local good = true;
		
		for x = 1, w do -- For each cell of the width of the item
			
			for y = 1, h do
				
				if( self:IsInventorySlotOccupied( i + x - 1, j + y - 1 ) ) then
					
					good = false;
					
				end
				
			end
			
		end
		
		return !good;
		
	end
	
	return true;
	
end

function meta:IsInventorySlotOccupied( x, y )
	
	self:CheckInventory();
	
	for _, v in pairs( self.Inventory ) do
		
		if( x >= v.X and x <= v.X + GAMEMODE:GetMetaItem( v.Class ).W - 1 ) then
			
			if( y >= v.Y and y <= v.Y + GAMEMODE:GetMetaItem( v.Class ).H - 1 ) then
				
				return true;
				
			end
			
		end
		
	end
	
	return false;
	
end

function meta:GetNextAvailableSlot( w, h )
	
	self:CheckInventory();
	
	for j = 1, 10 do -- For each inventory slot (i, j)
		
		for i = 1, 6 do
			
			if( !self:IsInventorySlotOccupiedItem( i, j, w, h ) ) then
				
				return i, j;
				
			end
			
		end
		
	end
	
	return -1, -1;
	
end

