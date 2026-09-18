creeps_spell_dracarys = class({})
LinkLuaModifier( "modifier_creeps_spell_dracarys", "creeps_spell/creeps_spell_dracarys", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_dracarys_damage_count", "creeps_spell/creeps_spell_dracarys", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_dracarys_triger", "creeps_spell/creeps_spell_dracarys", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_dracarys_debuff", "creeps_spell/creeps_spell_dracarys", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_dracarys_debuff2", "creeps_spell/creeps_spell_dracarys", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imgeneric_knockback_lua", "modifier/modifier_imgeneric_knockback_lua", LUA_MODIFIER_MOTION_BOTH )


require('internal/timers')
-----------------------------------------------------------------------
function creeps_spell_dracarys:Spawn()
	self.cast_count = 0
end
function creeps_spell_dracarys:IncrementCast()
	self.cast_count = self.cast_count +1
end
function creeps_spell_dracarys:GetIntrinsicModifierName() return "modifier_creeps_spell_dracarys_damage_count" end
--------------------------------------------------------------------------------

function creeps_spell_dracarys:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Winter_Wyvern.ArcticBurn.Cast", self:GetCaster() )

		-- local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		-- ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		-- ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_creeps_spell_dracarys_triger", {duration = 0.5} )
	end
end










modifier_creeps_spell_dracarys_damage_count = class({})
function modifier_creeps_spell_dracarys_damage_count:IsHidden() return false end
function modifier_creeps_spell_dracarys_damage_count:IsDebuff() return false end
function modifier_creeps_spell_dracarys_damage_count:IsPurgable() 		return false end
function modifier_creeps_spell_dracarys_damage_count:IsPurgeException() 	return false end
function modifier_creeps_spell_dracarys_damage_count:RemoveOnDeath()  return false end
function modifier_creeps_spell_dracarys_damage_count:IsStunDebuff() return false end
function modifier_creeps_spell_dracarys_damage_count:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_dracarys_damage_count:DeclareFunctions() return
    {MODIFIER_EVENT_ON_TAKEDAMAGE} end


function modifier_creeps_spell_dracarys_damage_count:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
    --self.off 是判定是否进入了第二状态，如果进入了则以下效果均取消，不再触发电场
    if  self.off~=nil then
        return
    end

	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
    local ability = self:GetAbility()
    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
    --判断累计伤害是否达到触发线
    if self:GetStackCount() > caster:GetMaxHealth()*ability:GetSpecialValueFor("health")*0.01 then
        caster:AddNewModifier(caster, ability, "modifier_creeps_spell_dracarys_triger", {duration= 0.5})
		EmitGlobalSound("custom_Slyrak_fire_dragon_flee")  
        self:SetStackCount(0)
    end
end




modifier_creeps_spell_dracarys_triger = class({})
function modifier_creeps_spell_dracarys_triger:IsHidden() return false end
function modifier_creeps_spell_dracarys_triger:IsDebuff() return false end
function modifier_creeps_spell_dracarys_triger:IsPurgable() return false end
function modifier_creeps_spell_dracarys_triger:IsPurgeException() return false end
function modifier_creeps_spell_dracarys_triger:IsStunDebuff() return false end
function modifier_creeps_spell_dracarys_triger:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_dracarys_triger:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_SILENCED]   = true,
		[MODIFIER_STATE_INVULNERABLE]   = true,
    }
    return state
end
function modifier_creeps_spell_dracarys_triger:DeclareFunctions() return {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
} end
function modifier_creeps_spell_dracarys_triger:GetOverrideAnimation( params ) return ACT_DOTA_FLAIL end
function modifier_creeps_spell_dracarys_triger:GetOverrideAnimationRate( params ) return 0.5 end

function modifier_creeps_spell_dracarys_triger:OnCreated(table)
    if IsServer() then
		self.next_step = 0
		self:StartIntervalThink(FrameTime())
        local particle_cast = "particles/rebuild/spell/fire_dragon_fly/before_fly.vpcf"
        local caster = self:GetCaster()
		local ability = self:GetAbility()
		ability:IncrementCast()
        caster:EmitSound("Hero_Sven.WarCry.Shield")
		local damageTable = {

			attacker = caster,
			damage = ability:GetSpecialValueFor("damage_index2")*caster:GetDamageMax(),
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}
	
		Timers:CreateTimer(0.3, function()
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleControl( effect_cast, 0,caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( effect_cast, 61,Vector(5,0,0))
			ParticleManager:ReleaseParticleIndex(effect_cast)
			-- caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_dracarys", {duration= 10})
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius2"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local duration = ability:GetSpecialValueFor("duration")
			for _, enemy in ipairs(units) do
				local enemy_direction = (enemy:GetOrigin() - caster:GetAbsOrigin()):Normalized()
				enemy:AddNewModifier(
					caster, -- player source
					ability, -- ability source
					"modifier_imgeneric_knockback_lua", -- modifier name
					{
						duration = 0.3,
						distance = 500,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
					} -- kv
				)
				damageTable.victim = enemy
				
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				enemy:AddNewModifier( caster, ability, "modifier_creeps_spell_dracarys_debuff2", {duration = duration*StatusResistance} )

				ApplyDamage(damageTable)
			
					
				
			end
		end)

        -- ParticleManager:SetParticleControlEnt(
        --     effect_cast,
        --     3,
        --     caster,
        --     PATTACH_ABSORIGIN_FOLLOW,
        --     "attach_hitloc",
        --     Vector(0,0,0), -- unknown
        --     true -- unknown, true
        -- )
        -- ParticleManager:SetParticleControlForward( effect_cast, 3, caster:GetForwardVector() )
        -- self.effect_cast = effect_cast
    end
end


function modifier_creeps_spell_dracarys_triger:OnDestroy()
    if not IsServer() then
        return
    end
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_dracarys", {duration= 3})
    -- self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_Unstable_spell", {})
    -- ParticleManager:DestroyParticle( self.effect_cast, false )
    -- ParticleManager:ReleaseParticleIndex( self.effect_cast )
 
end

function modifier_creeps_spell_dracarys_triger:OnIntervalThink(table)
	self.next_step = self.next_step + 30
	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, -self.next_step , 0 ), Vector(0,1,0) )
	self:GetParent():SetForwardVector( self.facing )
end








modifier_creeps_spell_dracarys = advanced_modifier({})

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:IsPurgable()
	return false
end

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:OnCreated( kv )
	self.flight_speed = 300
	self.per_cast_speed = 75
	if IsServer() then
		self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_1 )
		local caster = self:GetCaster()
		local deltaTime = 0.02
		local pathLength = 700
		local ability = self:GetAbility()
		self.heroList = GetAllRealHeroes()
		-- self.heroList = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		self.current_target = self.heroList[RandomInt(1, #self.heroList)]
		for _, unit in ipairs(self.heroList) do
			if unit:IsAlive() then
				self.current_target = unit 	
				break
			end
		end
		randomTable(self.heroList,#self.heroList)
		

		self:StartIntervalThink(1)
		local modifier = self
		local radius = ability:GetSpecialValueFor("radius")
		local endcapSoundName = "Hero_Batrider.Firefly.loop"
		StartSoundEvent( endcapSoundName, caster )
		StartSoundEvent("Hero_Phoenix.SunRay.Cast", caster)
		local speed = self:GetAbility().cast_count*self.per_cast_speed+self.flight_speed
		Timers:CreateTimer(0.5, function()
			local pfx = ParticleManager:CreateParticle( "particles/rebuild/spell/fire_dragon_fly/fire/fire_rayray.vpcf", PATTACH_WORLDORIGIN, nil )
			local attach_point = caster:ScriptLookupAttachment( "attach_head" )
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point)+Vector(0,0,550))
			ParticleManager:SetParticleControl(pfx, 9, caster:GetAttachmentOrigin(attach_point)+Vector(0,0,550))
			local casterOrigin	= caster:GetAbsOrigin()
			local casterForward	= caster:GetForwardVector()
			local endcapPos = casterOrigin + casterForward * pathLength
			modifier.current_target_pos =endcapPos  --当前龙息目标位置
			-- endcapPos = GetGroundPosition(endcapPos,nil)+Vector(0,0,32)
			ParticleManager:SetParticleControl( pfx, 1, endcapPos )
			
			--设置一个计时器  改变龙息的目标点
			caster:SetContextThink( DoUniqueString( "updateSunRay" ), function ( )
	
				if GameRules:IsGamePaused() then
					return deltaTime
				end

	
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point)+Vector(0,0,550))
				ParticleManager:SetParticleControl(pfx, 9, caster:GetAttachmentOrigin(attach_point)+Vector(0,0,550))
				local casterOrigin	= caster:GetAbsOrigin()
				local casterForward	= caster:GetForwardVector()
				local end_pos = casterOrigin + casterForward * pathLength --新的目标位置
				local units = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				if #units>0 then --区域内有敌人时朝该敌人释放龙息
					end_pos = units[1]:GetAbsOrigin()
				end

				local current_poos = modifier.current_target_pos          --当前的目标位置
				local direction = (end_pos - current_poos):Normalized()   --求方向
				local end_pos = current_poos+ direction * (speed / (1.0 / FrameTime()))   --更新新位置
				modifier.current_target_pos  = end_pos



				ParticleManager:SetParticleControl( pfx, 1, end_pos )
				if not caster:HasModifier( "modifier_creeps_spell_dracarys" ) then
					ParticleManager:DestroyParticle( pfx, false )
					ParticleManager:ReleaseParticleIndex(pfx)
					StopSoundEvent( endcapSoundName, caster )
					caster:EmitSound("Hero_Phoenix.SunRay.Stop")
					return nil
				end
	
	
	
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), end_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for _,unit in pairs(enemies) do
					unit:AddNewModifier(caster, ability, "modifier_creeps_spell_dracarys_debuff", { duration = 0.2 } )
				end
	
	
	
				return deltaTime
	
				end, 0.0 )
	
		end)

	end
end

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		return self:GetAbility().cast_count*self.per_cast_speed+self.flight_speed
	end
	return self.flight_speed
end

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:GetModifierMoveSpeed_Max( params )
	if IsServer() then
		return self:GetAbility().cast_count*self.per_cast_speed+self.flight_speed
	end
	return self.flight_speed
end

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:GetVisualZDelta( params )
	return 550
end

--------------------------------------------------------------------------------

function modifier_creeps_spell_dracarys:GetActivityTranslationModifiers( params )
	return "injured"
end

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE,
	}
	return funcs
end

function modifier_creeps_spell_dracarys:GetModifierTurnRate_Override()
	return 0.05
end

-----------------------------------------------------------------------

function modifier_creeps_spell_dracarys:CheckState()
	local state = 
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end


function modifier_creeps_spell_dracarys:OnIntervalThink()
	if self.heroList then
		if 10>=RandomInt(1, 100) then
			for _, unit in ipairs(self.heroList) do
				if unit:IsAlive() then
					self.current_target = unit 	
					break
				end
			end
			randomTable(self.heroList,#self.heroList)
		end
		local target = self.current_target :GetAbsOrigin() + Vector(RandomInt(-500, 200),RandomInt(-500, 500),0)
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = target
		})
	end
end



-- advanced_modifier
function modifier_creeps_spell_dracarys:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying,
		-- advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_creeps_spell_dracarys:Advanced_GetModifier_Flying()	
	return 1
end


-- Advanced_GetModifier_FlyingPathing









modifier_creeps_spell_dracarys_debuff = modifier_creeps_spell_dracarys_debuff or class({})

function modifier_creeps_spell_dracarys_debuff:IsDebuff()				return false end
function modifier_creeps_spell_dracarys_debuff:IsHidden() 				return true end
function modifier_creeps_spell_dracarys_debuff:IsPurgable() 				return false end
function modifier_creeps_spell_dracarys_debuff:IsPurgeException() 		return false end
function modifier_creeps_spell_dracarys_debuff:IsStunDebuff() 			return false end
function modifier_creeps_spell_dracarys_debuff:RemoveOnDeath() 			return true end
function modifier_creeps_spell_dracarys_debuff:IgnoreTenacity() 			return true end

function modifier_creeps_spell_dracarys_debuff:OnCreated()
	if not IsServer() then
		return
	end
	self.damage = self:GetCaster():GetDamageMax()*self:GetAbility():GetSpecialValueFor("damage_index")
	self:StartIntervalThink( 0.1 )
end



function modifier_creeps_spell_dracarys_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end

	local ability = self:GetAbility()
	local caster = self:GetCaster()


	if not caster:HasModifier("modifier_creeps_spell_dracarys") then
		return
	end

	
	local enemy = self:GetParent()

	local total_damage = self.damage

	local damageTable = {
		victim = enemy,
		attacker = caster,
		damage = total_damage,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = ability, --Optional.
		}
	ApplyDamage(damageTable)





end











modifier_creeps_spell_dracarys_debuff2 = class({})

function modifier_creeps_spell_dracarys_debuff2:IsDebuff()			   return true end
function modifier_creeps_spell_dracarys_debuff2:IsHidden() 			return false end
function modifier_creeps_spell_dracarys_debuff2:IsPurgable() 		    return true end
function modifier_creeps_spell_dracarys_debuff2:IsPurgeException() 	return true end
function modifier_creeps_spell_dracarys_debuff2:DeclareFunctions()   return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_creeps_spell_dracarys_debuff2:GetModifierMoveSpeedBonus_Percentage() 
        return (0 - self:GetAbility():GetSpecialValueFor("move_slow"))
end