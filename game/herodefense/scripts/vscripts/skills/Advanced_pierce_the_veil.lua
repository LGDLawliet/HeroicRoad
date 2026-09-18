Advanced_pierce_the_veil = class({})
LinkLuaModifier( "modifier_Advanced_pierce_the_veil_buff", "skills/Advanced_pierce_the_veil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_pierce_the_veil_phantom", "skills/Advanced_pierce_the_veil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_pierce_the_veil_phantom_attack", "skills/Advanced_pierce_the_veil", LUA_MODIFIER_MOTION_NONE )


function Advanced_pierce_the_veil:Precache( context )
	PrecacheResource( "model", "models/heroes/muerta/muerta_ult.vmdl", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_screen_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf", context )
end


function Advanced_pierce_the_veil:UnlockFirstCore(key)
	return true
end
function Advanced_pierce_the_veil:UnlockSecondCore(key)
	return true
end
function Advanced_pierce_the_veil:IsRefreshable() return false end

function Advanced_pierce_the_veil:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_muerta")
	if not ability then
		self.CoreUnlock = false
		self.unlock3 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	ability:UnlockPierceTheVeilEffect()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock2",{})
	return true

end

function Advanced_pierce_the_veil:CheckKV(key)
	local table = {
		bonus_damage = 10,


	}
	local value = table[key] or -1
	return value

end


function Advanced_pierce_the_veil:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end
function Advanced_pierce_the_veil:Spawn()
	self.bonus_duration = 0
	self.unlock1_bonus = 0
end
function Advanced_pierce_the_veil:IncrementBonusDuration()
	self.bonus_duration = self.bonus_duration + 0.3
end
function Advanced_pierce_the_veil:GetBonusDuration()
	if self.advanced_level>=15 then
		self.bonus_duration = 0
		return math.min(self.bonus_duration,6)
	end
	return 0
end

function Advanced_pierce_the_veil:GetUnlock1Bonus()
	return self.unlock1_bonus
end
function Advanced_pierce_the_veil:IncrementUnlock1Bonus()
	self.unlock1_bonus  = self.unlock1_bonus + 1
end
function Advanced_pierce_the_veil:OnSpellStart(talent)
	local caster = self:GetCaster()

	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Advanced_pierce_the_veil_buff"



	local transform_duration = self:GetSpecialValueFor( "transform_duration" )
	local duration = (self:GetSpecialValueFor( "duration" )+self:GetBonusDuration())*caster:GetModifierDurationGainIndex(0.3)+transform_duration
	if self.unlock2 then
		duration = -1
	end

	caster:Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge( caster )
	caster:AddNewModifier(
		caster,
		self,
		"modifier_Advanced_pierce_the_veil_buff",
		{duration = duration ,talent=talent and 1 or 0}
	)

	EmitSoundOn( "Hero_Muerta.PierceTheVeil.Cast", caster )
end



function Advanced_pierce_the_veil:CallPhantom(duration)
	local caster = self:GetCaster()
	local ability = self
	local pos = caster:GetOrigin()
	local forward = caster:GetForwardVector()
	local duration = duration or -1
	local unit  = CreateUnitByName("npc_hd_pierce_the_veil_ghost", pos, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_Advanced_pierce_the_veil_phantom", {duration=duration})
	unit:SetForwardVector(forward)
	-- unit:SetOriginalModel(caster.origin_model_name)
	-- unit:SetModelScale(caster:GetModelScale())
	-- local hModel = caster:FirstMoveChild()
	-- while hModel ~= nil do
	-- 	if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
	-- 		local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = unit:GetAbsOrigin() })
	-- 		-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
	-- 		hWearable:FollowEntity(unit, true)
	-- 	end
	-- 	hModel = hModel:NextMovePeer()
	-- end
	return unit
end


function Advanced_pierce_the_veil:OnProjectileHit_ExtraData(target, location, keys)
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
	local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
	caster:PerformAttack(target, false, true, true, false, false, false, true)
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

end



modifier_Advanced_pierce_the_veil_buff = modifier_Advanced_pierce_the_veil_buff or advanced_modifier({})

function modifier_Advanced_pierce_the_veil_buff:IsHidden()	return false end
function modifier_Advanced_pierce_the_veil_buff:IsDebuff()	return false end
function modifier_Advanced_pierce_the_veil_buff:IsPurgable()	return false end
function modifier_Advanced_pierce_the_veil_buff:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.modelscale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) 
	self.transform_duration = self:GetAbility():GetSpecialValueFor( "transform_duration" )

	self.transforming = true
	self:StartIntervalThink( self.transform_duration )

	if not IsServer() then return end
	if kv.talent==1 then
		self.talent = true
	end
	self.unit = {}
	table.insert(self.unit,self.ability:CallPhantom())



	self:PlayEffectsStart()


	self.bonus_damage = 1.5
	local level = self.ability:GetSpecialValueFor("advanced_level")
	if level>=10 then
		self.bonus_damage = 1.65
		if level>=15 then
			self.lv15 = true
			self.attack_count = 0
			if level>=20 then
				self.lv20 = true
				self.triggerCount = 0
				if self.ability.unlock1 then
					self.unlock1 = true
					self:SetStackCount(math.min(self.ability:GetUnlock1Bonus()*10,self.parent:GetBaseDamageMax()*8))
				end
				if self.ability.unlock2 then
					self.unlock2 = true
				end
			end
		end
	end
end

function modifier_Advanced_pierce_the_veil_buff:OnDestroy()
	if not IsServer() then return end

	for _, unit in ipairs(self.unit) do
		if not unit:IsNull() then
			unit:RemoveModifierByName("modifier_Advanced_pierce_the_veil_phantom")
		end
	end

	self:PlayEffectsEnd()
end


function modifier_Advanced_pierce_the_veil_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL, -- allow attack ethereal units
		-- MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK, 

	}
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(funcs,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT)
	end

	return funcs
end

function modifier_Advanced_pierce_the_veil_buff:GetModifierModelChange()
	return "models/heroes/muerta/muerta_ult.vmdl"
end

function modifier_Advanced_pierce_the_veil_buff:GetModifierModelScale()
	return self.modelscale
end

function modifier_Advanced_pierce_the_veil_buff:GetModifierProjectileName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf"
end

function modifier_Advanced_pierce_the_veil_buff:GetAttackSound()
	return "Hero_Muerta.PierceTheVeil.Attack"
end

function modifier_Advanced_pierce_the_veil_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage + self:GetStackCount()
end

function modifier_Advanced_pierce_the_veil_buff:GetOverrideAttackMagical( params )
	return 1
end

-- function modifier_Advanced_pierce_the_veil_buff:GetModifierTotalDamageOutgoing_Percentage( params )
-- 	if params.inflictor then return 0 end
-- 	if params.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
-- 	if params.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end
-- 	if not params.target:IsMagicImmune() then
-- 		local damage = params.original_damage
-- 		if self.ability:GetAutoCastState() then
-- 			damage = damage * self.bonus_damage 
-- 			self.parent:ModifyHealth(math.max(self.parent:GetHealth()*0.95,1), self.ability, false, 0)
-- 		end
-- 		local damageTable = {
-- 			victim = params.target,
-- 			attacker = self.parent,
-- 			damage =damage,
-- 			damage_type = DAMAGE_TYPE_MAGICAL,
-- 			damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
-- 			ability = self.ability, --Optional.
-- 		}
-- 		ApplyDamage( damageTable )
		
-- 		if self.lv15 then
-- 			self.attack_count = self.attack_count + 1
-- 			if self.attack_count>=10 then
-- 				self.attack_count = 0
-- 				self.ability:IncrementBonusDuration()
-- 			end
-- 			if self.lv20 and self.triggerCount<6 and self.parent:RollRandom(10,1)  then
-- 				if self.unlock2 then
-- 					if #self.unit>=7 then
-- 						for i, unit in ipairs(self.unit) do
-- 							if unit:IsNull() then
-- 								table.remove(self.unit,i)
-- 								break
-- 							end
-- 						end
-- 						if #self.unit>=7 then
-- 							return
-- 						end
-- 					end
-- 					table.insert(self.unit,self.ability:CallPhantom(3))
-- 				else
-- 					table.insert(self.unit,self.ability:CallPhantom(3))
-- 					self.triggerCount = self.triggerCount + 1
-- 				end


-- 			end
-- 			if self.unlock1 and not params.target:IsAlive() then
-- 				self.ability:IncrementUnlock1Bonus()
-- 			end

-- 		end

-- 		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact", params.target )
-- 	else
-- 		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact.MagicImmune", params.target )
-- 	end

-- 	return -200
-- end


function modifier_Advanced_pierce_the_veil_buff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.transforming,
		[MODIFIER_STATE_CANNOT_TARGET_BUILDINGS] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_DISARMED] = false,
	}
	if self:GetAbility().unlock2 or self.talent then
		state = {
			[MODIFIER_STATE_STUNNED] = self.transforming,
			[MODIFIER_STATE_CANNOT_TARGET_BUILDINGS] = true,
			-- [MODIFIER_STATE_ATTACK_IMMUNE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			-- [MODIFIER_STATE_DISARMED] = false,
		}
	end

	return state
end

function modifier_Advanced_pierce_the_veil_buff:OnIntervalThink()
	self.transforming = false
end

function modifier_Advanced_pierce_the_veil_buff:GetEffectName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function modifier_Advanced_pierce_the_veil_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Advanced_pierce_the_veil_buff:PlayEffectsStart()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_ultimate_form_screen_effect.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(1,0,0) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

function modifier_Advanced_pierce_the_veil_buff:PlayEffectsEnd()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf"
	local sound_cast = "Hero_Muerta.PierceTheVeil.End"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end



function modifier_Advanced_pierce_the_veil_buff:GetModifierAttackSpeedBonus_Constant()
	return 500
end






-- advanced_modifier
function modifier_Advanced_pierce_the_veil_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_pierce_the_veil_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_medusa_4") then return end
	if keys.inflictor then return 0 end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end
	if not keys.target:IsMagicImmune() then
		local damage = keys.original_damage
		if self.ability:GetAutoCastState() then
			damage = damage * self.bonus_damage 
			self.parent:ModifyHealth(math.max(self.parent:GetHealth()*0.95,1), self.ability, false, 0)
		end
		local damageTable = {
			victim = keys.target,
			attacker = self.parent,
			damage =damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK +DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
		ApplyDamage( damageTable )
		
		if self.lv15 then
			self.attack_count = self.attack_count + 1
			if self.attack_count>=10 then
				self.attack_count = 0
				self.ability:IncrementBonusDuration()
			end
			if self.lv20 and self.triggerCount<6 and self.parent:RollRandom(10,1)  then
				if self.unlock2 then
					if #self.unit>=7 then
						for i, unit in ipairs(self.unit) do
							if unit:IsNull() then
								table.remove(self.unit,i)
								break
							end
						end
						if #self.unit>=7 then
							return
						end
					end
					table.insert(self.unit,self.ability:CallPhantom(3))
				else
					table.insert(self.unit,self.ability:CallPhantom(3))
					self.triggerCount = self.triggerCount + 1
				end


			end
			if self.unlock1 and not keys.target:IsAlive() then
				self.ability:IncrementUnlock1Bonus()
			end

		end

		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact", keys.target )
	else
		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact.MagicImmune", keys.target )
	end

	return -200
end















modifier_Advanced_pierce_the_veil_phantom = modifier_Advanced_pierce_the_veil_phantom or class({})
function modifier_Advanced_pierce_the_veil_phantom:IsHidden()	return true end
function modifier_Advanced_pierce_the_veil_phantom:IsDebuff()	return false end
function modifier_Advanced_pierce_the_veil_phantom:IsPurgable()	return false end
function modifier_Advanced_pierce_the_veil_phantom:IsPurgeException()	return false end
function modifier_Advanced_pierce_the_veil_phantom:OnCreated(keys)
	if IsServer() then
		-- local caster = self:GetCaster()
		self.angle = RandomInt(-180, 180)
		self:GetParent():SetHullRadius(0)
		-- self:GetParent():SetModelScale(0.9)
		self.caster = self:GetCaster()
		self:StartIntervalThink(0.01)
		-- self:SetStackCount(self.type)
		self.attack_cooldown = GameRules:GetGameTime()
		self.attack_standby = true
		self.attackInterval = 0.3
		-- local name = self.caster:GetUnitName()
		-- if name=="npc_dota_hero_terrorblade" then
		-- 	self:GetParent():AddActivityModifier("abysm")
		-- end
		-- if name=="npc_dota_hero_monkey_king" then
		-- 	self:GetParent():AddActivityModifier("attack_long_range")
		-- end
		self.chance = 25
		if self:GetAbility():GetSpecialValueFor("advanced_level")>=5 then
			self.chance = 35
		end
	end

end
function modifier_Advanced_pierce_the_veil_phantom:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_Advanced_pierce_the_veil_phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function modifier_Advanced_pierce_the_veil_phantom:OnAttackStart(keys)
	if self.caster == keys.attacker then
		if self.attack_standby then
			if self.caster:IsAttacking() then
				-- 根据攻击速度触发攻击
				local parent = self:GetParent()
				if self.caster:RollRandom(self.chance,1)  then
					if self.attack_cooldown<=GameRules:GetGameTime() then
						local needTime = math.max(self.caster:GetSecondsPerAttack(false),0.06)
						self.attack_cooldown = GameRules:GetGameTime() + math.max(needTime - FrameTime(),self.attackInterval)
						parent:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_pierce_the_veil_phantom_attack", {duration=needTime})
						parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1/needTime)
					end
				end

				
			end
		end
    end
end

function modifier_Advanced_pierce_the_veil_phantom:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster then
		self:SafeDestroy()
		return
	end
	

	-- if not caster:HasModifier("modifier_Advanced_elder_dragon_form_transform") then
	-- 	-- self:SafeDestroy()
	-- 	self:GoDie()
	-- 	return
	-- end
	self.bonus_move = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
	local parent = self:GetParent()
	local pos = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	local newpos = RotatePosition(pos, QAngle(0, self.angle, 0), pos + forward)
	-- local newpos = pos - forward*150
	local dir = (newpos-pos):Normalized()
	local target_pos = pos+dir*200
	-- target_pos.z = target_pos.z+128
	local dis = CalculateDistance(target_pos,parent:GetAbsOrigin())
	if dis>=2000 then
		parent:SetForwardVector(forward)
		parent:SetAbsOrigin(target_pos+dir)
		return
	end
	if dis>=250 then
		parent:MoveToPosition(target_pos)
		-- self.attack_standby = false
	else
		-- parent:SetForwardVector(dir)
		-- parent:FaceTowards(forward)
		parent:SetForwardVector(forward)
		-- self.attack_standby = true
	end


	



	
end

function modifier_Advanced_pierce_the_veil_phantom:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		-- MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ATTACK_START
	}
end

function modifier_Advanced_pierce_the_veil_phantom:GetModifierMoveSpeed_AbsoluteMin()
	local caster = self:GetCaster()
	local index =  (self:GetParent():GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()/500
	return math.max( caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true),self.bonus_move*index)
end

function modifier_Advanced_pierce_the_veil_phantom:GetModifierIgnoreMovespeedLimit( params )
	return 1
end



modifier_Advanced_pierce_the_veil_phantom_attack = modifier_Advanced_pierce_the_veil_phantom_attack or class({})
function modifier_Advanced_pierce_the_veil_phantom_attack:IsHidden()	return true end
function modifier_Advanced_pierce_the_veil_phantom_attack:IsDebuff()	return false end
function modifier_Advanced_pierce_the_veil_phantom_attack:IsPurgable()	return false end
function modifier_Advanced_pierce_the_veil_phantom_attack:IsPurgeException()	return false end
function modifier_Advanced_pierce_the_veil_phantom_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_pierce_the_veil_phantom_attack:OnCreated(keys)
	-- if IsServer() then
	-- self.speed = 1/self:GetRemainingTime()
	self.caster = self:GetAbility():GetCaster()
	-- end
end
function modifier_Advanced_pierce_the_veil_phantom_attack:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ATTACK,
	}
end


function modifier_Advanced_pierce_the_veil_phantom_attack:OnAttack(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self.caster then
		return
	end
	if  self.caster:IsInSpecialAttack() then
		return
	end
	if self.trigger then
		return
	end
	self.trigger = true
	
	local info = 
			{
				Target =keys.target,
				Source = self:GetParent(),
				Ability = self:GetAbility(),	
				EffectName = "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf",
				iMoveSpeed = 1500,
				-- vSourceLoc = parent:GetAttachmentOrigin( parent:ScriptLookupAttachment( "attach_attack2" ) ),
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

	

	self:SafeDestroy()


end
