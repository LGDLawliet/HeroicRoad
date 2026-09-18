
creeps_spell_earth_return = class({})
LinkLuaModifier("modifier_creeps_spell_earth_return", "creeps_spell/creeps_spell_earth_return", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_earth_return_shield", "creeps_spell/creeps_spell_earth_return", LUA_MODIFIER_MOTION_NONE)



LinkLuaModifier("modifier_creeps_spell_earth_return_statue", "creeps_spell/creeps_spell_earth_return", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_earth_return_debuff", "creeps_spell/creeps_spell_earth_return", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_earth_return:GetIntrinsicModifierName()
	return "modifier_creeps_spell_earth_return"
end
function creeps_spell_earth_return:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/earth_return/shield/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf", context )


end

function creeps_spell_earth_return:Spawn()
	if IsServer() then
		self.unit_list = {}
		self.healing = 0
	end
end
function creeps_spell_earth_return:InsertTarget(target)
	if not self.unit_list[target] then
		self.unit_list[target] = 0
	end
	self.unit_list[target] = self.unit_list[target]  + 1
end
function creeps_spell_earth_return:InsertHealing(value)
	self.healing =self.healing + value
	if IsServer() then
		local caster = self:GetCaster()
		if caster:PassivesDisabled() then
			return
		end
		caster:AddNewModifier(caster, self, "modifier_creeps_spell_earth_return_shield", 
		{duration=self:GetSpecialValueFor("duration"),index=value})
	end

end




-- Fury Swipes modifier buff
modifier_creeps_spell_earth_return = advanced_modifier({})
function modifier_creeps_spell_earth_return:IsDebuff()return false end
function modifier_creeps_spell_earth_return:IsHidden()return true end
function modifier_creeps_spell_earth_return:IsPurgable() return false end
function modifier_creeps_spell_earth_return:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end

-- 分裂者的烈焰：中阶火元素死亡时将死亡之火附着到击杀者身上，并在状态创建5秒后爆炸，造成火元素全额攻击力*1的物理伤害。
-- 可以叠加，每次叠加不会刷新倒计时，但会使伤害变为目前的1.5倍。
-- 如果被附着火焰的人使+用’急行’，可以将火焰甩开并掉落到出发点1000范围内最近的友军身上（但如果没有其他友军则甩不开）。


function modifier_creeps_spell_earth_return:OnDeath(keys)
	if IsServer() then
		local target = keys.attacker
		local ability = self:GetAbility()
		local health = ability.healing
		local unitList = ability.unit_list
		local parent = self:GetParent()
		if health>0 then
			local unit = CreateUnitByName("npc_monster_middle_earth_element_statue", parent:GetOrigin(), true, nil, nil, parent:GetTeamNumber())
			-- unit:SetMaxHealth(health)
			-- unit:SetHealth(health)
			SetCreatureHealth(unit, health, true)
			_G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
			_G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
			local modifier = unit:AddNewModifier(unit, ability, "modifier_creeps_spell_earth_return_statue", {})
			if modifier then
				modifier:Init(unitList)
			end

		end

		
	end
end




modifier_creeps_spell_earth_return_shield = advanced_modifier({})
function modifier_creeps_spell_earth_return_shield:IsHidden() return false end
function modifier_creeps_spell_earth_return_shield:IsDebuff() return false end
function modifier_creeps_spell_earth_return_shield:IsPurgable() return false end
function modifier_creeps_spell_earth_return_shield:IsPurgeException() return false end
function modifier_creeps_spell_earth_return_shield:IsStunDebuff() return false end
function modifier_creeps_spell_earth_return_shield:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_earth_return_shield:OnCreated(keys)
    if not IsServer() then
        return
    end
    self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/earth_return/shield/effect.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(self.pfx, false, false, 15, false, false)
    self:SetStackCount(keys.index)
end

function modifier_creeps_spell_earth_return_shield:OnRefresh(keys)
    if not IsServer() then
        return
    end
    self:SetStackCount(self:GetStackCount()+keys.index)
end
function modifier_creeps_spell_earth_return_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end
function modifier_creeps_spell_earth_return_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return self:GetStackCount()
		-- return 0 
	end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage+1
	end
	return stack

end






modifier_creeps_spell_earth_return_statue = advanced_modifier({})
function modifier_creeps_spell_earth_return_statue:IsHidden() return false end
function modifier_creeps_spell_earth_return_statue:IsDebuff() return false end
function modifier_creeps_spell_earth_return_statue:IsPurgable() return false end
function modifier_creeps_spell_earth_return_statue:IsPurgeException() return false end
function modifier_creeps_spell_earth_return_statue:IsStunDebuff() return false end
function modifier_creeps_spell_earth_return_statue:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_earth_return_statue:GetTexture() return "brewmaster_primal_companion_earth" end
function modifier_creeps_spell_earth_return_statue:OnCreated(keys)
	if IsServer() then
		
	end
end
function modifier_creeps_spell_earth_return_statue:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

function modifier_creeps_spell_earth_return_statue:Init(unitList)
	

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_stoneremnant.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(self.pfx, false, false, 15, false, false)



	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 2, Vector(500,0,0))
	DestroyParticleByDelay(pfx,3)

	local parent = self:GetParent()
	self.modifierList = {}
	for unit, count in pairs(unitList) do
		local modifier = unit:AddNewModifier(parent, self:GetAbility(), "modifier_creeps_spell_earth_return_debuff", {stack = count})
		if modifier then
			table.insert(self.modifierList,modifier)
		end
	end


	
end


function modifier_creeps_spell_earth_return_statue:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end


function modifier_creeps_spell_earth_return_statue:OnDeath(keys)
	if IsServer() then
		for _, modifier in ipairs(self.modifierList) do
			if IsValid(modifier) then
				modifier:Destroy()
			end
		end

		ParticleManager:DestroyParticle(self.pfx,false)

		
	end
end



function modifier_creeps_spell_earth_return_statue:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end

	-- if keys.block_disabled then
    --     return 0 
    -- end
	local parent = self:GetParent()
	-- if parent:PassivesDisabled() then
	-- 	return
	-- end
	local health = parent:GetMaxHealth()*0.05
	if keys.damage>=health then
		return keys.damage - health
	end
	return 0 
end












modifier_creeps_spell_earth_return_debuff = advanced_modifier({})
function modifier_creeps_spell_earth_return_debuff:IsHidden() return false end
function modifier_creeps_spell_earth_return_debuff:IsDebuff() return true end
function modifier_creeps_spell_earth_return_debuff:IsPurgable() return false end
function modifier_creeps_spell_earth_return_debuff:IsPurgeException() return false end
function modifier_creeps_spell_earth_return_debuff:IsStunDebuff() return false end
function modifier_creeps_spell_earth_return_debuff:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_earth_return_debuff:GetTexture() return "brewmaster_primal_companion_earth" end
function modifier_creeps_spell_earth_return_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creeps_spell_earth_return_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	if ability then
		self.attribute_reduce = -ability:GetSpecialValueFor("attribute_reduce_per_hit")
	else
		self.attribute_reduce = -5
	end
	if IsServer() then
		
		self:SetStackCount(keys.stack)

		
	end


end

function modifier_creeps_spell_earth_return_debuff:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}

	
	return decFuncs	
end

function modifier_creeps_spell_earth_return_debuff:GetModifierBonusStats_Strength()	return self.attribute_reduce*self:GetStackCount() end
function modifier_creeps_spell_earth_return_debuff:GetModifierBonusStats_Intellect()	return self.attribute_reduce*self:GetStackCount() end
function modifier_creeps_spell_earth_return_debuff:GetModifierBonusStats_Agility()	return self.attribute_reduce*self:GetStackCount() end