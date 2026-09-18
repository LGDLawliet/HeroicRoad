heroTalent_npc_dota_hero_muerta = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_muerta", "heroTalent/heroTalent_npc_dota_hero_muerta", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_muerta_DOTA2", "heroTalent/heroTalent_npc_dota_hero_muerta", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_muerta:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_muerta"
end
function heroTalent_npc_dota_hero_muerta:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_gunslinger.vpcf", context )--
	
end

function heroTalent_npc_dota_hero_muerta:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	local caster = self:GetCaster()
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,
	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	caster:PerformAttack(target, false, true, true, false, false, false, true)
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

end
function heroTalent_npc_dota_hero_muerta:UnlockPierceTheVeilEffect()
	--self.unlock3 = true
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_muerta")
	if modifier then
		modifier:InitUnlock3Effect()
	end
end




------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_muerta = class({})

function modifier_heroTalent_npc_dota_hero_muerta:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_muerta:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_muerta:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_muerta:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_muerta:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_muerta:OnCreated()
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
		self.pro_speed = self:GetAbility():GetSpecialValueFor("pro_speed")
		self:StartIntervalThink(0.03)
		self.index = -1
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		
	end
end

function modifier_heroTalent_npc_dota_hero_muerta:GetModifierProjectileSpeedBonus()
	return self.pro_speed
end


function modifier_heroTalent_npc_dota_hero_muerta:InitUnlock3Effect()
	self.chance = 100
end


function modifier_heroTalent_npc_dota_hero_muerta:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_muerta:OnAttack(keys)
	if not IsServer() then return end
	if not self:GetParent():IsRangedAttacker() then
		return
	end
	if self:GetParent():IsDisableSplit() then  --分裂箭无效化
		return    
	end

	
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
		-- self:GetAbility():StartCooldown(0.02)
		if self.chance>=RandomInt(1, 100) then

			local ability =  self:GetAbility()
			local parent = self:GetParent()
			local attack_speed =  math.max(parent:GetSecondsPerAttack(false),0.03)
			parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3,1/attack_speed)

			-- local radius = parent:Script_GetAttackRange()+150
			local point = keys.target:GetOrigin()
			local enemies = FindUnitsInRadius(parent:GetTeamNumber(), point, nil,self.radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			local origin = parent:GetOrigin()
			
			local cast_direction = (point-origin):Normalized()
			local cast_angle = VectorToAngles( cast_direction ).y
			
			local secondTarget
			for _,enemy in pairs(enemies) do
				if enemy~=keys.target then
					local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
					local enemy_angle = VectorToAngles( enemy_direction ).y
					local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
					if angle_diff<=30 then
						secondTarget = enemy
						break
					end
				end
			end
			if not secondTarget then
				secondTarget = keys.target
			end
			if secondTarget then
				local info = 
					{
						Target =secondTarget,
						-- Source = unit,
						Ability = ability,	
						EffectName = parent:GetRangedProjectileName(),
						iMoveSpeed = parent:GetProjectileSpeed(),
						vSourceLoc = parent:GetAttachmentOrigin( parent:ScriptLookupAttachment( "attach_attack2" ) ),
						bDrawsOnMinimap = false,  --？？
						bDodgeable = true,   --可躲闪
						bIsAttack = false,   --攻击效果
						bVisibleToEnemies = true,  --对敌人可视
						bReplaceExisting = false, --替换现有的
						flExpireTime = GameRules:GetGameTime() + 10, --存在时间
						bProvidesVision = false, --提供视野
						ExtraData = {}   --额外的数据
					}
				ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
end
------------------------------------------------
modifier_heroTalent_npc_dota_hero_muerta_DOTA2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "radius" )
	
	if not IsServer() then return end
	self.main_target = nil
	self.proc_target = nil
	self.double_shot = false
	self.pro_speed = self:GetAbility():GetSpecialValueFor("pro_speed")
end

function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:OnRefresh( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "radius" )
	self.pro_speed = self:GetAbility():GetSpecialValueFor("pro_speed")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:GetModifierProjectileSpeedBonus()
	return self.pro_speed
end

function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:OnAttackStart( params )
	if params.attacker~=self.parent then return end
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end
	if self.parent:PassivesDisabled() then return end

	if not RollPseudoRandomPercentage(self.chance, self.parent:entindex(), self.parent) then return end

	self.main_target = params.target
	self.proc_target = params.target

	-- find other target units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.parent:Script_GetAttackRange() + self.bonus_range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		if enemy~=self.main_target then
			self.proc_target = enemy
			break
		end
	end

	self:PlayEffects()
end

function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:OnAttack( params )
	if params.attacker~=self.parent then return end
	if params.target~=self.main_target then return end

	-- not proc for instant attacks
	if params.no_attack_cooldown then return end

	local target = self.proc_target
	self.proc_target = nil
	self.main_target = nil

	-- attack secondary target
	self.double_shot = true
	--self.parent:PerformAttack(target, true, true, true, false, true, false, false)
	if target then
		local info = 
			{
				Target =target,
				-- Source = unit,
				Ability = self.ability,	
				EffectName = self.parent:GetRangedProjectileName(),
				iMoveSpeed = self.parent:GetProjectileSpeed(),
				vSourceLoc = self.parent:GetAttachmentOrigin( self.parent:ScriptLookupAttachment( "attach_attack2" ) ),
				bDrawsOnMinimap = false,  --？？
				bDodgeable = true,   --可躲闪
				bIsAttack = false,   --攻击效果
				bVisibleToEnemies = true,  --对敌人可视
				bReplaceExisting = false, --替换现有的
				flExpireTime = GameRules:GetGameTime() + 10, --存在时间
				bProvidesVision = false, --提供视野
				ExtraData = {}   --额外的数据
			}
		ProjectileManager:CreateTrackingProjectile(info)
	end
	self.double_shot = false
	EmitSoundOn( "Hero_Muerta.Attack.DoubleShot", self.parent )
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_heroTalent_npc_dota_hero_muerta_DOTA2:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_gunslinger.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end