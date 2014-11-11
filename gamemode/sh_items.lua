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
		
		include( v );
		
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
	tab.Vars = self:GetMetaItem( class ).Vars; -- Initialize default variables
	
	return tab;
	
end

function meta:CheckInventory()
	
	if( !self.Inventory ) then
		
		self.Inventory = { };
		
	end
	
end

function meta:IsInventorySlotOccupied( x, y )
	
	self:CheckInventory();
	
	for _, v in pairs( self.Inventory ) do
		
		if( x > v.X and x <= v.X + GAMEMODE:GetMetaItem( v.Class ).W ) then
			
			if( y > v.Y and y <= v.Y + GAMEMODE:GetMetaItem( v.Class ).H ) then
				
				return true;
				
			end
			
		end
		
	end
	
	return false;
	
end

function meta:GetNextAvailableSlot( w, h )
	
	self:CheckInventory();
	
	local x = 1;
	local y = 1;
	
	for i = 1, 6 do
		
		for j = 1, 10 do
			
			if( !self:IsInventorySlotOccupied( i, j ) ) then
				
				local good = true;
				
				if( x + w <= 6 or y + h <= 10 ) then
					
					for x = 1, w do
						
						for y = 1, h do
							
							if( self:IsInventorySlotOccupied( x, y ) ) then
								
								good = false;
								
							end
							
						end
						
					end
					
					if( good ) then
						
						return i, j;
						
					end
					
				end
				
			end
			
		end
		
	end
	
	return -1, -1;
	
end

function meta:GiveItem( item )
	
	self:CheckInventory();
	
	if( type( item ) == "string" ) then
		
		item = GAMEMODE:Item( item );
		
	end
	
	local x, y = self:GetNextAvailableSlot( GAMEMODE:GetMetaItem( item.Class ).W, GAMEMODE:GetMetaItem( item.Class ).H );
	
	item.X = x;
	item.Y = y;
	item.Owner = self;
	
	table.insert( self.Inventory, item );
	
end
