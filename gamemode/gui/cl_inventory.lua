local PANEL = { };

function PANEL:Paint( w, h )
	
	return true;

end

derma.DefineControl( "IInventoryBack", "", PANEL, "EditablePanel" );

local PANEL = { };

function PANEL:Paint( w, h )
	
	surface.SetDrawColor( Color( 255, 255, 255, 40 ) );
	surface.DrawOutlinedRect( 0, 0, w, h );
	return true;

end

function PANEL:OnMousePressed()
	
	GAMEMODE:DeselectInventory();
	
end

derma.DefineControl( "IInventorySquare", "", PANEL, "EditablePanel" );

local PANEL = { };

AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )

function PANEL:Init()
	
	self.LastPaint = 0;
	
	self:SetText( "" );
	
	self:SetAmbientLight( Color( 50, 50, 50 ) );
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) );
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) );
	
	self:SetColor( Color( 255, 255, 255, 255 ) );
	
	self.Entity = ClientsideModel( "models/humans/group01/male_01.mdl", RENDER_GROUP_OPAQUE_ENTITY );
	
end

function PANEL:SetModel( strModelName )
	
	self.Entity:SetModel( strModelName );
	self:BestGuessLayout();
	
end

function PANEL:GetModel()
	
	return self.Entity:GetModel();
	
end

function PANEL:Paint( w, h )
	
	if( !IsValid( self.Entity ) ) then return end
	
	surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
	surface.DrawRect( 0, 0, w, h );
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	self:LayoutEntity( self.Entity )
	
	cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetSize() )
		cam.IgnoreZ( true )
		
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.Entity:GetPos() )
		render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
		render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
		render.SetBlend( self.colColor.a / 255 )
		
		for i=0, 6 do
			local col = self.DirectionalLight[ i ]
			if ( col ) then
				render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
			end
		end
		
		self:DrawModel()
		
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
	cam.End3D()
	
	if( self.Selected ) then
		
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
		surface.DrawOutlinedRect( 0, 0, w, h );
		
	end
	
	if( self.ShowAmmo ) then
		
		surface.SetTextColor( Color( 255, 255, 255, 255 ) );
		surface.SetFont( "Infected.TinyTitle" );
		surface.SetTextPos( 4, 4 );
		surface.DrawText( self.Item.Vars.Ammo );
		
	end
	
	self.LastPaint = RealTime()
	
end

function PANEL:DrawModel() -- base DModelPanel
	local curparent = self
	local rightx = self:GetWide()
	local leftx = 0
	local topy = 0
	local bottomy = self:GetTall()
	local previous = curparent
	while(curparent:GetParent() != nil) do
		curparent = curparent:GetParent()
		local x,y = previous:GetPos()
		topy = math.Max(y, topy+y)
		leftx = math.Max(x, leftx+x)
		bottomy = math.Min(y+previous:GetTall(), bottomy + y)
		rightx = math.Min(x+previous:GetWide(), rightx + x)
		previous = curparent
	end
	render.SetScissorRect(leftx,topy,rightx, bottomy, true)
	self.Entity:DrawModel()
	render.SetScissorRect(0,0,0,0, false)
end

function PANEL:LayoutEntity( Entity )
	
	
	
end

function PANEL:OnMousePressed( code )
	
	if( self:IsDraggable() ) then
		
		self:MouseCapture( true )
		self:DragMousePress( code );
		
	end
	
	GAMEMODE:HandleItemClick( self, self.Item );
	
end

function PANEL:OnMouseReleased( code )
	
	self:MouseCapture( false )
	
	if( self:DragMouseRelease( code ) ) then
		return;
	end
	
end

function PANEL:BestGuessLayout()
	
	if( self.Item ) then
		
		local metaitem = GAMEMODE:GetMetaItem( self.Item.Class );
		
		if( metaitem.CamPos and metaitem.FOV and metaitem.LookAt ) then
			
			self:SetCamPos( metaitem.CamPos );
			self:SetFOV( metaitem.FOV );
			self:SetLookAt( metaitem.LookAt );
			
			return;
			
		end
		
	end
	
	local ent = self:GetEntity()
	local pos = ent:GetPos()
	
	local tab = PositionSpawnIcon( ent, pos );
	
	if( tab ) then
		self:SetCamPos( tab.origin )
		self:SetFOV( tab.fov )
		self:SetLookAt( tab.origin + tab.angles:Forward() * 2048 );
	end
	
end

vgui.Register( "IItem", PANEL, "DModelPanel" );

PANEL = { }

AccessorFunc( PANEL, "m_strModel", 		"Model" )
AccessorFunc( PANEL, "m_pOrigin", 		"Origin" )
AccessorFunc( PANEL, "m_bCustomIcon", 	"CustomIcon" )

function PANEL:Init()

	self:SetSize( 410, 502 )
	self:SetTitle( "Icon Editor" )
	
	local pnl = self:Add( "Panel" )
	pnl:SetSize( 400, 400 )
	pnl:Dock( RIGHT )
	
		local bg = pnl:Add( "DPanel" )
		bg:Dock( TOP )
		bg:SetSize( 400, 400 )
		bg:DockMargin( 0, 0, 0, 4 )
		bg.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 128 ) ) end
	
		self.ModelPanel = bg:Add( "DAdjustableModelPanel" )
		self.ModelPanel:Dock( FILL )
		self.ModelPanel.FarZ = 32768

	local pnl2 = pnl:Add( "Panel" )
	pnl2:SetSize( 400, 64 )
	pnl2:Dock( FILL )

		local BestGuess = pnl2:Add( "DImageButton" )
		BestGuess:SetImage( "icon32/wand.png" )
		BestGuess:SetStretchToFit( false )
		BestGuess:SetDrawBackground( true )
		BestGuess.DoClick = function() self:BestGuessLayout() end
		BestGuess:Dock( LEFT )
		BestGuess:DockMargin( 0, 0, 0, 0 )
		BestGuess:SetWide( 50 )
		BestGuess:SetTooltip( "Best Guess" )

		local FullFrontal = pnl2:Add( "DImageButton" )
		FullFrontal:SetImage( "icon32/hand_point_090.png" )
		FullFrontal:SetStretchToFit( false )
		FullFrontal:SetDrawBackground( true )
		FullFrontal.DoClick = function() self:FullFrontalLayout() end
		FullFrontal:Dock( LEFT )
		FullFrontal:DockMargin( 2, 0, 0, 0 )
		FullFrontal:SetWide( 50 )
		FullFrontal:SetTooltip( "Front" )
		
		local Above = pnl2:Add( "DImageButton" )
		Above:SetImage( "icon32/hand_property.png" )
		Above:SetStretchToFit( false )
		Above:SetDrawBackground( true )
		Above.DoClick = function() self:AboveLayout() end
		Above:Dock( LEFT )
		Above:DockMargin( 2, 0, 0, 0 )
		Above:SetWide( 50 )
		Above:SetTooltip( "Above" )
		
		local Right = pnl2:Add( "DImageButton" )
		Right:SetImage( "icon32/hand_point_180.png" )
		Right:SetStretchToFit( false )
		Right:SetDrawBackground( true )
		Right.DoClick = function() self:RightLayout() end
		Right:Dock( LEFT )
		Right:DockMargin( 2, 0, 0, 0 )
		Right:SetWide( 50 )
		Right:SetTooltip( "Right" )
		
		local Origin = pnl2:Add( "DImageButton" )
		Origin:SetImage( "icon32/hand_point_090.png" )
		Origin:SetStretchToFit( false )
		Origin:SetDrawBackground( true )
		Origin.DoClick = function() self:OriginLayout() end
		Origin:Dock( LEFT )
		Origin:DockMargin( 2, 0, 0, 0 )
		Origin:SetWide( 50 )
		Origin:SetTooltip( "Center" )

		local Render = pnl2:Add( "DButton" )
		Render:SetText( "RENDER" )
		Render.DoClick = function()
			
			local campos = self.ModelPanel:GetCamPos();
			local fov = self.ModelPanel:GetFOV();
			local lookat = campos + self.ModelPanel:GetLookAng():Forward() * 200;
			
			MsgN( "ITEM.CamPos = Vector( " .. math.Round( campos.x ) .. ", " .. math.Round( campos.y ) .. ", " .. math.Round( campos.z ) .. " );" );
			MsgN( "ITEM.FOV = " .. math.Round( fov ) .. ";" );
			MsgN( "ITEM.LookAt = Vector( " .. math.Round( lookat.x ) .. ", " .. math.Round( lookat.y ) .. ", " .. math.Round( lookat.z ) .. " );" );
			
		end
		Render:Dock( RIGHT )
		Render:DockMargin( 2, 0, 0, 0 )
		Render:SetWide( 50 )
		Render:SetTooltip( "Render Icon" )
		
end

function PANEL:SetDefaultLighting()

	self.ModelPanel:SetAmbientLight( Color( 255 * 0.3, 255 * 0.3, 255 * 0.3 ) )
	
	self.ModelPanel:SetDirectionalLight( 0, Color( 255 * 0.2, 255 * 0.2, 255 * 0.2 ) )
	self.ModelPanel:SetDirectionalLight( 1, Color( 255 * 1.3, 255 * 1.3, 255 * 1.3 ) )
	self.ModelPanel:SetDirectionalLight( 2, Color( 255 * 0.2, 255 * 0.2, 255 * 0.2 ) )
	self.ModelPanel:SetDirectionalLight( 3, Color( 255 * 0.2, 255 * 0.2, 255 * 0.2 ) )
	self.ModelPanel:SetDirectionalLight( 4, Color( 255 * 2.3, 255 * 2.3, 255 * 2.3 ) )
	self.ModelPanel:SetDirectionalLight( 5, Color( 255 * 0.1, 255 * 0.1, 255 * 0.1 ) )

end

function PANEL:BestGuessLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	
	local tab = PositionSpawnIcon( ent, pos )
	
	if ( tab ) then
		self.ModelPanel:SetCamPos( tab.origin )
		self.ModelPanel:SetFOV( tab.fov )
		self.ModelPanel:SetLookAng( tab.angles )
	end

end

function PANEL:FullFrontalLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( -200, 0, 0 )
	
	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( (campos * -1):Angle() )
	
end

function PANEL:AboveLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( 0, 0, 200 )
	
	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( (campos * -1):Angle() )
	
end

function PANEL:RightLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( 0, 200, 0 )
	
	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( (campos * -1):Angle() )
	
end

function PANEL:OriginLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( 0, 0, 0 )
	
	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( Angle( 0, -180, 0 ) )
	
end

function PANEL:UpdateEntity( ent )

	
	
end

function PANEL:Refresh()

	self.ModelPanel:SetModel( self:GetModel() )
	self.ModelPanel.LayoutEntity = function() self:UpdateEntity( self.ModelPanel:GetEntity() )  end

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	
	local tab = PositionSpawnIcon( ent, pos )
	
	self:BestGuessLayout()
	self:SetDefaultLighting()

end

vgui.Register( "IIconEditor", PANEL, "DFrame" )