local meta = FindMetaTable( "Player" );

GM.MetaItems = { };

local files = file.Find( GM.FolderName .. "/gamemode/items/*.lua", "LUA", "namedesc" );

if( #files > 0 ) then
	
	for _, v in pairs( files ) do
		
		ITEM = { };
		ITEM.Vars = { };
		
		ITEM.Name = "Item";
		ITEM.Desc = "Description";
		ITEM.Model = "models/kleiner.mdl";
		ITEM.W = 1;
		ITEM.H = 1;
		
		ITEM.PrimaryWep = false;
		ITEM.SecondaryWep = false;
		
		if( SERVER ) then
			
			AddCSLuaFile( "items/" .. v );
			
		end
		
		include( "items/" .. v );
		
		ITEM.Class = string.StripExtension( v );
		
		GM.MetaItems[string.StripExtension( v )] = ITEM;
		
	end
	
end

function GM:PostGamemodeLoaded()

	for _, v in pairs( weapons.GetList() ) do
		
		if( string.find( v.ClassName, "weapon_inf" ) and ( v.PrimaryWep or v.SecondaryWep ) ) then
			
			ITEM = { };
			ITEM.Vars = { };
			ITEM.Vars.Clip = 0;
			
			ITEM.Name = v.PrintName;
			ITEM.Desc = v.Description or "";
			ITEM.Model = v.WorldModel;
			ITEM.W = v.W or 1;
			ITEM.H = v.H or 1;
			
			ITEM.PrimaryWep = v.PrimaryWep;
			ITEM.SecondaryWep = v.SecondaryWep;
			
			ITEM.CamPos = v.CamPos;
			ITEM.FOV = v.FOV;
			ITEM.LookAt = v.LookAt;
			
			ITEM.Class = v.ClassName;
			
			GAMEMODE.MetaItems[v.ClassName] = ITEM;
			
		end
		
	end
	
end

function GM:GetMetaItem( class )
	
	return self.MetaItems[class];
	
end

function GM:Item( class )
	
	local tab = { };
	tab.Class = class;
	tab.Vars = table.Copy( self:GetMetaItem( class ).Vars or { } ); -- Initialize default variables
	tab.Primary = false;
	tab.Secondary = false;
	
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

function meta:IsInventorySlotOccupiedItemFilter( i, j, w, h, key )
	
	self:CheckInventory();
	
	if( i + w - 1 <= 6 and j + h - 1 <= 10 ) then -- If the item could potentially fit here
		
		local good = true;
		
		for x = 1, w do -- For each cell of the width of the item
			
			for y = 1, h do
				
				if( self:IsInventorySlotOccupied( i + x - 1, j + y - 1, key ) ) then
					
					good = false;
					
				end
				
			end
			
		end
		
		return !good;
		
	end
	
	return true;
	
end

function meta:IsInventorySlotOccupied( x, y, key )
	
	self:CheckInventory();
	
	for _, v in pairs( self.Inventory ) do
		
		if( x >= v.X and x <= v.X + GAMEMODE:GetMetaItem( v.Class ).W - 1 ) then
			
			if( y >= v.Y and y <= v.Y + GAMEMODE:GetMetaItem( v.Class ).H - 1 ) then
				
				if( key and v.Key == key ) then return false end
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

