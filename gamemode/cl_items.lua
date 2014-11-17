local function nClearInventory( len )
	
	LocalPlayer().Inventory = { };
	
end
net.Receive( "nClearInventory", nClearInventory );

local function nGiveItem( len )
	
	LocalPlayer():CheckInventory();
	
	local tab = net.ReadTable();
	
	LocalPlayer().Inventory[tab.Key] = tab;
	
end
net.Receive( "nGiveItem", nGiveItem );

local function nRemoveItem( len )
	
	LocalPlayer():CheckInventory();
	
	local key = net.ReadFloat();
	
	LocalPlayer().Inventory[key] = nil;
	
end
net.Receive( "nGiveItem", nGiveItem );

local function nMoveItem( len )
	
	local key = net.ReadFloat();
	local x = net.ReadFloat();
	local y = net.ReadFloat();
	
	LocalPlayer().Inventory[key].X = x;
	LocalPlayer().Inventory[key].Y = y;
	
end
net.Receive( "nMoveItem", nMoveItem );