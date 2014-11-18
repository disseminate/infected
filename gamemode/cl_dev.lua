function ccCreateIronsightsDev()
	
	local d = vgui.Create( "DFrame" );
	d:SetSize( 150, 234 );
	d:SetPos( 50, 50 );
	d:SetTitle( "" );
	d:MakePopup();
	
	local tab = { };
	
	for i = 1, 6 do
		
		local s = vgui.Create( "DNumberScratch", d );
		s:SetPos( 20, 24 + 10 + ( ( i - 1 ) * 30 ) );
		s:SetSize( 110, 20 );
		s:SetMin( -90 );
		s:SetMax( 90 );
		
		if( GAMEMODE.IronOverride ) then
			
			s:SetValue( GAMEMODE.IronOverride[i] );
			
		end
		
		function s:OnValueChanged()
			
			local frac = self:GetFloatValue();
			
			if( !GAMEMODE.IronOverride ) then GAMEMODE.IronOverride = { 0, 0, 0, 0, 0, 0 } end
			
			GAMEMODE.IronOverride[self.n] = frac;
			
		end
		
		s.n = i;
		tab[i] = s;
		
	end
	
	local b = vgui.Create( "DButton", d );
	b:SetPos( 10, 204 );
	b:SetSize( 75 - 10 - 5, 20 );
	b:SetText( "Reset" );
	function b:DoClick()
		
		for i = 1, 6 do
			
			tab[i]:SetValue( 0 );
			
		end
		
		GAMEMODE.IronOverride = nil;
		
	end
	
	local b = vgui.Create( "DButton", d );
	b:SetPos( 80, 204 );
	b:SetSize( 75 - 10 - 5, 20 );
	b:SetText( "Copy" );
	
	function b:DoClick()
		
		for _, v in pairs( { "Holster", "Aim" } ) do
			
			MsgN( "SWEP." .. v .. "Pos = Vector( " .. math.Round( tab[4]:GetFloatValue(), 2 ) .. ", " .. math.Round( tab[5]:GetFloatValue(), 2 ) .. ", " .. math.Round( tab[6]:GetFloatValue(), 2 ) .. " );" );
			
			if( tab[1]:GetFloatValue() == 0 and tab[2]:GetFloatValue() == 0 and tab[3]:GetFloatValue() == 0 ) then
				
				MsgN( "SWEP." .. v .. "Ang = Angle();" );
				
			else
				
				MsgN( "SWEP." .. v .. "Ang = Angle( " .. math.Round( tab[1]:GetFloatValue(), 2 ) .. ", " .. math.Round( tab[2]:GetFloatValue(), 2 ) .. ", " .. math.Round( tab[3]:GetFloatValue(), 2 ) .. " );" );
				
			end
			
		end
		
	end
	
end
concommand.Add( "dev_ironsights", ccCreateIronsightsDev );

local function ModelViewerInit( mdl, filter )
	
	local d = vgui.Create( "DFrame" );
	d:SetSize( 500, 624 );
	d:SetPos( 50, 50 );
	d:SetTitle( mdl );
	d:MakePopup();
	
	d.mdl = vgui.Create( "ICharPanel", d );
	d.mdl:SetPos( 0, 24 );
	d.mdl:SetSize( 500, 500 );
	d.mdl:SetModel( mdl );
	d.mdl:SetLookAt( d.mdl.Entity:OBBCenter() );
	d.mdl:SetFOV( 50 );
	d.mdl:SetAnimated( true );
	d.mdl.Entity:SetPoseParameter( "move_x", 1 );
	
	d.anim = vgui.Create( "DComboBox", d );
	d.anim:SetPos( 10, 534 );
	d.anim:SetSize( 480, 30 );
	d.anim:SetValue( "Anim" );
	
	local n = { };
	
	for i = 1, 10000 do
		
		local seq = d.mdl.Entity:SelectWeightedSequence( i );
		
		if( seq > -1 ) then
			
			if( !filter or string.find( d.mdl.Entity:GetSequenceName( seq ), filter ) ) then
				
				d.anim:AddChoice( "(" .. i .. ") " .. d.mdl.Entity:GetSequenceName( seq ), seq );
				table.insert( n, d.mdl.Entity:GetSequenceName( seq ) );
				
			end
			
		end
		
	end
	
	local l = d.mdl.Entity:GetSequenceList();
	
	for _, v in pairs( l ) do
		
		if( !table.HasValue( n, v ) ) then
			
			if( !filter or string.find( v, filter ) ) then
				
				d.anim:AddChoice( "(-1) " .. v, d.mdl.Entity:LookupSequence( v ) );
				
			end
			
		end
		
	end
	
	function d.anim:OnSelect( idx, val, data )
		
		d.mdl.Entity:SetCycle( 0 );
		d.mdl.Entity:SetPlaybackRate( 1 );
		d.mdl.Entity:ResetSequence( data );
		d.mdl:SetLookAt( Vector() );
		
	end
	
end

function ccCreateModelViewer( ply, cmd, args )
	
	if( args[1] == "1" ) then
		
		ModelViewerInit( ply:GetModel(), args[2] );
		
	else
		
		GAMEMODE:CreatePopupEntry( "Enter model", "", 0, nil, ModelViewerInit );
		
	end
	
end
concommand.Add( "dev_modelviewer", ccCreateModelViewer );

function ccCreateItemViewer( ply, cmd, args )
	
	local g = vgui.Create( "IIconEditor" );
	g:SetModel( args[1] );
	g:Refresh()
	g:MakePopup()
	g:Center()
	
end
concommand.Add( "dev_itemviewer", ccCreateItemViewer );
