item_hd_giants_ring = class({})
-- LinkLuaModifier("modifier_item_hd_giants_ring_arua", "items/item_hd_giants_ring", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_giants_ring_arua_effect", "items/item_hd_giants_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_giants_ring", "items/item_hd_giants_ring", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_giants_ring:GetIntrinsicModifierName()
	return "modifier_item_hd_giants_ring"
end






modifier_item_hd_giants_ring = advanced_modifier({})

function modifier_item_hd_giants_ring:IsDebuff() return false end
function modifier_item_hd_giants_ring:IsHidden() return true end
function modifier_item_hd_giants_ring:IsPurgable() return false end
function modifier_item_hd_giants_ring:GetEffectName() return "particles/new_effect/new_effect/new_hd_giants_ring.vpcf" end
function modifier_item_hd_giants_ring:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_item_hd_giants_ring:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")



	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

	

    if IsServer() then

		self:StartIntervalThink(1)
	
	end
end
function modifier_item_hd_giants_ring:OnIntervalThink()
	if IsServer() then

		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local damage =  self:GetCaster():GetStrength()
			local damagetype = self:GetAbility():GetAbilityDamageType()
			for i, enemy in pairs(enemies) do
				local damageTable = {
					victim = enemy,
					attacker = caster,
					damage = damage,
					damage_type = damagetype,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
					ability = self, --Optional.
					}
				ApplyDamage(damageTable)	
				if i>=3 then
					break
				end
			end
	end
end



function modifier_item_hd_giants_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_MODEL_SCALE,
		

	}
end
function modifier_item_hd_giants_ring:GetModifierModelScale() 
    return 60
end

function modifier_item_hd_giants_ring:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_giants_ring:GetModifierMoveSpeedBonus_Constant() return self.bonus_move end

function modifier_item_hd_giants_ring:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only,

    }
end

function modifier_item_hd_giants_ring:Advanced_GetModifier_FlyingPathing()	
	return 1
end
