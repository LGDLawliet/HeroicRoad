Advanced_Overload =Advanced_Overload or class({})

LinkLuaModifier("modifier_Advanced_Overload", "skills/Advanced_Overload", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Overload_buff", "skills/Advanced_Overload", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Overload_debuff", "skills/Advanced_Overload", LUA_MODIFIER_MOTION_NONE)



require('internal/timers')   --计时器功能
function Advanced_Overload:CheckKV(key)
	local table = {

		damage =4,
		bonus_damage = 0.05,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Overload:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_reactive_armor_unlock1",{})

	return true
end
function Advanced_Overload:UnlockSecondCore(key)
	return true
end
function Advanced_Overload:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_Overload_buff")
	if modifier then
		local stack = modifier:GetStackCount()
		modifier:SafeDestroy()

		local newModifier = caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Overload_buff", -- modifier name
			{} -- kv
		)
		if newModifier then
			newModifier:SetStackCount(stack)
		end
	end
	return true
end
function Advanced_Overload:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if advanced_level>=15 then
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end

function Advanced_Overload:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_flashbeam_arcana1.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", context )

	

end

function Advanced_Overload:SetLastCastSpell(ability)
	self.last_spell = ability
end
function Advanced_Overload:GetLastSpell()
	if self.last_spell and not self.last_spell:IsNull() then
		return self.last_spell
	end
	return nil
end
function Advanced_Overload:IsHiddenWhenStolen() 		return false end
function Advanced_Overload:IsRefreshable() 			return true end
function Advanced_Overload:IsStealable() 				return true end
function Advanced_Overload:IsNetherWardStealable()		return true end
function Advanced_Overload:GetIntrinsicModifierName() return "modifier_Advanced_Overload" end


modifier_Advanced_Overload =modifier_Advanced_Overload or  class({})

function modifier_Advanced_Overload:IsHidden()	return true end
function modifier_Advanced_Overload:IsDebuff()	return false end
function modifier_Advanced_Overload:IsStunDebuff()	return false end
function modifier_Advanced_Overload:IsPurgable()	return false end
function modifier_Advanced_Overload:IsPurgeException() return false end
function modifier_Advanced_Overload:RemoveOnDeath() return false end
function modifier_Advanced_Overload:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not IsServer() then return end
end


function modifier_Advanced_Overload:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_Advanced_Overload:OnAbilityFullyCast( params )
	if not IsServer() then return end
	
	if params.ability:IsItem() then return end
	if params.ability:GetCooldown(params.ability:GetLevel())<2 then
		return
	end
	if self.parent:PassivesDisabled() then return end
	local pass = false
	if params.unit~=self.parent then 
		if not IsEnemy(params.unit,self.parent) and CalculateDistance(params.unit,self.parent)<=800 then
			local chance = 20
			if self:GetAbility().advanced_level>=10 then
				chance = 30
			end
			if self.parent:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
				pass = true
				local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_flashbeam_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit )
				ParticleManager:SetParticleControl(effect_cast, 0, params.unit:GetOrigin())
				DestroyParticleByDelay(effect_cast,1.5)
				
			end
		end
	else
		self:GetAbility():SetLastCastSpell(params.ability)
		pass = true
	end
	if pass then
		self.parent:AddNewModifier(
			self.parent, -- player source
			self.ability, -- ability source
			"modifier_Advanced_Overload_buff", -- modifier name
			{} -- kv
		)
	end

end







modifier_Advanced_Overload_buff = modifier_Advanced_Overload_buff or advanced_modifier({})

function modifier_Advanced_Overload_buff:IsHidden()	return false end
function modifier_Advanced_Overload_buff:IsDebuff()	return false end
function modifier_Advanced_Overload_buff:IsStunDebuff()	return false end
function modifier_Advanced_Overload_buff:IsPurgable()	return false end

function modifier_Advanced_Overload_buff:OnCreated(keys)
	if IsServer() then
		local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_attack1",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		-- buff particle
		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
		if self:GetAbility().unlock2 then
			self:SetStackCount(2)
		else
			self:SetStackCount(1)
		end
		
	end
end

function modifier_Advanced_Overload_buff:OnRefresh()
	if IsServer() then
		if self:GetAbility().unlock2 then
			self:SetStackCount(math.min(self:GetStackCount()+2,20))
		else
			self:SetStackCount(math.min(self:GetStackCount()+1,10))
		end
		
	end
end






function modifier_Advanced_Overload_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_Advanced_Overload_buff:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker==self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local damage = parent:HDGetPrimaryStatValue()*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage")
			local consume_all = false
			if ability:GetAutoCastState() then
				damage = damage * self:GetStackCount()
				consume_all = true
			end
			if ability.advanced_level>=5 then
				local spell_amp = parent:GetSpellAmplification(false)
				if spell_amp>0 then
					damage = damage * (1+spell_amp*0.15)
				end
			end
			local damageTable = {

				attacker = parent,
				damage = damage,
				damage_type = ability:GetAbilityDamageType(),
				ability = ability, 
				hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
			}

			local enemies = FindUnitsInRadius(
			parent:GetTeamNumber(),	-- int, your team number
			keys.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			ability:GetSpecialValueFor("radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
			)
			local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
			local duration = ability:GetSpecialValueFor("duration")
			if consume_all then
				duration = duration  * self:GetStackCount()
			end
			

			damageTable.victim = keys.target
			ApplyDamage( damageTable )
			local StatusResistance =keys.target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
			keys.target:AddNewModifier(parent,ability, "modifier_Advanced_Overload_debuff", { duration =math.max( duration*StatusResistance,0.1) } )
			local count = 3
			for _,enemy in pairs(enemies) do
				if enemy~=keys.target then
					count = count - 1
					damageTable.victim = enemy
					ApplyDamage( damageTable )
					local StatusResistance =enemy:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					enemy:AddNewModifier(parent,ability, "modifier_Advanced_Overload_debuff", { duration =math.max( duration*StatusResistance,0.1) } )
					if count<=0 then
						break
					end
				end
				
			end
			self:PlayEffects( keys.target )

			if ability.unlock1 then
				local pos = keys.target:GetOrigin()
				local triggerCount = 3
				local radius  = ability:GetSpecialValueFor("radius")
				local caster = self:GetCaster()
				local new_damageTable = {

					attacker = caster,
					damage = damage,
					damage_type = ability:GetAbilityDamageType(),
					ability = ability, 
					hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
				}
	
				Timers:CreateTimer(2.5, function()
					if ability and not ability:IsNull() then

						local units = FindUnitsInRadius(caster:GetTeamNumber(),pos,nil,600,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)
						if #units<=0 then
							return
						end
						local target = units[1]
						pos = target:GetOrigin()

						local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
						local sound_cast = "Hero_StormSpirit.Overload"
					
						-- Create Particle
						local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
						ParticleManager:ReleaseParticleIndex( effect_cast )
						EmitSoundOn( sound_cast, target )
						damageTable.victim =target
						ApplyDamage( damageTable )
						local StatusResistance =target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
						target:AddNewModifier(parent,ability, "modifier_Advanced_Overload_debuff", { duration =math.max( duration*StatusResistance,0.1) } )

						local enemies = FindUnitsInRadius(caster:GetTeamNumber(),pos,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)
						local count = 3
						for _,enemy in pairs(enemies) do
							if enemy~=target then
								count = count - 1
								new_damageTable.victim = enemy
								ApplyDamage( new_damageTable )
								local StatusResistance =enemy:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
								enemy:AddNewModifier(parent,ability, "modifier_Advanced_Overload_debuff", { duration =math.max( duration*StatusResistance,0.1) } )
								if count<=0 then
									break
								end
							end
							
						end

						triggerCount = triggerCount - 1
						if triggerCount<=0 then
							return
						else
							return 2.5
						end
					end
					return nil  
				end)
			end







			if ability.advanced_level>=20 then
				local last_spell = ability:GetLastSpell()
				if last_spell then
					if consume_all then
						local newCooldown = last_spell:GetCooldownTimeRemaining() - self:GetStackCount()*1.5
						last_spell:EndCooldown()
						if newCooldown>=0 then
							last_spell:StartCooldown(newCooldown)
						end

						if ability.unlock2 and 30>=RandomInt(1, 100) then
							return
						end
						self:SafeDestroy()
					else
						local newCooldown = last_spell:GetCooldownTimeRemaining() - 1.5
						last_spell:EndCooldown()
						if newCooldown>=0 then
							last_spell:StartCooldown(newCooldown)
						end
						if ability.unlock2 and 30>=RandomInt(1, 100) then
							return
						end

						self:DecrementStackCount()
						if self:GetStackCount()<=0 then
							self:SafeDestroy()
						end
						return
					end
				end
			end

			if consume_all then
				if ability.unlock2 and 30>=RandomInt(1, 100) then
					return
				end
				self:SafeDestroy()
			else
				if ability.unlock2 and 30>=RandomInt(1, 100) then
					return
				end
				self:DecrementStackCount()
				if self:GetStackCount()<=0 then
					self:SafeDestroy()
				end
			end
			
			
		end
	end
end


function modifier_Advanced_Overload_buff:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
	local sound_cast = "Hero_StormSpirit.Overload"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, target )
end




function modifier_Advanced_Overload_buff:Advanced_GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then
		return
	end
	if self:GetStackCount()>0 then
		self:ShiftPosition()
		if 20>=RandomInt(1, 100) then
			return -1000
		else
			self:DecrementStackCount()
			if self:GetStackCount()<=0 then
				self:SafeDestroy()
			end
			return -1000
		end
	end


end

function modifier_Advanced_Overload_buff:ShiftPosition()
	local parent = self:GetParent()
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(head_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(head_particle, 1, parent:GetOrigin())
	ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 7, 0))
	ParticleManager:ReleaseParticleIndex(head_particle)

	parent:EmitSound("Hero_StormSpirit.StaticRemnantPlant")
	FindClearSpaceForUnit(parent, parent:GetOrigin() + RandomVector(350), true)

end

function modifier_Advanced_Overload_buff:ADDeclareFunctions()
	local funcs = {
		
	}
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end

	return funcs
end



modifier_Advanced_Overload_debuff =modifier_Advanced_Overload_debuff or  class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Overload_debuff:IsHidden()	return false end
function modifier_Advanced_Overload_debuff:IsDebuff()	return true end
function modifier_Advanced_Overload_debuff:IsStunDebuff()	return false end
function modifier_Advanced_Overload_debuff:IsPurgable()	return true end
function modifier_Advanced_Overload_debuff:OnCreated()
	local ability = self:GetAbility()
	self.move_slow = -ability:GetSpecialValueFor("move_slow")
	self.attack_slow = -ability:GetSpecialValueFor("attack_slow")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Overload_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Advanced_Overload_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end

function modifier_Advanced_Overload_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.move_slow
end