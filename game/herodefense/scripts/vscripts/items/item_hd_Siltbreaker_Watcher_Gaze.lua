item_hd_Siltbreaker_Watcher_Gaze = class({})
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_arua", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_arua_effect", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_active", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_effect", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_effect2", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_active_standby", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_debuff", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Watcher_Gaze_thinker", "items/item_hd_Siltbreaker_Watcher_Gaze", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_Siltbreaker_Watcher_Gaze:GetIntrinsicModifierName()
	return "modifier_item_hd_Siltbreaker_Watcher_Gaze"
end




function item_hd_Siltbreaker_Watcher_Gaze:OnSpellStart()

	local caster    =   self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
	-- local angle = AngleBetween(caster:GetAbsOrigin(),pos)

	local direction = GetDirection2D(pos, caster_pos)
	pos = caster:GetAbsOrigin() + direction*(-200)
	-- print(angle)
	-- print(caster:GetAbsOrigin())
	-- print(pos)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())

	ParticleManager:SetParticleControl(particle, 1, pos)
	
	Timers:CreateTimer(0.6, function()
		ParticleManager:DestroyParticle(particle,true)
		ParticleManager:ReleaseParticleIndex(particle)
	end)

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

	local enemy = FindUnitsInTrapezoid(caster:GetTeamNumber(), direction, GetGroundPosition(caster:GetAbsOrigin(), nil), 100, 300, 600, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, unit in pairs(enemy) do
		local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		local duration = math.min(8,4*StatusResistance)
		local duration = math.max(3,duration)
		unit:AddNewModifier(caster, self, "modifier_item_hd_Siltbreaker_Watcher_Gaze_active", {duration = duration})
	end

end





modifier_item_hd_Siltbreaker_Watcher_Gaze = class({})

function modifier_item_hd_Siltbreaker_Watcher_Gaze:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Watcher_Gaze:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Watcher_Gaze:IsPurgable() return false end



function modifier_item_hd_Siltbreaker_Watcher_Gaze:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


	
end


function modifier_item_hd_Siltbreaker_Watcher_Gaze:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		-- MODIFIER_PROPERTY_MANACOST_PERCENTAGE,            --技能魔法消耗
		-- MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
	}
end


function modifier_item_hd_Siltbreaker_Watcher_Gaze:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_Siltbreaker_Watcher_Gaze:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_Siltbreaker_Watcher_Gaze:GetModifierBonusStats_Agility()	return self.bonus_agi end
-- function modifier_item_hd_Siltbreaker_Watcher_Gaze:GetModifierPercentageManacost()	return -35 end
-- function modifier_item_hd_Siltbreaker_Watcher_Gaze:GetModifierPercentageManacostStacking()	return -35 end

modifier_item_hd_Siltbreaker_Watcher_Gaze_active = class({})

function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:IsHidden() return false end
function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:IsPurgable() return false end
function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:GetTexture()return "item_Siltbreaker_Watcher_Gaze" end
function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:GetStatusEffectName() return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf" end
-- function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
	}
end


function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:GetModifierIncomingPhysicalDamage_Percentage()	return 30 end

function modifier_item_hd_Siltbreaker_Watcher_Gaze_active:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	

	return state
end
