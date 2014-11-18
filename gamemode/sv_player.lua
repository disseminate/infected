local meta = FindMetaTable( "Player" );

function GM:PlayerInitialSpawn( ply )
	
	ply:SetTeam( TEAM_SURVIVOR );
	
	if( !ply:IsBot() ) then
		
		ply:Freeze( true );
		
		ply:SyncOtherPlayers();
		
	end
	
end

function GM:PlayerSpawn( ply )
	
	player_manager.SetPlayerClass( ply, "player_infected" );
	
	ply:SetDuckSpeed( 0.3 );
	ply:SetUnDuckSpeed( 0.3 );
	
	self:SetPlayerSpeed( ply, 100, 200 );
	
	if( ply:PlayerClass() == PLAYERCLASS_INFECTED or ply:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
		
		self:SetPlayerSpeed( ply, 40, 220 );
		
	end
	
	ply:GodDisable();
	ply:SetNoTarget( false );
	ply:SetNoDraw( false );
	ply:SetNotSolid( false );
	
	ply:SetAllowWeaponsInVehicle( true );
	
	ply:SetupHands();
	
	if( !ply.InitialSafeSpawn ) then
		
		ply.InitialSafeSpawn = true;
		self:PlayerInitialSpawnSafe( ply );
		
	end
	
	if( ply:IsBot() ) then
		
		local m = math.random( 0, 1 ) == 0;
		local g = m and MALE or FEMALE;
		
		if( g == MALE ) then
			
			ply:SetRPName( "John Doe" );
			ply:SetDesc( "This bot is in over his head." );
			
		else
			
			ply:SetRPName( "Jane Doe" );
			ply:SetDesc( "This bot is in over her head." );
			
		end
		
		ply:SetModel( table.Random( table.GetKeys( GAMEMODE.SurvivorModels[g] ) ) );
		ply:SetSubMaterial( ply:GetFacemap(), table.Random( GAMEMODE.SurvivorModels[g][ply:GetModel()] ) );
		ply:SetSubMaterial( ply:GetClothesSheet(), table.Random( GAMEMODE.SurvivorClothes[g] ) );
		
		return;
		
	end
	
	if( ply:CharID() > -1 ) then
		
		ply:ResetSubMaterials();
		
		local data = ply:GetDataByCharID( ply:CharID() );
		
		ply:SetModel( data.Model );
		ply:SetSubMaterial( ply:GetFacemap(), data.Face );
		ply:SetSubMaterial( ply:GetClothesSheet(), data.Clothes );
		
		hook.Call( "PlayerSetHandsModel", self, ply, ply:GetHands() );
		
		hook.Call( "PlayerLoadout", self, ply );
		
	end
	
end

function GM:PlayerInitialSpawnSafe( ply )
	
	if( ply:IsBot() ) then return end
	
	ply:SetNotSolid( true );
	ply:SetMoveType( MOVETYPE_NOCLIP );
	ply:SetNoDraw( true );
	
end

function GM:PlayerLoadout( ply )
	
	ply:Give( "weapon_inf_hands" );
	
	if( ply:PhysTrust() or ply:IsAdmin() ) then
		
		ply:Give( "weapon_physgun" );
		
	end
	
	if( ply:ToolTrust() or ply:IsAdmin() ) then
		
		ply:Give( "gmod_tool" );
		
	end
	
end

function GM:PlayerDeathSound( ply )
	
	return true;
	
end

function GM:PlayerAuthed( ply, steamid, uid )
	
	ply:PreloadPlayer();
	
end

function GM:SetupPlayerVisibility( ply, viewent )
	
	if( self.MainIntroCams ) then
		
		AddOriginToPVS( self.MainIntroCams[1][1] );
		
	end
	
end

function GM:PlayerSwitchFlashlight( ply, on )
	
	if( !ply.LastFlashlight ) then ply.LastFlashlight = 0; end
	
	if( CurTime() - ply.LastFlashlight > 0.2 ) then
		
		ply.LastFlashlight = CurTime();
		return true;
		
	end
	
end

function GM:GetFallDamage( ply, speed )
	
	if( ply:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
		
		if( ply:GetModel() == "models/player/odessa.mdl" ) then
			
			return 0;
			
		end
		
	end
	
	return self.BaseClass:GetFallDamage( ply, speed );
	
end

function GM:ScalePlayerDamage( ply, hitgroup, dmg )
	
	local attacker = dmg:GetAttacker();
	local inflictor = dmg:GetInflictor();
	
	if( hitgroup == HITGROUP_HEAD ) then
		
		dmg:ScaleDamage( 2 );
		
	end
	
	if( hitgroup == HITGROUP_LEFTARM or
		hitgroup == HITGROUP_RIGHTARM or
		hitgroup == HITGROUP_LEFTLEG or
		hitgroup == HITGROUP_RIGHTLEG or
		hitgroup == HITGROUP_GEAR ) then
		
		dmg:ScaleDamage( 0.25 );
		
	end
	
	if( attacker:IsPlayer() and inflictor:GetClass() != "weapon_inf_hands" ) then
		
		dmg:ScaleDamage( 0.25 );
		
	end
	
end

function meta:LoadPlayer( data )
	
	self:SetPhysTrust( tobool( data.PhysTrust ) );
	self:SetToolTrust( tobool( data.ToolTrust ) );
	self:SetCharCreateFlags( data.CharCreateFlags );
	
end

function meta:LoadCharacter( id )
	
	self:SetCharID( id );
	self:LoadCharacterData( self:GetDataByCharID( id ) );
	self:LoadItemData( self:GetItemDataByCharID( id ) );
	self:PostLoadCharacter();
	
end

function meta:LoadCharacterData( data )
	
	self:ResetSubMaterials();
	
	self:SetPlayerClass( data.Class );
	
	self:SetRPName( data.Name );
	self:SetDesc( data.Description );
	
	self:SetModel( data.Model );
	self:SetSubMaterial( self:GetFacemap(), data.Face );
	self:SetSubMaterial( self:GetClothesSheet(), data.Clothes );
	
end

function meta:LoadItemData( data )
	
	self.Inventory = { };
	net.Start( "nClearInventory" );
	net.Send( self );
	
	for _, v in pairs( data ) do
		
		if( !v.Class ) then continue; end
		
		local item = GAMEMODE:Item( v.Class );
		
		item.X = v.X;
		item.Y = v.Y;
		item.Owner = self;
		
		item.Primary = tobool( v.PrimaryEquipped );
		item.Secondary = tobool( v.SecondaryEquipped );
		
		if( !self.NextItemKey ) then self.NextItemKey = 1 end
		item.Key = self.NextItemKey;
		self.NextItemKey = self.NextItemKey + 1;
		
		for _, n in pairs( string.Explode( ";", v.Vars ) ) do
			
			local kv = string.Explode( "|", n );
			
			if( tonumber( kv[2] ) ) then
				
				item.Vars[kv[1]] = tonumber( kv[2] );
				
			else
				
				item.Vars[kv[1]] = kv[2];
				
			end
			
		end
		
		if( item.Primary or item.Secondary ) then
			
			self:Give( item.Class );
			
			if( item.Vars.Clip ) then
				
				self:GetWeapon( item.Class ):SetClip1( item.Vars.Clip );
				
			end
			
		end
		
		net.Start( "nGiveItem" );
			net.WriteTable( item );
		net.Send( self );
		
		self.Inventory[item.Key] = item;
		
	end
	
end

function meta:PostLoadCharacter()
	
	self:Freeze( false );
	
	self:SetNotSolid( false );
	self:SetMoveType( MOVETYPE_WALK );
	self:SetNoDraw( false );
	
	self:Spawn();
	
end

local function nCreateCharacter( len, ply )
	
	local class = net.ReadFloat();
	local name = net.ReadString();
	local desc = net.ReadString();
	local model = net.ReadString();
	local face = net.ReadString();
	local clothes = net.ReadString();
	
	local ret, reason = GAMEMODE:CheckValidCharacter( ply, class, name, desc, model, face, clothes );
	
	if( ret ) then
		
		ply:SaveNewCharacter( class, name, desc, model, face, clothes );
		
	else
		
		MsgC( COLOR_ERROR, "ERROR: Could not create character (\"" .. reason .. "\").\n" );
		
	end
	
end
net.Receive( "nCreateCharacter", nCreateCharacter );

local function nSelectCharacter( len, ply )
	
	local id = net.ReadFloat();
	ply:LoadCharacter( id );
	
end
net.Receive( "nSelectCharacter", nSelectCharacter );

local function nDeleteCharacter( len, ply )
	
	local id = net.ReadFloat();
	ply:DeleteCharacter( id );
	
end
net.Receive( "nDeleteCharacter", nDeleteCharacter );

local function nChangeName( len, ply )
	
	local name = net.ReadString();
	
	if( string.len( name ) >= GAMEMODE.MinNameLength and string.len( name ) <= GAMEMODE.MaxNameLength ) then
		
		ply:SetRPName( name );
		ply:UpdateCharacterField( "Name", name );
		
	end
	
end
net.Receive( "nChangeName", nChangeName );

local function nChangeDesc( len, ply )
	
	local desc = net.ReadString();
	
	if( string.len( desc ) <= GAMEMODE.MaxDescLength ) then
		
		ply:SetDesc( desc );
		ply:UpdateCharacterField( "Description", desc );
		
	end
	
end
net.Receive( "nChangeDesc", nChangeDesc );

local function nSetTyping( len, ply )
	
	local f = math.floor( net.ReadFloat() );
	
	if( f < 0 or f > 2 ) then return end
	
	ply:SetTyping( f );
	
end
net.Receive( "nSetTyping", nSetTyping );

local function nSetExpression( len, ply )
	
	local mode = net.ReadFloat();
	
	if( mode == 1 ) then
		
		ply:PlayScene( "scenes/expressions/citizen_scared_idle_01.vcd", 0 );
		
	elseif( mode == 2 ) then
		
		ply:PlayScene( "scenes/expressions/citizen_angry_idle_01.vcd", 0 );
		
	elseif( mode == 3 ) then
		
		ply:PlayScene( "scenes/expressions/citizen_angry_combat_01.vcd", 0 );
		
	end
	
end
net.Receive( "nSetExpression", nSetExpression );