heroTalent_npc_dota_hero_pudge = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pudge", "heroTalent/heroTalent_npc_dota_hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pudge_effect2", "heroTalent/heroTalent_npc_dota_hero_pudge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pudge_unlock", "heroTalent/heroTalent_npc_dota_hero_pudge", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_pudge:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_pudge:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_pudge:IsStealable() 				return true end
function heroTalent_npc_dota_hero_pudge:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_pudge:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_pudge" end
-- function heroTalent_npc_dota_hero_pudge:GetCastRange()
-- 	local caster = self:GetCaster()
-- 	return 700 - caster:GetCastRangeBonus()

-- end
function heroTalent_npc_dota_hero_pudge:Spawn()
    self.rot_unlock3 = false
end
function heroTalent_npc_dota_hero_pudge:GetUnlock()
    return self.rot_unlock3
end
modifier_heroTalent_npc_dota_hero_pudge = class({})

function modifier_heroTalent_npc_dota_hero_pudge:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_pudge:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_pudge:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_pudge:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pudge:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pudge:IsAura()
	return self:GetAbility():GetUnlock()
end

function modifier_heroTalent_npc_dota_hero_pudge:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_pudge_unlock" end
function modifier_heroTalent_npc_dota_hero_pudge:GetAuraRadius()	return -1  end
function modifier_heroTalent_npc_dota_hero_pudge:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_pudge:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_heroTalent_npc_dota_hero_pudge:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_heroTalent_npc_dota_hero_pudge:GetAuraEntityReject(hEntity)
	if hEntity == self:GetParent() then
		return true
	end
	return false
end


function modifier_heroTalent_npc_dota_hero_pudge:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
} 
end




function modifier_heroTalent_npc_dota_hero_pudge:GetModifierBonusStats_Strength()	
    if IsClient() then
        return
    end
    local max = _G.GAME_ROUND*5+20
    local bonus = math.min(self:GetStackCount()*3,max)
    return bonus
end

function modifier_heroTalent_npc_dota_hero_pudge:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.unit:IsRealHero() and keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber()  and keys.unit~=self:GetParent() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        local pos = keys.unit:GetAbsOrigin()
        
        local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit )
        ParticleManager:SetParticleControl( effect_cast, 0, keys.unit:GetAbsOrigin())
        ParticleManager:SetParticleControlEnt(effect_cast, 1, keys.unit, PATTACH_ABSORIGIN_FOLLOW, nil, keys.unit:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl( effect_cast, 2, Vector(1000,1000,1000))
        for a=3,4 do
            ParticleManager:SetParticleControl( effect_cast, a, keys.unit:GetAbsOrigin())
        end
        ParticleManager:SetParticleControl( effect_cast, 6,Vector(1000,0,0))
        local timer = 0
        Timers:CreateTimer(0.4, function()
            keys.unit:EmitSound("Hero_Pudge.Dismember.Damage.Arcana")
            timer = timer +0.4
            if timer<2 then
                return 0.4
            end
        end)
        DestroyParticleByDelay(effect_cast, 3)
        self:IncrementStackCount()
        self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_heroTalent_npc_dota_hero_pudge_effect2",
			{	duration = 300}
        )
        
       



    end
end



modifier_heroTalent_npc_dota_hero_pudge_unlock = class({})

function modifier_heroTalent_npc_dota_hero_pudge_unlock:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_pudge_unlock:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_pudge_unlock:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_pudge_unlock:IsPurgeException() return false end
-- function modifier_heroTalent_npc_dota_hero_pudge:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pudge_unlock:OnCreated(keys)
    if IsServer() then
        self.modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_pudge")
        if self.modifier then
            self:SetStackCount(self.modifier:GetStackCount())
        end
        self:StartIntervalThink(5)
    end
end
function modifier_heroTalent_npc_dota_hero_pudge_unlock:OnIntervalThink()
    if self.modifier and not self.modifier:IsNull() then
        if self.modifier then
            self:SetStackCount(self.modifier:GetStackCount())
        end
    end
end

function modifier_heroTalent_npc_dota_hero_pudge_unlock:DeclareFunctions()
    return 
    {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
} 
end




function modifier_heroTalent_npc_dota_hero_pudge_unlock:GetModifierBonusStats_Strength()	
    if IsClient() then
        return
    end
    local max = _G.GAME_ROUND*4+10
    local bonus = math.min(self:GetStackCount()*3,max)
    return bonus
end









modifier_heroTalent_npc_dota_hero_pudge_effect2 = modifier_heroTalent_npc_dota_hero_pudge_effect2 or  class({})

function modifier_heroTalent_npc_dota_hero_pudge_effect2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_pudge_effect2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_pudge_effect2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_pudge_effect2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_pudge_effect2:GetModifierBonusStats_Strength()	return math.min(self:GetStackCount()*6,200) end






function modifier_heroTalent_npc_dota_hero_pudge_effect2:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_pudge_effect2:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= (40) then
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

function modifier_heroTalent_npc_dota_hero_pudge_effect2:OnIntervalThink()
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


