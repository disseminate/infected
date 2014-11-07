AddCSLuaFile();

ENT.Base = "base_nextbot";

function ENT:Initialize()
   
	if( CLIENT ) then return end
	
	self.Sex = ( math.random( 0, 1 ) == 0 ) and MALE or FEMALE;
	
	self:SetModel( table.Random( table.GetKeys( GAMEMODE.SurvivorModels[self.Sex] ) ) );
	self:SetSubMaterial( self:GetFacemap(), "infected/humans/" .. string.StripExtension( string.GetFileFromFilename( self:GetModel() ) ) .. "/facemap_infected" );
	self:SetSubMaterial( self:GetClothesSheet(), table.Random( GAMEMODE.InfectedClothes[self.Sex] ) );
	
	self:SetHealth( math.random( 10, 30 ) );
	
	self.WanderAttentionSpan = math.Rand( 3, 9 );
	self.ChaseAttentionSpan = math.Rand( 20, 60 );
	
	if( GAMEMODE.SlowZombies ) then
		
		self.ChaseAttentionSpan = math.Rand( 200, 300 );
		
	else
		
		self.ChaseAttentionSpan = math.Rand( 20, 60 );
		
	end
	
	self.WalkAct = math.random( 1628, 1631 );
	
	self.PlayerPositions = { };
	
end

function ENT:SetupDataTables()
	
	--self:NetworkVar( "Bool", 0, "VehicleKilled" );
	
end

function ENT:BehaveAct()

end

function ENT:Think()
	
end

function ENT:BodyUpdate()
	
	self:BodyMoveXY();
	
end

function ENT:MovementThink()
	
	if( self.loco:IsStuck() ) then
		
		if( !self.StuckTime ) then
			
			self.StuckTime = CurTime();
			
		end
		
		self:Attack();
		
	else
		
		self.StuckTime = nil;
		
	end
	
	if( self.StuckTime and CurTime() >= self.StuckTime + 60 ) then
		
		if( !GAMEMODE:CanPlayerSeeZombieAt( self:GetPos() ) ) then
			
			self:Remove();
			return;
			
		end
		
	end
	
	local trace = { };
	trace.start = self:WorldSpaceCenter();
	trace.endpos = trace.start + self:GetForward() * 64;
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
		
		if( tr.Entity:GetClass() == "func_breakable" or tr.Entity:GetClass() == "func_breakable_surf" ) then
			
			self:Attack();
			
		end
		
		if( tr.Entity:GetClass() == "prop_door_rotating" or tr.Entity:GetClass() == "func_door_rotating" ) then
			
			self:Attack();
			
		end
		
	end
	
end

function ENT:AttackThink()
	
	if( self.NextAttackDamage and CurTime() > self.NextAttackDamage ) then
		
		self.NextAttackDamage = nil;
		
		local venttab = { };
		
		for _, v in pairs( ents.FindInSphere( self:GetPos(), 100 ) ) do
			
			local trace = { };
			trace.start = self:WorldSpaceCenter();
			trace.endpos = v:WorldSpaceCenter();
			trace.filter = ents.FindByClass( "inf_zombie" );
			
			for _, v in pairs( player.GetAll() ) do
				
				if( v:PlayerClass() == PLAYERCLASS_INFECTED or v:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
					
					table.insert( trace.filter, v );
					
				end
				
			end
			
			local tr = util.TraceLine( trace );
			
			if( tr.Entity and tr.Entity:IsValid() and tr.Entity == v ) then
				
				table.insert( venttab, v );
				
			end
			
		end
		
		for _, v in pairs( venttab ) do
			
			if( v:IsTargetable() ) then
				
				if( v:IsPlayer() and self:IsOnFire() and !v:IsOnFire() ) then
					
					v:Ignite( 20, 0 );
					
				end
				
				local dmg = DamageInfo();
				dmg:SetAttacker( self );
				dmg:SetDamage( 10 );
				dmg:SetDamageType( DMG_CLUB );
				dmg:SetInflictor( self );
				
				v:TakeDamageInfo( dmg );
				
				if( v:GetClass() == "func_breakable_surf" ) then
					
					v:Fire( "Shatter", "0 0 0" );
					
				end
				
				local ply = false;
				
				for _, n in pairs( player.GetAll() ) do
					
					if( n:GetPos():Distance( v:GetPos() ) < 1500 ) then
						
						ply = true;
						
					end
					
				end
				
				if( v:IsDoor() and ply ) then
					
					v:SetDoorHealth( v:DoorHealth() - 1 );
					
					if( v:DoorHealth() <= 0 ) then
						
						local d = ( v:GetPos() - self:GetPos() ):GetNormal();
						
						GAMEMODE:BreakDoor( v, d * 300, 300 );
						
					end
					
				end
				
			end
			
		end
		
		if( #venttab > 0 ) then
			
			self:EmitSound( "infected/zombie/attack/hit_0" .. math.random( 1, 8 ) .. ".wav" );
			
		end
		
	end
	
end

function ENT:IdleThink()
	
	if( !self.NextIdleSound ) then self.NextIdleSound = CurTime(); end
	
	if( CurTime() >= self.NextIdleSound ) then
		
		local snd = "infected/zombie/idle/idle_" .. string.FormatDigits( math.random( 1, 31 ) ) .. ".wav";
		self:EmitSound( snd );
		self.NextIdleSound = CurTime() + SoundDuration( snd );
		
	end
	
end

function ENT:RageThink()
	
	if( GAMEMODE.SlowZombies ) then
		
		self:IdleThink();
		return;
		
	end
	
	if( !self.NextRageSound ) then self.NextRageSound = CurTime(); end
	
	if( CurTime() >= self.NextRageSound ) then
		
		local g = "male";
		
		if( self.Sex == FEMALE ) then
			
			g = "female";
			
		end
		
		local snd = "infected/zombie/rage/" .. g .. "/rage_" .. string.FormatDigits( math.random( 1, 32 ) ) .. ".wav";
		self:EmitSound( snd );
		self.NextRageSound = CurTime() + SoundDuration( snd );
		
	end
	
end

function ENT:StuckThink()
	
	
	
end

function ENT:Attack()
	
	if( !self.NextAttack ) then self.NextAttack = CurTime(); end
	
	if( CurTime() >= self.NextAttack ) then
		
		self:RestartGesture( ACT_GMOD_GESTURE_RANGE_ZOMBIE );
		self.NextAttack = CurTime() + 1.6;
		self.NextAttackDamage = CurTime() + 0.6;
		
		self:EmitSound( "infected/zombie/attack/swing_0" .. math.random( 1, 2 ) .. ".wav" );
		
	end
	
end

function ENT:Wander( rad )
	
	local r = math.random( 0, 360 );
	
	local x = math.cos( r ) * rad;
	local y = math.sin( r ) * rad;
	
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( 0 );
	path:SetGoalTolerance( 60 );
	path:Compute( self, self:GetPos() + Vector( x, y, 0 ) );
	
	if( !path:IsValid() ) then return "failed" end
	
	while( path:IsValid() ) do

		path:Update( self );
		
		--path:Draw();
		
		self:AttackThink();
		self:IdleThink();
		self:MovementThink();
		
		self:UpdatePlayerPositions();
		local ret, ply = self:GetBestEnemy();
		
		if( ret != false ) then
			
			return "found", ply;
			
		end
		
		if( self.loco:IsStuck() ) then
			
			if( self:HandleStuck() ) then
				
				return "stuck";
				
			end
			
		end
		
		if( path:GetAge() > self.WanderAttentionSpan ) then return "timeout" end
		
		coroutine.yield();
	
	end
	
	return "ok"
	
end

function ENT:Idle( delay )
	
	local t = CurTime() + delay;
	
	local len = self:SetSequence( self:LookupSequence( "zombie_idle_01" ) );
	
	self:ResetSequenceInfo();
	self:SetCycle( 0 );
	self:SetPlaybackRate( 1 );
	
	while( CurTime() < t ) do
		
		self:AttackThink();
		self:IdleThink();
		
		self:UpdatePlayerPositions();
		local ret, ply = self:GetBestEnemy();
		
		if( ret != false ) then
			
			return "found", ply;
			
		end
		
		coroutine.yield();
	
	end
	
end

function ENT:FindClosestPlayer()
	
	local closest = nil;
	local dist = math.huge;
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:PlayerClass() != PLAYERCLASS_INFECTED and v:PlayerClass() != PLAYERCLASS_SPECIALINFECTED ) then
			
			local d = v:GetPos():Distance( self:GetPos() );
			
			if( d < dist ) then
				
				dist = d;
				closest = v;
				
			end
			
		end
		
	end
	
	return closest, dist;
	
end

function ENT:FindClosestPlayerDistance()
	
	local dist = math.huge;
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:PlayerClass() != PLAYERCLASS_INFECTED and v:PlayerClass() != PLAYERCLASS_SPECIALINFECTED ) then
			
			local d = v:GetPos():Distance( self:GetPos() );
			
			if( d < dist ) then
				
				dist = d;
				
			end
			
		end
		
	end
	
	return dist;
	
end

function ENT:FindClosestPlayerMemory()
	
	local closest = nil;
	local dist = math.huge;
	
	for k, v in pairs( self.PlayerPositions ) do
		
		if( v:PlayerClass() != PLAYERCLASS_INFECTED and v:PlayerClass() != PLAYERCLASS_SPECIALINFECTED ) then
			
			local d = v:Distance( self:GetPos() );
			
			if( d < dist ) then
				
				dist = d;
				closest = k;
				
			end
			
		end
		
	end
	
	return closest, dist;
	
end

function ENT:ChasePlayer()
	
	if( !self.Target or !self.Target:IsValid() ) then return "no target" end
	if( !self.PlayerPositions[self.Target] ) then return "no player position" end
	
	local path = Path( "Follow" );
	path:SetMinLookAheadDistance( 0 );
	path:SetGoalTolerance( 20 );
	path:Compute( self, self.PlayerPositions[self.Target][1] );
	
	if( !path:IsValid() ) then return "failed" end
	
	while( path:IsValid() ) do
		
		if( !self.Target or !self.Target:IsValid() ) then return "lost target" end
		
		path:Update( self );
		
		--path:Draw();
		
		self:AttackThink();
		self:MovementThink();
		self:RageThink();
		
		local dist = ( self.PlayerPositions[self.Target][1] - self:GetPos() ):Length();
		
		if( dist > 1500 and path:GetAge() > 1 ) then
			
			if( self.PlayerPositions[self.Target] ) then
				
				path:Compute( self, self.PlayerPositions[self.Target][1] );
				
			end	
			
		elseif( dist <= 1500 and path:GetAge() > 0.3 ) then
			
			if( self.PlayerPositions[self.Target] ) then
				
				path:Compute( self, self.PlayerPositions[self.Target][1] );
				
			end	
			
		end
		
		local dist = self:FindClosestPlayerDistance();
		
		if( dist < 64 ) then
			
			self:Attack();
			
		end
		
		self:UpdatePlayerPositions();
		
		local ret, ply = self:GetBestEnemy();
		
		if( ret == false ) then -- we have no enemy to chase..
			
			return "lost targets"
			
		elseif( ret ) then
			
			self.Target = ply;
			
		end
		
		coroutine.yield();

	end
	
	return "ok"

end

function ENT:UpdatePlayerPositions()
	
	for k, v in pairs( self.PlayerPositions ) do
		
		if( !k or !k:IsValid() ) then
			
			self.PlayerPositions[k] = nil;
			
			if( k == self.Target ) then
				
				self.Target = nil;
				
			end
			
		elseif( !k:Alive() ) then
			
			self.PlayerPositions[k] = nil;
			
			if( k == self.Target ) then
				
				self.Target = nil;
				
			end
			
		elseif( CurTime() > v[2] + self.ChaseAttentionSpan ) then
			
			self.PlayerPositions[k] = nil;
			
			if( k == self.Target ) then
				
				self.Target = nil;
				
			end
			
		end
		
	end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( !v:IsTargetable() ) then continue; end
		if( v:PlayerClass() == PLAYERCLASS_INFECTED or v:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then continue; end
		
		local pos = v:GetPos();
		local d = self:GetPos():Distance( pos );
		
		if( self.LastShot and self.LastShot == v ) then
			
			self.PlayerPositions[v] = { pos, CurTime() };
			continue;
			
		end
		
		if( d < 400 and v:FlashlightIsOn() ) then
			self.PlayerPositions[v] = { pos, CurTime() };
			continue;
		end
		
		if( d < 200 and ( !v:Crouching() or v:FlashlightIsOn() ) ) then
			self.PlayerPositions[v] = { pos, CurTime() };
			continue;
		end
		
		local dot = ( pos - self:GetPos() ):GetNormal():Dot( self:GetForward() );
		
		if( v:Crouching() and !v:FlashlightIsOn() ) then
			
			if( self:CanSeePlayer( v ) and dot > 0.7 and d < 1000 ) then
				
				self.PlayerPositions[v] = { pos, CurTime() };
				
			end
			
		else
			
			if( self.PlayerPositions[v] and d < 700 ) then
				
				self.PlayerPositions[v] = { pos, CurTime() };
				
			elseif( self:CanSeePlayer( v ) and dot > 0.6 and d < 2000 ) then
				
				self.PlayerPositions[v] = { pos, CurTime() };
				
			end
			
		end
		
	end
	
end

function ENT:PathDistanceToPos( pos )
	
	if( true ) then
		
		return ( self:GetPos() - pos ):Length();
		
	else
		
		local path = Path( "Follow" );
		path:SetMinLookAheadDistance( 0 );
		path:SetGoalTolerance( 20 );
		path:Compute( self, pos );
		
		return path:GetLength();
		
	end
	
end

function ENT:GetBestEnemy()
	
	if( self.Target and self.Target:IsValid() and self.PlayerPositions[self.Target] ) then
		
		local d = self:PathDistanceToPos( self.PlayerPositions[self.Target][1] );
		
		if( self.LastShot and self.LastShot:IsValid() ) then
			
			self.LastShot = nil;
			
			if( d > 400 ) then
				
				return true, self.LastShot;
				
			end
			
		end
		
		for k, v in pairs( self.PlayerPositions ) do
			
			local l = self:PathDistanceToPos( v[1] );
			
			if( l < d ) then
				
				return true, k;
				
			end
			
		end
		
		return nil, self.Target;
		
	else
		
		if( self.LastShot and self.LastShot:IsValid() ) then
			
			self.LastShot = nil;
			return true, self.LastShot;
			
		end
		
		local d = math.huge;
		local ply = nil;
		
		for k, v in pairs( self.PlayerPositions ) do
			
			local l = self:PathDistanceToPos( v[1] );
			
			if( l < d ) then
				
				d = l;
				ply = k;
				
			end
			
		end
		
		if( ply ) then
			
			return true, ply;
			
		else
			
			return false, nil;
			
		end
		
	end
	
end

function ENT:OnInjured( dmg )
	
	local ent = dmg:GetAttacker();
	
	local z = ( dmg:GetDamagePosition() - self:GetPos() ).z;
	
	if( GAMEMODE.SlowZombies ) then
		
		if( z > 55 ) then
			
			dmg:ScaleDamage( 10 );
			
		else
			
			dmg:ScaleDamage( 0 );
			
			if( ent and ent:IsValid() and ent:IsPlayer() ) then
				
				self.LastShot = ent;
				
			end
			
		end
		
	else
		
		if( ent and ent:IsValid() and ent:IsPlayer() ) then
			
			self.LastShot = ent;
			
			if( !self.PlayerPositions[ent] ) then
				
				dmg:ScaleDamage( 10 );
				
			end
			
		end
		
		if( z > 60 ) then
			
			dmg:ScaleDamage( 2 );
			
		end
		
	end
	
end

function ENT:RunBehaviour()
	
	while( true ) do
		
		self:StartActivity( self.WalkAct );
		self.loco:SetDesiredSpeed( 40 );
		local ret, ply = self:Wander( 300 );
		
		if( ret == "found" ) then
			
			self.Target = ply;
			
			if( GAMEMODE.SlowZombies ) then
				
				self:StartActivity( self.WalkAct );
				self.loco:SetDesiredSpeed( 40 );
				
			else
				
				self:StartActivity( ACT_HL2MP_RUN_FAST );
				self.loco:SetDesiredSpeed( 220 );
				
			end
			
			self:ChasePlayer( ply );
			
		end
		
		local ret, ply = self:Idle( math.Rand( 5, 15 ) );
		
		if( ret == "found" ) then
			
			self.Target = ply;
			
			if( GAMEMODE.SlowZombies ) then
				
				self:StartActivity( self.WalkAct );
				self.loco:SetDesiredSpeed( 40 );
				
			else
				
				self:StartActivity( ACT_HL2MP_RUN_FAST );
				self.loco:SetDesiredSpeed( 220 );
				
			end
			
			self:ChasePlayer();
			
		end
		
		local plys = ents.FindInSphere( self:GetPos(), 400 );
		local idlemore = true;
		local n = false;
		
		for _, v in pairs( plys ) do
			
			if( v:IsPlayer() and v:IsTargetable() ) then
				
				if( !v:Crouching() ) then
					
					idlemore = false;
					
				end
				
				n = true;
				
			end
			
		end
		
		if( !n ) then
			
			idlemore = false;
			
		end
		
		if( idlemore ) then
			
			local ret, ply = self:Idle( math.Rand( 10, 15 ) );
			
			if( ret == "found" ) then
				
				self.Target = ply;
				
				if( GAMEMODE.SlowZombies ) then
					
					self:StartActivity( self.WalkAct );
					self.loco:SetDesiredSpeed( 40 );
					
				else
					
					self:StartActivity( ACT_HL2MP_RUN_FAST );
					self.loco:SetDesiredSpeed( 220 );
					
				end
				
				self:ChasePlayer();
				
			end
			
		end
		
		coroutine.yield();
		
	end
	
end