-- 重写完成
item_hd_atb_earing_effects = class({})
LinkLuaModifier("modifier_item_hd_atb_earing_effects", "player_artifact/item_hd_atb_earing_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_atb_earing_effects_lv20", "player_artifact/item_hd_atb_earing_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_atb_earing_effects_lv30", "player_artifact/item_hd_atb_earing_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_atb_earing_effects_lv40", "player_artifact/item_hd_atb_earing_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_atb_earing_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_atb_earing_effects"
end
function item_hd_atb_earing_effects:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf", context )
end
-- function item_hd_atb_earing_effects:GetArtifactSpecialList()
--     local list = {}
--     list["76561198200656253"] = true
--     return list
-- end
-- function item_hd_atb_earing_effects:GetArtifactSpecialListLevelRequireReduction__Pct()
--     return 10
-- end
-- function item_hd_atb_earing_effects:GetArtifactSpecialListLevelRequireReduction__Con()
--     return 3
-- end
modifier_item_hd_atb_earing_effects = advanced_modifier({})

function modifier_item_hd_atb_earing_effects:IsDebuff() return false end
function modifier_item_hd_atb_earing_effects:IsHidden() return self.level < 40 end
function modifier_item_hd_atb_earing_effects:IsPurgable() return false end
function modifier_item_hd_atb_earing_effects:RemoveOnDeath() return false end
function modifier_item_hd_atb_earing_effects:GetTexture() return "item_artifact_64" end
function modifier_item_hd_atb_earing_effects:DestroyOnExpire() return false end
function modifier_item_hd_atb_earing_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.all = self.ability:GetArtifactSpecialValueFor("all")
    self.bonus_atb = self.ability:GetArtifactSpecialValueFor("bonus_atb")*0.01
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")

    self.atb_1 = self.ability:GetArtifactSpecialValueFor("atb_1")
    self.level_atb_2 = self.ability:GetArtifactSpecialValueFor("level_atb_2")
    self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")
    self.random_atb_3 = self.ability:GetArtifactSpecialValueFor("random_atb_3")
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.atb_lowest_4 = self.ability:GetArtifactSpecialValueFor("atb_lowest_4")
    self.outgoing_4 = self.ability:GetArtifactSpecialValueFor("outgoing_4")
    self.outgoing_max_4 = self.ability:GetArtifactSpecialValueFor("outgoing_max_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.keys_table = {
        [1] = {str = self.random_atb_3, agi = 0, int = 0},
        [2] = {str = 0, agi = self.random_atb_3, int = 0},
        [3] = {str = 0, agi = 0, int = self.random_atb_3},
    }
    self.time = 0

    
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_atb_earing_effects")
    if self.level >= 10 then
        self.all = self.all + self.atb_1
    end
    if self.level >= 70 then
        self.chance_4 = self.chance_7 
    end
    self.bonus_str =  self.all
	self.bonus_agi = self.all
	self.bonus_int = self.all
    self.speed_down = 0
    self.cd_down = 0
    if IsServer() then
        self:StartIntervalThink(1)
        self:SetHasCustomTransmitterData( true )--同步cy
    end
end

function modifier_item_hd_atb_earing_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.all = self.ability:GetArtifactSpecialValueFor("all")
    self.bonus_atb = self.ability:GetArtifactSpecialValueFor("bonus_atb")*0.01
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")

    self.atb_1 = self.ability:GetArtifactSpecialValueFor("atb_1")
    self.level_atb_2 = self.ability:GetArtifactSpecialValueFor("level_atb_2")
    self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")
    self.random_atb_3 = self.ability:GetArtifactSpecialValueFor("random_atb_3")
    self.chance_4 = self.ability:GetArtifactSpecialValueFor("chance_4")
    self.atb_lowest_4 = self.ability:GetArtifactSpecialValueFor("atb_lowest_4")
    self.outgoing_4 = self.ability:GetArtifactSpecialValueFor("outgoing_4")
    self.outgoing_max_4 = self.ability:GetArtifactSpecialValueFor("outgoing_max_4")
    self.chance_7 = self.ability:GetArtifactSpecialValueFor("chance_7")
    self.keys_table = {
        [1] = {str = self.random_atb_3, agi = 0, int = 0},
        [2] = {str = 0, agi = self.random_atb_3, int = 0},
        [3] = {str = 0, agi = 0, int = self.random_atb_3},
    }
    
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_atb_earing_effects")
    if self.level >= 10 then
        self.all = self.all + self.atb_1
    end
    if self.level >= 70 then
        self.chance_4 = self.chance_7 
    end
    self.bonus_str =  self.all
	self.bonus_agi = self.all
	self.bonus_int = self.all
end

function modifier_item_hd_atb_earing_effects:OnIntervalThink()
    local parent = self:GetParent()
    --基础属性+特效属性部分
    self.bonus_str = math.min(parent:GetBaseIntellect() *  self.bonus_atb ,300) + self.all
	self.bonus_agi = math.min(parent:GetBaseStrength() *  self.bonus_atb ,300) + self.all
	self.bonus_int = math.min(parent:GetBaseAgility() *  self.bonus_atb ,300) + self.all
    --lv20增加属性部分
    if self.level >= 20 then
        self.atb_2 = self.level_atb_2*parent:GetLevel()
        self.bonus_str = self.bonus_str + self.atb_2
	    self.bonus_agi = self.bonus_agi + self.atb_2
	    self.bonus_int = self.bonus_int + self.atb_2
        self.speed_down = self.atb_2*0.4
        self.cd_down = math.min(self.atb_2*0.06, 40)
    end
    --lv30增加属性部分
    self.time = self.time + 1
    if self.level >= 30 and self.time >= self.interval_3 then
        self.time = 0
        local random = math.random
        local atb_table = self.keys_table[random(1,3)]

        if self.level >= 40 then
            if self.chance_4 >= random(1,100) then
                atb_table = {str = self.random_atb_3, agi = self.random_atb_3, int = self.random_atb_3}
            end
        end
        if parent:IsAlive() then
            parent:AddNewModifier(parent, self.ability, "modifier_item_hd_atb_earing_effects_lv30", atb_table)
        end
    end
end
function modifier_item_hd_atb_earing_effects:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_item_hd_atb_earing_effects:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
        return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    end
end
function modifier_item_hd_atb_earing_effects:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_item_hd_atb_earing_effects:Advanced_GetModifierBonusStats_Strength()return self.bonus_str end
function modifier_item_hd_atb_earing_effects:Advanced_GetModifierBonusStats_Agility()return self.bonus_agi end
function modifier_item_hd_atb_earing_effects:Advanced_GetModifierBonusStats_Intellect()return self.bonus_int end
function modifier_item_hd_atb_earing_effects:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming
end
function modifier_item_hd_atb_earing_effects:GetModifierAttackSpeedBonus_Constant()
    return -self.speed_down
end
function modifier_item_hd_atb_earing_effects:Advanced_GetModifierCooldownReduction()
    return -self.cd_down
end

function modifier_item_hd_atb_earing_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if self.level < 40 then return 0 end
    local parent = self:GetParent()
    local str = parent:GetStrength()
    local agi = parent:GetAgility()
    local int = parent:GetIntellect(false)
    local result = math.min(math.floor(math.min(str,agi,int)/self.atb_lowest_4)*self.outgoing_4, self.outgoing_max_4)

    return result
end

function modifier_item_hd_atb_earing_effects:AddCustomTransmitterData( )
	return
	{
		bonus_str = self.bonus_str,
        bonus_agi = self.bonus_agi,
        bonus_int = self.bonus_int,
	}
end
function modifier_item_hd_atb_earing_effects:HandleCustomTransmitterData( data )
	self.bonus_str = data.bonus_str
    self.bonus_agi = data.bonus_agi
    self.bonus_int = data.bonus_int
end
---------
modifier_item_hd_atb_earing_effects_lv30 = advanced_modifier({})

function modifier_item_hd_atb_earing_effects_lv30:IsDebuff() return false end
function modifier_item_hd_atb_earing_effects_lv30:IsHidden() return false end
function modifier_item_hd_atb_earing_effects_lv30:IsPurgable() return false end
function modifier_item_hd_atb_earing_effects_lv30:GetTexture() return "item_artifact_64" end
function modifier_item_hd_atb_earing_effects_lv30:RemoveOnDeath() return false end
function modifier_item_hd_atb_earing_effects_lv30:OnCreated(keys)
    if IsServer() then
        self.str = keys.str
        self.agi = keys.agi
        self.int = keys.int
        self:SetHasCustomTransmitterData( true )--同步cy
    end
end
function modifier_item_hd_atb_earing_effects_lv30:OnRefresh(keys)
    if IsServer() then
        self.str = self.str + keys.str
        self.agi = self.agi + keys.agi
        self.int = self.int + keys.int
    end
end
function modifier_item_hd_atb_earing_effects_lv30:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_item_hd_atb_earing_effects_lv30:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end
function modifier_item_hd_atb_earing_effects_lv30:Advanced_GetModifierBonusStats_Strength(keys)
	return self.str
end
function modifier_item_hd_atb_earing_effects_lv30:Advanced_GetModifierBonusStats_Agility(keys)
	return self.agi
end
function modifier_item_hd_atb_earing_effects_lv30:Advanced_GetModifierBonusStats_Intellect(keys)
	return self.int
end

function modifier_item_hd_atb_earing_effects_lv30:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self.str
    elseif self._tooltip == 2 then
        return self.agi
    elseif self._tooltip == 3 then
        return self.int
    end
end
function modifier_item_hd_atb_earing_effects_lv30:AddCustomTransmitterData( )
	return
	{
		str = self.str,
        agi = self.agi,
        int = self.int,
	}
end
function modifier_item_hd_atb_earing_effects_lv30:HandleCustomTransmitterData( data )
	self.str = data.str
    self.agi = data.agi
    self.int = data.int
end
------------
