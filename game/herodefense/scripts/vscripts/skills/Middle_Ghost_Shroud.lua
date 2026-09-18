
-------------------------------------------
--			GHOST SHROUD
-------------------------------------------

Middle_Ghost_Shroud = Middle_Ghost_Shroud or class({})
LinkLuaModifier("modifier_Middle_Ghost_Shroud_active", "skills/Middle_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Middle_Ghost_Shroud_aura_debuff", "skills/Middle_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Ghost_Shroud_aura", "skills/Middle_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Ghost_Shroud_debuff", "skills/Middle_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Ghost_Shroud_Despair_Aura_buff", "skills/Middle_Ghost_Shroud", LUA_MODIFIER_MOTION_NONE)


function Middle_Ghost_Shroud:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		-- Params
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("radius")
		local healing_amp_pct = self:GetSpecialValueFor("healing_amp_pct")
		local slow_pct = self:GetSpecialValueFor("slow_pct")

		caster:EmitSound("Hero_Necrolyte.SpiritForm.Cast")

		caster:StartGesture(ACT_DOTA_NECRO_GHOST_SHROUD)
		caster:AddNewModifier(caster, self, "modifier_Middle_Ghost_Shroud_active", { duration = duration })
		caster:AddNewModifier(caster, self, "modifier_Middle_Ghost_Shroud_aura", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
		caster:AddNewModifier(caster, self, "modifier_Middle_Ghost_Shroud_aura_debuff", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
	end
end

function Middle_Ghost_Shroud:GetAOERadius( location , target)
	return self:GetTalentSpecialValueFor("radius")
end

function Middle_Ghost_Shroud:IsHiddenWhenStolen()
	return false
end



modifier_Middle_Ghost_Shroud_aura = class({})

function modifier_Middle_Ghost_Shroud_aura:IsHidden() return true end
function modifier_Middle_Ghost_Shroud_aura:IsPurgable() return true end
function modifier_Middle_Ghost_Shroud_aura:IsPurgeException() return true end
function modifier_Middle_Ghost_Shroud_aura:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end

function modifier_Middle_Ghost_Shroud_aura:StatusEffectPriority()return MODIFIER_PRIORITY_ULTRA end
function modifier_Middle_Ghost_Shroud_aura:GetEffectAttachType()return PATTACH_POINT_FOLLOW end

---------------------------------------------
-- Ghost Shroud Active Modifier (Purgable) --
---------------------------------------------

modifier_Middle_Ghost_Shroud_active = advanced_modifier({})

function modifier_Middle_Ghost_Shroud_active:IsHidden() return false end
function modifier_Middle_Ghost_Shroud_active:IsPurgable() return true end
function modifier_Middle_Ghost_Shroud_active:IsPurgeException() return true end

function modifier_Middle_Ghost_Shroud_active:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_Middle_Ghost_Shroud_active:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_Middle_Ghost_Shroud_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		
	}
end

function modifier_Middle_Ghost_Shroud_active:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self:GetAbility():GetSpecialValueFor("magic_amp_pct") * (-1)
end

function modifier_Middle_Ghost_Shroud_active:GetAbsoluteNoDamagePhysical()
	if self:GetCaster() == self:GetParent() then return 1
	else return nil end
end

function modifier_Middle_Ghost_Shroud_active:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return self.healing_amp_pct
end

function modifier_Middle_Ghost_Shroud_active:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.healing_amp_pct
end

function modifier_Middle_Ghost_Shroud_active:CheckState()
	return
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		}
end

-- ，魔免时移除状态
function modifier_Middle_Ghost_Shroud_active:OnCreated()
	self.healing_amp_pct	= self:GetAbility():GetSpecialValueFor("healing_amp_pct")

	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())   
end

function modifier_Middle_Ghost_Shroud_active:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsMagicImmune() then self:SafeDestroy()	end
end


function modifier_Middle_Ghost_Shroud_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
	}
	return funcs
end


modifier_Middle_Ghost_Shroud_aura_debuff = modifier_Middle_Ghost_Shroud_aura_debuff or class({})

function modifier_Middle_Ghost_Shroud_aura_debuff:IsHidden() return true end
function modifier_Middle_Ghost_Shroud_aura_debuff:IsPurgable() return false end
function modifier_Middle_Ghost_Shroud_aura_debuff:IsAura() return true end

function modifier_Middle_Ghost_Shroud_aura_debuff:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
	end
end

function modifier_Middle_Ghost_Shroud_aura_debuff:GetAuraRadius()return self.radius end
function modifier_Middle_Ghost_Shroud_aura_debuff:GetAuraSearchFlags()return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Middle_Ghost_Shroud_aura_debuff:GetAuraSearchTeam()return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Middle_Ghost_Shroud_aura_debuff:GetAuraSearchType()return self:GetAbility():GetAbilityTargetType() end
function modifier_Middle_Ghost_Shroud_aura_debuff:GetModifierAura()return "modifier_Middle_Ghost_Shroud_debuff" end

-------------------------------------------------------
-- Ghost Shroud Negative Aura Debuff (Movement Slow) --
-------------------------------------------------------

modifier_Middle_Ghost_Shroud_debuff = modifier_Middle_Ghost_Shroud_debuff or class({})

function modifier_Middle_Ghost_Shroud_debuff:IsHidden() return false end
function modifier_Middle_Ghost_Shroud_debuff:IsDebuff() return true end

function modifier_Middle_Ghost_Shroud_debuff:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff.vpcf"
end

function modifier_Middle_Ghost_Shroud_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_Middle_Ghost_Shroud_debuff:GetModifierMoveSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
	end
end

function modifier_Middle_Ghost_Shroud_debuff:OnCreated(table)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
	
end

function modifier_Middle_Ghost_Shroud_debuff:OnIntervalThink()
	
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if parent:GetBaseDamageMax()<=caster:GetIntellect(false)*2 then
		self:Retreat(caster)
		parent:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Ghost_Shroud_Despair_Aura_buff", { duration = 1})
	end
	if parent:GetHealth()<=caster:GetIntellect(false)*6 then
		parent:EmitSound("Hero_DeathProphet.Death")
		TrueKill(caster, parent, self:GetAbility())
	end
end


function modifier_Middle_Ghost_Shroud_debuff:Retreat(unit)
	local thisEntity = self:GetParent()
	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()

	-- if away from enemy is an unpathable area, find a new direction to run to
	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 3 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( thisEntity:GetIdealSpeed() )
		nAttempts = nAttempts + 1
	end

	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos
	})

end





modifier_Middle_Ghost_Shroud_Despair_Aura_buff = class({})

function modifier_Middle_Ghost_Shroud_Despair_Aura_buff:IsHidden() return false end
function modifier_Middle_Ghost_Shroud_Despair_Aura_buff:IsPurgable() return true end
function modifier_Middle_Ghost_Shroud_Despair_Aura_buff:CheckState()
	return {
		[MODIFIER_STATE_FEARED]=true,
	}
end

function modifier_Middle_Ghost_Shroud_Despair_Aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
	}
end

function modifier_Middle_Ghost_Shroud_Despair_Aura_buff:GetModifierMagicalResistanceDecrepifyUnique( params )
	return -30
end