LinkLuaModifier("modifier_chaotic_ice_knife_debuff", "chaotic_spell/class_1/chaotic_ice_knife", LUA_MODIFIER_MOTION_NONE)

chaotic_ice_knife = class({})
function chaotic_ice_knife:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_ice_knife/effect_projecile/effect.vpcf", context )

end
function chaotic_ice_knife:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function chaotic_ice_knife:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end
function chaotic_ice_knife:GetCastRange(vLocation, hTarget)
	local range = 800
	if self:GetRuneType()==2 then
		range = range * (1+self:GetSpecialValueFor("rune_2_bonus_range")*0.01)
	end
	return range
end


function chaotic_ice_knife:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local type = self:GetRuneType()

	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_ice_knife_cast")  
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/rebuild/chaotic_spell/chaotic_ice_knife/effect_projecile/effect.vpcf",
		iMoveSpeed = 3000,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {}   --额外的数据
	}
	if type==2 then
		info = 
		{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/rebuild/chaotic_spell/chaotic_ice_knife/effect_projecile/effect.vpcf",
		iMoveSpeed = 3000 * (1+self:GetSpecialValueFor("rune_2_bonus_range")*0.01),
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {}   --额外的数据
		}
	end
	ProjectileManager:CreateTrackingProjectile(info)
	
	if type==1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("rune_1_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local count = self:GetSpecialValueFor("rune_1_bouns_count")
		for index, unit in ipairs(enemies) do
		
			if unit~=target then
				info.Target = unit
				ProjectileManager:CreateTrackingProjectile(info)
				count = count - 1
				if count<=0 then
					break
				end
			end
		end
	
	end
end




function chaotic_ice_knife:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
	-- 	return true
	-- end
	local caster = self:GetCaster()
	target:EmitSound("chaotic_ice_knife_hit")
	local gain = self:GetEffectGain()

	local damageTable = {
		attacker	= caster,
		victim = target,
		damage		= (self:GetSpecialValueFor("base_damage") +  self:GetSpecialValueFor("bonus_damage_index")*caster:HDGetPrimaryStatValue())*gain,
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	}
	if self:GetRuneType()==2 then
		target:AddNewModifier(caster,self,"modifier_stunned",{duration = self:GetSpecialValueFor("rune_2_stun")})
		damageTable.damage = damageTable.damage * (1+self:GetSpecialValueFor("rune_2_bonus_damage")*0.01)
	end
	if self:GetRuneType()==3 then
		damageTable.damage = 0
	end
	ApplyDamage(damageTable)

	local duration = self:GetSpecialValueFor("duration")*caster:GetModifierStatusNegativeGainIndex(1)
	damageTable.damage = (self:GetSpecialValueFor("base_damage_aoe") +  self:GetSpecialValueFor("bonus_damage_index_aoe")*caster:HDGetPrimaryStatValue())*gain
	if self:GetRuneType()==3 then
		damageTable.damage = damageTable.damage * (1+self:GetSpecialValueFor("rune_3_radius_damage")*0.01)
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(enemies) do
		damageTable.victim = unit
		ApplyDamage(damageTable)
		if IsValid(unit) and unit:IsAlive() then
			self:ApplyModifier(unit, duration)
		end
	end

end


function chaotic_ice_knife:ApplyModifier(target, duration)
	local caster = self:GetCaster()

	local StatusResistance = target:GetHDStatusResistanceIndex()
	target:AddNewModifier(caster, self, "modifier_chaotic_ice_knife_debuff", {duration = duration*StatusResistance})

end








modifier_chaotic_ice_knife_debuff = advanced_modifier({})

function modifier_chaotic_ice_knife_debuff:IsHidden() 			return false end
function modifier_chaotic_ice_knife_debuff:IsPurgable() 			return false end
function modifier_chaotic_ice_knife_debuff:IsPurgeException() 	return false end
function modifier_chaotic_ice_knife_debuff:IsDebuff() return true end


function modifier_chaotic_ice_knife_debuff:OnCreated(keys)
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_slow") * 	self:GetAbility():GetEffectGain()

end


function modifier_chaotic_ice_knife_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_ice_knife_debuff:GetModifierMoveSpeedBonus_Constant() return   self.move_speed_reduction end
function modifier_chaotic_ice_knife_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end