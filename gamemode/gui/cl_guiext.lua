function GM:CreatePopupEntry( title, default, minlen, maxlen, cb, ml )
	
	local popup = vgui.Create( "DFrame" );
	
	if( ml ) then
		
		popup:SetSize( 300, 300 );
		
	else
		
		popup:SetSize( 300, 114 );
		
	end
	
	popup:SetTitle( title );
	popup:Center();
	popup:MakePopup();
	
	popup.e = vgui.Create( "DTextEntry", popup );
	popup.e:SetPos( 10, 34 );
	popup.e:SetSize( 280, 30 );
	popup.e:SetFont( "Infected.LabelLarge" );
	popup.e:SetTextColor( Color( 0, 0, 0, 255 ) );
	popup.e:SetValue( default );
	function popup.e:OnChange()
		
		if( !maxlen ) then return end
		
		local val = self:GetValue();
		
		if( string.len( val ) > maxlen or string.len( val ) < minlen ) then
			
			popup.l:SetTextColor( Color( 255, 0, 0, 255 ) );
			
		else
			
			popup.l:SetTextColor( Color( 255, 255, 255, 255 ) );
			
		end
		
		popup.l:SetText( string.len( val ) .. "/" .. maxlen );
		
	end
	function popup.e:OnEnter()
		
		popup.ok:DoClick();
		
	end
	
	if( ml ) then
		
		popup.e:SetFont( "Infected.LabelSmall" );
		popup.e:SetSize( 280, 300 - 24 - 10 - 50 );
		popup.e:SetMultiline( true );
		popup.e:SetWrap( true );
		
	end
	
	popup.e:PerformLayout();
	
	if( maxlen ) then
		
		popup.l = vgui.Create( "DLabel", popup );
		
		if( ml ) then
			
			popup.l:SetPos( 10, 260 );
			
		else
			
			popup.l:SetPos( 10, 74 );
			
		end
		
		popup.l:SetFont( "Infected.SubTitle" );
		popup.l:SetText( string.len( default ) .. "/" .. maxlen );
		popup.l:SetSize( 210, 30 );
		popup.l:SetTextColor( Color( 255, 255, 255, 255 ) );
		popup.l:PerformLayout();
		
		if( string.len( default ) > maxlen or string.len( default ) < minlen ) then
			
			popup.l:SetTextColor( Color( 255, 0, 0, 255 ) );
			
		end
		
	end
	
	popup.ok = vgui.Create( "DButton", popup );
	
	if( ml ) then
		
		popup.ok:SetPos( 300 - 70, 260 );
		
	else
		
		popup.ok:SetPos( 300 - 70, 74 );
		
	end
	
	popup.ok:SetSize( 60, 30 );
	popup.ok:SetFont( "Infected.SubTitle" );
	popup.ok:SetText( "OK" );
	function popup.ok:DoClick()
		
		local val = popup.e:GetValue();
		
		if( ( maxlen and string.len( val ) > maxlen ) or string.len( val ) < minlen ) then return end
		
		cb( val );
		popup:Remove();
		
	end
	
end