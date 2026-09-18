
modifier_chaotic_era_thirsty_furblog = advanced_modifier({})

function modifier_chaotic_era_thirsty_furblog:IsHidden()return false end
function modifier_chaotic_era_thirsty_furblog:IsDebuff()return false end
function modifier_chaotic_era_thirsty_furblog:IsPurgable()return false end
function modifier_chaotic_era_thirsty_furblog:IsPurgeException() 	return false end
function modifier_chaotic_era_thirsty_furblog:RemoveOnDeath() return true end
function modifier_chaotic_era_thirsty_furblog:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_thirsty_furblog:GetTexture() return self.texture end
-- function modifier_chaotic_era_thirsty_furblog:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", context )

-- end
function modifier_chaotic_era_thirsty_furblog:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus = GetChaticEraCreep_BuffSpecial(self,"value1")
    if IsServer() then

    end
end



function modifier_chaotic_era_thirsty_furblog:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,


    }
end

function modifier_chaotic_era_thirsty_furblog:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	self:IncrementStackCount()
end

function modifier_chaotic_era_thirsty_furblog:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	return math.min(self:GetStackCount()*self.bonus,1000)
end


function modifier_chaotic_era_thirsty_furblog:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_thirsty_furblog:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus
	end
end

