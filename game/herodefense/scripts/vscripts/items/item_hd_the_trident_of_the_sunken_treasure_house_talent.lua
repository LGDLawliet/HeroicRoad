item_hd_the_trident_of_the_sunken_treasure_house_talent = class({})

LinkLuaModifier("modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent", "items/item_hd_the_trident_of_the_sunken_treasure_house_talent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea", "items/item_hd_the_trident_of_the_sunken_treasure_house_talent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi", "items/item_hd_the_trident_of_the_sunken_treasure_house_talent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega", "items/item_hd_the_trident_of_the_sunken_treasure_house_talent", LUA_MODIFIER_MOTION_NONE)

function item_hd_the_trident_of_the_sunken_treasure_house_talent:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_waveform.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/shisui/water_gush1.vpcf", context )
end
-- require('internal/timers')   --计时器功能
function item_hd_the_trident_of_the_sunken_treasure_house_talent:GetIntrinsicModifierName()
	return "modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent"
end

function item_hd_the_trident_of_the_sunken_treasure_house_talent:OnProjectileHit(target, location)
	if not target then
		return
	end
	target:EmitSoundParams("Ability.GushImpact",0,0.6,0)
	target:AddNewModifier(target, self, "modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea", {duration = self:GetSpecialValueFor("sea_duration")})
end

function item_hd_the_trident_of_the_sunken_treasure_house_talent:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function item_hd_the_trident_of_the_sunken_treasure_house_talent:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self
	local pos = self:GetCursorPosition()
	local caster_pos = caster:GetOrigin()
	--local dir = CalculateDirection(pos,caster_pos)
	local start_pos = pos + Vector(0,0,3000)
	local radius = self:GetSpecialValueFor("radius")
	local count = 8
	for i = 1, count, 1 do
		local new_pos = pos + Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
		local start_pos = new_pos + Vector(0,0,RandomInt(500, 1000))
		local particle_target = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_target, 0, new_pos)
		ParticleManager:SetParticleControl(particle_target, 1,start_pos)
		ParticleManager:ReleaseParticleIndex(particle_target)
	end
	local particle_target = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_target, 0, pos)
	ParticleManager:SetParticleControl(particle_target, 1,start_pos)
	ParticleManager:ReleaseParticleIndex(particle_target)
	caster:EmitSoundParams("Hero_Zuus.GodsWrath.Target",0,0.6,0)

	local pos_table = {}
	table.insert(pos_table,pos)

	local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_REFLECTION
		damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY
	for _, target_pos in ipairs(pos_table) do
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			target_pos , 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_CLOSEST, 
			false
		)
		if #nearby_enemy_units ~= 0 then		
			for i, unit in pairs(nearby_enemy_units) do
				self.damage = unit:GetMaxHealth() * (self:GetSpecialValueFor("hp_damage"))*0.01
				local stack = unit:FindModifierByName("modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea")
				if stack then
					self.damage = unit:GetMaxHealth() * (self:GetSpecialValueFor("hp_damage") + stack:GetStackCount()*self:GetSpecialValueFor("hp_damage_per"))*0.01
				end
				damage_table.victim 		= unit
				damage_table.damage			= math.min(caster:GetAverageTrueAttackDamage(nil)*680 , self.damage)
				ApplyDamage(damage_table)
				if stack then
					unit:RemoveModifierByName("modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea")
				end
			end
		end
	end
end

-------------------------------------------------
modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent = advanced_modifier({})

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:IsDebuff() return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:IsHidden() return true end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:IsPurgable() 		return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:IsPurgeException() 	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:RemoveOnDeath()  return false end

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.posi = self.ability:GetSpecialValueFor("posi")
	self.posi_duration = self.ability:GetSpecialValueFor("posi_duration")
	self.sea_chance = self.ability:GetSpecialValueFor("sea_chance")
	self.sea_incoming_up = self.ability:GetSpecialValueFor("sea_incoming_up")
	self.sea_duration = self.ability:GetSpecialValueFor("sea_duration")
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},	
	}
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:Advanced_GetModifierBonusStats_Strength()	return self.bonus_atb  end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:Advanced_GetModifierBonusStats_Agility()	return self.bonus_atb  end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_atb  end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed  end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:Advanced_GetModifierPreAttack_BonusDamage()	return self.bonus_attack   end

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.attacker:GetTeamNumber() == keys.target:GetTeamNumber() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then
		return
	end
	if keys.target:GetHealthPercent() >= keys.attacker:GetHealthPercent() then
		keys.attacker:AddNewModifier(keys.attacker, self.ability, "modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi", {duration = self.posi_duration})
	end
	if keys.target:GetHealthPercent() <= keys.attacker:GetHealthPercent() then
		keys.attacker:AddNewModifier(keys.attacker, self.ability, "modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega", {duration = self.posi_duration})
	end
	if self.sea_chance >= RandomInt(1, 100) then
		local info = 
		{
			Target = keys.target,
			Source = keys.attacker,
			Ability = self.ability,	
			EffectName = "particles/rebuild/items/shisui/water_gush1.vpcf",
			--EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
			iMoveSpeed = 8000,
			-- vSourceLoc = caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,  --？？
			bDodgeable = false,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			bProvidesVision = true, --提供视野
			-- ExtraData = {hit = i}   --额外的数据
		}
		ProjectileManager:CreateTrackingProjectile(info)
		keys.attacker:EmitSoundParams("Ability.GushCast" , 0, 0.3 ,0)
	end
end

-------------------------------------------------
modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea = advanced_modifier({})

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:IsHidden()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:IsDebuff()	return true end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:IsPurgable()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:OnCreated(params)
	self.ability = self:GetAbility()
	self.sea_incoming_up = self.ability:GetSpecialValueFor("sea_incoming_up")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
	end
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:OnRefresh(params)
	self.sea_incoming_up = self.ability:GetSpecialValueFor("sea_incoming_up")
	if IsServer() then
		local dieTime = self:GetDieTime()
		if self:GetStackCount()>= (100) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:OnTooltip()
    return self.sea_incoming_up*self:GetStackCount()
end

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_sea:Advanced_GetModifierIncomingDamage_Percentage()
    return self.sea_incoming_up*self:GetStackCount()
end
--------------------------
modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi = advanced_modifier({})

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi:IsHidden()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi:IsDebuff()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi:IsPurgable()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi:OnCreated(params)
	self.posi = self:GetAbility():GetSpecialValueFor("posi")
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_DurationGain,
	}
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_posi:Advanced_GetModifier_DurationGain()
	return self.posi
end
--------------------------
modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega = advanced_modifier({})

function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega:IsHidden()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega:IsDebuff()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega:IsPurgable()	return false end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega:OnCreated(params)
	self.posi = self:GetAbility():GetSpecialValueFor("posi")
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_NegativeDurationGain,
	}
end
function modifier_item_hd_the_trident_of_the_sunken_treasure_house_talent_nega:Advanced_GetModifier_NegativeDurationGain()
	return self.posi
end



--海浪
--			local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
--			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
--			local pfx_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetUpVector() * 50
--			ParticleManager:SetParticleControl(self.pfx, 0, pfx_pos)
--			ParticleManager:SetParticleControl(self.pfx, 1, (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * self.speed)
--			self:AddParticle(self.pfx, false, false, 15, false, false)
--if self.pfx then
--	ParticleManager:DestroyParticle(self.pfx, false)
--	ParticleManager:ReleaseParticleIndex(self.pfx)
--end