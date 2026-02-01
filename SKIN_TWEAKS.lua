---@class ULootAddon
local ULoot = select(2, ...)

function ULoot:ApplySkinTweaks()
	ULoot:RegisterMasqueTweak('LiteStep', { size = 16, padding = 0 })
	ULoot:RegisterMasqueTweak('LiteStep - XLT', { size = 16, padding = 0 })
	ULoot:RegisterMasqueTweak('simpleSquare', { size = 12, row_spacing = 4 })
	ULoot:RegisterMasqueTweak('Caith', { size = 12, row_spacing = 4 })
	ULoot:RegisterMasqueTweak('Svelte Shadow', { size = 14 })
	ULoot:RegisterMasqueTweak('Square Shadow', { size = 16 })
	ULoot:RegisterMasqueTweak('Darion', { size = 10, row_spacing = 2, padding = 0 })
	ULoot:RegisterMasqueTweak('Darion Clean', { size = 10, row_spacing = 2, padding = 0 })
	-- I suggest you add your own addon which depends on ULoot and
	-- add your tweaks there, however you can do it by hand here.
	-- See the reference at the top of skins.lua
	-- ULoot:RegisterMasqueTweak('', { })
end