item_chaotic_roshan_flag_defense = class({})
LinkLuaModifier("modifier_item_chaotic_roshan_flag_defense", "items/item_chaotic_roshan_flag_defense", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_roshan_flag_defense_buff", "items/item_chaotic_roshan_flag_defense", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_roshan_flag_defense_summon", "items/item_chaotic_roshan_flag_defense", LUA_MODIFIER_MOTION_NONE)
function item_chaotic_roshan_flag_defense:GetIntrinsicModifierName()
    return "modifier_item_chaotic_roshan_flag_defense"
end
function item_chaotic_roshan_flag_defense:GetCastRange()
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
---------------------------------
modifier_item_chaotic_roshan_flag_defense = advanced_modifier({})
function modifier_item_chaotic_roshan_flag_defense:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_defense:IsHidden() return true end
function modifier_item_chaotic_roshan_flag_defense:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_defense:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_positive_amp = self.ability:GetSpecialValueFor("bonus_positive_amp")
    self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
    self.armor = self.ability:GetSpecialValueFor("armor")*0.01
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.buff_duration = 3.5  -- 略长于更新间隔，确保效果连续
    
    if IsServer() then
        self:StartIntervalThink(3.0)
        self:OnIntervalThink()  -- 立即执行一次
        self.check = true
		self:CheckIteam() 
    end
end

function modifier_item_chaotic_roshan_flag_defense:CheckIteam()
	local caster = self:GetParent()
	local item_1, item_2,item_3
	for i = 0, 8, 1 do
		local current_item = caster:GetItemInSlot(i)
		if current_item then
			local name = current_item:GetAbilityName()
			if name=="item_chaotic_roshan_flag_defense" then
				item_1 = current_item
			elseif name=="item_chaotic_roshan_flag_attack" then
				item_2 = current_item
			elseif name=="item_chaotic_roshan_flag_cooldown" then
				item_3 = current_item
			end
		end
	end

	if item_1 and item_2 and item_3 then
		UTIL_RemoveImmediate(item_1)
		UTIL_RemoveImmediate(item_2)
        UTIL_RemoveImmediate(item_3)
		caster:AddItemByName("item_chaotic_roshan_flag_final")
	end
end

function modifier_item_chaotic_roshan_flag_defense:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_DurationGain,
        MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_roshan_flag_defense:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -self.outgoing
end
function modifier_item_chaotic_roshan_flag_defense:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_chaotic_roshan_flag_defense:Advanced_GetModifier_DurationGain()
    return self.bonus_positive_amp
end
function modifier_item_chaotic_roshan_flag_defense:AdvancedOnSummon(keys)
    if not IsServer() then return end
    if keys.unit ~= self.parent then return end
    if not IsValid(keys.target) then return end
    keys.target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_roshan_flag_defense_summon", {})
end

function modifier_item_chaotic_roshan_flag_defense:OnIntervalThink()
    if not IsServer() then return end
    -- 抓取周围友军单位
    local allies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
        0,
        false
    )
    
    -- 为每个单位添加或刷新buff
    for _, ally in pairs(allies) do
        local final_modifier = ally:FindModifierByName("modifier_item_chaotic_roshan_flag_final_buff")
        if not final_modifier then
            local modifier = ally:FindModifierByName("modifier_item_chaotic_roshan_flag_defense_buff")
            if modifier then
                modifier:Destroy()
            end
            local current_armor = ally:GetPhysicalArmorValue(false)
            local armor = current_armor*self.armor
            ally:AddNewModifier(self.caster,self.ability,"modifier_item_chaotic_roshan_flag_defense_buff",{duration = self.buff_duration,armor = armor})
        end
    end
end

---------------------------------
modifier_item_chaotic_roshan_flag_defense_summon = advanced_modifier({})    

function modifier_item_chaotic_roshan_flag_defense_summon:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_defense_summon:IsHidden() return true end
function modifier_item_chaotic_roshan_flag_defense_summon:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_defense_summon:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()

    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_roshan_flag_defense_summon:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_item_chaotic_roshan_flag_defense_summon:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then self:Destroy() return end
    return -self.outgoing
end
---------------------------------
modifier_item_chaotic_roshan_flag_defense_buff = advanced_modifier({})
function modifier_item_chaotic_roshan_flag_defense_buff:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_defense_buff:IsHidden() return false end
function modifier_item_chaotic_roshan_flag_defense_buff:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_defense_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    if IsServer() then
        self.armor = keys.armor
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end

function modifier_item_chaotic_roshan_flag_defense_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_chaotic_roshan_flag_defense_buff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPhysicalArmorBonus()
	end
end

function modifier_item_chaotic_roshan_flag_defense_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_chaotic_roshan_flag_defense_buff:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then self:Destroy() return end
    return self.armor
end

function modifier_item_chaotic_roshan_flag_defense_buff:AddCustomTransmitterData( )
	return
	{
		armor = self.armor,
	}
end

function modifier_item_chaotic_roshan_flag_defense_buff:HandleCustomTransmitterData( data )
	self.armor = data.armor
end
