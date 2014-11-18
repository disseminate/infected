local function nToggleHolster( len, ply )
	
	if( ply:GetActiveWeapon() != NULL ) then
		
		if( ply:GetActiveWeapon().Holsterable ) then
			
			ply:SetHolstered( !ply:Holstered() );
			
		else
			
			ply:SetHolstered( false );
			
		end
		
	end
	
end
net.Receive( "nToggleHolster", nToggleHolster );

local function nSelectWeapon( len, ply )
	
	local class = net.ReadString();
	ply:SelectWeapon( class );
	
end
net.Receive( "nSelectWeapon", nSelectWeapon );