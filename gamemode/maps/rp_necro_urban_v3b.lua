GM.MainIntroCams = { { Vector( -79, -145, 568 ), Angle( 1, 5, 0 ) }, { Vector( -60, 0, 634 ), Angle( 9, -5, 0 ) } };

function GM:MapInitPostEntity()
	
	for _, v in pairs( ents.FindByClass( "func_precipitation" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "rainfall" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "rainfall_2" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "rainfall_tap" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "thunder_01" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "thunder_02" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "thunder_03" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "thunder_04" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "thunder_timer" ) ) do
		
		v:Remove();
		
	end
	
end

function GM:MapClientInitPostEntity()
	
	
	
end