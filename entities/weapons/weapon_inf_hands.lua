AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Hands";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/weapons/c_arms_citizen.mdl";
SWEP.WorldModel 	= "";

SWEP.HoldType = "fist";
SWEP.HoldTypeHolster = "normal";

SWEP.DrawAnim = "fists_draw";
SWEP.HolsterAnim = "fists_holster";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = true;
SWEP.DrawUseAnim = true;

SWEP.HolsterPos = Vector();
SWEP.HolsterAng = Vector();

SWEP.AimPos = Vector( -2.93, 2.81, -4.24 );
SWEP.AimAng = Vector( -0.81, 0, 0 );

SWEP.SecondaryBlock = true;
SWEP.BlockMul = 0.5;

SWEP.AttackAnims = { 
	{ "fists_left", Angle( 0, -10, 0 ) },
	{ "fists_right", Angle( 0, 10, 0 ) },
	{ "fists_uppercut", Angle( -7, 2, 0 ) } };
	
SWEP.HitSounds = {
	"npc/vort/foot_hit.wav",
	"weapons/crossbow/hitbod1.wav",
	"weapons/crossbow/hitbod2.wav"
}

SWEP.SwingSounds = {
	"npc/vort/claw_swing1.wav",
	"npc/vort/claw_swing2.wav"
}

function SWEP:Initialize()
	
	self:SetWeaponHoldType( self.HoldType );
	self:SetWeaponHoldTypeHolster( self.HoldTypeHolster );
	
end

function SWEP:Precache()
	
	util.PrecacheSound( "physics/wood/wood_crate_impact_hard2.wav" );
	
	util.PrecacheSound( "doors/door_latch3.wav" );
	util.PrecacheSound( "doors/door_locked2.wav" );
	
	for _, v in pairs( self.HitSounds ) do
		
		util.PrecacheSound( v );
		
	end
	
	for _, v in pairs( self.SwingSounds ) do
		
		util.PrecacheSound( v );
		
	end
	
end

function SWEP:IdleNow()
	
	local vm = self.Owner:GetViewModel();
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) );
	
end

function SWEP:PreDrawViewModel( vm, wep, ply )

	vm:SetMaterial( "engine/occlusionproxy" ) -- Hide that view model with hacky material

end

function SWEP:PrimaryHolstered()
	
	local tr = self.Owner:GetHandTrace();
	
	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
		
		self:PlaySound( "physics/wood/wood_crate_impact_hard2.wav", 70, math.random( 95, 105 ) );
		
		self:SetNextPrimaryFire( CurTime() + 0.1 );
		
	end
	
end

function SWEP:PrimaryUnholstered()
	
	if( self.Owner:KeyDown( IN_ATTACK2 ) ) then return end
	
	local anim = table.Random( self.AttackAnims );
	
	if( self.Owner:PlayerClass() == PLAYERCLASS_INFECTED ) then
		
		self:SetNextPrimaryFire( CurTime() + 1.6 );
		self:SetNextSecondaryFire( CurTime() + 1.6 );
		
		self.Owner:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true );
		
		self:PlaySound( "infected/zombie/attack/swing_0" .. math.random( 1, 2 ) .. ".wav" );
		
		timer.Simple( 0.6, function()
			
			if( CLIENT ) then return end
			
			if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
			
			local venttab = { };
			
			for _, v in pairs( ents.FindInSphere( self.Owner:GetPos(), 100 ) ) do
				
				local trace = { };
				trace.start = self.Owner:WorldSpaceCenter();
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
					
					if( v:IsPlayer() and self.Owner:IsOnFire() and !v:IsOnFire() ) then
						
						v:Ignite( 20, 0 );
						
					end
					
					local dmg = DamageInfo();
					dmg:SetAttacker( self.Owner );
					dmg:SetDamage( 10 );
					dmg:SetDamageType( DMG_CLUB );
					dmg:SetInflictor( self );
					
					v:TakeDamageInfo( dmg );
					
					if( v:GetClass() == "func_breakable_surf" ) then
						
						v:Fire( "Shatter", "0 0 0" );
						
					end
					
					if( v:IsDoor() ) then
						
						v:SetDoorHealth( v:DoorHealth() - 1 );
						
						if( v:DoorHealth() <= 0 ) then
							
							local d = ( v:GetPos() - self.Owner:GetPos() ):GetNormal();
							
							GAMEMODE:BreakDoor( v, d * 300, 300 );
							
						end
						
					end
					
				end
				
			end
			
			if( #venttab > 0 ) then
				
				self:PlaySound( "infected/zombie/attack/hit_0" .. math.random( 1, 8 ) .. ".wav" );
				
			end
			
		end )
		
		timer.Simple( 0.1, function()
			if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
			
			self.Owner:ViewPunch( Angle( -50, 50 * math.Rand( -1, 1 ), 0 ) );
		end )
		
	elseif( self.Owner:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
		
		self:SetNextPrimaryFire( CurTime() + 1.6 );
		self:SetNextSecondaryFire( CurTime() + 1.6 );
		
		self:PlaySound( table.Random( self.SwingSounds ), 74, math.random( 90, 110 ) );
		self.Owner:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true );
		
		timer.Simple( 0.1, function()
			if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
			
			self.Owner:ViewPunch( anim[2] );
		end )
		
		timer.Simple( 0.15, function()
			if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
			
			self:FistDamage();
		end )
		
	else
		
		self:SetNextPrimaryFire( CurTime() + 0.6 );
		self:SetNextSecondaryFire( CurTime() + 0.6 );
		
		self:PlaySound( table.Random( self.SwingSounds ), 74, math.random( 90, 110 ) );
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		timer.Simple( 0.1, function()
			if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
			
			self.Owner:ViewPunch( anim[2] );
		end )
		
		timer.Simple( 0.15, function()
			if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
			
			self:FistDamage();
		end )
		
	end
	
	local vm = self.Owner:GetViewModel();
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_01" ) );
	
	timer.Simple( 0, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
		
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( anim[1] ) );
		
		self:Idle();
	end )
	
end

function SWEP:FistDamage()
	
	if( CLIENT ) then return end
	
	self.Owner:LagCompensation( true );
	
	local trace = { };
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 50;
	trace.filter = self.Owner;
	trace.mins = Vector( -8, -8, -8 );
	trace.maxs = Vector( 8, 8, 8 );
	
	local tr = util.TraceHull( trace );
	
	if( tr.Hit ) then
		
		if( self.Owner:PlayerClass() == PLAYERCLASS_INFECTED or self.Owner:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
			
			self:PlaySound( "infected/zombie/attack/hit_0" .. math.random( 1, 8 ) .. ".wav" );
			
		else
			
			self:PlaySound( table.Random( self.HitSounds ), 74, math.random( 90, 110 ) );
			
		end
		
		if( tr.Entity and tr.Entity:IsValid() ) then
			
			local blockmul = 1;
			
			if( tr.Entity:IsPlayer() ) then
				
				if( tr.Entity:GetActiveWeapon() and tr.Entity:GetActiveWeapon():IsValid() ) then
					
					if( tr.Entity:GetActiveWeapon().IsBlocking and tr.Entity:GetActiveWeapon():IsBlocking() ) then
						
						blockmul = tr.Entity:GetActiveWeapon().BlockMul;
						
					end
					
				end
				
			end
			
			local dmg = DamageInfo();
			dmg:SetAttacker( self.Owner );
			dmg:SetDamage( 0 );
			dmg:SetDamageForce( Vector( 0, 0, 1 ) );
			dmg:SetDamagePosition( tr.Entity:GetPos() );
			dmg:SetDamageType( DMG_CLUB );
			dmg:SetInflictor( self );
			
			tr.Entity:TakeDamageInfo( dmg );
			
		end
		
	end
	
	self.Owner:LagCompensation( false );
	
end

function SWEP:Reload()
	
	
	
end

function SWEP:SecondaryUnholstered()
	
	
	
end

function SWEP:HolsterChild()
	
	self:OnRemove();
	
end

function SWEP:OnRemove()
	
	if( self.Owner and self.Owner:IsValid() ) then
		
		local vm = self.Owner:GetViewModel();
		
		if( vm and vm:IsValid() ) then
			
			vm:SetMaterial( "" );
			
		end
		
	end
	
	timer.Stop( "inf_weapon_idle" .. self:EntIndex() );

end
