heroTalent_npc_dota_hero_nyx_assassin_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_nyx_assassin_2", "heroTalent/heroTalent_npc_dota_hero_nyx_assassin_2", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_nyx_assassin_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_nyx_assassin_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_nyx_assassin_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_nyx_assassin_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_nyx_assassin_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_nyx_assassin_2" end


modifier_heroTalent_npc_dota_hero_nyx_assassin_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        -- self:GetParent():SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH )
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3) 
        self:GetParent():EmitSound("Hero_NyxAssassin.SpikedCarapace")
        self:StartIntervalThink(0.2)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

        
    end
end
function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:OnIntervalThink()

    -- self:GetParent():NotifyWearablesOfModelChange(true)
    -- self:GetParent():ManageModelChanges()
    local hero = self:GetParent()
    if hero:PassivesDisabled() then
        if self.nFXIndex then
            ParticleManager:DestroyParticle(self.nFXIndex,false)
            ParticleManager:ReleaseParticleIndex(self.nFXIndex)
            self.nFXIndex = nil
        end
    else
        if not self.nFXIndex then
            self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
            self:AddParticle( self.nFXIndex, false, false, -1, true, false )
            self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3) 
            self:GetParent():EmitSound("Hero_NyxAssassin.SpikedCarapace")
        end
    end
end

function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        
	}
end

-- function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:GetModifierBonusStats_Strength(keys)
-- 	local parent = self:GetParent()
--    if parent:HasModifier("modifier_heroTalent_npc_dota_hero_enigma_effect") then
-- 	   return (parent:GetLevel()+2)*1.5
--    end
--    return parent:GetLevel()*1.5
-- end

function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:OnTakeDamage(keys)
if IsServer() then   
    local attacker = keys.attacker
    local unit = keys.unit

    if unit~=self:GetParent() then	return end
    if attacker:GetTeam()==unit:GetTeam() then
        return
    end
    if keys.damage<=20 then return	end
    if attacker:IsMagicImmune() then
        return
    end
    if unit:PassivesDisabled() then
        return
    end

    if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

    if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

    if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


    local damage = keys.damage *0.3
    damage = math.min(unit:GetHealth()*0.3,damage)

    local damageTable = {
                        victim = attacker,
                        attacker = unit,
                        damage = damage,
                        damage_type = keys.damage_type,
                        damage_flags = DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT
                        +DOTA_DAMAGE_FLAG_REFLECTION
                        +DOTA_DAMAGE_FLAG_HPLOSS
                        +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
                        +DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
                        ability = self:GetAbility(), --Optional.
                        }
    local applydamage = ApplyDamage(damageTable)
    


end 
end


function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PRIMARY_ATTRIBUTE_OVERRIDE_STR,
        advanced_MODIFIER_PROPERTY_BONUS_STR_PER_LEVEL
    }
end

function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:Advanced_GetModifier_PrimaryAttributeOverride_Str()
    return 1
end


function modifier_heroTalent_npc_dota_hero_nyx_assassin_2:Advanced_GetModifierBonusSTR_PerLevel()
    return 1.5
end

