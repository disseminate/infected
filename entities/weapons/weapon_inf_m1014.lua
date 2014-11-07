AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Benelli M1014";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/infected/weapons/v_m1014.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_m1014.mdl";
SWEP.ViewModelFlip	= true;

SWEP.HoldType = "shotgun";
SWEP.HoldTypeHolster = "passive";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( -4.15, 0.53, -1.21 );
SWEP.HolsterAng = Angle( -29.79, -47.92, 24.54 );

SWEP.AimPos = Vector( 1.56, 0.9, -0.62 );
SWEP.AimAng = Angle();

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 8;
SWEP.Primary.DefaultClip 	= 8;
SWEP.Primary.Ammo			= "buckshot";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_M1014.Single";
SWEP.Primary.Damage			= 8;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.1;
SWEP.Primary.NumBullets		= 8;
SWEP.Primary.Delay			= 0.2;
SWEP.Primary.ViewPunch		= Angle( -5, 0, 0 );

SWEP.ShotgunReload = true;

SWEP.ZombieRadius			= 5000;