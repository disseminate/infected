function GM:ToggleHolsterThink()
	
	if( !self.ToggleHolsterPressed ) then self.ToggleHolsterPressed = false; end
	
	if( vgui.CursorVisible() ) then self.ToggleHolsterPressed = false; return end
	
	if( input.IsKeyDown( KEY_B ) and !self.ToggleHolsterPressed ) then
		
		self.ToggleHolsterPressed = true;
		
		if( LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" or
				LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" ) then
				
				return false;
				
			end
			
		end
		
		net.Start( "nToggleHolster" );
		net.SendToServer();
		
		if( LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon().Holsterable ) then
				
				LocalPlayer():SetHolstered( !LocalPlayer():Holstered() );
				
			else
				
				LocalPlayer():SetHolstered( false );
				
			end
			
		end
		
	elseif( !input.IsKeyDown( KEY_B ) and self.ToggleHolsterPressed ) then
		
		self.ToggleHolsterPressed = false;
		
	end
	
end

function GM:GetWeaponSlot()
	
	if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return 1 end
	if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_inf_hands" ) then return 1 end
	if( LocalPlayer():GetActiveWeapon().PrimaryWep ) then return 2 end
	if( LocalPlayer():GetActiveWeapon().SecondaryWep ) then return 3 end
	if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" ) then return 4 end
	if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_toolgun" ) then return 5 end
	
	return 1;
	
end

function GM:GetWeaponBySlot( i )
	
	if( i == 1 ) then return "weapon_inf_hands" end
	if( i == 4 ) then return "weapon_physgun" end
	if( i == 5 ) then return "weapon_toolgun" end
	
	for _, v in pairs( LocalPlayer():GetWeapons() ) do
		
		if( i == 2 and v:GetTable().PrimaryWep ) then return v:GetClass() end
		if( i == 3 and v:GetTable().SecondaryWep ) then return v:GetClass() end
		
	end
	
	return "";
	
end

function GM:PlayerBindPress( ply, b, d )
	
	if( d and b == "+jump" and self.IntroMode == 1 and !self.StartFadeIntro ) then
		
		if( CurTime() - self.IntroFadeStart > 3 ) then
			
			self.StartFadeIntro = CurTime();
			self:StopSong( 1 );
			surface.PlaySound( "infected/ui/mainmenu.mp3" );
			return true;
			
		end
		
	end
	
	if( d and b == "gm_showhelp" ) then
		
		self:ShowF1();
		return true;
		
	end
	
	if( d and b == "gm_showteam" ) then
		
		self:ShowF2();
		return true;
		
	end
	
	if( d and b == "gm_showspare1" ) then
		
		self:ShowF3();
		return true;
		
	end
	
	if( d and string.find( b, "messagemode" ) ) then
		
		self:CreateChatbox();
		return true;
		
	end
	
	if( d and b == "+use" ) then
		
		local tr = ply:GetHandTrace( 400 );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
			
			self:ShowPlayerCard( tr.Entity );
			
			return true;
			
		end
		
	end
	
	if( d and string.find( b, "rp_toggleholster" ) ) then
		
		if( LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" or
				LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" ) then
				
				return false;
				
			end
			
		end
		
		net.Start( "nToggleHolster" );
		net.SendToServer();
		
		if( LocalPlayer():GetActiveWeapon() != NULL ) then
			
			if( LocalPlayer():GetActiveWeapon().Holsterable ) then
				
				LocalPlayer():SetHolstered( !LocalPlayer():Holstered() );
				
			else
				
				LocalPlayer():SetHolstered( false );
				
			end
			
		end
		
		return true;
		
	end
	
	if( d and string.find( b, "slot" ) ) then
		
		if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return true end
		
		local n = string.gsub( b, "slot", "" );
		
		if( tonumber( n ) and tonumber( n ) >= 1 and tonumber( n ) <= 5 ) then
			
			local wep = self:GetWeaponBySlot( tonumber( n ) );
			
			if( LocalPlayer():HasWeapon( wep ) ) then
				
				net.Start( "nSelectWeapon" );
					net.WriteString( wep );
				net.SendToServer();
				
			end
			
		end
		
		return true;
		
	end
	
	if( d and b == "invnext" ) then
		
		if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return true end
		
		if( !self.WeaponSlot ) then self.WeaponSlot = self:GetWeaponSlot(); end
		
		self.WeaponSlot = self.WeaponSlot + 1;
		
		if( self.WeaponSlot > 5 ) then self.WeaponSlot = 1 end
		
		local wep = self:GetWeaponBySlot( self.WeaponSlot );
		
		while( !LocalPlayer():HasWeapon( wep ) ) do
			
			self.WeaponSlot = self.WeaponSlot + 1;
			if( self.WeaponSlot > 5 ) then self.WeaponSlot = 1 end
			wep = self:GetWeaponBySlot( self.WeaponSlot );
			
		end
		
		net.Start( "nSelectWeapon" );
			net.WriteString( wep );
		net.SendToServer();
		
		return true;
		
	end
	
	if( d and b == "invprev" ) then
		
		if( !LocalPlayer():GetActiveWeapon() or !LocalPlayer():GetActiveWeapon():IsValid() ) then return true end
		
		if( !self.WeaponSlot ) then self.WeaponSlot = self:GetWeaponSlot(); end
		
		self.WeaponSlot = self.WeaponSlot - 1;
		
		if( self.WeaponSlot < 1 ) then self.WeaponSlot = 5 end
		
		local wep = self:GetWeaponBySlot( self.WeaponSlot );
		
		while( !LocalPlayer():HasWeapon( wep ) ) do
			
			self.WeaponSlot = self.WeaponSlot - 1;
			if( self.WeaponSlot < 1 ) then self.WeaponSlot = 5 end
			wep = self:GetWeaponBySlot( self.WeaponSlot );
			
		end
		
		net.Start( "nSelectWeapon" );
			net.WriteString( wep );
		net.SendToServer();
		
		return true;
		
	end
	
	return self.BaseClass:PlayerBindPress( ply, b, d );
	
end

GM.HelpTopics = { };
GM.HelpTopics[1] = { "Credits", [[Disseminate - Infected.

Johnny Guitar - support.

Testers:
   Aimosal
   Casadis
   DoctorX
   Hoplite
   Matt
   SnowingMonkey]] };

function GM:ShowF1()
	
	self.D.F1 = vgui.Create( "DFrame" );
	self.D.F1:SetSize( 500, 700 );
	self.D.F1:Center();
	self.D.F1:SetTitle( "Help" );
	self.D.F1:MakePopup();
	
	for k, v in pairs( self.HelpTopics ) do
		
		local b = vgui.Create( "DButton", self.D.F1 );
		b:SetPos( 10, 24 + 10 + 40 * ( k - 1 ) );
		b:SetSize( 128, 30 );
		b:SetFont( "Infected.TinyTitle" );
		b:SetText( v[1] );
		function b:DoClick()
			
			GAMEMODE.D.F1.Text:SetText( v[2] );
			GAMEMODE.D.F1.Text:PerformLayout();
			
		end
		
	end
	
	self.D.F1.Text = vgui.Create( "DLabel", self.D.F1 );
	self.D.F1.Text:SetPos( 148, 24 + 10 );
	self.D.F1.Text:SetSize( 500 - 148 - 10, 24 + 10 );
	self.D.F1.Text:SetWrap( true );
	self.D.F1.Text:SetAutoStretchVertical( true );
	self.D.F1.Text:SetFont( "Infected.LabelSmall" );
	self.D.F1.Text:SetText( "" );
	
end

function GM:ShowF2()
	
	self:ShowInventory();
	
end

function GM:ShowF3()
	
	self:ShowPlayerCard( LocalPlayer(), true );
	
end

function GM:ShowPlayerCard( ply, me )
	
	self.D.F3 = vgui.Create( "DFrame" );
	self.D.F3:SetSize( 500, 700 );
	self.D.F3:Center();
	if( me ) then
		self.D.F3:SetTitle( "Player Menu" );
	else
		self.D.F3:SetTitle( ply:RPName() );
	end
	self.D.F3:MakePopup();
	
	self.D.F3.P = vgui.Create( "ICharPanel", self.D.F3 );
	self.D.F3.P:SetPos( 10, 34 );
	self.D.F3.P:SetSize( 128, 128 );
	self.D.F3.P:SetModel( ply:GetModel() );
	
	for i = 0, #ply:GetMaterials() - 1 do
		
		self.D.F3.P:SetSubMaterial( i, ply:GetSubMaterial( i ) );
		
	end
	
	self.D.F3.P:SetCamPos( Vector( 50, 20, 67 ) );
	self.D.F3.P:SetLookAt( Vector( 0, 0, 67 ) );
	self.D.F3.P:SetFOV( 15 );
	
	self.D.F3.P.NoMouseWheel = true;
	
	self.D.F3.N = vgui.Create( "DLabel", self.D.F3 );
	self.D.F3.N:SetPos( 148, 34 );
	self.D.F3.N:SetFont( "Infected.SubTitle" );
	self.D.F3.N:SetText( ply:RPName() );
	self.D.F3.N:SizeToContents();
	self.D.F3.N:SetTextColor( Color( 255, 255, 255, 255 ) );
	
	self.D.F3.DS = vgui.Create( "DScrollPanel", self.D.F3 );
	self.D.F3.DS:SetPos( 148, 64 );
	self.D.F3.DS:SetSize( 500 - 148 - 10, 700 - 64 - 10 );
	function self.D.F3.DS:Paint( w, h ) end
	
	self.D.F3.D = vgui.Create( "DLabel", self.D.F3.DS );
	self.D.F3.D:SetPos( 0, 0 );
	self.D.F3.D:SetFont( "Infected.LabelSmall" );
	self.D.F3.D:SetText( ply:Desc() );
	self.D.F3.D:SetAutoStretchVertical( true );
	self.D.F3.D:SetWrap( true );
	self.D.F3.D:SetSize( 500 - 148 - 10 - 16, 10 );
	self.D.F3.D:SetTextColor( Color( 255, 255, 255, 255 ) );
	self.D.F3.D:PerformLayout();
	
	if( me ) then
		
		self.D.F3.CN = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CN:SetPos( 10, 24 + 10 + 128 + 10 );
		self.D.F3.CN:SetSize( 128, 30 );
		self.D.F3.CN:SetFont( "Infected.TinyTitle" );
		self.D.F3.CN:SetText( "Change Name" );
		function self.D.F3.CN:DoClick()
			
			GAMEMODE:CreatePopupEntry( "Change Name", LocalPlayer():RPName(), GAMEMODE.MinNameLength, GAMEMODE.MaxNameLength, function( text )
				
				if( GAMEMODE.D.F3.N and GAMEMODE.D.F3.N:IsValid() ) then
					
					GAMEMODE.D.F3.N:SetText( text );
					GAMEMODE.D.F3.N:SizeToContents();
					
				end
				
				net.Start( "nChangeName" );
					net.WriteString( text );
				net.SendToServer();
				
			end );
			
		end
		
		self.D.F3.CD = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CD:SetPos( 10, 24 + 10 + 128 + 10 + 30 + 10 );
		self.D.F3.CD:SetSize( 128, 30 );
		self.D.F3.CD:SetFont( "Infected.TinyTitle" );
		self.D.F3.CD:SetText( "Change Description" );
		function self.D.F3.CD:DoClick()
			
			GAMEMODE:CreatePopupEntry( "Change Description", LocalPlayer():Desc(), 0, GAMEMODE.MaxDescLength, function( text )
				
				if( GAMEMODE.D.F3.D and GAMEMODE.D.F3.D:IsValid() ) then
					
					GAMEMODE.D.F3.D:SetText( text );
					GAMEMODE.D.F3.D:PerformLayout()
					
				end
				
				net.Start( "nChangeDesc" );
					net.WriteString( text );
				net.SendToServer();
				
			end, true );
			
		end
		
		self.D.F3.E_S = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.E_S:SetPos( 10, 24 + 10 + 128 + 10 + 30 + 10 + 30 + 10 + 30 + 10 );
		self.D.F3.E_S:SetSize( 128, 30 );
		self.D.F3.E_S:SetFont( "Infected.TinyTitle" );
		self.D.F3.E_S:SetText( "Expression: Scared" );
		function self.D.F3.E_S:DoClick()
			
			net.Start( "nSetExpression" );
				net.WriteFloat( 1 );
			net.SendToServer();
			
		end
		
		self.D.F3.E_A = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.E_A:SetPos( 10, 24 + 10 + 128 + 10 + 30 + 10 + 30 + 10 + 30 + 10 + 30 + 10 );
		self.D.F3.E_A:SetSize( 128, 30 );
		self.D.F3.E_A:SetFont( "Infected.TinyTitle" );
		self.D.F3.E_A:SetText( "Expression: Angry" );
		function self.D.F3.E_A:DoClick()
			
			net.Start( "nSetExpression" );
				net.WriteFloat( 2 );
			net.SendToServer();
			
		end
		
		self.D.F3.E_F = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.E_F:SetPos( 10, 24 + 10 + 128 + 10 + 30 + 10 + 30 + 10 + 30 + 10 + 30 + 10 + 30 + 10 );
		self.D.F3.E_F:SetSize( 128, 30 );
		self.D.F3.E_F:SetFont( "Infected.TinyTitle" );
		self.D.F3.E_F:SetText( "Expression: Furious" );
		function self.D.F3.E_F:DoClick()
			
			net.Start( "nSetExpression" );
				net.WriteFloat( 3 );
			net.SendToServer();
			
		end
		
		self.D.F3.CC = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CC:SetPos( 10, 700 - 120 );
		self.D.F3.CC:SetSize( 128, 30 );
		self.D.F3.CC:SetFont( "Infected.TinyTitle" );
		self.D.F3.CC:SetText( "Change Character" );
		function self.D.F3.CC:DoClick()
			
			GAMEMODE.IntroMode = 4;
			GAMEMODE:CharCreateSelect();
			
			GAMEMODE.D.F3:Remove();
			
		end
		
		if( #GAMEMODE.CharData[LocalPlayer():SteamID()] < 2 ) then
			
			self.D.F3.CC:SetDisabled( true );
			
		end
		
		self.D.F3.DC = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.DC:SetPos( 10, 700 - 80 );
		self.D.F3.DC:SetSize( 128, 30 );
		self.D.F3.DC:SetFont( "Infected.TinyTitle" );
		self.D.F3.DC:SetText( "Delete Character" );
		function self.D.F3.DC:DoClick()
			
			GAMEMODE.IntroMode = 4;
			GAMEMODE:CharCreateDelete();
			
			GAMEMODE.D.F3:Remove();
			
		end
		
		if( #GAMEMODE.CharData[LocalPlayer():SteamID()] < 2 ) then
			
			self.D.F3.DC:SetDisabled( true );
			
		end
		
		self.D.F3.CNC = vgui.Create( "DButton", self.D.F3 );
		self.D.F3.CNC:SetPos( 10, 700 - 40 );
		self.D.F3.CNC:SetSize( 128, 30 );
		self.D.F3.CNC:SetFont( "Infected.TinyTitle" );
		self.D.F3.CNC:SetText( "Create Character" );
		function self.D.F3.CNC:DoClick()
			
			GAMEMODE.IntroMode = 4;
			
			if( LocalPlayer():CharCreateFlags() == "" ) then
				GAMEMODE:CharCreate( CHARCREATE_SURVIVOR );
			else
				GAMEMODE:CharCreateSelectClass();
			end
			
			GAMEMODE.D.F3:Remove();
			
		end
		
		if( #GAMEMODE.CharData[LocalPlayer():SteamID()] >= GAMEMODE.MaxChars ) then
			
			self.D.F3.CNC:SetDisabled( true );
			
		end
		
	end
	
end