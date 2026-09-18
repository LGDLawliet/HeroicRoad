item_hd_infernal_menace_talent = class({})

LinkLuaModifier("modifier_item_hd_infernal_menace_talent", "items/item_hd_infernal_menace_talent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_infernal_menace_talent_buff", "items/item_hd_infernal_menace_talent", LUA_MODIFIER_MOTION_NONE)

-- require('internal/timers')   --计时器功能
function item_hd_infernal_menace_talent:GetIntrinsicModifierName()
	return "modifier_item_hd_infernal_menace_talent"
end

function item_hd_infernal_menace_talent:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/arcane_bolt_advanced_unlock3/effect.vpcf", context )
end
----------------------------------------------------------------------
modifier_item_hd_infernal_menace_talent = advanced_modifier({})

function modifier_item_hd_infernal_menace_talent:IsDebuff() return false end
function modifier_item_hd_infernal_menace_talent:IsHidden() return false end
function modifier_item_hd_infernal_menace_talent:IsPurgable() return false end

function modifier_item_hd_infernal_menace_talent:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_model = self.ability:GetSpecialValueFor("bonus_model")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")

	self.bonus_chance = self.ability:GetSpecialValueFor("bonus_chance")
	self.hp_per = self.ability:GetSpecialValueFor("hp_per")

    if IsServer() then
		self.double_edge_ability = self:GetCaster():FindAbilityByName("Advanced_double_edge")
		self:StartIntervalThink(0.5)
	end
end
function modifier_item_hd_infernal_menace_talent:OnIntervalThink()
	self.double_edge_ability = self:GetCaster():FindAbilityByName("Advanced_double_edge")
	local lose_pct = 100*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())/self:GetCaster():GetMaxHealth()
	local stack = lose_pct/self.hp_per
	self.lose_chance = stack*self.bonus_chance

	self.last_hp = self:GetAbility():GetSpecialValueFor("last_hp")*0.01 * self:GetCaster():GetMaxHealth()
	if self:GetCaster():GetHealth() >= self.last_hp then
		self:GetCaster():ModifyHealth(self.last_hp, self:GetAbility(), false,0)
	end

	self.lose_hp = self.ability:GetSpecialValueFor("lose_hp")*0.005 * self:GetCaster():GetHealth()
	self:GetCaster():ModifyHealth(self:GetCaster():GetHealth() - self.lose_hp, self:GetAbility(), false ,0)
	self.block_hp = self.ability:GetSpecialValueFor("block_hp")*0.01 * self:GetCaster():GetMaxHealth()
	self:SetStackCount(self.block_hp)
end
--function modifier_item_hd_infernal_menace_talent:OnDestroy()
--	if IsServer() then
--		self:GetParent():RemoveModifierByName("modifier_item_hd_infernal_menace_talent_buff")
--	end
--end

function modifier_item_hd_infernal_menace_talent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,           
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_hd_infernal_menace_talent:OnTooltip()
	return self:GetStackCount()
end
function modifier_item_hd_infernal_menace_talent:GetModifierModelScale()	return self.bonus_model end
function modifier_item_hd_infernal_menace_talent:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,   
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,      
	}
end
function modifier_item_hd_infernal_menace_talent:Advanced_GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_infernal_menace_talent:AdvancedGetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_infernal_menace_talent:Advanced_GetModifierTotalBlockConstantMaximum()	return self:GetStackCount() end
--function modifier_item_hd_infernal_menace_talent:EffectStack()
--	local caster = self:GetCaster()
--	local gain = caster:GetModifierDurationGainIndex(1)
--	caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_infernal_menace_talent_buff", {duration=60*gain}) 
--end

function modifier_item_hd_infernal_menace_talent:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion() then
		return
	end
	if not self.double_edge_ability or self.double_edge_ability:IsNull() then
		local target
		local chance = 0
		local caster = self:GetParent()
		if keys.attacker ==caster then
			if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
				return
			end
			target = keys.target
			chance = self:GetAbility():GetSpecialValueFor("attack_chance") + self.lose_chance
		elseif  keys.target==caster then
			target = keys.attacker
			chance = 0.5*(self:GetAbility():GetSpecialValueFor("attack_chance") + self.lose_chance)
		else	
			return
		end
		if caster:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
			if not target:IsAlive() or target:IsMagicImmune() then
				return
			end
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = caster:GetStrength()*self:GetAbility():GetSpecialValueFor("str_index"),
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility(), --Optional.
			}
			ApplyDamage(damageTable)
		end
		return
	end


	local target
	local chance = 0
	local caster = self:GetParent()
	if keys.attacker ==caster then
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		target = keys.target
		chance = self:GetAbility():GetSpecialValueFor("attack_chance") + self.lose_chance
	elseif  keys.target==caster then
		target = keys.attacker
		chance = 0.5*(self:GetAbility():GetSpecialValueFor("attack_chance") + self.lose_chance)
	else	
		return
	end
	if caster:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
		if not target:IsAlive() or target:IsMagicImmune() then
			return
		end
		self.double_edge_ability:CastUnlock1ItemEffect(target)
	end
	
end


-------------------------
modifier_item_hd_infernal_menace_talent_buff = class({})

function modifier_item_hd_infernal_menace_talent_buff:IsHidden()	return false end
function modifier_item_hd_infernal_menace_talent_buff:IsDebuff()	return false end
function modifier_item_hd_infernal_menace_talent_buff:IsPurgable()	return false end
function modifier_item_hd_infernal_menace_talent_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_hd_infernal_menace_talent_buff:GetModifierBonusStats_Strength()	return math.min(5*self:GetStackCount(),300) end

function modifier_item_hd_infernal_menace_talent_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_infernal_menace_talent_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime() 
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_item_hd_infernal_menace_talent_buff:OnIntervalThink()
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