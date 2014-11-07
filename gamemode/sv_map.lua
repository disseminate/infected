function GM:InitPostEntity()
	
	if( self.MapInitPostEntity ) then
		
		self:MapInitPostEntity();
		
	end
	
	self:LoadNavSpots();
	
end

function GM:BreakDoor( door, vel, t )
	
	if( door:GetNoDraw() ) then return end
	
	door:EmitSound( "physics/wood/wood_crate_break" .. math.random( 1, 5 ) .. ".wav" );
	
	door:SetNotSolid( true );
	door:SetNoDraw( true );
	door:Fire( "Lock" );
	
	door:SetDoorHealth( 100 );
	
	local newdoor = ents.Create( "prop_physics" );
	newdoor:SetPos( door:GetPos() );
	newdoor:SetAngles( door:GetAngles() );
	newdoor:SetModel( door:GetModel() );
	newdoor:SetSkin( door:GetSkin() );
	newdoor:Spawn();
	newdoor:GetPhysicsObject():SetVelocity( vel );
	newdoor:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	
	timer.Simple( t, function()
		
		if( door and door:IsValid() ) then
			
			door:Fire( "Unlock" );
			door:SetNotSolid( false );
			door:SetNoDraw( false );
			
		end
		
		if( newdoor and newdoor:IsValid() ) then
			
			newdoor:Remove();
			
		end
		
	end );
	
end
