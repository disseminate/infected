local PANEL = { };

function PANEL:Paint( w, h )
	
	return true;

end

derma.DefineControl( "IInventoryBack", "", PANEL, "EditablePanel" );

local PANEL = { };

function PANEL:Paint( w, h )
	
	surface.SetDrawColor( Color( 100, 100, 100, 100 ) );
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
		
		self.Entity:DrawModel()
		
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
	cam.End3D()
	
	if( self.Selected ) then
		
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) );
		surface.DrawOutlinedRect( 0, 0, w, h );
		
	end
	
	self.LastPaint = RealTime()
	
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