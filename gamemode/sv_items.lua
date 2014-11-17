local meta = FindMetaTable( "Player" );

function meta:ClearInventory()
	
	self.Inventory = { };
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "';" );
	
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
	
	self.Inventory[item.Key] = item;
	
end

function meta:RemoveItem( key )
	
	self:CheckInventory();
	
	if( !self.Inventory[key] ) then return end
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. self.Inventory[key].X .. "' AND Y = '" .. self.Inventory[key].Y .. "';" );
	
	net.Start( "nRemoveItem" );
		net.WriteFloat( key );
	net.Send( self );
	
	self.Inventory[key] = nil;
	
end
