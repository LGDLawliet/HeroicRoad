Middle_Powershot= class({})
LinkLuaModifier("modifier_Middle_Powershot_slow", "skills/Middle_Powershot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Powershot_move", "skills/Middle_Powershot", LUA_MODIFIER_MOTION_NONE)

function Middle_Powershot:IsHiddenWhenStolen()           return false end
function Middle_Powershot:IsStealable()                  return true end
function Middle_Powershot:IsNetherWardStealable()        return true end
function Middle_Powershot:IsRefreshable() 			   return true end
function Middle_Powershot:GetChannelTime()               return 0.2	end

-- function Middle_Powershot:OnUpgrade() 			
--   if self:GetLevel()==1 then 
-- 	AbilityChargeController:AbilityChargeInitialize(self,10, 3, 1, true, true) 
--   end
-- end

function Middle_Powershot:OnSpellStart()
	 local caster = self:GetCaster()
	 local caster_pos = caster:GetAbsOrigin()
	-- 预防目标位置等于自身位置导致的bug
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end
	 caster:EmitSound("Ability.PowershotPull")
	--  print(self:GetCursorPosition())
     self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/powershot/channel_effect/effect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
     ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1",caster_pos, false)
     ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack", caster_pos, false)
     self.Effect="particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
     self.distance=self:GetSpecialValueFor("range")+caster:GetCastRangeBonus()
	 self.distance = math.max(self.distance,100)
     self.speed=3000
     self.radius=250

end

function Middle_Powershot:OnChannelFinish(bInterrupted)
	
	-- 预防目标位置等于自身位置导致的bug
	local pos = self:GetCursorPosition()  
	if pos == self:GetCaster():GetAbsOrigin() then
		pos = pos + self:GetCaster():GetForwardVector()
	end
	local curpos = pos

	local ability = self
	local caster = ability:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	
	local dir=TG_Direction(curpos,caster_pos)
    dir.z=0
    EmitSoundOn( "Ability.Powershot", caster )  
	local projectileTable =
	{
		EffectName =self.Effect,
		Ability = ability,
		vSpawnOrigin =caster:GetAbsOrigin(),
		vVelocity =dir*self.speed,
		fDistance =self.distance,
		fStartRadius = self.radius,
		fEndRadius = self.radius,
		Source = caster,
		TreeBehavior = PROJECTILES_NOTHING,
		bCutTrees = true,
		bTreeFullCollision = false,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_TREE,
		bProvidesVision = true,
	}
	Projectile=ProjectileManager:CreateLinearProjectile( projectileTable )

	if self.particle~=nil then 
		ParticleManager:DestroyParticle(self.particle, false)
		self.particle=nil
	end
end


function Middle_Powershot:OnProjectileHit_ExtraData(target, location, kv)
	
		if target~=nil then
			local ability = self
            local caster = ability:GetCaster()
            if not target:IsMagicImmune() then
                local particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_ti6_powershot_dmg.vpcf", PATTACH_ABSORIGIN, target)
                ParticleManager:ReleaseParticleIndex( particle )
                local damageTable = {
                    victim = target,
                    attacker = caster,
                    damage =  (ability:GetSpecialValueFor( "basic_damage" ) + caster:GetBaseDamageMax()*ability:GetSpecialValueFor("attack_damage")),
                    damage_type = self:GetAbilityDamageType(),
                    damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
                    ability = ability,
                    }
                    ApplyDamage(damageTable)
					local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
					local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
                    target:AddNewModifier(caster, ability, "modifier_Middle_Powershot_slow", {duration=ability:GetSpecialValueFor("duration")*StatusResistance}) 
                    target:AddNewModifier(caster, ability, "modifier_Middle_Powershot_move", {duration=0.15}) 
            end						
	    end
end



function Middle_Powershot:OnProjectileThink_ExtraData(vLocation, table) GridNav:DestroyTreesAroundPoint(vLocation,300,false) end

modifier_Middle_Powershot_slow = class({})
function modifier_Middle_Powershot_slow:IsDebuff()				             return true  end
function modifier_Middle_Powershot_slow:IsPurgable() 			                 return true end
function modifier_Middle_Powershot_slow:IsPurgeException() 	                 return true end
function modifier_Middle_Powershot_slow:IsHidden()				             return false end
function modifier_Middle_Powershot_slow:DeclareFunctions()                     return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_Middle_Powershot_slow:GetModifierMoveSpeedBonus_Percentage() return (0- self:GetAbility():GetSpecialValueFor("move_slow")) end
----------------------------------------------------------------------
--击退
modifier_Middle_Powershot_move = class({})

function modifier_Middle_Powershot_move:IsDebuff()			return false end
function modifier_Middle_Powershot_move:IsHidden() 			return true end
function modifier_Middle_Powershot_move:IsPurgable() 		return false end
function modifier_Middle_Powershot_move:IsPurgeException() 	return false end
function modifier_Middle_Powershot_move:IsMotionController() return true end
function modifier_Middle_Powershot_move:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_Middle_Powershot_move:OnCreated(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 2000
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_Middle_Powershot_move:OnRefresh(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 2000
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Middle_Powershot_move:OnIntervalThink(keys)   
    if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    ResolveNPCPositions(new_pos, 70)
    end
end
-------------------------------------------------------------------


