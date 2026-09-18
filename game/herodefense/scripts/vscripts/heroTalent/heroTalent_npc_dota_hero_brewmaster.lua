heroTalent_npc_dota_hero_brewmaster = class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_brewmaster", "heroTalent/heroTalent_npc_dota_hero_brewmaster", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_brewmaster:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_brewmaster"
end


modifier_heroTalent_npc_dota_hero_brewmaster = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_brewmaster:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_brewmaster:IsHidden() 		return false end
function modifier_heroTalent_npc_dota_hero_brewmaster:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_brewmaster:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_brewmaster:GetTexture() return "brewmaster_drunken_haze" end

function modifier_heroTalent_npc_dota_hero_brewmaster:ADDeclareFunctions()
    return 
    {
        MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL= {nil, self:GetParent()},
        MODIFIER_EVENT_ON_DEATH = {nil,nil},   
    }
end

function modifier_heroTalent_npc_dota_hero_brewmaster:OnCreated()
    if not IsServer() then
		return
	end
    self.parent = self:GetParent()
	self.caster = self:GetCaster()
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
    self:StartIntervalThink(0.1)
     self:SetHasCustomTransmitterData( true )
	self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.nFXIndex, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)

	self:AddParticle(self.nFXIndex, false, false, -1, false, false)
end

function modifier_heroTalent_npc_dota_hero_brewmaster:OnRefresh()
    if not IsServer() then
		return
	end
    self.ability = self:GetAbility()
end

function modifier_heroTalent_npc_dota_hero_brewmaster:OnDeath(keys)
    if not IsServer() then
		return
	end
    if self:GetParent() == keys.attacker then
        self:SetStackCount(self:GetStackCount() * (1-self.ability:GetSpecialValueFor("kill_reduce")*0.01))
    end
    if keys.unit == self:GetParent() then
       self:SetStackCount(0) 
    end
end

function modifier_heroTalent_npc_dota_hero_brewmaster:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if not IsServer() then
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

function modifier_heroTalent_npc_dota_hero_brewmaster:OnIntervalThink()
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
        if damage_total>=1 then
            local caster = self:GetCaster()
            local damageTable = {
                victim = caster,
                attacker = caster,
                damage = damage_total,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --不致死与不触发吸血，技能伤害
                ability = self:GetAbility(), --Optional.
                hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY
            }
            ApplyDamage(damageTable)
        end
       

	end
end

function modifier_heroTalent_npc_dota_hero_brewmaster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_heroTalent_npc_dota_hero_brewmaster:OnTooltip() 

    return self:GetStackCount()
    
end