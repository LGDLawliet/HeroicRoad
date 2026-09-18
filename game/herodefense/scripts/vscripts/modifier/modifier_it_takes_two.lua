
--------------------------------------------------------------------------------
modifier_it_takes_two = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_it_takes_two:IsHidden()return false end
function modifier_it_takes_two:IsDebuff()return false end
function modifier_it_takes_two:IsStunDebuff()return false end
function modifier_it_takes_two:IsPurgable()return false end
function modifier_it_takes_two:GetTexture() return "arc_warden_tempest_double" end
function modifier_it_takes_two:IsPurgeException() 	return false end
function modifier_it_takes_two:RemoveOnDeath() return false end

function modifier_it_takes_two:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		

	}
end



function modifier_it_takes_two:GetModifierBonusStats_Strength()	return 15 end
function modifier_it_takes_two:GetModifierBonusStats_Intellect()	return 15 end
function modifier_it_takes_two:GetModifierBonusStats_Agility()	return 15 end
function modifier_it_takes_two:Advanced_GetModifierSpellAmplifyBonus()   return 20 end
function modifier_it_takes_two:GetModifierMagicalResistanceBonus() return 15 end

function modifier_it_takes_two:OnCreated(keys)
	if IsServer() then

		self:StartIntervalThink(12)
	end
end


function modifier_it_takes_two:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	parent:Purge(false, true, false, false,true) --强驱散
end
function modifier_it_takes_two:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_it_takes_two:Advanced_GetModifierIncomingDamage_Percentage()
	if Game_State~=nil and Game_State:IsInChaoticEra() then
		return -15
	end
	return 0
end
function modifier_it_takes_two:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	if Game_State~=nil and Game_State:IsInChaoticEra() then
		return 15
	end
	return 0
end