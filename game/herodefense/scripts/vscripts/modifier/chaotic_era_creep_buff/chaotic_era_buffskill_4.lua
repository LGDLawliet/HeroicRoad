chaotic_era_buffskill_4 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_4", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_4_buff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_4_debuff", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_4", LUA_MODIFIER_MOTION_NONE)
function chaotic_era_buffskill_4:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_4"
end

modifier_chaotic_era_buffskill_4 = advanced_modifier({})

function modifier_chaotic_era_buffskill_4:IsDebuff() return false end
function modifier_chaotic_era_buffskill_4:IsHidden() return false end
function modifier_chaotic_era_buffskill_4:IsPurgable() return false end

function modifier_chaotic_era_buffskill_4:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.heal = self.ability:GetSpecialValueFor("heal")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.max = self.ability:GetSpecialValueFor("max")
end

function modifier_chaotic_era_buffskill_4:ADDeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
	return funcs
end

function modifier_chaotic_era_buffskill_4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_4:OnDeath(keys)
	if IsServer() then
        local unit = keys.unit
		if unit ~= self.parent then return end

        local caster = self:GetCaster()
        caster:EmitSound("chaotic_mass_healing_word_cast")  
        local pos = caster:GetOrigin()+Vector(0,0,64)
        local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_mass_healing_word/cast_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( effect_cast1, 0, pos )
        ParticleManager:SetParticleControl( effect_cast1, 2, pos )
        ParticleManager:SetParticleControl( effect_cast1, 3, pos )
        DestroyParticleByDelay(effect_cast1,5)

		local units = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil,  self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
		   for i, ally in pairs(units) do
                if unit:PassivesDisabled() then
                    ally:AddNewModifier(unit, self.ability, "modifier_chaotic_era_buffskill_4_debuff", {duration = 5})
                end
				ally:AddNewModifier(unit, self.ability, "modifier_chaotic_era_buffskill_4_buff", {duration = self.duration, heal = self.heal})
				if i >= self.max then
					break
				end
		   end
	end
end
-- function modifier_chaotic_era_buffskill_4:OnTooltip(keys)
-- 	self._tooltip = (self._tooltip or 0) % 1 + 1
-- 	if self._tooltip == 1 then
--         if self.parent:PassivesDisabled() then
--             return 0
--         end
-- 		return  self:GetStackCount()
-- 	end
-- 	-- if self._tooltip == 2 then
--     --     if self:GetStackCount() <= 0 then
-- 	-- 	    return  self.break_incoming
--     --     end
--     --     return 0
-- 	-- end
-- end



modifier_chaotic_era_buffskill_4_buff = advanced_modifier({})

function modifier_chaotic_era_buffskill_4_buff:IsDebuff() return false end
function modifier_chaotic_era_buffskill_4_buff:IsHidden() return false end
function modifier_chaotic_era_buffskill_4_buff:IsPurgable() return true end
function modifier_chaotic_era_buffskill_4_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_era_buffskill_4_buff:GetEffectName() return "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_hero_heal.vpcf" end
function modifier_chaotic_era_buffskill_4_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    if IsServer() then
        self.heal = keys.heal
        self:SetStackCount(self.heal)
    end
end
function modifier_chaotic_era_buffskill_4_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_4_buff:AdvancedGetModifierConstantHealthRegenPercentage() 
    if self:GetParent():HasModifier("modifier_chaotic_era_buffskill_4_debuff") then return 0 end
    return self:GetStackCount()
end

modifier_chaotic_era_buffskill_4_debuff = advanced_modifier({})

function modifier_chaotic_era_buffskill_4_debuff:IsDebuff() return false end
function modifier_chaotic_era_buffskill_4_debuff:IsHidden() return true end
function modifier_chaotic_era_buffskill_4_debuff:IsPurgable() return false end
