AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Axe";
SWEP.Slot 			= 2;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= false;
SWEP.ViewModel 		= "models/infected/weapons/v_axe.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_axe.mdl";

SWEP.HoldType = "melee2";
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = true;
SWEP.DrawUseAnim = true;

SWEP.HolsterPos = Vector();
SWEP.HolsterAng = Angle();

SWEP.AimPos = Vector( 0, -3.5, -6 );
SWEP.AimAng = Angle( -5, 20, -50 );

SWEP.Melee = true;

SWEP.Primary.ClipSize 		= -1;
SWEP.Primary.DefaultClip 	= -1;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Damage			= 5;

SWEP.Description = "An axe, used to cut down trees.";
SWEP.W = 4;
SWEP.H = 2;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( -200, 0, 0 );
SWEP.FOV = 10;
SWEP.LookAt = Vector( 0, -2, 0 );

SWEP.MissDelay				= 0.7;
SWEP.HitDelay				= 0.5;
SWEP.Length					= 64;
SWEP.BulletDecal			= "decals/manhackcut3";
SWEP.SwingSound				= "Weapon_Crowbar.Single";
SWEP.HitWallSound			= "Weapon_Axe.Melee_Hit";
SWEP.HitFleshSound			= "Weapon_Axe.Melee_Hit";