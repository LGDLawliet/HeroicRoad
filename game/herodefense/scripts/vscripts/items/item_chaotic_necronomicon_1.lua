item_chaotic_necronomicon_1 = class({})

LinkLuaModifier("modifier_item_chaotic_necronomicon_1", "items/item_chaotic_necronomicon_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_necronomicon_1_summon", "items/item_chaotic_necronomicon_1", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_necronomicon_1:GetIntrinsicModifierName()
    return "modifier_item_chaotic_necronomicon_1"
end
function item_chaotic_necronomicon_1:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/shadow_demon_2/effect.vpcf", context )
end
modifier_item_chaotic_necronomicon_1 = advanced_modifier({})

function modifier_item_chaotic_necronomicon_1:IsDebuff() return false end
function modifier_item_chaotic_necronomicon_1:IsHidden() return true end
function modifier_item_chaotic_necronomicon_1:IsPurgable() return false end

function modifier_item_chaotic_necronomicon_1:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")

    if IsServer() then
        self.check = true
		self:CheckIteam() 
    end
end

function modifier_item_chaotic_necronomicon_1:CheckIteam()
	local caster = self:GetParent()
	local item_1, item_2
	for i = 0, 8, 1 do
		local current_item = caster:GetItemInSlot(i)
		if current_item then
			local name = current_item:GetAbilityName()
			if name=="item_chaotic_necronomicon_1" then
				item_1 = current_item
			elseif name=="item_chaotic_necronomicon_2" then
				item_2 = current_item
			end
		end
	end

	if item_1 and item_2 then
		UTIL_RemoveImmediate(item_1)
		UTIL_RemoveImmediate(item_2)
		caster:AddItemByName("item_chaotic_necronomicon_3")
	end
end

function modifier_item_chaotic_necronomicon_1:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_necronomicon_1:Advanced_GetModifier_Summon_Intensity()
    return self.bonus_summon_intensity
end

function modifier_item_chaotic_necronomicon_1:AdvancedOnSummon(keys)
    if not IsServer() then return end
    if keys.unit ~= self.parent then return end
    if not IsValid(keys.target) then return end

    keys.target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_necronomicon_1_summon", {})
end

--------------------------------------------------------------------------------
-- 召唤物效果：受到伤害减少；死亡时以最大生命值一定比例爆炸（伤害由召唤者造成，并受80%召唤增强影响）
modifier_item_chaotic_necronomicon_1_summon = advanced_modifier({})

function modifier_item_chaotic_necronomicon_1_summon:IsDebuff() return false end
function modifier_item_chaotic_necronomicon_1_summon:IsHidden() return true end
function modifier_item_chaotic_necronomicon_1_summon:IsPurgable() return false end
function modifier_item_chaotic_necronomicon_1_summon:RemoveOnDeath() return false end

function modifier_item_chaotic_necronomicon_1_summon:OnCreated()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()

    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.damage_pct = self.ability:GetSpecialValueFor("damage")*0.01-- 以百分比描述

    if IsServer() then
        self.damagetable = {
            --victim = enemy,
            attacker = self.caster,
            --damage = final_damage,
            damage_type = self.ability:GetAbilityDamageType(),
            ability = self.ability,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
            hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
        }
    end
end

function modifier_item_chaotic_necronomicon_1_summon:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = { nil, self:GetParent() },
    }
end

function modifier_item_chaotic_necronomicon_1_summon:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return -self.incoming
end

function modifier_item_chaotic_necronomicon_1_summon:OnDeath(keys)
    if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    if keys.unit ~= self.parent then return end
    if not IsValid(self.caster) then return end

    local owner = self.caster
    local origin = self.parent:GetAbsOrigin()
    local team = owner:GetTeamNumber()

    local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/talent/shadow_demon_2/effect.vpcf", PATTACH_ABSORIGIN, self.parent)
    ParticleManager:SetParticleControl(particle_cast_fx, 0, origin)
    DestroyParticleByDelay(particle_cast_fx,3)
    self.parent:EmitSound("Hero_ShadowDemon.DemonicPurge.Damage")

    local intensity_gain = owner:GetSummonIntensityIndex(0.8)
    local base = self.parent:GetMaxHealth()*self.damage_pct
    local final_damage = base*intensity_gain

    local enemies = FindUnitsInRadius(
        team,
        origin,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in ipairs(enemies) do
        self.damagetable.victim = enemy
        self.damagetable.damage = final_damage
        ApplyDamage(self.damagetable)
    end
end


