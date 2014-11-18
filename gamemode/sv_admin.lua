local function Kick( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local reason = args[2] or "";
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nKicked" );
			net.WriteString( targ:Nick() );
			net.WriteEntity( ply );
			net.WriteString( reason );
		net.Broadcast();
		
		GAMEMODE:Log( "admin", "K", ply:Nick() .. " kicked " .. targ:Nick() .. " (" .. reason .. ").", ply );
		
		if( reason == "" ) then
			
			targ:Kick( "Kicked by " .. ply:Nick() );
			
		else
			
			targ:Kick( "Kicked by " .. ply:Nick() .. ": " .. reason );
			
		end
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_kick", Kick );

local function Ban( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoDuration" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local duration = math.Round( tonumber( args[2] ) ) or 5;
	local reason = args[3] or "";
	
	if( duration < 0 ) then
		
		ply:SendNet( "nInvalidValue" );
		return;
		
	end
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nBanned" );
			net.WriteString( targ:Nick() );
			net.WriteEntity( ply );
			net.WriteFloat( duration );
			net.WriteString( reason );
		net.Broadcast();
		
		GAMEMODE:AddBan( targ:SteamID(), duration * 60, reason );
		
		GAMEMODE:Log( "admin", "B", ply:Nick() .. " banned " .. targ:Nick() .. " for " .. duration .. " minutes (" .. reason .. ").", ply );
		
		if( reason == "" ) then
			
			if( duration == 0 ) then
				
				targ:Kick( "Permabanned by " .. ply:Nick() );
				
			else
				
				targ:Kick( "Banned for " .. duration .. " minutes by " .. ply:Nick() );
				
			end
			
		else
			
			if( duration == 0 ) then
				
				targ:Kick( "Permabanned by " .. ply:Nick() .. ": " .. reason );
				
			else
				
				targ:Kick( "Banned for " .. duration .. " minutes by " .. ply:Nick() .. ": " .. reason );
				
			end
			
		end
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_ban", Ban );

local function Goto( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
		
		ply:SetPos( targ:GetPos() );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_goto", Goto );

local function Bring( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
		
		targ:SetPos( ply:GetPos() );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_bring", Bring );

local function SetPhysTrust( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = tonumber( args[2] );
	
	if( val != 0 and val != 1 ) then
		
		ply:SendNet( "nInvalidValue" );
		return;
		
	end
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetPhysTrust" );
			net.WriteEntity( targ );
			net.WriteEntity( ply );
			net.WriteFloat( val );
		net.Send( { targ, ply } );
		
		targ:SetPhysTrust( tobool( val ) );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s phystrust to " .. tostring( val ) .. ".", ply );
		
		if( tobool( val ) ) then
			
			targ:Give( "weapon_physgun" );
			
		else
			
			targ:StripWeapon( "weapon_physgun" );
			
		end
		
		targ:UpdatePlayerField( "PhysTrust", tostring( val ) );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_setphystrust", SetPhysTrust );

local function SetToolTrust( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = tonumber( args[2] );
	
	if( val != 0 and val != 1 ) then
		
		ply:SendNet( "nInvalidValue" );
		return;
		
	end
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetToolTrust" );
			net.WriteEntity( targ );
			net.WriteEntity( ply );
			net.WriteFloat( val );
		net.Send( { targ, ply } );
		
		targ:SetToolTrust( tobool( val ) );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s tooltrust to " .. tostring( val ) .. ".", ply );
		
		if( tobool( val ) ) then
			
			targ:Give( "gmod_tool" );
			
		else
			
			targ:StripWeapon( "gmod_tool" );
			
		end
		
		targ:UpdatePlayerField( "ToolTrust", tostring( val ) );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_settooltrust", SetToolTrust );

local function SetCharCreateFlags( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	if( #args < 2 ) then
		
		ply:SendNet( "nNoValue" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	local val = string.lower( args[2] );
	
	if( targ and targ:IsValid() ) then
		
		net.Start( "nSetCharCreateFlags" );
			net.WriteEntity( targ );
			net.WriteEntity( ply );
			net.WriteString( val );
		net.Send( { targ, ply } );
		
		GAMEMODE:Log( "admin", "P", ply:Nick() .. " set " .. targ:Nick() .. "'s charcreate flags to " .. tostring( val ) .. ".", ply );
		
		targ:SetCharCreateFlags( val );
		targ:UpdatePlayerField( "CharCreateFlags", val );
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_setcharcreateflags", SetCharCreateFlags );

local function CreateItem( ply, cmd, args )
	
	if( !args[1] ) then
		
		net.Start( "nItemsList" );
			net.WriteString( "" );
		net.Send( ply );
		return;
		
	end
	
	if( !GAMEMODE:GetMetaItem( args[1] ) ) then
		
		net.Start( "nItemsList" );
			net.WriteString( args[1] );
		net.Send( ply );
		return;
		
	end
	
	GAMEMODE:CreateItemEnt( ply:EyePos() + ply:GetAimVector() * 50, Angle(), args[1] );
	
end
concommand.AddAdmin( "rpa_createitem", CreateItem );

local function AddSeeds( ply, cmd, args )
	
	GAMEMODE:Log( "admin", "Z", ply:Nick() .. " added walkable seeds.", ply );
	GAMEMODE:AddSeeds();
	
end
concommand.AddAdmin( "rpa_addseeds", AddSeeds, true );

local function GenerateNavmesh( ply, cmd, args )
	
	GAMEMODE:Log( "admin", "Z", ply:Nick() .. " generated a navmesh.", ply );
	GAMEMODE:GenerateNavmesh();
	
end
concommand.AddAdmin( "rpa_generatenavmesh", GenerateNavmesh, true );

local function CreateZombie( ply, cmd, args )
	
	if( GAMEMODE:NumZombies() > 50 ) then
		
		ply:SendNet( "nMaxZombies" );
		return;
		
	end
	
	GAMEMODE:Log( "admin", "Z", ply:Nick() .. " created a zombie.", ply );
	
	local z = ents.Create( "inf_zombie" );
	z:SetPos( ply:GetEyeTrace().HitPos );
	z:SetAngles( Angle( 0, math.random( -180, 180 ), 0 ) );
	z:Spawn();
	z:Activate();
	
end
concommand.AddAdmin( "rpa_createzombie", CreateZombie );

local function SendZombiesTo( ply, cmd, args )
	
	if( #args < 1 ) then
		
		ply:SendNet( "nNoTarget" );
		return;
		
	end
	
	local targ = ply:FindPlayer( args[1] );
	
	if( targ and targ:IsValid() ) then
		
		for _, v in pairs( ents.FindByClass( "inf_zombie" ) ) do
			
			v.LastShot = targ;
			
		end
		
	else
		
		ply:SendNet( "nNoTargetFound" );
		
	end
	
end
concommand.AddAdmin( "rpa_sendzombiesto", SendZombiesTo );