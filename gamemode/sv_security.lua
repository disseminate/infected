GM.PrivateMode = false;

GM.PrivateSteamIDs = {
	STEAMID_DISSEMINATE,
};

GM.ClosedMessage = ":~)";

function GM:CheckPassword( steamid, networkid, svpass, pass, name )
	
	if( self.Bans ) then
		
		for k, v in pairs( self.Bans ) do
			
			if( v.Unban == 0 and util.SteamIDTo64( k ) == steamid ) then
				
				if( tonumber( v.Length ) == 0 ) then
					
					return false, "You're permabanned" .. reason;
					
				else
					
					return false, "You're banned for " .. ( v.Date + v.Length * 60 ) - os.time() .. " more minutes" .. reason;
					
				end
				
			end
			
		end
		
	end
	
	if( self.PrivateMode ) then
		
		if( !table.HasValue( self.PrivateSteamIDs, util.SteamIDFrom64( steamid ) ) ) then
			
			MsgC( Color( 128, 128, 128, 255 ), "Blocked player " .. name .. " (" .. util.SteamIDFrom64( steamid ) .. "): Private testing is enabled.\n" );
			return false, self.ClosedMessage;
			
		end
		
	end
	
	if( svpass != "" ) then
		
		if( pass != svpass ) then
			
			return false, "#GameUI_ServerRejectBadPassword";
			
		end
		
	end
	
	return true;
	
end