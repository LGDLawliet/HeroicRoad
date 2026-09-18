LinkLuaModifier( "modifier_chaotic_element_fire", "chaotic_spell/class_8/chaotic_element_fire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_element_fire_rune_1", "chaotic_spell/class_8/chaotic_element_fire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_element_fire_rune_3", "chaotic_spell/class_8/chaotic_element_fire.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_element_fire = class({})

function chaotic_element_fire:GetIntrinsicModifierName()
	return "modifier_chaotic_element_fire"
end
function chaotic_element_fire:OnProjectileHit_ExtraData(target, location, keys)
	if not IsServer() then return end
	if not target then
		return
	end
    local caster = self:GetCaster()
	if target:IsAlive() then
		target:Burning(caster, self, caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("rune_2_burning"))
	end
end
---------------------------------------------------------------------


modifier_chaotic_element_fire = advanced_modifier({})
function modifier_chaotic_element_fire:IsHidden() return self.type ~= 3 end
function modifier_chaotic_element_fire:IsPurgable() return false end
function modifier_chaotic_element_fire:OnCreated(params)
	self.outgoing_fire = self:GetAbility():GetSpecialValueFor("outgoing_fire")
	self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
	self.bonus_spell_amp_mult = self:GetAbility():GetSpecialValueFor("bonus_spell_amp_mult")

	self.type = self:GetAbility():GetRuneType()
	self.rune_1_duration = self:GetAbility():GetSpecialValueFor("rune_1_duration")
	self.rune_2_radius = self:GetAbility():GetSpecialValueFor("rune_2_radius")
	self.rune_2_num = self:GetAbility():GetSpecialValueFor("rune_2_num")
	self.rune_2_burning = self:GetAbility():GetSpecialValueFor("rune_2_burning")
	self.rune_2_damage = self:GetAbility():GetSpecialValueFor("rune_2_damage")
	self.rune_3_line = self:GetAbility():GetSpecialValueFor("rune_3_line")*0.01
	self.rune_3_outgoing_grow = self:GetAbility():GetSpecialValueFor("rune_3_outgoing_grow")
	self.rune_3_interval = self:GetAbility():GetSpecialValueFor("rune_3_interval")

	if IsServer() and self.type == 2 then
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_element_fire:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,self.rune_2_radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

   	for i, unit in ipairs(enemies) do
	   	if unit:IsAlive() then
			local info = 
			{
				Target =unit,
				Source = self:GetParent(),
				Ability = self:GetAbility(),	
				EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf",
				iMoveSpeed = 1500,
				-- caster:GetProjectileSpeed()
				vSourceLoc = self:GetParent():GetAbsOrigin(),
				bDrawsOnMinimap = false,  --？？
				bDodgeable = false,   --可躲闪
				bIsAttack = false,   --攻击效果
				bVisibleToEnemies = true,  --对敌人可视
				bReplaceExisting = false, --替换现有的
				flExpireTime = GameRules:GetGameTime() + 10, --存在时间
				bProvidesVision = false, --提供视野
				ExtraData = {}   --额外的数据
			}
		   ProjectileManager:CreateTrackingProjectile(info)
		   	if i >= self.rune_2_num then
				break
		   	end
		   
	   	end
   	end
end
function modifier_chaotic_element_fire:DeclareFunctions()
	local funcs = {
	}
	if self.type == 3 then
		table.insert(funcs,MODIFIER_PROPERTY_TOOLTIP)
	end
	return funcs
end
function modifier_chaotic_element_fire:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
	if self.type == 3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end
	return funcs
end

function modifier_chaotic_element_fire:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if not IsFireDamage(keys) then return end
	if self.type == 1 then
		local modifier = keys.target:FindModifierByName("modifier_chaotic_element_fire_rune_1")
		if modifier then
			modifier:ForceRefresh()
			modifier:SetDuration(self.rune_1_duration, true)
		else
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_chaotic_element_fire_rune_1", {duration = self.rune_1_duration})
		end
	end
	return self.outgoing_fire
end
function modifier_chaotic_element_fire:Advanced_GetModifierDamageOutgoing_Percentage()
	return self.bonus_attack
end
function modifier_chaotic_element_fire:Advanced_GetModifierSpellAmplifyBonusPercentageMUL()
	return self.bonus_spell_amp_mult
end

function modifier_chaotic_element_fire:OnTakeDamage(keys)
	if not IsServer() then return end
	if self.type ~= 3 then return end
	if keys.unit ~= self:GetParent() then return end
	if not IsEnemy(keys.unit,keys.attacker) then return end
	if keys.damage < keys.unit:GetMaxHealth()*self.rune_3_line then return end
	if keys.unit:HasModifier("modifier_chaotic_element_fire_rune_3") then return end

	self:SetStackCount(self:GetStackCount()+1)
	keys.unit:AddNewModifier(keys.unit,self:GetAbility(),"modifier_chaotic_element_fire_rune_3",{duration = self.rune_3_interval})
end

function modifier_chaotic_element_fire:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return self:GetStackCount()*self.rune_3_outgoing_grow
end
function modifier_chaotic_element_fire:OnTooltip()
	return self:GetStackCount()*self.rune_3_outgoing_grow
end
---------------------------------------------------------------------
modifier_chaotic_element_fire_rune_3 = advanced_modifier({})
function modifier_chaotic_element_fire_rune_3:IsHidden() return true end
function modifier_chaotic_element_fire_rune_3:IsPurgable() return false end
function modifier_chaotic_element_fire_rune_3:IsDebuff() return false end
---------------------------------------------------------------------
modifier_chaotic_element_fire_rune_1 = advanced_modifier({})
function modifier_chaotic_element_fire_rune_1:IsHidden() return false end
function modifier_chaotic_element_fire_rune_1:IsPurgable() return false end
function modifier_chaotic_element_fire_rune_1:IsDebuff() return true end

function modifier_chaotic_element_fire_rune_1:OnCreated(params)
	if not self:GetAbility() then self:Destroy() return end
	self.rune_1_armor = self:GetAbility():GetSpecialValueFor("rune_1_armor")
	self.rune_1_magic_res = self:GetAbility():GetSpecialValueFor("rune_1_magic_res")
end
function modifier_chaotic_element_fire_rune_1:OnRefresh(params)
	if not self:GetAbility() then self:Destroy() return end
	self.rune_1_armor = self:GetAbility():GetSpecialValueFor("rune_1_armor")
	self.rune_1_magic_res = self:GetAbility():GetSpecialValueFor("rune_1_magic_res")
end
function modifier_chaotic_element_fire_rune_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_chaotic_element_fire_rune_1:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_chaotic_element_fire_rune_1:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
	return -self.rune_1_armor
end
function modifier_chaotic_element_fire_rune_1:GetModifierMagicalResistanceBonus()
	if not self:GetAbility() then self:Destroy() return end
	return -self.rune_1_armor
end