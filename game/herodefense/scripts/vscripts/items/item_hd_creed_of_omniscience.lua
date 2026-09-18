item_hd_creed_of_omniscience = class({})
LinkLuaModifier("modifier_item_hd_creed_of_omniscience_arua", "items/item_hd_creed_of_omniscience", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_creed_of_omniscience", "items/item_hd_creed_of_omniscience", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_creed_of_omniscience:GetIntrinsicModifierName()
	return "modifier_item_hd_creed_of_omniscience_arua"
end








modifier_item_hd_creed_of_omniscience_arua = class({})

function modifier_item_hd_creed_of_omniscience_arua:IsHidden() return true end
function modifier_item_hd_creed_of_omniscience_arua:IsAura() return true end
function modifier_item_hd_creed_of_omniscience_arua:GetAuraDuration() return 1 end
function modifier_item_hd_creed_of_omniscience_arua:GetModifierAura() return "modifier_item_hd_creed_of_omniscience" end
function modifier_item_hd_creed_of_omniscience_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius")  end
function modifier_item_hd_creed_of_omniscience_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_creed_of_omniscience_arua:GetAuraSearchTeam() return self:GetAbility():IsCooldownReady() and DOTA_UNIT_TARGET_TEAM_FRIENDLY or DOTA_UNIT_TARGET_TEAM_NONE end
function modifier_item_hd_creed_of_omniscience_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end











modifier_item_hd_creed_of_omniscience = class({})

function modifier_item_hd_creed_of_omniscience:IsDebuff() return false end
function modifier_item_hd_creed_of_omniscience:IsHidden() return false end
function modifier_item_hd_creed_of_omniscience:IsPurgable() return false end
-- function modifier_item_hd_creed_of_omniscience:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_creed_of_omniscience:GetTexture()return "item_creed_of_omniscience" end


function modifier_item_hd_creed_of_omniscience:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                        --受到伤害事件
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK

	}
end




function modifier_item_hd_creed_of_omniscience:OnTakeDamage(keys)
    if IsServer() then 
		local ability =self:GetAbility()  
		if not ability then
			return
		end
		if keys.unit~=self:GetParent() or not ability:IsCooldownReady() then
			return
		end
		if self:GetParent():GetHealth()<=50 then
			return
		end
		-- :UseResources(true, true, true, true)
		ability:StartCooldown(10)
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_WORLDORIGIN, keys.target)
		-- ParticleManager:SetParticleControlEnt(self.particle, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_attack1", keys.unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 0, keys.unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		local healing =  HealWithGain(50,self:GetCaster(),self:GetParent(),ability)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), healing, nil)


    end 
end

