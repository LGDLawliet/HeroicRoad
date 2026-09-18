item_hd_stormcrafter = class({})
-- LinkLuaModifier("modifier_item_hd_stormcrafter_arua", "items/item_hd_stormcrafter", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_stormcrafter_arua_effect", "items/item_hd_stormcrafter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_stormcrafter", "items/item_hd_stormcrafter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_stormcrafter_active", "items/item_hd_stormcrafter", LUA_MODIFIER_MOTION_NONE)


function item_hd_stormcrafter:GetIntrinsicModifierName()
	return "modifier_item_hd_stormcrafter"
end

modifier_item_hd_stormcrafter = advanced_modifier({})

function modifier_item_hd_stormcrafter:IsDebuff() return false end
function modifier_item_hd_stormcrafter:IsHidden() return true end
function modifier_item_hd_stormcrafter:IsPurgable() return false end

function modifier_item_hd_stormcrafter:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana_regen = self.ability:GetSpecialValueFor("bonus_mana_regen")
	self.int_damage = self.ability:GetSpecialValueFor("int_damage")
    if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_item_hd_stormcrafter:OnIntervalThink()
	if IsServer() then
	   if self:GetAbility():IsCooldownReady() then
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

	   if #units>0 then
		    self:GetAbility():UseResources(true, true, true,true)
			local caster = self:GetCaster()
			caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
			local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(head_particle, 1, units[1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[1]:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(head_particle)

			ApplyDamage({
				victim 			= units[1],
				damage 			= caster:GetIntellect(false)*self.int_damage,
				damage_type		= self:GetAbility():GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			local ability_sp = self:GetCaster():FindAbilityByName("Primary_Thundergods_Wrath") or self:GetCaster():FindAbilityByName("Middle_Thundergods_Wrath") or self:GetCaster():FindAbilityByName("Advanced_Thundergods_Wrath")
			if ability_sp then
				if not ability_sp:IsCooldownReady() then
					local newCooldown = ability_sp:GetCooldownTimeRemaining() - self:GetAbility():GetSpecialValueFor("cd_reduce")
					ability_sp:EndCooldown()
					if newCooldown > 0 then
						ability_sp:StartCooldown(newCooldown)
					end
				end
			end
	   end	
	   end
		-- self:SetHasCustomTransmitterData(true)
	end
end

function modifier_item_hd_stormcrafter:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力	
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end
function modifier_item_hd_stormcrafter:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_stormcrafter:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regen end



------------------------------

modifier_item_hd_stormcrafter_active = advanced_modifier({})

function modifier_item_hd_stormcrafter_active:IsDebuff() return false end
function modifier_item_hd_stormcrafter_active:IsHidden() return false end
function modifier_item_hd_stormcrafter_active:IsPurgable() return false end

function modifier_item_hd_stormcrafter_active:OnCreated(keys)
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
    if IsServer() then
		self:StartIntervalThink(3)
	end
end

function modifier_item_hd_stormcrafter_active:OnIntervalThink()
	
	local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1500,--这个是雷神之怒自己的范围
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #units>0 then
		local ability_sp = self:GetCaster():FindAbilityByName("Primary_Thundergods_Wrath") or self:GetCaster():FindAbilityByName("Middle_Thundergods_Wrath") or self:GetCaster():FindAbilityByName("Advanced_Thundergods_Wrath")
		if ability_sp then
			ability_sp:OnSpellStart()
		end	
	end
end
