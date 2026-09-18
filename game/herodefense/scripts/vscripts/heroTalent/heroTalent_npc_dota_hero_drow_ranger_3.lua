heroTalent_npc_dota_hero_drow_ranger_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_drow_ranger_3", "heroTalent/heroTalent_npc_dota_hero_drow_ranger_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect", "heroTalent/heroTalent_npc_dota_hero_drow_ranger_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_drow_ranger_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_drow_ranger_3"
end

function heroTalent_npc_dota_hero_drow_ranger_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_drow/drow_base_attack_linear_proj.vpcf", context )

end
function heroTalent_npc_dota_hero_drow_ranger_3:Spawn()
	self.arrow_index = 0
	self.arrow_wave = {}
	self.effect ={}
end
function heroTalent_npc_dota_hero_drow_ranger_3:InitData(modifier)
	self.arrow_index = self.arrow_index + 1
	if self.arrow_index>=500000 then
		self.arrow_index = 1
	end
	self.arrow_wave[self.arrow_index] = modifier
	return self.arrow_index
end
function heroTalent_npc_dota_hero_drow_ranger_3:RemoveData(index)
	self.arrow_wave[index] = nil
end
function heroTalent_npc_dota_hero_drow_ranger_3:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end
	local modifier = self.arrow_wave[data.modifier_index]
	if not modifier or modifier:IsNull() then
		return false
	end
	if modifier:CheckUnit(target) then
		return false
	end
	modifier:Record(target)

	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*data.damage_index,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)
	local sound_cast = "Hero_DrowRanger.ProjectileImpact"
	EmitSoundOn( sound_cast, target )

	return true
end


modifier_heroTalent_npc_dota_hero_drow_ranger_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_drow_ranger_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3:ADDeclareFunctions()
    return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
    }
end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3:OnAttack(keys)
	if not IsServer() then return end
	local parent = self:GetParent()
	if not parent:IsRangedAttacker() then
		return
	end
	if parent:IsDisableSplit() then  --分裂箭无效化
		return    
	end

	if keys.attacker == parent and keys.target and keys.target:GetTeamNumber() ~= parent:GetTeamNumber() and  not parent:PassivesDisabled() then	
		if parent:IsInSpecialAttack() then
			return
		end
		local chance = self.chance
		local damage_index= self:GetAbility():GetSpecialValueFor("damage")
		local random = math.random
		local pass = false

		if chance >= random(1, 100) then
			pass = true
		end
		local ability =  self:GetAbility()
		if not pass and self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(true, true, true,true)
			pass = true
		end
		if pass then
			-- local ability =  self:GetAbility()
			local modifier = parent:AddNewModifier(
				parent, -- player source
				ability, -- ability source
				"modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect", -- modifier name
				{
					duration = 3,
					damage_index = damage_index,
				}
			)
		end
	

	end
end

modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect = advanced_modifier({})


function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:GetAttributes( ) return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:OnCreated( kv )

	if not IsServer() then return end
	

	local caster = self:GetCaster()
	local point =caster:GetOrigin()+caster:GetForwardVector()*100
	self.direction = point-self:GetCaster():GetOrigin()
	self.direction.z = 0
	self.direction = self.direction:Normalized()

	self.current_arrows = 0
	self.current_wave = 0



	local projectile_name
	if self.frost then
		projectile_name = "particles/units/heroes/hero_drow/drow_multishot_proj_linear_proj.vpcf"
	else
		projectile_name = "particles/units/heroes/hero_drow/drow_base_attack_linear_proj.vpcf"
	end

	self.arrow_index = self:GetAbility():InitData(self)
	self.effect = {}
	local dis = caster:Script_GetAttackRange() * self:GetAbility():GetSpecialValueFor("length")/100
	self.info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = caster:GetAttachmentOrigin( caster:ScriptLookupAttachment( "attach_attack1" ) ),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType =DOTA_UNIT_TARGET_BASIC +DOTA_UNIT_TARGET_HERO ,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	    EffectName = projectile_name,
	    fDistance = dis,
	    fStartRadius = 50,
	    fEndRadius = 50,
		ExtraData = {
			modifier_index = self.arrow_index,
			damage_index = kv.damage_index,
		}
		
	}
	local speed = math.max(dis,caster:GetProjectileSpeed())
	local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, 10, 0 ), self.direction )
	self.info.vVelocity = projectile_direction * (speed)
	ProjectileManager:CreateLinearProjectile(self.info)
	local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, 20, 0 ), self.direction )
	self.info.vVelocity = projectile_direction * (speed)
	ProjectileManager:CreateLinearProjectile(self.info)
	local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, -10, 0 ), self.direction )
	self.info.vVelocity = projectile_direction * (speed)
	ProjectileManager:CreateLinearProjectile(self.info)
	local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, -20, 0 ), self.direction )
	self.info.vVelocity = projectile_direction * (speed)
	ProjectileManager:CreateLinearProjectile(self.info)
	local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, 0, 0 ), self.direction )
	self.info.vVelocity = projectile_direction * (speed)
	ProjectileManager:CreateLinearProjectile(self.info)
	if self:GetParent():GetLevel() >= self:GetAbility():GetSpecialValueFor("lvl") then
		local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, 30, 0 ), self.direction )
		self.info.vVelocity = projectile_direction * (speed)
		ProjectileManager:CreateLinearProjectile(self.info)
		local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, -30, 0 ), self.direction )
		self.info.vVelocity = projectile_direction * (speed)
		ProjectileManager:CreateLinearProjectile(self.info)
	end

	-- play effects
	local sound_cast = "Hero_DrowRanger.Multishot.Channel"
	EmitSoundOn( sound_cast, caster )
end



function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:OnDestroy()
	if not IsServer() then return end

	self:GetAbility():RemoveData(self.arrow_index)
	local sound_cast = "Hero_DrowRanger.Multishot.Channel"
	StopSoundOn( sound_cast, self:GetCaster() )
end




function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:PlayEffects()
	-- Get Resources
	local sound_cast
	if self.frost then
		sound_cast = "Hero_DrowRanger.Multishot.FrostArrows"
	else
		sound_cast = "Hero_DrowRanger.Multishot.Attack"
	end
	EmitSoundOn( sound_cast, self:GetCaster() )
end


function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:CheckUnit(target)

	for _, unit in ipairs(self.effect) do
		if unit == target then
			return true
		end
	end
	return false
end

function modifier_heroTalent_npc_dota_hero_drow_ranger_3_effect:Record(target)

	table.insert(self.effect,target)
end