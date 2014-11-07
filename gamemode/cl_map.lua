function GM:InitPostEntity()
	
	if( self.MapClientInitPostEntity ) then
		
		self:MapClientInitPostEntity();
		
	end
	
end

function GM:OnEntityCreated( e )
	
	if( e:GetClass() == "class C_ClientRagdoll" or e:GetClass() == "class C_HL2MPRagdoll" ) then
		
		if( e:GetRagdollOwner() and e:GetRagdollOwner():IsValid() ) then
			
			for i = 0, 4 do
				
				e:SetSubMaterial( i, e:GetRagdollOwner():GetSubMaterial( i ) );
				
			end
			
		end
		
	end
	
end