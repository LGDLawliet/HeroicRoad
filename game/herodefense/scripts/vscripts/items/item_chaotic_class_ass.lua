LinkLuaModifier( "modifier_item_chaotic_class_ass", "items/item_chaotic_class_ass.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_class_ass_active", "items/item_chaotic_class_ass.lua", LUA_MODIFIER_MOTION_NONE )

item_chaotic_class_ass = class({})

function item_chaotic_class_ass:OnSpellStart()
	if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_chaotic_class_ass")
    if item ~=nil then
		local modifier = caster:FindModifierByName("modifier_item_chaotic_class_range_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_melee_phy")
		or caster:FindModifierByName("modifier_item_chaotic_class_summon")
		or caster:FindModifierByName("modifier_item_chaotic_class_ass")

		if modifier then
			modifier:Destroy()
		end
        caster:AddNewModifier(caster, nil, "modifier_item_chaotic_class_ass", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end

modifier_item_chaotic_class_ass = advanced_modifier({})

function modifier_item_chaotic_class_ass:IsDebuff()return false end
function modifier_item_chaotic_class_ass:IsHidden()return false end
function modifier_item_chaotic_class_ass:IsPurgable()return false end
function modifier_item_chaotic_class_ass:RemoveOnDeath()return false end
function modifier_item_chaotic_class_ass:DestroyOnExpire()	return false end
function modifier_item_chaotic_class_ass:GetTexture()	return "item_force_staff_wr_arcana_alt" end

function modifier_item_chaotic_class_ass:OnCreated(params)
	self.damage_down = 30
	self.duration = 2
	self.bonus_duration = 0.1
	self.cast_duration = 1.5
	self.other_atb = 10
	self.bonus_other_atb = 0.15
	self.cd_speed = 20
	self.cd_reduce = 0.1

	if not IsServer() then return end
	if self:GetParent():HasAbility("chaotic_ass_heal") then return end
    if not self.checkingAbility then
		local parent = self:GetParent()
		local maxSlotNumber = skillshop:GetMaxSpellCount(parent)
		if not parent:IsAlive() then
            return
        end
        if skillshop:GetPlayerAbilityNumber(parent) >= maxSlotNumber then
			return
		end
		self.checkingAbility = true
		if parent:HasAbility("chaotic_ass_heal") then
			return
		end
		chaotic_era:LearnChaoticEraSpell(parent,"chaotic_ass_heal")
	end
end

function modifier_item_chaotic_class_ass:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_item_chaotic_class_ass:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_chaotic_class_ass:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return self.damage_down
	end
	if self._tooltip == 2 then
		return self.other_atb + self.bonus_other_atb*self:GetParent():GetLevel()
	end
	if self._tooltip == 3 then
		return self.duration + self.bonus_duration*self:GetParent():GetLevel()
	end
	if self._tooltip == 4 then
		return self.cast_duration
	end
end

function modifier_item_chaotic_class_ass:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return -self.damage_down
end

function modifier_item_chaotic_class_ass:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 or keys.unit ~= self:GetParent() then
		return
	end
	local arti = keys.unit:FindModifierByName("modifier_item_hd_holy_staff_effects")
	local index = 0
	if arti and GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_holy_staff_effects") >= 20 then
		index = 1
	end
	local gain = self:GetParent():GetModifierDurationGainIndex(index)
	local heroes = GetAllRealHeroes()
	for _,hero in pairs(heroes) do
		local same = hero:FindModifierByName("modifier_item_chaotic_class_ass")
		if hero ~= self:GetParent() and not same then
			local modifier = hero:FindModifierByName("modifier_item_chaotic_class_ass_active")
			
			if modifier then
				modifier:SetDuration(modifier:GetRemainingTime() + self.cast_duration*gain,true)
			else
				local duration = self.duration + self:GetParent():GetLevel()*self.bonus_duration
				local stack1 = self.other_atb + self:GetParent():GetStrength()*self.bonus_other_atb
				local stack2 = self.other_atb + self:GetParent():GetAgility()*self.bonus_other_atb
				local stack3 = self.other_atb + self:GetParent():GetIntellect(false)*self.bonus_other_atb
				hero:AddNewModifier(self:GetParent(),nil,"modifier_item_chaotic_class_ass_active",{duration = duration*gain})
			end
		end
	end
end

---------------------

modifier_item_chaotic_class_ass_active = advanced_modifier({})

function modifier_item_chaotic_class_ass_active:IsDebuff()return false end
function modifier_item_chaotic_class_ass_active:IsHidden()return false end
function modifier_item_chaotic_class_ass_active:IsPurgable()return false end
function modifier_item_chaotic_class_ass_active:RemoveOnDeath()return false end
function modifier_item_chaotic_class_ass_active:GetTexture()	return "item_force_staff_wr_arcana_alt" end

function modifier_item_chaotic_class_ass_active:OnCreated(keys)
	self.other_atb = 10
	self.bonus_other_atb = 0.15
	local stack1 = self.other_atb + self:GetCaster():GetStrength()*self.bonus_other_atb
	local stack2 = self.other_atb + self:GetCaster():GetAgility()*self.bonus_other_atb
	local stack3 = self.other_atb + self:GetCaster():GetIntellect(false)*self.bonus_other_atb
	self.bonus_str = math.min(stack1 ,1000)
	self.bonus_agi = math.min(stack2, 1000)
	self.bonus_int = math.min(stack3 ,1000)
end

function modifier_item_chaotic_class_ass_active:OnRefresh(keys)
	self.other_atb = 10
	self.bonus_other_atb = 0.15
	local stack1 = self.other_atb + self:GetCaster():GetStrength()*self.bonus_other_atb
	local stack2 = self.other_atb + self:GetCaster():GetAgility()*self.bonus_other_atb
	local stack3 = self.other_atb + self:GetCaster():GetIntellect(false)*self.bonus_other_atb
	self.bonus_str = math.min(stack1 ,1000)
	self.bonus_agi = math.min(stack2, 1000)
	self.bonus_int = math.min(stack3 ,1000)
end

function modifier_item_chaotic_class_ass_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_chaotic_class_ass_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_chaotic_class_ass_active:Advanced_GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_item_chaotic_class_ass_active:Advanced_GetModifierBonusStats_Agility()
	return self.bonus_agi
end
function modifier_item_chaotic_class_ass_active:Advanced_GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_item_chaotic_class_ass_active:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self.bonus_str
	elseif self._tooltip == 2 then
		return self.bonus_agi
	elseif self._tooltip == 3 then
		return self.bonus_int
	end
end

