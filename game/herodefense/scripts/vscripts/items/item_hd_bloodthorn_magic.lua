item_hd_bloodthorn_magic = class({})
-- LinkLuaModifier("modifier_item_hd_bloodthorn_magic_arua", "items/item_hd_bloodthorn_magic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bloodthorn_magic_arua_effect", "items/item_hd_bloodthorn_magic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bloodthorn_magic", "items/item_hd_bloodthorn_magic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bloodthorn_magic_active", "items/item_hd_bloodthorn_magic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bloodthorn_magic_active_standby", "items/item_hd_bloodthorn_magic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_bloodthorn_magic_active_debuff", "items/item_hd_bloodthorn_magic", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_item_hd_bloodthorn_magic_thinker", "items/item_hd_bloodthorn_magic", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_bloodthorn_magic:GetIntrinsicModifierName()
	return "modifier_item_hd_bloodthorn_magic"
end



function item_hd_bloodthorn_magic:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	EmitSoundOn("DOTA_Item.Orchid.Activate", caster)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local duration = 3*StatusResistance
	if duration>8 then	duration = 8	end
	if duration<3 then	duration = 3	end
	target:AddNewModifier(caster, self, "modifier_item_hd_bloodthorn_magic_active", {duration = duration})
	local pfx_name = "particles/new_effect/new_effect/new_hd_bloodthorn_magic_3.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(pfx, 1, target:GetForwardVector(), caster:GetRightVector(), caster:GetUpVector())
	ParticleManager:ReleaseParticleIndex(pfx)
	local damage = caster:GetMaxMana()*0.5
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})


    -- local hRemnant = CreateUnitByName("npc_dota_thinker", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
    -- hRemnant:ResistSpawneNeutral(false)
    -- hRemnant:AddNewModifier(target, self, "modifier_item_hd_bloodthorn_magic_thinker", { duration = 0.5 })
	-- hRemnant:AddNewModifier(caster, self, "modifier_phased", { duration = 4 })

end


-- modifier_item_hd_bloodthorn_magic_arua = class({})

-- function modifier_item_hd_bloodthorn_magic_arua:IsHidden() return true end
-- function modifier_item_hd_bloodthorn_magic_arua:IsAura() return true end
-- function modifier_item_hd_bloodthorn_magic_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_bloodthorn_magic_arua:GetModifierAura() return "modifier_item_hd_bloodthorn_magic_arua_effect" end
-- function modifier_item_hd_bloodthorn_magic_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_bloodthorn_magic_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_bloodthorn_magic_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_bloodthorn_magic_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_bloodthorn_magic = advanced_modifier({})

function modifier_item_hd_bloodthorn_magic:IsDebuff() return false end
function modifier_item_hd_bloodthorn_magic:IsHidden() return true end
function modifier_item_hd_bloodthorn_magic:IsPurgable() return false end
-- function modifier_item_hd_bloodthorn_magic:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_bloodthorn_magic:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_bloodthorn_magic:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
    -- self.caster = self:GetCaster()
    local parent = self:GetParent()
	-- self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	-- self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

	-- self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")
	-- self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	-- self.bonus_damage_per = self.ability:GetSpecialValueFor("bonus_damage_per")
	-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	-- self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_bloodthorn_magic_active_standby", {duration = 20})
	-- 	-- self:StartIntervalThink(0.5)
	-- 	-- self:SetStackCount(1)




	end
end



function modifier_item_hd_bloodthorn_magic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		MODIFIER_PROPERTY_HEALTH_BONUS,                   --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                     --魔法值
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
	}
end


function modifier_item_hd_bloodthorn_magic:GetModifierBonusStats_Intellect()	return self.bonus_int end

function modifier_item_hd_bloodthorn_magic:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_bloodthorn_magic:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_bloodthorn_magic:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end

function modifier_item_hd_bloodthorn_magic:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_bloodthorn_magic:GetModifierPreAttack_BonusDamage() return self.bonus_damage end


function modifier_item_hd_bloodthorn_magic:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end







modifier_item_hd_bloodthorn_magic_active = class({})

function modifier_item_hd_bloodthorn_magic_active:IsDebuff() return true end
function modifier_item_hd_bloodthorn_magic_active:IsHidden() return false end
function modifier_item_hd_bloodthorn_magic_active:IsPurgable() return false end
function modifier_item_hd_bloodthorn_magic_active:IsPurgeException() return false end
function modifier_item_hd_bloodthorn_magic_active:GetTexture()return "item_bloodthorn_magic" end
function modifier_item_hd_bloodthorn_magic_active:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_item_hd_bloodthorn_magic_active:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_hd_bloodthorn_magic_active:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true,

}
	return state
end


function modifier_item_hd_bloodthorn_magic_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,       --魔法抗性
	}
end


function modifier_item_hd_bloodthorn_magic_active:GetModifierMagicalResistanceBonus(keys)
	return -90
end


-- modifier_item_hd_bloodthorn_magic_active_standby = class({})

-- function modifier_item_hd_bloodthorn_magic_active_standby:IsDebuff() return false end
-- function modifier_item_hd_bloodthorn_magic_active_standby:IsHidden() return false end
-- function modifier_item_hd_bloodthorn_magic_active_standby:DestroyOnExpire()	return false end
-- function modifier_item_hd_bloodthorn_magic_active_standby:RemoveOnDeath()	return false end
-- function modifier_item_hd_bloodthorn_magic_active_standby:GetTexture()return "item_bloodthorn" end



-- if modifier_item_hd_bloodthorn_magic_thinker == nil then
--     modifier_item_hd_bloodthorn_magic_thinker = class({})
-- end
-- function modifier_item_hd_bloodthorn_magic_thinker:IsHidden()return false end
-- function modifier_item_hd_bloodthorn_magic_thinker:IsDebuff()return false end
-- function modifier_item_hd_bloodthorn_magic_thinker:IsPurgable()return false end
-- function modifier_item_hd_bloodthorn_magic_thinker:IsPurgeException()return false end

-- function modifier_item_hd_bloodthorn_magic_thinker:OnCreated(params)

--     if IsServer() then
--         local hParent = self:GetParent()
-- 		local hCaster = self:GetCaster()
-- 		-- self:GetParent():AddNoDraw()
--         hParent:SetOriginalModel(hCaster:GetModelName())
--         hParent:SetModelScale(hCaster:GetModelScale())
--         hParent:SetShouldDoFlyHeightVisual(false)
-- 		hParent:SetForwardVector(hCaster:GetForwardVector())
--         -- local vRBG = Vector(128, 128, 204)
--         -- hParent:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)

--         local hModel = hCaster:FirstMoveChild()
--         while hModel ~= nil do
--             if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
--                 local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hParent:GetAbsOrigin() })
--                 -- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
--                 hWearable:FollowEntity(hParent, true)
--             end
--             hModel = hModel:NextMovePeer()
--         end
--         hParent:StartGesture(ACT_DOTA_ATTACK)

