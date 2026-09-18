
Primary_Blood_Lust = class({})

LinkLuaModifier("modifier_Primary_Blood_Lust", "skills/Primary_Blood_Lust", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Blood_Lust_c", "skills/Primary_Blood_Lust", LUA_MODIFIER_MOTION_NONE)

function Primary_Blood_Lust:IsHiddenWhenStolen() 		return false end
function Primary_Blood_Lust:IsRefreshable() 			return true end
function Primary_Blood_Lust:IsStealable() 			return true end
function Primary_Blood_Lust:IsNetherWardStealable()	return true end
-- function Primary_Blood_Lust:GetAOERadius()
-- 	local caster = self:GetCaster()
-- 	local radius = (self:GetCastRange(caster:GetAbsOrigin(), caster)*0.5 + caster:GetCastRangeBonus()* 0.1) 	
-- 	return radius		 
-- end
function Primary_Blood_Lust:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()	
	--local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if target:IsAlive() then
		local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.7)
		local duration = self:GetSpecialValueFor("buff_duration")
		duration = math.min(duration*2,duration*ModifierStatusGain)
	    target:AddNewModifier(caster, self, "modifier_Primary_Blood_Lust", {duration = duration})
	    --buff:SetStackCount(buff:GetStackCount() + 1)
	end    
    local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 3, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(pfx1)
	-- if not scepter then
	-- 	local radius = (self:GetCastRange(caster:GetAbsOrigin(), caster)*0.5 + caster:GetCastRangeBonus()* 0.1) 	
	-- 	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 	for _, hero in pairs(heroes) do
	-- 		if hero ~= target then
	-- 			caster:SetCursorCastTarget(hero)
	-- 			self:OnSpellStart(true)
	-- 			-- if not self:GetCaster():HasScepter() then --a杖对所有英雄释放
	-- 			-- 	return
	-- 			-- end	
	-- 		end
	-- 	end
	-- 	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 	for _, unit in pairs(units) do
	-- 		if unit ~= target then
	-- 			caster:SetCursorCastTarget(unit)
	-- 			self:OnSpellStart(true)
	-- 			return
	-- 		end
	-- 	end
	-- end		
	caster:EmitSound("Hero_OgreMagi.Bloodlust.Cast")
end


modifier_Primary_Blood_Lust = class({})

function modifier_Primary_Blood_Lust:IsDebuff()				return false end
function modifier_Primary_Blood_Lust:IsHidden() 			return false end
function modifier_Primary_Blood_Lust:IsPurgable() 			return true end
function modifier_Primary_Blood_Lust:IsPurgeException() 	return true end
--function modifier_Primary_Blood_Lust:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end  --允许叠加
function modifier_Primary_Blood_Lust:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,} end
function modifier_Primary_Blood_Lust:GetModifierMoveSpeedBonus_Percentage() 
	return self.bonus_move
end
function modifier_Primary_Blood_Lust:GetModifierAttackSpeedBonus_Constant() 
	return self.bonus_attack_speed
end 
function modifier_Primary_Blood_Lust:GetModifierPreAttack_BonusDamage() 
	return self.bonus_damage
end


function modifier_Primary_Blood_Lust:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf" end
function modifier_Primary_Blood_Lust:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Primary_Blood_Lust:OnCreated()
	self.bonus_move = self:GetAbility():GetSpecialValueFor("move_bonus")
	self.bonus_attack_speed = (self:GetAbility():GetSpecialValueFor("attack_speed_bonus")) 
	self.bonus_damage = (self:GetAbility():GetSpecialValueFor("attack_damage_bonus")) 
	if IsServer() then
		self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
	end
end


function modifier_Primary_Blood_Lust:OnRefresh(table)
	self.bonus_move = self:GetAbility():GetSpecialValueFor("move_bonus")
	self.bonus_attack_speed = (self:GetAbility():GetSpecialValueFor("attack_speed_bonus")) 
	self.bonus_damage = (self:GetAbility():GetSpecialValueFor("attack_damage_bonus")) 
	if IsServer() then
		self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
	end
end
