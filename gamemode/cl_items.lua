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
					
					self.D.Inventory.Slots[droppable[1].ItemY][droppable[1].ItemX].Item = nil;
					receiver.Item = droppable[1];
					
					droppable[1].ItemX = receiver.ItemX;
					droppable[1].ItemY = receiver.ItemY;
					
					net.Start( "nMoveItem" );
						net.WriteFloat( droppable[1].Key );
						net.WriteFloat( receiver.ItemX );
						net.WriteFloat( receiver.ItemY );
					net.SendToServer();
					
					--LocalPlayer().Inventory[droppable[1].Key].X = receiver.ItemX;
					--LocalPlayer().Inventory[droppable[1].Key].Y = receiver.ItemY;
					
					--self:RefreshInventory();
					
				end
				
			end );
			self.D.Inventory.Slots[j][i].ItemX = i;
			self.D.Inventory.Slots[j][i].ItemY = j;
			
		end
		
	end
	
	for _, v in pairs( LocalPlayer().Inventory ) do
		
		local item = vgui.Create( "IItem", self.D.Inventory.Back );
		item:SetPos( ( v.X - 1 ) * 48, ( v.Y - 1 ) * 48 );
		item:SetSize( self:GetMetaItem( v.Class ).W * 48, self:GetMetaItem( v.Class ).H * 48 );
		item:SetModel( self:GetMetaItem( v.Class ).Model );
		item:Droppable( "Items" );
		item.ItemX = v.X;
		item.ItemY = v.Y;
		item.Key = v.Key;
		
		self.D.Inventory.Slots[v.Y][v.X].Item = item;
		
	end
	
end