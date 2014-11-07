function GM:SetupDataDirectories()
	
	file.CreateDir( "Infected" );
	file.CreateDir( "Infected/nodes" );
	file.CreateDir( "Infected/logs" );
	file.CreateDir( "Infected/logs/" .. os.date( "%y-%m-%d" ) );
	
end

function GM:Log( filename, prefix, str, ply )
	
	local f = "Infected/logs/" .. os.date( "%y-%m-%d" ) .. "/" .. filename .. ".txt";
	local write = os.date( "%m-%H-%S" ) .. "\t[" .. prefix .. "]\t" .. str;
	
	if( ply and ply:IsValid() ) then
		
		write = os.date( "%m-%H-%S" ) .. "\t" .. ply:SteamID() .. "\t[" .. prefix .. "]\t" .. str;
		
	end
	
	if( file.Exists( f, "DATA" ) ) then
		
		file.Append( f, "\n" .. write );
		
	else
		
		file.Write( f, write );
		
	end
	
end