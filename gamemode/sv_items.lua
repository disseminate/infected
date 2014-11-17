local meta = FindMetaTable( "Player" );

function meta:ClearInventory()
	
	self.Inventory = { };
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "';" );
	GAMEMODE.ItemData[self:SteamID()][self:CharID()] = { };
	
	net.Start( "nClearInventory" );
	net.Send( self );
	
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
	
	if( !self.NextItemKey ) then self.NextItemKey = 1 end
	item.Key = self.NextItemKey;
	self.NextItemKey = self.NextItemKey + 1;
	
	net.Start( "nGiveItem" );
		net.WriteTable( item );
	net.Send( self );
	
	local varstr = "";
	for k, v in pairs( item.Vars ) do
		varstr = varstr .. k .. "|" .. v .. ";"
	end
	
	mysqloo.Query( "INSERT INTO items ( SteamID, CharID, Class, X, Y, Vars ) VALUES ( '" .. self:SteamID() .. "', '" .. self:CharID() .. "', '" .. item.Class .. "', '" .. item.X .. "', '" .. item.Y .. "', '" .. varstr .. "' )" );
	
	table.insert( self:GetItemDataByCharID( self:CharID() ), {
		CharID = self:CharID(),
		Class = item.Class,
		SteamID = self:SteamID(),
		Vars = varstr,
		X = item.X,
		Y = item.Y
	} );
	
	self.Inventory[item.Key] = item;
	
end

function meta:RemoveItem( key )
	
	self:CheckInventory();
	
	if( !self.Inventory[key] ) then return end
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. self.Inventory[key].X .. "' AND Y = '" .. self.Inventory[key].Y .. "';" );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == self.Inventory[key].X and v.Y == self.Inventory[key].Y ) then
			
			self:GetItemDataByCharID( self:CharID() )[k] = nil;
			
		end
		
	end
	
	net.Start( "nRemoveItem" );
		net.WriteFloat( key );
	net.Send( self );
	
	self.Inventory[key] = nil;
	
end

function meta:MoveItem( key, x, y )
	
	self:CheckInventory();
	
	if( !self.Inventory[key] ) then return end
	
	if( self:IsInventorySlotOccupiedItemFilter( x, y, GAMEMODE:GetMetaItem( self.Inventory[key].Class ).W, GAMEMODE:GetMetaItem( self.Inventory[key].Class ).H, key ) ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '" .. x .. "', Y = '" .. y .. "' WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. self.Inventory[key].X .. "' AND Y = '" .. self.Inventory[key].Y .. "';" );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == self.Inventory[key].X and v.Y == self.Inventory[key].Y ) then
			
			v.X = x;
			v.Y = y;
			
		end
		
	end
	
	net.Start( "nMoveItem" );
		net.WriteFloat( key );
		net.WriteFloat( x );
		net.WriteFloat( y );
	net.Send( self );
	
	self.Inventory[key].X = x;
	self.Inventory[key].Y = y;
	
end

function meta:UseItem( key )
	
	self:CheckInventory();
	
	if( !self.Inventory[key] ) then return end
	
	local item = self.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	metaitem:OnUse( item );
	
	if( item.Vars.Uses ) then
		
		item.Vars.Uses = item.Vars.Uses - 1;
		
		if( item.Vars.Uses == 0 ) then
			
			self:RemoveItem( key );
			
		else
			
			self:UpdateItemVars( key );
			
		end
		
	end
	
end

local function nMoveItem( len, ply )
	
	local key = net.ReadFloat();
	local x = net.ReadFloat();
	local y = net.ReadFloat();
	
	ply:MoveItem( key, x, y );
	
end
net.Receive( "nMoveItem", nMoveItem );

local function nUseItem( len, ply )
	
	local key = net.ReadFloat();
	
	ply:UseItem( key );
	
end
net.Receive( "nUseItem", nUseItem );

local function nDestroyItem( len, ply )
	
	local key = net.ReadFloat();
	
	ply:RemoveItem( key );
	
end
net.Receive( "nDestroyItem", nDestroyItem );
