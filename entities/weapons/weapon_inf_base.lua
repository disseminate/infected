AddCSLuaFile();

SWEP.PrintName 		= "Base";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;
SWEP.ViewModelFlip 	= false;

SWEP.ViewModelFOV	= 54;

SWEP.ViewModel 		= "";
SWEP.WorldModel 	= "";

SWEP.SwayScale		= 0;

SWEP.Primary.ClipSize 		= -1;
SWEP.Primary.DefaultClip 	= -1;
SWEP.Primary.Ammo			= "";
SWEP.Primary.Automatic		= false;

SWEP.Secondary.ClipSize 	= -1;
SWEP.Secondary.DefaultClip 	= -1;
SWEP.Secondary.Ammo			= "";
SWEP.Secondary.Automatic	= false;

SWEP.Holsterable = true;

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "revolver" ] 		= ACT_HL2MP_IDLE_REVOLVER,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "" ]				= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "zombie" ]		= ACT_HL2MP_IDLE_ZOMBIE,
	[ "suitcase" ]		= ACT_HL2MP_IDLE_SUITCASE
}

function SWEP:SetWeaponHoldType( t )
	
	local index = ActIndex[ t ]
	
	self.ActivityTranslate = { }
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslate [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslate [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	if t == "revolver" then
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL;
	end
	
	if t == "passive" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_IDLE_CROUCH;
	end
	
	if( t == "suitcase" ) then
		
		self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= ACT_HL2MP_IDLE_SUITCASE
		self.ActivityTranslate [ ACT_MP_WALK ] 						= ACT_HL2MP_WALK_SUITCASE
		self.ActivityTranslate [ ACT_MP_RUN ] 						= ACT_HL2MP_IDLE+2
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_IDLE+3
		self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_IDLE+4
		self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE+5
		self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_HL2MP_IDLE+5
		self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_IDLE+6
		self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_IDLE+6
		self.ActivityTranslate [ ACT_MP_JUMP ] 						= ACT_HL2MP_IDLE+7
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= ACT_HL2MP_IDLE+8
		
	end

end

function SWEP:SetWeaponHoldTypeHolster( t )
	
	local index = ActIndex[ t ]
	
	self.ActivityTranslateHolster = { }
	self.ActivityTranslateHolster [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslateHolster [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslateHolster [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslateHolster [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslateHolster [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslateHolster [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslateHolster [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslateHolster [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslateHolster [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslateHolster [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslateHolster [ ACT_RANGE_ATTACK1 ] 				= index+8
	
	if t == "normal" then
		self.ActivityTranslateHolster [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	
	if t == "revolver" then
		self.ActivityTranslateHolster [ ACT_RANGE_ATTACK1 ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL;
	end
	
	if t == "passive" then
		self.ActivityTranslateHolster [ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_IDLE_CROUCH;
	end
	
	if( t == "suitcase" ) then
		
		self.ActivityTranslateHolster [ ACT_MP_STAND_IDLE ] 				= ACT_HL2MP_IDLE_SUITCASE
		self.ActivityTranslateHolster [ ACT_MP_WALK ] 						= ACT_HL2MP_WALK_SUITCASE
		self.ActivityTranslateHolster [ ACT_MP_RUN ] 						= ACT_HL2MP_IDLE+2
		self.ActivityTranslateHolster [ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_IDLE+3
		self.ActivityTranslateHolster [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_IDLE+4
		self.ActivityTranslateHolster [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_IDLE+5
		self.ActivityTranslateHolster [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_HL2MP_IDLE+5
		self.ActivityTranslateHolster [ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_IDLE+6
		self.ActivityTranslateHolster [ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_IDLE+6
		self.ActivityTranslateHolster [ ACT_MP_JUMP ] 						= ACT_HL2MP_IDLE+7
		self.ActivityTranslateHolster [ ACT_RANGE_ATTACK1 ] 				= ACT_HL2MP_IDLE+8
		
	end

end

function SWEP:TranslateActivity( act )
	
	local val = -1;
	
	if( self.Owner:Holstered() ) then
		
		if( self.ActivityTranslateHolster[ act ] ) then
			val = self.ActivityTranslateHolster[ act ]
		end
		
	else
		
		if( self.ActivityTranslate[ act ] ) then
			val = self.ActivityTranslate[ act ]
		end
		
	end
	
	local len2d = self.Owner:GetVelocity():Length2D();
	
	if( val == ACT_HL2MP_RUN and len2d >= 200 ) then
		
		val = ACT_HL2MP_RUN_FAST;
		
	end
	
	return val;
	
end

function SWEP:Initialize()
	
	self:SetWeaponHoldType( self.HoldType );
	self:SetWeaponHoldTypeHolster( self.HoldTypeHolster );
	
end

function SWEP:Precache()
	
	if( self.Firearm ) then
		
		if( type( self.Primary.Sound ) == "table" ) then
			
			for _, v in pairs( self.Primary.Sound ) do
				
				util.PrecacheSound( v );
				
			end
			
		else
			
			util.PrecacheSound( self.Primary.Sound );
			
		end
		
		util.PrecacheSound( self.Primary.ReloadSound );
		
	end
	
end

function SWEP:DoDrawAnim()
	
	if( self.DrawAnim ) then
		
		if( type( self.DrawAnim ) == "string" ) then
			
			local vm = self.Owner:GetViewModel();
			vm:SendViewModelMatchingSequence( vm:LookupSequence( self.DrawAnim ) );
			
		else
			
			self:SendWeaponAnim( self.DrawAnim );
			
		end
		
	else
		
		self:SendWeaponAnim( self.DrawAct or ACT_VM_DRAW );
		
	end
	
	self:Idle();
	
end

function SWEP:DoHolsterAnim()
	
	if( self.HolsterAnim ) then
		
		if( type( self.HolsterAnim ) == "string" ) then
			
			local vm = self.Owner:GetViewModel();
			vm:SendViewModelMatchingSequence( vm:LookupSequence( self.HolsterAnim ) );
			
		else
			
			self:SendWeaponAnim( self.HolsterAnim );
			
		end
		
	else
		
		self:SendWeaponAnim( self.HolsterAct or ACT_VM_HOLSTER );
		
	end
	
	timer.Stop( "inf_weapon_idle" .. self:EntIndex() );
	
end

function SWEP:IdleNow()
	
	self:SendWeaponAnim( self.IdleAct or ACT_VM_IDLE );
	
end

function SWEP:Idle()
	
	local vm = self.Owner:GetViewModel();
	
	timer.Create( "inf_weapon_idle" .. self:EntIndex(), vm:SequenceDuration(), 1, function()
		
		if( !self or !self:IsValid() or !self.Owner or !self.Owner:IsValid() ) then return end
		
		self:IdleNow();
		
	end )
	
end

function SWEP:Deploy()
	
	if( self.Owner:Holstered() and self.HolsterUseAnim ) then
		
		self:DoHolsterAnim();
		
	elseif( !self.Owner:Holstered() and self.DrawUseAnim ) then
		
		self:DoDrawAnim();
		
	else
		
		if( self.Owner:Holstered() ) then
			
			self.IronMode = IRON_HOLSTERED;
			self.IronMul = 1;
			
		else
			
			self.IronMode = IRON_IDLE;
			self.IronMul = 0;
			
		end
		
	end
	
	if( self:DeployChild() ) then return false end
	return true;
	
end

function SWEP:DeployChild()
end

function SWEP:OnRemove()
end

function SWEP:HolsterChild()
end

function SWEP:Holster()
	
	timer.Stop( "inf_weapon_idle" .. self:EntIndex() );
	
	if( self:HolsterChild() ) then return false end
	return true;
	
end

function SWEP:Think()
	
	if( self.ApplyReload and CurTime() >= self.ApplyReload ) then
		
		self.ApplyReload = nil;
		
		self:SetClip1( self:Clip1() + self.ApplyReloadAmount );
		
		self.ReloadItemTab.Vars.Ammo = self.ReloadItemTab.Vars.Ammo - self.ApplyReloadAmount;
		
		if( SERVER ) then
			
			if( self.ReloadItemTab.Vars.Ammo <= 0 ) then
				
				self.Owner:RemoveItem( self.ReloadItemTab.Key );
				
			else
				
				self.Owner:UpdateItemVars( self.ReloadItemTab.Key );
				
			end
			
		end
		
		self.Owner:SaveWeaponVars( self:GetClass() );
		
	end
	
	if( !IsFirstTimePredicted() ) then return end
	
	if( self.ShotgunReload ) then
		
		if( self.InReload ) then
			
			if( self.Owner:Holstered() ) then
				
				self.InReload = false;
				return;
				
			end
			
			if( self:GetNextPrimaryFire() <= CurTime() ) then
				
				if( self:Clip1() < self.Primary.ClipSize and self.ApplyReloadAmount > 0 ) then
					
					self:ReloadProgress();
					
				else
					
					self:FinishReload();
					
				end
				
			end
			
		end
		
		if( self.NeedPump and self:GetNextPrimaryFire() <= CurTime() ) then
			
			self:Pump();
			return;
			
		end
		
		if( !self.InReload ) then
			
			--self:Idle();
			
		end
		
	end
	
	if( self.ThinkChild ) then
		
		self:ThinkChild()
		
	end
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	if( self.Owner:Holstered() and self.IronMode > IRON_HOLSTERED ) then -- Going down.
		
		if( self.IronMode > IRON_IDLE ) then
			self.IronMul = 0;
		end
		
		if( self.HolsterUseAnim ) then
			
			self:DoHolsterAnim();
			self.IronMode = IRON_HOLSTERED;
			
		else
			
			self.IronMode = IRON_HOLSTERED2IDLE;
			self.IronDir = 1;
			
			self:Idle();
			
		end
		
	elseif( !self.Owner:Holstered() and self.IronMode < IRON_IDLE ) then -- Raising up.
		
		if( self.DrawUseAnim ) then
			
			self:DoDrawAnim();
			self.IronMode = IRON_IDLE;
			self.IronMul = 0;
			
		else
			
			self.IronMode = IRON_HOLSTERED2IDLE;
			self.IronDir = -1;
			
			timer.Stop( "cc_weapon_idle" .. self:EntIndex() );
			
		end
		
	end
	
	if( self.Owner:KeyDown( IN_ATTACK2 ) ) then
		
		if( self.IronMode == IRON_IDLE or self.IronMode == IRON_IDLE2AIM ) then
			
			self.IronMode = IRON_IDLE2AIM;
			self.IronDir = 1;
			
		end
		
	elseif( self.IronMode > IRON_IDLE ) then
		
		self.IronMode = IRON_IDLE2AIM;
		self.IronDir = -1;
		
	end
	
end

function SWEP:PlaySound( snd, vol, pit )
	
	if( SERVER ) then
		
		if( type( snd ) == "table" ) then
			
			self.Owner:EmitSound( table.Random( snd ), vol, pit );
			
		else
			
			self.Owner:EmitSound( snd, vol, pit );
			
		end
		
	end
	
end

function SWEP:StopSound( snd )
	
	if( SERVER ) then
		
		self.Owner:StopSound( snd );
		
	end
	
end

function SWEP:CanPrimaryAttack( noreload )

	if( self:Clip1() <= 0 ) then
	
		self:EmitSound( self.EmptySound or "Weapon_Pistol.Empty" );
		self:SetNextPrimaryFire( CurTime() + 0.2 );
		return false;
		
	end

	return true;

end

function SWEP:CanSecondaryAttack()

	if( self:Clip2() <= 0 ) then
	
		self:EmitSound( self.EmptyAltSound or "Weapon_Pistol.Empty" );
		self:SetNextSecondaryFire( CurTime() + 0.2 );
		return false;
		
	end

	return true;

end

function SWEP:BulletAccuracyModifier()
	
	local muliron = self.Owner:KeyDown( IN_ATTACK2 ) and 0.7 or 1;
	
	return muliron;
	
end

function SWEP:PrimaryHolstered()
end

function SWEP:ShootEffects()
	
	self:SendWeaponAnim( self.PrimaryAttackAct or ACT_VM_PRIMARYATTACK );
	self.Owner:MuzzleFlash();
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
end

function SWEP:PrimaryUnholstered()
	
	if( self.Firearm ) then
		
		if( self:CanPrimaryAttack() ) then
			
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
			self:ShootEffects();
			
			self:SetClip1( self:Clip1() - 1 );
			self.Owner:SaveWeaponVars( self:GetClass() );
			
			self:Idle();
			
			if( SERVER and self.ZombieRadius ) then
				
				for _, v in pairs( GAMEMODE:ZombiesInSphere( self.Owner:GetPos(), self.ZombieRadius ) ) do
					
					v.LastShot = self.Owner;
					
				end
				
			end
			
			if( self.Primary.ViewPunch ) then
				
				self.Owner:ViewPunch( Angle( self.Primary.ViewPunch.p, math.random( -self.Primary.ViewPunch.y, self.Primary.ViewPunch.y ), math.random( -self.Primary.ViewPunch.r, self.Primary.ViewPunch.r ) ) );
				
			end
			
			if( type( self.Primary.Sound ) == "table" ) then
				for _, v in pairs( self.Primary.Sound ) do
					self:PlaySound( v, 80, 100 );
				end
			else
				self:PlaySound( self.Primary.Sound, 80, 100 );
			end
			
			if( !IsFirstTimePredicted() ) then return end
			
			self:ShootBullet( self.Primary.Damage, self.Primary.Force, self.Primary.NumBullets, self.Primary.Accuracy * self:BulletAccuracyModifier() );
			
		end
		
	elseif( self.Melee ) then
		
		if( self.Owner:KeyDown( IN_ATTACK2 ) ) then return end
		
		self:SetNextPrimaryFire( CurTime() + self.MissDelay );
		self:SetNextSecondaryFire( CurTime() + self.MissDelay );
		
		self.Owner:LagCompensation( true );
		
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		self:PlaySound( self.SwingSound );
		
		local trace = { };
		trace.start = self.Owner:GetShootPos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * self.Length;
		trace.filter = self.Owner;
		trace.mins = Vector( -8, -8, -8 );
		trace.maxs = Vector( 8, 8, 8 );
		
		local tr = util.TraceHull( trace );
		
		if( tr.Hit ) then
			
			self.Weapon:SendWeaponAnim( self.PrimaryAttackAct or ACT_VM_HITCENTER );
			
			self:SetNextPrimaryFire( CurTime() + self.HitDelay );
			self:SetNextSecondaryFire( CurTime() + self.HitDelay );
			
			local ltr = util.TraceLine( trace );
			
			if( tr.Entity and tr.Entity:IsValid() and ( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) ) then
				
				self:PlaySound( self.HitFleshSound );
				
			else
				
				if( type( self.HitWallSound ) == "boolean" ) then
					
					if( self.HitWallSound ) then
						
						self:PlaySound( GAMEMODE:GetImpactSound( tr ) );
						
					end
					
				else
					
					self:PlaySound( self.HitWallSound );
					
				end
				
			end
			
			if( self.BulletDecal ) then
				
				if( type( self.BulletDecal ) == "boolean" ) then
					
					util.Decal( GAMEMODE:GetTraceDecal( tr ), ltr.HitPos + ltr.HitNormal, ltr.HitPos - ltr.HitNormal );
					
				else
					
					util.Decal( self.BulletDecal, ltr.HitPos + ltr.HitNormal, ltr.HitPos - ltr.HitNormal );
					
				end
				
			end
			
			if( SERVER ) then
				
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
				dmg:SetDamage( self.Primary.Damage );
				dmg:SetDamageForce( tr.Normal * 50 );
				dmg:SetDamagePosition( tr.HitPos );
				dmg:SetDamageType( self.DamageType or DMG_SLASH );
				dmg:SetInflictor( self );
				
				if( tr.Entity.DispatchTraceAttack ) then
					
					tr.Entity:DispatchTraceAttack( dmg, tr );
					
				end
				
			end
			
		else
			
			self.Weapon:SendWeaponAnim( self.MissAnim or ACT_VM_MISSCENTER );
			
		end
		
		if( self.Primary.ViewPunch ) then
			
			self.Owner:ViewPunch( Angle( self.Primary.ViewPunch.p, math.random( -self.Primary.ViewPunch.y, self.Primary.ViewPunch.y ), math.random( -self.Primary.ViewPunch.r, self.Primary.ViewPunch.r ) ) );
			
		end
		
		self.Owner:LagCompensation( false );
		self:Idle();
		
	end
	
end

function SWEP:SecondaryHolstered()
end

function SWEP:SecondaryUnholstered()
end

function SWEP:AimMul()
	
	local mul = 1;
	
	if( self.Owner:Crouching() ) then
		
		mul = mul * 0.7;
		
	end
	
	if( self.Owner:GetVelocity():Length() > 5 ) then
		
		mul = mul * 1.5;
		
	end
	
	return mul;
	
end

function SWEP:ShootBullet( damage, force, n, aimcone )
	
	local bullet 		= { };
	bullet.Num 			= n or 1;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= self.Owner:GetAimVector();
	bullet.Spread 		= Vector( aimcone, aimcone, 0 ) * self:AimMul();
	bullet.Tracer		= 1;
	bullet.Force		= force;
	bullet.Damage		= damage;
	bullet.AmmoType 	= "Pistol";
	bullet.TracerName	= self.Primary.TracerName or "Tracer";
	
	self.Owner:FireBullets( bullet );
	
end

function SWEP:PrimaryAttack()
	
	if( self.Owner:Holstered() ) then
		
		self:PrimaryHolstered();
		
	else
		
		self:PrimaryUnholstered();
		
	end
	
end

function SWEP:SecondaryAttack()
	
	if( self.Owner:Holstered() ) then
		
		self:SecondaryHolstered();
		
	else
		
		self:SecondaryUnholstered();
		
	end
	
end

function SWEP:IsBlocking()
	
	if( self.SecondaryBlock ) then
		
		if( !self.Owner:Holstered() and self.Owner:KeyDown( IN_ATTACK2 ) ) then
			
			return true;
			
		end
		
	end
	
	return false;
	
end

function SWEP:FillClip()
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	if( self.ApplyReloadAmount > 0 ) then
		
		if( self:Clip1() < self.Primary.ClipSize ) then
			
			self:SetClip1( self:Clip1() + 1 );
			self.ApplyReloadAmount = self.ApplyReloadAmount - 1;
			
			if( SERVER ) then
				
				if( self.ReloadItemTab.Vars.Ammo <= 0 ) then
					
					self.Owner:RemoveItem( self.ReloadItemTab.Key );
					
				else
					
					self.Owner:UpdateItemVars( self.ReloadItemTab.Key );
					
				end
				
			end
			
			self.Owner:SaveWeaponVars( self:GetClass() );
			
		end
		
	end
	
end

function SWEP:ReloadProgress()
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	if( self:Clip1() >= self.Primary.ClipSize ) then return end
	if( self.ApplyReloadAmount <= 0 ) then return end
	
	self:FillClip();
	
	if( self.Primary.ReloadStartSound ) then
		
		self:PlaySound( self.Primary.ReloadStartSound );
		
	end
	
	self.Weapon:SendWeaponAnim( self.ReloadAct or ACT_VM_RELOAD );

	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
	
end

function SWEP:FinishReload()
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	self.InReload = false;
	
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
	self:Idle();
	
end

function SWEP:Pump()
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	self.NeedPump = false;
	
	if( self.Primary.PumpSound ) then
		
		self:PlaySound( self.Primary.PumpSound );
		
	end
	
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP );
	
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
	self:Idle();
	
end

function SWEP:Reload()
	
	
	
end

function SWEP:ReloadItem( item, metaitem )
	
	if( self.Owner:Holstered() ) then return end
	if( !self.Firearm ) then return end
	
	if( self.ShotgunReload ) then
		
		if( self.NeedPump ) then return false end
		if( self.InReload ) then return false end
		
		self.ReloadItemTab = item;
		
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START );
		-- animation event
		
		self.Owner:SetAnimation( PLAYER_RELOAD );
		
		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
		self.InReload = true;
		
		local delta = self.Primary.ClipSize - self:Clip1();
		delta = math.min( self.Primary.ClipSize - self:Clip1(), item.Vars.Ammo );
		self.ApplyReloadAmount = delta;
		
		item.Vars.Ammo = item.Vars.Ammo - delta;
		
		if( SERVER ) then
			
			if( item.Vars.Ammo <= 0 ) then
				
				self.Owner:RemoveItem( item.Key );
				
			else
				
				self.Owner:UpdateItemVars( item.Key );
				
			end
			
		end
		
		return true;
		
	else
		
		local delta = self.Primary.ClipSize - self:Clip1();
		delta = math.min( self.Primary.ClipSize - self:Clip1(), item.Vars.Ammo );
		
		if( delta > 0 ) then
			
			self.ReloadItemTab = item;
			
			self:SendWeaponAnim( self.ReloadAct or ACT_VM_RELOAD );
			
			if( self.Primary.ReloadSound ) then
				self:PlaySound( self.Primary.ReloadSound );
			end
			
			self.Owner:SetAnimation( PLAYER_RELOAD );
			
			self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
			self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() );
			
			self:Idle();
			
			self.ApplyReload = CurTime() + self:SequenceDuration();
			self.ApplyReloadAmount = delta;
			
		end
		
	end
	
end

SWEP.Holstered = false;
SWEP.IronMode = IRON_HOLSTERED;
SWEP.IronDir = 1;
SWEP.IronMul = 1;

SWEP.IronNetPos = Vector();
SWEP.IronNetAng = Vector();

function SWEP:IronsightsMul()
	
	return FrameTime();
	
end

function SWEP:CalcIron()
	
	if( !self.Holsterable and self.IronMode < IRON_IDLE ) then
		
		self.IronMode = IRON_IDLE;
		
	end
	
	if( self.HolsterPos and self.AimPos and self.HolsterAng and self.AimAng ) then
		
		if( self.IronMode == IRON_HOLSTERED ) then
			
			self.IronNetPos = self.HolsterPos;
			self.IronNetAng = self.HolsterAng;
			
		elseif( self.IronMode == IRON_HOLSTERED2IDLE ) then
			
			if( self.IronMul == 1 and self.IronDir == 1 ) then -- Going up... and hit idle
				
				self.IronMode = IRON_HOLSTERED;
				
			elseif( self.IronMul == 0 and self.IronDir == -1 ) then -- Going down... and hit holstered
				
				self.IronMode = IRON_IDLE;
				
			else
				
				self.IronMul = math.Clamp( self.IronMul + self.IronDir * self:IronsightsMul(), 0, 1 );
				
				self.IronNetPos = self.IronMul * self.HolsterPos;
				self.IronNetAng = self.IronMul * self.HolsterAng;
				
			end
			
		elseif( self.IronMode == IRON_IDLE ) then
			
			self.IronNetPos = Vector();
			self.IronNetAng = Vector();
			
		elseif( self.IronMode == IRON_IDLE2AIM ) then
			
			if( self.IronMul == 1 and self.IronDir == 1 ) then
				
				self.IronMode = IRON_AIM;
				
			elseif( self.IronMul == 0 and self.IronDir == -1 ) then
				
				self.IronMode = IRON_IDLE;
				
			else
				
				self.IronMul = math.Clamp( self.IronMul + self.IronDir * self:IronsightsMul(), 0, 1 );
				
				self.IronNetPos = self.IronMul * self.AimPos;
				self.IronNetAng = self.IronMul * self.AimAng;
				
			end
			
		elseif( self.IronMode == IRON_AIM ) then
			
			self.IronNetPos = self.AimPos;
			self.IronNetAng = self.AimAng;
			
		end
		
	end
	
end

function SWEP:GetViewModelPosition( pos, ang )
	
	if( GAMEMODE.IronOverride ) then
		
		ang:RotateAroundAxis( ang:Right(), GAMEMODE.IronOverride[1] );
		ang:RotateAroundAxis( ang:Up(), GAMEMODE.IronOverride[2] );
		ang:RotateAroundAxis( ang:Forward(), GAMEMODE.IronOverride[3] );
		
		pos = pos + GAMEMODE.IronOverride[4] * ang:Right();
		pos = pos + GAMEMODE.IronOverride[5] * ang:Up();
		pos = pos + GAMEMODE.IronOverride[6] * ang:Forward();
		
		return pos, ang
		
	end
	
	local vOriginalOrigin = pos;
	local vOriginalAngles = ang;
	
	self:CalcIron();
	
	ang:RotateAroundAxis( ang:Right(), self.IronNetAng.x );
	ang:RotateAroundAxis( ang:Up(), self.IronNetAng.y );
	ang:RotateAroundAxis( ang:Forward(), self.IronNetAng.z );

	pos = pos + self.IronNetPos.x * ang:Right();
	pos = pos + self.IronNetPos.y * ang:Up();
	pos = pos + self.IronNetPos.z * ang:Forward();
	
	if( !self.m_vecLastFacing ) then
		
		self.m_vecLastFacing = vOriginalOrigin;
		
	end
	
	local forward = vOriginalAngles:Forward();
	local right = vOriginalAngles:Right();
	local up = vOriginalAngles:Up();
	
	local vDifference = self.m_vecLastFacing - forward;
	
	local flSpeed = 7;
	
	local flDiff = vDifference:Length();
	if( flDiff > 1.5 ) then
		
		flSpeed = flSpeed * ( flDiff / 1.5 );
		
	end
	
	vDifference:Normalize();
	
	self.m_vecLastFacing = self.m_vecLastFacing + vDifference * flSpeed * FrameTime();
	self.m_vecLastFacing:Normalize();
	pos = pos + ( vDifference * -1 ) * 5;
	
	return pos - forward * 5, ang;
	
end

SWEP.ScopeTexture = "gmod/scope-refract";
SWEP.ScopeTextureTop = "gmod/scope";

function SWEP:PreDrawViewModel( vm, wep, ply )
	
	if( self.Scoped ) then
		
		if( self.IronMode == IRON_AIM ) then
			
			vm:SetMaterial( "engine/occlusionproxy" );
			
		else
			
			vm:SetMaterial( "" );
			
		end
		
	else
		
		vm:SetMaterial( "" );
		
	end
	
end

function SWEP:InScope()
	
	if( self.Scoped and LocalPlayer():GetViewEntity() == LocalPlayer() and self.IronMode == IRON_AIM ) then
		
		return true;
		
	end
	
	return false;
	
end

function SWEP:DrawHUD()
	
	if( self:InScope() ) then
		
		local h = ScrH();
		local w = ( 4 / 3 ) * h;
		
		local dw = ( ScrW() - w ) / 2;
		
		surface.SetDrawColor( 0, 0, 0, 255 );
		surface.DrawRect( 0, 0, dw, h );
		surface.DrawRect( w + dw, 0, dw, h );
		
		if( render.GetDXLevel() >= 90 ) then
			
			render.UpdateRefractTexture();
			surface.SetTexture( surface.GetTextureID( self.ScopeTexture ) );
			surface.SetDrawColor( 255, 255, 255, 255 );
			surface.DrawTexturedRect( dw, 0, w, h );
			
		end
		
		surface.SetTexture( surface.GetTextureID( self.ScopeTextureTop ) );
		surface.SetDrawColor( 0, 0, 0, 255 );
		surface.DrawTexturedRect( dw, 0, w, h );
		
		surface.SetDrawColor( 0, 0, 0, 255 );
		
		surface.DrawLine( 0, ScrH() / 2, ScrW(), ScrH() / 2 );
		surface.DrawLine( ScrW() / 2, 0, ScrW() / 2, ScrH() );
		
	end
	
	if( GAMEMODE.IronOverride ) then
		
		surface.SetDrawColor( 255, 255, 255, 255 );
		surface.DrawLine( 0, ScrH() / 2, ScrW(), ScrH() / 2 );
		surface.DrawLine( ScrW() / 2, 0, ScrW() / 2, ScrH() );
		
	end
	
end

function SWEP:TranslateFOV( fov )
	
	if( self:InScope() ) then
		
		return 20;
		
	end
	
	return fov;
	
end

function SWEP:AdjustMouseSensitivity()
	
	if( self:InScope() ) then
		
		return ( 20 / GetConVarNumber( "fov_desired" ) );
		
	end
	
	return 1;
	
end

function SWEP:DrawWorldModel()
	
	if( self.RepositionToHand ) then
		
		local hand = self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_rh" ) );
		
		if( hand ) then
			
			self:SetRenderOrigin( hand.Pos );
			self:SetRenderAngles( hand.Ang );
			
		end
		
	end
	
	self:DrawModel();
	
end

function SWEP:GetTracerOrigin()
	
	if( self.FixTracerOrigins and self.Owner == LocalPlayer() ) then
		
		return self.Owner:EyePos() + self.Owner:EyeAngles():Right() * 5 + self.Owner:EyeAngles():Forward() * 13 + self.Owner:EyeAngles():Up() * -3;
		
	end
	
end
