chaotic_era_buffskill_2 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_2", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_2", LUA_MODIFIER_MOTION_NONE)

function chaotic_era_buffskill_2:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_2"
end

modifier_chaotic_era_buffskill_2 = advanced_modifier({})

function modifier_chaotic_era_buffskill_2:IsDebuff() return false end
function modifier_chaotic_era_buffskill_2:IsHidden() return false end
function modifier_chaotic_era_buffskill_2:IsPurgable() return false end
function modifier_chaotic_era_buffskill_2:GetEffectName() return "particles/basic_extend/status_effect_blur_creeps.vpcf" end
function modifier_chaotic_era_buffskill_2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_era_buffskill_2:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.evasion = self.ability:GetSpecialValueFor("evasion")
	self.evasion_plus = self.ability:GetSpecialValueFor("evasion_plus")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self:SetStackCount(self.evasion)
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end

function modifier_chaotic_era_buffskill_2:OnIntervalThink() 
    self:SetStackCount(self.evasion_plus)
    local heroes = GetAllRealHeroes()
    for _, hero in ipairs(heroes) do
        if hero:IsAlive() then
            local distance = CalculateDistance(hero, self.parent)
            if distance <= self.radius then
                self:SetStackCount(self.evasion)
                break
            end
        end
    end
end

function modifier_chaotic_era_buffskill_2:ADDeclareFunctions()
	local funcs = {
	}
	return funcs
end

function modifier_chaotic_era_buffskill_2:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_chaotic_era_buffskill_2:GetModifierEvasion_Constant() 
    if self.parent:PassivesDisabled() then
        return 0
    end
    return self:GetStackCount()
end



function modifier_chaotic_era_buffskill_2:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
        if self.parent:PassivesDisabled() then
            return 0
        end
		return  self:GetStackCount()
	end
	-- if self._tooltip == 2 then
    --     if self:GetStackCount() <= 0 then
	-- 	    return  self.break_incoming
    --     end
    --     return 0
	-- end
end



