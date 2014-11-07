GM.Music = { };
GM.Music.Light = {
	{ "infected/music/ghosts_01.mp3", 168 },
	{ "infected/music/ghosts_02.mp3", 196 },
	{ "infected/music/ghosts_05.mp3", 171 },
	{ "infected/music/ghosts_09.mp3", 166 },
	{ "infected/music/ghosts_12.mp3", 137 },
	{ "infected/music/ghosts_13.mp3", 193 },
	{ "infected/music/ghosts_17.mp3", 133 },
	{ "infected/music/ghosts_28.mp3", 321 },
	{ "infected/music/ghosts_30.mp3", 178 },
	{ "infected/music/ghosts_34.mp3", 352 },
	{ "infected/music/ghosts_36.mp3", 139 },
}
GM.Music.Alert = {
	{ "infected/music/ghosts_03.mp3", 231 },
}

function GM:PlayRandomLight()
	
	self:PlaySong( table.Random( self.Music.Light ) );
	
end

function GM:PlayRandomAlert()
	
	self:PlaySong( table.Random( self.Music.Alert ) );
	
end

function GM:PlaySong( song, f, vol )
	
	if( type( song ) == "string" ) then
		
		for _, v in pairs( self.Music.Light ) do
			
			if( v[1] == song ) then
				
				song = v;
				break;
				
			end
			
		end
		
		for _, v in pairs( self.Music.Alert ) do
			
			if( v[1] == song ) then
				
				song = v;
				break;
				
			end
			
		end
		
	end
	
	f = f or 1;
	
	if( !self.MusicSound ) then
		
		self.MusicSound = CreateSound( LocalPlayer(), song[1] );
		
		if( vol ) then
			
			self.MusicSound:PlayEx( vol, 100 );
			
		else
			
			self.MusicSound:Play();
			
		end
		
		self.CurrentSongEnd = CurTime() + song[2];
		
	else
		
		if( self.CurrentSongEnd and CurTime() < self.CurrentSongEnd - f ) then
			
			self.NextSongTime = CurTime() + f;
			self.NextSong = song;
			self.NextVolume = vol;
			
			self.MusicSound:FadeOut( f );
			
			self.SongStopTime = CurTime() + f;
			
		elseif( self.MusicSound:IsPlaying() ) then
			
			self.NextSongTime = CurTime() + f;
			self.NextSong = song;
			self.NextVolume = vol;
			
		else
			
			self.MusicSound = CreateSound( LocalPlayer(), song[1] );
			
			if( vol ) then
				
				self.MusicSound:PlayEx( vol, 100 );
				
			else
				
				self.MusicSound:Play();
				
			end
			
			self.CurrentSongEnd = CurTime() + song[2];
			
		end
		
	end
	
end

function GM:StopSong( f )
	
	f = f or 0;
	
	if( self.MusicSound ) then
		
		if( f == 0 ) then
			
			self.MusicSound:Stop();
			self.CurrentSongEnd = nil;
			
		elseif( CurTime() < self.CurrentSongEnd - f ) then
			
			self.MusicSound:FadeOut( f );
			self.SongStopTime = CurTime() + f;
			
		end
		
	end
	
end

function GM:MusicThink()
	
	if( self.SongStopTime and CurTime() >= self.SongStopTime ) then
		
		if( self.MusicSound ) then
			
			self.MusicSound:Stop();
			self.CurrentSongEnd = nil;
			
		end
		
		self.SongStopTime = nil;
		
	end
	
	if( self.NextSongTime and self.NextSong and CurTime() >= self.NextSongTime ) then
		
		self.MusicSound = CreateSound( LocalPlayer(), self.NextSong[1] );
		
		if( self.NextVolume ) then
			
			self.MusicSound:PlayEx( self.NextVolume, 100 );
			
		else
			
			self.MusicSound:Play();
			
		end
		
		self.CurrentSongEnd = CurTime() + self.NextSong[2];
		
		self.NextSongTime = nil;
		self.NextSong = nil;
		self.NextVolume = nil;
		
	end
	
end
