creep_act1_treasure = class({})

LinkLuaModifier("modifier_creep_act1_treasure", "creeps_spell/creep_act1_treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_act1_treasure_active", "creeps_spell/creep_act1_treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_act1_treasure_debuff", "creeps_spell/creep_act1_treasure", LUA_MODIFIER_MOTION_NONE)
function creep_act1_treasure:GetIntrinsicModifierName()
	return "modifier_creep_act1_treasure"
end
----------------------------------------------------------
modifier_creep_act1_treasure = advanced_modifier({})

function modifier_creep_act1_treasure:IsHidden() return self:GetRemainingTime() < 0 end
function modifier_creep_act1_treasure:IsPurgable() return false end
function modifier_creep_act1_treasure:IsDebuff() return false end
function modifier_creep_act1_treasure:DestroyOnExpire() return false end

function modifier_creep_act1_treasure:OnCreated()
	self.time = self:GetAbility():GetSpecialValueFor("time")
	self.time_each = self:GetAbility():GetSpecialValueFor("time_each")
	self.gold = self:GetAbility():GetSpecialValueFor("gold")
	self.gold_min = self:GetAbility():GetSpecialValueFor("gold_min")
	self.gold_max = self:GetAbility():GetSpecialValueFor("gold_max")
	self.poison_res = self:GetAbility():GetSpecialValueFor("poison_res")
	if not IsServer() then return end
	

	self:GetParent():GameTimer(0.03,function ()
		local heroes = GetAllRealHeroes()
		local time = self.time
		
		

		local unit = self:GetParent()
		local level = 1
		local person_index = 1 + (#heroes-1)*0.8
		if _G.GAME_ROUND <= 9 then
			level = 2
		end
		if _G.GAME_ROUND > 9 and _G.GAME_ROUND <= 15 then
			level = 4
		end
		if _G.GAME_ROUND > 15 and _G.GAME_ROUND <= 25 then
			level = 8
		end
		unit:SetBaseDamageMax(70+6*_G.GAME_ROUND*level)
		unit:SetBaseDamageMin(70+6*_G.GAME_ROUND*level)
		SetCreatureHealth(unit, 500+500*_G.GAME_ROUND*level*person_index, true)
		unit:SetPhysicalArmorBaseValue(4+level*2)
		unit:SetBaseMagicalResistanceValue(10+level*2)

		self:SetDuration(time, true)
		self:StartIntervalThink(0.5)
		-- 多人模式在中间
		if #heroes >= 2 then
			-- 开场瞬移到中心
			self:GetCaster():SetOrigin(Vector(-300,-1053,64))
			self:GetCaster():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
		end

	end)
end
function modifier_creep_act1_treasure:OnIntervalThink()
	if self:GetRemainingTime() < 0 then
		if self:GetParent():IsAlive() then
			self:GetParent():Kill(nil,nil)
		end
	end
end
function modifier_creep_act1_treasure:CheckState()
	return{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_creep_act1_treasure:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_creep_act1_treasure:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	if not keys.attacker then
		return
	end
	if keys.attacker:HasModifier("modifier_hd_poison") then
		return self.poison_res
	end
	return 
end
function modifier_creep_act1_treasure:Advanced_GetModifierIncomingPoisonDamagePercentage()
	return self.poison_res
end
function modifier_creep_act1_treasure:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit ~= self:GetParent() then
		return
	end
	local heroes = GetAllRealHeroes()

	if self:GetRemainingTime() >= 0 then
		
		local random = math.random
		local extra_gold = random(self.gold_min,self.gold_max)*_G.GAME_ROUND
		local gold = self.gold + extra_gold
		for _, hero in pairs(heroes)do
			hero:ModifyGoldFiltered(gold,true,DOTA_ModifyGold_CreepKill)  --金币奖励
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,hero, gold, nil)
		end
	else
		for _, hero in pairs(heroes)do
			hero:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creep_act1_treasure_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
			self:ShadowEffect(hero)
		end
	end
end

-- 播放特效(target)
function modifier_creep_act1_treasure:ShadowEffect(target)
	local sound_cast = "Hero_Nevermore.Shadowraze.Arcana"
	local particle_caster_ground = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf" -- 特效1：毁灭阴影至宝
	self:GetCaster():EmitSoundParams(sound_cast,0, 0.3, 0 )
	local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, self:GetCaster())
	local target_point = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 3, Vector(150, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)
end
----------------------------------------------------------
modifier_creep_act1_treasure_debuff = advanced_modifier({})

function modifier_creep_act1_treasure_debuff:IsHidden() return false end
function modifier_creep_act1_treasure_debuff:IsPurgable() return false end
function modifier_creep_act1_treasure_debuff:IsDebuff() return true end
function modifier_creep_act1_treasure_debuff:RemoveOnDeath() return false end
function modifier_creep_act1_treasure_debuff:OnCreated(table)
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	self.outgoing = self:GetAbility():GetSpecialValueFor("incoming")
end	
function modifier_creep_act1_treasure_debuff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end
function modifier_creep_act1_treasure_debuff:Advanced_GetModifierIncomingDamage_Percentage()
	return self.incoming
end
function modifier_creep_act1_treasure_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return -self.outgoing
end
