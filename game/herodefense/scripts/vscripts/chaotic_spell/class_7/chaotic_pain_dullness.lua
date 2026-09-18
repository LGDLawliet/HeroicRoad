chaotic_pain_dullness = class({})
LinkLuaModifier("modifier_chaotic_pain_dullness", "chaotic_spell/class_7/chaotic_pain_dullness", LUA_MODIFIER_MOTION_NONE)

-- function chaotic_pain_dullness:Spawn() 
--     if not IsServer() then
--         return
--     end
--     self:GetCaster():GameTimer(0.1,function()
--         if IsValid(self) then
--             self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chaotic_pain_dullness", {})
--         end
--     end)
-- end

function chaotic_pain_dullness:GetIntrinsicModifierName()
	return "modifier_chaotic_pain_dullness"
end


modifier_chaotic_pain_dullness = advanced_modifier({})

function modifier_chaotic_pain_dullness:IsDebuff()			return false end
function modifier_chaotic_pain_dullness:IsHidden() 		return false end
function modifier_chaotic_pain_dullness:IsPurgable() 		return false end
function modifier_chaotic_pain_dullness:IsPurgeException() return false end
function modifier_chaotic_pain_dullness:GetTexture() return "pudge/arcana/pudge_flesh_heap_arcana" end

function modifier_chaotic_pain_dullness:ADDeclareFunctions()
    return 
    {
        MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL= {nil, self.parent},   
    }
end

function modifier_chaotic_pain_dullness:OnCreated()
    if not IsServer() then
		return
	end
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction") * 0.01
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.damage_interval =  self.ability:GetSpecialValueFor("damage_interval")
    self.damage_changing =  self.ability:GetSpecialValueFor("damage_changing")*0.01

    self.damage_reduction_record = 0
    self.damage_record = 0
    self.time_require = 0
    self.stop_delete = true
    self.tData = {}
    if self.ability:GetRuneType()==1 then
        -- self.timer = Gamerules:GetGameTime()+1
        self.rune_1_bonus = self.ability:GetSpecialValueFor("rune_1_bonus")*0.01
    end
    self:StartIntervalThink(0.1)
    -- self:SetHasCustomTransmitterData( true )
end

function modifier_chaotic_pain_dullness:OnRefresh()
    if not IsServer() then
		return
	end
    self.ability = self:GetAbility()
end

function modifier_chaotic_pain_dullness:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if not IsServer() then
		return 0
	end
    if keys.block_disabled then
        return 0 
    end
    if self.parent:PassivesDisabled() then
        return 0
    end   
    if keys.damage<=10 then
        return 0
    end
    if keys.attacker and keys.attacker==self.parent then
        return 0
    end
    if not IsValid(self.ability) then
        return 0
    end
    local damage_block = keys.damage * self.damage_reduction
    local damage_record = damage_block * self.damage_changing
    self.damage_reduction_record = self.damage_reduction_record + damage_record
	self:SetStackCount(self.damage_reduction_record)
    table.insert(self.tData, { 
        duration = self.duration , 
        damage = damage_record /self.duration,
        next_damage_time = GameRules:GetGameTime()+ self.damage_interval,
    })
	return damage_block
end

function modifier_chaotic_pain_dullness:OnIntervalThink()
	if IsServer() then
        if not IsValid(self.ability) and self:GetStackCount() <= 0 then
            self:Destroy()
            return
        end
        local damage_total = 0
        local time = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if 0 < self.tData[i].duration then
                if self.tData[i].next_damage_time <= time then
                    self.tData[i].next_damage_time = time +  self.damage_interval
                    damage_total = damage_total + self.tData[i].damage
                    self.tData[i].duration = self.tData[i].duration -  self.damage_interval
                    self.damage_reduction_record = self.damage_reduction_record - self.tData[i].damage
                    self:SetStackCount(self.damage_reduction_record)
                    if self.tData[i].duration<=0 then
                        table.remove(self.tData, i)
                    end
                end
			end
        
		end
        if self.rune_1_bonus then
            damage_total = damage_total - self.rune_1_bonus* self.parent:GetHealth()
        end
        if damage_total>=1 then
            local caster = self:GetCaster()
            local damageTable = {
                victim = caster,
                attacker = caster,
                damage = damage_total,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL +DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_HPLOSS, --不致死与不触发吸血，技能伤害
                ability = self:GetAbility(), --Optional.
            }
            ApplyDamage(damageTable)
        end
       

	end
end

function modifier_chaotic_pain_dullness:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_pain_dullness:OnTooltip() 

    return self:GetStackCount()
    
end