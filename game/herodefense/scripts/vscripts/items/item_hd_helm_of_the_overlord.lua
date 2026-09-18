item_hd_helm_of_the_overlord = class({})

LinkLuaModifier("modifier_item_hd_helm_of_the_overlord", "items/item_hd_helm_of_the_overlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helm_of_the_overlord_active", "items/item_hd_helm_of_the_overlord", LUA_MODIFIER_MOTION_NONE)


function item_hd_helm_of_the_overlord:GetIntrinsicModifierName()
	return "modifier_item_hd_helm_of_the_overlord"
end



function item_hd_helm_of_the_overlord:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_soul_assumption_bolt1.vpcf", context )

end





modifier_item_hd_helm_of_the_overlord = advanced_modifier({})

function modifier_item_hd_helm_of_the_overlord:IsDebuff() return false end
function modifier_item_hd_helm_of_the_overlord:IsHidden() return true end
function modifier_item_hd_helm_of_the_overlord:IsPurgable() return false end
function modifier_item_hd_helm_of_the_overlord:IsPurgeException() return false end
function modifier_item_hd_helm_of_the_overlord:RemoveOnDeath() return false end


function modifier_item_hd_helm_of_the_overlord:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()

	self.bonus_attribute =ability:GetSpecialValueFor("bonus_attribute")
	self.bonus = ability:GetSpecialValueFor("summon_intensity")



end




function modifier_item_hd_helm_of_the_overlord:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力

	}
end


function modifier_item_hd_helm_of_the_overlord:GetModifierBonusStats_Strength()	return self.bonus_attribute end
function modifier_item_hd_helm_of_the_overlord:GetModifierBonusStats_Agility()	return self.bonus_attribute end
function modifier_item_hd_helm_of_the_overlord:GetModifierBonusStats_Intellect()	return self.bonus_attribute end
function modifier_item_hd_helm_of_the_overlord:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_helm_of_the_overlord_active", {})

	end
end

-- advanced_modifier
function modifier_item_hd_helm_of_the_overlord:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_helm_of_the_overlord:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus 
end






modifier_item_hd_helm_of_the_overlord_active = class({})

function modifier_item_hd_helm_of_the_overlord_active:IsDebuff() return false end
function modifier_item_hd_helm_of_the_overlord_active:IsHidden() return true end
function modifier_item_hd_helm_of_the_overlord_active:IsPurgable() return false end
function modifier_item_hd_helm_of_the_overlord_active:RemoveOnDeath() return false end
function modifier_item_hd_helm_of_the_overlord_active:GetTexture() return "item_helm_of_the_overlord" end



function modifier_item_hd_helm_of_the_overlord_active:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	
		

	}
end


function modifier_item_hd_helm_of_the_overlord_active:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		local feast_aiblity = self:GetAbility()

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 then  
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		local gain = self:GetCaster():GetModifierLifeStealGain(1)
		local flLifesteal = flDamage *0.2*gain
		Attacker:Heal( flLifesteal, feast_aiblity )
	

	end

	return 0.0

end
