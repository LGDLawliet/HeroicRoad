
heroTalent_npc_dota_hero_beastmaster_2 = class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_beastmaster_2", "heroTalent/heroTalent_npc_dota_hero_beastmaster_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_beastmaster_2_melee", "heroTalent/heroTalent_npc_dota_hero_beastmaster_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_beastmaster_2_range", "heroTalent/heroTalent_npc_dota_hero_beastmaster_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive", "heroTalent/heroTalent_npc_dota_hero_beastmaster_2", LUA_MODIFIER_MOTION_NONE)
function heroTalent_npc_dota_hero_beastmaster_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_beastmaster_2" end

function heroTalent_npc_dota_hero_beastmaster_2:Precache( context )
	--PrecacheResource( "particle", "particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", context )
	--PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/talent/beastmaster_2/eagle_attackeffectspell_storm_beltpell_storm_bolt.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/summer_2021/summer_2021_emblem_effect_gem_trail_glow.vpcf", context )
end

function heroTalent_npc_dota_hero_beastmaster_2:OnSpellStart(keys)
	if IsServer() then
        local form = 1
        local modifier1 = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_beastmaster_2_range")
        if modifier1 then
            modifier1:Destroy()
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_beastmaster_2_melee", {})
        else
            self:GetCaster():RemoveModifierByName("modifier_heroTalent_npc_dota_hero_beastmaster_2_melee")
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_beastmaster_2_range", {})
        end
      

        -- if self:GetAutoCastState() then
        --     self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_beastmaster_2_range", {})
        --     self:GetCaster().Form_MODIFIER_NAME = "modifier_heroTalent_npc_dota_hero_beastmaster_2_range"
        -- else
        --     self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_beastmaster_2_melee", {})
        --     self:GetCaster().Form_MODIFIER_NAME = "modifier_heroTalent_npc_dota_hero_beastmaster_2_melee"
        -- end
	end
end
----------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_beastmaster_2_melee = modifier_heroTalent_npc_dota_hero_beastmaster_2_melee or  advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:GetTexture() return "beastmaster_call_of_the_wild_boar" end

function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:Advanced_GetModifierAttackRangeOverride() return  150 end

function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:OnCreated(keys)
	self.incoming_down = self:GetAbility():GetSpecialValueFor("incoming_down")
    self.maxhp_up = self:GetAbility():GetSpecialValueFor("maxhp_up")
    if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()  
		-- self.caster.IsRanger = false
		-- self.caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK )
    end
end

function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
    }
	return funcs
end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:Advanced_GetModifierIncomingDamage_Percentage()
    return -self.incoming_down
end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_melee:AdvancedGetModifierExtraHealthPercentage()
    return self.maxhp_up
end
--------------------------------------------------------------

modifier_heroTalent_npc_dota_hero_beastmaster_2_range = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:GetTexture()	return "beastmaster_call_of_the_wild_hawk" end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_EVENT_ON_DAY_STARTED,
		--MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	}
	return decFuncs	
end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:OnDayStarted()
    if not IsServer() then
        return
    end
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER , false)
    for _, unit in pairs(units) do
        unit:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive",{})
    end
end
--function heroTalent_npc_dota_hero_beastmaster_2_range:GetAttackSound()
--	return "Hero_Terrorblade_Morphed.Attack"
--end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:GetModifierProjectileSpeedBonus() return  1600 end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:GetModifierProjectileName()
    return "particles/rebuild/talent/beastmaster_2/eagle_attackeffectspell_storm_beltpell_storm_bolt.vpcf"
end



function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	
    self.attack_range = self.ability:GetSpecialValueFor("attack_range")
	self.bonus_vision = self.ability:GetSpecialValueFor("bonus_vision")
    if IsServer() then
		--如果单位不是远程单位 则改变为远程
		-- if self.caster.IsRanger==false then
		-- 	-- self.caster.RangerFrom = self.caster.RangerFrom +  1   --变更为远程形态的状态数加一
		-- 	-- self.caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		-- end
    end
end

function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:OnDestroy()
    if IsServer() then    	

		--如果单位不是远程单位 则改变为远程
		-- if self.caster.IsRanger==false then
		-- 	self.caster.RangerFrom = self.caster.RangerFrom -  1   --变更为远程形态的状态数减一
		-- 	--如果没有远程形态状态了变回近战
		-- 	if self.caster.RangerFrom==0 then
		-- 		self.caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		-- 	end	
		-- end

        local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER , false)
        for _, unit in pairs(units) do
            local modifier = unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive")
            if modifier then
                modifier:SafeDestroy()
            end
        end
    end
end

function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:Advanced_GetModifierAttackRangeBonus() return  self.attack_range end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:Advanced_GetBonusVisionPercentage()return self.bonus_vision end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:CheckState()
    return{
        [MODIFIER_STATE_FORCED_FLYING_VISION] =true,
    }
end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        advanced_MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
	
    }
end

---------------------------------------------------

modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:RemoveOnDeath() return false end
--function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:GetEffectAttachType() return "PATTACH_OVERHEAD_FOLLOW" end
--function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:GetEffectName() return "particles/econ/events/summer_2021/summer_2021_emblem_effect_gem_trail_glow.vpcf" end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:CheckState()
    return{
        [MODIFIER_STATE_PROVIDES_VISION] = true
    }
end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_beastmaster_2_range_passive:Advanced_GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end