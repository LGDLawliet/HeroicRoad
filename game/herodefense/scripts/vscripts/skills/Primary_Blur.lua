Primary_Blur = class({})

LinkLuaModifier("modifier_Primary_Blur_activate", "skills/Primary_Blur", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Primary_Blur", "skills/Primary_Blur", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Primary_Blur_talent", "Primary_Blur", LUA_MODIFIER_MOTION_NONE)

function Primary_Blur:IsHiddenWhenStolen() 		return false end
function Primary_Blur:IsRefreshable() 			return true end
function Primary_Blur:IsStealable() 				return true end
function Primary_Blur:IsNetherWardStealable()		return true end
function Primary_Blur:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function Primary_Blur:GetIntrinsicModifierName() return "modifier_Primary_Blur" end

function Primary_Blur:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_PhantomAssassin.Blur")
	caster:Purge(false, true, false, false, false) --弱驱散
	caster:AddNewModifier(caster, self, "modifier_Primary_Blur_activate", {duration = self:GetSpecialValueFor("duration")})
	local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	-- if caster:HasTalent("special_bonus_imba_phantom_assassin_2") then
	-- 	caster:AddNewModifier(caster, self, "modifier_Primary_Blur_talent", {duration = caster:GetTalentValue("special_bonus_imba_phantom_assassin_2", "duration")})
	-- end
end

modifier_Primary_Blur_activate = class({})  --魅影无形主动效果

function modifier_Primary_Blur_activate:IsDebuff()			return false end
function modifier_Primary_Blur_activate:IsHidden() 			return false end
function modifier_Primary_Blur_activate:IsPurgable() 		return false end
function modifier_Primary_Blur_activate:IsPurgeException() 	return false end
function modifier_Primary_Blur_activate:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf" end
function modifier_Primary_Blur_activate:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_Blur_activate:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Primary_Blur_activate:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_heroTalent_npc_dota_hero_phantom_assassin_2") then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	
	end
end
function modifier_Primary_Blur_activate:OnDestroy()
	if IsServer() and self.nFXIndex then
		ParticleManager:DestroyParticle( self.nFXIndex,false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end
-- modifier_Primary_Blur_talent = class({})

-- function modifier_Primary_Blur_talent:IsDebuff()			return false end
-- function modifier_Primary_Blur_talent:IsHidden() 			return false end
-- function modifier_Primary_Blur_talent:IsPurgable() 			return false end
-- function modifier_Primary_Blur_talent:IsPurgeException() 	return false end
-- function modifier_Primary_Blur_talent:CheckState() return {[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end

modifier_Primary_Blur = class({})

function modifier_Primary_Blur:IsDebuff()			return false end
function modifier_Primary_Blur:IsHidden() 			return true end
function modifier_Primary_Blur:IsPurgable() 		return false end
function modifier_Primary_Blur:IsPurgeException() 	return false end
-- function modifier_Primary_Blur:GetEffectName() return "particles/new_effect/status/new_status_effect_soul_17.vpcf" end
function modifier_Primary_Blur:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Primary_Blur:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_Primary_Blur:GetModifierEvasion_Constant() return self:GetCaster():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("evasion") end



