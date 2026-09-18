
creeps_spell_Fist_of_anger = class({})

LinkLuaModifier("modifier_creeps_spell_Fist_of_anger_passive", "creeps_spell/creeps_spell_Fist_of_anger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_creeps_spell_Fist_of_anger_debuff", "creeps_spell/creeps_spell_Fist_of_anger", LUA_MODIFIER_MOTION_NONE )


function creeps_spell_Fist_of_anger:GetIntrinsicModifierName() return "modifier_creeps_spell_Fist_of_anger_passive" end

function creeps_spell_Fist_of_anger:Precache( context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )


end





modifier_creeps_spell_Fist_of_anger_passive = class({})

function modifier_creeps_spell_Fist_of_anger_passive:IsHidden() return true end
function modifier_creeps_spell_Fist_of_anger_passive:IsAura() return true end
function modifier_creeps_spell_Fist_of_anger_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Fist_of_anger_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Fist_of_anger_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Fist_of_anger_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临

	}
end



function modifier_creeps_spell_Fist_of_anger_passive:OnAttackLanded(keys)
	if IsServer() then
		local caster = self:GetCaster()
		if keys.attacker == caster then
			if caster:PassivesDisabled() then
				return
			end
			local ability = self:GetAbility()



			local target =keys.target
			local pos = target:GetAbsOrigin()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			local pos_1 = pos + vDir * 800
			local tTargets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 0, false)
			
			local damageTable = {

				attacker = caster,
				damage = keys.damage,
				damage_type = keys.damage_type,
				ability = ability, --Optional.
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  , --Optional.
			}
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
    		for i, hTarget in pairs(tTargets) do
				if hTarget~=target then
					damageTable.victim = hTarget
					ApplyDamage(damageTable)
				end


				local StatusResistance =  hTarget:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				hTarget:AddNewModifier(caster, ability, "modifier_creeps_spell_Fist_of_anger_debuff", {duration = 0.1*StatusResistance})
    		end
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  caster )
			ParticleManager:SetParticleControl( nFXIndex, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 300, 300, 300 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			caster:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")

		end
	end
end

modifier_creeps_spell_Fist_of_anger_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_Fist_of_anger_debuff:IsHidden()	return false end
function modifier_creeps_spell_Fist_of_anger_debuff:IsDebuff()	return true end
function modifier_creeps_spell_Fist_of_anger_debuff:IsStunDebuff()	return false end
function modifier_creeps_spell_Fist_of_anger_debuff:IsPurgable()	return true end
function modifier_creeps_spell_Fist_of_anger_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_creeps_spell_Fist_of_anger_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -100
end