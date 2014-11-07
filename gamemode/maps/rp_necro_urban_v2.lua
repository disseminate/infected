GM.MainIntroCams = { { Vector( 2394, 323, 358 ), Angle( -6, -153, 0 ) }, { Vector( 2409, 254, 360 ), Angle( -6, -154, 0 ) } };

function GM:MapInitPostEntity()
	
	for _, v in pairs( ents.FindByName( "park111dc" ) ) do
		
		v:Remove();
		
	end
	
end