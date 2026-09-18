chaotic_step = chaotic_step or class({})

LinkLuaModifier("modifier_chaotic_step", "chaotic_spell/class_2/chaotic_step", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_step_buff", "chaotic_spell/class_2/chaotic_step", LUA_MODIFIER_MOTION_NONE)

function chaotic_step:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_step/chaotic_step/effect_pos.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_step/chaotic_step/effect_pos_2.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_step/chaotic_step/effect_pos_move.vpcf.vpcf", context )
end

function chaotic_step:GetIntrinsicModifierName() return "modifier_chaotic_step" end
function chaotic_step:GetCastRange()
	if IsServer() then
		return 99999
	end
	local caster = self:GetCaster()
	return math.min(2000,self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus())-caster:GetCastRangeBonus()

end

function chaotic_step:GetCastPoint()
	local time = 0.3
	if self:GetRuneType()==1 then
		time = 0
	end
	return time
end

function chaotic_step:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return DOTA_ABILITY_BEHAVIOR_POINT
end

function chaotic_step:GetCooldown(iLevel)
	local cd =  self:GetSpecialValueFor("cd")
	if self:GetRuneType()==2 then
		cd = cd * (1-self:GetSpecialValueFor("rune_2_cd")*0.01)
	end
	if self:GetRuneType()==3 then
		cd = cd * (1+self:GetSpecialValueFor("rune_3_cd")*0.01)
	end
	return cd
end

function chaotic_step:OnSpellStart()
	
	if IsServer() then


		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		local speed = self:GetSpecialValueFor("ability_speed")
		self.traveled = 0
		self.duration_record = 0
		local castrange = self:GetSpecialValueFor("distance")+caster:GetCastRangeBonus()
		self.distance 	= (target_loc - caster_loc):Length2D()
		self.direction 	= (target_loc - caster_loc):Normalized()
		self.dir = CalculateDirection(caster_loc, target_loc)


        if self.distance >castrange then
            self.distance  = castrange
        end
		self.distance = math.min(self.distance,2000)



		local duration = self:GetSpecialValueFor("duration")

        local info = {
            Ability = self,
            vSpawnOrigin = caster_loc,
            vVelocity = self.direction * speed,
            fDistance = self.distance,
            fStartRadius = 0,
            fEndRadius = 0,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_NONE,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            bProvidesVision = false,
            iVisionTeamNumber = caster:GetTeamNumber(),
            ExtraData =        {
				speed = speed * FrameTime(),
            }
        }
    
        self.projectileID = ProjectileManager:CreateLinearProjectile(info)
		caster:AddNewModifier(caster, self, "modifier_chaotic_step_buff", {duration = duration*caster:GetModifierDurationGainIndex(1)})
		if self:GetRuneType()==3 then
			caster:AddNewModifier(caster, self, "modifier_invulnerable", {duration = duration*caster:GetModifierDurationGainIndex(1)})
		end
		local pfx_min = ParticleManager:CreateParticle("particles/rebuild/chaotic_step/chaotic_step/effect_pos.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_min, 1, Vector(caster_loc.x+self.dir.x*300, caster_loc.y+self.dir.y*300, caster_loc.z + 128))
		ParticleManager:SetParticleControlForward(pfx_min, 1, Vector(-self.dir.x,-self.dir.y,self.dir.z))  --方向
		ParticleManager:ReleaseParticleIndex(pfx_min)
		-- caster:EmitSound("Hero_Windrunner.ShackleshotCast")
		caster:EmitSound("Hero_QueenOfPain.Blink_out.Shard")

	end
end

function chaotic_step:OnProjectileThink_ExtraData(location, ExtraData)

	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	if (self.traveled + ExtraData.speed < (self.distance+100)) and caster:IsAlive()  then
		caster:SetAbsOrigin(Vector(location.x, location.y, GetGroundPosition(location, caster).z))
		--caster:Purge(false, true, true, true, true)
		self.traveled = self.traveled + ExtraData.speed
		ProjectileManager:ProjectileDodge(caster)
		local pfx_min = ParticleManager:CreateParticle("particles/rebuild/chaotic_step/chaotic_step/effect_pos_move.vpcf.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_min, 0, caster_loc)
		ParticleManager:SetParticleControlForward(pfx_min, 0, caster:GetForwardVector())  --方向	
		ParticleManager:ReleaseParticleIndex(pfx_min)	
	else
		local caster = self:GetCaster()
		caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.01}) --提供相位，防止卡位
		ProjectileManager:DestroyLinearProjectile(self.projectileID)
	
		local pfx_max = ParticleManager:CreateParticle("particles/rebuild/chaotic_step/chaotic_step/effect_pos_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_max, 1, caster_loc)
		ParticleManager:SetParticleControlForward(pfx_max,1, caster:GetForwardVector())  --方向
		ParticleManager:ReleaseParticleIndex(pfx_max)	
		
	end


	
end



-------------------------
modifier_chaotic_step = modifier_chaotic_step or advanced_modifier({})

function modifier_chaotic_step:IsDebuff() 	return false end
function modifier_chaotic_step:IsHidden() 	return true end
function modifier_chaotic_step:IsPurgable() return false end
function modifier_chaotic_step:OnCreated()
	self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed")
end
function modifier_chaotic_step:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_chaotic_step:GetModifierMoveSpeedBonus_Constant() 
    return self.move_speed
end
modifier_chaotic_step_buff = modifier_chaotic_step_buff or advanced_modifier({})
function modifier_chaotic_step_buff:IsDebuff() 	return false end
function modifier_chaotic_step_buff:IsHidden() 	return false end
function modifier_chaotic_step_buff:IsPurgable() return false end

function modifier_chaotic_step_buff:OnCreated()
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
function modifier_chaotic_step_buff:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
		
    }
end

function modifier_chaotic_step_buff:GetModifierMoveSpeedBonus_Constant() 
    return self.bonus_move_speed
end

function modifier_chaotic_step_buff:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end
function modifier_chaotic_step_buff:OnTooltip() 
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetModifierAttackSpeedBonus_Constant()
	end
	if self._tooltip == 2 then
		return self:GetModifierMoveSpeedBonus_Constant() 
	end

end
function modifier_chaotic_step_buff:GetModifierIgnoreMovespeedLimit()  return 1 end




