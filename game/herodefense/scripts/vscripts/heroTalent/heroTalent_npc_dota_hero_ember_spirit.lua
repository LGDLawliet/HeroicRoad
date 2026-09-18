heroTalent_npc_dota_hero_ember_spirit = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_ember_spirit", "heroTalent/heroTalent_npc_dota_hero_ember_spirit", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_ember_spirit:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_ember_spirit:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_ember_spirit:IsStealable() 				return true end
function heroTalent_npc_dota_hero_ember_spirit:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_ember_spirit:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_ember_spirit" end
-- function heroTalent_npc_dota_hero_ember_spirit:OnSpellStart()
--     local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_ember_spirit")
--     if modifier then
--         modifier:OnWaveEnd()
--     end
-- end


modifier_heroTalent_npc_dota_hero_ember_spirit = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_ember_spirit:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ember_spirit:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_ember_spirit:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
-- function modifier_heroTalent_npc_dota_hero_ember_spirit:OnCreated(table)
--     if not IsServer()  then
--         return
--     end


-- end
function modifier_heroTalent_npc_dota_hero_ember_spirit:OnWaveEnd()
    
    self:IncrementStackCount()
    return 1
end


function modifier_heroTalent_npc_dota_hero_ember_spirit:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件


	}
end

function modifier_heroTalent_npc_dota_hero_ember_spirit:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end






function modifier_heroTalent_npc_dota_hero_ember_spirit:OnTakeDamage(keys)
    if IsServer() then  
		if keys.unit == self:GetParent() then
			if keys.damage<=0 or not self:GetAbility():IsCooldownReady() then	return	end
			-- print("take damage")
			if keys.damage >= keys.unit:GetHealth() and self:GetStackCount()>=1   then
                self:DecrementStackCount()
				keys.unit:SetHealth(self:GetParent():GetMaxHealth()*0.5)
                keys.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invulnerable", {duration = 1})
                local caster = keys.unit
                local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
                ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex(effect_cast)
                caster:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")
  
				
			end

		end

    end 
end

