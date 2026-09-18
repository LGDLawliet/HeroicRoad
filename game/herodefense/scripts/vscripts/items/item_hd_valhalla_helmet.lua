item_hd_valhalla_helmet = class({})

LinkLuaModifier("modifier_item_hd_valhalla_helmet", "items/item_hd_valhalla_helmet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_valhalla_helmet_active", "items/item_hd_valhalla_helmet", LUA_MODIFIER_MOTION_NONE)

function item_hd_valhalla_helmet:GetIntrinsicModifierName()
	return "modifier_item_hd_valhalla_helmet"
end

function item_hd_valhalla_helmet:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_Silencer.Curse")

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_crawler.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)

	caster:AddNewModifier(caster, self, "modifier_item_hd_valhalla_helmet_active", {duration = self:GetSpecialValueFor("duration")})

	local healing =  HealWithGain(self:GetSpecialValueFor("hp_active"),caster,caster,self)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)
end

-------------------------------------------------------------
modifier_item_hd_valhalla_helmet = advanced_modifier({})

function modifier_item_hd_valhalla_helmet:IsDebuff() return false end
function modifier_item_hd_valhalla_helmet:IsHidden() return true end
function modifier_item_hd_valhalla_helmet:IsPurgable() return false end


function modifier_item_hd_valhalla_helmet:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
end
function modifier_item_hd_valhalla_helmet:OnDestroy(keys)
	if not IsServer() then
		return
	end
	local modifier = self:GetParent():FindModifierByName("modifier_item_hd_valhalla_helmet_active")
	if modifier then
		modifier:SafeDestroy()
	end
end
function modifier_item_hd_valhalla_helmet:AdvancedGetModifierHealthBonus()	return self.bonus_health end

function modifier_item_hd_valhalla_helmet:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end

---------------------------------------------------------------
modifier_item_hd_valhalla_helmet_active = advanced_modifier({})

function modifier_item_hd_valhalla_helmet_active:IsDebuff() return false end
function modifier_item_hd_valhalla_helmet_active:IsHidden() return false end
function modifier_item_hd_valhalla_helmet_active:IsPurgable() return false end
function modifier_item_hd_valhalla_helmet_active:GetTexture()return "item_valhalla_helmet" end
function modifier_item_hd_valhalla_helmet_active:GetEffectAttachType() 	    return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_valhalla_helmet_active:GetEffectName() 	  return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf" end

function modifier_item_hd_valhalla_helmet_active:AdvancedGetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_valhalla_helmet_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
    }
end

function modifier_item_hd_valhalla_helmet_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_time = self.ability:GetSpecialValueFor("bonus_time")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
end

function modifier_item_hd_valhalla_helmet_active:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if not IsEnemy(keys.attacker, self:GetParent()) then
		return 
	end

	self:SetDuration(self:GetRemainingTime() + self:GetAbility():GetSpecialValueFor("bonus_time"), true)
	--local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_counter_glint.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	--ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	--ParticleManager:ReleaseParticleIndex(pfx)
	--self:GetParent():EmitSound("Hero_Antimage.Counterspell.Target")
end
