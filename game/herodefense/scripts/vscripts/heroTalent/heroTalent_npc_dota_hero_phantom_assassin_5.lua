heroTalent_npc_dota_hero_phantom_assassin_5 = heroTalent_npc_dota_hero_phantom_assassin_5 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_5", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_5", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_5_debuff", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_5", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
-- function heroTalent_npc_dota_hero_phantom_assassin_5:GetIntrinsicModifierName()
-- 	return "modifier_heroTalent_npc_dota_hero_phantom_assassin_5"
-- end

function heroTalent_npc_dota_hero_phantom_assassin_5:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf", context )
	-- PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives_debuff.vpcf", context )
end
function heroTalent_npc_dota_hero_phantom_assassin_5:Trigger(target)

	local caster = self:GetCaster()
	if target:IsAlive() then
		caster:PerformAttack(target, false, true, true, false, false, false, true)

	end

 
	if self:GetAutoCastState() then
		local pfx_name = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
		caster:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)

		local endpos = target:GetAbsOrigin() + (target:GetForwardVector() * -1) * 120
		if endpos~=caster:GetAbsOrigin() then
			FindClearSpaceForUnit(caster, endpos, true)
			caster:SetForwardVector(target:GetForwardVector())
			caster:MoveToTargetToAttack(target)
		end

		local duration = self:GetSpecialValueFor("duration")* caster:GetModifierDurationGainIndex(1)
		caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_phantom_assassin_5", {duration = duration})
	
	end





end


function heroTalent_npc_dota_hero_phantom_assassin_5:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Stifling_Dagger",costKeys)
			end
		end)
	
	end

end










modifier_heroTalent_npc_dota_hero_phantom_assassin_5 =modifier_heroTalent_npc_dota_hero_phantom_assassin_5 or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:OnCreated(keys)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
end



function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end

function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move_speed
end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:Advanced_GetModifierAttackSpeedPercentage()
	return self.bonus_attack_speed
end


function modifier_heroTalent_npc_dota_hero_phantom_assassin_5:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:GetModifierMoveSpeedBonus_Percentage()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierAttackSpeedPercentage()
	end
end
