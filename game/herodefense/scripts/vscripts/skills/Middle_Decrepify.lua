
Middle_Decrepify = class({})

LinkLuaModifier("modifier_Middle_Decrepify_ally", "skills/Middle_Decrepify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Decrepify_enemy", "skills/Middle_Decrepify", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Middle_Decrepify_enemy_stack", "skills/Middle_Decrepify", LUA_MODIFIER_MOTION_NONE)

function Middle_Decrepify:IsHiddenWhenStolen() 		return false end
function Middle_Decrepify:IsRefreshable() 			return true end
function Middle_Decrepify:IsStealable() 			return true end
function Middle_Decrepify:IsNetherWardStealable()	return true end

function Middle_Decrepify:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


	if IsEnemy(caster, target) then
		---------------------------------------------------
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 
		self:GetSpecialValueFor("radius"),
		 DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		 local bonus_armor_target = caster
		for _, unit in pairs(units) do
			if unit:GetPhysicalArmorValue(false) > bonus_armor_target:GetPhysicalArmorValue(false) then
				bonus_armor_target = unit
			end
		end
		--获取最高护甲的友军英雄
		local ent = bonus_armor_target:entindex()
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.5)
		local StatusResistance = target:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self, "modifier_Middle_Decrepify_enemy", {duration = self:GetSpecialValueFor("duration_basic")*StatusResistance,target = ent})
		------------------------------------------------------
	else 
		-- local ModifierStatusNegativeGain = caster:GetModifierDurationGainIndex(1)
		target:AddNewModifier(caster, self, "modifier_Middle_Decrepify_ally", {duration = self:GetSpecialValueFor("duration_basic")})
	end
	
	target:EmitSound("Hero_Pugna.Decrepify")
end

modifier_Middle_Decrepify_ally = class({})

function modifier_Middle_Decrepify_ally:IsDebuff()			return false end
function modifier_Middle_Decrepify_ally:IsHidden() 			return false end
function modifier_Middle_Decrepify_ally:IsPurgable() 			return true end
function modifier_Middle_Decrepify_ally:IsPurgeException() 	return true end
function modifier_Middle_Decrepify_ally:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_Middle_Decrepify_ally:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Decrepify_ally:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_ATTACK_IMMUNE] = true, } end
function modifier_Middle_Decrepify_ally:DeclareFunctions() return 
	{MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL} end
function modifier_Middle_Decrepify_ally:GetAbsoluteNoDamagePhysical() return 1 end

function modifier_Middle_Decrepify_ally:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end



function modifier_Middle_Decrepify_ally:OnIntervalThink()

	if self:GetParent():IsMagicImmune() then self:SafeDestroy()	end

end



modifier_Middle_Decrepify_enemy = class({})

function modifier_Middle_Decrepify_enemy:IsDebuff()			return true end
function modifier_Middle_Decrepify_enemy:IsHidden() 			return false end
function modifier_Middle_Decrepify_enemy:IsPurgable() 		return true end
function modifier_Middle_Decrepify_enemy:IsPurgeException() 	return true end
function modifier_Middle_Decrepify_enemy:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_Middle_Decrepify_enemy:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_Decrepify_enemy:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_ATTACK_IMMUNE] = true, } end
function modifier_Middle_Decrepify_enemy:DeclareFunctions() return
	 {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Middle_Decrepify_enemy:GetModifierMoveSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_Middle_Decrepify_enemy:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_Middle_Decrepify_enemy:GetModifierMagicalResistanceBonus() return (0 - self:GetAbility():GetSpecialValueFor("magic_resistance_reduce")) end


function modifier_Middle_Decrepify_enemy:OnCreated(kv)
	if IsServer() then
		self.target = EntIndexToHScript( kv.target )  
	
		self:StartIntervalThink(0.5)
	end
end



function modifier_Middle_Decrepify_enemy:OnIntervalThink()
	if IsServer() then
		
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.5)
		local StatusResistance = self:GetParent():GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_Middle_Decrepify_enemy_stack", {duration = self:GetAbility():GetSpecialValueFor("duration_bonus")*StatusResistance})
		if self:GetParent():IsMagicImmune() then self:SafeDestroy()	end
	end
end



modifier_Middle_Decrepify_enemy_stack = class({})

function modifier_Middle_Decrepify_enemy_stack:IsDebuff()			    return true end
function modifier_Middle_Decrepify_enemy_stack:IsHidden() 			return false end
function modifier_Middle_Decrepify_enemy_stack:IsPurgable() 		    return true end
function modifier_Middle_Decrepify_enemy_stack:IsPurgeException() 	return true end
function modifier_Middle_Decrepify_enemy_stack:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Middle_Decrepify_enemy_stack:GetModifierMagicalResistanceBonus() return (0 - self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_per_0.5s")*self:GetStackCount()) end
function modifier_Middle_Decrepify_enemy_stack:OnCreated(table)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Middle_Decrepify_enemy_stack:OnRefresh(table)
	if IsServer() then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_per_0.5s_max") then
			self:IncrementStackCount()
		end
	end
end


