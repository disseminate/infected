function GM:Think()
	
	self:DrawNavmesh();
	
	self:AIThink();
	self:VehicleThink();
	self:ViewOffsetThink();
	
end

function GM:ViewOffsetThink()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:GetViewOffset() != v:GetModelDef().ViewOffset ) then
			
			v:SetViewOffset( v:GetModelDef().ViewOffset );
			
		end
		
		if( v:GetViewOffsetDucked() != v:GetModelDef().ViewOffsetDucked ) then
			
			v:SetViewOffsetDucked( v:GetModelDef().ViewOffsetDucked );
			
		end
		
	end
	
end