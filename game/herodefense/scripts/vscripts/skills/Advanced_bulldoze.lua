
Advanced_bulldoze = Advanced_bulldoze or class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_bulldoze", "skills/Advanced_bulldoze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_bulldoze_active", "skills/Advanced_bulldoze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_bulldoze_cooldown", "skills/Advanced_bulldoze", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_bulldoze_unlock2", "skills/Advanced_bulldoze", LUA_MODIFIER_MOTION_NONE )
function Advanced_bulldoze:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", context )


end
function Advanced_bulldoze:GetIntrinsicModifierName()
	return "modifier_Advanced_bulldoze"
end
function Advanced_bulldoze:OnAdvancedUpgrade()
	self:SetLevel(0)
	self:SetLevel(1)
end
function Advanced_bulldoze:GetCooldown(iLevel)
	if self:GetUnlock(3)==3 then
		return 4 
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end

function Advanced_bulldoze:CheckKV(key)
	local table = {
		movement_speed = 0.8,
		status_resistance = 0.8,
	}
	local value = table[key] or -1
	return value

end
function Advanced_bulldoze:UnlockFirstCore(key)
	return true
end
function Advanced_bulldoze:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_bulldoze_unlock2",{})
	return true
end
function Advanced_bulldoze:UnlockThirdCore(key)

	return true
end

function Advanced_bulldoze:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = 7
	if self.advanced_level>=5 then
		duration = 11
	end
	duration =  duration *caster:GetModifierDurationGainIndex(1)
	if self.unlock1 then
		duration = -1
	end
	if self.unlock3 then
		duration = 1.5
	end
	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_bulldoze_active", -- modifier name
		{ duration =duration} -- kv
	)
end

modifier_Advanced_bulldoze = modifier_Advanced_bulldoze or advanced_modifier({})
function modifier_Advanced_bulldoze:IsHidden()	return true end
function modifier_Advanced_bulldoze:IsDebuff()	return false end
function modifier_Advanced_bulldoze:IsPurgable()	return false end
function modifier_Advanced_bulldoze:IsPurgeException() return false end
function modifier_Advanced_bulldoze:RemoveOnDeath() return false end
function modifier_Advanced_bulldoze:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
end

function modifier_Advanced_bulldoze:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Advanced_bulldoze:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}

	return funcs
end

function modifier_Advanced_bulldoze:GetModifierMoveSpeedBonus_Percentage()
	return self:GetParent():PassivesDisabled() and 0 or self.movespeed
end
function modifier_Advanced_bulldoze:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_Advanced_bulldoze:Advanced_GetModifier_StatusResistance(keys)
	return self.resistance
end










modifier_Advanced_bulldoze_active = modifier_Advanced_bulldoze_active or advanced_modifier({})
function modifier_Advanced_bulldoze_active:IsHidden()	return false end
function modifier_Advanced_bulldoze_active:IsDebuff()	return false end
function modifier_Advanced_bulldoze_active:IsPurgable()	return true end
function modifier_Advanced_bulldoze_active:IsPurgeException() return true end
function modifier_Advanced_bulldoze_active:RemoveOnDeath() return true end
function modifier_Advanced_bulldoze_active:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor( "status_resistance" )
	if self:GetAbility():GetUnlock(1)==1 then
		self.unlock1 = true
	end
	if self:GetAbility().unlock3 then
		self.unlock3 = true
	end
	if not IsServer() then return end
	local sound_cast = "Hero_Spirit_Breaker.Bulldoze.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
	if self.unlock3 then
		self:GetAbility():SetActivated(false)
		self:GetAbility():EndCooldown()
	end

	self:StartIntervalThink(0.06)

	
end

function modifier_Advanced_bulldoze_active:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Advanced_bulldoze_active:OnIntervalThink()
	local parent = self:GetParent()

	if parent:IsMoving() then
		local pos = parent:GetOrigin()
		local ability = self:GetAbility()
		local uints = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 325, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if #uints<=0 then
			return
		end
		local knockbackProperties =
		{
			duration = 0.4,
			knockback_duration = 0.4,
			knockback_distance = 128,
			knockback_height = 128
		}
		local damage_index = 0.05
		if ability.advanced_level>=10 then
			damage_index = 0.08
		end
		local damage = parent:GetMaxHealth()*damage_index
		if ability.advanced_level>=20 then
			damage = parent:GetIdealSpeed()+damage
		end

		local damageTable = {
			-- victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability =ability, --Optional.
		}
		if ability.unlock1 then
			for _, unit in ipairs(uints) do
				if not unit:HasModifier("modifier_Advanced_bulldoze_cooldown") then
					local target_pos = pos - parent:GetForwardVector()*216
					local arc = unit:AddNewModifier(
						parent, -- player source
						ability, -- ability source
						"modifier_generic_arc_lua", -- modifier name
						{
							target_x = target_pos.x,
							target_y = target_pos.y,
							distance = CalculateDistance(target_pos,unit:GetOrigin()),
							duration = 0.3,
							height = 128,
							fix_end = false,
							isForward = true,
							-- isRestricted = true,
						} -- kv
					)

					

					-- local target_pos = unit:GetOrigin()
					-- local direction = (target_pos - pos):Normalized()
					-- target_pos = target_pos - direction*125

					-- knockbackProperties.center_x = target_pos.x
					-- knockbackProperties.center_y = target_pos.y
					-- knockbackProperties.center_z = target_pos.z
	
					-- unit:AddNewModifier( parent, nil, "modifier_knockback", knockbackProperties )
					unit:AddNewModifier( parent, ability, "modifier_Advanced_bulldoze_cooldown", {duration = 3} )
					unit:EmitSound("Hero_Magnataur.HornToss.Cast")
					damageTable.victim = unit
					ApplyDamage(damageTable)
					parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 5)
				end
			end
		else
			for _, unit in ipairs(uints) do
				if not unit:HasModifier("modifier_Advanced_bulldoze_cooldown") then
					local target_pos = unit:GetOrigin()
					local direction = (target_pos - pos):Normalized()
					target_pos = target_pos - direction*125
					knockbackProperties.center_x = target_pos.x
					knockbackProperties.center_y = target_pos.y
					knockbackProperties.center_z = target_pos.z
	
					unit:AddNewModifier( parent, nil, "modifier_knockback", knockbackProperties )
					unit:AddNewModifier( parent, ability, "modifier_Advanced_bulldoze_cooldown", {duration = 3} )
					unit:EmitSound("Hero_Pangolier.Gyroshell.Stun.Creep")
					damageTable.victim = unit
					ApplyDamage(damageTable)
				end
			end
		end

	end

end







function modifier_Advanced_bulldoze_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT)
		table.insert(funcs,MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT)
	end

	return funcs
end
function modifier_Advanced_bulldoze_active:OnDestroy()
	if IsServer() then
		if self.unlock3 then
			self:GetAbility():SetActivated(true)
			self:GetAbility():StartCooldown(4)
		end
	end
end
function modifier_Advanced_bulldoze_active:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_Advanced_bulldoze_active:GetModifierMoveSpeedBonus_Constant()
	if self.unlock1 then
		return 400
	end
	if self.unlock3 then
		return 4000
	end
	local duration = self:GetDuration()
	local remaining_duration = self:GetRemainingTime()
	local max_bonus = 700
	return math.max( max_bonus * math.sin(math.pi*remaining_duration/duration),0)
end

function modifier_Advanced_bulldoze_active:GetModifierIgnoreMovespeedLimit()             return   1  end

function modifier_Advanced_bulldoze_active:GetEffectName()	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf" end
function modifier_Advanced_bulldoze_active:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Advanced_bulldoze_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_Advanced_bulldoze_active:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end


modifier_Advanced_bulldoze_cooldown = modifier_Advanced_bulldoze_cooldown or class({})
function modifier_Advanced_bulldoze_cooldown:IsHidden()	return true end
function modifier_Advanced_bulldoze_cooldown:IsDebuff()	return false end
function modifier_Advanced_bulldoze_cooldown:IsPurgable()	return false end








modifier_Advanced_bulldoze_unlock2 = class({})

function modifier_Advanced_bulldoze_unlock2:IsHidden()	return true end
function modifier_Advanced_bulldoze_unlock2:IsDebuff()	return false end
function modifier_Advanced_bulldoze_unlock2:IsPurgable()	return false end
function modifier_Advanced_bulldoze_unlock2:IsPurgeException() return false end
function modifier_Advanced_bulldoze_unlock2:RemoveOnDeath() return false end
-- function modifier_Advanced_bulldoze_unlock2:GetEffectName() return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_debut_ambient_ground_arcs_pnt.vpcf" end
-- function modifier_Advanced_bulldoze_unlock2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_bulldoze_unlock2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	}

	return funcs
end

function modifier_Advanced_bulldoze_unlock2:GetModifierPreAttack_BonusDamagePostCrit(params) 
	return math.min(6000, self:GetParent():GetIdealSpeed()*0.5 )
end
