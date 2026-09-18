chaotic_magic_emanation = class ({})

LinkLuaModifier("modifier_chaotic_magic_emanation_aura", "chaotic_spell/class_3/chaotic_magic_emanation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_magic_emanation_buff", "chaotic_spell/class_3/chaotic_magic_emanation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_magic_emanation_rune_1", "chaotic_spell/class_3/chaotic_magic_emanation", LUA_MODIFIER_MOTION_NONE)
function chaotic_magic_emanation:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_magic_emanation/effect_cast/chaotic_mana_shroud.vpcf", context )
end

function chaotic_magic_emanation:GetIntrinsicModifierName()
	return "modifier_chaotic_magic_emanation_aura"
end
function chaotic_magic_emanation:Spawn()
	self.regen = 0
end
function chaotic_magic_emanation:UpdateRegen(regen)
	self.regen = regen
end
function chaotic_magic_emanation:GetRegen()
	return self.regen
end
function chaotic_magic_emanation:GetAOERadius() return self:GetSpecialValueFor("radius") end

function chaotic_magic_emanation:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
	return DOTA_ABILITY_BEHAVIOR_AURA + DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function chaotic_magic_emanation:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function chaotic_magic_emanation:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function chaotic_magic_emanation:OnToggle()
	if not IsServer() then return end
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chaotic_magic_emanation_rune_1", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_chaotic_magic_emanation_rune_1", self:GetCaster())
	end
	
end











--------------------------------------------------------------------------------------
modifier_chaotic_magic_emanation_aura = advanced_modifier({})

function modifier_chaotic_magic_emanation_aura:IsHidden()	return false end
function modifier_chaotic_magic_emanation_aura:IsDebuff()	return false end
function modifier_chaotic_magic_emanation_aura:IsPurgable() 		return false end
function modifier_chaotic_magic_emanation_aura:IsPurgeException() 	return false end
function modifier_chaotic_magic_emanation_aura:RemoveOnDeath()  return false end
function modifier_chaotic_magic_emanation_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chaotic_magic_emanation_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_chaotic_magic_emanation_aura:GetModifierAura()	return "modifier_chaotic_magic_emanation_buff" end
function modifier_chaotic_magic_emanation_aura:GetAuraRadius()	return self.radius  end
function modifier_chaotic_magic_emanation_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_chaotic_magic_emanation_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_chaotic_magic_emanation_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_chaotic_magic_emanation_aura:GetAuraEntityReject(hEntity)
	if hEntity:HasModifier("modifier_chaotic_magic_emanation_aura") then
		return true
	end
	return false
end

function modifier_chaotic_magic_emanation_aura:OnCreated(keys)
	local ability = self:GetAbility()
	self.int_to_manaregen = ability:GetSpecialValueFor("int_to_manaregen")*0.01
	self.self_regen_reducetion = -ability:GetSpecialValueFor("self_regen_reducetion")*0.01

	self.mana_regen = self:GetParent():GetIntellect(false) * self.int_to_manaregen
	self.magic_resistacne = -ability:GetSpecialValueFor("magic_resistance_self")
	ability:UpdateRegen(self.mana_regen)
	self:StartIntervalThink(0.3)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
	end
end
function modifier_chaotic_magic_emanation_aura:OnRefresh(keys)
	self:OnCreated(keys)
end
function modifier_chaotic_magic_emanation_aura:OnIntervalThink()
	
	self.mana_regen = self:GetParent():GetIntellect(false) * self.int_to_manaregen
	self:GetAbility():UpdateRegen(self.mana_regen)
end
function modifier_chaotic_magic_emanation_aura:AdvancedGetModifierConstantManaRegen()	
	return self.mana_regen *self.self_regen_reducetion
end


function modifier_chaotic_magic_emanation_aura:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

    }
end
function modifier_chaotic_magic_emanation_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end



function modifier_chaotic_magic_emanation_aura:GetModifierMagicalResistanceBonus(keys)
	return self.magic_resistacne
end
function modifier_chaotic_magic_emanation_aura:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantManaRegen()
	elseif self._tooltip == 2 then
		return self:GetModifierMagicalResistanceBonus()
	end
end


modifier_chaotic_magic_emanation_buff = modifier_chaotic_magic_emanation_buff or advanced_modifier({})

function modifier_chaotic_magic_emanation_buff:IsHidden()	return false end
function modifier_chaotic_magic_emanation_buff:IsDebuff()return false end
function modifier_chaotic_magic_emanation_buff:IsPurgable()	return false end
function modifier_chaotic_magic_emanation_buff:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chaotic_magic_emanation_buff:OnCreated( kv )
	local ability = self:GetAbility()
	if ability then
		self.magic_resistance_all = self:GetAbility():GetSpecialValueFor("magic_resistance_all")
		self.rune_1_require = self:GetAbility():GetSpecialValueFor("rune_1_require")
		self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
	end





end



function modifier_chaotic_magic_emanation_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end



function modifier_chaotic_magic_emanation_buff:GetModifierMagicalResistanceBonus(keys)
	return self.magic_resistance_all
end

function modifier_chaotic_magic_emanation_buff:GetEffectName()
	return "particles/rebuild/chaotic_spell/chaotic_magic_emanation/effect_cast/chaotic_mana_shroud.vpcf"
end
function modifier_chaotic_magic_emanation_buff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end
function modifier_chaotic_magic_emanation_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantManaRegen()
	elseif self._tooltip == 2 then
		return self:GetModifierMagicalResistanceBonus()
	end
end


function modifier_chaotic_magic_emanation_buff:AdvancedGetModifierConstantManaRegen()	
	local ability = self:GetAbility()
	if ability then
		return ability:GetRegen()
	end
end


function modifier_chaotic_magic_emanation_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,

    }
end


function modifier_chaotic_magic_emanation_buff:Advanced_GetModifierSpellAmplifyBonus()	
	local ability = self:GetAbility()
	if ability and ability:GetRuneType()==1 then
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_chaotic_magic_emanation_rune_1") then
			local gain = math.floor((100-caster:GetManaPercent())/self.rune_1_require)*self.rune_1_bonus
			return gain
		end
	end
	return 0
end






modifier_chaotic_magic_emanation_rune_1 = advanced_modifier({})

function modifier_chaotic_magic_emanation_rune_1:IsHidden()	return true end
function modifier_chaotic_magic_emanation_rune_1:IsDebuff()	return false end
function modifier_chaotic_magic_emanation_rune_1:IsPurgable() 		return false end
function modifier_chaotic_magic_emanation_rune_1:IsPurgeException() 	return false end
function modifier_chaotic_magic_emanation_rune_1:OnCreated(keys)
	self.rune_1_lost  = self:GetAbility():GetSpecialValueFor("rune_1_lost")*0.01
	if IsServer() then
		self:StartIntervalThink(1)
	end
end


function modifier_chaotic_magic_emanation_rune_1:OnIntervalThink(keys)
	local parent = self:GetParent()
	parent:SpendMana( parent:GetMana()*self.rune_1_lost, self:GetAbility() )
end






