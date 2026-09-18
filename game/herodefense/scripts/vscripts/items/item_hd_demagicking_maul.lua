item_hd_demagicking_maul = class({})

LinkLuaModifier("modifier_item_hd_demagicking_maul", "items/item_hd_demagicking_maul", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_demagicking_maul:GetIntrinsicModifierName()
	return "modifier_item_hd_demagicking_maul"
end


modifier_item_hd_demagicking_maul = advanced_modifier({})

function modifier_item_hd_demagicking_maul:IsDebuff() return false end
function modifier_item_hd_demagicking_maul:IsHidden() return true end
function modifier_item_hd_demagicking_maul:IsPurgable() return false end
function modifier_item_hd_demagicking_maul:IsPurgeException() return false end
function modifier_item_hd_demagicking_maul:RemoveOnDeath() return false end
function modifier_item_hd_demagicking_maul:DestroyOnExpire() return false end
function modifier_item_hd_demagicking_maul:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end
function modifier_item_hd_demagicking_maul:AdvancedGetModifierExtraHealthPercentage() return 50 end
function modifier_item_hd_demagicking_maul:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.maxHealth =math.max( math.min(self:GetParent():GetMaxHealth()*0.5,10000),1)
        self:StartIntervalThink(0.25)     
    end
end
function modifier_item_hd_demagicking_maul:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	self.maxHealth =math.max( math.min(parent:GetMaxHealth()*0.5,10000),1)
    if parent:GetHealth()>self.maxHealth then
        -- self:GetParent():SetHealth(self.maxHealth)
		parent:ModifyHealth(self.maxHealth, self:GetAbility(), false, 0)
    end
   
end



function modifier_item_hd_demagicking_maul:OnAttackLanded(keys)
	if IsServer() then
		local target =keys.target
		local attacker = keys.attacker
		local caster = self:GetCaster()
		if attacker == caster then
		
			if not caster:IsApplyModifier() then
				return
			end
			local damage = caster:GetMaxHealth()*0.05
			if damage<=20 then
				return
			end
			
			local pfx_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives_cast_swirl.vpcf"
			local effect_cast = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			target:ModifyHealth(target:GetHealth()  -damage, self:GetAbility() , false, DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS+DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT)

		elseif target==caster then
			local damage = caster:GetMaxHealth()*0.03
			if damage<=20 then
				return
			end
			
			local pfx_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives_cast_swirl.vpcf"
			local effect_cast = ParticleManager:CreateParticle( pfx_name, PATTACH_ABSORIGIN_FOLLOW, attacker )
			ParticleManager:SetParticleControl( effect_cast, 0, attacker:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			attacker:ModifyHealth(attacker:GetHealth()  -damage, self:GetAbility() , false, DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS+DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT)

		end
	end
end

function modifier_item_hd_demagicking_maul:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end