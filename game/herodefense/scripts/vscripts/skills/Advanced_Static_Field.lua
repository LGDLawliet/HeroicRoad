--特效优化 √
require('internal/timers')   --计时器功能
Advanced_Static_Field = class({})
LinkLuaModifier("modifier_Advanced_Static_Field", "skills/Advanced_Static_Field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Static_Field_debuff", "skills/Advanced_Static_Field.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Static_Field_bound_fields_thinker", "skills/Advanced_Static_Field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Static_Field_bound_fields_thinker_effect", "skills/Advanced_Static_Field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Static_Field_unlock3_debuff", "skills/Advanced_Static_Field.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
function Advanced_Static_Field:CheckKV(key)
	local table = {
        spell_damage=0.13,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Static_Field:UnlockFirstCore(key)
	return true
end
function Advanced_Static_Field:UnlockSecondCore(key)
	return true
end
function Advanced_Static_Field:UnlockThirdCore(key)
	return true
end



function Advanced_Static_Field:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/static_field/gauss.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", context )
	
    PrecacheResource( "particle", "particles/rebuild/spell/static_field/bound_fields/formation.vpcf", context )
end



function Advanced_Static_Field:GetIntrinsicModifierName() 
    return "modifier_Advanced_Static_Field" 
end
function Advanced_Static_Field:GetCastRange()
	return self:GetSpecialValueFor("radius")
end



function Advanced_Static_Field:OnProjectileHit_ExtraData(target, pos)
	if not target or (target and target:TriggerStandardTargetSpell(self)) then
		return
	end
	target:EmitSound("ContinuumDevice.Activate")

	local caster = self:GetCaster()

	local pfx_aoe = ParticleManager:CreateParticle("particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_aoe, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_aoe, 2, Vector(300, 300, 300))
	ParticleManager:ReleaseParticleIndex(pfx_aoe)
	local unit = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damagetable = {
		attacker = caster,
		ability = self,
		damage = caster:GetIntellect(false)*3,
		damage_type = self:GetAbilityDamageType(),
        hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	

	for i=1, #unit do
		local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, unit[i]:GetAttachmentOrigin(unit[i]:ScriptLookupAttachment("attach_hitloc")))
		ParticleManager:ReleaseParticleIndex(pfx)
        damagetable.victim = unit[i]
        ApplyDamage(damagetable)
        unit[i]:EmitSound("Hero_Zuus.StaticField")
	end

end

modifier_Advanced_Static_Field = advanced_modifier({})

function modifier_Advanced_Static_Field:IsPassive()	return true end
function modifier_Advanced_Static_Field:IsBuff()				    return true  end
function modifier_Advanced_Static_Field:IsPurgable() 			    return false  end
function modifier_Advanced_Static_Field:IsPurgeException() 	   return false  end
function modifier_Advanced_Static_Field:IsHidden()				    return false  end
function modifier_Advanced_Static_Field:OnCreated()  --学习了技能

    self:StartIntervalThink(0.5)
    self.SpellAmplify = 20
    if IsServer() then
        self.advanced_level = 1
        
			
	end
end

function modifier_Advanced_Static_Field:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

    if self.advanced_level>=5 then
        self.SpellAmplify = 35
    end
    if IsClient() then
        return
    end
    
    if not  ability:IsCooldownReady() or caster:IsIllusion() or caster:PassivesDisabled() or caster:IsSilenced() then
		return
	end
    if not caster:IsAlive() then
        return
    end

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
    caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY,
      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
   if enemies~=nil then
   
    for _,target in pairs(enemies) do


        if ability.unlock3 then
            local pos = target:GetAbsOrigin()
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
            pos, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            target:EmitSound("Hero_Zuus.LightningBolt")
            local pfx_aoe = ParticleManager:CreateParticle("particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(pfx_aoe, 0, pos)
            ParticleManager:SetParticleControl(pfx_aoe, 2, Vector(300, 300, 300))
            ParticleManager:ReleaseParticleIndex(pfx_aoe)
            local damageTable = {
                attacker =  caster,
                -- victim = target,
                damage = ability:GetSpecialValueFor("spell_damage2")*self:GetCaster():GetIntellect(false),
                damage_type = ability:GetAbilityDamageType(),
                ability = ability,
                hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
            }
            local startcool = true
            for _, unit in ipairs(enemies) do
                local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(pfx, 0, unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc")))
                ParticleManager:ReleaseParticleIndex(pfx)
                damageTable.victim = unit
                ApplyDamage(damageTable) 
                if not unit:IsAlive() then
                    startcool = false
                end
            end
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
            pos, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            EmitSoundOnLocationWithCaster( pos,  "Hero_Dark_Seer.Vacuum", caster )
            for _,enemy in pairs(enemies) do
                if enemy~=target and target:GetHDStatusResistanceIndex(1)<0.7 then
                    enemy:AddNewModifier(
                        caster, -- player source
                        ability, -- ability source
                        "modifier_Advanced_Static_Field_unlock3_debuff", -- modifier name
                        {
                            duration = 0.2,
                            x = pos.x,
                            y = pos.y,
                        } -- kv
                    )
                end
             
  
            end
            if startcool then
                if not (35>=RandomInt(1, 100)) then
                    ability:UseResources(true, true, true, true)
                end
            end
        else
            
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_WORLDORIGIN, caster)
            -- ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()+self:GetCaster():GetUpVector()*120)
            local pos = target:GetAbsOrigin()
            ParticleManager:SetParticleControl(particle, 0, Vector(pos.x,pos.y,pos.z+128))
            ParticleManager:ReleaseParticleIndex(particle)
            
            local damageTable = {
                attacker =  caster,
                victim = target,
                damage = ability:GetSpecialValueFor("spell_damage2")*self:GetCaster():GetIntellect(false),
                damage_type = ability:GetAbilityDamageType(),
                ability = ability,
                hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
            }
            ApplyDamage(damageTable) 
            if IsValid(target) and target:IsAlive() then
                --LV10解锁交流电+
                if self.advanced_level>=10 and 35>=RandomInt(1, 100) then
                    --do nothing
                else
                    ability:UseResources(true, true, true, true)
                end
               
            end
        end


        break
    end
   
end
end

function modifier_Advanced_Static_Field:OnAbilityExecuted(keys)  
    if IsServer() then
        if keys.ability:GetCooldown(keys.ability:GetLevel()) < 1  then
            return
        end
        local parent = self:GetParent()
        if parent:PassivesDisabled() then
            return
        end
        local ability = self:GetAbility()
        if keys.unit ~= parent then
            --lV15解锁感应电流
            --当不触发感应电流时返回
            if self.advanced_level>=15 and self:GetCaster():GetRandomEffect(35,INT_TYPE,1) >=RandomInt(1, 100) then
                if CalculateDistance(keys.unit, parent)<=1000 and not IsEnemy(keys.unit,parent) then
                    --do nothing
                else
                    return
                end
                
            else
                return
            end
            
        end
	    parent:EmitSound("Hero_Zuus.StaticField")
	    local radius = ability:GetSpecialValueFor("radius")
	    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        local damage =( ability:GetSpecialValueFor("spell_damage")) * self:GetCaster():GetIntellect(false)
        if keys.ability:GetCooldown(keys.ability:GetLevel()) < 3 and keys.ability:GetManaCost(keys.ability:GetLevel()) <= 50 then
            damage = damage *0.3
        end
        local number = ability:GetSpecialValueFor("effect_amount")
        local i = 0
        for _,target in pairs(enemies) do
		    if target ~= nil and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
                self:PlayEffect(self:GetParent(),target)
                local damage= {
                    victim = target,
                    attacker = parent,
                    damage = damage,
                    damage_type = ability:GetAbilityDamageType(),
                    damage_flags =DOTA_UNIT_TARGET_FLAG_NONE, 
                    ability = ability,
                    hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
                }
	    	    ApplyDamage(damage)
                --LV20解锁电离辐射
                if self.advanced_level>=20 and not target:IsNull() and target:IsAlive() then
                    target:AddNewModifier(parent, ability, "modifier_Advanced_Static_Field_debuff", {})
                end
                i = i + 1 
                if i>=number then
                    break
                end
            end
        end


        if ability.unlock1 then
            local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

            if #units>0 then
                local info = 
                {
                    -- Target = target,
                    -- Source = caster,
                    Ability = ability,	
                    EffectName = "particles/rebuild/spell/static_field/gauss.vpcf",
                    iMoveSpeed = 500,
                    -- iSourceAttach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
       
                    bDrawsOnMinimap = false,
                    bDodgeable = true,
                    bIsAttack = false,
                    bVisibleToEnemies = true,
                    bReplaceExisting = false,
                    flExpireTime = GameRules:GetGameTime() + 10,
                    bProvidesVision = false,
                    ExtraData = {},	
                }
               
                local pos = parent:GetAbsOrigin()
                local forward = parent:GetForwardVector()
                pos = pos - forward*200
                pos.z = pos.z +100
                for i = 1, 3, 1 do
                    info.Target = units[RandomInt(1, #units)]
                    info.vSourceLoc = Vector(pos.x+RandomInt(-50,50),pos.y+RandomInt(-50,50),pos.z+RandomInt(0,100))
                    ProjectileManager:CreateTrackingProjectile(info)
                end
            end

            
        elseif ability.unlock2 then
            if self.modifier and not self.modifier:IsNull() then
                self.modifier:SetDuration(self.modifier:GetRemainingTime()+1, true)
                
            else
                self.modifier = parent:AddNewModifier(parent, ability, "modifier_Advanced_Static_Field_bound_fields_thinker", {duration = 1.1})
                
            end
        end

    end
end

function modifier_Advanced_Static_Field:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end
function modifier_Advanced_Static_Field:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_Advanced_Static_Field:Advanced_GetModifierSpellAmplifyBonus()    return self.SpellAmplify end
function modifier_Advanced_Static_Field:PlayEffect(source,target)
    local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/static_field/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(head_particle, 0, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    DestroyParticleByDelay(head_particle,1)
    

end



modifier_Advanced_Static_Field_debuff = class({})

function modifier_Advanced_Static_Field_debuff:IsDebuff() return true end
function modifier_Advanced_Static_Field_debuff:IsHidden() return false end
function modifier_Advanced_Static_Field_debuff:IsPurgable() return false end

function modifier_Advanced_Static_Field_debuff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	

	}
end
function modifier_Advanced_Static_Field_debuff:GetModifierMagicalResistanceBonus()return -self:GetStackCount() end



function modifier_Advanced_Static_Field_debuff:OnCreated(keys)
    self.ability = self:GetAbility()
    if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Static_Field_debuff:OnRefresh(keys)
	if IsServer() then
		if self:GetStackCount()<30 then
            self:IncrementStackCount()
        end
	end
end




modifier_Advanced_Static_Field_bound_fields_thinker = class({})


function modifier_Advanced_Static_Field_bound_fields_thinker:IsHidden()	return false end
function modifier_Advanced_Static_Field_bound_fields_thinker:IsDebuff()	return false end
function modifier_Advanced_Static_Field_bound_fields_thinker:IsPurgable()	return false end
function modifier_Advanced_Static_Field_bound_fields_thinker:IsPurgeException()	return false end
function modifier_Advanced_Static_Field_bound_fields_thinker:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.radius = 700
    -- self.duration = self:GetRemainingTime()

    local particle_cast = "particles/rebuild/spell/static_field/bound_fields/formation.vpcf"
	self.nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( 99999, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( self.nFXIndex )
    self:AddParticle( self.nFXIndex, false, false, -1, true, false )

	
	self.sound_loop = "Hero_Disruptor.KineticField"
	EmitSoundOn( self.sound_loop, self:GetParent() )

    self:StartIntervalThink(1)

  
end
function modifier_Advanced_Static_Field_bound_fields_thinker:OnRefresh(keys)
    if IsClient() then
        return
    end

end

function modifier_Advanced_Static_Field_bound_fields_thinker:OnDestroy()
	if not IsServer() then return end
    StopSoundOn( self.sound_loop, self:GetParent() )
    local sound_end = "Hero_Disruptor.KineticField.End"
    EmitSoundOn( sound_end, self:GetParent() )
    
    ParticleManager:DestroyParticle(self.nFXIndex , true)
	ParticleManager:ReleaseParticleIndex( self.nFXIndex )
end

function modifier_Advanced_Static_Field_bound_fields_thinker:OnIntervalThink()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    parent:EmitSound("Hero_Zuus.StaticField")
    local radius = ability:GetSpecialValueFor("radius")
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    local damage =( ability:GetSpecialValueFor("spell_damage")) * self:GetCaster():GetIntellect(false)
    local number = ability:GetSpecialValueFor("effect_amount")
    local i = 0
    for _,target in pairs(enemies) do
        if target ~= nil and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
            local damage= {
                victim = target,
                attacker = parent,
                damage = damage,
                damage_type = ability:GetAbilityDamageType(),
                damage_flags =DOTA_UNIT_TARGET_FLAG_NONE, 
                ability = ability,
                hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
            }
            ApplyDamage(damage)
            target:AddNewModifier(parent, ability, "modifier_Advanced_Static_Field_debuff", {})
            i = i + 1 
            if i>=number then
                break
            end
        end
    end
end


function modifier_Advanced_Static_Field_bound_fields_thinker:IsAura()	return true end
function modifier_Advanced_Static_Field_bound_fields_thinker:GetModifierAura()	return "modifier_Advanced_Static_Field_bound_fields_thinker_effect" end
function modifier_Advanced_Static_Field_bound_fields_thinker:GetAuraRadius()	return self.radius end
function modifier_Advanced_Static_Field_bound_fields_thinker:GetAuraDuration()	return 0.3 end
function modifier_Advanced_Static_Field_bound_fields_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Static_Field_bound_fields_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Static_Field_bound_fields_thinker:GetAuraSearchFlags()	return 0 end




















modifier_Advanced_Static_Field_bound_fields_thinker_effect = class({})


function modifier_Advanced_Static_Field_bound_fields_thinker_effect:IsHidden()	return true end
function modifier_Advanced_Static_Field_bound_fields_thinker_effect:IsDebuff()	return true end
function modifier_Advanced_Static_Field_bound_fields_thinker_effect:IsPurgable()	return true end
function modifier_Advanced_Static_Field_bound_fields_thinker_effect:OnCreated( kv )
	if not IsServer() then return end
	-- references


    self.parent = self:GetParent()
    if self.parent:HasAbility("creep_special_gain_phase") then
        self.trigger = true
    end
    self.speed = self.parent:GetIdealSpeedNoSlows()


  
end

function modifier_Advanced_Static_Field_bound_fields_thinker_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_Advanced_Static_Field_bound_fields_thinker_effect:GetModifierMoveSpeed_Limit( params )
	if not IsServer() then return end
    local pos = self:GetCaster():GetAbsOrigin()
    local distance = 700
	local parent_vector = self.parent:GetOrigin()-pos
	-- local parent_direction = parent_vector:Normalized()

	local actual_distance = parent_vector:Length2D()
	-- local wall_distance = actual_distance-distance

    if actual_distance>distance then
        return 0
    end
    if self.trigger then
        return 0
    end

    local parent_vector2 =  self.parent:GetOrigin() +self.parent:GetForwardVector() -pos
    local actual_distance2 = parent_vector2:Length2D()

    if actual_distance2>actual_distance then
        return 0
    end
    if self.parent:GetHDStatusResistanceIndex(1)>=1 then
        return 0
    end
    return math.max(self.speed*actual_distance/1300,20)

	-- -- calculate facing angle
	-- local parent_angle = VectorToAngles(-parent_direction).y

	-- local unit_angle = self:GetParent():GetAnglesAsVector().y
	-- local wall_angle = math.abs( AngleDiff( parent_angle, unit_angle ) )

	-- -- calculate movespeed limit
	-- local limit = 0
	-- if wall_angle<=90 then
	-- 	-- facing and touching wall
	-- 	limit = (wall_distance/distance)*self.max_min + self.min_speed
	-- else
	-- 	limit = 0
	-- end

end















modifier_Advanced_Static_Field_unlock3_debuff = class({})


function modifier_Advanced_Static_Field_unlock3_debuff:IsHidden()	return false end
function modifier_Advanced_Static_Field_unlock3_debuff:IsDebuff()	return true end
function modifier_Advanced_Static_Field_unlock3_debuff:IsStunDebuff()	return true end
function modifier_Advanced_Static_Field_unlock3_debuff:IsPurgable()	return true end

function modifier_Advanced_Static_Field_unlock3_debuff:OnCreated( kv )

	if not IsServer() then return end
	local center = Vector( kv.x, kv.y, 0 )
	self.direction = center - self:GetParent():GetOrigin()
	self.speed = self.direction:Length2D()/self:GetDuration()
	self.direction.z = 0
	self.direction = self.direction:Normalized()
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

function modifier_Advanced_Static_Field_unlock3_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end


function modifier_Advanced_Static_Field_unlock3_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Static_Field_unlock3_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_Advanced_Static_Field_unlock3_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_Advanced_Static_Field_unlock3_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
function modifier_Advanced_Static_Field_unlock3_debuff:UpdateHorizontalMotion( me, dt )
	local target = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( target )
end
function modifier_Advanced_Static_Field_unlock3_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end