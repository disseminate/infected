AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Winchester 1893";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= true;
SWEP.ViewModel 		= "models/infected/weapons/v_1893.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_1893.mdl";
SWEP.ViewModelFlip	= true;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "passive";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( -8.69, 0.27, -8.37 );
SWEP.HolsterAng = Angle( -27.54, -57.18, 22.57 );

SWEP.AimPos = Vector( 4.38, 2.58, -1.56 );
SWEP.AimAng = Angle( -0.03, 0.07, 1.5 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 15;
SWEP.Primary.DefaultClip 	= 15;
SWEP.Primary.Ammo			= "buckshot";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_1893.Single";
SWEP.Primary.Damage			= 10;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.08;
SWEP.Primary.NumBullets		= 1;
SWEP.Primary.Delay			= 1;
SWEP.Primary.ViewPunch		= Angle( -5, 0, 0 );

SWEP.Description = "A Winchester 1893 bolt-action rifle.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( 200, 0, 0 );
SWEP.FOV = 20;
SWEP.LookAt = Vector( 0, 0, 0 );

SWEP.ShotgunReload = true;

SWEP.ZombieRadius			= 3000;