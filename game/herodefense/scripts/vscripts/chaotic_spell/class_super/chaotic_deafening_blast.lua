LinkLuaModifier("modifier_chaotic_deafening_blast_already", "chaotic_spell/class_super/chaotic_deafening_blast", LUA_MODIFIER_MOTION_NONE)

chaotic_deafening_blast = class({})

function chaotic_deafening_blast:GetCastRange()
    if IsServer() then return 30000 end
    return self:GetSpecialValueFor("length") - self:GetCaster():GetCastRangeBonus()
end



function chaotic_deafening_blast:OnSpellStart()
    local target_point = self:GetCursorPosition()
    local caster = self:GetCaster()
    -- 螺旋形发射声波
    if self:GetRuneType() == 1 then
        local count = 8  -- 发射数量
        local short = self:GetSpecialValueFor("rune_1_short") * 0.01
        local long = self:GetSpecialValueFor("rune_1_long") * 0.01
        
        -- 首先发射角度为0的最长声波
        Timers:CreateTimer(0.1, function()
            self:Blast(target_point, long, 1, 1, 0)
        end)
        
        -- 然后发射其他角度的声波
        for i=2,count do
            local angle = ((i-1)/(count-1)) * 360
            local length_ratio = long - (long-short) * ((i-1)/(count-1))
            
            caster:GameTimer(i*0.08, function()
                self:Blast(target_point, length_ratio, 1, 1, angle)
            end)
        end
    else
        -- 默认发射模式
        self:Blast(target_point, 1, 1, 1, 0)
        self:Blast(target_point, 1, 1, 1, 30)
        self:Blast(target_point, 1, 1, 1, -30)
    end
end

function chaotic_deafening_blast:Blast(point, length_index, speed_index, damage_index, angle)
    if not IsServer() then return end
    if not point then return end

    local caster = self:GetCaster()
    local length_index = length_index or 1
    local speed_index = speed_index or 1 
    local damage_index = damage_index or 1 
    local angle = angle or 0

    local speed = 1200*speed_index
    local distance = self:GetSpecialValueFor("length")*length_index
    local damage = (caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage") + self:GetSpecialValueFor("damage"))*damage_index

    if point == caster:GetAbsOrigin() then
        point = point + caster:GetAbsOrigin():GetForwardVector()*100
    end

    local width = self:GetSpecialValueFor("width")
    self.direction = point - caster:GetOrigin()
	self.direction.z = 0
	self.direction = self.direction:Normalized()

    local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, angle, 0 ), self.direction )

    self.info = {
        EffectName = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf",
        Ability = self,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fStartRadius = width,
        fEndRadius = width,
        vVelocity = projectile_direction * speed,
        fDistance = distance,
        Source = caster,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        bProvidesVision = true,
        iVisionRadius  = 500,
		iVisionTeamNumber = caster:GetTeamNumber(),
        ExtraData = {
            damage = damage,
            direction_x = projectile_direction.x,
            direction_y = projectile_direction.y,
        }   --额外的数据
    }

    ProjectileManager:CreateLinearProjectile(self.info)
    caster:EmitSoundParams("Hero_Invoker.DeafeningBlast", 0,0.3,0)
end

function chaotic_deafening_blast:OnProjectileHit_ExtraData(target, location, keys)
    if not self then return end
    if target then
        local damage = keys.damage or 0
        local knockback_distance = self:GetSpecialValueFor("knock_dis")
        local duration = self:GetSpecialValueFor("disarm_duration")-0.5
        local disarm_duration = self:GetSpecialValueFor("disarm_duration")

        local modifier = target:FindModifierByNameAndCaster("modifier_chaotic_deafening_blast_already",self:GetCaster())
		if modifier then
			damage = damage*self:GetSpecialValueFor("index")*0.01
		end
        local damage_table = {
            victim = target,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self,
            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
        }
        ApplyDamage(damage_table)
        local pos = target:GetAbsOrigin()-Vector(keys.direction_x,keys.direction_y,0)*50
        -- 击退
        local knockback =
        {
            knockback_duration = duration,
            duration = duration-0.5,
            knockback_distance = knockback_distance,
            knockback_height = 50,
            center_x = pos.x,
            center_y = pos.y,
            center_z = pos.z,
        }
        target:RemoveModifierByName("modifier_knockback")
        target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback)
        target:AddNewModifier(self:GetCaster(), self, "modifier_disarmed", {duration = disarm_duration})
        target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_deafening_blast_already", {duration = 0.2})
        
        return false
    end
end


------------------------------------------------------------------------------------------------------------------------------
modifier_chaotic_deafening_blast_already = class({})

function modifier_chaotic_deafening_blast_already:IsDebuff()	return false end
function modifier_chaotic_deafening_blast_already:IsHidden()	return true end
function modifier_chaotic_deafening_blast_already:IsPurgable()	return false end