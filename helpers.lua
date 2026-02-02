---@class ULootAddon
local ULoot = select(2, ...)
local print = print

ULootTooltip = CreateFrame('GameTooltip', 'ULootTooltip', UIParent, 'GameTooltipTemplate')
local tooltip = ULootTooltip
tooltip:SetOwner(UIParent, "ANCHOR_NONE")

function ULoot.CanEquipItem(link)
	if not C_Item.IsEquippableItem(link) then
		return false
	end
	tooltip:ClearLines()
	tooltip:SetHyperlink(link)
	for i=2, 5 do
		local line = _G["ULootTooltipTextRight"..i]
		if line and line:GetText() then
			local r, g, b = line:GetTextColor()
			local lr, lg, lb = _G["ULootTooltipTextLeft"..i]:GetTextColor()
			return (r > .8 and b > .8 and g > .8 and lr > .8 and lg > .8 and lb > .8) and true or false
		end
	end
end
function ULoot.IsItemUpgrade(link)
	if not ULoot.CanEquipItem(link) then
		return false
	end
	local id = string.match(link, "item:(%d+)")
	if PawnIsItemIDAnUpgrade and id and PawnIsItemIDAnUpgrade(id) then
		return true
	end
	return false
end

--@do-not-package@
-- Debug
local AC = LibStub('AceConsole-2.0', true)
if AC then print = function(...) AC:PrintLiteral(...) end end
--@end-do-not-package@
