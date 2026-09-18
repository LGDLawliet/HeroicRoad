item_hd_mekansm = class({})

LinkLuaModifier("modifier_item_hd_mekansm_aura", "items/item_hd_mekansm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mekansm_active", "items/item_hd_mekansm", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function item_hd_mekansm:GetIntrinsicModifierName()
	return "modifier_item_hd_mekansm_aura"
end
modifier_item_hd_mekansm_aura = advanced_modifier({})


function modifier_item_hd_mekansm_aura:IsHidden()	return true end
function modifier_item_hd_mekansm_aura:IsDebuff()	return false end
function modifier_item_hd_mekansm_aura:IsPurgable() 		return false end
function modifier_item_hd_mekansm_aura:IsPurgeException() 	return false end
function modifier_item_hd_mekansm_aura:RemoveOnDeath()  return false end
function modifier_item_hd_mekansm_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_mekansm_aura:IsAura() 
	if IsServer() and self:GetAbility():IsCooldownReady() then
		return true 
	end
end

function modifier_item_hd_mekansm_aura:GetModifierAura()	return "modifier_item_hd_mekansm_active" end
function modifier_item_hd_mekansm_aura:GetAuraRadius()	return 100000  end---1找不到目标
function modifier_item_hd_mekansm_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_mekansm_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_item_hd_mekansm_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end


function modifier_item_hd_mekansm_aura:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_heal_amp = self.ability:GetSpecialValueFor("bonus_heal_amp")
end

function modifier_item_hd_mekansm_aura:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end

function modifier_item_hd_mekansm_aura:Advanced_GetModifierHealAMP_Percentage()
    return self.bonus_heal_amp
end

-----------------------------------------------------------
modifier_item_hd_mekansm_active = advanced_modifier({})

function modifier_item_hd_mekansm_active:IsDebuff() return false end
function modifier_item_hd_mekansm_active:IsHidden() return false end
function modifier_item_hd_mekansm_active:IsPurgable() return false end
function modifier_item_hd_mekansm_active:GetTexture() return "item_mekansm" end


function modifier_item_hd_mekansm_active:OnCreated(keys)
	self.active = self:GetAbility():GetSpecialValueFor("active")*0.01*self:GetParent():GetMaxHealth()
end

function modifier_item_hd_mekansm_active:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
    }
end

function modifier_item_hd_mekansm_active:OnTakeDamage(keys)
	if IsServer() and self:GetAbility():IsCooldownReady() and keys.unit:GetHealth()<=0 and not keys.unit.force_die then
		local parent =  keys.unit
		parent:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
		parent:SetHealth(1)
		local healing =  HealWithGain(self.active,self:GetCaster(),parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)

		self.particle = ParticleManager:CreateParticle("particles/econ/events/ti10/mekanism_recipient_ti10_rim.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
			
		local pos = parent:GetAbsOrigin()
		ParticleManager:SetParticleControl(self.particle, 1, Vector(pos.x,pos.y,pos.z+128))
		ParticleManager:ReleaseParticleIndex(self.particle)

		self:GetAbility():UseResources(true, true, true,true)		
	end
end