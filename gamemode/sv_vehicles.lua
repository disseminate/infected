function GM:VehicleThink( v )
	
	if( v:InVehicle() and v:GetVehicle():GetVelocity():Length2D() > 5 ) then
		
		local veh = v:GetVehicle();
		
		for _, n in pairs( GAMEMODE:ZombiesInSphere( veh:GetPos(), 500 ) ) do
			
			n.LastShot = v;
			
		end
		
		if( veh:GetTable().VehicleTable.Name == "Jalopy" and veh:GetVelocity():Length2D() > 100 ) then
			
			local enttab = ents.FindInSphere( veh:GetPos() + veh:GetForward() * 70, 80 );
			
			for _, v in pairs( enttab ) do
				
				if( v:GetClass() == "inf_zombie" ) then
					
					--v:SetVehicleKilled( true );
					v:TakeDamage( 100, veh, v );
					
				end
				
			end
			
		end
		
	end
	
end