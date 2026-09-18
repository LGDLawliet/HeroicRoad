
creeps_spell_mucinous_body = class({})

LinkLuaModifier("modifier_creeps_spell_mucinous_body", "creeps_spell/creeps_spell_mucinous_body", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_mucinous_body:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/ice_rain/ice_rain.vpcf", context )

end


function creeps_spell_mucinous_body:IsHiddenWhenStolen() 		return false end
function creeps_spell_mucinous_body:IsRefreshable() 			return true end
function creeps_spell_mucinous_body:IsStealable() 				return true end
function creeps_spell_mucinous_body:IsNetherWardStealable()		return true end
function creeps_spell_mucinous_body:GetIntrinsicModifierName() return "modifier_creeps_spell_mucinous_body" end



modifier_creeps_spell_mucinous_body = advanced_modifier({})

function modifier_creeps_spell_mucinous_body:IsDebuff()			return false end
function modifier_creeps_spell_mucinous_body:IsHidden() 			return true end
function modifier_creeps_spell_mucinous_body:IsPurgable() 		return false end
function modifier_creeps_spell_mucinous_body:IsPurgeException() 	return false end
function modifier_creeps_spell_mucinous_body:Advanced_GetModifierIncomingDamage_Percentage()	
	if IsClient() then
		return 0
	end

	local chance = 60
	local parent = self:GetParent()
	chance = chance+(parent:GetHealthPercent()-100)

	if chance>=RandomInt(1, 100) then
		return -1000
	end

	return 0
end

function modifier_creeps_spell_mucinous_body:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
