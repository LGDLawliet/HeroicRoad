--特效优化 √
Advanced_Eldwurm_soul_Slyrak = class({})


LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak", "skills/Advanced_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_effect", "skills/Advanced_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15", "skills/Advanced_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_debuff", "skills/Advanced_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_unlock1", "skills/Advanced_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff", "skills/Advanced_Eldwurm_soul_Slyrak", LUA_MODIFIER_MOTION_NONE)
-- require('internal/timers')   --计时器功能
function Advanced_Eldwurm_soul_Slyrak:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Einherjar_passive_effect",{})
	return true
end
function Advanced_Eldwurm_soul_Slyrak:UnlockSecondCore(key)
	return true
end
function Advanced_Eldwurm_soul_Slyrak:UnlockThirdCore(key)

	return true
end

function Advanced_Eldwurm_soul_Slyrak:GetIntrinsicModifierName() return "modifier_Advanced_Eldwurm_soul_Slyrak" end
function Advanced_Eldwurm_soul_Slyrak:IsHiddenWhenStolen() 		return false end
function Advanced_Eldwurm_soul_Slyrak:IsRefreshable() 			return true  end
function Advanced_Eldwurm_soul_Slyrak:CheckKV(key)
	local table = {

		bonus_attack_damage =10,
		bonus_attack_speed = 0.3,



	}
	local value = table[key] or -1
	return value

end

function Advanced_Eldwurm_soul_Slyrak:CheckKVFixedOverride(key)
	if key=="bonus_attack_speed" then
		if self:GetUnlock(3)==3 then
			return 0
		end
	end

	return -999999

end

function Advanced_Eldwurm_soul_Slyrak:SpecialEffect_Lifestealer(unit)
	local caster = self:GetCaster()
	if self.advanced_level>=15 then
		unit:AddNewModifier(caster, self, "modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15", {stack=0})
	else
		unit:AddNewModifier(caster, self, "modifier_Advanced_Eldwurm_soul_Slyrak_effect", {})
	end

end







function Advanced_Eldwurm_soul_Slyrak:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/elder_dragon_form/unlock2/effect/fire/monkey_king_spring_fire_base.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", context )

	PrecacheResource( "particle", "particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", context )

	
	
end
function Advanced_Eldwurm_soul_Slyrak:Spawn()
	self.unlock1_bonus = 0
	self.active_proj = {


	}
end
function Advanced_Eldwurm_soul_Slyrak:GetStack()
	return self.unlock1_bonus
end
function Advanced_Eldwurm_soul_Slyrak:AddStack()
	self.unlock1_bonus = self.unlock1_bonus + 1
end
function Advanced_Eldwurm_soul_Slyrak:ReduceStack()
	self.unlock1_bonus = math.max(self.unlock1_bonus -1,0)
end
function Advanced_Eldwurm_soul_Slyrak:OnProjectileHitHandle( target, location, handle )
	if IsServer() then
		if not target then
			self.active_proj[handle] = nil
			return true
		end

		if self.active_proj[handle].count>=5 then
			return
		end


		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage =self.active_proj[handle].damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

		-- -- debuff
		target:AddNewModifier(self:GetCaster(), self,"modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff",{	duration = 3,} )
		-- target:AddNewModifier(self:GetCaster(), self,"modifier_stroke_of_fate_buff",{} )
	
		self.active_proj[handle].count = self.active_proj[handle].count + 1

	
	end
end


modifier_Advanced_Eldwurm_soul_Slyrak= class({})

function modifier_Advanced_Eldwurm_soul_Slyrak:IsDebuff()			return false end
function modifier_Advanced_Eldwurm_soul_Slyrak:IsHidden() 			return true end
function modifier_Advanced_Eldwurm_soul_Slyrak:IsPurgable() 		return false end
function modifier_Advanced_Eldwurm_soul_Slyrak:IsPurgeException() 	return false end


function modifier_Advanced_Eldwurm_soul_Slyrak:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		local caster = self:GetCaster()
		if caster:PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		-- local stack = RandomInt(ability:GetSpecialValueFor("bonus_damage_min"), ability:GetSpecialValueFor("bonus_damage_max"))
		if ability.unlock1 then

			local caster_pos = caster:GetOrigin()
			local unit_pos = unit:GetOrigin()
			local dir = CalculateDirection(caster_pos,unit_pos)
			-- dir.z = 0
			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , unit)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, unit_pos)
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,unit_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/eldwurm_soul_slyrak/unlock1/effectstart.vpcf", PATTACH_CUSTOMORIGIN , caster)
			-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(particle_cast_fx, 0, caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlForward(particle_cast_fx, 0,-dir)  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 5,caster_pos)
			ParticleManager:SetParticleControlEnt( particle_cast_fx, 10, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Slyrak_unlock1", {})
		end
		if ability.advanced_level>=15 then
			
			local stack = 0
			if ability.advanced_level>=20 then
				stack = caster:GetAverageTrueAttackDamage(nil)*0.2
			end
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15", {stack=stack})
		else
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Slyrak_effect", {})
		end
		
	

			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/elder_dragon_form/unlock2/effect/fire/monkey_king_spring_fire_base.vpcf", PATTACH_WORLDORIGIN , unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
			-- ParticleManager:SetParticleControlForward(particle_cast_fx, 2,unit:GetForwardVector())  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(50,0,0))
			-- ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
			Timers:CreateTimer(0.5, function()
				ParticleManager:DestroyParticle(particle_cast_fx, false)
				ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			end)

			unit:EmitSound("Hero_DragonKnight.ElderDragonForm")
		-- end
	end
end










modifier_Advanced_Eldwurm_soul_Slyrak_effect = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Slyrak_effect:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect:IsPurgeException() return false end
-- function modifier_Advanced_Eldwurm_soul_Slyrak_effect:GetTexture() return "soul_of_aethrak" end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect:OnCreated(keys)
	local ability = self:GetAbility()
	self.bonus_health_threshold = ability:GetSpecialValueFor("bonus_health_threshold")
	-- self.bonus_index = 1
	self.bonus_attack_damage = ability:GetSpecialValueFor("bonus_attack_damage")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.armor_reduce = ability:GetSpecialValueFor("armor_reduce")
	if IsServer() then
		
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_Eldwurm_soul_Slyrak_effect:OnIntervalThink()
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end

	else
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex,false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	end
end



function modifier_Advanced_Eldwurm_soul_Slyrak_effect:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Eldwurm_soul_Slyrak_effect:GetModifierPreAttack_BonusDamage()	
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		local bonus = self.bonus_attack_damage*(1+self:GetStackCount()*0.05)
		-- print("bonus="..bonus)
		return bonus
	end
	return 0
end

function modifier_Advanced_Eldwurm_soul_Slyrak_effect:Advanced_GetModifierPhysicalArmorBonus()	
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		return -self.armor_reduce
	end
	return 0
end


function modifier_Advanced_Eldwurm_soul_Slyrak_effect:OnAttackLanded(keys)
	

	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if self:GetParent():GetHealthPercent()>self.bonus_health_threshold then
		return
	end
	local ability = self:GetAbility()
	local max = 20
	if ability.advanced_level>=10 then
		max = 30
	end
	self:SetStackCount(math.min(self:GetStackCount()+1,max))
	--self:GetParent():IsIllusion()
	if not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	-- if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
	local caster = self:GetCaster()
	if not ability then
		return
	end
	keys.target:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Slyrak_debuff", {duration = 5})
	-- end
	

end

function modifier_Advanced_Eldwurm_soul_Slyrak_effect:OnTooltip()
	if self:GetParent():GetHealthPercent()>self.bonus_health_threshold then
		return 0
	end
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()	
	elseif self._tooltip == 2 then
		return self.armor_reduce
	end
end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect:Advanced_GetModifierAttackSpeedPercentage()	
	if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
		return self.bonus_attack_speed
	end
	return 0
end



function modifier_Advanced_Eldwurm_soul_Slyrak_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end






modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15 = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:IsPurgeException() return false end
-- function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:GetTexture() return "soul_of_aethrak" end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:OnCreated(keys)
	local ability = self:GetAbility()
	-- self.bonus_health_threshold = ability:GetSpecialValueFor("bonus_health_threshold")
	-- self.bonus_index = 1
	self.bonus_attack_damage = ability:GetSpecialValueFor("bonus_attack_damage")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.armor_reduce = ability:GetSpecialValueFor("armor_reduce")
	if ability:GetUnlock(1)==1 then
		local stack = math.min(ability:GetStack(),40)
		self.bonus_attack_damage = self.bonus_attack_damage  * (1+stack*0.1)
		self.bonus_attack_speed = self.bonus_attack_speed * (1+stack*0.03)
	end
	if ability:GetSpecialValueFor("advanced_level")>=20 then
		self.bonus_attack_damage = self.bonus_attack_damage +self:GetStackCount()
	end


	if IsServer() then
		if ability:GetSpecialValueFor("advanced_level")>=20 then
			self:SetStackCount(keys.stack)
			self.bonus_attack_damage = self.bonus_attack_damage +self:GetStackCount()
		end
		self.unlock2_time = GameRules:GetGameTime()
		self:StartIntervalThink(0.03)
	end
end

function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:OnIntervalThink()
	--20效果无法通过客户端获取
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/eldwurm_soul_slyrak/ambient/effect_kid/invoker_kid_forge_spirit_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end



function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	

	}
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE)
	end
	return funcs
end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:GetModifierDamageOutgoing_Percentage() 
	if IsClient() then
		return 0
	end
	if 20>=RandomInt(1, 100) then
		return 300
	end
end



function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:GetModifierPreAttack_BonusDamage()	
	-- if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
	local bonus = self.bonus_attack_damage*(1+self:GetStackCount()*0.05)
		-- print("bonus="..bonus)
	return bonus
	-- end
	-- return 0
end

function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:Advanced_GetModifierPhysicalArmorBonus()	
	return -self.armor_reduce
end


function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:OnAttackLanded(keys)
	

	-- if IsClient() then
	-- 	print("gogogogogogogo")
	-- end
	-- self.bonus_index = math.min(self.bonus_index+0.05,2)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	-- if self:GetParent():GetHealthPercent()>self.bonus_health_threshold then
	-- 	return
	-- end
	local ability = self:GetAbility()
	local max = 30
	if not ability then
		return
	end
	self:SetStackCount(math.min(self:GetStackCount()+1,max))
	--self:GetParent():IsIllusion()
	if not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if keys.target:IsMagicImmune() then
		return
	end
	-- if self:GetParent():GetHealthPercent()<=self.bonus_health_threshold then
	local caster = self:GetCaster()

	keys.target:AddNewModifier(caster, ability, "modifier_Advanced_Eldwurm_soul_Slyrak_debuff", {duration = 5})
	if ability.unlock2 then
		if GameRules:GetGameTime()>=self.unlock2_time and 10>=RandomInt(1, 100)  then
			self.unlock2_time = GameRules:GetGameTime() +2
			local projectile_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
			local projectile_distance = keys.attacker:Script_GetAttackRange()+200
			local projectile_start_radius = 135
			local projectile_end_radius = 250
			local projectile_speed = 1050
			local projectile_direction = keys.target:GetOrigin() - keys.attacker:GetOrigin()
			projectile_direction.z = 0
			projectile_direction = projectile_direction:Normalized()
			-- create projectile
			keys.attacker:EmitSound("Hero_DragonKnight.BreathFire")
			local info = {
				Source = keys.attacker,
				Ability = ability,
				vSpawnOrigin = keys.attacker:GetAbsOrigin(),
				
				bDeleteOnHit = false,
				
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				
				EffectName = projectile_name,
				fDistance = projectile_distance,
				fStartRadius = projectile_start_radius,
				fEndRadius =projectile_end_radius,
				vVelocity = projectile_direction * projectile_speed,
			}
			local particle = ProjectileManager:CreateLinearProjectile(info)
			ability.active_proj[particle] = {
				count = 0,
				damage = keys.attacker:GetAverageTrueAttackDamage(nil)*2
		
			}
		end
		
	end


end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end

function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:OnTooltip()

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierAttackSpeedPercentage()	
	elseif self._tooltip == 2 then
		return self.armor_reduce
	end
end
function modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15:Advanced_GetModifierAttackSpeedPercentage()	
	return self.bonus_attack_speed
end






modifier_Advanced_Eldwurm_soul_Slyrak_debuff = advanced_modifier({})

function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:IsDebuff() return true end
function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:IsHidden() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:IsPurgable() return true end


function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	self.reduce = -self.ability:GetSpecialValueFor("armor_reduce")*0.1
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self.max = 10
		if self:GetAbility().advanced_level>=5 then
			self.max = 16
		end
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		

		if self:GetStackCount()>= (self.max) then
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

function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:OnIntervalThink()
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




function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:Advanced_GetModifierPhysicalArmorBonus() return self.reduce*self:GetStackCount() end



function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:OnTooltip()
	return self.reduce*self:GetStackCount() 
end
function modifier_Advanced_Eldwurm_soul_Slyrak_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end


modifier_Advanced_Eldwurm_soul_Slyrak_unlock1 = modifier_Advanced_Eldwurm_soul_Slyrak_unlock1 or class({})

function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsDebuff() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsHidden() return true end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsPurgable() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:IsPurgeException() return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:OnCreated()
	local ability = self:GetAbility()
	-- local stack = ability:GetStack()
	-- if stack>=40 then
	-- 	self.no = true
	-- 	return
	-- end
	ability:AddStack()
end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock1:OnDestroy()
	-- if self.no then
	-- 	return
	-- end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	ability:ReduceStack()
end




modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff = class({})

function modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff:IsDebuff()			return true end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff:IsHidden() 			return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff:IsPurgable() 			return false end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff:IsPurgeException() 	return false end  
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff:DeclareFunctions() return {
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
 } end
function modifier_Advanced_Eldwurm_soul_Slyrak_unlock2_debuff:GetModifierDamageOutgoing_Percentage() 
	return -20 
end


