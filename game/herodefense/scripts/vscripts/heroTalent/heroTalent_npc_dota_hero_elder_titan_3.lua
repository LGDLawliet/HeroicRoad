heroTalent_npc_dota_hero_elder_titan_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_3", "heroTalent/heroTalent_npc_dota_hero_elder_titan_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_3_active", "heroTalent/heroTalent_npc_dota_hero_elder_titan_3", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_elder_titan_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_elder_titan_3"
end

function heroTalent_npc_dota_hero_elder_titan_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/elder_titan_3/active.vpcf", context )
end

function heroTalent_npc_dota_hero_elder_titan_3:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
            if self.already == nil then
			    caster:AddItemByName("item_hd_iron_part")
                self.already = 1
            end
		end)
	end
end

function heroTalent_npc_dota_hero_elder_titan_3:OnSpellStart()
    if not IsServer() then
        return
    end

    local item_0 = self:GetCaster():GetItemInSlot(0)
    if item_0 then
        if item_0:GetAbilityName() == "item_hd_wind_blaster_talent" or item_0:GetAbilityName() == "item_hd_the_trident_of_the_sunken_treasure_house_talent" or item_0:GetAbilityName() == "item_hd_infernal_menace_talent" or item_0:GetAbilityName() == "item_hd_flower_locket_talent" then
            return
        end

        if item_0:GetAbilityName() == "item_hd_wind_blaster" or item_0:GetAbilityName() == "item_hd_the_trident_of_the_sunken_treasure_house" or item_0:GetAbilityName() == "item_hd_infernal_menace" or item_0:GetAbilityName() == "item_hd_flower_locket" then
            local item_0_talent = item_0:GetAbilityName()
            UTIL_RemoveImmediate(item_0)
            self:GetCaster():AddItemByName(item_0_talent.."_talent")
        else
            UTIL_RemoveImmediate(item_0)
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_elder_titan_3_active", {duration = self:GetSpecialValueFor("duration")})
        end
    end

    self:GetCaster():EmitSound("DOTA_Item.HavocHammer.Cast")

    self:GetCaster():GameTimer(1.5, function()
        self:GetCaster():EmitSound("DOTA_Item.HavocHammer.Cast")
    end)
end
----------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_elder_titan_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_elder_titan_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_elder_titan_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_elder_titan_3:OnCreated()
    self.ability = self:GetAbility()
    self.each_armor = self.ability:GetSpecialValueFor("each_armor")
    self.each_magic_res = self.ability:GetSpecialValueFor("each_magic_res")
    if IsServer() then
        self:StartIntervalThink(2)
    end
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3:OnIntervalThink()
    self:SetStackCount(0)
    for i=0, 10 do
        local item = self:GetParent():GetItemInSlot(i)
        if item ~= nil then
            self:SetStackCount(self:GetStackCount()+1)
        end
    end
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3:GetModifierMagicalResistanceBonus()
    return self.each_magic_res * self:GetStackCount()
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3:Advanced_GetModifierPhysicalArmorBonus()
    return self.each_armor * self:GetStackCount()
end
----------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_elder_titan_3_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:GetEffectName() return "particles/rebuild/talent/elder_titan_3/active.vpcf" end

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:OnCreated()
    self.ability = self:GetAbility()

    self.incoming_down = self.ability:GetSpecialValueFor("incoming_down")
    self.bonus_incoming_down = self.ability:GetSpecialValueFor("bonus_incoming_down")
    self.model = self.ability:GetSpecialValueFor("model")
    self.bonus_model = self.ability:GetSpecialValueFor("bonus_model")
    self.level = self:GetParent():GetLevel()
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:OnRefresh()
    self.ability = self:GetAbility()

    self.incoming_down = self.ability:GetSpecialValueFor("incoming_down")
    self.bonus_incoming_down = self.ability:GetSpecialValueFor("bonus_incoming_down")
    self.model = self.ability:GetSpecialValueFor("model")
    self.bonus_model = self.ability:GetSpecialValueFor("bonus_model")
    self.level = self:GetParent():GetLevel()
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:GetModifierModelScale()
    return (self.model + (self.level*self.bonus_model))
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:Advanced_GetModifierIncomingDamage_Percentage()
    return -(self.incoming_down + (self.level*self.bonus_incoming_down))
end

function modifier_heroTalent_npc_dota_hero_elder_titan_3_active:OnTooltip()
    return (self.incoming_down + (self.level*self.bonus_incoming_down))
end
