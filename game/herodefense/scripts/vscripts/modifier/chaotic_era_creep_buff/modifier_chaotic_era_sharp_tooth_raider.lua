
modifier_chaotic_era_sharp_tooth_raider = advanced_modifier({})

function modifier_chaotic_era_sharp_tooth_raider:IsHidden()return false end
function modifier_chaotic_era_sharp_tooth_raider:IsDebuff()return false end
function modifier_chaotic_era_sharp_tooth_raider:IsPurgable()return false end
function modifier_chaotic_era_sharp_tooth_raider:IsPurgeException() 	return false end
function modifier_chaotic_era_sharp_tooth_raider:RemoveOnDeath() return true end
function modifier_chaotic_era_sharp_tooth_raider:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_sharp_tooth_raider:GetTexture() return self.texture end
-- function modifier_chaotic_era_sharp_tooth_raider:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", context )

-- end
function modifier_chaotic_era_sharp_tooth_raider:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus = GetChaticEraCreep_BuffSpecial(self,"value1")
    if IsServer() then

    end
end



function modifier_chaotic_era_sharp_tooth_raider:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,  --攻击忽略护甲


    }
end


function modifier_chaotic_era_sharp_tooth_raider:Advanced_GetModifierAttackArmor_Ignore(keys)
	return self.bonus
end



function modifier_chaotic_era_sharp_tooth_raider:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_sharp_tooth_raider:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus
	end
end

