item_hd_pheromone = class({})
-- LinkLuaModifier("modifier_item_hd_pheromone_arua", "items/item_hd_pheromone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pheromone_arua_effect", "items/item_hd_pheromone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_pheromone", "items/item_hd_pheromone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_pheromone_active", "items/item_hd_pheromone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pheromone_active_effect", "items/item_hd_pheromone", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_item_hd_pheromone_active_standby", "items/item_hd_pheromone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pheromone_active_debuff", "items/item_hd_pheromone", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_pheromone:GetIntrinsicModifierName()
	return "modifier_item_hd_pheromone"
end



-- function item_hd_pheromone:OnSpellStart()

-- 	local caster    =   self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	if target:TriggerSpellAbsorb(self) then	return 	end
-- 	target:EmitSound("Hero_Silencer.Curse")
-- 	-- self:StartCooldown(5)
-- 	-- local modifier = caster:FindAllModifiersByName("modifier_item_hd_pheromone_active")
-- 	-- if #modifier>0 then
-- 	-- 	modifier[1]:Destroy()
-- 	-- 	return
-- 	-- end

-- 	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_pheromone_active", {duration = 5})
-- end


-- modifier_item_hd_pheromone_arua = class({})

-- function modifier_item_hd_pheromone_arua:IsHidden() return true end
-- function modifier_item_hd_pheromone_arua:IsAura() return true end
-- function modifier_item_hd_pheromone_arua:GetAuraDuration() return 0.5 end
-- function modifier_item_hd_pheromone_arua:GetModifierAura() return "modifier_item_hd_pheromone_arua_effect" end
-- function modifier_item_hd_pheromone_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_item_hd_pheromone_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_item_hd_pheromone_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_item_hd_pheromone_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end



modifier_item_hd_pheromone = class({})

function modifier_item_hd_pheromone:IsDebuff() return false end
function modifier_item_hd_pheromone:IsHidden() return true end
function modifier_item_hd_pheromone:IsPurgable() return false end
-- function modifier_item_hd_pheromone:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_pheromone:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_pheromone:IsAura() return true end
function modifier_item_hd_pheromone:GetAuraDuration() return 0.5 end
function modifier_item_hd_pheromone:GetModifierAura() return "modifier_item_hd_pheromone_active" end
function modifier_item_hd_pheromone:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_item_hd_pheromone:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_pheromone:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_pheromone:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end





modifier_item_hd_pheromone_active = class({})

function modifier_item_hd_pheromone_active:IsDebuff() return false end
function modifier_item_hd_pheromone_active:IsHidden() return false end
function modifier_item_hd_pheromone_active:IsPurgable() return false end
function modifier_item_hd_pheromone_active:GetTexture()return "item_pheromone" end
function modifier_item_hd_pheromone_active:OnCreated(keys)
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("active_attack_speed")
	self.bonus_move =self:GetAbility():GetSpecialValueFor("active_move")
end



function modifier_item_hd_pheromone_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end


function modifier_item_hd_pheromone_active:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end
function modifier_item_hd_pheromone_active:GetModifierMoveSpeedBonus_Percentage()	return self.bonus_move end