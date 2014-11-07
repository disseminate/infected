GM.ChatCommands = { };

function GM:AddChatCommand( cmd, col, func )
	
	table.insert( self.ChatCommands, { cmd, col, func } );
	
end

function GM:GetChatCommand( text )
	
	local tab = self.ChatCommands;
	
	table.sort( tab, function( a, b )
		
		return string.len( a[1] ) > string.len( b[1] );
		
	end );
	
	for _, v in pairs( tab ) do
		
		if( text ) then
			
			if( string.find( string.lower( text ), string.lower( v[1] ), nil, true ) == 1 ) then
				
				return v;
				
			end
			
		end
		
	end
	
	return false;
	
end

function GM:OnChat( ply, text )
	
	if( self:GetChatCommand( text ) ) then
		
		local cc = self:GetChatCommand( text );
		local f = string.Trim( string.sub( text, string.len( cc[1] ) + 1 ) );
		
		if( SERVER ) then
			
			local ret = cc[3]( ply, f, nil, cc );
			
			net.Start( "nSay" );
				net.WriteEntity( ply );
				net.WriteString( text );
			net.Send( ret );
			
		else
			
			if( ply == LocalPlayer() ) then
				
				cc[3]( ply, f, true, cc );
				
			else
				
				cc[3]( ply, f, nil, cc );
				
			end
			
		end
		
	else
		
		if( text == "" ) then return end
		
		if( SERVER ) then
			
			for _, v in pairs( GAMEMODE:ZombiesInSphere( ply:GetPos(), 500 ) ) do
				
				v.LastShot = ply;
				
			end
			
			local rf = { };
			
			for _, v in pairs( player.GetAllBut( ply ) ) do
				
				if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
					
					table.insert( rf, v );
					
				end
				
			end
			
			net.Start( "nCCLocal" );
				net.WriteEntity( ply );
				net.WriteString( text );
			net.Send( rf );
			
			self:Log( "chat", " ", ply:RPName() .. ": " .. text, ply );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", Color( 255, 255, 255, 255 ), ply:RPName() .. ": " .. text, nil, ply );
			
		end
		
	end
	
end

if( CLIENT ) then

	local function nCCLocal( len )
		
		local ply = net.ReadEntity();
		local arg = net.ReadString();
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", Color( 255, 255, 255, 255 ), ply:RPName() .. ": " .. arg, nil, ply );
		
	end
	net.Receive( "nCCLocal", nCCLocal );
	
end

local function ccWhisper( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		for _, v in pairs( GAMEMODE:ZombiesInSphere( ply:GetPos(), 200 ) ) do
			
			v.LastShot = ply;
			
		end
		
		GAMEMODE:Log( "chat", "W", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 200 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatSmall", cc[2], "[Whisper] " .. ply:RPName() .. ": " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/w", Color( 200, 200, 200, 255 ), ccWhisper );

local function ccYell( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		for _, v in pairs( GAMEMODE:ZombiesInSphere( ply:GetPos(), 1000 ) ) do
			
			v.LastShot = ply;
			
		end
		
		GAMEMODE:Log( "chat", "Y", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 1000 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatBig", cc[2], "[Yell] " .. ply:RPName() .. ": " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/y", Color( 255, 0, 0, 255 ), ccYell );

local function ccMe( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "M", ply:RPName() .. " " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormalI", cc[2], ply:RPName() .. " " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/me", Color( 255, 170, 50, 255 ), ccMe );

local function ccIt( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "I", "[" .. ply:RPName() .. "] " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormalI", cc[2], arg, "[" .. ply:RPName() .. "] ", ply );
		
	end
	
end
GM:AddChatCommand( "/it", Color( 255, 150, 20, 255 ), ccIt );

local function ccLocalOOC( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "o", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:GetPos():Distance( ply:GetPos() ) < 500 ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", cc[2], "[LOOC] " .. ply:RPName() .. ": " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "[[", Color( 170, 211, 255, 255 ), ccLocalOOC );

local function ccOOC( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "O", ply:RPName() .. ": " .. arg, ply );
		
		return player.GetAllBut( ply );
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", cc[2], "[OOC] " .. ply:RPName() .. ": " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "//", Color( 130, 190, 255, 255 ), ccOOC );

local function ccAdmin( ply, arg, l, cc )
	
	if( arg == "" ) then return end
	
	if( SERVER ) then
		
		GAMEMODE:Log( "chat", "A", ply:RPName() .. ": " .. arg, ply );
		
		local rf = { };
		
		for _, v in pairs( player.GetAllBut( ply ) ) do
			
			if( v:IsAdmin() ) then
				
				table.insert( rf, v );
				
			end
			
		end
		
		return rf;
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", cc[2], "[Admin] " .. ply:RPName() .. ": " .. arg, nil, ply );
		
	end
	
end
GM:AddChatCommand( "/a", Color( 255, 70, 70, 255 ), ccAdmin );
