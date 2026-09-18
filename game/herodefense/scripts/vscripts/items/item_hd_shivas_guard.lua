item_hd_shivas_guard = class({})
LinkLuaModifier("modifier_item_hd_shivas_guard_arua", "items/item_hd_shivas_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shivas_guard_arua_effect", "items/item_hd_shivas_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shivas_guard", "items/item_hd_shivas_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shivas_guard_active", "items/item_hd_shivas_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shivas_guard_debuff", "items/item_hd_shivas_guard", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_shivas_guard:GetIntrinsicModifierName()
	return "modifier_item_hd_shivas_guard"
end


function item_hd_shivas_guard:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
	caster:AddNewModifier(caster, self, "modifier_item_hd_shivas_guard_active", {duration = (self:GetSpecialValueFor("blast_radius") / self:GetSpecialValueFor("blast_speed"))})
end





modifier_item_hd_shivas_guard_arua = class({})

function modifier_item_hd_shivas_guard_arua:IsHidden() return true end
function modifier_item_hd_shivas_guard_arua:IsAura() return true end
function modifier_item_hd_shivas_guard_arua:GetAuraDuration() return 0.5 end
function modifier_item_hd_shivas_guard_arua:RemoveOnDeath() return false end
function modifier_item_hd_shivas_guard_arua:GetModifierAura() return "modifier_item_hd_shivas_guard_arua_effect" end
function modifier_item_hd_shivas_guard_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_shivas_guard_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_shivas_guard_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_shivas_guard_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end











modifier_item_hd_shivas_guard = advanced_modifier({})

function modifier_item_hd_shivas_guard:IsDebuff() return false end
function modifier_item_hd_shivas_guard:IsHidden() return true end
function modifier_item_hd_shivas_guard:IsPurgable() return false end
function modifier_item_hd_shivas_guard:OnCreated(keys)
    self.ability = self:GetAbility()
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    if IsServer() then
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_shivas_guard_arua", {})

	end

end

function modifier_item_hd_shivas_guard:OnDestroy()
	if IsServer() then

		self.modifier:SafeDestroy()
	end
end


function modifier_item_hd_shivas_guard:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
	}
end


function modifier_item_hd_shivas_guard:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_shivas_guard:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_shivas_guard:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



modifier_item_hd_shivas_guard_arua_effect = advanced_modifier({})

function modifier_item_hd_shivas_guard_arua_effect:IsDebuff() return true end
function modifier_item_hd_shivas_guard_arua_effect:IsHidden() return false end
function modifier_item_hd_shivas_guard_arua_effect:IsPurgable() return false end
function modifier_item_hd_shivas_guard_arua_effect:GetTexture()return "item_shivas_guard" end


function modifier_item_hd_shivas_guard_arua_effect:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return -20
end

function modifier_item_hd_shivas_guard_arua_effect:GetModifierAttackSpeedBonus_Constant()
	return -20
end



-- advanced_modifier
function modifier_item_hd_shivas_guard_arua_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE
    }
end
function modifier_item_hd_shivas_guard_arua_effect:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return -20
end

function modifier_item_hd_shivas_guard_arua_effect:Advanced_GetModifier_LifeSteal_Intensity(keys)
	return -20
end


--主动效果

modifier_item_hd_shivas_guard_active = class({})

function modifier_item_hd_shivas_guard_active:IsDebuff()			return false end
function modifier_item_hd_shivas_guard_active:IsHidden() 			return true end
function modifier_item_hd_shivas_guard_active:IsPurgable() 		return false end
function modifier_item_hd_shivas_guard_active:IsPurgeException() 	return false end
function modifier_item_hd_shivas_guard_active:RemoveOnDeath() 	return false end
function modifier_item_hd_shivas_guard_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_hd_shivas_guard_active:OnCreated()

	self.ability = self:GetAbility()
	self.hitted = {}
	self.blast_speed=self.ability:GetSpecialValueFor("blast_speed")
	self.damage=500+self.ability:GetCaster():GetIntellect(false)*8
	self.slow_duration_tooltip=4
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.ability:GetSpecialValueFor("blast_radius"), self:GetDuration() * 1.33, 350))
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_item_hd_shivas_guard_active:OnIntervalThink()
	local radius_increase = (self.blast_speed / (1.0 / FrameTime())) * 100
	self:SetStackCount(self:GetStackCount() + radius_increase)
	local radius = self:GetStackCount() / 100
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, FrameTime(), false)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not self.hitted[enemy:entindex()] then
			self.hitted[enemy:entindex()] = true
			local pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(pfx, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})
			enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_item_hd_shivas_guard_debuff", {duration = self.slow_duration_tooltip})
		end
	end
end

function modifier_item_hd_shivas_guard_active:OnDestroy()
	if IsServer() then
		local radius = self:GetStackCount() / 100
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, self.slow_duration_tooltip, false)
		self.hitted = nil
	end
	self.ability = nil
	self.blast_speed=nil
	self.slow_duration_tooltip=nil
	self.damage=nil
end

modifier_item_hd_shivas_guard_debuff = class({})

function modifier_item_hd_shivas_guard_debuff:IsDebuff()			return true end
function modifier_item_hd_shivas_guard_debuff:IsHidden() 		return false end
function modifier_item_hd_shivas_guard_debuff:IsPurgable() 		return true end
function modifier_item_hd_shivas_guard_debuff:IsPurgeException() return true end
function modifier_item_hd_shivas_guard_debuff:GetTexture() return "item_shivas_guard" end
function modifier_item_hd_shivas_guard_debuff:OnDestroy() self.ability = nil end
function modifier_item_hd_shivas_guard_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_hd_shivas_guard_debuff:GetModifierMoveSpeedBonus_Constant() return -180 end
function modifier_item_hd_shivas_guard_debuff:GetModifierAttackSpeedBonus_Constant() return -30 end
function modifier_item_hd_shivas_guard_debuff:GetEffectName() return "particles/generic_gameplay/generic_slowed_cold.vpcf" end
function modifier_item_hd_shivas_guard_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


