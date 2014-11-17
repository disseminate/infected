surface.CreateFont( "Infected.MainTitle", {
	font = "BebasNeue",
	size = 100,
	weight = 500,
	antialias = true } );

surface.CreateFont( "Infected.MediumTitle", {
	font = "BebasNeue",
	size = 50,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.SubTitle", {
	font = "BebasNeue",
	size = 30,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.TinyTitle", {
	font = "BebasNeue",
	size = 20,
	weight = 300,
	antialias = true } );
	
surface.CreateFont( "Infected.FrameTitle", {
	font = "BebasNeue",
	size = 24,
	weight = 300,
	antialias = true } );
	
surface.CreateFont( "Infected.BigButton", {
	font = "BebasNeue",
	size = 100,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.SmallButton", {
	font = "Myriad Pro",
	size = 20,
	weight = 500,
	antialias = true } );

surface.CreateFont( "Infected.LabelLarge", {
	font = "Myriad Pro",
	size = 30,
	weight = 500,
	antialias = true } );

surface.CreateFont( "Infected.LabelSmall", {
	font = "Myriad Pro",
	size = 20,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.PlayerName", {
	font = "BebasNeue",
	size = 30,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.PlayerNameSmall", {
	font = "BebasNeue",
	size = 20,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.AmmoClip", {
	font = "BebasNeue",
	size = 70,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.AmmoCount", {
	font = "BebasNeue",
	size = 50,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.ChatSmall", {
	font = "Myriad Pro",
	size = 14,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.ChatNormal", {
	font = "Myriad Pro",
	size = 18,
	weight = 500,
	antialias = true } );
	
surface.CreateFont( "Infected.ChatNormalI", {
	font = "Myriad Pro",
	size = 18,
	weight = 500,
	antialias = true,
	italic = true } );
	
surface.CreateFont( "Infected.ChatBig", {
	font = "Myriad Pro",
	size = 26,
	weight = 500,
	antialias = true } );

function GM:HUDShouldDraw( str )
	
	--if( str == "CHudWeaponSelection" ) then return false end
	if( str == "CHudAmmo" ) then return false end
	if( str == "CHudAmmoSecondary" ) then return false end
	if( str == "CHudSecondaryAmmo" ) then return false end
	if( str == "CHudHealth" ) then return false end
	if( str == "CHudBattery" ) then return false end
	--if( str == "CHudChat" ) then return false end
	if( str == "CHudDamageIndicator" ) then return false end
	
	if( str == "CHudCrosshair" ) then
		
		local wep = LocalPlayer():GetActiveWeapon();
		
		if( wep and wep:IsValid() and wep != NULL ) then
			
			if( wep:GetClass() == "gmod_tool" or wep:GetClass() == "weapon_physgun" or wep:GetClass() == "weapon_physcannon" ) then
				
				return true
				
			end
			
		end
		
		return false;
		
	end
	
	return true
	
end

function GM:CalcView( ply, pos, ang, fov, znear, zfar )
	
	local ct = ( math.sin( CurTime() / 10 ) + 1 ) / 2;
	
	if( self.IntroMode == 1 and self.MainIntroCams ) then
		
		local cp = LerpVector( ct, self.MainIntroCams[1][1], self.MainIntroCams[2][1] );
		local ca = LerpAngle( ct, self.MainIntroCams[1][2], self.MainIntroCams[2][2] );
		
		return { origin = cp, angles = ca, fov = fov };
		
	end
	
	return self.BaseClass:CalcView( ply, pos, ang, fov, znear, zfar );
	
end

function draw.DrawDiagonals( col, x, y, w, h, density )
	
	surface.SetDrawColor( col );
	
	for i = 0, w + h, density do
		
		if( i < h ) then
			
			surface.DrawLine( x + i, y, x, y + i );
			
		elseif( i > w ) then
			
			surface.DrawLine( x + w, y + i - w, x - h + i, y + h );
			
		else
			
			surface.DrawLine( x + i, y, x + i - h, y + h );
			
		end
		
	end
	
end

function draw.DrawProgressBar( perc, x, y, w, h, col )
	
	perc = math.Clamp( perc, 0, 1 );
	
	draw.RoundedBox( 0, x, y, w, h, Color( 0, 0, 0, 150 ) );
	draw.RoundedBox( 0, x + 2, y + 2, ( w - 4 ) * perc, h - 4, col );
	draw.DrawDiagonals( Color( col.r * 0.8, col.g * 0.8, col.b * 0.8, col.a ), x + 2, y + 2, w - 4, h - 4, 4 );
	
end

local matBlurScreen = Material( "pp/blurscreen" );

function draw.DrawBackgroundBlur( frac )
	
	if( frac == 0 ) then return end
	
	DisableClipping( true );
	
	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 );
	
	for i = 1, 3 do
		
		matBlurScreen:SetFloat( "$blur", frac * 5 * ( i / 3 ) )
		matBlurScreen:Recompute();
		render.UpdateScreenEffectTexture();
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );
		
	end
	
	DisableClipping( false );

end

function draw.DrawBlur( x, y, w, h, us, vs, ue, ve, frac )
	
	if( frac == 0 ) then return end
	
	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 );
	
	for i = 1, 3 do
		
		matBlurScreen:SetFloat( "$blur", frac * 5 * ( i / 3 ) )
		matBlurScreen:Recompute();
		render.UpdateScreenEffectTexture();
		surface.DrawTexturedRectUV( x, y, w, h, us, vs, ue, ve );
		
	end

end

function draw.DrawTextShadow( text, font, x, y, color, color2, mode )
	
	draw.DrawText( text, font, x, y, color2, mode );
	draw.DrawText( text, font, x + 1, y + 1, color, mode );
	
end

GM.LogoBigMat = Material( "infected/vgui/logobig.png", "unlitgeneric mips" );

GM.IntroLines = {
	"There was no hope of survival.",
	"The first outbreak was in New York City.",
	"Why it started is unknown.",
	"This is the story of how you died."
};

function GM:HUDPaintIntro()
	
	if( !self.IntroMode ) then self.IntroMode = 1 end
	if( !self.StartFadeIntro ) then self.StartFadeIntro = nil; end
	if( !self.IntroFadeStart ) then
		
		self.IntroFadeStart = CurTime();
		self:PlaySong( self.Music.Light[1] );
		
	end
	
	if( self.IntroMode == 1 ) then
		
		if( !self.MainIntroCams ) then
			
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
			surface.DrawRect( 0, 0, ScrW(), ScrH() );
			
		end
		
		DrawToyTown( 3, 0.4 );
		
		local as = math.Clamp( CurTime() - self.IntroFadeStart - 3, 0, 1 );
		
		local w = self.LogoBigMat:Width();
		local h = self.LogoBigMat:Height();
		
		local ratio = h / w;
		
		local lw = ScrW() * 0.55;
		local lh = lw * ratio;
		
		surface.SetMaterial( self.LogoBigMat );
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRect( ScrW() * 0.5 - lw / 2, ScrH() * 0.3 - lh / 2, lw, lh );
		
		surface.SetFont( "Infected.MainTitle" );
		local text = "This is the story of how you died";
		
		local tw, th = surface.GetTextSize( text );
		
		surface.SetTextPos( ScrW() * 0.5 - tw / 2, ScrH() * 0.5 - th / 2 );
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.DrawText( text );
		
		-- lw - tw
		local x1 = ScrW() / 2 - lw / 2;
		local x2 = ScrW() / 2 + lw / 2;
		local linewidth = ( lw - tw ) / 2 - 20;
		
		for i = 1, 0, -1 do
			
			surface.DrawLine( x1, ScrH() * 0.5 - i, x1 + linewidth, ScrH() * 0.5 - i );
			surface.DrawLine( x2, ScrH() * 0.5 - i, x2 - linewidth, ScrH() * 0.5 - i );
			
		end
		
		surface.SetFont( "Infected.SubTitle" );
		local text = "Press space to continue";
		
		tw, th = surface.GetTextSize( text );
		
		surface.SetTextPos( ScrW() / 2 - tw / 2, ScrH() * 0.9 - th / 2 );
		surface.SetTextColor( Color( 255, 255, 255, 255 * as ) );
		surface.DrawText( text );
		
		if( self.StartFadeIntro ) then
			
			local d = CurTime() - self.StartFadeIntro;
			local a = math.Clamp( d, 0, 1 );
			
			surface.SetDrawColor( Color( 0, 0, 0, 255 * a ) );
			surface.DrawRect( 0, 0, ScrW(), ScrH() );
			
			if( d > 4 ) then
				
				if( cookie.GetNumber( "inf_introlines", 1 ) == 1 ) then
					
					self.IntroMode = 2;
					cookie.Set( "inf_introlines", 1 );
					
				else
					
					self.IntroMode = 3;
					
				end
				
				self.StartFadeIntro = CurTime();
				
			end
			
		end
		
	elseif( self.IntroMode == 2 ) then
		
		local d = CurTime() - self.StartFadeIntro;
		
		local ai = { };
		
		for i = 1, #self.IntroLines do
			
			ai[i] = math.Clamp( d - ( i - 1 ) * 3, 0, 1 );
			
		end
		
		if( d > #self.IntroLines * 3 + 3 ) then
			
			local fadea = d - ( #self.IntroLines * 3 + 3 );
			
			for k, v in pairs( ai ) do
				
				ai[k] = math.Clamp( 1 - fadea, 0, 1 );
				
			end
			
		end
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		local y = 10;
		
		for k, v in pairs( self.IntroLines ) do
			
			surface.SetFont( "Infected.SubTitle" );
			
			surface.SetTextPos( 10, y );
			surface.SetTextColor( Color( 255, 255, 255, 255 * ai[k] ) );
			surface.DrawText( v );
			
			local tw, th = surface.GetTextSize( v );
			
			y = y + th + 10;
			
		end
		
		if( d > #self.IntroLines * 3 + 3 + 3 ) then
			
			self.IntroMode = 3;
			self.StartFadeIntro = CurTime();
			
		end
		
	elseif( self.IntroMode == 3 ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		if( a == 0 ) then
			
			self.IntroMode = 4;
			
		end
		
	elseif( self.IntroMode == 4 ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	elseif( self.IntroMode == 5 ) then
		
		local d = CurTime() - self.StartFadeIntro;
		local a = 1 - math.Clamp( d, 0, 1 );
		local ba = 1 - math.Clamp( d, 0, 3 ) / 3;
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 * a ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		draw.DrawBackgroundBlur( ba );
		
		if( ba == 0 ) then
			
			self.IntroMode = 6;
			
		end
		
	end
	
end

function GM:HUDPaintCharCreate()
	
	if( self.CharCreateMode == CHARCREATE_SELECT ) then
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
	elseif( self.CharCreateMode == CHARCREATE_DELETE ) then
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who's finished?" );
		
	elseif( self.CharCreateMode == CHARCREATE_SELECTCLASS ) then
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "What are you?" );
		
	elseif( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		local a = 1;
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 * a ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
		
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
		surface.SetFont( "Infected.SubTitle" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 120 );
		surface.DrawText( "Sex" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 160 );
		surface.DrawText( "Name" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 200 );
		surface.DrawText( "Description" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 610 );
		surface.DrawText( "Face" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 650 );
		surface.DrawText( "Clothes" );
		
	elseif( self.CharCreateMode == CHARCREATE_HECU ) then
		
		local a = 1;
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 * a ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
		
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
		surface.SetFont( "Infected.SubTitle" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 120 );
		surface.DrawText( "Name" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 160 );
		surface.DrawText( "Description" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 570 );
		surface.DrawText( "Uniform" );
		
	elseif( self.CharCreateMode == CHARCREATE_INFECTED ) then
		
		local a = 1;
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 * a ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
		
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
		surface.SetFont( "Infected.SubTitle" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 120 );
		surface.DrawText( "Sex" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 160 );
		surface.DrawText( "Name" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 200 );
		surface.DrawText( "Description" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 610 );
		surface.DrawText( "Face" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 650 );
		surface.DrawText( "Clothes" );
		
	elseif( self.CharCreateMode == CHARCREATE_SPECIALINFECTED ) then
		
		local a = 1;
		
		draw.DrawDiagonals( Color( 50, 50, 50, 255 * a ), 0, 0, ScrW(), 100, 10 );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 * a ) );
		
		surface.SetFont( "Infected.MainTitle" );
		
		surface.SetTextPos( 10, 10 );
		surface.DrawText( "Who are you?" );
		
		surface.SetFont( "Infected.SubTitle" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 120 );
		surface.DrawText( "Name" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 160 );
		surface.DrawText( "Description" );
		
		surface.SetTextPos( ScrW() / 2 + 20, 570 );
		surface.DrawText( "Mutation" );
		
	end
	
	if( self.CharCreateMode and self.CharCreateMode >= CHARCREATE_SURVIVOR ) then
		
		if( GAMEMODE.CharCreateBadStart and CurTime() - GAMEMODE.CharCreateBadStart < 10 ) then
			
			local w, h = surface.GetTextSize( GAMEMODE.CharCreateBad );
			
			local ba = 0;
			
			if( CurTime() - GAMEMODE.CharCreateBadStart < 1 ) then
				
				ba = CurTime() - GAMEMODE.CharCreateBadStart;
				
			elseif( CurTime() - GAMEMODE.CharCreateBadStart < 9 ) then
				
				ba = 1;
				
			else
				
				ba = math.Clamp( 1 - ( CurTime() - GAMEMODE.CharCreateBadStart - 9 ), 0, 1 );
				
			end
			
			surface.SetTextColor( Color( 255, 255, 255, 255 * ba ) );
			
			surface.SetTextPos( ScrW() - 80 - w - 10, ScrH() - 55 );
			surface.DrawText( GAMEMODE.CharCreateBad );
			
		end
		
	end
	
end

GM.HUDFlies = { };

function GM:HUDPaintInfected()
	
	if( LocalPlayer():PlayerClass() != PLAYERCLASS_INFECTED and LocalPlayer():PlayerClass() != PLAYERCLASS_SPECIALINFECTED ) then return end
	
	if( !self.NextHUDFlies ) then self.NextHUDFlies = 0 end
	
	if( CurTime() >= self.NextHUDFlies and #self.HUDFlies < 10 ) then
		
		self.NextHUDFlies = CurTime() + 0.1;
		
		local side = math.random( 1, 4 );
		local x, y, vel;
		local accel = { math.Rand( -1, 1 ), math.Rand( -1, 1 ) };
		
		if( side == 1 ) then
			
			x = math.random( 0, ScrW() );
			y = 0;
			vel = { math.Rand( -1, 1 ), math.Rand( 0, 1 ) };
			
		elseif( side == 2 ) then
			
			x = ScrW();
			y = math.random( 0, ScrH() );
			vel = { math.Rand( -1, 0 ), math.Rand( -1, 1 ) };
			
		elseif( side == 3 ) then
			
			x = math.random( 0, ScrW() );
			y = ScrH();
			vel = { math.Rand( -1, 1 ), math.Rand( -1, 0 ) };
			
		else
			
			x = 0;
			y = math.random( 0, ScrH() );
			vel = { math.Rand( 0, 1 ), math.Rand( -1, 1 ) };
			
		end
		
		local tab = { };
		tab.x = x;
		tab.y = y;
		tab.vel = vel;
		tab.accel = accel;
		
		table.insert( self.HUDFlies, tab );
		
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, math.random( 100, 255 ) ) );
	
	for k, v in pairs( self.HUDFlies ) do
		
		if( self.HUDFlies[k].x < 0 or self.HUDFlies[k].x > ScrW() or self.HUDFlies[k].y < 0 or self.HUDFlies[k].y > ScrH() ) then
			
			table.remove( self.HUDFlies, k );
			
		else
			
			self.HUDFlies[k].x = self.HUDFlies[k].x + self.HUDFlies[k].vel[1] / 5;
			self.HUDFlies[k].y = self.HUDFlies[k].y + self.HUDFlies[k].vel[2] / 5;
			self.HUDFlies[k].vel[1] = self.HUDFlies[k].vel[1] + self.HUDFlies[k].accel[1] / 5;
			self.HUDFlies[k].vel[2] = self.HUDFlies[k].vel[2] + self.HUDFlies[k].accel[2] / 5;
			
			surface.DrawRect( self.HUDFlies[k].x, self.HUDFlies[k].y, math.random( 3, 6 ), math.random( 3, 6 ) );
			
		end
		
	end
	
end

function GM:HUDPaintOthers()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v != LocalPlayer() ) then
			
			if( !v.HUDA ) then v.HUDA = 0 end
			
			local pos = v:EyePos();
			local ts = ( pos + Vector( 0, 0, 12 ) ):ToScreen();
			
			if( self.SeeAll or (
				pos:Distance( LocalPlayer():EyePos() ) < 768 and
				LocalPlayer():CanSeePlayer( v ) and
				!v:GetNoDraw() and
				v:Alive() ) ) then
				
				v.HUDA = math.Approach( v.HUDA, 1, FrameTime() );
				
			else
				
				v.HUDA = math.Approach( v.HUDA, 0, FrameTime() );
				
			end
			
			if( v.HUDA > 0 ) then
				
				draw.DrawText( v:RPName(), "Infected.PlayerName", ts.x, ts.y, Color( 255, 255, 255, 255 * v.HUDA ), 1 );
				
				if( v:Typing() > 0 ) then
					
					draw.DrawText( "Typing...", "Infected.PlayerNameSmall", ts.x, ts.y + 30, Color( 255, 255, 255, 255 * v.HUDA ), 1 );
					
				end
				
			end
			
		end
		
	end
	
	for _, v in pairs( ents.FindByClass( "inf_zombie" ) ) do
		
		if( !v.HUDA ) then v.HUDA = 0 end
		
		local pos = v:GetPos();
		local ts = ( pos + Vector( 0, 0, 76 ) ):ToScreen();
		
		if( self.SeeAll ) then
			
			v.HUDA = math.Approach( v.HUDA, 1, FrameTime() );
			
		else
			
			v.HUDA = math.Approach( v.HUDA, 0, FrameTime() );
			
		end
		
		if( v.HUDA > 0 ) then
			
			draw.DrawText( "Z", "Infected.PlayerName", ts.x, ts.y, Color( 255, 0, 0, 255 * v.HUDA ), 1 );
			
		end
		
	end
	
end

function GM:PreDrawHalos()
	
	
	
end

function GM:HUDPaintHealth()
	
	if( !PercHealth ) then PercHealth = 1; end
	if( !PercArmor ) then PercArmor = 0; end
	if( !PercStamina ) then PercStamina = 1; end
	
	PercHealth = math.Approach( PercHealth, LocalPlayer():Health() / 100, FrameTime() );
	PercArmor = math.Approach( PercArmor, LocalPlayer():Armor() / 100, FrameTime() );
	PercStamina = math.Approach( PercStamina, PercStamina, FrameTime() );
	
	local barh = 14;
	local y = ScrH() - 20 - barh;
	
	if( PercHealth < 1 ) then
		draw.DrawProgressBar( PercHealth, 20, y, 200, barh, Color( 170, 0, 0, 255 ) );
		y = y - 10 - barh;
	end
	
	if( PercArmor > 0 ) then
		draw.DrawProgressBar( PercArmor, 20, y, 200, barh, Color( 170, 170, 170, 255 ) );
		y = y - 10 - barh;
	end
	
	if( PercStamina < 1 ) then
		draw.DrawProgressBar( PercStamina, 20, y, 200, barh, Color( 170, 170, 0, 255 ) );
		y = y - 10 - barh;
	end
	
end

function GM:HUDPaintWeapon()
	
	if( LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() ) then
		
		local wep = LocalPlayer():GetActiveWeapon();
		
		surface.SetFont( "Infected.SubTitle" );
		local w, h = surface.GetTextSize( wep:GetPrintName() );
		
		draw.RoundedBox( 0, ScrW() - w - 10, ScrH() - 10 - h, w, h, Color( 0, 0, 0, 200 ) );
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetTextPos( ScrW() - w - 10, ScrH() - 10 - h );
		surface.DrawText( wep:GetPrintName() );
		
		--
		
		if( LocalPlayer():Holstered() ) then
			
			
			
		else
			
			if( wep:Clip1() > -1 ) then
				
				surface.SetFont( "Infected.AmmoClip" );
				local w, h = surface.GetTextSize( wep:Clip1() );
				
				local x = ScrW() - 10 - w;
				
				draw.RoundedBox( 0, x, ScrH() - 50 - h, w, h, Color( 0, 0, 0, 200 ) );
				
				surface.SetTextPos( x, ScrH() - 50 - h );
				surface.DrawText( wep:Clip1() );
				
			end
			
		end
		
	end
	
end

function GM:HUDPaintDeath()
	
	if( !LocalPlayer():Alive() ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
		surface.SetFont( "Infected.MainTitle" );
		local text = "Rest In Piece";
		
		if( !game.IsDedicated() or self.PrivateMode ) then
			
			text = "Rest In Pepperonis";
			
		end
		
		local tw, th = surface.GetTextSize( text );
		
		surface.SetTextPos( ScrW() / 2 - tw / 2, ScrH() / 2 - th / 2 );
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.DrawText( text );
		
		surface.SetFont( "Infected.SubTitle" );
		local text = "You have died.";
		
		local tw2, th2 = surface.GetTextSize( text );
		
		surface.SetTextPos( ScrW() / 2 - tw2 / 2, ScrH() / 2 + th / 2 );
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.DrawText( text );
		
	end
	
end

function GM:HUDPaintDebug()
	
	
	
end

function GM:HUDPaint()
	
	self:HUDPaintInfected();
	
	self:HUDPaintOthers();
	
	self:HUDPaintHealth();
	self:HUDPaintWeapon();
	self:HUDPaintChat();
	self:HUDPaintDeath();
	
	self:HUDPaintIntro();
	self:HUDPaintCharCreate();
	
	self:HUDPaintDebug();
	
end

GM.ColorModDeContrast = { };
GM.ColorModDeContrast["$pp_colour_addr"] = 0;
GM.ColorModDeContrast["$pp_colour_addg"] = 0;
GM.ColorModDeContrast["$pp_colour_addb"] = 0;
GM.ColorModDeContrast["$pp_colour_brightness"] = 0;
GM.ColorModDeContrast["$pp_colour_contrast"] = 1;
GM.ColorModDeContrast["$pp_colour_colour"] = 0.8;
GM.ColorModDeContrast["$pp_colour_mulr"] = 0;
GM.ColorModDeContrast["$pp_colour_mulg"] = 0;
GM.ColorModDeContrast["$pp_colour_mulb"] = 0;

GM.ColorModInfected = { };
GM.ColorModInfected["$pp_colour_addr"] = 0;
GM.ColorModInfected["$pp_colour_addg"] = 0;
GM.ColorModInfected["$pp_colour_addb"] = 0;
GM.ColorModInfected["$pp_colour_brightness"] = 0;
GM.ColorModInfected["$pp_colour_contrast"] = 1;
GM.ColorModInfected["$pp_colour_colour"] = 0.35;
GM.ColorModInfected["$pp_colour_mulr"] = 0;
GM.ColorModInfected["$pp_colour_mulg"] = 0;
GM.ColorModInfected["$pp_colour_mulb"] = 0;

function GM:RenderScreenspaceEffects()
	
	if( self.IntroMode == 1 ) then
		
		DrawToyTown( 5, ScrH() * 0.3 );
		
	end
	
	DrawColorModify( self.ColorModDeContrast );
	
	if( LocalPlayer():PlayerClass() == PLAYERCLASS_INFECTED or LocalPlayer():PlayerClass() == PLAYERCLASS_SPECIALINFECTED ) then
		
		DrawColorModify( self.ColorModInfected );
		
	end
	
end