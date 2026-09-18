heroTalent_npc_dota_hero_omniknight_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_2", "heroTalent/heroTalent_npc_dota_hero_omniknight_2", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_2_skewer", "heroTalent/heroTalent_npc_dota_hero_omniknight_2", LUA_MODIFIER_MOTION_HORIZONTAL  )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_omniknight_2_skewer_debuff", "heroTalent/heroTalent_npc_dota_hero_omniknight_2", LUA_MODIFIER_MOTION_HORIZONTAL  )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_omniknight_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_omniknight_2"
end




function heroTalent_npc_dota_hero_omniknight_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_heal.vpcf", context )
end
modifier_heroTalent_npc_dota_hero_omniknight_2 = class({})

function modifier_heroTalent_npc_dota_hero_omniknight_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_omniknight_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_omniknight_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_omniknight_2:OnCreated(keys)
	if IsServer() then
		self.record = {}
	end
end

function modifier_heroTalent_npc_dota_hero_omniknight_2:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function modifier_heroTalent_npc_dota_hero_omniknight_2:GetModifierProcAttack_BonusDamage_Magical(keys) 
	if not self:GetParent():IsRealHero() then
		return 0
	end
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		local time = ability:GetCooldownTimeRemaining()-0.2
		ability:EndCooldown()
		if time<=0 then
			return
		end
		ability:StartCooldown(time)
		return
	end
	local bonus = self:GetParent():GetAverageTrueAttackDamage(nil)*2
	ability:UseResources(true, true, true, true)
	self.record[keys.record] = true
	return bonus
end


function modifier_heroTalent_npc_dota_hero_omniknight_2:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		if self.record[params.record] then
			self.record[params.record] = nil
			if flDamage>0 then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, Target )
				ParticleManager:SetParticleControl(nFXIndex,0,Target:GetOrigin())
				ParticleManager:ReleaseParticleIndex( nFXIndex )
				Target:EmitSound("Hero_Omniknight.HammerOfPurity.Target")
				local enemies = FindUnitsInRadius(Attacker:GetTeamNumber(), Target:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				local count = 0
				for _, unit in ipairs(enemies) do
					if unit:GetHealthPercent()<100 then
						count = count + 1
						local healing = HealWithGain(flDamage,Attacker,unit,Ability)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
						ParticleManager:SetParticleControl(nFXIndex,0,unit:GetOrigin())
						ParticleManager:ReleaseParticleIndex( nFXIndex )
						if count>=3 then
							break
						end
					end

					
				end
		
			end
		end
	
	

	end

	return 0.0

end
