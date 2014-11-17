include( "sh_enum.lua" );
include( "shared.lua" );
include( "sh_accessor.lua" );
include( "sh_admin.lua" );
include( "sh_animations.lua" );
include( "sh_chatcmd.lua" );
include( "sh_items.lua" );
include( "sh_models.lua" );
include( "sh_player.lua" );
include( "sh_playerclass.lua" );
include( "sh_sandbox.lua" );
include( "sh_soundscripts.lua" );
include( "gui/cl_inventory.lua" );
include( "gui/cl_gui.lua" );
include( "gui/cl_guiext.lua" );
include( "gui/cl_skin.lua" );
include( "cl_admin.lua" );
include( "cl_binds.lua" );
include( "cl_charcreate.lua" );
include( "cl_chat.lua" );
include( "cl_dev.lua" );
include( "cl_hud.lua" );
include( "cl_items.lua" );
include( "cl_map.lua" );
include( "cl_sound.lua" );
include( "cl_think.lua" );

GM.D = { };

local files = file.Find( GM.FolderName .. "/gamemode/maps/" .. game.GetMap() .. ".lua", "LUA", "namedesc" );

if( #files > 0 ) then

	for _, v in pairs( files ) do
		
		include( "maps/" .. v );
		AddCSLuaFile( "maps/" .. v );
		
	end
	
	MsgC( Color( 128, 128, 128, 255 ), "Map lua file for " .. game.GetMap() .. " loaded serverside.\n" );
	
end