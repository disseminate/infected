AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "MP5A2";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= false;
SWEP.ViewModel 		= "models/infected/weapons/v_mp5a2.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_mp5a2.mdl";
SWEP.ViewModelFlip	= true;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "passive";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.FixTracerOrigins = true;

SWEP.HolsterPos = Vector( -6.6, -3.19, -7.89 );
SWEP.HolsterAng = Angle( 3.29, -75.83, 4.94 );

SWEP.AimPos = Vector( 3.1, 1.47, -3.24 );
SWEP.AimAng = Angle( 0.63, 0, 0 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 30;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Sound			= "Weapon_MP5A2.Single";
SWEP.Primary.Damage			= 10;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.1;
SWEP.Primary.Delay			= 0.075;
SWEP.Primary.ViewPunch		= Angle( -1, 0, 0 );

SWEP.Description = "An MP5A2 rifle.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( -450, -19, -8 );
SWEP.FOV = 5;
SWEP.LookAt = Vector( -250, -10, -5 );
SWEP.ItemAmmo = "ammo_9mm";

SWEP.ZombieRadius			= 1500;
