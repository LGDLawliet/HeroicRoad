Primary_Powershot= class({})

function Primary_Powershot:IsHiddenWhenStolen()           return false end
function Primary_Powershot:IsStealable()                  return true end
function Primary_Powershot:IsNetherWardStealable()        return true end
function Primary_Powershot:IsRefreshable() 			   return true end
function Primary_Powershot:GetChannelTime()               return 0.2	end

-- function Primary_Powershot:OnUpgrade() 			
--   if self:GetLevel()==1 then 
-- 	AbilityChargeController:AbilityChargeInitialize(self,10, 3, 1, true, true) 
--   end
-- end

function Primary_Powershot:OnSpellStart()
	 local caster = self:GetCaster()
	 local caster_pos = caster:GetAbsOrigin()

	 caster:EmitSound("Ability.PowershotPull")
	--  print(self:GetCursorPosition())
     self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/powershot/channel_effect/effect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
     ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1",caster_pos, false)
     ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack", caster_pos, false)
     self.Effect="particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
     self.distance=self:GetSpecialValueFor("range")+caster:GetCastRangeBonus()
	 self.distance = math.max( self.distance,100)
     self.speed=3000
     self.radius=250

end

function Primary_Powershot:OnChannelFinish(bInterrupted)
	
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


function Primary_Powershot:OnProjectileHit_ExtraData(target, location, kv)
	
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
            end						
	    end
end



function Primary_Powershot:OnProjectileThink_ExtraData(vLocation, table) GridNav:DestroyTreesAroundPoint(vLocation,300,false) end

