item_set_mbone_shield = class({})
LinkLuaModifier("modifier_item_set_mbone_shield", "items/item_set_mbone_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_set_mbone_active", "items/item_set_mbone_shield", LUA_MODIFIER_MOTION_NONE)

function item_set_mbone_shield:GetIntrinsicModifierName()
	return "modifier_item_set_mbone_shield"
end

modifier_item_set_mbone_shield = advanced_modifier({})

function modifier_item_set_mbone_shield:IsDebuff() return false end
function modifier_item_set_mbone_shield:IsHidden() return self:GetStackCount()<=0 end
function modifier_item_set_mbone_shield:IsPurgable() return false end

function modifier_item_set_mbone_shield:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_block = self.ability:GetSpecialValueFor("bonus_block")
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.hp_heal = self.ability:GetSpecialValueFor("hp_heal")*0.01
    self:SetStackCount(0)
    if IsServer() then
        self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
    end
end 

function modifier_item_set_mbone_shield:OnIntervalThink()
    print("找到了吗？")
    if self:GetParent():HasModifier("modifier_item_set_mbone_sword") then
        self:SetStackCount(math.min(self:GetStackCount()+1,self.ability:GetSpecialValueFor("max_stack")))
    end
end

function modifier_item_set_mbone_shield:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
    }
end

function modifier_item_set_mbone_shield:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
	return self.bonus_block 
end

function modifier_item_set_mbone_shield:OnTakeDamage(keys)  
    if not IsServer() then
        return
    end
    if keys.unit ~= self:GetParent() then
        return
    end

    if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and keys.damage>0 and self:GetAbility():IsCooldownReady() then
        local random = math.random
        local ability = self:GetAbility()
        local caster = self:GetParent()
        if self.chance >= random(1,100) then
            local healing = self.hp_heal * caster:GetMaxHealth()
            local fhealing =  HealWithGain(healing,self:GetParent(),self:GetParent(),ability) --返回治疗的数值
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self:GetParent(), fhealing, nil) 
            self:GetAbility():UseResources(true, true, true, true)
        end
    end

    if self:GetParent():HasModifier("modifier_item_set_mbone_sword") then
        if self:GetStackCount()>=1 and not self:GetParent():IsAlive() then
            self:SetStackCount(self:GetStackCount()-1)
            self:GetParent():SetHealth(1)
            local effect_cast1 = ParticleManager:CreateParticle( "particles/ui/tips/muerta_death_reckoning_flames_green.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
			ParticleManager:SetParticleControlEnt( effect_cast1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
			DestroyParticleByDelay(effect_cast1,2)
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_set_mbone_active", {duration = 3})
        end
    end
end
-----------
modifier_item_set_mbone_active = advanced_modifier({})

function modifier_item_set_mbone_active:IsDebuff() return false end
function modifier_item_set_mbone_active:IsHidden() return true end
function modifier_item_set_mbone_active:IsPurgable() return false end

function modifier_item_set_mbone_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active_attack_speed = self.ability:GetSpecialValueFor("active_attack_speed")
end
function modifier_item_set_mbone_active:DeclareFunctions(keys)
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end
function modifier_item_set_mbone_active:GetModifierAttackSpeedBonus_Constant(keys)
    return self.active_attack_speed
end