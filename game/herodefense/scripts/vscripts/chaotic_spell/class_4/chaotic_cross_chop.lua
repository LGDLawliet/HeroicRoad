chaotic_cross_chop = class({})


LinkLuaModifier("modifier_chaotic_cross_chop", "chaotic_spell/class_4/chaotic_cross_chop", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_cross_chop_health_cost", "chaotic_spell/class_4/chaotic_cross_chop", LUA_MODIFIER_MOTION_NONE)



LinkLuaModifier("modifier_chaotic_cross_chop_rune_1_buff", "chaotic_spell/class_4/chaotic_cross_chop", LUA_MODIFIER_MOTION_NONE)


function chaotic_cross_chop:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_cross_chop/chaotic_cross_chop.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_cross_chop/chaotic_cross_chop_2_2.vpcf", context )
end
function chaotic_cross_chop:GetIntrinsicModifierName()
	return "modifier_chaotic_cross_chop"
end

function chaotic_cross_chop:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end

function chaotic_cross_chop:OnProjectileHit_ExtraData(target, location, kv)
	
	if target~=nil then
		local ability = self
		local caster = ability:GetCaster()

		local damageTable = {
			victim = target,
			attacker = caster,
			damage =  kv.damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
			ability = ability,
			}

		ApplyDamage(damageTable)


		if ability:GetRuneType()==1 then
			local gain = caster:GetModifierDurationGainIndex(1)
			local time = self:GetSpecialValueFor("rune_1_duration")
			time = math.min(time*gain,20)
			caster:AddNewModifier(
				caster,
				self,
				"modifier_chaotic_cross_chop_rune_1_buff",
				{	duration = time,stack_time = time}
			)
		end
				
	end
end


-- function chaotic_cross_chop:OnProjectileThink_ExtraData(vLocation, table) GridNav:DestroyTreesAroundPoint(vLocation,300,false) end

modifier_chaotic_cross_chop = advanced_modifier({})

function modifier_chaotic_cross_chop:IsDebuff() return false end
function modifier_chaotic_cross_chop:IsHidden() return true end
function modifier_chaotic_cross_chop:IsPurgable() 		return false end
function modifier_chaotic_cross_chop:IsPurgeException() 	return false end
function modifier_chaotic_cross_chop:RemoveOnDeath()  return false end
function modifier_chaotic_cross_chop:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
	

		self.health_cost = ability:GetSpecialValueFor("health_cost")
		self.health_cost_superposition = ability:GetSpecialValueFor("health_cost_superposition")
		self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
		self.debuff_duration = ability:GetSpecialValueFor("debuff_duration")
		self.length = ability:GetSpecialValueFor("length")
		self.width = ability:GetSpecialValueFor("width")
		self.trigger_chance = ability:GetSpecialValueFor("trigger_chance")


		

	end
end



function modifier_chaotic_cross_chop:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
	

		self.health_cost = ability:GetSpecialValueFor("health_cost")
		self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
		self.debuff_duration = ability:GetSpecialValueFor("debuff_duration")
		self.length = ability:GetSpecialValueFor("length")
		self.width = ability:GetSpecialValueFor("width")
		self.trigger_chance = ability:GetSpecialValueFor("trigger_chance")


	end
end



function modifier_chaotic_cross_chop:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end


function modifier_chaotic_cross_chop:OnAttackLanded(keys)

	if IsServer() then



		local ability = self:GetAbility()

		local parent = self:GetParent()

		if parent:IsAlive() then
			if parent:IsRangedAttacker() then
				return
			end
			if parent:PassivesDisabled() then
				return
			end
			if CalculateDistance(parent,keys.target)>=400 then
				return
			end
			if not ability:IsCooldownReady() then
				return
			end
			if not (self.trigger_chance>=RandomInt(1, 100)) then
				return
			end
			ability:UseResources(true, true, true, true)

			if ability:GetAutoCastState() then

				local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_cross_chop/chaotic_cross_chop.vpcf", PATTACH_CUSTOMORIGIN, parent )
				ParticleManager:SetParticleControl( effect_cast1, 0, parent:GetOrigin() )
				ParticleManager:SetParticleControlForward(effect_cast1, 0, parent:GetForwardVector())
				DestroyParticleByDelay(effect_cast1,2)

				parent:GameTimer(0.2,function()
					local attack_keys = {
						duration = 0.1,
						iSpecialAttack = 1,
						iDisableApplyModifier = 0,
						iDisableCleave = 1,
						iDisableSplit = 1,
			
					}
					local attackEffectRecord = parent:AddAttackEffectModifier(ability,attack_keys)
			
					parent:PerformAttack(keys.target, false, true, true, false, false, false, false)
					if attackEffectRecord then
						attackEffectRecord:Destroy()
					end


					parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_ATTACK, 0, 0.3, 4)


					local modifier = parent:FindModifierByName("modifier_chaotic_cross_chop_health_cost")
					local cost = 0
					if modifier then
						cost = parent:GetMaxHealth() * (self.health_cost  + modifier:GetStackCount() )*0.01
					else
						cost = parent:GetMaxHealth() * (self.health_cost * 0.01)
					end
					if parent:GetHealth() <= cost then
						return 0	
					end

					parent:ModifyHealth(parent:GetHealth() - cost,ability,false, 0)
					parent:AddNewModifier(parent, self:GetAbility(), "modifier_chaotic_cross_chop_health_cost", {duration = self.debuff_duration})
					
					local effect = "particles/rebuild/chaotic_spell/chaotic_cross_chop/chaotic_cross_chop_2.vpcf"
					local dir = TG_Direction(keys.target:GetAbsOrigin(),parent:GetAbsOrigin())
					local damage = (parent:GetAverageTrueAttackDamage(nil) * ability:GetSpecialValueFor("bouns_damage")) *ability:GetEffectGain()
	
					local projectileTable =
					{
						EffectName =effect,
						Ability = ability,
						vSpawnOrigin =parent:GetAbsOrigin(),
						vVelocity = dir * 3000,
						fDistance =self.length,
						fStartRadius = self.width,
						fEndRadius = self.width,
						Source = parent,
						TreeBehavior = PROJECTILES_NOTHING,
						bCutTrees = true,
						bTreeFullCollision = false,
						bHasFrontalCone = false,
						bReplaceExisting = false,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
						bProvidesVision = false,
						ExtraData = {damage = damage}   --额外的数据
				
					}
	
					ProjectileManager:CreateLinearProjectile( projectileTable )

					parent:EmitSound("Hero_EarthSpirit.Magnetize.End")
					parent:EmitSound("Hero_Juggernaut.OmniSlash")
					
				end)

			else
				local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_cross_chop/chaotic_cross_chop.vpcf", PATTACH_CUSTOMORIGIN, parent )
				ParticleManager:SetParticleControl( effect_cast1, 0, parent:GetOrigin() )
				ParticleManager:SetParticleControlForward(effect_cast1, 0, parent:GetForwardVector())
				DestroyParticleByDelay(effect_cast1,2)

				parent:GameTimer(0.2,function()
					local attack_keys = {
						duration = 0.1,
						iSpecialAttack = 1,
						iDisableApplyModifier = 0,
						iDisableCleave = 1,
						iDisableSplit = 1,
			
					}
					local attackEffectRecord = parent:AddAttackEffectModifier(ability,attack_keys)
			
					parent:PerformAttack(keys.target, false, true, true, false, false, false, false)
					parent:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_ATTACK, 0, 0.3, 4)
					if attackEffectRecord then
						attackEffectRecord:Destroy()
					end
				end)

				return 0
			end
		end
	end
	return 0
end


modifier_chaotic_cross_chop_health_cost = advanced_modifier({})

function modifier_chaotic_cross_chop_health_cost:IsDebuff() return false end
function modifier_chaotic_cross_chop_health_cost:IsHidden() return false end
function modifier_chaotic_cross_chop_health_cost:IsPurgable() 		return false end
function modifier_chaotic_cross_chop_health_cost:IsPurgeException() 	return false end
function modifier_chaotic_cross_chop_health_cost:OnCreated()

	if not IsServer() then
		return
	end

	local health_cost_superposition = self:GetAbility():GetSpecialValueFor("health_cost_superposition")

	-- print(health_cost_superposition)

	self:SetStackCount(health_cost_superposition)

end

function modifier_chaotic_cross_chop_health_cost:OnRefresh()

	if not IsServer() then
		return
	end

	local health_cost_superposition = self:GetAbility():GetSpecialValueFor("health_cost_superposition")

	-- print(health_cost_superposition)

	self:SetStackCount(math.min(self:GetStackCount() + health_cost_superposition, 50))

end

function modifier_chaotic_cross_chop_health_cost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chaotic_cross_chop_health_cost:OnTooltip()

	return self:GetStackCount()

end		











modifier_chaotic_cross_chop_rune_1_buff = advanced_modifier({})

function modifier_chaotic_cross_chop_rune_1_buff:IsHidden()	return false end
function modifier_chaotic_cross_chop_rune_1_buff:IsDebuff()	return false end
function modifier_chaotic_cross_chop_rune_1_buff:IsPurgable()	return false end


function modifier_chaotic_cross_chop_rune_1_buff:OnCreated(params)
	
	self.ability = self:GetAbility()
	self.bonus_attack_damage = self.ability:GetSpecialValueFor("rune_1_bonus")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { 
			dieTime = self:GetDieTime() 
		})
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_chaotic_cross_chop_rune_1_buff:OnRefresh(params)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+params.stack_time

		
		table.insert(self.tData, {
			dieTime = dieTime 
		})
		self:IncrementStackCount()
	end
end

function modifier_chaotic_cross_chop_rune_1_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_chaotic_cross_chop_rune_1_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end
function modifier_chaotic_cross_chop_rune_1_buff:Advanced_GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()*self.bonus_attack_damage
end




function modifier_chaotic_cross_chop_rune_1_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_chaotic_cross_chop_rune_1_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return   self:Advanced_GetModifierPreAttack_BonusDamage()
	end
end