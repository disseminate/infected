DeriveGamemode( "sandbox" );

GM.Name = "Infected";

GM.SlowZombies = false;

local meta = FindMetaTable( "Entity" );

team.SetUp( TEAM_SURVIVOR, "Survivors", Color( 200, 255, 255, 255 ) );

GM.SurvivorModels = { };
GM.SurvivorModels[MALE] = { };
GM.SurvivorModels[FEMALE] = { };

GM.SurvivorModels[MALE]["models/player/group01/male_01.mdl"] = { "infected/humans/male_01/facemap_01", "infected/humans/male_01/facemap_02", "infected/humans/male_01/facemap_03", "infected/humans/male_01/facemap_04", "infected/humans/male_01/facemap_05" };
GM.SurvivorModels[MALE]["models/player/group01/male_02.mdl"] = { "infected/humans/male_02/facemap_01", "infected/humans/male_02/facemap_02", "infected/humans/male_02/facemap_03", "infected/humans/male_02/facemap_04", "infected/humans/male_02/facemap_07" };
GM.SurvivorModels[MALE]["models/player/group01/male_03.mdl"] = { "infected/humans/male_03/facemap_01", "infected/humans/male_03/facemap_02", "infected/humans/male_03/facemap_03", "infected/humans/male_03/facemap_04", "infected/humans/male_03/facemap_05", "infected/humans/male_03/facemap_06", "infected/humans/male_03/facemap_08", "infected/humans/male_03/facemap_09" };
GM.SurvivorModels[MALE]["models/player/group01/male_04.mdl"] = { "infected/humans/male_04/facemap_01", "infected/humans/male_04/facemap_02", "infected/humans/male_04/facemap_03", "infected/humans/male_04/facemap_04" };
GM.SurvivorModels[MALE]["models/player/group01/male_05.mdl"] = { "infected/humans/male_05/facemap_01", "infected/humans/male_05/facemap_02", "infected/humans/male_05/facemap_03", "infected/humans/male_05/facemap_04", "infected/humans/male_05/facemap_05", "infected/humans/male_05/facemap_06", "infected/humans/male_05/facemap_07" };
GM.SurvivorModels[MALE]["models/player/group01/male_06.mdl"] = { "infected/humans/male_06/facemap_01", "infected/humans/male_06/facemap_02", "infected/humans/male_06/facemap_03", "infected/humans/male_06/facemap_04", "infected/humans/male_06/facemap_05", "infected/humans/male_06/facemap_08", "infected/humans/male_06/facemap_09", "infected/humans/male_06/facemap_10", "infected/humans/male_06/facemap_11" };
GM.SurvivorModels[MALE]["models/player/group01/male_07.mdl"] = { "infected/humans/male_07/facemap_01", "infected/humans/male_07/facemap_02", "infected/humans/male_07/facemap_03", "infected/humans/male_07/facemap_04", "infected/humans/male_07/facemap_05", "infected/humans/male_07/facemap_06", "infected/humans/male_07/facemap_07", "infected/humans/male_07/facemap_08" };
GM.SurvivorModels[MALE]["models/player/group01/male_08.mdl"] = { "infected/humans/male_08/facemap_01", "infected/humans/male_08/facemap_02", "infected/humans/male_08/facemap_04", "infected/humans/male_08/facemap_05", "infected/humans/male_08/facemap_09", "infected/humans/male_08/facemap_10" };
GM.SurvivorModels[MALE]["models/player/group01/male_09.mdl"] = { "infected/humans/male_09/facemap_01", "infected/humans/male_09/facemap_02", "infected/humans/male_09/facemap_03", "infected/humans/male_09/facemap_04", "infected/humans/male_09/facemap_06" };

GM.SurvivorModels[FEMALE]["models/player/group01/female_01.mdl"] = { "infected/humans/female_01/facemap_01", "infected/humans/female_01/facemap_02", "infected/humans/female_01/facemap_03" };
GM.SurvivorModels[FEMALE]["models/player/group01/female_02.mdl"] = { "infected/humans/female_02/facemap_01", "infected/humans/female_02/facemap_02", "infected/humans/female_02/facemap_03" };
GM.SurvivorModels[FEMALE]["models/player/group01/female_03.mdl"] = { "infected/humans/female_03/facemap_01", "infected/humans/female_03/facemap_02", "infected/humans/female_03/facemap_03", "infected/humans/female_03/facemap_04" };
GM.SurvivorModels[FEMALE]["models/player/group01/female_04.mdl"] = { "infected/humans/female_04/facemap_01", "infected/humans/female_04/facemap_02", "infected/humans/female_04/facemap_03" };
GM.SurvivorModels[FEMALE]["models/player/group01/female_05.mdl"] = { "infected/humans/female_05/facemap_01", "infected/humans/female_05/facemap_02" };
GM.SurvivorModels[FEMALE]["models/player/group01/female_06.mdl"] = { "infected/humans/female_06/facemap_01", "infected/humans/female_06/facemap_02" };

GM.SurvivorClothes = { };
GM.SurvivorClothes[MALE] = {
	"infected/humans/male/sheet_01",
	"infected/humans/male/sheet_02",
	"infected/humans/male/sheet_03",
	"infected/humans/male/sheet_04",
	"infected/humans/male/sheet_05",
	"infected/humans/male/sheet_06",
	"infected/humans/male/sheet_07",
	"infected/humans/male/sheet_08",
	"infected/humans/male/sheet_09",
	"infected/humans/male/sheet_10",
	"infected/humans/male/sheet_11",
	"infected/humans/male/sheet_12",
	"infected/humans/male/sheet_13",
	"infected/humans/male/sheet_14",
	"infected/humans/male/sheet_15",
	"infected/humans/male/sheet_16",
	"infected/humans/male/sheet_17",
	"infected/humans/male/sheet_18",
	"infected/humans/male/sheet_19",
	"infected/humans/male/sheet_20",
	"infected/humans/male/sheet_21",
	"infected/humans/male/sheet_22",
	"infected/humans/male/sheet_23",
	"infected/humans/male/sheet_24",
	"infected/humans/male/sheet_25",
	"infected/humans/male/sheet_26",
	"infected/humans/male/sheet_27",
	"infected/humans/male/sheet_28",
	"infected/humans/male/sheet_29",
	"infected/humans/male/sheet_30",
	"infected/humans/male/sheet_31",
	"infected/humans/male/sheet_32",
	"infected/humans/male/sheet_33",
};
GM.SurvivorClothes[FEMALE] = {
	"infected/humans/female/sheet_01",
	"infected/humans/female/sheet_02",
	"infected/humans/female/sheet_03",
	"infected/humans/female/sheet_04",
	"infected/humans/female/sheet_05",
	"infected/humans/female/sheet_06",
	"infected/humans/female/sheet_07",
	"infected/humans/female/sheet_08",
	"infected/humans/female/sheet_09",
	"infected/humans/female/sheet_10",
	"infected/humans/female/sheet_11",
	"infected/humans/female/sheet_12",
	"infected/humans/female/sheet_13",
	"infected/humans/female/sheet_14",
	"infected/humans/female/sheet_15",
	"infected/humans/female/sheet_16",
	"infected/humans/female/sheet_17",
};

GM.InfectedModels = { };
GM.InfectedModels[MALE] = { };
GM.InfectedModels[FEMALE] = { };

GM.InfectedModels[MALE]["models/player/group01/male_01.mdl"] = { "infected/humans/male_01/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_02.mdl"] = { "infected/humans/male_02/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_03.mdl"] = { "infected/humans/male_03/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_04.mdl"] = { "infected/humans/male_04/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_05.mdl"] = { "infected/humans/male_05/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_06.mdl"] = { "infected/humans/male_06/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_07.mdl"] = { "infected/humans/male_07/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_08.mdl"] = { "infected/humans/male_08/facemap_infected" };
GM.InfectedModels[MALE]["models/player/group01/male_09.mdl"] = { "infected/humans/male_09/facemap_infected" };

GM.InfectedModels[FEMALE]["models/player/group01/female_01.mdl"] = { "infected/humans/female_01/facemap_infected" };
GM.InfectedModels[FEMALE]["models/player/group01/female_02.mdl"] = { "infected/humans/female_02/facemap_infected" };
GM.InfectedModels[FEMALE]["models/player/group01/female_03.mdl"] = { "infected/humans/female_03/facemap_infected" };
GM.InfectedModels[FEMALE]["models/player/group01/female_04.mdl"] = { "infected/humans/female_04/facemap_infected" };
GM.InfectedModels[FEMALE]["models/player/group01/female_05.mdl"] = { "infected/humans/female_05/facemap_infected" };
GM.InfectedModels[FEMALE]["models/player/group01/female_06.mdl"] = { "infected/humans/female_06/facemap_infected" };

GM.InfectedClothes = { };
GM.InfectedClothes[MALE] = {
	"infected/humans/male_inf/sheet_01",
	"infected/humans/male_inf/sheet_02",
	"infected/humans/male_inf/sheet_03",
	"infected/humans/male_inf/sheet_04",
};
GM.InfectedClothes[FEMALE] = {
	"infected/humans/female_inf/sheet_01",
	"infected/humans/female_inf/sheet_02",
	"infected/humans/female_inf/sheet_03",
	"infected/humans/female_inf/sheet_04",
	"infected/humans/female_inf/sheet_05",
	"infected/humans/female_inf/sheet_06",
};

GM.HECUModels = {
	"models/infected/hecu/hecu_01.mdl",
	"models/infected/hecu/hecu_02.mdl",
	"models/infected/hecu/hecu_03.mdl",
	"models/infected/hecu/hecu_04.mdl",
};

GM.SpecialInfectedModels = {
	"models/player/odessa.mdl",
}

if( CLIENT ) then -- Precache the materials

	for k, v in pairs( GM.SurvivorModels[MALE] ) do
		
		for _, n in pairs( v ) do
			
			surface.SetMaterial( Material( n ) );
			
		end
		
	end

	for k, v in pairs( GM.SurvivorModels[FEMALE] ) do
		
		for _, n in pairs( v ) do
			
			surface.SetMaterial( Material( n ) );
			
		end
		
	end
	
	for k, v in pairs( GM.InfectedModels[MALE] ) do
		
		for _, n in pairs( v ) do
			
			surface.SetMaterial( Material( n ) );
			
		end
		
	end

	for k, v in pairs( GM.InfectedModels[FEMALE] ) do
		
		for _, n in pairs( v ) do
			
			surface.SetMaterial( Material( n ) );
			
		end
		
	end

	for _, v in pairs( GM.SurvivorClothes[MALE] ) do
		
		surface.SetMaterial( Material( v ) );
		
	end

	for _, v in pairs( GM.SurvivorClothes[FEMALE] ) do
		
		surface.SetMaterial( Material( v ) );
		
	end
	
	for _, v in pairs( GM.InfectedClothes[MALE] ) do
		
		surface.SetMaterial( Material( v ) );
		
	end

	for _, v in pairs( GM.InfectedClothes[FEMALE] ) do
		
		surface.SetMaterial( Material( v ) );
		
	end
	
end

function meta:GetClothesSheet()
	
	if( string.find( string.lower( self:GetModel() ), "/player/" ) ) then
		
		local tab = self:GetMaterials();
		
		for k, v in pairs( tab ) do
			
			if( string.find( v, "players_sheet" ) ) then return k - 1 end
			
		end
		
		return -1;
		
	end
	
	return -1;
	
end

function meta:GetFacemap()
	
	if( string.find( string.lower( self:GetModel() ), "/player/" ) ) then
		
		local tab = self:GetMaterials();
		
		for k, v in pairs( tab ) do
			
			if( string.find( v, "facemap" ) ) then return k - 1 end
			if( string.find( v, "cylmap" ) ) then return k - 1 end
			
		end
		
		return -1;
		
	end
	
	return -1;
	
end

function meta:ResetSubMaterials()
	
	local tab = self:GetMaterials();
	
	for k, v in pairs( tab ) do
		
		self:SetSubMaterial( k - 1, "" );
		
	end
	
end

GM.MinNameLength = 5;
GM.MaxNameLength = 40;
GM.MaxDescLength = 500;

GM.MaxChars = 10;

function GM:CheckValidCharacter( ply, class, name, desc, model, face, clothes )
	
	if( class == PLAYERCLASS_MILITARY and !string.find( ply:CharCreateFlags(), "m" ) ) then
		
		return false, "You don't have permissions to make this type of character.";
		
	end
	
	if( class == PLAYERCLASS_INFECTED and !string.find( ply:CharCreateFlags(), "i" ) ) then
		
		return false, "You don't have permissions to make this type of character.";
		
	end
	
	if( class == PLAYERCLASS_SPECIALINFECTED and !string.find( ply:CharCreateFlags(), "s" ) ) then
		
		return false, "You don't have permissions to make this type of character.";
		
	end
	
	if( string.len( name ) < self.MinNameLength ) then
		
		return false, "Name is too short.";
		
	end
	
	if( string.len( name ) > self.MaxNameLength ) then
		
		return false, "Name is too long.";
		
	end
	
	if( string.len( desc ) > self.MaxDescLength ) then
		
		return false, "Description is too long.";
		
	end
	
	if( class == PLAYERCLASS_SURVIVOR ) then
		
		local good = false;
		
		for k, v in pairs( self.SurvivorModels[MALE] ) do
			
			if( k == model ) then
				
				good = true;
				
			end
			
		end
		
		for k, v in pairs( self.SurvivorModels[FEMALE] ) do
			
			if( k == model ) then
				
				good = true;
				
			end
			
		end
		
		if( !good ) then
			
			return false, "Invalid model.";
			
		end
		
		if( self.SurvivorModels[MALE][model] ) then
			
			if( !table.HasValue( self.SurvivorModels[MALE][model], face ) ) then
				
				return false, "Invalid face.";
				
			end
			
		end
		
		if( self.SurvivorModels[FEMALE][model] ) then
			
			if( !table.HasValue( self.SurvivorModels[FEMALE][model], face ) ) then
				
				return false, "Invalid face.";
				
			end
			
		end
		
		if( !table.HasValue( self.SurvivorClothes[MALE], clothes ) and !table.HasValue( self.SurvivorClothes[FEMALE], clothes ) ) then
			
			return false, "Invalid clothes.";
			
		end
		
	elseif( class == PLAYERCLASS_MILITARY ) then
		
		local good = false;
		
		for k, v in pairs( self.HECUModels ) do
			
			if( v == model ) then
				
				good = true;
				
			end
			
		end
		
		if( !good ) then
			
			return false, "Invalid model.";
			
		end
		
		if( face != "" ) then
			
			return false, "Invalid face.";
			
		end
		
		if( clothes != "" ) then
			
			return false, "Invalid clothes.";
			
		end
		
	elseif( class == PLAYERCLASS_SPECIALINFECTED ) then
		
		local good = false;
		
		for k, v in pairs( self.SpecialInfectedModels ) do
			
			if( v == model ) then
				
				good = true;
				
			end
			
		end
		
		if( !good ) then
			
			return false, "Invalid model.";
			
		end
		
		if( face != "" ) then
			
			return false, "Invalid face.";
			
		end
		
		if( clothes != "" ) then
			
			return false, "Invalid clothes.";
			
		end
		
	end
	
	return true;
	
end

function GM:CanSeePos( pos1, pos2, filter )
	
	local trace = { };
	trace.start = pos1;
	trace.endpos = pos2;
	trace.filter = filter;
	trace.mask = MASK_SOLID + CONTENTS_WINDOW + CONTENTS_GRATE;
	local tr = util.TraceLine( trace );
	
	if( tr.Fraction == 1.0 ) then
		
		return true;
		
	end
	
	return false;
	
end

function GM:ShouldCollide( e1, e2 )
	
	if( e1:GetClass() == "inf_zombie" and e2:GetClass() == "inf_zombie" ) then
		
		return false;
		
	end
	
	return true;
	
end

function meta:CanSeePlayer( ply )
	
	return GAMEMODE:CanSeePos( self:EyePos(), ply:EyePos(), { self, ply } );
	
end

function meta:GetHandTrace( len )
	
	local trace = { };
	trace.start = self:GetShootPos();
	trace.endpos = trace.start + self:GetAimVector() * ( len or 60 );
	trace.filter = self;
	local tr = util.TraceLine( trace );
	
	return tr;
	
end

function GM:IsSpotClear( pos )
	
	local trace = { };
	trace.start = pos + Vector( 0, 0, 4 );
	trace.endpos = pos + Vector( 0, 0, 72 );
	trace.filter = { };
	trace.mins = Vector( -32, -32, 0 );
	trace.maxs = Vector( 32, 32, 1 );
	local tr = util.TraceHull( trace );
	
	if( !tr.Hit ) then
		
		return true;
		
	end
	
	return false;
	
end

function GM:CanPlayerSeeZombieAt( pos )
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:IsTargetable() ) then
			
			local d = v:GetPos():Distance( pos );
			
			if( d < 1000 ) then return true end 
			if( v:VisibleVec( pos ) ) then return true end 
			
			local dir = ( pos * v:EyePos() ):GetNormal();
			
			if( dir:Dot( v:GetAimVector() ) > 0.7071 and d < 2500 ) then
				
				return true;
				
			end
			
		end
		
	end
	
	return false;
	
end

function GM:FormatLine( str, font, size )
	
	if( string.len( str ) == 1 ) then return str, 0 end
	
	local start = 1;
	local c = 1;
	
	surface.SetFont( font );
	
	local endstr = "";
	local n = 0;
	local lastspace = 0;
	local lastspacemade = 0;
	
	while( string.len( str or "" ) > c ) do
	
		local sub = string.sub( str, start, c );
	
		if( string.sub( str, c, c ) == " " ) then
			lastspace = c;
		end
		
		if( surface.GetTextSize( sub ) >= size and lastspace ~= lastspacemade ) then
			
			local sub2;
			
			if( lastspace == 0 ) then
				lastspace = c;
				lastspacemade = c;
			end
			
			if( lastspace > 1 ) then
				sub2 = string.sub( str, start, lastspace - 1 );
				c = lastspace;
			else
				sub2 = string.sub( str, start, c );
			end
			
			endstr = endstr .. sub2 .. "\n";
			
			lastspace = c + 1;
			lastspacemade = lastspace;
			
			start = c + 1;
			n = n + 1;
		
		end
	
		c = c + 1;
	
	end
	
	if( start < string.len( str or "" ) ) then
	
		endstr = endstr .. string.sub( str or "", start );
	
	end
	
	return endstr, n;

end

function GM:GetTraceDecal( tr )
	
	if( tr.MatType == MAT_ALIENFLESH ) then return "Impact.AlientFlesh" end
	if( tr.MatType == MAT_ANTLION ) then return "Impact.Antlion" end
	if( tr.MatType == MAT_CONCRETE ) then return "Impact.Concrete" end
	if( tr.MatType == MAT_METAL ) then return "Impact.Metal" end
	if( tr.MatType == MAT_WOOD ) then return "Impact.Wood" end
	if( tr.MatType == MAT_GLASS ) then return "Impact.Glass" end
	if( tr.MatType == MAT_FLESH ) then return "Impact.Flesh" end
	if( tr.MatType == MAT_BLOODYFLESH ) then return "Impact.BloodyFlesh" end
	
	return "Impact.Concrete";
	
end

function meta:IsDoor()
	
	if( self:GetClass() == "prop_door_rotating" ) then return true end
	return false
	
end

function meta:GetDataByCharID( id )
	
	for _, v in pairs( GAMEMODE.CharData[self:SteamID()] ) do
		
		if( v.id == id ) then
			
			return v;
			
		end
		
	end
	
end

function meta:GetIndexByCharID( id )
	
	for k, v in pairs( GAMEMODE.CharData[self:SteamID()] ) do
		
		if( v.id == id ) then
			
			return k;
			
		end
		
	end
	
end

function meta:GetItemDataByCharID( id )
	
	for k, v in pairs( GAMEMODE.ItemData[self:SteamID()] ) do
		
		if( k == id ) then
			
			return v;
			
		end
		
	end
	
end

function meta:FindPlayer( str )
	
	if( str == "^" ) then return self end
	if( str == "*" ) then
		
		local tr = self:GetEyeTrace();
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
			
			return tr.Entity;
			
		end
		
	end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:SteamID() == str ) then
			
			return v;
			
		end
		
	end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( string.find( string.lower( v:RPName() ), string.lower( str ) ) ) then
			
			return v;
			
		elseif( string.find( string.lower( v:Nick() ), string.lower( str ) ) ) then
			
			return v;
			
		end
		
	end
	
end

function meta:SendNet( str )
	
	net.Start( str );
	net.Send( self );
	
end

function meta:IsTargetable()
	
	if( self:GetNoDraw() ) then return false end
	if( self:IsPlayer() and !self:Alive() ) then return false end
	if( self:IsPlayer() and self:CharID() == -1 and !self:IsBot() ) then return false end
	
	return true;
	
end

function string.FormatDigits( str )
	
	if( tonumber( str ) < 10 ) then
		
		return "0" .. str;
		
	end
	
	return str;
	
end

function player.GetAllBut( ply )
	
	local ret = { };
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v != ply ) then
			
			table.insert( ret, v );
			
		end
		
	end
	
	return ret;
	
end