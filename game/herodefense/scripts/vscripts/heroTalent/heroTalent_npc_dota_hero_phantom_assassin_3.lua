heroTalent_npc_dota_hero_phantom_assassin_3 = heroTalent_npc_dota_hero_phantom_assassin_3 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_3", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff", "heroTalent/heroTalent_npc_dota_hero_phantom_assassin_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_phantom_assassin_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_phantom_assassin_3"
end

function heroTalent_npc_dota_hero_phantom_assassin_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives_debuff.vpcf", context )
end


modifier_heroTalent_npc_dota_hero_phantom_assassin_3 =modifier_heroTalent_npc_dota_hero_phantom_assassin_3 or class({})

function modifier_heroTalent_npc_dota_hero_phantom_assassin_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_phantom_assassin_3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_heroTalent_npc_dota_hero_phantom_assassin_3:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	local chance = 7
	-- if caster:GetSecondsPerAttack(false)<=0.1 then
	-- 	chance = 3
	-- end
	if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 5)
		caster:EmitSound("Hero_PhantomAssassin.FanOfKnives.Cast")

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local units = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {

			attacker =caster,
			-- damage = caster:GetStrength()*4,
			damage_type = DAMAGE_TYPE_PURE,
			ability = ability, --Optional.
		}
		
		local damage_min = caster:GetAverageTrueAttackDamage(nil)*0.5
		local damage_max = caster:GetAverageTrueAttackDamage(nil)*5
	
		for i, enemy in ipairs(units) do
			damageTable.victim = enemy
			local damage = math.max(enemy:GetMaxHealth()*0.02,damage_min)
			damageTable.damage = math.min(damage,damage_max)
			ApplyDamage(damageTable)

			enemy:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff", {duration = 2})
			if i>=4 then
				break
			end	
			
		end

	end

	
end





modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff = modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff or class({})

function modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff:IsDebuff()				return true end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff:IsPurgable() 			return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff:GetEffectName() return "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives_debuff.vpcf" end
function modifier_heroTalent_npc_dota_hero_phantom_assassin_3_debuff:CheckState()
	local state = {

		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}

	return state
end