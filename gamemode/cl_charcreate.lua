GM.CharData = { };

local function nLoadCharacters( len )
	
	local tab = net.ReadTable();
	
	GAMEMODE.CharData[LocalPlayer():SteamID()] = tab;
	
	for _, v in pairs( GAMEMODE.CharData[LocalPlayer():SteamID()] ) do
		
		util.PrecacheModel( v.Model );
		
	end
	
end
net.Receive( "nLoadCharacters", nLoadCharacters );

function GM:CharCreateResetModel()
	
	if( self.D.CP and self.D.CP:IsValid() ) then
		
		self.D.CP:SetModel( self.CharCreateModel );
		self.D.CP.Entity:ResetSubMaterials();
		
		self.D.CP:SetSubMaterial( self.D.CP.Entity:GetFacemap(), self.CharCreateFace );
		self.D.CP:SetSubMaterial( self.D.CP.Entity:GetClothesSheet(), self.CharCreateClothes );
		
	end
	
end

function GM:CharCreateRandomModel()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		self.CharCreateModel = table.Random( table.GetKeys( self.SurvivorModels[self.CharCreateSex] ) );
		self.CharCreateFace = table.Random( self.SurvivorModels[self.CharCreateSex][self.CharCreateModel] );
		self.CharCreateClothes = table.Random( self.SurvivorClothes[self.CharCreateSex] );
		
	elseif( self.CharCreateMode == CHARCREATE_HECU ) then
		
		self.CharCreateModel = table.Random( self.HECUModels );
		self.CharCreateFace = "";
		self.CharCreateClothes = "";
		
	elseif( self.CharCreateMode == CHARCREATE_INFECTED ) then
		
		self.CharCreateModel = table.Random( table.GetKeys( self.InfectedModels[self.CharCreateSex] ) );
		self.CharCreateFace = table.Random( self.InfectedModels[self.CharCreateSex][self.CharCreateModel] );
		self.CharCreateClothes = table.Random( self.InfectedClothes[self.CharCreateSex] );
		
	elseif( self.CharCreateMode == CHARCREATE_SPECIALINFECTED ) then
		
		self.CharCreateModel = table.Random( self.SpecialInfectedModels );
		self.CharCreateFace = "";
		self.CharCreateClothes = "";
		
	end
	
end

function GM:CharCreateNextFace()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.SurvivorModels[self.CharCreateSex] ) do
			
			if( self.CharCreateModel == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFace ) then
						
						if( v[m + 1] ) then
							
							self.CharCreateFace = v[m + 1];
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateModel = table.FindNext( table.GetKeys( self.SurvivorModels[self.CharCreateSex] ), self.CharCreateModel );
							self.CharCreateFace = self.SurvivorModels[self.CharCreateSex][self.CharCreateModel][1];
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end
		
	elseif( self.CharCreateMode == CHARCREATE_HECU ) then
		
		self.CharCreateModel = table.FindNext( self.HECUModels, self.CharCreateModel );
		self:CharCreateResetModel();
		
	elseif( self.CharCreateMode == CHARCREATE_INFECTED ) then
		
		for k, v in pairs( self.InfectedModels[self.CharCreateSex] ) do
			
			if( self.CharCreateModel == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFace ) then
						
						if( v[m + 1] ) then
							
							self.CharCreateFace = v[m + 1];
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateModel = table.FindNext( table.GetKeys( self.InfectedModels[self.CharCreateSex] ), self.CharCreateModel );
							self.CharCreateFace = self.InfectedModels[self.CharCreateSex][self.CharCreateModel][1];
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end
		
	elseif( self.CharCreateMode == CHARCREATE_SPECIALINFECTED ) then
		
		self.CharCreateModel = table.FindNext( self.SpecialInfectedModels, self.CharCreateModel );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreatePrevFace()
	
	if( self.CharCreateMode == CHARCREATE_SURVIVOR ) then
		
		for k, v in pairs( self.SurvivorModels[self.CharCreateSex] ) do
			
			if( self.CharCreateModel == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFace ) then
						
						if( v[m - 1] ) then
							
							self.CharCreateFace = v[m - 1];
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateModel = table.FindPrev( table.GetKeys( self.SurvivorModels[self.CharCreateSex] ), self.CharCreateModel );
							self.CharCreateFace = self.SurvivorModels[self.CharCreateSex][self.CharCreateModel][#self.SurvivorModels[self.CharCreateSex][self.CharCreateModel]];
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end
	
	elseif( self.CharCreateMode == CHARCREATE_HECU ) then
		
		self.CharCreateModel = table.FindPrev( self.HECUModels, self.CharCreateModel );
		self:CharCreateResetModel();
		
	elseif( self.CharCreateMode == CHARCREATE_INFECTED ) then
		
		for k, v in pairs( self.InfectedModels[self.CharCreateSex] ) do
			
			if( self.CharCreateModel == k ) then
				
				for m, n in pairs( v ) do -- facemaps
					
					if( n == self.CharCreateFace ) then
						
						if( v[m - 1] ) then
							
							self.CharCreateFace = v[m - 1];
							self:CharCreateResetModel();
							return;
							
						else
							
							self.CharCreateModel = table.FindPrev( table.GetKeys( self.InfectedModels[self.CharCreateSex] ), self.CharCreateModel );
							self.CharCreateFace = self.InfectedModels[self.CharCreateSex][self.CharCreateModel][#self.InfectedModels[self.CharCreateSex][self.CharCreateModel]];
							self:CharCreateResetModel();
							return;
							
						end
						
					end
					
				end
				
			end
			
		end
		
	elseif( self.CharCreateMode == CHARCREATE_SPECIALINFECTED ) then
		
		self.CharCreateModel = table.FindPrev( self.SpecialInfectedModels, self.CharCreateModel );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreateNextClothes()
	
	if( self.CharCreateMode == CHARCREATE_INFECTED ) then
		
		self.CharCreateClothes = table.FindNext( self.InfectedClothes[self.CharCreateSex], self.CharCreateClothes );
		self:CharCreateResetModel();
		
	else
		
		self.CharCreateClothes = table.FindNext( self.SurvivorClothes[self.CharCreateSex], self.CharCreateClothes );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreatePrevClothes()
	
	if( self.CharCreateMode == CHARCREATE_INFECTED ) then
		
		self.CharCreateClothes = table.FindPrev( self.InfectedClothes[self.CharCreateSex], self.CharCreateClothes );
		self:CharCreateResetModel();
		
	else
		
		self.CharCreateClothes = table.FindPrev( self.SurvivorClothes[self.CharCreateSex], self.CharCreateClothes );
		self:CharCreateResetModel();
		
	end
	
end

function GM:CharCreateThink()
	
	if( self.CharSelectButtons ) then
		
		local hovering = false;
		
		for _, v in pairs( self.CharSelectButtons ) do
			
			if( v.Hovered ) then
				
				hovering = true;
				
				local d = LocalPlayer():GetDataByCharID( v.id );
				
				if( GAMEMODE.D.CP:GetModel() != d.Model or
					GAMEMODE.D.CP.Entity:GetSubMaterial( GAMEMODE.D.CP.Entity:GetFacemap() ) != d.Face or
					GAMEMODE.D.CP.Entity:GetSubMaterial( GAMEMODE.D.CP.Entity:GetClothesSheet() ) != d.Clothes ) then
					
					GAMEMODE.D.CP:SetModel( d.Model );
					GAMEMODE.D.CP.Entity:ResetSubMaterials();
					
					GAMEMODE.D.CP:SetSubMaterial( GAMEMODE.D.CP.Entity:GetFacemap(), d.Face );
					GAMEMODE.D.CP:SetSubMaterial( GAMEMODE.D.CP.Entity:GetClothesSheet(), d.Clothes );
					
				end
				
			end
			
		end
		
		if( !hovering ) then
			
			GAMEMODE.D.CP:SetModel( "" );
			
		end
		
	end
	
end

function GM:CharCreateSelect()
	
	self.CharCreateMode = CHARCREATE_SELECT;
	self.CharCreateFade = CurTime();
	
	self.D.CP = vgui.Create( "ICharPanel" );
	self.D.CP:SetPos( ScrW() / 2, 100 );
	self.D.CP:SetSize( ScrW() / 2, ScrH() - 100 );
	self.D.CP.Entity:SetAngles( Angle() );
	self.D.CP:SetFOV( 30 );
	
	local y = 120;
	
	self.CharSelectButtons = { };
	
	for k, v in pairs( self.CharData[LocalPlayer():SteamID()] ) do
		
		surface.SetFont( "Infected.MediumTitle" );
		local tw, th = surface.GetTextSize( v.Name );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( 100, y );
		b:SetSize( tw, th );
		b:SetText( v.Name );
		b:SetFont( "Infected.MediumTitle" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		b.id = v.id;
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			net.Start( "nSelectCharacter" );
				net.WriteFloat( self.id );
			net.SendToServer();
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
			if( GAMEMODE.D.CancelBut ) then
				
				GAMEMODE.D.CancelBut:Remove();
				
			end
			
			self:Remove();
			
		end
		b.TextButtonBackground = true;
		
		if( k == LocalPlayer():CharID() ) then
			
			b:SetDisabled( true );
			
		end
		
		table.insert( self.CharSelectButtons, b );
		
		y = y + 70;
		
	end
	
	if( LocalPlayer():CharID() > -1 ) then
		
		y = y + 40;
		
		surface.SetFont( "Infected.SubTitle" );
		local tw, th = surface.GetTextSize( "Cancel" );
		
		self.D.CancelBut = vgui.Create( "DButton" );
		self.D.CancelBut:SetPos( 100, y );
		self.D.CancelBut:SetSize( tw, th );
		self.D.CancelBut:SetText( "Cancel" );
		self.D.CancelBut:SetFont( "Infected.SubTitle" );
		self.D.CancelBut:SetDrawBackground( false );
		self.D.CancelBut:SetDrawBorder( false );
		function self.D.CancelBut:DoClick()
			
			for _, v in pairs( GAMEMODE.CharSelectButtons ) do
				
				v:Remove();
				
			end
			
			GAMEMODE.CharSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
			self:Remove();
			
		end
		self.D.CancelBut.TextButtonBackground = true;
		
	end
	
	self.CharSelectButtons[1]:MakePopup();
	
end

function GM:CharCreateDelete()
	
	self.CharCreateMode = CHARCREATE_DELETE;
	self.CharCreateFade = CurTime();
	
	self.D.CP = vgui.Create( "ICharPanel" );
	self.D.CP:SetPos( ScrW() / 2, 100 );
	self.D.CP:SetSize( ScrW() / 2, ScrH() - 100 );
	self.D.CP.Entity:SetAngles( Angle() );
	self.D.CP:SetFOV( 30 );
	
	local y = 120;
	
	self.CharSelectButtons = { };
	
	for k, v in pairs( self.CharData[LocalPlayer():SteamID()] ) do
		
		surface.SetFont( "Infected.MediumTitle" );
		local tw, th = surface.GetTextSize( v.Name );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( 100, y );
		b:SetSize( tw, th );
		b:SetText( v.Name );
		b:SetFont( "Infected.MediumTitle" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		b.id = v.id;
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			net.Start( "nDeleteCharacter" );
				net.WriteFloat( self.id );
			net.SendToServer();
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
			if( GAMEMODE.D.CancelBut ) then
				
				GAMEMODE.D.CancelBut:Remove();
				
			end
			
			self:Remove();
			
		end
		b.TextButtonBackground = true;
		
		if( k == LocalPlayer():CharID() ) then
			
			b:SetDisabled( true );
			
		end
		
		table.insert( self.CharSelectButtons, b );
		
		y = y + 70;
		
	end
	
	if( LocalPlayer():CharID() > -1 ) then
		
		y = y + 40;
		
		surface.SetFont( "Infected.SubTitle" );
		local tw, th = surface.GetTextSize( "Cancel" );
		
		self.D.CancelBut = vgui.Create( "DButton" );
		self.D.CancelBut:SetPos( 100, y );
		self.D.CancelBut:SetSize( tw, th );
		self.D.CancelBut:SetText( "Cancel" );
		self.D.CancelBut:SetFont( "Infected.SubTitle" );
		self.D.CancelBut:SetDrawBackground( false );
		self.D.CancelBut:SetDrawBorder( false );
		function self.D.CancelBut:DoClick()
			
			for _, v in pairs( GAMEMODE.CharSelectButtons ) do
				
				v:Remove();
				
			end
			
			GAMEMODE.CharSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
			self:Remove();
			
		end
		self.D.CancelBut.TextButtonBackground = true;
		
	end
	
	self.CharSelectButtons[1]:MakePopup();
	
end

function GM:CharCreateSelectClass()
	
	self.CharCreateMode = CHARCREATE_SELECTCLASS;
	self.CharCreateFade = CurTime();
	
	self.D.CP = vgui.Create( "ICharPanel" );
	self.D.CP:SetPos( ScrW() / 2, 100 );
	self.D.CP:SetSize( ScrW() / 2, ScrH() - 100 );
	self.D.CP.Entity:SetAngles( Angle() );
	self.D.CP:SetFOV( 30 );
	
	local y = 120;
	
	self.CharCreateSelectButtons = { };
	
	surface.SetFont( "Infected.MediumTitle" );
	local tw, th = surface.GetTextSize( "Survivor" );
	
	local b = vgui.Create( "DButton" );
	b:SetPos( 100, y );
	b:SetSize( tw, th );
	b:SetText( "Survivor" );
	b:SetFont( "Infected.MediumTitle" );
	b:SetDrawBackground( false );
	b:SetDrawBorder( false );
	function b:DoClick()
		
		for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
			
			if( v != self ) then
				
				v:Remove();
				
			end
			
		end
		
		GAMEMODE.CharCreateSelectButtons = nil;
		
		GAMEMODE.D.CP:Remove();
		GAMEMODE.D.CP = nil;
		
		if( GAMEMODE.D.CancelBut ) then
			
			GAMEMODE.D.CancelBut:Remove();
			
		end
		
		GAMEMODE:CharCreate( CHARCREATE_SURVIVOR );
		
		self:Remove();
		
	end
	b.TextButtonBackground = true;
	
	table.insert( self.CharCreateSelectButtons, b );
	
	y = y + 70;
	
	if( string.find( LocalPlayer():CharCreateFlags(), "m" ) ) then
		
		surface.SetFont( "Infected.MediumTitle" );
		local tw, th = surface.GetTextSize( "HECU" );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( 100, y );
		b:SetSize( tw, th );
		b:SetText( "HECU" );
		b:SetFont( "Infected.MediumTitle" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharCreateSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			if( GAMEMODE.D.CancelBut ) then
				
				GAMEMODE.D.CancelBut:Remove();
				
			end
			
			GAMEMODE:CharCreate( CHARCREATE_HECU );
			
			self:Remove();
			
		end
		b.TextButtonBackground = true;
		
		table.insert( self.CharCreateSelectButtons, b );
		
		y = y + 70;
		
	end
	
	if( string.find( LocalPlayer():CharCreateFlags(), "i" ) ) then
		
		surface.SetFont( "Infected.MediumTitle" );
		local tw, th = surface.GetTextSize( "Infected" );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( 100, y );
		b:SetSize( tw, th );
		b:SetText( "Infected" );
		b:SetFont( "Infected.MediumTitle" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharCreateSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			if( GAMEMODE.D.CancelBut ) then
				
				GAMEMODE.D.CancelBut:Remove();
				
			end
			
			GAMEMODE:CharCreate( CHARCREATE_INFECTED );
			
			self:Remove();
			
		end
		b.TextButtonBackground = true;
		
		table.insert( self.CharCreateSelectButtons, b );
		
		y = y + 70;
		
	end
	
	if( string.find( LocalPlayer():CharCreateFlags(), "s" ) ) then
		
		surface.SetFont( "Infected.MediumTitle" );
		local tw, th = surface.GetTextSize( "Special Infected" );
		
		local b = vgui.Create( "DButton" );
		b:SetPos( 100, y );
		b:SetSize( tw, th );
		b:SetText( "Special Infected" );
		b:SetFont( "Infected.MediumTitle" );
		b:SetDrawBackground( false );
		b:SetDrawBorder( false );
		function b:DoClick()
			
			for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
				
				if( v != self ) then
					
					v:Remove();
					
				end
				
			end
			
			GAMEMODE.CharCreateSelectButtons = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			if( GAMEMODE.D.CancelBut ) then
				
				GAMEMODE.D.CancelBut:Remove();
				
			end
			
			GAMEMODE:CharCreate( CHARCREATE_SPECIALINFECTED );
			
			self:Remove();
			
		end
		b.TextButtonBackground = true;
		
		table.insert( self.CharCreateSelectButtons, b );
		
		y = y + 70;
		
	end
	
	y = y + 40;
	
	surface.SetFont( "Infected.SubTitle" );
	local tw, th = surface.GetTextSize( "Cancel" );
	
	self.D.CancelBut = vgui.Create( "DButton" );
	self.D.CancelBut:SetPos( 100, y );
	self.D.CancelBut:SetSize( tw, th );
	self.D.CancelBut:SetText( "Cancel" );
	self.D.CancelBut:SetFont( "Infected.SubTitle" );
	self.D.CancelBut:SetDrawBackground( false );
	self.D.CancelBut:SetDrawBorder( false );
	function self.D.CancelBut:DoClick()
		
		for _, v in pairs( GAMEMODE.CharCreateSelectButtons ) do
			
			v:Remove();
			
		end
		
		GAMEMODE.CharCreateSelectButtons = nil;
		
		GAMEMODE.D.CP:Remove();
		GAMEMODE.D.CP = nil;
		
		GAMEMODE.StartFadeIntro = CurTime();
		GAMEMODE.IntroMode = 5;
		
		GAMEMODE.CharCreateMode = nil;
		
		self:Remove();
		
	end
	self.D.CancelBut.TextButtonBackground = true;
	
	for _, v in pairs( self.CharCreateSelectButtons ) do
		
		v:MakePopup();
		
	end
	
end

function GM:CharCreate( mode )
	
	self.CharCreateMode = mode;
	self.CharCreateFade = CurTime();
	self.CharCreateSex = MALE;
	
	self:CharCreateRandomModel();
	
	if( self.D.CCP ) then
		
		self.D.CCP:Remove();
		
	end
	
	if( self.D.CP ) then
		
		self.D.CP:Remove();
		
	end
	
	self.D.CCP = vgui.Create( "IClearPanel" );
	self.D.CCP:SetPos( ScrW() / 2, 100 );
	self.D.CCP:SetSize( ScrW() / 2, ScrH() - 100 );
	self.D.CCP:MakePopup();
	
	self.D.CP = vgui.Create( "ICharPanel" );
	self.D.CP:SetPos( 0, 100 );
	self.D.CP:SetSize( ScrW() / 2, ScrH() - 100 );
	self:CharCreateResetModel();
	self.D.CP.Entity:SetAngles( Angle() );
	self.D.CP:SetFOV( 30 );
	
	local y = 20;
	
	if( self.CharCreateMode != CHARCREATE_HECU and self.CharCreateMode != CHARCREATE_SPECIALINFECTED ) then
		
		self.D.CCP.M = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.M:SetPos( 200, y );
		self.D.CCP.M:SetSize( 100, 30 );
		self.D.CCP.M:SetFont( "Infected.SubTitle" );
		self.D.CCP.M:SetText( "Male" );
		self.D.CCP.M:SetSelected( true );
		function self.D.CCP.M:DoClick()
			
			self:SetSelected( true );
			GAMEMODE.D.CCP.F:SetSelected( false );
			
			if( GAMEMODE.CharCreateSex == FEMALE ) then
				
				GAMEMODE.CharCreateSex = MALE;
				GAMEMODE:CharCreateRandomModel();
				GAMEMODE:CharCreateResetModel();
				
			end
			
		end
		
		self.D.CCP.F = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.F:SetPos( 310, y );
		self.D.CCP.F:SetSize( 100, 30 );
		self.D.CCP.F:SetFont( "Infected.SubTitle" );
		self.D.CCP.F:SetText( "Female" );
		function self.D.CCP.F:DoClick()
			
			self:SetSelected( true );
			GAMEMODE.D.CCP.M:SetSelected( false );
			
			if( GAMEMODE.CharCreateSex == MALE ) then
				
				GAMEMODE.CharCreateSex = FEMALE;
				GAMEMODE:CharCreateRandomModel();
				GAMEMODE:CharCreateResetModel();
				
			end
			
		end
		
		y = y + 40;
		
	end
	
	self.D.CCP.NE = vgui.Create( "DTextEntry", self.D.CCP );
	self.D.CCP.NE:SetPos( 200, y );
	self.D.CCP.NE:SetSize( 300, 30 );
	self.D.CCP.NE:SetFont( "Infected.LabelLarge" );
	self.D.CCP.NE:SetTextColor( Color( 0, 0, 0, 255 ) );
	
	y = y + 40;
	
	self.D.CCP.DE = vgui.Create( "DTextEntry", self.D.CCP );
	self.D.CCP.DE:SetPos( 200, y );
	self.D.CCP.DE:SetSize( ScrW() / 2 - 200 - 100, 400 );
	self.D.CCP.DE:SetFont( "Infected.LabelLarge" );
	self.D.CCP.DE:SetTextColor( Color( 0, 0, 0, 255 ) );
	self.D.CCP.DE:SetMultiline( true );
	
	y = y + 410;
	
	self.D.CCP.F1 = vgui.Create( "DButton", self.D.CCP );
	self.D.CCP.F1:SetPos( 200, y );
	self.D.CCP.F1:SetSize( 30, 30 );
	self.D.CCP.F1:SetFont( "Infected.SubTitle" );
	self.D.CCP.F1:SetText( "<" );
	function self.D.CCP.F1:DoClick()
		
		GAMEMODE:CharCreatePrevFace();
		
	end
	
	self.D.CCP.F2 = vgui.Create( "DButton", self.D.CCP );
	self.D.CCP.F2:SetPos( 240, y );
	self.D.CCP.F2:SetSize( 30, 30 );
	self.D.CCP.F2:SetFont( "Infected.SubTitle" );
	self.D.CCP.F2:SetText( ">" );
	function self.D.CCP.F2:DoClick()
		
		GAMEMODE:CharCreateNextFace();
		
	end
	
	y = y + 40;
	
	if( self.CharCreateMode != CHARCREATE_HECU and self.CharCreateMode != CHARCREATE_SPECIALINFECTED ) then
		
		self.D.CCP.C1 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C1:SetPos( 200, y );
		self.D.CCP.C1:SetSize( 30, 30 );
		self.D.CCP.C1:SetFont( "Infected.SubTitle" );
		self.D.CCP.C1:SetText( "<" );
		function self.D.CCP.C1:DoClick()
			
			GAMEMODE:CharCreatePrevClothes();
			
		end
		
		self.D.CCP.C2 = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.C2:SetPos( 240, y );
		self.D.CCP.C2:SetSize( 30, 30 );
		self.D.CCP.C2:SetFont( "Infected.SubTitle" );
		self.D.CCP.C2:SetText( ">" );
		function self.D.CCP.C2:DoClick()
			
			GAMEMODE:CharCreateNextClothes();
			
		end
		
		y = y + 40;
		
	end
	
	if( LocalPlayer():CharID() > -1 ) then
		
		self.D.CCP.Cancel = vgui.Create( "DButton", self.D.CCP );
		self.D.CCP.Cancel:SetPos( ScrW() / 2 - 100, ScrH() - 100 - 60 - 50 );
		self.D.CCP.Cancel:SetSize( 80, 40 );
		self.D.CCP.Cancel:SetFont( "Infected.SubTitle" );
		self.D.CCP.Cancel:SetText( "Cancel" );
		function self.D.CCP.Cancel:DoClick()
			
			GAMEMODE.D.CCP:Remove();
			GAMEMODE.D.CCP = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
		end
		
	end
	
	self.D.CCP.Done = vgui.Create( "DButton", self.D.CCP );
	self.D.CCP.Done:SetPos( ScrW() / 2 - 80, ScrH() - 100 - 60 );
	self.D.CCP.Done:SetSize( 60, 40 );
	self.D.CCP.Done:SetFont( "Infected.SubTitle" );
	self.D.CCP.Done:SetText( "Done" );
	function self.D.CCP.Done:DoClick()
		
		local class = PLAYERCLASS_SURVIVOR;
		
		if( mode == CHARCREATE_HECU ) then class = PLAYERCLASS_MILITARY end
		if( mode == CHARCREATE_INFECTED ) then class = PLAYERCLASS_INFECTED end
		if( mode == CHARCREATE_SPECIALINFECTED ) then class = PLAYERCLASS_SPECIALINFECTED end
		
		local name = GAMEMODE.D.CCP.NE:GetValue();
		local desc = GAMEMODE.D.CCP.DE:GetValue();
		local model = GAMEMODE.CharCreateModel;
		local face = GAMEMODE.CharCreateFace;
		local clothes = GAMEMODE.CharCreateClothes;
		
		local ret, reason = GAMEMODE:CheckValidCharacter( LocalPlayer(), class, name, desc, model, face, clothes );
		
		if( !ret ) then
			
			GAMEMODE.CharCreateBad = reason;
			GAMEMODE.CharCreateBadStart = CurTime();
			
		else
			
			net.Start( "nCreateCharacter" );
				net.WriteFloat( class );
				net.WriteString( name );
				net.WriteString( desc );
				net.WriteString( model );
				net.WriteString( face );
				net.WriteString( clothes );
			net.SendToServer();
			
			GAMEMODE.D.CCP:Remove();
			GAMEMODE.D.CCP = nil;
			
			GAMEMODE.D.CP:Remove();
			GAMEMODE.D.CP = nil;
			
			GAMEMODE.StartFadeIntro = CurTime();
			GAMEMODE.IntroMode = 5;
			
			GAMEMODE.CharCreateMode = nil;
			
		end
		
	end
	
end