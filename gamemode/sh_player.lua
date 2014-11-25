local meta = FindMetaTable( "Player" );

function GM:SetupMove( ply, mv, cmd )
	
	if( !ply or !ply:IsValid() ) then return end
	
	if( ply:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
		
		if( ply:GetModel() == "models/player/odessa.mdl" ) then
			
			if( mv:KeyPressed( IN_JUMP ) and ply:OnGround() and !mv:KeyDown( IN_USE ) ) then
				
				local dot = ply:GetAimVector():Dot( Vector( ply:GetAimVector().x, ply:GetAimVector().y, 0 ):GetNormal() );
				local mul = dot / 3 + 0.66;
				
				mv:SetVelocity( ply:GetAimVector() * 1300 * mul );
				
			end
			
		end
		
	end
	
end

function GM:PlayerFootstep( ply, pos, foot, s, vol, rf )
	
	if( ply:PlayerClass() == PLAYERCLASS_MILITARY ) then
		
		if( ply:GetVelocity():Length2D() > 150 ) then
			if( foot == 0 ) then
				ply:EmitSound( "NPC_MetroPolice.RunFootstepLeft" );
			else
				ply:EmitSound( "NPC_MetroPolice.RunFootstepRight" );
			end
		else
			if( foot == 0 ) then
				ply:EmitSound( "NPC_MetroPolice.FootstepLeft" );
			else
				ply:EmitSound( "NPC_MetroPolice.FootstepRight" );
			end
		end
		
		return;
		
	end
	
	self.BaseClass:PlayerFootstep( ply, pos, foot, s, vol, rf );
	
end

function meta:IsZombie()
	
	return ( self:PlayerClass() == PLAYERCLASS_INFECTED or self:PlayerClass() == PLAYERCLASS_SPECIALINFECTED );
	
end