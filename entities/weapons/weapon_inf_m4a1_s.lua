AddCSLuaFile();

SWEP.Base			= "weapon_inf_base";

SWEP.PrintName 		= "Silenced M4A1";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;

SWEP.UseHands		= false;
SWEP.ViewModel 		= "models/infected/weapons/v_m4a1.mdl";
SWEP.WorldModel 	= "models/infected/weapons/w_m4a1_s.mdl";
SWEP.ViewModelFlip	= true;

SWEP.HoldType = "ar2";
SWEP.HoldTypeHolster = "passive";

SWEP.Holsterable = true;
SWEP.HolsterUseAnim = false;
SWEP.DrawUseAnim = false;

SWEP.FixTracerOrigins = true;

SWEP.HolsterPos = Vector( -5.01, -3.25, -10.05 );
SWEP.HolsterAng = Angle( -2.52, -73.96, 10.76 );	

SWEP.AimPos = Vector( 3.27, 0.77, 1.03 );
SWEP.AimAng = Angle( 1.5, 1.5, 1.5 );

SWEP.Firearm = true;

SWEP.Primary.ClipSize 		= 30;
SWEP.Primary.DefaultClip 	= 0;
SWEP.Primary.Ammo			= "";
SWEP.Primary.InfiniteAmmo	= true;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Sound			= "Weapon_M4A1.Silenced";
SWEP.Primary.Damage			= 10;
SWEP.Primary.Force			= 3;
SWEP.Primary.Accuracy		= 0.1;
SWEP.Primary.Delay			= 0.075;
SWEP.Primary.ViewPunch		= Angle( -1, 0, 0 );

SWEP.Description = "An M4A1 rifle, with a silencer attached.";
SWEP.W = 5;
SWEP.H = 2;
SWEP.PrimaryWep = true;
SWEP.SecondaryWep = false;
SWEP.CamPos = Vector( -588, 7, -4 );
SWEP.FOV = 5;
SWEP.LookAt = Vector( -388, 5, -2 );
SWEP.ItemAmmo = "ammo_556mm";

SWEP.ZombieRadius			= 200;

SWEP.IdleAct				= ACT_VM_IDLE_SILENCED;
SWEP.PrimaryAttackAct		= ACT_VM_PRIMARYATTACK_SILENCED;
SWEP.ReloadAct				= ACT_VM_RELOAD_SILENCED;
SWEP.DrawAct				= ACT_VM_DRAW_SILENCED;