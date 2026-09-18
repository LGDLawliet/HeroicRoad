--特效优化 √
Advanced_purification = class({})

LinkLuaModifier( "modifier_Advanced_purification", "skills/Advanced_purification", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_purification_unlock1", "skills/Advanced_purification", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_purification_unlock3", "skills/Advanced_purification", LUA_MODIFIER_MOTION_NONE )
function Advanced_purification:IsHiddenWhenStolen()
	return false
end
function Advanced_purification:CheckKV(key)
	local table = {

	


		basic_damage = 10,
		bonus_damage = 0.1,




	}
	local value = table[key] or -1
	return value

end
function Advanced_purification:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_reactive_armor_unlock1",{})

	return true
end
function Advanced_purification:UnlockSecondCore(key)
	return true
end
function Advanced_purification:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_purification_unlock3",{})
	return true
end





function Advanced_purification:Spawn()
	self.Advanced_purification_cooldow = 0
end
function Advanced_purification:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")

	return radius
end

function Advanced_purification:OnSpellStart(unlock3)
	if not IsServer() then
		return
	end
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local rare_cast_response = "omniknight_omni_ability_purif_03"
	local target_cast_response = {"omniknight_omni_ability_purif_01", "omniknight_omni_ability_purif_02", "omniknight_omni_ability_purif_04", "omniknight_omni_ability_purif_05", "omniknight_omni_ability_purif_06", "omniknight_omni_ability_purif_07", "omniknight_omni_ability_purif_08"}
	local self_cast_response = {"omniknight_omni_ability_purif_01", "omniknight_omni_ability_purif_05", "omniknight_omni_ability_purif_06", "omniknight_omni_ability_purif_07", "omniknight_omni_ability_purif_08"}
	local sound_cast = "Hero_Omniknight.Purification"    

	-- Play cast responses    
	if caster == target then
		if RollPercentage(50) then
			EmitSoundOn(self_cast_response[math.random(1, #self_cast_response)], caster)
		end
	else
		-- Roll for rare response
		if RollPercentage(5) then
			EmitSoundOn(rare_cast_response, caster)

		-- Roll for normal reponse
		elseif RollPercentage(50) then
			EmitSoundOn(target_cast_response[math.random(1,#target_cast_response)], caster)
		end
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
	
	--命石：洗礼，目标修改
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_holy_cross_cloak")
	if equip_sp then
		local targets = GetAllRealHeroes()
		for _,target in pairs(targets)do
			self:Purification(caster, ability, target,false,unlock3)
		end
	else
		self:Purification(caster, ability, target,false,unlock3)
	end

	-- #4 Talent: Purification is also applied on a second random target

		local bounce_radius = ability:GetSpecialValueFor("radius")

		-- Find a target to jump to
		local allies = FindUnitsInRadius(caster:GetTeamNumber(),
												 target:GetAbsOrigin(),
												 nil,
												 bounce_radius,
												 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
												 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												 DOTA_UNIT_TARGET_FLAG_NONE,
												 FIND_ANY_ORDER,
												 false)

		-- Find a bounce target
		for _,ally in pairs(allies) do

			if ally ~= target then
				-- Purify it
				local sub = true
				self:Purification(caster, ability, ally,sub,unlock3)

				-- -- Stop at the first valid bounce target
				-- break
			end
		end
	
end

function Advanced_purification:Purification(caster, ability, target, sub,unlock3)
	if not IsServer() then
		return
	end
	-- Ability properties
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_aoe = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local particle_hit = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"


	local level = self.advanced_level
	-- Ability specials
	local heal_amount = ability:GetSpecialValueFor("basic_damage")
	local radius = ability:GetSpecialValueFor("radius")

	-- #8 Talent: Purification heal/damage increase
	heal_amount = heal_amount + caster:GetStrength()*ability:GetSpecialValueFor("bonus_damage")
	--命石：洗礼，治疗修改1
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_holy_cross_cloak")
	if equip_sp then
		heal_amount = heal_amount*(1+equip_sp:GetAbility():GetSpecialValueFor("bonus_damage")*0.01)
		radius = radius*(1+equip_sp:GetAbility():GetSpecialValueFor("bonus_radius")*0.01)
	end

	-- Add cast particle
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	-- Add AoE particle
	local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_aoe_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_aoe_fx)    


	-- Calculate final heal/damage values
	local heal = heal_amount
	local damage = heal
	target:Purge(false, true, false, false, true) --强驱散
	local sub_index = 0.5
	--LV5解锁圣耀
	if level>=5 then
		sub_index = 0.75
	end
	if sub then
		heal = heal*sub_index
	end
	local healing = 0

	--LV15解锁圣佑
	--命石：洗礼，治疗修改2
	if level>=15 and not equip_sp then
		healing = HealWithGain(heal,caster,target,self,nil,nil,nil,50,nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
	else
		if not equip_sp then
		healing = HealWithGain(heal,caster,target,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
		end
	end

	if level>=20 then
		if not unlock3 then
			target:AddNewModifier(caster, self, "modifier_Advanced_purification", {duration =2.5})
		end

		if not sub and self.unlock1 then
			caster:AddNewModifier(caster, self, "modifier_Advanced_purification_unlock1", {duration =30* caster:GetModifierDurationGainIndex(1)})
		end
	end

    



	--是否造成伤害
	if sub then
		--触发本源唤醒
		local chance = 10
		--LV10解锁本源唤醒
		if level>=10 then
			chance = 15
		end
		local effect_count = 2  --触发次数
		if self.unlock2 then
			chance = 20
			effect_count = 10
		end

		if self.Advanced_purification_cooldow<effect_count and chance>=RandomInt(1, 100) then
			self.Advanced_purification_cooldow = self.Advanced_purification_cooldow + 1
			Timers:CreateTimer(RandomFloat(0.1, 0.3), function()
				caster:SetCursorCastTarget(target)
				self:OnSpellStart(unlock3)
				Timers:CreateTimer(1, function()
					self.Advanced_purification_cooldow = self.Advanced_purification_cooldow - 1
				end)
			end)
		end
		return
	end
	-- Find enemies around it
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  target:GetAbsOrigin(),
									  nil,
									  radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)

	
	for i,enemy in pairs(enemies) do
		-- If they're not magic immune, damage them
		if not enemy:IsMagicImmune() then
			local damageTable = {
				victim = enemy,
				attacker = caster, 
				damage = damage,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				ability = ability,
				hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
			}
		
			ApplyDamage(damageTable)  

			-- Add hit particle
			local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControlEnt(particle_hit_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_hit_fx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(particle_hit_fx, 3, Vector(radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(particle_hit_fx)
		end
		if i>=5 then
			break
		end
	end        



end











modifier_Advanced_purification = advanced_modifier({})

-----------------------------------------------------------------------------------------
function modifier_Advanced_purification:IsDebuff() return false end
function modifier_Advanced_purification:IsHidden() return false end
function modifier_Advanced_purification:IsPurgable()	return false end


function modifier_Advanced_purification:Advanced_GetModifierIncomingDamage_Percentage( params )
	return -100
end


function modifier_Advanced_purification:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





modifier_Advanced_purification_unlock1 = class({})

function modifier_Advanced_purification_unlock1:IsHidden()	return false end
function modifier_Advanced_purification_unlock1:IsDebuff()	return false end
function modifier_Advanced_purification_unlock1:IsPurgable()	return false end
function modifier_Advanced_purification_unlock1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

function modifier_Advanced_purification_unlock1:GetModifierBonusStats_Strength()	return 10*self:GetStackCount() end






function modifier_Advanced_purification_unlock1:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_purification_unlock1:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= (50) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_purification_unlock1:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end



modifier_Advanced_purification_unlock3 = class({})


function modifier_Advanced_purification_unlock3:IsHidden()	return true end
function modifier_Advanced_purification_unlock3:IsPurgable() 		return false end
function modifier_Advanced_purification_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_purification_unlock3:RemoveOnDeath()  return false end
function modifier_Advanced_purification_unlock3:OnCreated(keys)
	if IsServer() then
		self.time = GameRules:GetGameTime()
	end
end
function modifier_Advanced_purification_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_Advanced_purification_unlock3:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
			return
		end
		if keys.target~=self:GetParent() or keys.attacker:GetTeamNumber()==keys.target:GetTeamNumber() then
			return
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		if self.time>=GameRules:GetGameTime() then
			return
		end
		if 35>=RandomInt(1, 100) then
			keys.target:SetCursorCastTarget(keys.target)
			self:GetAbility():OnSpellStart(true)
			self.time = GameRules:GetGameTime() + 1
		end
	end
end

