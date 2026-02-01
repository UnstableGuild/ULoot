---@class ULootAddon: AceAddon
local ULoot = LibStub("AceAddon-3.0"):NewAddon(select(2, ...), "ULoot")
_G.ULoot = ULoot
local L = ULoot.L
local print = print

-------------------------------------------------------------------------------
-- Settings
local defaults = {
	profile = {
		skin = "smooth",
		skin_anchors = false,
	}
}

-------------------------------------------------------------------------------
-- Module helpers

-- Return module localization with new module
local _NewModule = ULoot.NewModule
---@return ULootModule module
---@return table localization
function ULoot:NewModule(module_name, ...)
	local new = _NewModule(self, module_name, ...)
	return new, self["L_"..module_name]
end

local _GetModule = ULoot.GetModule
function ULoot:GetModule(module_name, ...)
	return module_name == "Core" and ULoot or _GetModule(self, module_name, ...)
end

-- Set up basic event handler
local function SetEventHandler(addon, frame)
	if not frame then
		frame = CreateFrame("Frame")
		addon.eframe = frame
	end
	frame:SetScript("OnEvent", function(self, event, ...)
		if addon[event] then
			addon[event](addon, ...)
		end
	end)
end

ULoot.slash_commands = {}
function ULoot:SetSlashCommand(slash, func)
	local key = "ULOOT_"..slash
	_G["SLASH_"..key.."1"] = "/"..slash
	_G.SlashCmdList[key] = func
end

function ULoot:ShowOptionPanel(module)
	if not ULootOptions then
		C_AddOns.EnableAddOn("ULoot_Options")
		local loaded, reason = C_AddOns.LoadAddOn("ULoot_Options")
		if not loaded or not ULootOptions then
			print("|cffff4422ULoot|r: Failed to load options - " .. tostring(reason))
			return
		end
	end
	ULootOptions:OpenPanel(module)
end

function ULoot:ApplyOptions(in_options)
	self.opt = self.db.profile
	-- Update skin
	ULoot:SetSkin(self.opt.skin)
	for _,v in ipairs(ULoot.skinners) do
		v:Reskin()
	end
	-- Update all modules
	for k,v in pairs(ULoot.modules) do
		if v.db then
			v.opt = v.db.profile
		end
		if v.ApplyOptions then
			v:ApplyOptions(in_options)
		end
	end
end

-- Add shortcuts for modules
---@class ULootModule: AceAddon
local ULootModule = {
	opt = {},
	InitializeModule = function(self, defaults, frame)
		local module_name = self:GetName()
		-- Set up DB namespace
		self.db = ULoot.db:RegisterNamespace(module_name, defaults)
		self.opt = self.db.profile

		function self.ShowOptions()
			ULoot:ShowOptionPanel(self)
		end
		-- Default slash command
		ULoot:SetSlashCommand(("ULoot"..module_name):lower(), self.ShowOptions)
		-- Set event handler
		self:SetEventHandler(frame)
	end,
	SetEventHandler = SetEventHandler,
	OnProfileChanged = ULoot.OnProfileChanged,
}
ULoot:SetDefaultModulePrototype(ULootModule)

-------------------------------------------------------------------------------
-- Prototype helper

function ULoot.Prototype_New(self, new)
	new = new or {}
	for k,v in pairs(self) do
		if k ~= "New" and k ~= "_New" then
			if new[k] ~= nil then
				new['_'..k] = new[k]
			end
			rawset(new, k, v)
		end
	end
	return new
end

function ULoot.NewPrototype()
	return { New = ULoot.Prototype_New, _New = ULoot.Prototype_New }
end

-------------------------------------------------------------------------------
-- Addon init

function ULoot:OnInitialize()
	-- Init DB
	self.db = LibStub("AceDB-3.0"):New("ULootADB", defaults, true)
	self.opt = self.db.profile
	self.db.RegisterCallback(self, "OnProfileChanged", "ApplyOptions")
	self.db.RegisterCallback(self, "OnProfileCopied", "ApplyOptions")
	self.db.RegisterCallback(self, "OnProfileReset", "ApplyOptions")
	-- Load skins, import Masque skins
	self:SkinsOnInitialize()
end

function ULoot:OnEnable()
	self:SetSlashCommand("uloot", function() self:ShowOptionPanel(self) end)
end

--@do-not-package@
local AC = LibStub("AceConsole-2.0", true)
if AC then print = function(...) AC:PrintLiteral(...) end end
--@end-do-not-package@
