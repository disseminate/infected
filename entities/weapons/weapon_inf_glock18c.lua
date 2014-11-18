AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Glock 18c";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= false;
SWEP.ViewModel 		= "models/infected/weapons/v_glock18c.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_glock18c.mdl";

SWEP.HoldType = "revolver";
SWEP.HoldTypeHolster = "normal";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.HolsterPos = Vector( 0, 0, 0 );
SWEP.HolsterAng = Angle( -30, 0, 0 );

SWEP.AimPos = Vector( -2.5, 0.89, -1.08 );
SWEP.AimAng = Angle( -0.03, 0.99, 0 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 18;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Sound			= "Weapon_Glock18c.Single";
SWEP.Primary.Damage			= 20;
SWEP.Primary.Force			= 5;
SWEP.Primary.Accuracy		= 0.07;
SWEP.Primary.Delay			= 0.1;
SWEP.Primary.ViewPunch		= Angle( -2, 0, 0 );

SWEP.Description = "A Glock 18C pistol.";
SWEP.W = 3;
SWEP.H = 2;
SWEP.PrimaryWep = false;
SWEP.SecondaryWep = true;
SWEP.CamPos = Vector( -169, -4, -12 );
SWEP.FOV = 4;
SWEP.LookAt = Vector( 30, 1, 2 );
SWEP.ItemAmmo = "ammo_9mm";

SWEP.ZombieRadius			= 2000;