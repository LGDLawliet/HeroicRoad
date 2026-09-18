creeps_spell_Jump = class({})


LinkLuaModifier("modifier_creeps_spell_Jump_debuff", "creeps_spell/creeps_spell_Jump", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Jump_buff", "creeps_spell/creeps_spell_Jump", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Jump_tower_form", "creeps_spell/creeps_spell_Jump", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Behavior
function creeps_spell_Jump:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT +DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end


function creeps_spell_Jump:GetCastRange( point, target )
	return 3000
end




--------------------------------------------------------------------------------
-- Ability Phase Start
-- function creeps_spell_Jump:OnAbilityPhaseStart()
	

-- 	return true
-- end
-- function creeps_spell_Jump:OnAbilityPhaseInterrupted()
-- 	self.interrupted = true
-- end
--------------------------------------------------------------------------------
-- Ability Start
function creeps_spell_Jump:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	local point = self:GetCursorPosition()


	-- load data
	local duration = 1.1
	local height = 100
	local distance = (point - caster:GetOrigin()):Length2D()



	local facing_direction = caster:GetAnglesAsVector().y
	local attacker_vector = (point - caster:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction )) --角度差
	local anima

	if angle_diff<=45 then --向前跳
		anima = 1520
	else
		if angle_diff>=135 then --向后条
			anima = 1521
		else  --判断左右
			local angle = attacker_direction-facing_direction
		
			if angle<135  then  --在左边
				if angle>0  then
					anima = 1522
				else
					if ( angle<0 and angle>-180) then
						anima = 1523
					else
						anima = 1522
					end
					
				end
				
			else   --在右边
				anima = 1523
			end
		end

	end
	caster:AddNewModifier(caster, self, "modifier_creeps_spell_Jump_tower_form", { duration = 10})
	caster:AddNewModifier(caster, self, "modifier_creeps_spell_Jump_buff", { duration = duration})
	-- add arc modifier
	local arc = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			target_x = point.x,
			target_y = point.y,
			distance = distance,
			duration = duration,
			height = height,
			fix_end = false,
			isForward = true,
			-- isRestricted = true,
		} -- kv
	)
	local pfx = ParticleManager:CreateParticle( "particles/new_effect/unit/brain_worm/jump_main.vpcf", PATTACH_WORLDORIGIN, nil )
	local pos =  caster:GetOrigin()
	pos.z = pos.z +128
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 1, Vector(3,0,0))
	ParticleManager:ReleaseParticleIndex( pfx )
	local damage = caster:GetDamageMax()*self:GetSpecialValueFor("damage")
	
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, enemy in pairs(enemies) do
        local damageTable = {
            victim 			= enemy,
            damage 			= damage,
            damage_type		= self:GetAbilityDamageType(),
            damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
            attacker 		= caster,
            ability 		= self
        }
		local StatusResistance =  enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain

		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_creeps_spell_Jump_debuff", -- modifier name
			{ duration = duration*StatusResistance } -- kv
		)
        ApplyDamage(damageTable)
    end
	arc:SetStackCount(anima)
	arc:SetEndCallback(function()
		-- if not self.interrupted then return end
		-- self.interrupted = nil
		EmitSoundOn( "Hero_Leshrac.Split_Earth.Tormented", caster )
		local pfx = ParticleManager:CreateParticle( "particles/new_effect/unit/brain_worm/jump_main.vpcf", PATTACH_WORLDORIGIN, nil )
		point.z = point.z+128
		ParticleManager:SetParticleControl(pfx, 0, point)
		ParticleManager:SetParticleControl(pfx, 10, Vector(3,0,0))
		ParticleManager:ReleaseParticleIndex( pfx )
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			local damageTable = {
				victim 			= enemy,
				damage 			= damage,
				damage_type		= self:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= caster,
				ability 		= self
			}
			local StatusResistance =  enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	
			enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_creeps_spell_Jump_debuff", -- modifier name
				{ duration = duration*StatusResistance } -- kv
			)
			ApplyDamage(damageTable)
		end
	end)
	
	-- Effects
	EmitSoundOn( "Hero_Leshrac.Split_Earth", caster )
	-- EmitSoundOn( "Hero_Techies.ProjectileImpact", caster )
end








modifier_creeps_spell_Jump_debuff = class({})


function modifier_creeps_spell_Jump_debuff:IsHidden()	return false end
function modifier_creeps_spell_Jump_debuff:IsDebuff()	return true end
function modifier_creeps_spell_Jump_debuff:IsStunDebuff()	return false end
function modifier_creeps_spell_Jump_debuff:IsPurgable()	return true end

function modifier_creeps_spell_Jump_debuff:OnCreated( kv )

	self.slow = -self:GetAbility():GetSpecialValueFor( "slow" )

	if not IsServer() then return end
end



function modifier_creeps_spell_Jump_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_creeps_spell_Jump_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end





modifier_creeps_spell_Jump_buff = advanced_modifier({})

function modifier_creeps_spell_Jump_buff:IsDebuff() return false end
function modifier_creeps_spell_Jump_buff:IsHidden() return true end
function modifier_creeps_spell_Jump_buff:IsPurgable() return false end

function modifier_creeps_spell_Jump_buff:Advanced_GetModifierIncomingDamage_Percentage()return -100 end

function modifier_creeps_spell_Jump_buff:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}

	return state
end


function modifier_creeps_spell_Jump_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
	return funcs
end


function modifier_creeps_spell_Jump_buff:Advanced_GetModifier_StatusResistance(keys)
	return 150
end



modifier_creeps_spell_Jump_tower_form = class({})

function modifier_creeps_spell_Jump_tower_form:IsDebuff() return false end
function modifier_creeps_spell_Jump_tower_form:IsHidden() return false end
function modifier_creeps_spell_Jump_tower_form:IsPurgable() return false end


function modifier_creeps_spell_Jump_tower_form:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}

	return state
end
function modifier_creeps_spell_Jump_tower_form:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end

function modifier_creeps_spell_Jump_tower_form:OnIntervalThink()
	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("creeps_spell_Acid_bomb")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 6000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
	for _, enemy in pairs(enemies) do
		if enemy:IsAlive() then
			local pos = enemy:GetAbsOrigin()
			pos.x = pos.x +RandomInt(-500, 500)
			pos.y = pos.y +RandomInt(-500, 500)
			print("打死你")
			ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = pos,
				AbilityIndex = ability:entindex(),
				Queue = false,
			})

			break
		end
	
	end



end




function modifier_creeps_spell_Jump_tower_form:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE,   

	}
end


function modifier_creeps_spell_Jump_tower_form:GetModifierTurnRate_Override()
	return 1
end
