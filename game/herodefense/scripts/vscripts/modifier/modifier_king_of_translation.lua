
--------------------------------------------------------------------------------
modifier_king_of_translation = advanced_modifier({})
-- require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_king_of_translation:IsHidden()return false end
function modifier_king_of_translation:IsDebuff()return false end
function modifier_king_of_translation:IsStunDebuff()return false end
function modifier_king_of_translation:IsPurgable()return false end
function modifier_king_of_translation:GetTexture() return "tiny/ti9_immortal/tiny_grow_prestige" end
function modifier_king_of_translation:IsPurgeException() 	return false end
function modifier_king_of_translation:RemoveOnDeath() return false end

function modifier_king_of_translation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,

	}
end

function modifier_king_of_translation:GetModifierBonusStats_Strength()	return 20+self:GetStackCount() end
function modifier_king_of_translation:GetModifierBonusStats_Intellect()	return 20+self:GetStackCount() end
function modifier_king_of_translation:GetModifierBonusStats_Agility()	return 20+self:GetStackCount() end
function modifier_king_of_translation:Advanced_GetModifierSpellAmplifyBonus()   
	if IsClient() then
		return 20+self:GetStackCount() 
	end
	local index = 20+self:GetStackCount() 
	if 20>=RandomInt(1, 100) then
		index = index + 100
	end
	return index
end
function modifier_king_of_translation:GetModifierMagicalResistanceBonus() return 25 end
function modifier_king_of_translation:GetModifierMoveSpeedBonus_Constant() return 50 end
function modifier_king_of_translation:GetModifierMoveSpeedBonus_Percentage() return 10 end
function modifier_king_of_translation:GetModifierCastRangeBonusStacking() return 400 end
function modifier_king_of_translation:AdvancedGetModifierConstantHealthRegen() return 30+self:GetStackCount() end
function modifier_king_of_translation:AdvancedGetModifierConstantManaRegen() return 10+self:GetStackCount()*0.5 end
function modifier_king_of_translation:GetModifierHealthBonus() return 1300 end

function modifier_king_of_translation:Advanced_GetModifierPhysicalArmorBonus()
    return 10
end



function modifier_king_of_translation:OnCreated(keys)
	self.bonus_cooldown = 20

end



function modifier_king_of_translation:OnIntervalThink()
	self:SetStackCount(_G.GAME_ROUND)
	self:StartIntervalThink(-1)
end


function modifier_king_of_translation:OnWaveStart()
	self:StartIntervalThink(5)
end



function modifier_king_of_translation:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Target == nil then
			return 0
		end
		if  Attacker == self:GetParent()  then
			if Attacker:GetHealthPercent()>=100 then
				return
			end
	
			if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
				return 0
			end
			if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
				return 0
			end
	
			if Ability then
				if 30>=RandomInt(1, 100) then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
	
			else
				if 30>=RandomInt(1, 100) then
					local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
			local flLifesteal = flDamage * 0.1
			Attacker:Heal( flLifesteal, nil )
		end

	

	end

	return 0.0

end



function modifier_king_of_translation:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
		advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_Wave_Start = {},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,

    }
end
function modifier_king_of_translation:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end

function modifier_king_of_translation:Advanced_GetModifierCastRangeBonusStacking(keys)
	return 400
end

