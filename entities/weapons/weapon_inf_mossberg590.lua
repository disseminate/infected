AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Mossberg 590";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/infected/weapons/v_mossberg590.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_mossberg590.mdl";
SWEP.ViewModelFlip	= true;

SWEP.HoldType = "shotgun";
SWEP.HoldTypeHolster = "passive";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( -10, 2, -7 );
SWEP.HolsterAng = Angle( -40, -60, 30 );

SWEP.AimPos = Vector( 2.85, 1.86, -2.4 );
SWEP.AimAng = Angle( 2.56, 0.76, -3.45 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 8;
SWEP.Primary.DefaultClip 	= 8;
SWEP.Primary.Ammo			= "buckshot";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_590.Single";
SWEP.Primary.Damage			= 8;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.1;
SWEP.Primary.NumBullets		= 8;
SWEP.Primary.Delay			= 1;
SWEP.Primary.ViewPunch		= Angle( -5, 0, 0 );

SWEP.ShotgunReload = true;

SWEP.ZombieRadius			= 4000;