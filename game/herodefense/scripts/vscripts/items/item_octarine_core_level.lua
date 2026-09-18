
LinkLuaModifier("modifier_item_octarine_core_level1_buff", "items/item_octarine_core_level.lua", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
item_octarine_core_level1=class({})
function item_octarine_core_level1:GetIntrinsicModifierName() 
    return "modifier_item_octarine_core_level1_buff" 
end
item_octarine_core_level2=class({})
function item_octarine_core_level2:GetIntrinsicModifierName() 
    return "modifier_item_octarine_core_level1_buff" 
end 
item_octarine_core_level3=class({})
function item_octarine_core_level3:GetIntrinsicModifierName() 
    return "modifier_item_octarine_core_level1_buff" 
end
item_octarine_core_level4=class({})
function item_octarine_core_level4:GetIntrinsicModifierName() 
    return "modifier_item_octarine_core_level1_buff" 
end

function item_octarine_core_level4:Spawn()
        Timers:CreateTimer(0.3, function()
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_octarine_core_level1_buff", { })
        end)
end


modifier_item_octarine_core_level1_buff=advanced_modifier({})

function modifier_item_octarine_core_level1_buff:IsPassive()			return true end
function modifier_item_octarine_core_level1_buff:IsHidden() 		return true end
function modifier_item_octarine_core_level1_buff:IsPurgable() 		return false end
function modifier_item_octarine_core_level1_buff:IsPurgeException() return false end
function modifier_item_octarine_core_level1_buff:AllowIllusionDuplicate() return false end
function modifier_item_octarine_core_level1_buff:OnCreated()
    
    if self:GetAbility() == nil then
		return
    end
    local ability=self:GetAbility()
    self.bonus_cooldown= ability:GetSpecialValueFor("bonus_cooldown") 
    self.cast_range_bonus= ability:GetSpecialValueFor("cast_range_bonus") 
    self.bonus_health= ability:GetSpecialValueFor("bonus_health") 
    self.bonus_mana= ability:GetSpecialValueFor("bonus_mana") 
    self.bonus_mana_regen= ability:GetSpecialValueFor("bonus_mana_regen") 
    self.blood= ability:GetSpecialValueFor("blood") *0.01

end

function modifier_item_octarine_core_level1_buff:DeclareFunctions() 
    return 
    {
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS, 
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    } 
end

function modifier_item_octarine_core_level1_buff:OnTakeDamage(tg)
    if IsServer() then   
        local caster = self:GetCaster()
        if tg.attacker==caster and not caster:IsIllusion() and tg.inflictor~=nil and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 
            local life_steal_gain = caster:GetModifierLifeStealGain(1)
            local hp=tg.damage*self.blood *life_steal_gain
            hp = hp-hp%1
            if hp<=0 then return end   --没有吸血效果了就不执行了
            local ability = self:GetAbility()
           
            caster:Heal(hp, ability)

        end 
    end 
end

-- function modifier_item_octarine_core_level1_buff:GetModifierPercentageCooldown()
--     return self.bonus_cooldown
-- end

function modifier_item_octarine_core_level1_buff:GetModifierCastRangeBonus()
  return self.cast_range_bonus
end

function modifier_item_octarine_core_level1_buff:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_octarine_core_level1_buff:GetModifierManaBonus()
    return self.bonus_mana
end

function modifier_item_octarine_core_level1_buff:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end



function modifier_item_octarine_core_level1_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_item_octarine_core_level1_buff:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end
