function concommand.AddAdmin( cmd, cb, sa )
	
	local function f( ply, cmd, args )
		
		if( sa ) then
			
			if( ply:IsSuperAdmin() ) then
				
				cb( ply, cmd, args );
				
			end
			
			return;
			
		end
		
		if( ply:IsAdmin() ) then
			
			cb( ply, cmd, args );
			
		end
		
	end
	concommand.Add( cmd, f );
	
end

function GM:PlayerNoClip( ply )
	
	if( !ply:IsAdmin() ) then
		
		if( CLIENT and IsFirstTimePredicted() ) then
			
			--GAMEMODE:AddChat( Color( 200, 0, 0, 255 ), "CombineControl.ChatNormal", "You need to be an admin to do this.", { CB_ALL, CB_OOC } );
			
		end
		
		return false;
		
	end
	
	if( SERVER ) then
		
		if( ply:IsEFlagSet( EFL_NOCLIP_ACTIVE ) ) then
			
			ply:GodDisable();
			ply:SetNoTarget( false );
			ply:SetNoDraw( false );
			ply:SetNotSolid( false );
			
			if( ply:GetActiveWeapon() != NULL ) then
				
				ply:GetActiveWeapon():SetNoDraw( false );
				ply:GetActiveWeapon():SetColor( Color( 255, 255, 255, 255 ) );
				
			end
			
		else
			
			ply:GodEnable();
			ply:SetNoTarget( true );
			ply:SetNoDraw( true );
			ply:SetNotSolid( true );
			
			if( ply:GetActiveWeapon() != NULL ) then
				
				ply:GetActiveWeapon():SetNoDraw( true );
				ply:GetActiveWeapon():SetColor( Color( 255, 255, 255, 0 ) );
				
			end
			
		end
		
	end
	
	return true;
	
end