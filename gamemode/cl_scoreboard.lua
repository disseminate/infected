function GM:ScoreboardHide()
	
	if( self.D.Scoreboard ) then
		
		self.D.Scoreboard:Remove();
		
	end
	
	self.D.Scoreboard = nil;
	
end

function GM:ScoreboardShow()
	
	self.D.Scoreboard = vgui.Create( "DFrame" );
	self.D.Scoreboard:SetSize( 500, 600 );
	self.D.Scoreboard:SetTitle( GetHostName() );
	self.D.Scoreboard:ShowCloseButton( false );
	self.D.Scoreboard:Center();
	self.D.Scoreboard:MakePopup();
	
	self.D.Scoreboard.Scroll = vgui.Create( "DScrollPanel", self.D.Scoreboard );
	self.D.Scoreboard.Scroll:SetPos( 0, 24 );
	self.D.Scoreboard.Scroll:SetSize( 500, 600 - 24 );
	
	self.D.Scoreboard.Board = vgui.Create( "IScoreboard", self.D.Scoreboard.Scroll );
	self.D.Scoreboard.Board:SetSize( 500, 8000 );
	self.D.Scoreboard.Board:SetPos( 0, 0 );
	
end