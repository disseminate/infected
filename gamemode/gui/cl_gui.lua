local PANEL = { };

function PANEL:Paint( w, h )
	
	return true;

end

derma.DefineControl( "IClearPanel", "", PANEL, "EditablePanel" );

local PANEL = { };

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )

function PANEL:Init()
	
	self.LastPaint = 0;
	
	self:SetText( "" );
	self:SetAnimSpeed( 0.5 );
	self:SetAnimated( true );
	
	self:SetAmbientLight( Color( 50, 50, 50 ) );
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) );
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) );
	
	self:SetColor( Color( 255, 255, 255, 255 ) );
	
	self.Entity = ClientsideModel( "models/humans/group01/male_01.mdl", RENDER_GROUP_OPAQUE_ENTITY );
	self.Entity:SetNoDraw( true );
	
	self:SetCamPos( Vector( 50, 50, 50 ) );
	self:SetLookAt( Vector( 0, 0, 55 ) );
	self:SetFOV( 30 );
	
	self.HasModel = false;
	
end

function PANEL:SetModel( strModelName )
	
	self.Entity:SetModel( strModelName );
	self.Entity:SetNoDraw( true );
	
	if( string.len( strModelName ) == 0 ) then
		
		self.HasModel = false;
		
	else
		
		self.HasModel = true;
		
	end
	
end

function PANEL:GetModel()
	
	return self.Entity:GetModel();
	
end

function PANEL:SetSubMaterial( i, j )
	
	self.Entity:SetSubMaterial( i, j );
	
end

function PANEL:OnMouseWheeled( dlta )
	
	if( !self.NoMouseWheel and string.len( self:GetModel() ) > 0 ) then
		
		self:SetFOV( math.Clamp( self:GetFOV() + dlta * -2, 20, 60 ) );
		
	end
	
end

function PANEL:Paint()
	
	if( !IsValid( self.Entity ) ) then return end
	if( !self.HasModel ) then return end
	
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
	
	if( self.Dark ) then
		
		surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
	
	self.LastPaint = RealTime()
	
end

PANEL.Anims = { };
PANEL.Anims["idle"] = { "idle_subtle", "idle_all" };
PANEL.Anims["walk"] = { "walk_all", "WalkUnarmed_all", "walk_all_moderate" };

function PANEL:StartAnimation( set )
	
	if( !self.Anims[set] ) then return end
	
	local seq = -1;
	
	for _, v in pairs( self.Anims[set] ) do
		
		if( seq <= 0 ) then
			
			seq = self.Entity:LookupSequence( v );
			
		end
		
		if( seq > 0 ) then
			
			self.bAnimated = true;
			self.Entity:ResetSequence( seq );
			break;
			
		end
		
	end
	
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed );
end

function PANEL:StartScene( name )
	
	if ( IsValid( self.Scene ) ) then
		self.Scene:Remove()
	end
	
	self.Scene = ClientsideScene( name, self.Entity )
	
end

function PANEL:OnMousePressed( code )
	
	if( self.HasModel ) then
		
		self:MouseCapture( true );
		self.MouseDetect = true;
		
		local centerx, centery = self:LocalToScreen( self:GetWide() * 0.5, self:GetTall() * 0.5 )
		input.SetCursorPos( centerx, centery );
		
		self.MX = centerx;
		self.MY = centery;
		
	end
	
end

function PANEL:OnMouseReleased( code )
	
	if( self.HasModel ) then
		
		self:MouseCapture( false );
		self.MouseDetect = false;
		
	end
	
end

function PANEL:LayoutEntity( Entity )
	
	if( self.bAnimated ) then
		self:RunAnimation();
	end
	
	if( self.MouseDetect ) then
		
		local xpos = gui.MouseX();
		local ypos = gui.MouseY();
		
		local dx = xpos - self.MX;
		local dy = ypos - self.MY;
		
		input.SetCursorPos( self.MX, self.MY );
		
		Entity:SetAngles( Entity:GetAngles() + Angle( 0, dx, 0 ) );
		
	else
		
		local ang = Entity:GetAngles();
		ang = ang * 0.9;
		Entity:SetAngles( ang );
		
	end
	
	if( self.HeadFollowMouse ) then
		
		local mx = gui.MouseX() / ScrW();
		local my = gui.MouseY() / ScrH();
		
		local rxa, rxb = Entity:GetPoseParameterRange( 6 );
		local rya, ryb = Entity:GetPoseParameterRange( 7 );
		
		local px = Lerp( mx, rxa, rxb );
		local py = Lerp( my, rya, ryb );
		
		Entity:SetPoseParameter( "head_yaw", px );
		Entity:SetPoseParameter( "head_pitch", py );
		
	end
	
end

vgui.Register( "ICharPanel", PANEL, "DModelPanel" );

PANEL = { };

function PANEL:Init()
	
	self.ContentScroll = vgui.Create( "DScrollPanel", self );
	self.ContentScroll:SetPos( 10, 40 );
	self.ContentScroll:SetSize( GAMEMODE.ChatWidth - 20, GAMEMODE.ChatHeight - 80 );
	function self.ContentScroll:Paint( w, h )
		
		surface.SetDrawColor( 0, 0, 0, 70 );
		surface.DrawRect( 0, 0, w, h );
		
		surface.SetDrawColor( 0, 0, 0, 100 );
		surface.DrawOutlinedRect( 0, 0, w, h );
		
	end
	
	self.Content = vgui.Create( "EditablePanel" );
	self.Content:SetPos( 0, 0 );
	self.Content:SetSize( GAMEMODE.ChatWidth - 20, 20 );
	self.Content.Paint = function( content, pw, ph )
		
		local y = 0;
		
		for k, v in pairs( GAMEMODE.ChatLines ) do
			
			local start = v[1];
			local filter = v[2];
			local font = v[3];
			local color = v[4];
			local text = v[5];
			local ply = v[6];
			local formatted = v[7];
			
			if( table.HasValue( filter, GAMEMODE.ChatboxFilter ) ) then
				
				local expl = string.Explode( "\n", formatted );
				
				for _, v in pairs( expl ) do
					
					surface.SetFont( font );
					local _, h = surface.GetTextSize( v );
					
					local mx, my = self.ContentScroll:GetCanvas():GetPos();
					
					if( my + y > -20 ) then
						
						draw.DrawTextShadow( string.sub( v, 1, 196 ), font, 0, y, color, Color( 0, 0, 0, 255 ), 0 );
						
					end
					
					y = y + h;
					
				end
				
			end
			
		end
		
		if( ph != math.max( y, 20 ) ) then
			
			content:SetTall( math.max( y, 20 ) );
			self.ContentScroll:PerformLayout();
			
			if( self.ContentScroll.VBar ) then
				
				self.ContentScroll.VBar:SetScroll( math.huge );
				
			end
			
		end
		
	end
	
	self.ContentScroll:AddItem( self.Content );
	
end

function PANEL:Paint( w, h )
	
	local x1, y1, w1, h1 = self:GetBounds();
	
	local us = x1 / ScrW();
	local vs = y1 / ScrH();
	local ue = ( x1 + w1 ) / ScrW();
	local ve = ( y1 + h1 ) / ScrH();
	
	draw.DrawBlur( 0, 0, w, h, us, vs, ue, ve, 1 );
	
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	
	return true

end

derma.DefineControl( "IChatPanel", "", PANEL, "EditablePanel" );