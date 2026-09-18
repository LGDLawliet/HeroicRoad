
LinkLuaModifier("modifier_Middle_mana_shield_meditate", "skills/Middle_mana_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_mana_shield", "skills/Middle_mana_shield", LUA_MODIFIER_MOTION_NONE)

Middle_mana_shield = class({})

function Middle_mana_shield:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", context )
end
function Middle_mana_shield:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function Middle_mana_shield:GetIntrinsicModifierName()
	return "modifier_Middle_mana_shield_meditate"
end

function Middle_mana_shield:ProcsMagicStick() return false end

function Middle_mana_shield:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Middle_mana_shield:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Middle_mana_shield:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Middle_mana_shield", {})
	else
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Middle_mana_shield", self:GetCaster())
	end
end
------------------------------------------------------------------------------------------------------------------
modifier_Middle_mana_shield_meditate = advanced_modifier({})

function modifier_Middle_mana_shield_meditate:IsHidden()	return true end
function modifier_Middle_mana_shield_meditate:IsPurgable() 		return false end
function modifier_Middle_mana_shield_meditate:IsPurgeException() 	return false end
function modifier_Middle_mana_shield_meditate:RemoveOnDeath()  return false end
function modifier_Middle_mana_shield_meditate:DeclareFunctions()
	local decFuncs = {	
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,                       --魔法值
    }
    return decFuncs
end

function modifier_Middle_mana_shield_meditate:ADDeclareFunctions()
	local decFuncs = {	
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,                       --魔法值
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return decFuncs
end

function modifier_Middle_mana_shield_meditate:OnCreated(table)
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	self:SetStackCount(0)
	--if IsServer() then
		self:StartIntervalThink(0.5)
	--end
end

function modifier_Middle_mana_shield_meditate:OnIntervalThink()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")

	if self:GetParent():HasModifier("modifier_Middle_mana_shield") then
		self:SetStackCount(self.incoming)
	else
		self:SetStackCount(0)
	end
end

function modifier_Middle_mana_shield_meditate:GetModifierExtraManaPercentage()	return self.bonus_mana end
function modifier_Middle_mana_shield_meditate:Advanced_GetModifierSpellAmplifyBonus()	return self.bonus_spell_amp end
function modifier_Middle_mana_shield_meditate:Advanced_GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()
end
-------------------------------------------------------------------------------------------------------------------
modifier_Middle_mana_shield = advanced_modifier({})
function modifier_Middle_mana_shield:GetEffectName()return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf" end
function modifier_Middle_mana_shield:IsHidden() return false end
function modifier_Middle_mana_shield:IsDebuff() return false end
function modifier_Middle_mana_shield:IsPurgable() 		return false end
function modifier_Middle_mana_shield:RemoveOnDeath()	return false end

function modifier_Middle_mana_shield:OnCreated()
	self.per_mana = self:GetAbility():GetSpecialValueFor("per_mana")
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
	
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.middle_damage = self:GetAbility():GetSpecialValueFor("middle_damage")

	if not IsServer() then return end
	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
	self:StartIntervalThink(self.interval)
end

function modifier_Middle_mana_shield:OnIntervalThink()
	self.per_mana = self:GetAbility():GetSpecialValueFor("per_mana")
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
	
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.max = self:GetAbility():GetSpecialValueFor("max")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.middle_damage = self:GetAbility():GetSpecialValueFor("middle_damage")

	local parent = self:GetParent()
	local parent_pos = parent:GetAbsOrigin()
	local radius = self.radius
	local damage = parent:GetIntellect(false) * self.middle_damage

	local enemies = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent_pos,
		nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
    	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
	)
    local i = 0
    for _, enemy in pairs(enemies) do
		local damageTable = {
			attacker = parent,
            victim = enemy,
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
        ApplyDamage(damageTable)
		enemy:AddNewModifier(parent,self:GetAbility(),"modifier_stunned",{duration = self.stun_duration})

		local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_WORLDORIGIN, enemy)
        local pos = enemy:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+5000))
        ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
        ParticleManager:SetParticleControl(particle, 3, Vector(pos.x, pos.y, pos.z))
		enemy:EmitSoundParams("Hero_Zuus.LightningBolt",0,0.3,0)

		i = i + 1
		if i >= self.max then
			break
		end
    end
end

function modifier_Middle_mana_shield:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

function modifier_Middle_mana_shield:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	if self:GetParent().GetMana then
		local mana_to_block	= keys.original_damage * self.absorption_tooltip * 0.01 / self.per_mana
		if mana_to_block >= self:GetParent():GetMana() then
			self:GetParent():EmitSound("Hero_Medusa.ManaShield.Proc")
			
			local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(shield_particle)
		end			
		local block =math.min(self.absorption_tooltip, self.absorption_tooltip * self:GetParent():GetMana() / math.max(mana_to_block, 1)) * (-1)
		mana_to_block = math.min(mana_to_block,self:GetParent():GetMaxMana()*0.35)
		self:GetParent():Script_ReduceMana(mana_to_block,self:GetAbility())

		return block
	end
end


