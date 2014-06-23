--[[
	Disables the workshop
	This file overrides some sandbox hooks to disable the workshop
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
]]--

if not spawnmenu or not spawnmenu.GetCreationTabs then return end

if tmg_creation_tab_old == nil then
	tmg_creation_tab_old = spawnmenu.GetCreationTabs
end

local function replaceContentWithSomeNode()

	local cVar, url, HTML, panel, plsVoteUp, plsVoteUpText;

	cVar = GetConVar("workshop_disable_url");
	url = cVar:GetString()

	panel = vgui.Create("DPanel");
	panel:SetPaintBackgroundEnabled( false )
	panel:SetPaintBorderEnabled( false )
	panel:DockMargin( 0, 0, 0, 0 );
		
	HTML = vgui.Create( "DHTML", panel );
	HTML:OpenURL( url );
	HTML:Dock( FILL );
	HTML:DockMargin( 0, 0, 0, 0 );
	
	if steamworks.IsSubscribed( "256758253" ) then
		plsVoteUp = vgui.Create("DPanel", panel)
		plsVoteUp:Dock( TOP );
		plsVoteUp:DockMargin( 2, 2, 2, 2 );
		plsVoteUp:SetPaintBackgroundEnabled( false )
		plsVoteUp:SetPaintBorderEnabled( false )
		
		plsVoteUpText = vgui.Create("DLabel", plsVoteUp );
		plsVoteUpText:Dock( FILL );
		plsVoteUpText:DockMargin( 4, 4, 4, 4 );
		plsVoteUpText:SetText("If you like this addon, please give it an upvote on the Workshop, since the people who would rather see this gone are massively voting it down." );
		plsVoteUpText:SetWrap( true )
		plsVoteUpText:SetFont( "DermaDefaultBold" )
		plsVoteUpText:SetPaintBackgroundEnabled( false )
		plsVoteUpText:SetPaintBorderEnabled( false )
		plsVoteUpText:SetColor( Color( 49, 112, 143, 255 ) );
		
		plsVoteUp.Paint = function( w, h )
			local w, h = plsVoteUp:GetSize()
			draw.RoundedBox( 4, 0, 0, w, h, Color( 188, 232, 241, 255 ) );
			draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 217, 237, 247, 255 ) );
		end
	end
	
	return panel
end

/**
	Override the tabs so we can insert our own content here
*/
spawnmenu.GetCreationTabs = function()
	
	local _tabs = tmg_creation_tab_old()
	local out = {}
	
	local Hide = { "saves", "dupes" }
	for key, val in pairs( _tabs ) do
		local skip = false
		for _, hid in pairs( Hide ) do
			local _x = "." .. hid
			if string.Right( key, string.len( _x ) ) == _x then
				skip = true
			end
		end
		
		if not skip then
			out[key]=val
		else
			out[key]=val
			table.Merge( out[key], { Function = function()
				return replaceContentWithSomeNode();
			end } )
		end			
	end
	return out
end

/**
	Override the spawnmenu tabs,
	Main way to add tabs, although it fails sometimes
*/

local function overrideSpawnmenuTabs()
	spawnmenu.AddCreationTab( "#spawnmenu.category.dupes", function()
		return replaceContentWithSomeNode();		
	end, "icon16/control_repeat_blue.png", 200 )
	
	spawnmenu.AddCreationTab( "#spawnmenu.category.saves", function()
		return replaceContentWithSomeNode();
	end, "icon16/disk_multiple.png", 200 )
end

overrideSpawnmenuTabs()

timer.Simple( 0, overrideSpawnmenuTabs )
hook.Add( "PlayerSpawn", overrideSpawnmenuTabs )

print( " --[ Workshop disabler loaded ]-- " )