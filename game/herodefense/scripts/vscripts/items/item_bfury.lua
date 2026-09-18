
LinkLuaModifier("modifier_imba_bfury_passive", "items/item_bfury", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
item_bfury_level1 = class({})
function item_bfury_level1:GetIntrinsicModifierName() return "modifier_imba_bfury_passive" end
item_bfury_level3 = class({})
function item_bfury_level3:GetIntrinsicModifierName() return "modifier_imba_bfury_passive" end
item_bfury_level4 = class({})
function item_bfury_level4:GetIntrinsicModifierName() return "modifier_imba_bfury_passive" end
item_bfury_level2 = class({})
function item_bfury_level2:GetIntrinsicModifierName() return "modifier_imba_bfury_passive" end

function item_bfury_level4:Spawn()
	Timers:CreateTimer(0.3, function()
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_bfury_passive", { })
	end)
end


modifier_imba_bfury_passive = advanced_modifier({})

function modifier_imba_bfury_passive:IsDebuff()			return false end
function modifier_imba_bfury_passive:IsHidden() 		return true end
function modifier_imba_bfury_passive:IsPermanent() 		return true end
function modifier_imba_bfury_passive:IsPurgable() 		return false end
function modifier_imba_bfury_passive:IsPurgeException() return false end
function modifier_imba_bfury_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
-- function modifier_imba_bfury_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_bfury_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_bfury_passive:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_imba_bfury_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end
	if self:GetParent():IsDisableCleave() or self:GetParent():IsRangedAttacker() then
		return
	end
	-- print("do cleave")
	local cleave_pct = self:GetAbility():GetSpecialValueFor("cleave")
	local cleave_damage = keys.damage * (cleave_pct / 100)
	if self:GetParent():IsIllusion() then
		cleave_damage = 0
	end
	local target = keys.target
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	
	local i = 0
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = cleave_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
								hd_flags =  HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY,
								ability = nil, --Optional.
								}
			ApplyDamage(damageTable)
			i = i +1 
			if i>=self:GetAbility():GetSpecialValueFor("max") then
				break
			end
		end
	end
	-- local pos = self:GetCaster():GetAbsOrigin()
	-- local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_great_cleave_crit.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControl(pfx, 0, Vector(pos.x,pos.y,pos.y+100))
	-- -- local pfx = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf", PATTACH_ABSORIGIN, keys.target)
	-- -- ParticleManager:SetParticleControl(pfx, 0, keys.target:GetAbsOrigin())
	-- ParticleManager:ReleaseParticleIndex(pfx)
end

