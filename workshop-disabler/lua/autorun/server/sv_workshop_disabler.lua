--[[
	Disables the workshop
	This file simply adds the client-side file and adds some convars
	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
]]--


CreateConVar( "workshop_disable_url", "http://tmg-clan.com/in-game/workshop", { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The webpage to show instead of the workshop" )
AddCSLuaFile( "autorun/client/cl_workshop_disabler.lua" )

print( " --[ Workshop disabler loaded ]-- " )