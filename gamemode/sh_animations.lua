function GM:CalcMainActivity( ply, vel )
	
	self.BaseClass:CalcMainActivity( ply, vel );
	
	self:CalcSpecialActivity( ply, vel );
	
	return ply.CalcIdeal, ply.CalcSeqOverride;
	
end

GM.ZombieAnimTab = { };
GM.ZombieAnimTab[ACT_MP_STAND_IDLE] = 1703;
GM.ZombieAnimTab[ACT_MP_WALK] = 1628;
GM.ZombieAnimTab[ACT_MP_RUN] = 1621;
GM.ZombieAnimTab[ACT_MP_CROUCH_IDLE] = 1706;
GM.ZombieAnimTab[ACT_MP_CROUCHWALK] = 1633;

function GM:CalcSpecialActivity( ply, vel )
	
	if( ply:PlayerClass() == PLAYERCLASS_INFECTED ) then
		
		if( self.ZombieAnimTab[ply.CalcIdeal] ) then
			
			ply.CalcIdeal = self.ZombieAnimTab[ply.CalcIdeal];
			
		end
		
	end
	
	if( ply:PlayerClass() == PLAYERCLASS_SPECIALINFECTED and ply:GetModel() == "models/player/odessa.mdl" ) then
		
		if( self.ZombieAnimTab[ply.CalcIdeal] ) then
			
			ply.CalcIdeal = self.ZombieAnimTab[ply.CalcIdeal];
			
		end
		
		if( ply.CalcIdeal == 1621 ) then
			
			ply.CalcIdeal = 1646;
			
		end
		
		if( ply.CalcIdeal == 1628 ) then
			
			ply.CalcIdeal = 1647;
			
		end
		
		if( ply.CalcIdeal == 1703 ) then
			
			ply.CalcIdeal = 1647;
			
		end
		
	end
	
end