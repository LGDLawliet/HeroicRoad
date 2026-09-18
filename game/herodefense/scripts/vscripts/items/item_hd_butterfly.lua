item_hd_butterfly = class({})
-- LinkLuaModifier("modifier_item_hd_butterfly_arua", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_butterfly_arua_effect", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_butterfly", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_butterfly_active", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_butterfly_effect", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_butterfly_effect2", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_butterfly_active_standby", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_butterfly_debuff", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_butterfly_thinker", "items/item_hd_butterfly", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_butterfly:GetIntrinsicModifierName()
	return "modifier_item_hd_butterfly"
end






modifier_item_hd_butterfly = advanced_modifier({})

function modifier_item_hd_butterfly:IsDebuff() return false end
function modifier_item_hd_butterfly:IsHidden() return true end
function modifier_item_hd_butterfly:IsPurgable() return false end


function modifier_item_hd_butterfly:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_butterfly:OnIntervalThink()
	if IsServer() then

	   if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(true, true, true,true)
		local caster = self:GetCaster()
		self.particle = ParticleManager:CreateParticle("particles/econ/events/winter_major_2016/cyclone_wm16_f.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		local ModifierStatusGain =  caster:GetModifierDurationGainIndex(1)
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_butterfly_active", {duration = 1*ModifierStatusGain })
	   end

	end
end

function modifier_item_hd_butterfly:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end
function modifier_item_hd_butterfly:Advanced_GetModifierBonusStats_Agility(keys)
	return self.bonus_agi
end


function modifier_item_hd_butterfly:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_EVASION_CONSTANT,                 --闪避
	}
end



function modifier_item_hd_butterfly:GetModifierBonusStats_Agility()	return self.bonus_agi end

function modifier_item_hd_butterfly:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_butterfly:GetModifierEvasion_Constant() return self.bonus_evasion end
function modifier_item_hd_butterfly:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end



modifier_item_hd_butterfly_active = advanced_modifier({})

function modifier_item_hd_butterfly_active:IsDebuff() return false end
function modifier_item_hd_butterfly_active:IsHidden() return false end
function modifier_item_hd_butterfly_active:IsPurgable() return false end
function modifier_item_hd_butterfly_active:GetTexture()return "item_butterfly" end



function modifier_item_hd_butterfly_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.parent = self:GetParent()
	--获取当前本身的全额敏捷，并翻倍
	self.bonus_agi = (self.parent:GetAgility())


end

function modifier_item_hd_butterfly_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end
function modifier_item_hd_butterfly_active:Advanced_GetModifierBonusStats_Agility(keys)
	return self.bonus_agi
end

