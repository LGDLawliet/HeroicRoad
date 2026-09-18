item_hd_holy_cross_cloak = class({})

LinkLuaModifier("modifier_item_hd_holy_cross_cloak", "items/item_hd_holy_cross_cloak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_holy_cross_cloak_active", "items/item_hd_holy_cross_cloak", LUA_MODIFIER_MOTION_NONE)

function item_hd_holy_cross_cloak:GetIntrinsicModifierName()
	return "modifier_item_hd_holy_cross_cloak"
end

function item_hd_holy_cross_cloak:OnSpellStart()
	if IsServer() then
		local ability = self
		local caster = self:GetCaster()
		local parent = self:GetCursorTarget()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  100000 ,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  
		for _, unit in pairs(units) do
			local modifier = unit:FindModifierByName("modifier_item_hd_holy_cross_cloak_active")
			if modifier then
				unit:RemoveModifierByNameAndCaster("modifier_item_hd_holy_cross_cloak_active", caster)
			end
		end
		parent:EmitSound("Hero_Omniknight.HammerOfPurity.Crit")
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_WORLDORIGIN, parent)
		ParticleManager:SetParticleControl(self.particle, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		parent:AddNewModifier(caster, ability, "modifier_item_hd_holy_cross_cloak_active", {})
	end
end

modifier_item_hd_holy_cross_cloak = advanced_modifier({})

function modifier_item_hd_holy_cross_cloak:IsDebuff() return false end
function modifier_item_hd_holy_cross_cloak:IsHidden() return true end
function modifier_item_hd_holy_cross_cloak:IsPurgable() return false end
function modifier_item_hd_holy_cross_cloak:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_spell_amp = self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
end

function modifier_item_hd_holy_cross_cloak:OnDestroy(keys)
    if IsServer() then
		local caster = self:GetCaster()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  100000 ,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)  
		for _, unit in pairs(units) do
			local modifier = unit:FindModifierByName("modifier_item_hd_holy_cross_cloak_active")
			if modifier then
				unit:RemoveModifierByNameAndCaster("modifier_item_hd_holy_cross_cloak_active", caster)
			end
		end
	end
end	 

function modifier_item_hd_holy_cross_cloak:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_holy_cross_cloak:Advanced_GetModifierHealAMP_Percentage(keys)return self.bonus_heal_amplification end
function modifier_item_hd_holy_cross_cloak:Advanced_GetModifierSpellAmplifyBonus() return self.bonus_spell_amp end

--------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_hd_holy_cross_cloak_active = advanced_modifier({})

function modifier_item_hd_holy_cross_cloak_active:IsDebuff() return false end
function modifier_item_hd_holy_cross_cloak_active:IsHidden() return false end
function modifier_item_hd_holy_cross_cloak_active:IsPurgable() return false end
function modifier_item_hd_holy_cross_cloak_active:GetTexture()return "item_holy_cross_cloak" end
function modifier_item_hd_holy_cross_cloak_active:GetEffectAttachType()return "PATTACH_ABSORIGIN_FOLLOW" end
function modifier_item_hd_holy_cross_cloak_active:GetEffectName()return "particles/rebuild/chaotic_spell/chaotic_holy_aura/effect_buff/effect_of_the_light_blinding_light_thinker_energy.vpcf" end
function modifier_item_hd_holy_cross_cloak_active:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE  + MODIFIER_ATTRIBUTE_MULTIPLE end
--function modifier_item_hd_holy_cross_cloak_active:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE  end
function modifier_item_hd_holy_cross_cloak_active:OnCreated()
	self.ability = self:GetAbility()
	self.damage_heal = self.ability:GetSpecialValueFor("damage_heal")*0.01
end
function modifier_item_hd_holy_cross_cloak_active:OnRefresh()
	self.ability = self:GetAbility()
	self.damage_heal = self.ability:GetSpecialValueFor("damage_heal")*0.01
end
function modifier_item_hd_holy_cross_cloak_active:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetAbility():GetCaster(),nil}
	}
end
function modifier_item_hd_holy_cross_cloak_active:OnTakeDamage(keys)
	if keys.attacker ~= self:GetAbility():GetCaster() then
		return
	end
	if not IsServer() then
		return
	end
	local heal = keys.damage * self.damage_heal
	local fhealing =  HealWithGain(heal,keys.attacker,self:GetParent(),self:GetAbility())
end