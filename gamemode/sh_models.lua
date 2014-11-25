GM.ModelDefinitions = { };

GM.ModelDefinitions[""] = {
	ViewOffset = Vector( 0, 0, 64 ),
	ViewOffsetDucked = Vector( 0, 0, 28 ),
};

GM.ModelDefinitions["FastZombie"] = {
	ViewOffset = Vector( 0, 0, 50 ),
	ViewOffsetDucked = Vector( 0, 0, 40 ),
};

local meta = FindMetaTable( "Player" );

function meta:GetModelDef()
	
	local s = self:GetSpecialAnimSet();
	
	if( s and GAMEMODE.ModelDefinitions[s] ) then
		
		return GAMEMODE.ModelDefinitions[s];
		
	elseif( GAMEMODE.ModelDefinitions[self:GetModel()] ) then
		
		return GAMEMODE.ModelDefinitions[self:GetModel()];
		
	else
		
		return GAMEMODE.ModelDefinitions[""];
		
	end
	
end