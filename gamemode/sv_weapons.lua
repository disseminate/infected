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
