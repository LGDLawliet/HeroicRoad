Advanced_Blur = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Blur_activate", "skills/Advanced_Blur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Blur_detected", "skills/Advanced_Blur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Blur_detected2", "skills/Advanced_Blur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Blur_Invisibility", "skills/Advanced_Blur", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Blur", "skills/Advanced_Blur", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_Blur_talent", "Advanced_Blur", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Blur_unlock1", "skills/Advanced_Blur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Blur_unlock3", "skills/Advanced_Blur", LUA_MODIFIER_MOTION_NONE)
function Advanced_Blur:CheckKV(key)
	local table = {
		evasion = 1,




	}
	if self:GetUnlock(1)==1 or self:GetUnlock(3)==3  then
		table.evasion = -1.8
	end
	local value = table[key] or -1
	return value

end


function Advanced_Blur:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Blur_unlock1",{})
	return true
end
function Advanced_Blur:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Blur:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Blur_unlock3",{})
	return true

end



function Advanced_Blur:IsHiddenWhenStolen() 		return false end
function Advanced_Blur:IsRefreshable() 			return true end
function Advanced_Blur:IsStealable() 				return true end
function Advanced_Blur:IsNetherWardStealable()		return true end
function Advanced_Blur:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function Advanced_Blur:GetIntrinsicModifierName() return "modifier_Advanced_Blur" end
function Advanced_Blur:GetAOERadius()
	
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local radius = self:GetSpecialValueFor( "radius" )
	if advanced_level>=5 then
		radius = 1200
	end
	return radius
end

function Advanced_Blur:GetCooldown(iLevel)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	--LV15解锁魅影无形
	if advanced_level>=15 then
		return 10
	end
	return 15
end



function Advanced_Blur:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_PhantomAssassin.Blur")
	caster:Purge(false, true, false, false, false) --弱驱散
	local duration = self:GetSpecialValueFor("duration")
	--LV15解锁魅影无形
	if self.advanced_level>=15 then
		duration =2
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_Blur_activate", {duration = duration})
	local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	-- if caster:HasTalent("special_bonus_imba_phantom_assassin_2") then
	-- 	caster:AddNewModifier(caster, self, "modifier_Advanced_Blur_talent", {duration = caster:GetTalentValue("special_bonus_imba_phantom_assassin_2", "duration")})
	-- end
end

modifier_Advanced_Blur_activate = class({})  --魅影无形主动效果

function modifier_Advanced_Blur_activate:IsDebuff()			return false end
function modifier_Advanced_Blur_activate:IsHidden() 			return false end
function modifier_Advanced_Blur_activate:IsPurgable() 		return false end
function modifier_Advanced_Blur_activate:IsPurgeException() 	return false end
function modifier_Advanced_Blur_activate:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf" end
function modifier_Advanced_Blur_activate:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Blur_activate:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Advanced_Blur_activate:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_heroTalent_npc_dota_hero_phantom_assassin_2") then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/phantom_assassin/pa_fall20_immortal_shoulders/pa_fall20_blur_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	
	end
end
function modifier_Advanced_Blur_activate:OnDestroy()
	if IsServer() and self.nFXIndex then
		ParticleManager:DestroyParticle( self.nFXIndex,false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end
-- modifier_Advanced_Blur_talent = class({})

-- function modifier_Advanced_Blur_talent:IsDebuff()			return false end
-- function modifier_Advanced_Blur_talent:IsHidden() 			return false end
-- function modifier_Advanced_Blur_talent:IsPurgable() 			return false end
-- function modifier_Advanced_Blur_talent:IsPurgeException() 	return false end
-- function modifier_Advanced_Blur_talent:CheckState() return {[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end

modifier_Advanced_Blur = class({})

function modifier_Advanced_Blur:IsDebuff()			return false end
function modifier_Advanced_Blur:IsHidden() 			return true end
function modifier_Advanced_Blur:IsPurgable() 		return false end
function modifier_Advanced_Blur:IsPurgeException() 	return false end
--function modifier_Advanced_Blur:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf" end
function modifier_Advanced_Blur:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Blur:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_Advanced_Blur:GetModifierEvasion_Constant() return self:GetCaster():PassivesDisabled() and 0 or self.evasion end
function modifier_Advanced_Blur:OnCreated()
	local advanced_level = 1
	self.evasion = self:GetAbility():GetSpecialValueFor("evasion")
	self:StartIntervalThink(1)
	-- if IsServer() then
		
	-- 	self:StartIntervalThink(1)
	-- end
end

function modifier_Advanced_Blur:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.evasion = ability:GetSpecialValueFor("evasion")
	if IsClient() then
		return
	end
	if not self:GetParent():IsAlive() then
		return
	end
	local radius1 = ability:GetSpecialValueFor("radius")
	local radius2 = ability:GetSpecialValueFor("radius")

	--LV10解锁无形+
	if advanced_level>=10 then
		radius2 = 1200
	end
	local bonus_evasion_for_hero = ability:GetSpecialValueFor("bonus_evasion_for_hero")
	local bonus_evasion_for_basic = ability:GetSpecialValueFor("bonus_evasion_for_basic")
	--LV5解锁遁影+
	if advanced_level>=5 then
		radius1 = 1200
		bonus_evasion_for_hero = bonus_evasion_for_hero *1.5
		bonus_evasion_for_basic = bonus_evasion_for_basic*1.5
	end
	local uint_hero = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius1, 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	local uint_basic = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius2, 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	self.bonus_evasion = 0
	if #uint_hero > 0 and not self:GetParent():PassivesDisabled() then
		self.bonus_evasion = (#uint_hero-1) *bonus_evasion_for_hero
	end

	if #uint_basic > 0 and not self:GetParent():PassivesDisabled() then
		self.bonus_evasion = self.bonus_evasion + #uint_basic * bonus_evasion_for_basic
	end
	if self.bonus_evasion > ability:GetSpecialValueFor("max_bonus_evasion") then
		self.bonus_evasion = ability:GetSpecialValueFor("max_bonus_evasion")
	end
	if self.bonus_evasion~=nil then
		caster:AddNewModifier(caster, ability, "modifier_Advanced_Blur_detected", {}):SetStackCount(self.bonus_evasion)
		self.bonus_evasion = 0
	end

	


	local uints = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"), 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	caster:AddNewModifier(caster, ability, "modifier_Advanced_Blur_detected2", {}):SetStackCount(#uints*3)
	


end

modifier_Advanced_Blur_detected = class({})

function modifier_Advanced_Blur_detected:IsDebuff()			return false end
function modifier_Advanced_Blur_detected:IsHidden() 			return false end
function modifier_Advanced_Blur_detected:IsPurgable() 		return false end
function modifier_Advanced_Blur_detected:IsPurgeException() 	return false end
-- function modifier_Advanced_Blur_detected:GetEffectName() return "particles/basic_extend/status_effect_blur.vpcf" end
-- function modifier_Advanced_Blur_detected:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Blur_detected:DeclareFunctions() return {MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_Advanced_Blur_detected:GetModifierEvasion_Constant() 
	local ability = self:GetAbility()
	return self:GetCaster():PassivesDisabled() or ability:GetUnlock(1)==1 or ability:GetUnlock(3)==3 and 0 or self:GetStackCount() 
end
function modifier_Advanced_Blur_detected:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(3)
		self.effect_cast = ParticleManager:CreateParticle( "particles/basic_extend/status_effect_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	
		self:AddParticle(
			self.effect_cast,
			false,
			false,
			-1,
			false,
			false
		)
	end
end
function modifier_Advanced_Blur_detected:OnIntervalThink()
	local  ability = self:GetAbility()
	local parent = self:GetParent()
	--LV20解锁潜影
	if ability.advanced_level>=20 and self:GetStackCount()>0 then
		
		parent:AddNewModifier(parent, ability, "modifier_Advanced_Blur_Invisibility", {duration =1.5})
	end
	if ability.unlock2 then
		local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		self:StartIntervalThink(1.5)
		return
	end

	if ability.unlock1 and self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast,false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self.effect_cast = nil
	end
end
modifier_Advanced_Blur_detected2 = class({})

function modifier_Advanced_Blur_detected2:IsDebuff()			return false end
function modifier_Advanced_Blur_detected2:IsHidden() 			return true end
function modifier_Advanced_Blur_detected2:IsPurgable() 		return false end
function modifier_Advanced_Blur_detected2:IsPurgeException() 	return false end
-- function modifier_Advanced_Blur_detected:GetStatusEffectName() return "particles/basic_extend/status_effect_blur.vpcf" end
-- function modifier_Advanced_Blur_detected:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Blur_detected2:DeclareFunctions() return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_Advanced_Blur_detected2:GetModifierBaseDamageOutgoing_Percentage() return self:GetCaster():PassivesDisabled() and 0 or self:GetStackCount() end




modifier_Advanced_Blur_Invisibility = class({})

function modifier_Advanced_Blur_Invisibility:IsDebuff()			return false end
function modifier_Advanced_Blur_Invisibility:IsHidden() 			return false end
function modifier_Advanced_Blur_Invisibility:IsPurgable()     	return false end
function modifier_Advanced_Blur_Invisibility:IsPurgeException() 	return false end

function modifier_Advanced_Blur_Invisibility:GetModifierInvisibilityLevel()	return 2 end


function modifier_Advanced_Blur_Invisibility:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
	}

	return state
end










modifier_Advanced_Blur_unlock1 = class({})

function modifier_Advanced_Blur_unlock1:IsDebuff()			return false end
function modifier_Advanced_Blur_unlock1:IsHidden() 			return true end
function modifier_Advanced_Blur_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Blur_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Blur_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Blur_unlock1:CheckState()
	local state = {[MODIFIER_STATE_CANNOT_MISS] = true}

	return state
end

function modifier_Advanced_Blur_unlock1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_Advanced_Blur_unlock1:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end


		local bonus_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*0.75
		

		return bonus_damage
	end
end




modifier_Advanced_Blur_unlock3 = advanced_modifier({})

function modifier_Advanced_Blur_unlock3:IsDebuff()			return false end
function modifier_Advanced_Blur_unlock3:IsHidden() 			return false end
function modifier_Advanced_Blur_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Blur_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Blur_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Blur_unlock3:OnCreated(keys)
	if IsServer() then
		self.attack_count = 0
		self:SetStackCount(30)
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Blur_unlock3:OnIntervalThink()
	self:SetStackCount(math.min(self:GetStackCount()+1,30))
end

function modifier_Advanced_Blur_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_Advanced_Blur_unlock3:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	-- local ability = self:GetAbility()
	local caster = self:GetParent()
	if caster:PassivesDisabled() then
		return
	end
	if not caster:IsApplyModifier()  then
		return
	end

	self.attack_count =  self.attack_count +1
	if self.attack_count>=4 then
		self.attack_count = self.attack_count - 4
		self:SetStackCount(math.min(self:GetStackCount()+1,30))
	end
end



function modifier_Advanced_Blur_unlock3:GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then
		return
	end
	-- if not self:GetParent():IsRealHero() then
	-- 	return false
	-- end
	-- if params.target~=self:GetParent() then return end
	if self:GetStackCount()>=1 then
		self:SpellTrigger()
		self:DecrementStackCount()
		return -100
	end

end

function modifier_Advanced_Blur_unlock3:SpellTrigger()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_PhantomAssassin.Blur")
	caster:Purge(false, true, false, false, false) --弱驱散
	local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
end


function modifier_Advanced_Blur_unlock3:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
