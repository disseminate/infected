AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Beretta M9";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= false;
SWEP.ViewModel 		= "models/infected/weapons/v_m9.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_m9.mdl";
SWEP.ViewModelFlip	= true;

SWEP.HoldType = "revolver";
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -20, 0, 0 );

SWEP.AimPos = Vector( 2.78, 1.56, -3.83 );
SWEP.AimAng = Angle( -0.23, 0, 0 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 18;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_M9.Single";
SWEP.Primary.Damage			= 20;
SWEP.Primary.Force			= 5;
SWEP.Primary.Accuracy		= 0.07;
SWEP.Primary.Delay			= 0.1;
SWEP.Primary.ViewPunch		= Angle( -2, 0, 0 );

SWEP.Description = "An M9 pistol.";
SWEP.W = 3;
SWEP.H = 2;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( -171, 1, 21 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( 27, 0, -3 );
SWEP.ItemAmmo = "ammo_9mm";

SWEP.ZombieRadius			= 2000;