heroTalent_npc_dota_hero_skywrath_mage = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skywrath_mage", "heroTalent/heroTalent_npc_dota_hero_skywrath_mage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skywrath_mage_buff", "heroTalent/heroTalent_npc_dota_hero_skywrath_mage", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_skywrath_mage:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_skywrath_mage"
end

modifier_heroTalent_npc_dota_hero_skywrath_mage = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_skywrath_mage:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage:DestroyOnExpire() return false end

function modifier_heroTalent_npc_dota_hero_skywrath_mage:OnCreated()
	self.index = self:GetAbility():GetSpecialValueFor("index")
	self.int = self:GetAbility():GetSpecialValueFor("int")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.base_int = self:GetAbility():GetSpecialValueFor("base_int")
	self.low = {}
	self.awake = 0
end
function modifier_heroTalent_npc_dota_hero_skywrath_mage:CheckState()
	if self.low == true then
		return{[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true}
	end
	return
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage:DeclareFunctions()
	return{MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,}
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_Wave_Start={},
		MODIFIER_EVENT_ON_Wave_End={},
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		}
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage:Advanced_GetModifierBonusStats_Intellect()
	return	self:GetStackCount()*(1+self.awake*self:GetAbility():GetSpecialValueFor("index")*0.01) + self.base_int*self.awake
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage:OnWaveStart()
	if not IsServer() then
		return
	end
	self:SetStackCount(self:GetStackCount() + self.int)
	self.low = true
	self.awake = 0
	self.already = false
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage:OnWaveEnd()
	if not IsServer() then
		return
	end
	self.low = true
	self.awake = 0
	self.already = false
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage:OnAbilityFullyCast( keys )
	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		
		local time = keys.ability:GetCooldown(keys.ability:GetLevel())
		if time <= 1 or self.awake==1 or self.already then
			return
		end
	 
		local caster = self:GetCaster()
		self.low = false
		self.awake = 1
		self.already = true
		local duration = self:GetAbility():GetSpecialValueFor("duration")*caster:GetLevel()
		self:SetDuration(duration, true)
		caster:GameTimer(duration,function()
			self.awake = 0
			self:SetDuration(0.1, true)
		end)


		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		caster:EmitSound("Blink_Layer.Swift")

	end
end




modifier_heroTalent_npc_dota_hero_skywrath_mage_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:GetModifierBonusStats_Intellect()	return self.bonus_int*self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:OnCreated(params)
	self.ability = self:GetAbility()
	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:OnRefresh(params)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+params.stack_time

		
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_heroTalent_npc_dota_hero_skywrath_mage_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end
