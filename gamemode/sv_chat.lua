local function nSay( len, ply )
	
	local arg = net.ReadString();
	
	if( string.len( arg ) <= 0 or string.len( arg ) > 500 ) then return end
	
	GAMEMODE:OnChat( ply, arg );
	
end
net.Receive( "nSay", nSay );