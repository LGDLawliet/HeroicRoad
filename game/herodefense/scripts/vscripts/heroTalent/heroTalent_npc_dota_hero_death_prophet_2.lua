heroTalent_npc_dota_hero_death_prophet_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_death_prophet_2", "heroTalent/heroTalent_npc_dota_hero_death_prophet_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_death_prophet_2_buff", "heroTalent/heroTalent_npc_dota_hero_death_prophet_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff", "heroTalent/heroTalent_npc_dota_hero_death_prophet_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_death_prophet_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_death_prophet_2"
end
function heroTalent_npc_dota_hero_death_prophet_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/death_prophet_2/effect_parent.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", context )
end
function heroTalent_npc_dota_hero_death_prophet_2:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

modifier_heroTalent_npc_dota_hero_death_prophet_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_death_prophet_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2:OnCreated(table)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.cost = self:GetAbility():GetSpecialValueFor("cost")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_heroTalent_npc_dota_hero_death_prophet_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_death_prophet_2:OnDeath(keys)
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
	if  not Game_State:IsInBattle() then
		return
	end
	if CalculateDistance(keys.unit,parent)>self.radius then
		return
	end
	if keys.unit:GetUnitName()=="npc_dummy_unit" then
		return
	end
	parent:EmitSound("Hero_DeathProphet.Silence.Cast")
	-- local ability = self:GetAbility()

	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/death_prophet_2/effect_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit )
	ParticleManager:SetParticleControl( nFXIndex, 0, keys.unit:GetOrigin()+Vector(0,0,64) )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1500,1,1) )
	ParticleManager:SetParticleControlEnt(nFXIndex, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	self:IncrementStackCount()
end

function modifier_heroTalent_npc_dota_hero_death_prophet_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	local ability = self:GetAbility()
	local stack = self:GetStackCount()

	if ability:GetAutoCastState() and stack>=self.cost then
		if keys.unit:HasModifier("modifier_heroTalent_npc_dota_hero_death_prophet_2_buff") then
			return
		end
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit )
		ParticleManager:SetParticleControl( nFXIndex, 0, keys.unit:GetOrigin()+Vector(0,0,64) )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(300,1,1) )
		ParticleManager:ReleaseParticleIndex(nFXIndex)

		self:SetStackCount(stack-self.cost)
		
		keys.unit:AddNewModifier( keys.unit, ability, "modifier_heroTalent_npc_dota_hero_death_prophet_2_buff", {duration=self.duration}) 
		keys.unit:AddNewModifier( keys.unit, ability, "modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff", {}) 
		keys.unit:EmitSound("Hero_DeathProphet.Silence")
	end


end



modifier_heroTalent_npc_dota_hero_death_prophet_2_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_death_prophet_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_buff:OnCreated(keys)
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	if IsServer() then
		if  _G.GAME_ENDLESS_WAVE>=1 then
			self:SetStackCount(2)
		else
			self:SetStackCount(1)
		end
	end
end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_buff:Advanced_GetModifierSpellAmplifyBonus()
	return self.spell_amp*self:GetStackCount()
end



modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff = class({})

function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:OnCreated(keys)
	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
	self.int_max = self:GetAbility():GetSpecialValueFor("int_max")
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+self.bonus_int,self.int_max))
	end
end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:OnRefresh(keys)
	self:OnCreated(keys)
end
function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_death_prophet_2_int_buff:GetModifierBonusStats_Intellect()	return self:GetStackCount() end




