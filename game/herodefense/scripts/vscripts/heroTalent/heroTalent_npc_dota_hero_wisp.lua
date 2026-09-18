heroTalent_npc_dota_hero_wisp = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_wisp", "heroTalent/heroTalent_npc_dota_hero_wisp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_wisp_buff", "heroTalent/heroTalent_npc_dota_hero_wisp", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_wisp:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_wisp"
end

modifier_heroTalent_npc_dota_hero_wisp = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_wisp:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_wisp:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_wisp:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_wisp:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_wisp:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_wisp:OnCreated(kv)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.heal = self.ability:GetSpecialValueFor("heal")*0.01
	self.line = self.ability:GetSpecialValueFor("line")
	self.need = self.ability:GetSpecialValueFor("need")
	self.profic = self.ability:GetSpecialValueFor("profic")

	self.talentgain = self.ability:GetTalentGain(0.35)
	self.profic_t = self.profic * self.talentgain
	self.heal_t = self.heal * self.talentgain

	if IsServer() then
		self:StartIntervalThink(2)
	end
end

function modifier_heroTalent_npc_dota_hero_wisp:OnIntervalThink()
	local heroes = GetAllRealHeroes()

	self.talentgain = self.ability:GetTalentGain(0.35)
	self.profic_t = self.profic * self.talentgain

	
	local pass = true
	for _,hero in pairs(heroes) do
		if not hero:IsAlive() or hero:GetHealthPercent() < self.need then
			pass = false
			break
		end
	end	

	if pass == true then
		for _,hero in pairs(heroes) do
			if hero ~= self.parent then
				hero:RemoveModifierByName("modifier_heroTalent_npc_dota_hero_wisp_buff")
				local newbuff = hero:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_wisp_buff", {duration = 2})
				if newbuff then
					newbuff:SetStackCount(self.profic_t)
				end
			end
		end	
	end
end
function modifier_heroTalent_npc_dota_hero_wisp:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_wisp:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.35)
	self.profic_t = self.profic * self.talentgain
	self.heal_t = self.heal * self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.heal_t*100
    elseif self._tooltip == 2 then
        return self.profic_t
    end
end
function modifier_heroTalent_npc_dota_hero_wisp:OnCustomModifierFunction_Heal(keys)--治疗事件unit:治疗者 target:目标 heal:治疗量
	if IsServer() then
        local healer = keys.unit
        local target = keys.target
		local heal = keys.heal
		if heal < 1 then return end
		
		if healer ~= self.parent then return end
		if target ~= self.parent then return end
        if not target:IsAlive() then return end

		self.talentgain = self.ability:GetTalentGain(0.35)
		self.heal_t = self.heal * self.talentgain

		local hero = FinDLowestHealthPerAllyHeroInRange(self.parent, 10000)
		if hero and hero:IsAlive()then
			local healing = heal*self.heal_t
			hero:Heal(healing, self.ability)
			SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero, healing, nil)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_wisp_buff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_wisp_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_wisp_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_wisp_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_wisp_buff:OnCreated(keys)
	if IsServer() then
		local pfx_name ="particles/rebuild/spell/wisp_talent/wisp_talent.vpcf"
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster~=target then
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			
			-- 使用AddParticle来正确管理粒子生命周期，避免残留
			self:AddParticle(
				pfx,
				false,  -- bDestroyImmediately
				false,  -- bStatusEffect
				-1,     -- iPriority
				false,  -- bHeroEffect
				false   -- bOverheadEffect
			)
		end
	end
end
function modifier_heroTalent_npc_dota_hero_wisp_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN
    }
end
function modifier_heroTalent_npc_dota_hero_wisp_buff:Advanced_GetModifier_TalentEffectGain(keys)
	return self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_wisp_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_heroTalent_npc_dota_hero_wisp_buff:OnTooltip()
	return self:GetStackCount()
end