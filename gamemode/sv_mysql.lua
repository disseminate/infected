require( "mysqloo" );

local meta = FindMetaTable( "Player" );

local MySQLHost = "192.254.233.171";
local MySQLUser = "dissemin_inf";
local MySQLPass = "d99beH8DAyF123sVx1915Jk2E2YLB50jA1q5k87F";
local MySQLDB = "dissemin_infected";
local MySQLPort = 3306;

GM.SQLQueue = { };

function GM:ConnectToSQL()
	
	InfSQL = mysqloo.connect( MySQLHost, MySQLUser, MySQLPass, MySQLDB, MySQLPort );
	
	function InfSQL:onConnected()
		
		MsgC( Color( 128, 128, 128, 255 ), "MySQL successfully connected to " .. self:hostInfo() .. ".\nMySQL server version: " .. self:serverInfo() .. "\n" );
		
		GAMEMODE:InitSQLTables();
		
		for k, v in pairs( GAMEMODE.SQLQueue ) do
			
			timer.Simple( 0.01 * ( k - 1 ), function()
				
				mysqloo.Query( v[1], v[2], v[3], v[4] );
				
			end );
			
		end
		
		GAMEMODE.SQLQueue = { };
		
		mysqloo.Query( "SET interactive_timeout = 28800" );
		mysqloo.Query( "SET wait_timeout = 28800" );
		
	end

	function InfSQL:onConnectionFailed( err )
		
		if( string.find( err, "Unknown MySQL server host" ) ) then return end
		
		GAMEMODE:ConnectToSQL();
		
	end

	InfSQL:connect();
	
end

function mysqloo.Query( q, cb, cbe, noerr )
	
	local qo = InfSQL:query( q );
	
	if( !qo ) then
		
		table.insert( GAMEMODE.SQLQueue, { q, cb, cbe, noerr } );
		InfSQL:abortAllQueries();
		InfSQL:connect();
		return;
		
	end
	
	function qo:onSuccess( ret )
		
		if( cb ) then
			
			cb( ret, qo );
			
		end
		
	end
	
	function qo:onError( err )
		
		if( InfSQL:status() == mysqloo.DATABASE_NOT_CONNECTED ) then
			
			table.insert( GAMEMODE.SQLQueue, { q, cb, cbe, noerr } );
			InfSQL:abortAllQueries();
			InfSQL:connect();
			return;
			
		end
		
		if( err == "MySQL server has gone away" ) then
			
			table.insert( GAMEMODE.SQLQueue, { q, cb, cbe, noerr } );
			InfSQL:abortAllQueries();
			InfSQL:connect();
			return;
			
		end
		
		if( string.find( err, "Lost connection to MySQL server" ) ) then
			
			table.insert( GAMEMODE.SQLQueue, { q, cb, cbe, noerr } );
			InfSQL:abortAllQueries();
			InfSQL:connect();
			return;
			
		end
		
		if( cbe ) then
			
			cbe( err, qo );
			
		end
		
		if( !noerr ) then
			
			MsgC( COLOR_ERROR, "ERROR: MySQL query \"" .. q .. "\" failed (\"" .. err .. "\").\n" );
			
		end
		
	end
	
	qo:start();
	
end

function mysqloo.Escape( s )
	
	if( !s ) then return "" end
	
	return InfSQL:escape( tostring( s ) );
	
end

local SQLStructure = { };

SQLStructure["players"] = {
	{ "LastPlayed", "INT" },
	{ "PhysTrust", "INT", "1" },
	{ "ToolTrust", "INT", "0" },
	{ "CharCreateFlags", "TEXT" },
	{ "PlayerTitle", "TEXT" },
	{ "PlayerTitleColor", "TEXT" },
};

SQLStructure["bans"] = {
	{ "Length", "INT" },
	{ "Reason", "TEXT" },
	{ "Date", "INT" },
	{ "Unban", "INT", "0" },
};

SQLStructure["chars"] = {
	{ "Class", "INT", "1" },
	{ "Name", "TEXT" },
	{ "Description", "TEXT" },
	{ "Model", "TEXT" },
	{ "Face", "TEXT" },
	{ "Clothes", "TEXT" },
};

SQLStructure["items"] = {
	{ "CharID", "INT" },
	{ "Class", "TEXT" },
	{ "X", "INT" },
	{ "Y", "INT" },
	{ "PrimaryEquipped", "INT" },
	{ "SecondaryEquipped", "INT" },
	{ "Vars", "TEXT" },
};

function GM:InitSQLTables()
	
	for k, v in pairs( SQLStructure ) do
		
		local function qs()
			
			GAMEMODE:InitSQLTable( SQLStructure[k], k );
			
		end
		
		mysqloo.Query( "CREATE TABLE IF NOT EXISTS " .. k .. " ( id INT NOT NULL auto_increment, SteamID VARCHAR(30) NOT NULL, PRIMARY KEY ( id ) );", qs );
		
	end
	
end

function GM:InitSQLTable( data, table )
	
	for _, v in pairs( data ) do
		
		local function qs()
			
			MsgC( Color( 128, 128, 128, 255 ), "Column " .. v[1] .. " exists in table " .. table .. ".\n" );
			
		end
		
		local function qf()
			
			MsgC( Color( 128, 128, 128, 255 ), "Column " .. v[1] .. " does not exist in table " .. table .. ". Creating...\n" );
			
			if( v[3] ) then
				
				mysqloo.Query( "ALTER TABLE " .. table .. " ADD COLUMN " .. v[1] .. " " .. v[2] .. " NOT NULL DEFAULT '" .. tostring( v[3] ) .. "'" );
				
			else
				
				mysqloo.Query( "ALTER TABLE " .. table .. " ADD COLUMN " .. v[1] .. " " .. v[2] .. " NOT NULL" );
				
			end
			
		end
		
		mysqloo.Query( "SELECT " .. v[1] .. " FROM " .. table, qs, qf, true );
		
	end
	
end

GM.Bans = { };

function GM:LoadBans()
	
	local function qs( res )
		
		for _, v in pairs( res ) do
			
			GAMEMODE.Bans[v.SteamID] = { };
			GAMEMODE.Bans[v.SteamID].Date = v.Date;
			GAMEMODE.Bans[v.SteamID].Length = v.Length;
			GAMEMODE.Bans[v.SteamID].Reason = v.Reason;
			GAMEMODE.Bans[v.SteamID].Unban = v.Unban;
			
		end
		
	end
	
	mysqloo.Query( "SELECT * FROM bans", qs );
	
end

function GM:AddBan( sid, duration, reason )
	
	self.Bans[sid] = { };
	self.Bans[sid].Date = os.time();
	self.Bans[sid].Length = duration;
	self.Bans[sid].Reason = reason;
	self.Bans[sid].Unban = 0;
	
	local function qs( res )
		
		MsgC( Color( 128, 128, 128, 255 ), "Saved player ban for SteamID " .. sid .. ".\n" );
		
	end
	
	MsgC( Color( 128, 128, 128, 255 ), "Saving player ban for SteamID " .. sid .. "...\n" );
	mysqloo.Query( "INSERT INTO bans ( SteamID, Length, Reason, Date, Unban ) VALUES ( '" .. sid .. "', '" .. duration .. "', '" .. reason .. "', '" .. os.time() .. "', '0' )", qs );
	
end

GM.PlayerData = { };
GM.CharData = { };
GM.ItemData = { };

function meta:PreloadPlayer()
	
	MsgC( Color( 128, 128, 128, 255 ), "Preloading player " .. self:Nick() .. "...\n" );
	
	local function qs( res )
		
		if( !self or !self:IsValid() ) then
			
			MsgC( Color( 128, 128, 128, 255 ), "Disconnect while preloading player data.\n" );
			return;
			
		end
		
		if( #res == 0 ) then
			
			MsgC( Color( 128, 128, 128, 255 ), "Player record not found for " .. self:Nick() .. ". Saving...\n" );
			self:SaveNewPlayer();
			return;
			
		end
		
		GAMEMODE.PlayerData[self:SteamID()] = res[1];
		MsgC( Color( 128, 128, 128, 255 ), "Preloaded player data for " .. self:Nick() .. ".\n" );
		
		self:UpdatePlayer();
		self:LoadPlayer( res[1] );
		
		self:PreloadCharacters();
		
	end
	
	mysqloo.Query( "SELECT * FROM players WHERE SteamID = '" .. self:SteamID() .. "'", qs );
	
end

function meta:PreloadCharacters()
	
	MsgC( Color( 128, 128, 128, 255 ), "Preloading characters for " .. self:Nick() .. "...\n" );
	GAMEMODE.ItemData[self:SteamID()] = { };
	
	local function qs( res )
		
		if( !self or !self:IsValid() ) then
			
			MsgC( Color( 128, 128, 128, 255 ), "Disconnect while preloading character data.\n" );
			return;
			
		end
		
		GAMEMODE.CharData[self:SteamID()] = res;
		
		net.Start( "nLoadCharacters" );
			net.WriteTable( res );
		net.Send( self );
		
		MsgC( Color( 128, 128, 128, 255 ), "Preloaded character data for " .. self:Nick() .. ".\n" );
		
		for _, v in pairs( res ) do
			
			MsgC( Color( 128, 128, 128, 255 ), "Preloading character items for CharID " .. v.id .. "...\n" );
			
			mysqloo.Query( "SELECT * FROM items WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. v.id .. "'", function( res )
				
				if( !self or !self:IsValid() ) then
					
					MsgC( Color( 128, 128, 128, 255 ), "Disconnect while preloading item data.\n" );
					return;
					
				end
				
				GAMEMODE.ItemData[self:SteamID()][v.id] = res;
				
				MsgC( Color( 128, 128, 128, 255 ), "Preloaded item data for CharID " .. v.id .. ".\n" );
				
			end );
			
		end
		
	end
	
	mysqloo.Query( "SELECT * FROM chars WHERE SteamID = '" .. self:SteamID() .. "'", qs );
	
end

function meta:NumCharacters()
	
	if( !GAMEMODE.CharData[self:SteamID()] ) then return 0 end
	
	return #GAMEMODE.CharData[self:SteamID()];
	
end

function meta:SaveNewPlayer()
	
	local function qs( res )
		
		MsgC( Color( 128, 128, 128, 255 ), "Saved new player " .. self:Nick() .. ".\n" );
		self:PreloadPlayer();
		
	end
	
	self.New = true;
	
	mysqloo.Query( "INSERT INTO players ( SteamID, LastPlayed ) VALUES ( '" .. self:SteamID() .. "', '" .. os.time() .. "' )", qs );
	
end

function meta:UpdatePlayer()
	
	local function qs( res )
		
		MsgC( Color( 128, 128, 128, 255 ), "Player update successful.\n" );
		
	end
	
	MsgC( Color( 128, 128, 128, 255 ), "Updating player " .. self:Nick() .. "...\n" );
	mysqloo.Query( "UPDATE players SET LastPlayed = '" .. os.time() .. "' WHERE SteamID = '" .. self:SteamID() .. "'", qs );
	
end

function meta:SaveNewCharacter( class, name, desc, model, face, clothes )
	
	if( #GAMEMODE.CharData[self:SteamID()] >= GAMEMODE.MaxChars ) then return end
	
	local function qs( res, qo )
		
		local id = qo:lastInsert();
		
		local tab = { };
		tab["SteamID"] = self:SteamID();
		tab["Class"] = class;
		tab["Name"] = name;
		tab["Description"] = desc;
		tab["Model"] = model;
		tab["Face"] = face;
		tab["Clothes"] = clothes;
		tab["id"] = id;
		
		table.insert( GAMEMODE.CharData[self:SteamID()], tab );
		GAMEMODE.ItemData[self:SteamID()][id] = { };
		
		MsgC( Color( 128, 128, 128, 255 ), "Saved new character " .. name .. ".\n" );
		
		net.Start( "nLoadCharacters" );
			net.WriteTable( GAMEMODE.CharData[self:SteamID()] );
		net.Send( self );
		
		self:LoadCharacter( id );
		
	end
	
	self.New = true;
	
	mysqloo.Query( "INSERT INTO chars ( SteamID, Class, Name, Description, Model, Face, Clothes ) VALUES ( '" .. self:SteamID() .. "', '" .. mysqloo.Escape( class ) .. "', '" .. mysqloo.Escape( name ) .. "', '" .. mysqloo.Escape( desc ) .. "', '" .. model .. "', '" .. face .. "', '" .. clothes .. "' )", qs );
	
end

function meta:DeleteCharacter( id )
	
	if( self:CharID() == id ) then return end
	if( !self:GetDataByCharID( id ) ) then return end
	
	local function qS()
		
		MsgC( Color( 128, 128, 128, 255 ), "Player " .. self:Nick() .. " deleted character ID " .. id .. ".\n" );
		
	end
	
	MsgC( Color( 128, 128, 128, 255 ), "Player " .. self:Nick() .. " is deleting character ID " .. id .. "...\n" );
	
	mysqloo.Query( "DELETE FROM chars WHERE id = '" .. id .. "'", qS );
	
	GAMEMODE.CharData[self:SteamID()][self:GetIndexByCharID( id )] = nil;
	
	net.Start( "nLoadCharacters" );
		net.WriteTable( GAMEMODE.CharData[self:SteamID()] );
	net.Send( self );
	
end

function meta:UpdatePlayerField( field, val )
	
	GAMEMODE.PlayerData[self:SteamID()][field] = val;
	mysqloo.Query( "UPDATE players SET " .. field .. " = '" .. mysqloo.Escape( val ) .. "' WHERE SteamID = '" .. self:SteamID() .. "'", qs );
	
end

function meta:UpdateCharacterField( field, val )
	
	GAMEMODE.CharData[self:SteamID()][self:GetIndexByCharID( self:CharID() )][field] = val;
	mysqloo.Query( "UPDATE chars SET " .. field .. " = '" .. mysqloo.Escape( val ) .. "' WHERE id = '" .. self:CharID() .. "'", qs );
	
end

function meta:UpdateItemVars( key )
	
	local varstr = "";
	for k, v in pairs( self.Inventory[key].Vars ) do
		varstr = varstr .. k .. "|" .. v .. ";"
	end
	
	mysqloo.Query( "UPDATE items SET Vars = '" .. varstr .. "' WHERE SteamID = '" .. self:SteamID() .. "' AND CharID = '" .. self:CharID() .. "' AND X = '" .. self.Inventory[key].X .. "' AND Y = '" .. self.Inventory[key].Y .. "'", qs );
	
	for k, v in pairs( self:GetItemDataByCharID( self:CharID() ) ) do
		
		if( v.X == self.Inventory[key].X and v.Y == self.Inventory[key].Y ) then
			
			v.Vars = varstr;
			
		end
		
	end
	
end
