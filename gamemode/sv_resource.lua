resource.AddSingleFile( "resource/fonts/bebasneue.ttf" );

resource.AddWorkshop( 315557857 );

GM.WorkshopMaps = { };
GM.WorkshopMaps["gm_shambles"] = 151544081;
GM.WorkshopMaps["rp_necro_forest_a1"] = 128002457;
GM.WorkshopMaps["rp_necro_urban_v1"] = 320875135;
GM.WorkshopMaps["rp_necro_urban_v2"] = 320870151;
GM.WorkshopMaps["rp_necro_urban_v3b"] = 178935552;

if( GM.WorkshopMaps[game.GetMap()] ) then
	
	resource.AddWorkshop( GM.WorkshopMaps[game.GetMap()] );
	
else
	
	resource.AddSingleFile( "maps/" .. game.GetMap() .. ".bsp" );
	
end