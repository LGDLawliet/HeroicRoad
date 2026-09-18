heroTalent_npc_dota_hero_life_stealer_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_life_stealer_2", "heroTalent/heroTalent_npc_dota_hero_life_stealer_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_life_stealer_2_buff", "heroTalent/heroTalent_npc_dota_hero_life_stealer_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_life_stealer_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_life_stealer_2"
end
function heroTalent_npc_dota_hero_life_stealer_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", context )

end

modifier_heroTalent_npc_dota_hero_life_stealer_2 = class({})

function modifier_heroTalent_npc_dota_hero_life_stealer_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_life_stealer_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_life_stealer_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_life_stealer_2:OnDeath(keys)
    if not IsServer() then
        return
    end

	local parent = self:GetParent()
	if parent==keys.unit then
		return
	end
	if parent:PassivesDisabled() then
		return
	end
	if CalculateDistance(keys.unit,parent)>750 then
		return
	end
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, parent)
	ParticleManager:SetParticleControl(infest_particle, 0, keys.unit:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(infest_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	parent:EmitSound("Hero_LifeStealer.Infest")
	local ability = self:GetAbility()
	local index = math.floor(parent:GetStrength()*0.1)
	local gain = parent:GetModifierDurationGainIndex(1)
	parent:AddNewModifier(parent, ability, "modifier_heroTalent_npc_dota_hero_life_stealer_2_buff", {duration=20*gain,index=index}) 
	local heal = (parent:GetMaxHealth()-parent:GetHealth())*0.07
	if heal>0 then
		local healing = HealWithGain(heal,parent,parent,ability)
		if healing>=100 then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		end

	end


end



modifier_heroTalent_npc_dota_hero_life_stealer_2_buff = class({})

function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:GetModifierPreAttack_BonusDamage()	return self:GetStackCount() end



function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack = params.index })
		self:SetStackCount( params.index )
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
	
		table.insert(self.tData, {dieTime = dieTime ,stack = params.index})
		self:SetStackCount(self:GetStackCount()+ params.index )
		
	end
end

function modifier_heroTalent_npc_dota_hero_life_stealer_2_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()- self.tData[i].stack )
				table.remove(self.tData, i)
				
			end
		end
	end
end


