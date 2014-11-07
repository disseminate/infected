function GM:Think()
	
	if( self.IntroMode == 3 ) then
		
		if( #self.CharData[LocalPlayer():SteamID()] > 0 ) then
			
			self.IntroMode = 4;
			
			self:CharCreateSelect();
			
		else
			
			self.IntroMode = 4;
			self:CharCreate( CHARCREATE_SURVIVOR );
			
		end
		
	end
	
	self:CharCreateThink();
	self:ToggleHolsterThink();
	self:MusicThink();
	
end