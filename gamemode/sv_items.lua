local meta = FindMetaTable( "Player" );

function meta:ClearInventory()
	
	for _, v in pairs( self.Inventory ) do
		
		if( v.Primary or v.Secondary ) then
			
			self:StripWeapon( v.Class );
			
		end
		
	end
	
	self.Inventory = { };
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "';" );
	
	GAMEMODE.ItemData[self:SteamID()][self:CharID()] = { };
	
	net.Start( "nClearInventory" );
	net.Send( self );
	
end

function meta:GiveItemVars( class, vars )
	
	self:CheckInventory();
	
	local item = GAMEMODE:Item( class );
	
	local x, y = self:GetNextAvailableSlot( GAMEMODE:GetMetaItem( item.Class ).W, GAMEMODE:GetMetaItem( item.Class ).H );
	
	item.X = x;
	item.Y = y;
	item.Owner = self;
	
	if( vars and vars != { } ) then
		item.Vars = table.Copy( vars );
	end
	
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
	
	local p = tonumber( item.Primary );
	local s = tonumber( item.Secondary );
	
	if( !p ) then p = 0 end
	if( !s ) then s = 0 end
	
	mysqloo.Query( "INSERT INTO items ( SteamID, CharID, Class, X, Y, PrimaryEquipped, SecondaryEquipped, Vars ) VALUES ( '" .. self:SteamID() .. "', '" .. self:CharID() .. "', '" .. item.Class .. "', '" .. item.X .. "', '" .. item.Y .. "', '" .. p .. "', '" .. s .. "', '" .. varstr .. "' )" );
	
	table.insert( self:GetItemDataByCharID( self:CharID() ), {
		CharID = self:CharID(),
		Class = item.Class,
		SteamID = self:SteamID(),
		Vars = varstr,
		X = item.X,
		Y = item.Y,
		Primary = item.Primary,
		Secondary = item.Secondary,
	} );
	
	self.Inventory[item.Key] = item;
	
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
	
	local p = tonumber( item.Primary );
	local s = tonumber( item.Secondary );
	
	if( !p ) then p = 0 end
	if( !s ) then s = 0 end
	
	mysqloo.Query( "INSERT INTO items ( SteamID, CharID, Class, X, Y, PrimaryEquipped, SecondaryEquipped, Vars ) VALUES ( '" .. self:SteamID() .. "', '" .. self:CharID() .. "', '" .. item.Class .. "', '" .. item.X .. "', '" .. item.Y .. "', '" .. p .. "', '" .. s .. "', '" .. varstr .. "' )" );
	
	table.insert( self:GetItemDataByCharID( self:CharID() ), {
		CharID = self:CharID(),
		Class = item.Class,
		SteamID = self:SteamID(),
		Vars = varstr,
		X = item.X,
		Y = item.Y,
		Primary = item.Primary,
		Secondary = item.Secondary
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
	
	if( self:GetMetaItem( self.Inventory[key].Class ).PrimaryWep or self:GetMetaItem( self.Inventory[key].Class ).SecondaryWep ) then
		
		self:StripWeapon( self.Inventory[key].Class );
		
	end
	
	net.Start( "nRemoveItem" );
		net.WriteFloat( key );
	net.Send( self );
	
	self.Inventory[key] = nil;
	
end

function meta:MoveItem( key, x, y )
	
	self:CheckInventory();
	
	if( !self.Inventory[key] ) then return end
	
	if( self.Inventory[key].Primary ) then
		
		self:MoveItemEquipped( key, x, y, true );
		return;
		
	elseif( self.Inventory[key].Secondary ) then
		
		self:MoveItemEquipped( key, x, y, false );
		return;
		
	end
	
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

function meta:MoveItemEquipped( key, x, y, p )
	
	if( self:IsInventorySlotOccupiedItemFilter( x, y, GAMEMODE:GetMetaItem( self.Inventory[key].Class ).W, GAMEMODE:GetMetaItem( self.Inventory[key].Class ).H, key ) ) then return end
	
	local primary = "PrimaryEquipped = '1'";
	
	if( !p ) then
		
		primary = "SecondaryEquipped = '1'";
		
	end
	
	mysqloo.Query( "UPDATE items SET X = '" .. x .. "', Y = '" .. y .. "', PrimaryEquipped = '0', SecondaryEquipped = '0' WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND " .. primary );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == self.Inventory[key].X and v.Y == self.Inventory[key].Y ) then
			
			v.X = x;
			v.Y = y;
			v.Primary = false;
			v.Secondary = false;
			
		end
		
	end
	
	net.Start( "nMoveItem" );
		net.WriteFloat( key );
		net.WriteFloat( x );
		net.WriteFloat( y );
	net.Send( self );
	
	self.Inventory[key].X = x;
	self.Inventory[key].Y = y;
	self.Inventory[key].Primary = false;
	self.Inventory[key].Secondary = false;
	
	self:StripWeapon( self.Inventory[key].Class );
	
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

function GM:CreateItemEnt( pos, ang, class, vars )
	
	local ent = ents.Create( "inf_item" );
	ent:SetPos( pos );
	ent:SetAngles( ang );
	ent:SetItemClass( class );
	
	if( vars ) then
		
		ent:SetVars( vars );
		
	else
		
		ent:SetVars( self:Item( class ).Vars );
		
	end
	
	ent:Spawn();
	ent:Activate();
	
	return ent;
	
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

local function nDropItem( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	GAMEMODE:CreateItemEnt( ply:EyePos() + ply:GetAimVector() * 50, Angle(), ply.Inventory[key].Class, ply.Inventory[key].Vars );
	ply:RemoveItem( key );
	
end
net.Receive( "nDropItem", nDropItem );

local function nDestroyItem( len, ply )
	
	local key = net.ReadFloat();
	
	ply:RemoveItem( key );
	
end
net.Receive( "nDestroyItem", nDestroyItem );

local function nEquipPrimary( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	if( !GAMEMODE:GetMetaItem( ply.Inventory[key].Class ).PrimaryWep ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', PrimaryEquipped = '1', SecondaryEquipped = '0' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. ply.Inventory[key].X .. "' AND Y = '" .. ply.Inventory[key].Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == ply.Inventory[key].X and v.Y == ply.Inventory[key].Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Primary = true;
			v.Secondary = false;
			
		end
		
	end
	
	ply.Inventory[key].X = 0;
	ply.Inventory[key].Y = 0;
	ply.Inventory[key].Primary = true;
	ply.Inventory[key].Secondary = false;
	
	ply:Give( ply.Inventory[key].Class );
	
	if( ply.Inventory[key].Vars.Clip ) then
		
		ply:GetWeapon( ply.Inventory[key].Class ):SetClip1( ply.Inventory[key].Vars.Clip );
		
	end
	
end
net.Receive( "nEquipPrimary", nEquipPrimary );

local function nEquipSecondary( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	if( !GAMEMODE:GetMetaItem( ply.Inventory[key].Class ).SecondaryWep ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', PrimaryEquipped = '0', SecondaryEquipped = '1' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. ply.Inventory[key].X .. "' AND Y = '" .. ply.Inventory[key].Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == ply.Inventory[key].X and v.Y == ply.Inventory[key].Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Primary = false;
			v.Secondary = true;
			
		end
		
	end
	
	ply.Inventory[key].X = 0;
	ply.Inventory[key].Y = 0;
	ply.Inventory[key].Primary = false;
	ply.Inventory[key].Secondary = true;
	
	ply:Give( ply.Inventory[key].Class );
	
	if( ply.Inventory[key].Vars.Clip ) then
		
		ply:GetWeapon( ply.Inventory[key].Class ):SetClip1( ply.Inventory[key].Vars.Clip );
		
	end
	
end
net.Receive( "nEquipSecondary", nEquipSecondary );
