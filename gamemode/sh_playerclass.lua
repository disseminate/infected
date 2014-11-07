local PLAYER = { };

PLAYER.DisplayName			= "Infected";
PLAYER.TeammateNoCollide	= false;
PLAYER.AvoidPlayers			= false;
PLAYER.CanUseFlashlight		= true;

function PLAYER:GetHandsModel()
	
	if( self.Player:PlayerClass() == PLAYERCLASS_INFECTED or self.Player:PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
		
		return { model = "models/weapons/c_arms_citizen.mdl", skin = 2, body = "0000000" };
		
	elseif( self.Player:PlayerClass() == PLAYERCLASS_MILITARY ) then
		
		return { model = "models/weapons/c_arms_cstrike.mdl", skin = 0, body = "0000000" };
		
	else
		
		local model = self.Player:GetModel();
		local s = 0;
		
		if( string.find( model, "male_01" ) or
			string.find( model, "male_03" ) or
			string.find( model, "female_03" ) or
			string.find( model, "female_05" ) ) then
			
			s = 1;
			
		end
		
		return { model = "models/weapons/c_arms_citizen.mdl", skin = s, body = "0000000" };
		
	end

end

function PLAYER:StartMove( move )
end

function PLAYER:FinishMove( move )
end

player_manager.RegisterClass( "player_infected", PLAYER, "player_sandbox" );