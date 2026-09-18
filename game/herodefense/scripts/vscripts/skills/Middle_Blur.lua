Middle_Blur = class({})

LinkLuaModifier("modifier_Middle_Blur_activate", "skills/Middle_Blur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Blur_detected", "skills/Middle_Blur", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Middle_Blur", "skills/Middle_Blur", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_Blur_talent", "Middle_Blur", LUA_MODIFIER_MOTION_NONE)

function Middle_Blur:IsHiddenWhenStolen() 		return false end
function Middle_Blur:IsRefreshable() 			return true end
function Middle_Blur:IsStealable() 				return true end
function Middle_Blur:IsNetherWardStealable()		return true end
function Middle_Blur:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function Middle_Blur:GetIntrinsicModifierName() return "modifier_Middle_Blur" end

function Middle_Blur:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_PhantomAssassin.Blur")
	caster:Purge(false, true, false, false, false) --弱驱散
	caster:AddNewModifier(caster, self, "modifier_Middle_Blur_activate", {duration = self:GetSpecialValueFor("duration")})
	local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	-- if caster:HasTalent("special_bonus_imba_phantom_assassin_2") then
	-- 	caster:AddNewModifier(caster, self, "modifier_Middle_Blur_talent", {duration = caster:GetTalentValue("special_bonus_imba_phantom_assassin_2", "duration")})
	-- end
end

modifier_Middle_Blur_activate = class({})  --魅影无形主动效果

function modifier_Middle_Blur_activate:IsDebuff()			return false end
function modifier_Middle_Blur_activate:IsHidden() 			return false end
function modifier_Middle_Blur_activate:IsPurgable() 		return false end
function modifier_Middle_Blur_activate:IsPurgeException() 	return false end
function modifier_Middle_Blur_activate:RemoveOnDeath()  return false end
function modifier_Middle_Blur_activate:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf" end
function modifier_Middle_Blur_activate:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Blur_activate:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Middle_Blur_activate:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_heroTalent_npc_dota_hero_phantom_assassin_2") then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	
	end
end
function modifier_Middle_Blur_activate:OnDestroy()
	if IsServer() and self.nFXIndex then
		ParticleManager:DestroyParticle( self.nFXIndex,false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end
-- modifier_Middle_Blur_talent = class({})

-- function modifier_Middle_Blur_talent:IsDebuff()			return false end
-- function modifier_Middle_Blur_talent:IsHidden() 			return false end
-- function modifier_Middle_Blur_talent:IsPurgable() 			return false end
-- function modifier_Middle_Blur_talent:IsPurgeException() 	return false end
-- function modifier_Middle_Blur_talent:CheckState() return {[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end

modifier_Middle_Blur = class({})

function modifier_Middle_Blur:IsDebuff()			return false end
function modifier_Middle_Blur:IsHidden() 			return true end
function modifier_Middle_Blur:IsPurgable() 		return false end
function modifier_Middle_Blur:IsPurgeException() 	return false end
--function modifier_Middle_Blur:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf" end
function modifier_Middle_Blur:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Blur:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_Middle_Blur:GetModifierEvasion_Constant() return self:GetCaster():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("evasion") end
function modifier_Middle_Blur:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_Middle_Blur:OnIntervalThink()
	local caster = self:GetCaster()
	if not self:GetParent():IsAlive() then
		return
	end
	
	local uint_hero = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	local uint_basic = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	self.bonus_evasion = 0
	if #uint_hero > 0 and not self:GetParent():PassivesDisabled() then
		self.bonus_evasion = #uint_hero * self:GetAbility():GetSpecialValueFor("bonus_evasion_for_hero")
	end
	self.bonus_evasion = self.bonus_evasion - self:GetAbility():GetSpecialValueFor("bonus_evasion_for_hero")  --减掉自身
	if #uint_basic > 0 and not self:GetParent():PassivesDisabled() then
		self.bonus_evasion = self.bonus_evasion + #uint_basic * self:GetAbility():GetSpecialValueFor("bonus_evasion_for_basic")
	end
	if self.bonus_evasion > self:GetAbility():GetSpecialValueFor("max_bonus_evasion") then
		self.bonus_evasion = self:GetAbility():GetSpecialValueFor("max_bonus_evasion")
	end
	if self.bonus_evasion==nil then
		return
	end
	
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Blur_detected", {}):SetStackCount(self.bonus_evasion)
	self.bonus_evasion = 0


	


end

modifier_Middle_Blur_detected = class({})

function modifier_Middle_Blur_detected:IsDebuff()			return false end
function modifier_Middle_Blur_detected:IsHidden() 			return false end
function modifier_Middle_Blur_detected:IsPurgable() 		return false end
function modifier_Middle_Blur_detected:IsPurgeException() 	return false end
function modifier_Middle_Blur_detected:GetEffectName() return "particles/basic_extend/status_effect_blur.vpcf" end
function modifier_Middle_Blur_detected:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Blur_detected:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_Middle_Blur_detected:GetModifierEvasion_Constant() return self:GetCaster():PassivesDisabled() and 0 or self:GetStackCount() end

