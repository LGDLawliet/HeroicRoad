
LinkLuaModifier("modifier_item_hd_argo_paw_buff", "items/item_hd_argo_paw.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_argo_paw_thinker", "items/item_hd_argo_paw.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_argo_paw_aura_debuff", "items/item_hd_argo_paw.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_argo_paw_aura_attack_debuff", "items/item_hd_argo_paw.lua", LUA_MODIFIER_MOTION_NONE)


require("internal/timers")
item_hd_argo_paw= advanced_modifier({})

function item_hd_argo_paw:GetIntrinsicModifierName() 
    return "modifier_item_hd_argo_paw_buff" 
end

function item_hd_argo_paw:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/argo_paw/effect.vpcf", context )
end

function item_hd_argo_paw:IsRefreshable() return false end

function item_hd_argo_paw:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self,iLevel) /(math.max(self:GetCaster():GetCooldownReduction(),0.001))
end

function item_hd_argo_paw:GetCustomCastErrorTarget()
	return "#DOTA_HUB_CANT_CAST_TO_TARGET"
end

function item_hd_argo_paw:CastFilterResultTarget(target)
	if IsServer() then
		return UF_SUCCESS
	end
end

function item_hd_argo_paw:OnSpellStart()
    local target = self:GetCaster():GetCursorCastTarget()
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
    DestroyParticleByDelay(particle,2)

    target:AddNewModifier(
        self:GetCaster(), -- player source
        self, -- ability source
        "modifier_item_hd_argo_paw_aura_debuff", -- modifier name
        { duration = self:GetSpecialValueFor("no_duration") } -- kv
    )
end
-----------------------------------------------------------------------------------

modifier_item_hd_argo_paw_buff=advanced_modifier({})

-- function modifier_item_hd_argo_paw_buff:IsPassive()			return true end
function modifier_item_hd_argo_paw_buff:IsDebuff() return false end
function modifier_item_hd_argo_paw_buff:IsHidden() 		return true end
function modifier_item_hd_argo_paw_buff:IsPurgable() 		return false end
function modifier_item_hd_argo_paw_buff:IsPurgeException() return false end
function modifier_item_hd_argo_paw_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_argo_paw_buff:DestroyOnExpire() return false end
function modifier_item_hd_argo_paw_buff:OnCreated()
    local ability = self:GetAbility()
	self.bonus_int = ability:GetSpecialValueFor("bonus_int")
    self.bonus_mana = ability:GetSpecialValueFor("bonus_mana")
    self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
end
function modifier_item_hd_argo_paw_buff:ADDeclareFunctions()
	return {
		advanced_MMODIFIER_PROPERTY_STATS_INTELLECT_BONUS,   
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
	}
end
function modifier_item_hd_argo_paw_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

function modifier_item_hd_argo_paw_buff:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_argo_paw_buff:AdvancedGetModifierManaBonus()	return self.bonus_mana end

function modifier_item_hd_argo_paw_buff:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end
function modifier_item_hd_argo_paw_buff:GetModifierProcAttack_BonusDamage_Magical( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end
		if not self:GetParent():IsRealHero() then
			return false
		end

		local stack = 0
		local modifier = target:FindModifierByNameAndCaster("modifier_item_hd_argo_paw_aura_attack_debuff", self:GetAbility():GetCaster())
        local bonus = self:GetAbility():GetSpecialValueFor("attack_mp")*0.01
		if modifier==nil then
			target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_hd_argo_paw_aura_attack_debuff",{})
		else
            stack = modifier:GetStackCount()
            for i = 1, stack, 1 do
                bonus = bonus *2
            end
            bonus = bonus / 2
            bonus = math.min(bonus,self:GetAbility():GetSpecialValueFor("attack_mp_max")*0.01)
            if bonus < self:GetAbility():GetSpecialValueFor("attack_mp_max")*0.01 then
                modifier:IncrementStackCount()
            end
			modifier:ForceRefresh()
		end
		local bonus_damage = self:GetCaster():GetMaxMana()*bonus
		return bonus_damage
	end
end








modifier_item_hd_argo_paw_aura_debuff = advanced_modifier({})
function modifier_item_hd_argo_paw_aura_debuff:IsHidden()	return true end
function modifier_item_hd_argo_paw_aura_debuff:IsDebuff()	return true end
function modifier_item_hd_argo_paw_aura_debuff:IsStunDebuff()	return true end
function modifier_item_hd_argo_paw_aura_debuff:IsPurgable()	return false end
function modifier_item_hd_argo_paw_aura_debuff:RemoveOnDeath()	return false end


function modifier_item_hd_argo_paw_aura_debuff:OnCreated( kv )
    if IsServer() then
        self:GetParent():AddNoDraw()
        self:PlayEffects()
    end

end


function modifier_item_hd_argo_paw_aura_debuff:OnDestroy()
	if not IsServer() then return end
	-- find enemies

	local effect_cast_damage = ParticleManager:CreateParticle( "particles/rebuild/spell/astral_imprisonment/astral_imprisonment_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast_damage, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast_damage, 1, Vector(100,0,0) )
	ParticleManager:ReleaseParticleIndex(effect_cast_damage)
	self:GetParent():RemoveNoDraw()
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	StopSoundOn( sound_loop, self:GetCaster() )
	local sound_cast = "Hero_ObsidianDestroyer.AstralImprisonment.End"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end


function modifier_item_hd_argo_paw_aura_debuff:CheckState()
	if not IsServer() then
		return
	end
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_hd_argo_paw_aura_debuff:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf"
	local sound_loop = "Hero_ObsidianDestroyer.AstralImprisonment"
	
	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end

-- function modifier_item_hd_argo_paw_aura_debuff:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
-- 	}
-- end
-- function modifier_item_hd_argo_paw_aura_debuff:GetModifierTotalDamageOutgoing_Percentage()	return -1000 end




function modifier_item_hd_argo_paw_aura_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_item_hd_argo_paw_aura_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return -1000 
end




modifier_item_hd_argo_paw_aura_attack_debuff = modifier_item_hd_argo_paw_aura_attack_debuff or class({})

function modifier_item_hd_argo_paw_aura_attack_debuff:IsHidden()	return false end
function modifier_item_hd_argo_paw_aura_attack_debuff:IsDebuff()	return true end
function modifier_item_hd_argo_paw_aura_attack_debuff:IsPurgable()	return false end
function modifier_item_hd_argo_paw_aura_attack_debuff:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_item_hd_argo_paw_aura_attack_debuff:GetEffectName()
	return "particles/rebuild/items/argo_paw/effect.vpcf"
end

function modifier_item_hd_argo_paw_aura_attack_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end