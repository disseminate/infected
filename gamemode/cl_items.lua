local function nClearInventory( len )
	
	LocalPlayer().Inventory = { };
	
	GAMEMODE:RefreshInventory();
	
end
net.Receive( "nClearInventory", nClearInventory );

local function nGiveItem( len )
	
	LocalPlayer():CheckInventory();
	
	local tab = net.ReadTable();
	
	LocalPlayer().Inventory[tab.Key] = tab;
	
	GAMEMODE:RefreshInventory();
	
end
net.Receive( "nGiveItem", nGiveItem );

local function nRemoveItem( len )
	
	LocalPlayer():CheckInventory();
	
	local key = net.ReadFloat();
	
	LocalPlayer().Inventory[key] = nil;
	
	GAMEMODE:RefreshInventory();
	
end
net.Receive( "nRemoveItem", nRemoveItem );

local function nMoveItem( len )
	
	LocalPlayer():CheckInventory();
	
	local key = net.ReadFloat();
	local x = net.ReadFloat();
	local y = net.ReadFloat();
	
	if( !LocalPlayer().Inventory[key] ) then return end
	
	LocalPlayer().Inventory[key].X = x;
	LocalPlayer().Inventory[key].Y = y;
	
	GAMEMODE:RefreshInventory();
	
end
net.Receive( "nMoveItem", nMoveItem );

local function nItemTooBig( len )
	
	GAMEMODE:AddChat( { CB_ALL, CB_IC }, "Infected.ChatNormal", COLOR_ERROR, "You can't fit that in your inventory." );
	
end
net.Receive( "nItemTooBig", nItemTooBig );

function GM:ShowInventory()
	
	LocalPlayer():CheckInventory();
	
	self.D.Inventory = vgui.Create( "DFrame" );
	self.D.Inventory:SetSize( 800, 34 + ( 48 * 10 ) + 10 + 150 );
	self.D.Inventory:Center();
	self.D.Inventory:SetTitle( "Inventory" );
	self.D.Inventory:MakePopup();
	
	self.D.Inventory.Back = vgui.Create( "IInventoryBack", self.D.Inventory );
	self.D.Inventory.Back:SetPos( 10, 34 );
	self.D.Inventory.Back:SetSize( 48 * 6, 48 * 10 );
	
	self.D.Inventory.T = vgui.Create( "DLabel", self.D.Inventory );
	self.D.Inventory.T:SetPos( 10 + 48 * 6 + 10, 34 );
	self.D.Inventory.T:SetFont( "Infected.SubTitle" );
	self.D.Inventory.T:SetText( "" );
	self.D.Inventory.T:SizeToContents();
	self.D.Inventory.T:SetTextColor( Color( 255, 255, 255, 255 ) );
	
	self.D.Inventory.D = vgui.Create( "DLabel", self.D.Inventory );
	self.D.Inventory.D:SetPos( 10 + 48 * 6 + 10, 70 );
	self.D.Inventory.D:SetFont( "Infected.LabelSmall" );
	self.D.Inventory.D:SetText( "" );
	self.D.Inventory.D:SetAutoStretchVertical( true );
	self.D.Inventory.D:SetWrap( true );
	self.D.Inventory.D:SetSize( 800 - 10 - ( 10 + 48 * 6 + 10 ), 48 * 10 - 200 );
	self.D.Inventory.D:SetTextColor( Color( 255, 255, 255, 255 ) );
	self.D.Inventory.D:PerformLayout();
	
	self:RefreshInventory();
	
end

function GM:RefreshInventory()
	
	if( !self.D.Inventory ) then return end
	if( !self.D.Inventory.Back ) then return end
	
	for _, v in pairs( self.D.Inventory.Back:GetChildren() ) do
		
		v:Remove();
		
	end
	
	self.D.Inventory.Slots = { };
	
	for j = 1, 10 do
		
		self.D.Inventory.Slots[j] = { };
		
		for i = 1, 6 do
			
			self.D.Inventory.Slots[j][i] = vgui.Create( "IInventorySquare", self.D.Inventory.Back );
			self.D.Inventory.Slots[j][i]:SetPos( ( i - 1 ) * 48, ( j - 1 ) * 48 );
			self.D.Inventory.Slots[j][i]:SetSize( 48, 48 );
			self.D.Inventory.Slots[j][i]:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
				
				if( bDoDrop and !receiver.Item ) then
					
					local pw, ph = droppable[1]:GetSize();
					
					pw = pw / 48;
					ph = ph / 48;
					
					pw = math.floor( pw / 2 );
					ph = math.floor( ph / 2 );
					
					local i = receiver.ItemX - pw;
					local j = receiver.ItemY - ph;
					
					if( i >= 1 and j >= 1 and self.D.Inventory.Slots[j][i] ) then
						receiver = self.D.Inventory.Slots[j][i];
					end
					
					self.D.Inventory.Slots[droppable[1].Item.Y][droppable[1].Item.X].Item = nil;
					receiver.Item = droppable[1];
					
					droppable[1].Item.X = receiver.ItemX;
					droppable[1].Item.Y = receiver.ItemY;
					
					net.Start( "nMoveItem" );
						net.WriteFloat( droppable[1].Item.Key );
						net.WriteFloat( receiver.ItemX );
						net.WriteFloat( receiver.ItemY );
					net.SendToServer();
					
					self:DeselectInventory();
					
					if( LocalPlayer():IsInventorySlotOccupiedItemFilter( x, y, GAMEMODE:GetMetaItem( LocalPlayer().Inventory[droppable[1].Item.Key].Class ).W, GAMEMODE:GetMetaItem( LocalPlayer().Inventory[droppable[1].Item.Key].Class ).H, droppable[1].Item.Key ) ) then return end
					
					LocalPlayer().Inventory[key].X = x;
					LocalPlayer().Inventory[key].Y = y;
					
					droppable[1]:SetPos( ( droppable[1].Item.X - 1 ) * 48, ( droppable[1].Item.Y - 1 ) * 48 );
					
				end
				
			end );
			self.D.Inventory.Slots[j][i].ItemX = i;
			self.D.Inventory.Slots[j][i].ItemY = j;
			
		end
		
	end
	
	if( self.D.Inventory.Primary ) then
		
		self.D.Inventory.Primary:Remove();
		
	end
	
	self.D.Inventory.Primary = vgui.Create( "IInventorySquare", self.D.Inventory );
	self.D.Inventory.Primary:SetPos( 10, 34 + ( 48 * 10 ) + 20 );
	self.D.Inventory.Primary:SetSize( 400 - 15, 130 );
	self.D.Inventory.Primary:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop and !receiver.Item ) then
			
			self:DeselectInventory();
			
		end
		
	end );
	
	if( self.D.Inventory.Secondary ) then
		
		self.D.Inventory.Secondary:Remove();
		
	end
	
	self.D.Inventory.Secondary = vgui.Create( "IInventorySquare", self.D.Inventory );
	self.D.Inventory.Secondary:SetPos( 405, 34 + ( 48 * 10 ) + 20 );
	self.D.Inventory.Secondary:SetSize( 400 - 15, 130 );
	self.D.Inventory.Secondary:Receiver( "Items", function( receiver, droppable, bDoDrop, command, x, y )
		
		if( bDoDrop and !receiver.Item ) then
			
			self:DeselectInventory();
			
		end
		
	end );
	
	for _, v in pairs( LocalPlayer().Inventory ) do
		
		local item = vgui.Create( "IItem", self.D.Inventory.Back );
		item:SetPos( ( v.X - 1 ) * 48, ( v.Y - 1 ) * 48 );
		item:SetSize( self:GetMetaItem( v.Class ).W * 48, self:GetMetaItem( v.Class ).H * 48 );
		item:SetModel( self:GetMetaItem( v.Class ).Model );
		item:Droppable( "Items" );
		
		item.Item = v;
		self.D.Inventory.Slots[v.Y][v.X].Item = item;
		
	end
	
end

function GM:DeselectInventory()
	
	for j = 1, 10 do
		
		for i = 1, 6 do
			
			if( self.D.Inventory.Slots[j][i].Item ) then
				
				self.D.Inventory.Slots[j][i].Item.Selected = false;
				
			end
			
		end
		
	end
	
	if( self.D.Inventory.T ) then
		
		self.D.Inventory.T:SetText( "" );
		
	end
	
	if( self.D.Inventory.D ) then
		
		self.D.Inventory.D:SetText( "" );
		
	end
	
	self:RefreshItemButtons();
	
end

function GM:HandleItemClick( panel, item )
	
	local metadata = self:GetMetaItem( item.Class );
	
	if( self.D.Inventory.T ) then
		
		self.D.Inventory.T:SetText( metadata.Name );
		self.D.Inventory.T:SizeToContents();
		
	end
	
	if( self.D.Inventory.D ) then
		
		self.D.Inventory.D:SetText( metadata.Desc );
		self.D.Inventory.D:PerformLayout();
		
	end
	
	for j = 1, 10 do
		
		for i = 1, 6 do
			
			if( self.D.Inventory.Slots[j][i].Item ) then
				
				self.D.Inventory.Slots[j][i].Item.Selected = false;
				
			end
			
		end
		
	end
	
	panel.Selected = true;
	self:RefreshItemButtons();
	
end

function GM:GetSelectedItem()
	
	for j = 1, 10 do
		
		for i = 1, 6 do
			
			if( self.D.Inventory.Slots[j][i].Item and self.D.Inventory.Slots[j][i].Item.Selected ) then
				
				return self.D.Inventory.Slots[j][i].Item;
				
			end
			
		end
		
	end
	
end

function GM:RefreshItemButtons()
	
	if( self.D.Inventory.Use ) then
		
		self.D.Inventory.Use:Remove();
		
	end
	
	if( self.D.Inventory.Drop ) then
		
		self.D.Inventory.Drop:Remove();
		
	end
	
	if( self.D.Inventory.Destroy ) then
		
		self.D.Inventory.Destroy:Remove();
		
	end
	
	local panel = self:GetSelectedItem();
	
	if( panel ) then
		
		local item = panel.Item;
		local metaitem = self:GetMetaItem( item.Class );
		
		if( metaitem.GetUseText and metaitem.OnUse ) then
			
			self.D.Inventory.Use = vgui.Create( "DButton", self.D.Inventory );
			self.D.Inventory.Use:SetPos( 800 - 10 - 128, 70 + 48 * 10 - 200 + 20 );
			self.D.Inventory.Use:SetSize( 128, 30 );
			self.D.Inventory.Use:SetFont( "Infected.TinyTitle" );
			self.D.Inventory.Use:SetText( metaitem:GetUseText( item ) );
			function self.D.Inventory.Use:DoClick()
				
				metaitem:OnUse( item );
				
				if( item.Vars.Uses ) then
					
					item.Vars.Uses = item.Vars.Uses - 1;
					
					if( item.Vars.Uses == 0 ) then
						
						LocalPlayer().Inventory[item.Key] = nil;
						
						GAMEMODE:RefreshInventory();
						GAMEMODE:DeselectInventory();
						
					end
					
				end
				
				net.Start( "nUseItem" );
					net.WriteFloat( item.Key );
				net.SendToServer();
				
				GAMEMODE:RefreshItemButtons();
				
			end
			
		end
		
		self.D.Inventory.Drop = vgui.Create( "DButton", self.D.Inventory );
		self.D.Inventory.Drop:SetPos( 800 - 10 - 128, 70 + 48 * 10 - 200 + 20 + 40 );
		self.D.Inventory.Drop:SetSize( 128, 30 );
		self.D.Inventory.Drop:SetFont( "Infected.TinyTitle" );
		self.D.Inventory.Drop:SetText( "Drop" );
		function self.D.Inventory.Drop:DoClick()
			
			net.Start( "nDropItem" );
				net.WriteFloat( item.Key );
			net.SendToServer();
			
			LocalPlayer().Inventory[item.Key] = nil;
			
			GAMEMODE:RefreshInventory();
			GAMEMODE:DeselectInventory();
			
		end
		
		self.D.Inventory.Destroy = vgui.Create( "DButton", self.D.Inventory );
		self.D.Inventory.Destroy:SetPos( 800 - 10 - 128, 70 + 48 * 10 - 200 + 20 + 40 + 40 );
		self.D.Inventory.Destroy:SetSize( 128, 30 );
		self.D.Inventory.Destroy:SetFont( "Infected.TinyTitle" );
		self.D.Inventory.Destroy:SetText( "Destroy" );
		function self.D.Inventory.Destroy:DoClick()
			
			net.Start( "nDestroyItem" );
				net.WriteFloat( item.Key );
			net.SendToServer();
			
			LocalPlayer().Inventory[item.Key] = nil;
			
			GAMEMODE:RefreshInventory();
			GAMEMODE:DeselectInventory();
			
		end
		
	end
	
end