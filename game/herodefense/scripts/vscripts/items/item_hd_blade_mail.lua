item_hd_blade_mail = class({})

LinkLuaModifier("modifier_item_hd_blade_mail", "items/item_hd_blade_mail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_blade_mail_active", "items/item_hd_blade_mail", LUA_MODIFIER_MOTION_NONE)

function item_hd_blade_mail:GetIntrinsicModifierName()
	return "modifier_item_hd_blade_mail"
end

function item_hd_blade_mail:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives.vpcf", context )
end


-------------------------------------------------------------
modifier_item_hd_blade_mail = advanced_modifier({})

function modifier_item_hd_blade_mail:IsDebuff() return false end
function modifier_item_hd_blade_mail:IsHidden() return true end
function modifier_item_hd_blade_mail:IsPurgable() return false end
function modifier_item_hd_blade_mail:GetTexture()return "item_blade_mail" end
function modifier_item_hd_blade_mail:GetEffectName() return "particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail.vpcf" end
function modifier_item_hd_blade_mail:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_blade_mail:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end

function modifier_item_hd_blade_mail:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
    }
end
function modifier_item_hd_blade_mail:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_item_hd_blade_mail:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if not self:GetAbility():IsCooldownReady() then
			return
		end
		self:GetAbility():UseResources(true, true, true, true)
		if unit~=self:GetParent() then	return end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

		--unit:EmitSound("Hero_PhantomAssassin.FanOfKnives.Cast")
		unit:EmitSoundParams("DOTA_Item.BladeMail.Activate",0,0.4,0)
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
		ParticleManager:SetParticleControl( effect_cast, 0, unit:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local units = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local damageTable = {
			attacker = unit,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
		}
		for _, enemy in pairs(units) do
			damageTable.victim = enemy
			local damage = self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("hp_damage")*0.01 * (unit:GetPhysicalArmorValue(false)*self:GetAbility():GetSpecialValueFor("armor_tsf")*0.01 +1)
			damageTable.damage = damage
			ApplyDamage(damageTable)	
		end
    end 
end
