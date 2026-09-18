
chaotic_time_stop = class({})
LinkLuaModifier("modifier_chaotic_time_stop_aura", "chaotic_spell/class_9/chaotic_time_stop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_time_stop_debuff", "chaotic_spell/class_9/chaotic_time_stop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_time_stop_debuff_override", "chaotic_spell/class_9/chaotic_time_stop", LUA_MODIFIER_MOTION_NONE)

function chaotic_time_stop:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_time_stop/effect_main/effect.vpcf", context )

end

function chaotic_time_stop:IsRefreshable()
	return false
end

function chaotic_time_stop:OnSpellStart()
	local caster = self:GetCaster()
	local sound_cast = "Hero_FacelessVoid.Chronosphere.MaceOfAeons"    
	EmitSoundOn(sound_cast, caster)    

	local duration = self:GetSpecialValueFor("duration")

    if self:GetRuneType() == 2 then
        caster:AddNewModifier(caster, self, "modifier_chaotic_time_stop_aura", {duration = duration})
        return
    end

    local mana = caster:GetMana()
    caster:Script_ReduceMana(mana, self)
    local bonus_duration = math.floor(mana/100)*self:GetSpecialValueFor("mana_to_duration")
    duration = (math.min((duration + bonus_duration),self:GetSpecialValueFor("duration_max")))
	local modifier = caster:AddNewModifier(caster, self, "modifier_chaotic_time_stop_aura", {duration = duration})
end



-----------------------------------------

modifier_chaotic_time_stop_aura = advanced_modifier({})
function modifier_chaotic_time_stop_aura:IsHidden() return false end
function modifier_chaotic_time_stop_aura:IsPurgable() return false end
function modifier_chaotic_time_stop_aura:IsDebuff() return false end
function modifier_chaotic_time_stop_aura:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()

		local pfx_name = "particles/rebuild/chaotic_spell/chaotic_time_stop/effect_main/effect.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(20000,5000,5000))
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end


function modifier_chaotic_time_stop_aura:IsAura() return self:GetAbility() and true end
function modifier_chaotic_time_stop_aura:GetAuraDuration() return 0.1 end
function modifier_chaotic_time_stop_aura:GetModifierAura() return "modifier_chaotic_time_stop_debuff" end
function modifier_chaotic_time_stop_aura:GetAuraRadius() return 99999 end
function modifier_chaotic_time_stop_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_chaotic_time_stop_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_time_stop_aura:GetAuraEntityReject(unit)
	local parent = self:GetParent()
	if parent==unit then
		return true
	end
	return false
end

function modifier_chaotic_time_stop_aura:GetAuraSearchTeam() 
    local team = DOTA_UNIT_TARGET_TEAM_BOTH
    if self:GetAbility():GetRuneType() == 1 then
        team =  DOTA_UNIT_TARGET_TEAM_ENEMY
    end
    return team 
end

-- function modifier_chaotic_time_stop_aura:ADDeclareFunctions()
-- 	local funcs =  {
-- 		MODIFIER_EVENT_ON_MODIFIER_APPLIED = {self:GetParent(),nil},
-- 		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
--     }
--     return funcs
-- end

--function modifier_chaotic_time_stop_aura:AdvancedOnModifierApplied(keys)
-- 	local parent = self:GetParent()
-- 	if keys.caster==parent then
-- 		if keys.target~=parent then
-- 			if keys.target:GetPlayerOwnerID()==parent:GetPlayerOwnerID() then
-- 				return
-- 			end
-- 			if self.modifier_chance>=RandomInt(1, 100) then
-- 				self:SafeDestroy()
-- 			else
-- 				self.modifier_chance = self.modifier_chance + math.max(self.modifier_chance_gain,1)
-- 			end
-- 		end
-- 	end
-- end

-------------------


modifier_chaotic_time_stop_debuff = advanced_modifier({})
function modifier_chaotic_time_stop_debuff:IsHidden() 			return true end
function modifier_chaotic_time_stop_debuff:IsPurgable() 			return false end
function modifier_chaotic_time_stop_debuff:IsPurgeException() 	return false end
function modifier_chaotic_time_stop_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_chaotic_time_stop_debuff:IsDebuff() return true end
function modifier_chaotic_time_stop_debuff:IsStunDebuff()	return true end
function modifier_chaotic_time_stop_debuff:IsMotionController() return true end
function modifier_chaotic_time_stop_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_chaotic_time_stop_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_chaotic_time_stop_debuff:StatusEffectPriority() return 16 end

function modifier_chaotic_time_stop_debuff:OnCreated(table)
    if not IsServer() then return end
    if self:GetAbility() then 
        if self:GetAbility():GetRuneType() == 2 and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then

            self:GetParent():Purge(false, true, false, true, true)  --强驱散
            local poison = self:GetParent():FindModifierByName("modifier_hd_poison")
            if poison then
               poison:Destroy() 
            end

            local dashu_debuff = self:GetParent():FindModifierByName("modifier_chaotic_era_poison_boom_debuff")
            if dashu_debuff then
                dashu_debuff:Destroy() 
            end

            local hua_debuff = self:GetParent():FindModifierByName("modifier_chaotic_era_hypnotic_pollen_debuff")
            if hua_debuff then
                hua_debuff:Destroy() 
            end

            local hunluan_debuff = self:GetParent():FindModifierByName("modifier_chaotic_era_chaotic_executive_debuff")
            if hunluan_debuff then
                hunluan_debuff:Destroy() 
            end
        end

        self:StartIntervalThink(0.1)
    end
end

function modifier_chaotic_time_stop_debuff:OnIntervalThink()
    if not self:GetAbility() then 
        self:Destroy() 
        return 
    end
    
    if self:GetAbility():GetRuneType() == 2 and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        self:GetParent():Purge(false, true, false, true, true)  --强驱散

        local poison = self:GetParent():FindModifierByName("modifier_hd_poison")
        if poison then
            poison:Destroy() 
        end

        local dashu_debuff = self:GetParent():FindModifierByName("modifier_chaotic_era_poison_boom_debuff")
        if dashu_debuff then
            dashu_debuff:Destroy() 
        end
    
        local hua_debuff = self:GetParent():FindModifierByName("modifier_chaotic_era_hypnotic_pollen_debuff")
        if hua_debuff then
            hua_debuff:Destroy() 
        end
    
        local hunluan_debuff = self:GetParent():FindModifierByName("modifier_chaotic_era_chaotic_executive_debuff")
        if hunluan_debuff then
            hunluan_debuff:Destroy() 
        end
    end

    if self:GetAbility():GetRuneType() == 3 and self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
        local line = self:GetAbility():GetSpecialValueFor("rune_3_line")
        if self:GetParent():GetHealthPercent() <= line then
            TrueKill(self:GetCaster(),self:GetParent(),self:GetAbility())
        end
    end
end

function modifier_chaotic_time_stop_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true, 
		[MODIFIER_STATE_INVISIBLE] = false, 
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

function modifier_chaotic_time_stop_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING,
    }
    return funcs
end

function modifier_chaotic_time_stop_debuff:GetDisableHealing()
    return 1
end

function modifier_chaotic_time_stop_debuff:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    return funcs
end

function modifier_chaotic_time_stop_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    if self:GetAbility() then 
        if self:GetAbility():GetRuneType() == 2 and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
            return -200
        end
        return self:GetAbility():GetSpecialValueFor("incoming")
    end
    return
end
function modifier_chaotic_time_stop_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if self:GetAbility() then 
        return -200
    end
    return
end

function modifier_chaotic_time_stop_debuff:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:IsAlive() then
			parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_DIE, 0, 0.9, 0.1)
            if self:GetAbility() then
                if self:GetAbility():GetRuneType() == 1 then
                    local mana = self:GetAbility():GetSpecialValueFor("rune_1_mp")*0.01*self:GetCaster():GetMaxMana()
                    self:GetCaster():GiveMana(mana)
                end
            end
		end
		
	end
end






