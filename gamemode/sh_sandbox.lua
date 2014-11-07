GM.PropBlacklist = {
	"models/props_c17/oildrum001_explosive.mdl",
	"models/props_junk/gascan001a.mdl",
	"*models/props_phx/",
	"*models/phx/",
	"*models/maxofs2d/",
	"*models/balloons/",
	"*models/perftest/",
	"*models/shadertest/",
	"*models/hunter/",
	"*models/props_combine/",
	"*models/combine_room/",
	"models/cranes/crane_frame.mdl",
	"models/props_c17/metalladder003.mdl",
	"models/props_canal/canal_bridge01.mdl",
	"models/props_canal/canal_bridge02.mdl",
	"models/props_canal/canal_bridge03a.mdl",
	"models/props_c17/furniturechair001a.mdl",
	"models/vehicles/car001b_hatchback.mdl",
	"models/props_junk/propane_tank001a.mdl",
};

GM.ToolTrustBlacklist = {
	"balloon",
	"dynamite",
	"eyeposer",
	"faceposer",
	"finger",
	"inflator",
	"trails",
	"creator"
};

GM.SandboxBlacklist = {
	"prop_door_rotating",
	"func_door_rotating",
	"inf_zombie",
	"func_door",
	"func_monitor",
	"func_brush",
	"prop_dynamic",
	"prop_dynamic_override",
	"func_breakable",
	"func_movelinear",
	"func_button",
	"func_breakable_surf",
	"env_headcrabcanister",
};

function GM:LimitReachedProcess( ply, str )
	
	if( game.SinglePlayer() ) then return true end
	if( !ply or !ply:IsValid() ) then return true end
	
	local c = cvars.Number( "sbox_max" .. str, 0 );
	
	if( str == "props" ) then
		
		if( ply:ToolTrust() ) then c = c * 5; end
		--if( ply:CustomMaxProps() != 0 ) then c = c + ply:CustomMaxProps(); end
		
	end
	
	if( str == "ragdolls" ) then
		
		--if( ply:CustomMaxRagdolls() != 0 ) then c = ply:CustomMaxRagdolls(); end
		
	end
	
	if( ply:GetCount( str ) < c or c < 0 ) then return true; end 
	
	ply:LimitHit( str );
	return false;

end

function GM:CanDrive( ply, ent )
	
	return false;
	
end

function GM:PlayerGiveSWEP( ply, weapon, info )
	
	return false;
	
end

function GM:PlayerSpawnedProp( ply, model, ent )
	
	if( !ply:IsAdmin() and ent:BoundingRadius() > 400 and ply:ToolTrust() ) then
		
		--self:LogSandbox( "[S] " .. ply:VisibleRPName() .. " tried to spawn prop " .. model .. ", but it was too big (" .. math.Round( ent:BoundingRadius() ) .. " > 400).", ply );
		ent:Remove();
		
		--net.Start( "nAddNotification" );
		--	net.WriteString( "That prop is too big." );
		--net.Send( ply );
		
		return false;
		
	end
	
	if( !ply:IsAdmin() and ent:BoundingRadius() > 100 and !ply:ToolTrust() ) then
		
		--self:LogSandbox( "[S] " .. ply:VisibleRPName() .. " tried to spawn prop " .. model .. ", but it was too big (" .. math.Round( ent:BoundingRadius() ) .. " > 100).", ply );
		ent:Remove();
		
		--net.Start( "nAddNotification" );
		--	net.WriteString( "That prop is too big." );
		--net.Send( ply );
		
		return false;
		
	end
	
	--ent:SetPropCreator( ply:RPName() .. " (" .. ply:VisibleRPName() .. ")" );
	--ent:SetPropSteamID( ply:SteamID() );
	
	return self.BaseClass:PlayerSpawnedProp( ply, model, ent );
	
end

function GM:PlayerSpawnEffect( ply, model )
	
	if( ply:IsAdmin() ) then
		
		if( SERVER ) then
			
			--self:LogSandbox( "[E] " .. ply:VisibleRPName() .. " spawned effect " .. model .. ".", ply );
			
		end
		
		return true;
		
	end
	
	return false;
	
end

function GM:PlayerSpawnNPC( ply, npctype, weapon )
	
	return false;
	
end

function GM:PlayerSpawnObject( ply, model, skin )
	
	return self.BaseClass:PlayerSpawnObject( ply, model, skin );
	
end

function GM:PlayerSpawnProp( ply, model )
	
	if( ply:IsAdmin() ) then
		
		if( SERVER ) then
			
			--self:LogSandbox( "[S] " .. ply:VisibleRPName() .. " spawned prop " .. model .. ".", ply );
			
		end
		
		return true;
		
	end
	
	if( !ply.NextPropSpawn ) then ply.NextPropSpawn = 0; end
	if( CurTime() < ply.NextPropSpawn ) then return false end
	ply.NextPropSpawn = CurTime() + 1;
	
	if( table.HasValue( self.PropBlacklist, string.lower( model ) ) ) then
		
		if( CLIENT ) then
			
			GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "That prop is banned." );
			
		end
		
		return false;
		
	end
	
	for _, v in pairs( self.PropBlacklist ) do
		
		if( string.find( v, "*" ) == 1 ) then
			
			if( string.find( string.lower( model ), string.sub( v, 2 ), nil, true ) ) then
				
				if( CLIENT ) then
					
					GAMEMODE:AddChat( { CB_ALL, CB_OOC }, "Infected.ChatNormal", COLOR_ERROR, "That prop is banned." );
					
				end
				
				return false;
				
			end
			
		end
		
	end
	
	if( !ply:Alive() ) then return false end
	
	if( self:LimitReachedProcess( ply, "props" ) ) then
		
		if( SERVER ) then
			
			--self:LogSandbox( "[S] " .. ply:VisibleRPName() .. " spawned prop " .. model .. ".", ply );
			
		end
		
		return true;
		
	end
	
	return false;
	
end

function GM:PlayerSpawnRagdoll( ply, model )
	
	if( ply:IsAdmin() ) then
		
		if( SERVER ) then
			
			--self:LogSandbox( "[R] " .. ply:VisibleRPName() .. " spawned ragdoll " .. model .. ".", ply );
			
		end
		
		return true;
		
	end
	
	return false;
	
end

function GM:PlayerSpawnSENT( ply, class )
	
	return false;
	
end

function GM:PlayerSpawnSWEP( ply, class, info )
	
	return false;
	
end

function GM:PlayerSpawnVehicle( ply, model, name, tab )
	
	if( ply:IsAdmin() ) then
		
		if( SERVER ) then
			
			--self:LogSandbox( "[V] " .. ply:VisibleRPName() .. " spawned vehicle " .. name .. ".", ply );
			
		end
		
		return true;
		
	end
	
	return false;
	
end

function GM:CanTool( ply, tr, tool )
	
	if( ply:SteamID() == STEAMID_DISSEMINATE and tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
		
		if( tool == "remover" ) then
			
			local ed = EffectData();
				ed:SetEntity( tr.Entity );
			util.Effect( "entity_remove", ed, true, true );
			
			ply:GetActiveWeapon():EmitSound( Sound( "Airboat.FireGunRevDown" ) );
			ply:GetActiveWeapon():SendWeaponAnim( ACT_VM_PRIMARYATTACK );
			ply:SetAnimation( PLAYER_ATTACK1 );
			
			local effectdata = EffectData();
				effectdata:SetOrigin( tr.HitPos );
				effectdata:SetNormal( tr.HitNormal );
				effectdata:SetEntity( tr.Entity );
				effectdata:SetAttachment( tr.PhysicsBone );
			util.Effect( "selection_indicator", effectdata );
			
			local effectdata = EffectData();
				effectdata:SetOrigin( tr.HitPos );
				effectdata:SetStart( ply:GetShootPos() );
				effectdata:SetAttachment( 1 );
				effectdata:SetEntity( ply:GetActiveWeapon() );
			util.Effect( "ToolTracer", effectdata );
			
			if( SERVER ) then
				
				local nick = tr.Entity:Nick();
				
				tr.Entity:Kick( "Kicked by " .. ply:Nick() );
				
				net.Start( "nRemoved" );
					net.WriteString( nick );
					net.WriteEntity( ply );
				net.Broadcast();
				
			end
			
			return true;
			
		end
		
	end
	
	if( table.HasValue( self.SandboxBlacklist, tr.Entity:GetClass() ) ) then return false end
	
	if( ply:IsAdmin() ) then
		
		if( SERVER ) then
			
			--if( self:NoToolLog( ply, tr, tool ) ) then return true end
			
			--self:LogSandbox( "[T] " .. ply:VisibleRPName() .. " used tool " .. tool .. " on " .. tr.Entity:GetClass() .. ".", ply );
			
		end
		
		return true;
		
	end
	
	if( tr.Entity:IsPlayer() ) then return false end
	if( tr.Entity:IsNPC() ) then return false end
	
	if( !ply:ToolTrust() ) then return false end
	
	if( table.HasValue( self.ToolTrustBlacklist, tool ) ) then return false end
	
	if( self.BaseClass:CanTool( ply, tr, tool ) ) then
		
		if( SERVER ) then
			
			--if( self:NoToolLog( ply, tr, tool ) ) then return true end
			
			--self:LogSandbox( "[T] " .. ply:VisibleRPName() .. " used tool " .. tool .. " on " .. tr.Entity:GetClass() .. ".", ply );
			
		end
		
		return true;
		
	end
	
	return false;
	
end

function GM:OnPhysgunFreeze( wep, phys, ent, ply )
	
	if( table.HasValue( self.SandboxBlacklist, ent:GetClass() ) ) then return false end
	if( ent.CanPhysgun and !ent:CanPhysgun() ) then return false end
	
	if( ply:IsAdmin() ) then return self.BaseClass:OnPhysgunFreeze( wep, phys, ent, ply ) end
	
	if( ent:IsNPC() ) then return false end
	if( ent:IsPlayer() ) then return false end
	
	if( !ply:PhysTrust() ) then return false end
	
	return self.BaseClass:OnPhysgunFreeze( wep, phys, ent, ply );
	
end

function GM:OnPhysgunReload( physgun, ply )
	
	local trace = { };
	trace.start = ply:GetShootPos();
	trace.endpos = ply:GetEyeTrace().HitPos;
	trace.filter = { physgun, ply };
	local tr = util.TraceLine( trace );
	
	local ent = tr.Entity;
	
	if( ent and ent:IsValid() ) then
		
		if( table.HasValue( self.SandboxBlacklist, ent:GetClass() ) ) then return false end
		if( ent.CanPhysgun and !ent:CanPhysgun() ) then return false end
		
		if( ply:IsAdmin() ) then return self.BaseClass:OnPhysgunReload( physgun, ply ) end
		
		if( !ply:PhysTrust() ) then return false end
		
	end
	
	local ret = self.BaseClass:OnPhysgunReload( physgun, ply );
	
	if( ret ) then
		
		return true;
		
	end
	
	return false;
	
end

function GM:PhysgunPickup( ply, ent )
	
	if( ent:IsPlayer() and ent:IsBot() and ply:IsAdmin() ) then return true end
	if( table.HasValue( self.SandboxBlacklist, ent:GetClass() ) ) then return false end
	if( ent.CanPhysgun and !ent:CanPhysgun() ) then return false end
	
	if( ply:IsAdmin() ) then
		
		if( self.BaseClass:PhysgunPickup( ply, ent ) ) then
			
			return true;
			
		end
		
	end
	
	if( ent:IsPlayer() ) then return false end
	if( ent:IsNPC() ) then return false end
	
	if( !ply:PhysTrust() ) then return false end
	
	if( !ply:ToolTrust() and ent:GetPos():Distance( ply:GetPos() ) > 300 ) then return false end
	
	local ret = self.BaseClass:PhysgunPickup( ply, ent );
	
	if( ret ) then
		
		return true;
		
	end
	
end

function GM:PhysgunDrop( ply, ent )
	
	self.BaseClass:PhysgunDrop( ply, ent );
	
	if( !ply:IsAdmin() ) then
		ent:SetVelocity( Vector() );
	end
	
	return true;
	
end

function GM:CanProperty( ply, prop, ent )
	
	return false;
	
end

list.Add( "OverrideMaterials", "models/props_c17/metalladder001" );
list.Add( "OverrideMaterials", "models/props_c17/metalladder002" );
list.Add( "OverrideMaterials", "models/props_c17/metalladder003" );
list.Add( "OverrideMaterials", "models/props_debris/metalwall001a" );
list.Add( "OverrideMaterials", "models/props_canal/metalwall005b" );
list.Add( "OverrideMaterials", "models/props_combine/metal_combinebridge001" );
list.Add( "OverrideMaterials", "models/props_interiors/metalfence007a" );
list.Add( "OverrideMaterials", "models/props_pipes/pipeset_metal02" );
list.Add( "OverrideMaterials", "models/props_pipes/pipeset_metal" );
list.Add( "OverrideMaterials", "models/props_wasteland/metal_tram001a" );
list.Add( "OverrideMaterials", "models/props_canal/metalcrate001d" );
list.Add( "OverrideMaterials", "models/weapons/v_stunbaton/w_shaft01a" );
list.Add( "OverrideMaterials", "models/props_wasteland/lighthouse_stairs" );
list.Add( "OverrideMaterials", "models/props_debris/plasterwall021a" );
list.Add( "OverrideMaterials", "models/props_debris/plasterwall009d" );
list.Add( "OverrideMaterials", "models/props_debris/plasterwall034a" );
list.Add( "OverrideMaterials", "models/props_debris/plasterwall039c" );
list.Add( "OverrideMaterials", "models/props_debris/plasterwall040c" );
list.Add( "OverrideMaterials", "models/props_debris/concretefloor013a" );
list.Add( "OverrideMaterials", "models/props_wasteland/concretefloor010a" );
list.Add( "OverrideMaterials", "models/props_debris/concretewall019a" );
list.Add( "OverrideMaterials", "models/props_wasteland/concretewall064b" );
list.Add( "OverrideMaterials", "models/props_wasteland/concretewall066a" );
list.Add( "OverrideMaterials", "models/props_debris/building_template012d" );
list.Add( "OverrideMaterials", "models/props_wasteland/dirtwall001a" );
list.Add( "OverrideMaterials", "models/props_combine/masterinterface01c" );
list.Add( "OverrideMaterials", "effects/breenscreen_static01_" );
list.Add( "OverrideMaterials", "models/props_lab/security_screens" );
list.Add( "OverrideMaterials", "models/props_lab/security_screens2" );
list.Add( "OverrideMaterials", "effects/minescreen_static01_" );
list.Add( "OverrideMaterials", "console/background01_widescreen" );
list.Add( "OverrideMaterials", "effects/c17_07camera" );
list.Add( "OverrideMaterials", "effects/com_shield002a" );
list.Add( "OverrideMaterials", "effects/c17_07camera" );
list.Add( "OverrideMaterials", "effects/combinedisplay_core_" );
list.Add( "OverrideMaterials", "effects/combinedisplay_dump" );
list.Add( "OverrideMaterials", "effects/combinedisplay001a" );
list.Add( "OverrideMaterials", "effects/combinedisplay001b" );
list.Add( "OverrideMaterials", "models/props_lab/eyescanner_disp" );
list.Add( "OverrideMaterials", "effects/combine_binocoverlay" );
list.Add( "OverrideMaterials", "models/props_lab/generatorconsole_disp" );
list.Add( "OverrideMaterials", "models/props_lab/computer_disp" );
list.Add( "OverrideMaterials", "models/combine_helicopter/helicopter_bomb01" );
list.Add( "OverrideMaterials", "models/props_combine/introomarea_disp" );
list.Add( "OverrideMaterials", "models/props_combine/tpballglow" );
list.Add( "OverrideMaterials", "models/props_combine/combine_door01_glass" );
list.Add( "OverrideMaterials", "models/props_combine/Combine_Citadel001" );
list.Add( "OverrideMaterials", "models/props_combine/combine_fenceglow" );
list.Add( "OverrideMaterials", "models/props_combine/combine_intmonitor001_disp" );
list.Add( "OverrideMaterials", "models/props_combine/combine_monitorbay_disp" );
list.Add( "OverrideMaterials", "models/props_combine/masterinterface_alert" );
list.Add( "OverrideMaterials", "models/props_combine/weaponstripper_sheet" );
list.Add( "OverrideMaterials", "models/Combine_Helicopter/helicopter_bomb01" );
list.Add( "OverrideMaterials", "models/props_combine/combine_interface_disp" );
list.Add( "OverrideMaterials", "models/props_combine/tprings_sheet" );
list.Add( "OverrideMaterials", "models/props_combine/combinethumper002" );
list.Add( "OverrideMaterials", "models/props_combine/tprotato1_sheet" );
list.Add( "OverrideMaterials", "models/props_combine/pipes01" );
list.Add( "OverrideMaterials", "models/combine_mine/combine_mine_citizen" );
list.Add( "OverrideMaterials", "models/combine_mine/combine_mine_citizen2" );
list.Add( "OverrideMaterials", "models/combine_mine/combine_mine_citizen3" );
list.Add( "OverrideMaterials", "models/combine_turrets/floor_turret/floor_turret_citizen" );
list.Add( "OverrideMaterials", "models/combine_turrets/floor_turret/floor_turret_citizen2" );
list.Add( "OverrideMaterials", "models/combine_turrets/floor_turret/floor_turret_citizen4" );
list.Add( "OverrideMaterials", "effects/prisonmap_disp" );
list.Add( "OverrideMaterials", "models/effects/vortshield" );
list.Add( "OverrideMaterials", "effects/tvscreen_noise001a" );
list.Add( "OverrideMaterials", "effects/combinedisplay002a" );
list.Add( "OverrideMaterials", "effects/combinedisplay002b" );
list.Add( "OverrideMaterials", "models/props_foliage/oak_tree01" );
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff02b" );
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff02c" );
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff04a" );
list.Add( "OverrideMaterials", "models/props_wasteland/rockcliff02a" );
list.Add( "OverrideMaterials", "models/dav0r/hoverball" );
list.Add( "OverrideMaterials", "models/props_junk/ravenholmsign_sheet" );
list.Add( "OverrideMaterials", "models/props_junk/TrafficCone001a" );
list.Add( "OverrideMaterials", "models/props_c17/frostedglass_01a_dx60" );
list.Add( "OverrideMaterials", "models/props_canal/rock_riverbed01a" );
list.Add( "OverrideMaterials", "models/props_canal/canalmap_sheet" );
list.Add( "OverrideMaterials", "models/props_canal/coastmap_sheet" );
list.Add( "OverrideMaterials", "models/effects/slimebubble_sheet" );
list.Add( "OverrideMaterials", "models/Items/boxart1" );
list.Add( "OverrideMaterials", "models//props/de_tides/clouds" );
list.Add( "OverrideMaterials", "models/props_c17/fisheyelens" );
list.Add( "OverrideMaterials", "models/Shadertest/predator" );
list.Add( "OverrideMaterials", "models/props_lab/warp_sheet" );
list.Add( "OverrideMaterials", "models/props_c17/furniturefabric001a" );
list.Add( "OverrideMaterials", "models/props_c17/furniturefabric002a" );
list.Add( "OverrideMaterials", "models/props_c17/furniturefabric003a" );
list.Add( "OverrideMaterials", "models/props_c17/oil_drum001h" );
list.Add( "OverrideMaterials", "models/props_junk/glassbottle01b" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin10" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin11" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin12" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin13" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin14" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin15" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin16" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin2" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin3" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin4" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin5" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin6" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin7" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin8" );
list.Add( "OverrideMaterials", "models/props_c17/door01a_skin9" );
list.Add( "OverrideMaterials", "models/props_c17/hospital_bed01_skin2" );
list.Add( "OverrideMaterials", "models/props_c17/hospital_surgerytable01_skin2" );
list.Add( "OverrideMaterials", "models/props_animated_breakable/smokestack/brickwall002a" );
list.Add( "OverrideMaterials", "models/props_animated_breakable/smokestack/brick_chimney01" );
list.Add( "OverrideMaterials", "models/props_building_details/courtyard_template001c_bars" );
list.Add( "OverrideMaterials", "models/props_c17/awning001a" );
list.Add( "OverrideMaterials", "models/props_c17/awning001b" );
list.Add( "OverrideMaterials", "models/props_c17/awning001c" );
list.Add( "OverrideMaterials", "models/props_c17/awning001d" );
list.Add( "OverrideMaterials", "models/props_c17/chairchrome01" );
list.Add( "OverrideMaterials", "models/props_c17/concretewall020a" );
list.Add( "OverrideMaterials", "models/props_c17/door03a_glass" );
list.Add( "OverrideMaterials", "models/props_c17/gate_door01a" );
list.Add( "OverrideMaterials", "models/props_combine/combine_cell_burned" );
list.Add( "OverrideMaterials", "models/props_combine/coredx70" );