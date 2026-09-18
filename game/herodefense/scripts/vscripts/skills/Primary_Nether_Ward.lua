
Primary_Nether_Ward = class({})

LinkLuaModifier("modifier_Primary_Nether_Ward", "skills/Primary_Nether_Ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Nether_Ward_debuff", "skills/Primary_Nether_Ward", LUA_MODIFIER_MOTION_NONE)


function Primary_Nether_Ward:IsHiddenWhenStolen() 	return false end
function Primary_Nether_Ward:IsRefreshable() 		return true end
function Primary_Nether_Ward:IsStealable() 			return true end
function Primary_Nether_Ward:IsNetherWardStealable()	return false end
function Primary_Nether_Ward:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Primary_Nether_Ward:GetCastRange()
	local caster = self:GetCaster()
	return 700 - caster:GetCastRangeBonus()

end
function Primary_Nether_Ward:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()

	local ward = CreateUnitByName("npc_nether_ward", pos, true, caster, caster, caster:GetTeamNumber())
	SetCreatureHealth(ward, self:GetSpecialValueFor("ward_health"), true)
	ward:AddNewModifier(caster, self, "modifier_Primary_Nether_Ward", {duration = self:GetSpecialValueFor("duration")})
	ward:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
	ward:AddNewModifier(caster, self, "modifier_rooted", {duration = self:GetSpecialValueFor("duration")})
	ward:SetControllableByPlayer(caster:GetPlayerID(), false)
	ward:EmitSound("Hero_Pugna.NetherWard")
	SetCreatureHealth(ward, self:GetSpecialValueFor("ward_health"), true)
end

modifier_Primary_Nether_Ward = class({})

function modifier_Primary_Nether_Ward:IsDebuff()			return false end
function modifier_Primary_Nether_Ward:IsHidden() 			return true end
function modifier_Primary_Nether_Ward:IsPurgable() 		return false end
function modifier_Primary_Nether_Ward:IsPurgeException() 	return false end
function modifier_Primary_Nether_Ward:IsAura() 			return self:GetAbility() and true or false end
function modifier_Primary_Nether_Ward:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_Nether_Ward:GetAuraDuration() return 0.5 end
function modifier_Primary_Nether_Ward:GetModifierAura() return "modifier_Primary_Nether_Ward_debuff" end
function modifier_Primary_Nether_Ward:GetAuraRadius() return  self.radius end
function modifier_Primary_Nether_Ward:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Primary_Nether_Ward:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Primary_Nether_Ward:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Primary_Nether_Ward:GetModifierPercentageCasttime() return -100 end
function modifier_Primary_Nether_Ward:GetAbsoluteNoDamageMagical() return 1 end
function modifier_Primary_Nether_Ward:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_Primary_Nether_Ward:GetAbsoluteNoDamagePure() return 1 end
function modifier_Primary_Nether_Ward:GetModifierIgnoreCastAngle() return 360 end
function modifier_Primary_Nether_Ward:GetDisableHealing() return 1 end
function modifier_Primary_Nether_Ward:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_Primary_Nether_Ward:CheckState()

	return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,  }


end
function modifier_Primary_Nether_Ward:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	} 
end

function modifier_Primary_Nether_Ward:OnAttackLanded(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not IsServer() or keys.target ~= self:GetParent() then
		return
	end
	local dmg = keys.attacker:IsTrueHero() and 4 or 1
	if dmg >= self:GetParent():GetHealth() then
		
		self:GetParent():Kill(nil, keys.attacker)
		self:SafeDestroy()
		return
	end
	-- self:GetParent():SetHealth(self:GetParent():GetHealth() - dmg)
	self:GetParent():ModifyHealth(self:GetParent():GetHealth() - dmg, self, false, 0)
end


modifier_Primary_Nether_Ward_debuff = class({})

function modifier_Primary_Nether_Ward_debuff:IsDebuff()			return true end
function modifier_Primary_Nether_Ward_debuff:IsHidden() 			return false end
function modifier_Primary_Nether_Ward_debuff:IsPurgable() 			return false end
function modifier_Primary_Nether_Ward_debuff:IsPurgeException() 	return false end
function modifier_Primary_Nether_Ward_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE} end
function modifier_Primary_Nether_Ward_debuff:GetModifierTotalPercentageManaRegen() return self.mana_regen_tooltip end
function modifier_Primary_Nether_Ward_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Primary_Nether_Ward_debuff:OnCreated(table)
	self.ability = self:GetAbility()
	if not self.ability then
		self:SafeDestroy()
		return
	end
	self.mana_regen_tooltip = - self:GetAbility():GetSpecialValueFor("mana_regen_tooltip")
	if IsServer() then

		
		self.caster = self.ability:GetCaster()
		self.damage = self.caster:GetIntellect(false) * self.ability:GetSpecialValueFor("intelligence_index") + self.ability:GetSpecialValueFor("basic_damage")
		self.manaloss =  self.ability:GetSpecialValueFor("mana_loss_intelligence_index") * self.caster:GetIntellect(false)
		self:StartIntervalThink(1)
	end
end

function modifier_Primary_Nether_Ward_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	local damageTable = {
		victim = self:GetParent(),
		attacker = self.caster,
		damage = self.damage,
		damage_type = self.ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability =self.ability, --Optional.
		}
	ApplyDamage(damageTable)
	self:GetParent():Script_ReduceMana(self.manaloss,self.ability)
end

