local meta = FindMetaTable( "Player" );

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
	
	if( !ply.NextWeaponSwap ) then ply.NextWeaponSwap = CurTime() end
	
	if( CurTime() >= ply.NextWeaponSwap ) then
		
		local class = net.ReadString();
		ply:SelectWeapon( class );
		
		ply.NextWeaponSwap = CurTime() + 0.1;
		
	end
	
end
net.Receive( "nSelectWeapon", nSelectWeapon );

local function nReload( len, ply )
	
	local key = net.ReadFloat();
	
	if( !ply.Inventory[key] ) then return end
	
	ply:GetActiveWeapon():ReloadItem( ply.Inventory[key], GAMEMODE:GetMetaItem( ply.Inventory[key].Class ) );
	
end
net.Receive( "nReload", nReload );