LinkLuaModifier( "modifier_item_set_storm_armor", "items/item_set_storm_armor.lua", LUA_MODIFIER_MOTION_NONE )


item_set_storm_armor = class({})

function item_set_storm_armor:GetIntrinsicModifierName()
    return "modifier_item_set_storm_armor"
end
function item_set_storm_armor:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", context )
end
function item_set_storm_armor:GetCastRange()
    return self:GetSpecialValueFor("radius")
end
---------------------------------------
modifier_item_set_storm_armor = advanced_modifier({})

function modifier_item_set_storm_armor:IsDebuff()return false end
function modifier_item_set_storm_armor:IsHidden()return true end
function modifier_item_set_storm_armor:IsPurgable()return false end
function modifier_item_set_storm_armor:RemoveOnDeath()return false end
function modifier_item_set_storm_armor:DestroyOnExpire()	return false end

function modifier_item_set_storm_armor:OnCreated(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.lightning_incoming = self:GetAbility():GetSpecialValueFor("lightning_incoming")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_item_set_storm_armor:OnIntervalThink()
    local random = math.random
    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY ,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies)do
        local modifier = enemy:FindModifierByName("modifier_item_set_storm_active")
        if modifier then
            if self.chance >= random(1,100) then
                local no_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY ,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
                for _,no_enemy in pairs(no_enemies)do
                    local modifier = no_enemy:FindModifierByName("modifier_item_set_storm_active")
                    if not modifier then
                        no_enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_set_storm_active",{duration = self.duration , stack = self.lightning_incoming})
                        local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", PATTACH_CUSTOMORIGIN, nil)
                        ParticleManager:SetParticleControlEnt(pfx, 0, no_enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
                        ParticleManager:SetParticleControlEnt(pfx, 1,no_enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
                        ParticleManager:SetParticleControlForward(pfx, 1, no_enemy:GetForwardVector())  --方向
                        ParticleManager:ReleaseParticleIndex(pfx)
                        no_enemy:EmitSound("Hero_Morphling.AdaptiveStrikeAgi.Target")
                        break
                    end
                end
            end
        end
    end
end

function modifier_item_set_storm_armor:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_set_storm_armor:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_set_storm_armor:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell_amp
end

