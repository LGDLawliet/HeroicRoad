
Middle_chaos_form = class({})

LinkLuaModifier("modifier_Middle_chaos_form_transform", "skills/Middle_chaos_form", LUA_MODIFIER_MOTION_NONE)

function Middle_chaos_form:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local duration = ability:GetSpecialValueFor("duration")	
	
	EmitSoundOn("Hero_ShadowDemon.Disruption", caster)

	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:Destroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Middle_chaos_form_transform"

	local gain = caster:GetModifierDurationGainIndex(0.3)
	caster:AddNewModifier(caster, ability, "modifier_Middle_chaos_form_transform", {duration = duration*gain})

	local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end

--------------------------------------------------------------------------
modifier_Middle_chaos_form_transform = advanced_modifier({})
function modifier_Middle_chaos_form_transform:IsHidden()	return false end
function modifier_Middle_chaos_form_transform:IsPurgable()	return false end
function modifier_Middle_chaos_form_transform:IsDebuff()	return false end
function modifier_Middle_chaos_form_transform:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_10.vpcf" end
-- function modifier_item_hd_soul_of_balnock_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_chaos_form_transform:StatusEffectPriority() return 1000 end

function modifier_Middle_chaos_form_transform:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		--MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
	return decFuncs	
end

function modifier_Middle_chaos_form_transform:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil}
    }
end

function modifier_Middle_chaos_form_transform:GetModifierModelScale() 
    return 30
end

function modifier_Middle_chaos_form_transform:GetModifierModelChange()
	return "models/items/warlock/golem/warlock_the_infernal_master_golem/warlock_the_infernal_master_golem.vmdl"
end

function modifier_Middle_chaos_form_transform:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.per_stack_bonus_spell_damage = self.ability:GetSpecialValueFor("middle_amp")
	self.max_stack = self.ability:GetSpecialValueFor("middle_amp_max")
	self.every_sec_cost = self.ability:GetSpecialValueFor("middle_cost")*0.01*self:GetParent():GetMana()
    if IsServer() then
		self:StartIntervalThink(1)
    end
end

function modifier_Middle_chaos_form_transform:OnIntervalThink()
	local caster = self:GetCaster()
	if caster:GetMana() <= 1 then
		self:SetStackCount(self:GetStackCount())
	else
		self:SetStackCount(math.min((self:GetStackCount() + self.per_stack_bonus_spell_damage),self.max_stack))
	end
	self.every_sec_cost = self.ability:GetSpecialValueFor("middle_cost")*0.01*self:GetParent():GetMana()
	self:GetParent():Script_ReduceMana(self.every_sec_cost,self:GetAbility())
end
function modifier_Middle_chaos_form_transform:Advanced_GetModifierBonusStats_Strength()	return self.bonus_str end--力
function modifier_Middle_chaos_form_transform:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end--敏
function modifier_Middle_chaos_form_transform:Advanced_GetModifierBonusStats_Agility()	return self.bonus_agi end--智
function modifier_Middle_chaos_form_transform:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification + self:GetStackCount() end




function modifier_Middle_chaos_form_transform:OnAbilityFullyCast(keys)

	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		local ability = keys.ability
		if ability==self:GetAbility() then
			return
		end
		local parent = self:GetParent()
		local manaCost = ability:GetManaCost(-1)
		self.manaCost = self.manaCost +manaCost
		local parent_mana = parent:GetMaxMana()*0.1

		if self.manaCost>=parent_mana then
			local stack = self.manaCost / parent_mana
			stack = stack-stack%1
			self.manaCost =self.manaCost -parent_mana * stack
			self:SetStackCount(math.min(self:GetStackCount()+stack,30))
		end

	
	
		
	end
end


function modifier_Middle_chaos_form_transform:Advanced_GetModifierCastRangeBonusStacking(keys)
	return (self.bonus_spell_range)
end

