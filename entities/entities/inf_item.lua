AddCSLuaFile();

ENT.Base = "base_anim";

function ENT:Initialize()
	
	if( CLIENT ) then return end
	
	self:SetUseType( SIMPLE_USE );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	
	local phys = self:GetPhysicsObject();
	
	if( phys and phys:IsValid() ) then
		
		phys:Wake();
		
	end
	
end

function ENT:SetupDataTables()
	
	self:NetworkVar( "String", 0, "ItemClass" );
	self:NetworkVar( "String", 1, "VarString" );
	
	if( CLIENT ) then return end
	
	self:NetworkVarNotify( "ItemClass", function( self, name, old, new )
		
		local metaitem = GAMEMODE:GetMetaItem( new );
		
		self:SetModel( metaitem.Model );
		
		local phys = self:GetPhysicsObject();
		
		if( phys and phys:IsValid() ) then
			
			phys:Wake();
			
		end
		
	end );
	
end

function ENT:SetVars( tab )
	
	local varstr = "";
	
	for k, v in pairs( tab ) do
		varstr = varstr .. k .. "|" .. v .. ";";
	end
	
	self:SetVarString( varstr );
	
end

function ENT:GetVars()
	
	local tab = { };
	
	for _, v in pairs( string.Explode( ";", self:GetVarString() ) ) do
		
		if( v != "" ) then
			
			local n = string.Explode( "|", v );
			
			if( tonumber( n[2] ) ) then
				
				tab[n[1]] = tonumber( n[2] );
				
			else
				
				tab[n[1]] = n[2];
				
			end
			
		end
		
	end
	
	return tab;
	
end

function ENT:Use( ply, caller, type, val )
	
	if( CLIENT ) then return end
	
	local metaitem = GAMEMODE:GetMetaItem( self:GetItemClass() );
	
	local a, b = ply:GetNextAvailableSlot( metaitem.W, metaitem.H );
	
	if( a == -1 or b == -1 ) then
		
		ply:SendNet( "nItemTooBig" );
		return;
		
	end
	
	if( !self.Used ) then
		
		self.Used = true;
		
		self:Remove();
		ply:GiveItemVars( self:GetItemClass(), self:GetVars() );
		
	end
	
end