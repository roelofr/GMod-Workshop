if SERVER then
	print( "ADD RESOURCES" )
	Msg( "==============\r\n\r\n")
	function addDir( searchin )
		local validExtensions = { "vmt", "mdl", "mp3", "wav" }
		
		local files, dirs = {}
		
		files, dirs = file.Find( searchin .. "/*", "GAME", "namedesc" )
		for _, dir in pairs( dirs ) do
			if not string.EndsWith( dir, "." ) and not string.EndsWith( dir, "./" ) then
				print( "Directory: " .. searchin .. "/" .. dir )
				addDir( searchin .. "/" .. dir )
			end
		end
		for _, curfile in pairs( files ) do
			local fileExt = string.GetExtensionFromFilename( curfile )
			if table.HasValue( validExtensions, string.lower( fileExt ) ) then
				print( "Resource : " .. searchin .. "/" .. curfile )
				if fileExt == "lua" then
					AddCSLuaFile( searchin .. "/" .. curfile )
				else
					resource.AddFile( searchin .. "/" .. curfile )
				end
			end
		end
	end
	function addFile( name )
		local allExts = { "vmt", "mdl", "mp3", "wav" }
		for _, x in pairs( allExts ) do
			local fname = name .. "." .. x
			if file.Exists( fname, "GAME" ) then
				print( "Resource : " .. name .. "." .. x )
				resource.AddFile( name )
			end
		end
	end
	addDir( "sound/chicken" )
	addDir( "sound/teamcharlie" )
	
	addDir( "materials/models/lduke" )
	addDir( "materials/models/owosso" )
	
	addDir( "models/lduke" )
	addDir( "models/owosso" )
	
	addFile( "materials/particles/feather" )
	Msg( "==============\r\n\r\n")
	
	-- Gamemode files
	AddCSLuaFile( "net.lua" )
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "resource.lua" )
end