LinkLuaModifier("modifier_item_act3_chaos_unupdate", "items/item_act3_chaos.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_chaos", "items/item_act3_chaos.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_chaos_updated", "items/item_act3_chaos.lua", LUA_MODIFIER_MOTION_NONE)
item_act3_chaos_unupdate = class({})
function item_act3_chaos_unupdate:Precache(context)
    --PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", context)
end
function item_act3_chaos_unupdate:Spawn()
    if IsServer() then
		self:SetCurrentCharges(0)
        if IsInToolsMode() then
            caster:AddItemByName("item_act3_chaos")
        end
	end
end
function item_act3_chaos_unupdate:GetIntrinsicModifierName()
    return "modifier_item_act3_chaos_unupdate"
end

----
modifier_item_act3_chaos_unupdate = advanced_modifier({})

function modifier_item_act3_chaos_unupdate:IsHidden() return true end
function modifier_item_act3_chaos_unupdate:IsDebuff() return false end
function modifier_item_act3_chaos_unupdate:IsPurgable() return false end
function modifier_item_act3_chaos_unupdate:RemoveOnDeath() return false end

function modifier_item_act3_chaos_unupdate:GrowEvent()
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.ability:SetCurrentCharges(math.max(math.min(self.ability:GetCurrentCharges()+5, GetWave()*5), 5))
    if self.ability:GetCurrentCharges() >= 85 or IsInToolsMode() then
        local caster = self:GetCaster()
        local item = caster:FindItemInInventory("item_act3_chaos_unupdate")
        if item ~= nil then
            UTIL_RemoveImmediate(item) --removeitem的暂时替代
            caster:AddItemByName("item_act3_chaos")
        end
    end
end

function modifier_item_act3_chaos_unupdate:OnCreated()    
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.move_down = self.ability:GetSpecialValueFor("move_down")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.check4 = self.ability:GetSpecialValueFor("check4")
end

function modifier_item_act3_chaos_unupdate:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end
function modifier_item_act3_chaos_unupdate:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end
function modifier_item_act3_chaos_unupdate:GetModifierMoveSpeedBonus_Constant()
    return -self.move_down
end
function modifier_item_act3_chaos_unupdate:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -self.outgoing
end
function modifier_item_act3_chaos_unupdate:Advanced_GetModifierIncomingDamage_Percentage()
    return self.incoming
end
function modifier_item_act3_chaos_unupdate:OnWaveStart()
	if not IsServer() then return end
	if Game_State:IsInChaoticEra() then return end
	self:GrowEvent()
end
function modifier_item_act3_chaos_unupdate:OnChaoticEraRoundChange(keys)
	if not IsServer() then return end
	if not Game_State:IsInChaoticEra() then return end
	self:GrowEvent()
end

-----------------------------------------------------
item_act3_chaos = class({})

function item_act3_chaos:GetIntrinsicModifierName()
    return "modifier_item_act3_chaos"
end
modifier_item_act3_chaos = advanced_modifier({})

function modifier_item_act3_chaos:IsHidden() return true end
function modifier_item_act3_chaos:IsDebuff() return false end
function modifier_item_act3_chaos:IsPurgable() return false end
function modifier_item_act3_chaos:RemoveOnDeath() return false end

function modifier_item_act3_chaos:OnCreated()    
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

    self.all = self.ability:GetSpecialValueFor("all")
    self.profic = self.ability:GetSpecialValueFor("profic")
    self.outgoing_mult = self.ability:GetSpecialValueFor("outgoing_mult")
    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.cooldown_reduction = self.ability:GetSpecialValueFor("cooldown_reduction")
    self.summon_intensity = self.ability:GetSpecialValueFor("summon_intensity")
    self.manacost_reduction = self.ability:GetSpecialValueFor("manacost_reduction")
    self.level = self.ability:GetSpecialValueFor("level")

    if IsServer() then
        if (not self.already) and (not self.parent:HasModifier("modifier_item_act3_chaos_updated")) then
            for i = 0, self.level, 1 do
                self.parent:HeroLevelUp(true)
            end
            self.already = true
            self.parent:AddNewModifier(self.parent, nil, "modifier_item_act3_chaos_updated", {})
        end
    end
end

function modifier_item_act3_chaos:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_Summon_Intensity,

    }
end
function modifier_item_act3_chaos:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
    }
end
function modifier_item_act3_chaos:Advanced_GetModifierBonusStats_Strength()   
    return self.all
end
function modifier_item_act3_chaos:Advanced_GetModifierBonusStats_Agility()
    return self.all
end 
function modifier_item_act3_chaos:Advanced_GetModifierBonusStats_Intellect()
    return self.all
end
function modifier_item_act3_chaos:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end
function modifier_item_act3_chaos:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return self.outgoing_mult
end
function modifier_item_act3_chaos:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming
end
function modifier_item_act3_chaos:Advanced_GetModifierCooldownReduction()
    return self.cooldown_reduction
end
function modifier_item_act3_chaos:Advanced_GetModifier_Summon_Intensity()
    return self.summon_intensity
end
function modifier_item_act3_chaos:GetModifierPercentageManacostStacking()
    return self.manacost_reduction
end
----
modifier_item_act3_chaos_updated = advanced_modifier({})

function modifier_item_act3_chaos_updated:IsHidden() return true end
function modifier_item_act3_chaos_updated:IsDebuff() return false end
function modifier_item_act3_chaos_updated:IsPurgable() return false end
function modifier_item_act3_chaos_updated:IsPurgeException() return false end
function modifier_item_act3_chaos_updated:RemoveOnDeath() return false end
