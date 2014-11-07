local function nNoTarget( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "ERROR: No target specified." );
	
end
net.Receive( "nNoTarget", nNoTarget );

local function nNoTargetFound( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "ERROR: Target not found." );
	
end
net.Receive( "nNoTargetFound", nNoTargetFound );

local function nNoValue( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "ERROR: No value specified." );
	
end
net.Receive( "nNoValue", nNoValue );

local function nNoDuration( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "ERROR: No duration specified." );
	
end
net.Receive( "nNoDuration", nNoDuration );

local function nInvalidValue( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "ERROR: Invalid value specified." );
	
end
net.Receive( "nInvalidValue", nInvalidValue );

local function nKicked( len )
	
	local targ = net.ReadString();
	local ply = net.ReadEntity();
	local r = net.ReadString();
	
	if( r != "" ) then
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, targ .. " was kicked by " .. ply:Nick() .. " (" .. r .. ")." );
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, targ .. " was kicked by " .. ply:Nick() .. "." );
		
	end
	
end
net.Receive( "nKicked", nKicked );

local function nBanned( len )
	
	local targ = net.ReadString();
	local ply = net.ReadEntity();
	local duration = net.ReadFloat();
	local r = net.ReadString();
	
	if( r != "" ) then
		
		if( duration == 0 ) then
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, targ .. " was permabanned by " .. ply:Nick() .. " (" .. r .. ")." );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, targ .. " was banned by " .. ply:Nick() .. " for " .. duration .. " minutes (" .. r .. ")." );
			
		end
		
	else
		
		if( duration == 0 ) then
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, targ .. " was permabanned by " .. ply:Nick() .. "." );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, targ .. " was banned by " .. ply:Nick() .. " for " .. duration .. " minutes." );
			
		end
		
	end
	
end
net.Receive( "nBanned", nBanned );

local function nRemoved( len )
	
	local targ = net.ReadString();
	local ply = net.ReadEntity();
	
	GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, targ .. " was removed by " .. ply:Nick() .. "." );
	
end
net.Receive( "nRemoved", nRemoved );

local function nSetPhysTrust( len )
	
	local targ = net.ReadEntity();
	local ply = net.ReadEntity();
	local val = net.ReadFloat();
	
	if( tobool( val ) ) then
		
		if( targ == LocalPlayer() ) then
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, ply:Nick() .. " gave you phystrust." );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, "You gave phystrust to " .. targ:Nick() .. "." );
			
		end
		
	else
		
		if( targ == LocalPlayer() ) then
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, ply:Nick() .. " removed your phystrust." );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, "You removed phystrust from " .. targ:Nick() .. "." );
			
		end
		
	end
	
end
net.Receive( "nSetPhysTrust", nSetPhysTrust );

local function nSetToolTrust( len )
	
	local targ = net.ReadEntity();
	local ply = net.ReadEntity();
	local val = net.ReadFloat();
	
	if( tobool( val ) ) then
		
		if( targ == LocalPlayer() ) then
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, ply:Nick() .. " gave you tooltrust." );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, "You gave tooltrust to " .. targ:Nick() .. "." );
			
		end
		
	else
		
		if( targ == LocalPlayer() ) then
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, ply:Nick() .. " removed your tooltrust." );
			
		else
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, "You removed tooltrust from " .. targ:Nick() .. "." );
			
		end
		
	end
	
end
net.Receive( "nSetToolTrust", nSetToolTrust );

local function nSetCharCreateFlags( len )
	
	local targ = net.ReadEntity();
	local ply = net.ReadEntity();
	local val = net.ReadString();
	
	if( targ == LocalPlayer() ) then
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, ply:Nick() .. " set your character creation flags to \"" .. val .. "\"." );
		
	else
		
		GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_NOTIFY, "You set " .. targ:Nick() .. "'s character creation flags to \"" .. val .. "\"." );
		
	end
	
end
net.Receive( "nSetCharCreateFlags", nSetCharCreateFlags );

local function nMaxZombies( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "ERROR: Maximum zombies reached (50)." );
	
end
net.Receive( "nMaxZombies", nMaxZombies );

local function SeeAll( ply, cmd, args )
	
	if( !GAMEMODE.SeeAll ) then GAMEMODE.SeeAll = false end
	GAMEMODE.SeeAll = !GAMEMODE.SeeAll;
	
end
concommand.AddAdmin( "rpa_seeall", SeeAll );