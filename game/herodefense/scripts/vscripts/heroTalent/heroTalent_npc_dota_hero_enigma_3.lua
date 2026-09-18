
heroTalent_npc_dota_hero_enigma_3 = class({})
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_enigma_3", "herotalent/heroTalent_npc_dota_hero_enigma_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_enigma_3_active", "herotalent/heroTalent_npc_dota_hero_enigma_3", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_enigma_3:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/talent/enigma_talent_3/active.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/talent/enigma_talent_3/active_effect.vpcf", context )
end

----------------------------------------------------------------------------------------------
function heroTalent_npc_dota_hero_enigma_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_enigma_3"
end

function heroTalent_npc_dota_hero_enigma_3:GetCastRange()
	return 1200
end


function heroTalent_npc_dota_hero_enigma_3:OnSpellStart()--释放
    -------清空层数--------------------------------------
	local caster = self:GetCaster()
    local radius = 1200
    local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_enigma_3")
	if modifier then
		local stack = modifier:GetStackCount()
		if stack >= 0 then
            local duration = self:GetSpecialValueFor("duration_stack")*stack
			
            caster:EmitSound("CNY_Beast.Black_Hole.Stop")

            self.particle = ParticleManager:CreateParticle("particles/rebuild/talent/enigma_talent_3/active.vpcf", PATTACH_ABSORIGIN, caster)
	        ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(self.particle, 2, caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(self.particle, 3, caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(self.particle, 7, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(self.particle, 8, caster:GetAbsOrigin())
	        ParticleManager:SetParticleControl(self.particle, 9, caster:GetAbsOrigin())

	        ParticleManager:ReleaseParticleIndex(self.particle)

	        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		    DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
            ) 
	        for _, unit in pairs(units) do
		        unit:AddNewModifier(unit, self, "modifier_heroTalent_npc_dota_hero_enigma_3_active", {duration = duration})
	        end

            modifier:SetStackCount(0)
        end
    end
end
---------------modifier：被动叠层--------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_enigma_3 = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_enigma_3:IsHidden() 	return false end
function modifier_heroTalent_npc_dota_hero_enigma_3:IsPurgable()  return false end
function modifier_heroTalent_npc_dota_hero_enigma_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_enigma_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_enigma_3:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_enigma_3:GetTexture() return "enigma_black_hole" end

function modifier_heroTalent_npc_dota_hero_enigma_3:OnCreated(keys)
	self:SetStackCount(0)
    self:StartIntervalThink(1)
    self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stack")
end


function modifier_heroTalent_npc_dota_hero_enigma_3:OnAbilityExecuted(keys)
    local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_enigma_3_active")
    if modifier then
        return
    end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) < 3 or keys.unit ~= self:GetParent() then--冷却时间需要大于3
        return 
    else
        self:SetStackCount(math.min(self.max_stacks, self:GetStackCount()+self:GetAbility():GetSpecialValueFor("stack_per_cast")))
    end
end

function modifier_heroTalent_npc_dota_hero_enigma_3:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED = {self:GetParent(),nil},
    }
end
------------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_enigma_3_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_enigma_3_active:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_enigma_3_active:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_enigma_3_active:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_enigma_3_active:OnCreated(keys)
    self.bonus_damage =  self:GetAbility():GetSpecialValueFor("dmg_up")
end



function modifier_heroTalent_npc_dota_hero_enigma_3_active:GetEffectName()
    return "particles/rebuild/talent/enigma_talent_3/active_effect.vpcf"
end
function modifier_heroTalent_npc_dota_hero_enigma_3_active:GetEffectAttachType()
    return PATTACH_CENTER_FOLLOW
end


function modifier_heroTalent_npc_dota_hero_enigma_3_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end


function modifier_heroTalent_npc_dota_hero_enigma_3_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.bonus_damage
end


function modifier_heroTalent_npc_dota_hero_enigma_3_active:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,  
	}
end


function modifier_heroTalent_npc_dota_hero_enigma_3_active:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	end
end

