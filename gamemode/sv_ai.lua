function GM:AddSeeds()
	
	if( self.GeneratingNavmesh ) then return end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:OnGround() and v:GetGroundEntity() == game.GetWorld() ) then
			
			local trace = { };
			trace.start = v:GetPos();
			trace.endpos = trace.start - Vector( 0, 0, 1 );
			trace.filter = v;
			local tr = util.TraceLine( trace );
			
			navmesh.AddWalkableSeed( v:GetPos(), tr.HitNormal );
			
		end
		
	end
	
end

function GM:GenerateNavmesh()
	
	if( self.GeneratingNavmesh ) then return end
	
	self.GeneratingNavmesh = true;
	
	navmesh.BeginGeneration();
	
end

function GM:DrawNavmesh()
	
	if( true ) then return end
	
	for _, v in pairs( player.GetAll() ) do
		
		local nav = navmesh.Find( v:GetEyeTrace().HitPos, 500, 50, 50 );
		
		for _, n in pairs( nav ) do
			
			n:Draw();
			n:DrawSpots();
			
		end
		
	end
	
end

GM.NavHideSpots = { };

function GM:LoadNavSpots()
	
	self.NavHideSpots = { };
	
	local rootent = ents.FindByClass( "info_player_start" )[1];
	local areas = navmesh.Find( rootent:GetPos(), 32768, 16384, 16384 );
	
	for k, v in pairs( areas ) do
		
		local vec = v:GetHidingSpots();
		
		for _, n in pairs( vec ) do
			
			table.insert( self.NavHideSpots, n );
			
		end
		
	end
	
end

GM.Nodes = { };

function GM:AIThink()
	
	if( #self.NavHideSpots == 0 ) then
		
		self:LoadNavSpots();
		
	end
	
	if( #self.NavHideSpots > 0 and self:NumZombies() < ( self.MaxAutospawnZombies or 30 ) ) then
		
		if( !self.NextSpawnZombie ) then self.NextSpawnZombie = CurTime() end
		
		if( CurTime() >= self.NextSpawnZombie ) then
			
			self.NextSpawnZombie = CurTime() + 0.1;
			self:SpawnZombieRandom();
			
		end
		
	end
	
	if( !self.NextNodeCheck ) then self.NextNodeCheck = CurTime() end
	
	if( CurTime() >= self.NextNodeCheck ) then
		
		local shouldSave = false;
		
		for _, v in pairs( player.GetBots() ) do
			
			if( v:Alive() and v:OnGround() and v:GetGroundEntity() == game.GetWorld() ) then
				
				local trace = { };
				trace.start = v:EyePos();
				trace.endpos = trace.start + Vector( 0, 0, 32768 );
				trace.filter = v;
				local tr = util.TraceLine( trace );
				
				if( tr.HitSky ) then
					
					local goodtrace = true;
					
					for _, n in pairs( { Vector( 1, 0, 0 ), Vector( -1, 0, 0 ), Vector( 0, 1, 0 ), Vector( 0, -1, 0 ) } ) do
						
						local trace = { };
						trace.start = v:EyePos();
						trace.endpos = trace.start + n * 16;
						trace.filter = v;
						local tr = util.TraceLine( trace );
						
						if( tr.HitWorld ) then goodtrace = false end
						
					end
					
					if( goodtrace ) then
						
						local pos = v:GetPos();
						local good = true;
						
						for _, v in pairs( self.Nodes ) do
							
							if( pos:Distance( v ) < 128 ) then
								
								good = false;
								break;
								
							end
							
						end
						
						if( good ) then
							
							table.insert( self.Nodes, pos );
							shouldSave = true;
							
						end
						
					end
					
				end
				
			end
			
		end
		--[[
		for _, v in pairs( self.Nodes ) do
			
			debugoverlay.Line( v - Vector( 16, 0, 0 ), v + Vector( 16, 0, 0 ), 0.1, Color( 255, 200, 0, 255 ), true );
			debugoverlay.Line( v - Vector( 0, 16, 0 ), v + Vector( 0, 16, 0 ), 0.1, Color( 255, 200, 0, 255 ), true );
			debugoverlay.Line( v, v + Vector( 0, 0, 72 ), 0.1, Color( 255, 200, 0, 255 ), true );
			
		end
		--]]
		if( shouldSave ) then
			
			self:SaveNodes();
			MsgN( "Saved " .. #self.Nodes .. " nodes." );
			
		end
		
		self.NextNodeCheck = CurTime() + 0.1;
		
	end
	
end

function GM:SaveNodes()
	
	local write = "";
	
	for _, v in pairs( self.Nodes ) do
		
		write = write .. tostring( v ) .. "\n";
		
	end
	
	file.Write( "Infected/nodes/" .. game.GetMap() .. ".txt", write );
	
end

function GM:LoadNodes()
	
	if( file.Exists( "Infected/nodes/" .. game.GetMap() .. ".txt", "DATA" ) ) then
		
		local read = file.Read( "Infected/nodes/" .. game.GetMap() .. ".txt", "DATA" );
		
		for _, v in pairs( string.Explode( "\n", read ) ) do
			
			if( v != "" ) then
				
				table.insert( self.Nodes, Vector( v ) );
				
			end
			
		end
		
	end
	
end

function GM:SpawnZombieRandom()
	
	local tab = { };
	
	for _, v in pairs( self.Nodes ) do
		
		if( self:IsSpotClear( v ) and !self:CanPlayerSeeZombieAt( v ) ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	if( #tab == 0 ) then
		
		return;
		
	end
	
	local pos = table.Random( tab ) + Vector( 0, 0, 16 );
	
	local z = ents.Create( "inf_zombie" );
	z:SetPos( pos );
	z:SetAngles( Angle( 0, math.random( -180, 180 ), 0 ) );
	z:Spawn();
	z:Activate();
	
end

function GM:RemoveAllZombies()
	
	for _, v in pairs( ents.FindByClass( "inf_zombie" ) ) do
		
		v:Remove();
		
	end
	
end

function GM:ZombiesInSphere( p, r )
	
	local tab = { };
	
	for _, v in pairs( ents.FindByClass( "inf_zombie" ) ) do
		
		if( v:GetPos():Distance( p ) <= r ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	return tab;
	
end

function GM:NumZombies()
	
	return #ents.FindByClass( "inf_zombie" );
	
end