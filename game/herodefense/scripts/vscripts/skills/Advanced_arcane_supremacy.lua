LinkLuaModifier( "modifier_Advanced_arcane_supremacy", "skills/Advanced_arcane_supremacy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_arcane_supremacy_middle", "skills/Advanced_arcane_supremacy", LUA_MODIFIER_MOTION_NONE )
Advanced_arcane_supremacy = class({})

function Advanced_arcane_supremacy:GetIntrinsicModifierName()
	return "modifier_Advanced_arcane_supremacy"
end
function Advanced_arcane_supremacy:CheckKV(key)
	local table = {
		crit = 2,
		bonus_pri = 1,
	}
	local value = table[key] or -1
	return value

end
---------------------------------------------------------------------


modifier_Advanced_arcane_supremacy = advanced_modifier({})
function modifier_Advanced_arcane_supremacy:IsDebuff() return false end
function modifier_Advanced_arcane_supremacy:IsHidden() return true end
function modifier_Advanced_arcane_supremacy:IsPurgable() return false end
function modifier_Advanced_arcane_supremacy:RemoveOnDeath() return false end
function modifier_Advanced_arcane_supremacy:OnCreated(params)
	local parent = self:GetParent()
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")
	self.pri_spell_amp = self:GetAbility():GetSpecialValueFor("pri_spell_amp")
	
    self.last_cast = nil
	if IsServer() then
		self:SetStackCount(parent:GetPrimaryAttribute())
	end
end

function modifier_Advanced_arcane_supremacy:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_Advanced_arcane_supremacy:Advanced_GetModifierSpellAmplifyBonus()
	self.pri_spell_amp = self:GetAbility():GetSpecialValueFor("pri_spell_amp")
	if self:GetStackCount()==DOTA_ATTRIBUTE_AGILITY  then
		return self.pri_spell_amp*self:GetParent():GetAgility()
	end
	if self:GetStackCount()==DOTA_ATTRIBUTE_STRENGTH  then
		return self.pri_spell_amp*self:GetParent():GetStrength()
	end
	return
end

function modifier_Advanced_arcane_supremacy:AdvancedGetModifierConstantManaRegen()
	-- lv15
	if self:GetAbility():GetSpecialValueFor("advanced_level") < 15 then
		return 0
	end
	if self:GetStackCount()==DOTA_ATTRIBUTE_AGILITY or self:GetStackCount()==DOTA_ATTRIBUTE_STRENGTH  then
		return self:GetParent():GetIntellect(false)*0.2
	end
	return	self:GetParent():GetIntellect(false)*0.1
end

function modifier_Advanced_arcane_supremacy:Advanced_GetModifierBonusStats_Strength()	
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_pri*0.3
	end
	return self:GetStackCount()==0 and self.bonus_pri or 0 
end

function modifier_Advanced_arcane_supremacy:Advanced_GetModifierBonusStats_Intellect()
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")	
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_pri*0.3
	end
	return self:GetStackCount()==2 and self.bonus_pri or 0 
end

function modifier_Advanced_arcane_supremacy:Advanced_GetModifierBonusStats_Agility()	
	self.bonus_pri = self:GetAbility():GetSpecialValueFor("bonus_pri")
	if self:GetStackCount()==DOTA_ATTRIBUTE_ALL  then
		return self.bonus_pri*0.3
	end
	return self:GetStackCount()==1 and self.bonus_pri or 0 
end

function modifier_Advanced_arcane_supremacy:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local target = keys.target

	if keys.attacker ~= self:GetParent() then--是自己打的
		return
	end
	if not IsEnemy(target,attacker) then--打的是敌人
		return
	end
	if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then--用的技能伤害
		return 
	end
	if Cannotcrit(keys) then--不是不能暴击的那种
		return
	end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end--不是生命流失
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end--不是无任何追加
	
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.crit = self:GetAbility():GetSpecialValueFor("crit")-100
	self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
	-- lv10
	if self:GetAbility().advanced_level >= 10 then
		self.outgoing = 30
	end
    local crit_grow = attacker:FindModifierByName("modifier_Advanced_arcane_supremacy_middle")
    if crit_grow then
        local index_max = self:GetAbility():GetSpecialValueFor("index_max")
		-- lv5
		if self:GetAbility().advanced_level >= 5 then
			index_max = 130
		end
        self.crit = self.crit + math.min(crit_grow:GetStackCount(),index_max)
    end

	local random = math.random
	if self.chance >= random(1,100) then
		-- lv20
		if self:GetAbility().advanced_level >= 20 then
			if target:GetHealthPercent() < 1 then
				target:ForceKill(false)
			end
		end
		return self.crit
	else
		return self.outgoing
	end
	return 0
end

function modifier_Advanced_arcane_supremacy:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return
	end
	if keys.ability:IsToggle() or keys.ability:IsItem() then
		return
	end

    local duration = self:GetAbility():GetSpecialValueFor("duration")
	-- lv5
	if self:GetAbility().advanced_level >= 5 then
		duration = 25
	end
    -- 第一次释放技能，lastcast是nil，添加普通加成后把这次技能记录为lastcast
    if self.last_cast == nil then
        local index = self:GetAbility():GetSpecialValueFor("index")
        keys.unit:AddNewModifier(keys.unit, self:GetAbility() , "modifier_Advanced_arcane_supremacy_middle", {duration = duration ,stack_time = duration, stack = index})
    end
    -- 从第二次释放技能lastcast不是nil，也不是此次技能，使用更高加成，然后将此次技能记录为lastcast
    if self.last_cast ~= nil and self.last_cast ~= keys.ability  then
        local index_pro = self:GetAbility():GetSpecialValueFor("index_pro")
        keys.unit:AddNewModifier(keys.unit, self:GetAbility() , "modifier_Advanced_arcane_supremacy_middle", {duration = duration ,stack_time = duration, stack = index_pro})
    end
    -- 从第二次释放技能lastcast不是nil，是此次技能，使用普通加成，然后将此次技能记录为lastcast
    if self.last_cast ~= nil and self.last_cast == keys.ability  then
        local index = self:GetAbility():GetSpecialValueFor("index")
        keys.unit:AddNewModifier(keys.unit, self:GetAbility() , "modifier_Advanced_arcane_supremacy_middle", {duration = duration,stack_time = duration , stack = index})
    end
    self.last_cast = keys.ability
end


-- 增伤独立叠加
-- 独立叠加不同层数cy
modifier_Advanced_arcane_supremacy_middle = advanced_modifier({})

function modifier_Advanced_arcane_supremacy_middle:IsDebuff() return false end
function modifier_Advanced_arcane_supremacy_middle:IsPurgable() return false end

function modifier_Advanced_arcane_supremacy_middle:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_arcane_supremacy_middle:OnRefresh(keys)
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+keys.stack_time
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_Advanced_arcane_supremacy_middle:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end