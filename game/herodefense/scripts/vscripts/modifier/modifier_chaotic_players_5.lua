
modifier_chaotic_players_5 = advanced_modifier({})

function modifier_chaotic_players_5:IsHidden()return false end
function modifier_chaotic_players_5:IsDebuff()return false end
function modifier_chaotic_players_5:IsPurgable()return false end
function modifier_chaotic_players_5:GetTexture() return "roshan_bash" end
function modifier_chaotic_players_5:IsPurgeException() 	return false end
function modifier_chaotic_players_5:RemoveOnDeath() return false end

function modifier_chaotic_players_5:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},

    }
end
function modifier_chaotic_players_5:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		local attacker = tg.attacker
		local parent = self:GetParent()

		if attacker ~= parent then return end
        
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION  then return end
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then return end

		-- 受吸血增强影响
        local life_steal_gain = attacker:GetModifierLifeStealGain(1)
		local hp = tg.damage *0.01 *life_steal_gain
		if tg.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
			hp = hp*2
		end

		if hp <= 0 then return end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
        attacker:Heal(hp, nil)
    end 
end
function modifier_chaotic_players_5:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return 0
end
function modifier_chaotic_players_5:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
        unit:AddNewModifier(self:GetParent(), nil, "modifier_chaotic_players_5", {})
	end
end
