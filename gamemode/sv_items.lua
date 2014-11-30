local meta = FindMetaTable( "Player" );

function meta:ClearInventory()
	
	for _, v in pairs( self.Inventory ) do
		
		if( v.Primary or v.Secondary ) then
			
			self:StripWeapon( v.Class );
			
		end
		
	end
	
	self:SetPrimaryWeaponModel( "" );
	self:SetSecondaryWeaponModel( "" );
	
	self.Inventory = { };
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "';" );
	
	GAMEMODE.ItemData[self:SteamID()][self:CharID()] = { };
	
	net.Start( "nClearInventory" );
	net.Send( self );
	
end

function meta:GiveItemVars( class, vars )
	
	if( self:CheckInventory() ) then return end
	
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
	
	if( self:CheckInventory() ) then return end
	
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
	
	if( self:CheckInventory() ) then return end
	
	if( !self.Inventory[key] ) then return end
	
	mysqloo.Query( "DELETE FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. self.Inventory[key].X .. "' AND Y = '" .. self.Inventory[key].Y .. "';" );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == self.Inventory[key].X and v.Y == self.Inventory[key].Y ) then
			
			self:GetItemDataByCharID( self:CharID() )[k] = nil;
			
		end
		
	end
	
	local metaitem = GAMEMODE:GetMetaItem( self.Inventory[key].Class );
	
	if( metaitem.PrimaryWep or metaitem.SecondaryWep ) then
		
		self:StripWeapon( self.Inventory[key].Class );
		
		if( metaitem.PrimaryWep ) then
			
			self:SetPrimaryWeaponModel( "" );
			
		else
			
			self:SetSecondaryWeaponModel( "" );
			
		end
		
	end
	
	net.Start( "nRemoveItem" );
		net.WriteFloat( key );
	net.Send( self );
	
	self.Inventory[key] = nil;
	
end

function meta:MoveItem( key, x, y )
	
	if( self:CheckInventory() ) then return end
	
	if( !self.Inventory[key] ) then return end
	
	local item = self.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( item.Primary ) then
		
		self:MoveItemEquipped( key, x, y, true );
		return;
		
	elseif( item.Secondary ) then
		
		self:MoveItemEquipped( key, x, y, false );
		return;
		
	end
	
	if( self:IsInventorySlotOccupiedItemFilter( x, y, metaitem.W, metaitem.H, key ) ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '" .. x .. "', Y = '" .. y .. "' WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = x;
			v.Y = y;
			
		end
		
	end
	
	net.Start( "nMoveItem" );
		net.WriteFloat( key );
		net.WriteFloat( x );
		net.WriteFloat( y );
	net.Send( self );
	
	item.X = x;
	item.Y = y;
	
end

function meta:MoveItemEquipped( key, x, y, p )
	
	if( !self.Inventory[key] ) then return end
	
	local metaitem = GAMEMODE:GetMetaItem( self.Inventory[key].Class );
	
	if( self:IsInventorySlotOccupiedItemFilter( x, y, metaitem.W, metaitem.H, key ) ) then return end
	
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
	
	if( metaitem.PrimaryWep ) then
		
		self:SetPrimaryWeaponModel( "" );
		
	else
		
		self:SetSecondaryWeaponModel( "" );
		
	end
	
end

function meta:UseItem( key )
	
	if( self:CheckInventory() ) then return end
	
	if( !self.Inventory[key] ) then return end
	
	local item = self.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.OnUse ) then return end
	
	metaitem:OnUse( item );
	
	if( metaitem.UseHealth ) then
		
		self:SetHealth( math.Clamp( self:Health() + metaitem.UseHealth, 0, self:GetMaxHealth() ) );
		
	end
	
	if( metaitem.UseSound ) then
		
		self:EmitSound( metaitem.UseSound );
		
	end
	
	if( item.Vars.Uses ) then
		
		if( item.Vars.Uses > 0 ) then
			
			item.Vars.Uses = item.Vars.Uses - 1;
			
			if( item.Vars.Uses == 0 and metaitem.RemoveOnUse ) then
				
				self:RemoveItem( key );
				
			else
				
				self:UpdateItemVars( key );
				
			end
			
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

function GM:NumItems()
	
	local c = 0;
	
	for _, v in pairs( ents.FindByClass( "inf_item" ) ) do
		
		if( v:GetAutospawn() ) then
			
			c = c + 1;
			
		end
		
	end
	
	return c;
	
end

function GM:ItemThink()
	
	if( #self.NavHideSpots > 0 ) then
		
		if( !self.NextSpawnItem ) then self.NextSpawnItem = CurTime() end
		
		if( CurTime() >= self.NextSpawnItem ) then
			
			self.NextSpawnItem = CurTime() + 120;
			self:SpawnItemRandom();
			
		end
		
		for _, v in pairs( ents.FindByClass( "inf_item" ) ) do
			
			if( v:GetAutospawn() and CurTime() >= v:GetAutospawnTime() + 600 ) then
				
				if( !self:CanPlayerSeeZombieAt( v:GetPos() ) ) then
					
					v:Remove();
					
				end
				
			end
			
		end
		
	end
	
end

function GM:SpawnItemRandom()
	
	local rarity = math.random( 1, 100 );
	local item;
	
	if( rarity > 98 ) then -- Ammo: 2%
		
		item = self:GetItemByTier( 5 );
		
	elseif( rarity > 94 ) then -- Primary weapons: 4%
		
		item = self:GetItemByTier( 4 );
		
	elseif( rarity > 85 ) then -- Secondary weapons: 9%
		
		item = self:GetItemByTier( 3 );
		
	elseif( rarity > 50 ) then -- Tier 2: 35%
		
		item = self:GetItemByTier( 2 );
		
	else -- Tier 1: 50%
		
		item = self:GetItemByTier( 1 );
		
	end
	
	if( !item ) then
		
		self:Log( "autospawn", "E", "Couldn't autospawn item - no item of tier!" );
		return;
		
	end
	
	local tab = { };
	
	for _, v in pairs( self.Nodes ) do
		
		if( self:IsSpotClear( v ) and !self:CanPlayerSeeZombieAt( v ) ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	if( #tab == 0 ) then
		
		self:Log( "autospawn", "E", "Couldn't autospawn item - no nodes!" );
		return;
		
	end
	
	local pos = table.Random( tab );
	
	local ent = self:CreateItemEnt( pos, Angle( 0, math.random( -180, 180 ), 0 ), item );
	ent:SetAutospawn( true );
	ent:SetAutospawnTime( CurTime() );
	
	self:Log( "autospawn", "A", "Created item " .. item .. " at Vector( " .. math.Round( pos.x ) .. ", " .. math.Round( pos.y ) .. ", " .. math.Round( pos.z ) .. " )." );
	
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
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.PrimaryWep ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', PrimaryEquipped = '1', SecondaryEquipped = '0' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Primary = true;
			v.Secondary = false;
			
		end
		
	end
	
	item.X = 0;
	item.Y = 0;
	item.Primary = true;
	item.Secondary = false;
	
	ply:Give( item.Class );
	ply:SetPrimaryWeaponModel( metaitem.Model );
	
	if( item.Vars.Clip ) then
		
		ply:GetWeapon( item.Class ):SetClip1( item.Vars.Clip );
		
	end
	
end
net.Receive( "nEquipPrimary", nEquipPrimary );

local function nEquipSecondary( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !metaitem.SecondaryWep ) then return end
	
	mysqloo.Query( "UPDATE items SET X = '0', Y = '0', PrimaryEquipped = '0', SecondaryEquipped = '1' WHERE SteamID = '" .. ply:SteamID() .. "' AND CharID = '" .. ply:CharID() .. "' AND X = '" .. item.X .. "' AND Y = '" .. item.Y .. "';" );
	
	for k, v in pairs( ply:GetItemDataByCharID( ply:CharID() ) ) do
		
		if( v.X == item.X and v.Y == item.Y ) then
			
			v.X = 0;
			v.Y = 0;
			v.Primary = false;
			v.Secondary = true;
			
		end
		
	end
	
	item.X = 0;
	item.Y = 0;
	item.Primary = false;
	item.Secondary = true;
	
	ply:Give( item.Class );
	ply:SetSecondaryWeaponModel( metaitem.Model );
	
	if( item.Vars.Clip ) then
		
		ply:GetWeapon( item.Class ):SetClip1( item.Vars.Clip );
		
	end
	
end
net.Receive( "nEquipSecondary", nEquipSecondary );

local function nUnloadItem( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	local item = ply.Inventory[key];
	local metaitem = GAMEMODE:GetMetaItem( item.Class );
	
	if( !item.Vars.Clip ) then return end
	if( item.Vars.Clip <= 0 ) then return end
	
	local x, y = ply:GetNextAvailableSlot( metaitem.W, metaitem.H );
	
	if( x > 0 and y > 0 ) then
		
		ply:GiveItemVars( weapons.Get( item.Class ).ItemAmmo, { Ammo = item.Vars.Clip } );
		
		item.Vars.Clip = 0;
		ply:UpdateItemVars( key );
		
		local wep = ply:GetWeapon( item.Class );
		
		if( wep and wep:IsValid() ) then
			
			wep:SetClip1( 0 );
			
		end
		
	end
	
end
net.Receive( "nUnloadItem", nUnloadItem );
