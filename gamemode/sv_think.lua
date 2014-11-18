function GM:Think()
	
	self:DrawNavmesh();
	
	self:AIThink();
	
	for _, v in pairs( player.GetAll() ) do
		
		self:VehicleThink( v );
		self:ViewOffsetThink( v );
		
		if( !v.NextSaveClips ) then v.NextSaveClips = 0; end
		
		if( CurTime() >= v.NextSaveClips ) then
			
			v:SaveWeaponClips();
			v.NextSaveClips = CurTime() + 10;
			
		end
		
	end
	
end

function GM:ViewOffsetThink( v )
	
	if( v:GetViewOffset() != v:GetModelDef().ViewOffset ) then
		
		v:SetViewOffset( v:GetModelDef().ViewOffset );
		
	end
	
	if( v:GetViewOffsetDucked() != v:GetModelDef().ViewOffsetDucked ) then
		
		v:SetViewOffsetDucked( v:GetModelDef().ViewOffsetDucked );
		
	end
	
end