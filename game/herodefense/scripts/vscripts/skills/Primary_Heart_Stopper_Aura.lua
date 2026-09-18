LinkLuaModifier("modifier_Primary_Heart_Stopper_Aura", "skills/Primary_Heart_Stopper_Aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Heart_Stopper_Aura_damage", "skills/Primary_Heart_Stopper_Aura", LUA_MODIFIER_MOTION_NONE)

Primary_Heart_Stopper_Aura = Primary_Heart_Stopper_Aura or class({})
function Primary_Heart_Stopper_Aura:GetIntrinsicModifierName()return "modifier_Primary_Heart_Stopper_Aura" end
function Primary_Heart_Stopper_Aura:GetAbilityTextureName()return "necrolyte_heartstopper_aura" end

function Primary_Heart_Stopper_Aura:GetAOERadius()return self:GetSpecialValueFor("radius")- self:GetCaster():GetCastRangeBonus() end
---------------------------------------------------------------

modifier_Primary_Heart_Stopper_Aura = advanced_modifier({})

function modifier_Primary_Heart_Stopper_Aura:IsPurgable() 		return false end
function modifier_Primary_Heart_Stopper_Aura:IsPurgeException() 	return false end
function modifier_Primary_Heart_Stopper_Aura:RemoveOnDeath()  return false end
function modifier_Primary_Heart_Stopper_Aura:GetAuraEntityReject(target)
	return false
end

function modifier_Primary_Heart_Stopper_Aura:GetAuraRadius()return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_Primary_Heart_Stopper_Aura:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Primary_Heart_Stopper_Aura:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Primary_Heart_Stopper_Aura:GetAuraSearchType()return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Primary_Heart_Stopper_Aura:GetModifierAura()return "modifier_Primary_Heart_Stopper_Aura_damage" end

function modifier_Primary_Heart_Stopper_Aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end

function modifier_Primary_Heart_Stopper_Aura:GetAttributes()return MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_Primary_Heart_Stopper_Aura:IsHidden()return true end
function modifier_Primary_Heart_Stopper_Aura:GetEffectName()return "particles/auras/aura_heartstopper.vpcf" end
function modifier_Primary_Heart_Stopper_Aura:GetEffectAttachType()return PATTACH_POINT_FOLLOW end

----------------------------
modifier_Primary_Heart_Stopper_Aura_damage = advanced_modifier({})


function modifier_Primary_Heart_Stopper_Aura_damage:IsHidden() return false end
function modifier_Primary_Heart_Stopper_Aura_damage:IsDebuff()return true end
function modifier_Primary_Heart_Stopper_Aura_damage:IsPurgable()return false end
function modifier_Primary_Heart_Stopper_Aura_damage:GetAttributes()return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_Heart_Stopper_Aura_damage:OnCreated()
	if IsServer() then
		self.parent	= self:GetParent()
		self.tick_rate	= self:GetAbility():GetSpecialValueFor("tick_rate")
		self.damage_max = self:GetAbility():GetSpecialValueFor("damage_max")*self:GetCaster():HDGetPrimaryStatValue()
		if not self.timer then
			self:StartIntervalThink(self.tick_rate)
			self.timer = true
		end
	end
end

function modifier_Primary_Heart_Stopper_Aura_damage:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		if not caster:PassivesDisabled() then
			local ability = self:GetAbility()
			if not ability then
				return
			end
			self.damage_max = self:GetAbility():GetSpecialValueFor("damage_max")*self:GetCaster():HDGetPrimaryStatValue()
			local damage_table = {
				victim = self.parent,
				attacker = caster,
				ability = self:GetAbility(),
				--damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				hd_flags = HD_DAMAGE_FLAG_DOT + HD_DAMAGE_FLAG_NO_SPELL_CRIT,
			}
			damage_table.damage = math.max(math.min(self:GetAbility():GetSpecialValueFor("damage")*self.parent:GetMaxHealth()*0.01 ,self.damage_max),20)

			ApplyDamage(damage_table)
		end
	end
end


