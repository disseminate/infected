GM.ModelDefinitions = { };

GM.ModelDefinitions[""] = {
	ViewOffset = Vector( 0, 0, 64 ),
	ViewOffsetDucked = Vector( 0, 0, 28 ),
};

GM.ModelDefinitions["models/player/odessa.mdl"] = {
	ViewOffset = Vector( 0, 0, 50 ),
	ViewOffsetDucked = Vector( 0, 0, 40 ),
};

local meta = FindMetaTable( "Player" );

function meta:GetModelDef()
	
	if( GAMEMODE.ModelDefinitions[self:GetModel()] ) then
		
		return GAMEMODE.ModelDefinitions[self:GetModel()];
		
	else
		
		return GAMEMODE.ModelDefinitions[""];
		
	end
	
end