chaotic_to_turn_defense_into_attack = class({})
LinkLuaModifier("modifier_chaotic_to_turn_defense_into_attack", "chaotic_spell/class_8/chaotic_to_turn_defense_into_attack", LUA_MODIFIER_MOTION_NONE)

function chaotic_to_turn_defense_into_attack:GetIntrinsicModifierName() return "modifier_chaotic_to_turn_defense_into_attack" end



function chaotic_to_turn_defense_into_attack:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_to_turn_defense_into_attack/eff/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash_headmodel.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_to_turn_defense_into_attack/eff/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf", context )
end



modifier_chaotic_to_turn_defense_into_attack = advanced_modifier({})

function modifier_chaotic_to_turn_defense_into_attack:IsDebuff()			return false end
function modifier_chaotic_to_turn_defense_into_attack:IsHidden() 		return false end
function modifier_chaotic_to_turn_defense_into_attack:IsPurgable() 		return false end
function modifier_chaotic_to_turn_defense_into_attack:IsPurgeException() return false end

function modifier_chaotic_to_turn_defense_into_attack:ADDeclareFunctions()
    return 
    {
        MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL= {nil, self:GetParent()},
		-- advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        
    }
end

function modifier_chaotic_to_turn_defense_into_attack:OnCreated()

    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")*0.01
    self.threshold = self:GetAbility():GetSpecialValueFor("threshold")*0.01
    self.attack_damage_reduction = self:GetAbility():GetSpecialValueFor("attack_damage_reduction")
    self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.angle = self:GetAbility():GetSpecialValueFor("angle")
    self.damage_record = 0

end

function modifier_chaotic_to_turn_defense_into_attack:OnRefresh() 
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")*0.01
    self.threshold = self:GetAbility():GetSpecialValueFor("threshold")*0.01
    self.attack_damage_reduction = self:GetAbility():GetSpecialValueFor("attack_damage_reduction")
    self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.angle = self:GetAbility():GetSpecialValueFor("angle")
    self.damage_record = 0
end

-- function modifier_chaotic_to_turn_defense_into_attack:OnAttackStart(keys)

-- 	if IsServer() then   

-- 		local target = keys.target

-- 		if target ~= self.parent then	return end

--         self.parent:GameTimer(0.2,function()
--             if IsValid(self) then
--                 local origin = self.parent:GetOrigin()
--                 local direction = CalculateDirection(keys.attacker,self.parent)
--                 self:effect_damage(origin,direction)
--             end
--         end)
--     end 
-- end

-- function modifier_chaotic_to_turn_defense_into_attack:Advanced_GetModifierIncomingDamage_Percentage( keys )

--     if not IsServer() then
--         return
--     end

--     if keys.target ~= self.parent then
--         return 0
--     end

--     self.damage_record = self.damage_record + (keys.damage * (self.damage_reduction * 0.01))

--     self:SetStackCount(self.damage_record)

--     if self.damage_record >= self.parent:GetMaxHealth() * self.threshold  then

--         local origin = self.parent:GetOrigin()

--         local point = origin + self.parent:GetForwardVector() * 100

--         local enemies = FindUnitsInRadius(
-- 		self.parent:GetTeamNumber(),
-- 		origin,
-- 		nil,	
-- 		self.radius,
-- 		DOTA_UNIT_TARGET_TEAM_ENEMY,
-- 		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
-- 		DOTA_UNIT_TARGET_FLAG_NONE,	
-- 		0,	
-- 		false
--         )


--         local cast_direction = (point-origin):Normalized()
--         local cast_angle = VectorToAngles( cast_direction ).y

--         local damage = self.damage_record * self.damage_bonus

--         local damageTable = {

--             attacker = self.parent,
--             damage = damage,
--             damage_type = self.ability:GetAbilityDamageType(),
--             damage_flags = DOTA_DAMAGE_FLAG_NONE,
--             ability = self.ability, 
--         }
--         print("88888888")
--         if self.ability:GetRuneType()==1 then
--             print("12345")
--             for _ , enemy in pairs(enemies) do
--                 damageTable.victim = enemy
--                 ApplyDamage(damageTable)
--             end

            
--         else
--             print("66666666")
--             for _ , enemy in pairs(enemies) do

--                 local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
    
--                 local enemy_angle = VectorToAngles( enemy_direction ).y
--                 local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
    
--                 if angle_diff <= self.angle then
    
--                     damageTable.victim = enemy
--                     ApplyDamage(damageTable)
    
--                 end
--             end
    
--         end

        
--         self.damage_record = 0

--         self:SetStackCount(self.damage_record)

--         self:PlayEffect(origin,cast_direction)

--     end

--     return self.damage_reduction

-- end

function modifier_chaotic_to_turn_defense_into_attack:Advanced_GetModifierDamageOutgoing_Percentage(keys)
    return -self.attack_damage_reduction
end

function modifier_chaotic_to_turn_defense_into_attack:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
    if self:GetParent():PassivesDisabled() then
        return 0
    end

	local block = keys.damage *self.damage_reduction


    self.damage_record = self.damage_record + block
    self:SetStackCount(self.damage_record)
    if self.damage_record >= self.parent:GetMaxHealth() * self.threshold  then
        local origin = self.parent:GetOrigin()
        local point = origin + self.parent:GetForwardVector() * 100
        local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),
		origin,
		nil,	
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_NONE,	
		0,	
		false
        )
        local cast_direction = (point-origin):Normalized()
        local cast_angle = VectorToAngles( cast_direction ).y
        local damage = self.damage_record * self.damage_bonus
        local damageTable = {

            attacker = self.parent,
            damage = damage,
            damage_type = self.ability:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
            ability = self.ability, 
        }

        if self.ability:GetRuneType()==1 then
            for _ , enemy in pairs(enemies) do
                damageTable.victim = enemy
                ApplyDamage(damageTable)
            end
        else
            for _ , enemy in pairs(enemies) do
                local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
                local enemy_angle = VectorToAngles( enemy_direction ).y
                local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
                if angle_diff <= self.angle then
                    damageTable.victim = enemy
                    ApplyDamage(damageTable)
                end
            end
        end
        

        self.damage_record = 0
        self:SetStackCount(0)
        self:PlayEffect(origin,cast_direction)
    end














	return math.min(keys.damage,block) 
end



-- function modifier_chaotic_to_turn_defense_into_attack:effect_damage(origin,direction)

--     local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_to_turn_defense_into_attack/eff/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash_headmodel.vpcf", PATTACH_WORLDORIGIN, self.parent )
--     ParticleManager:SetParticleControl( effect_cast, 0, origin )
--     ParticleManager:SetParticleControl( effect_cast, 10, origin )
--     ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
--     DestroyParticleByDelay(effect_cast,0.5)
--     EmitSoundOnLocationWithCaster(origin, "Hero_Mars.Spear.Knockback", self.parent )
-- end

function modifier_chaotic_to_turn_defense_into_attack:PlayEffect(origin,cast_direction)

    local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_to_turn_defense_into_attack/eff/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf", PATTACH_WORLDORIGIN, self.parent )
    ParticleManager:SetParticleControl( effect_cast, 0, origin )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,self.radius,self.radius) )
    ParticleManager:SetParticleControlForward( effect_cast, 0, cast_direction )
    DestroyParticleByDelay(effect_cast,5)

    if self:GetAbility():GetRuneType()==1 then
        local point = origin + cast_direction*100
        local newpos1 = RotatePosition(origin, QAngle(0, 120, 0), point)
		local pfxdirection1 = (newpos1-origin):Normalized()
        local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_to_turn_defense_into_attack/eff/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf", PATTACH_WORLDORIGIN, self.parent )
        ParticleManager:SetParticleControl( effect_cast, 0, origin )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,self.radius,self.radius) )
        ParticleManager:SetParticleControlForward( effect_cast, 0, pfxdirection1 )
        DestroyParticleByDelay(effect_cast,5)



		local newpos2 = RotatePosition(origin, QAngle(0, 120, 0), newpos1)
		local pfxdirection2 = (newpos2-origin):Normalized()
        local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_to_turn_defense_into_attack/eff/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf", PATTACH_WORLDORIGIN, self.parent )
        ParticleManager:SetParticleControl( effect_cast, 0, origin )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,self.radius,self.radius) )
        ParticleManager:SetParticleControlForward( effect_cast, 0, pfxdirection2 )
        DestroyParticleByDelay(effect_cast,5)
    end
    self.parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_ATTACK, 0, 0.3, 4)

    EmitSoundOnLocationWithCaster(origin, "Hero_Mars.Shield.Cast.Small", self.parent )

end

function modifier_chaotic_to_turn_defense_into_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_to_turn_defense_into_attack:OnTooltip() 

    self._tooltip = (self._tooltip or 0) % 2 + 1

    if self._tooltip == 1 then
        return self.attack_damage_reduction
    end

    if self._tooltip == 2 then
        return self:GetStackCount()
    end
    
end