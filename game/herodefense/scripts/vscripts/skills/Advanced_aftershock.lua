--特效优化 √
Advanced_aftershock = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "skills/Advanced_aftershock", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_aftershock", "skills/Advanced_aftershock", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_aftershock_buff", "skills/Advanced_aftershock", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_aftershock_unlock1_effect", "skills/Advanced_aftershock", LUA_MODIFIER_MOTION_NONE )

-- Passive Modifier
function Advanced_aftershock:GetIntrinsicModifierName()
	return "modifier_Advanced_aftershock"
end
function Advanced_aftershock:GetCastRange(vLocation, hTarget)
	-- if IsClient() then
	-- 	if self.custom_indicator then
	-- 		-- register cursor position
	-- 		local vLoc = self:GetCaster():GetAbsOrigin()
	-- 		self.custom_indicator:Register( vLoc,1 ,1)
	-- 		-- print("diao yong")
	-- 	end
	-- 	if self.custom_indicator_b then
	-- 		-- register cursor position
	-- 		local vLoc = self:GetCaster():GetAbsOrigin()
	-- 		self.custom_indicator_b:Register( vLoc,1 ,1)
	-- 		-- print("diao yong")
	-- 	end
	-- end
	return self:GetSpecialValueFor("radius")
end

function Advanced_aftershock:CheckKV(key)
	local table = {
		damage = 10,
		bonus_damage = 0.04,


	}
	local value = table[key] or -1
	return value

end


function Advanced_aftershock:UnlockFirstCore(key)
	
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_aftershock_unlock1_effect",{})
	return true
end
function Advanced_aftershock:UnlockSecondCore(key)
	return true
end
function Advanced_aftershock:UnlockThirdCore(key)
	return true
end

function Advanced_aftershock:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/aftershock/unlock2.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf", context )

	


end




modifier_Advanced_aftershock = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_aftershock:IsHidden()	return true end
function modifier_Advanced_aftershock:IsPurgable() 		return false end
function modifier_Advanced_aftershock:IsPurgeException() 	return false end
function modifier_Advanced_aftershock:RemoveOnDeath()  return false end


function modifier_Advanced_aftershock:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_Advanced_aftershock:OnAbilityFullyCast( params )
	if IsServer() then
		if params.ability:IsItem() then return end
		local cooldown = params.ability:GetCooldown(params.ability:GetLevel())
		if cooldown <= 1 then
			return
		end
		-- local ability = self:GetAbility()
		-- local advanced_level = ability.advanced_level
		local StartCooldDown = not self:GetAbility().unlock3
		if params.unit~=self:GetParent() then 
			self:Trigger(2,cooldown,params.unit,StartCooldDown)
			return 
		else --自身触发
			local cooldown = params.ability:GetCooldown(params.ability:GetLevel())
			if cooldown <= 1 then
				return
			end
			self:Trigger(1,cooldown,self:GetCaster(),StartCooldDown)

		end

	end
end

function modifier_Advanced_aftershock:Trigger(type,cooldown,unit,Gocooldown)
	local ability = self:GetAbility()
	local advanced_level = ability.advanced_level
	local caster = self:GetCaster()
	local particle = "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"
	if ability.unlock1 then
		particle =  "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf"
	elseif ability.unlock2 then
		particle =  "particles/rebuild/spell/aftershock/unlock2.vpcf"
	elseif ability.unlock3 then
		particle =  "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf"
	else

		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_earthshaker_2") then
			particle = "particles/rebuild/spell/after_shock/talent2/effect.vpcf"
			caster:EmitSound("Hero_EarthShaker.BlinkLayer")
		end
	end
	if type==1 or type==3 then
		local index= math.min(1,cooldown/10)
		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_earthshaker_2") then
			if cooldown>=2 then
				index = 1
			end
		
		end
		-- Find enemies in radius
		local unitTable = {}

		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage")+(caster:GetStrength())*ability:GetSpecialValueFor("bonus_damage")
		local duration = ability:GetSpecialValueFor("duration")*index
		if type==3 then
			duration = 0.2
		end
		local count = 1  --共鸣触发次数
		local buff_duration = 2
		if advanced_level>=5 then
			count = count +1
			radius = radius+100
			if advanced_level>=10 then
				buff_duration = buff_duration+1
			end
		end
		if ability.unlock2 then
			radius = radius +300
		end
		damage =damage *index
		local modifier = caster:FindModifierByName("modifier_Advanced_aftershock_buff")
		if modifier then
			local index = modifier:GetStackCount()*0.15+1
			damage = damage*index
			duration = duration * index
		end
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		local damagetable= {
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability,
			}

		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		
		for _,enemy in pairs(enemies) do
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster,ability,"modifier_stunned",{ duration = duration*StatusResistance })
			damagetable.victim = enemy
			ApplyDamage(damagetable)
			unitTable[enemy] = true
		end

		local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		--共鸣触发
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			FIND_FARTHEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		local i = 0
		for _, unit in ipairs(units) do  
			if unit~=caster then
				i = i +1
				local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					unit:GetOrigin(),	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					0,	-- int, flag filter
					0,	-- int, order filter
					false	-- bool, can grow cache
				)
				for _,enemy in pairs(enemies) do
					if	not unitTable[enemy] then
						local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
						enemy:AddNewModifier(caster,ability,"modifier_stunned",{ duration = duration*StatusResistance })
						damagetable.victim = enemy
						ApplyDamage(damagetable)
						unitTable[enemy] = true
					end

				end

				local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
				ParticleManager:ReleaseParticleIndex( effect_cast )
				if i>=count then
					break
				end
			end
		end
		if ability.unlock2 then
			self:BonusRandomTrigger(caster,damage,radius,duration)
		end

		caster:AddNewModifier(caster,ability,"modifier_Advanced_aftershock_buff",{ duration = buff_duration })
	elseif type==2 or type==4 then
		local currentCooldown = ability:GetCooldownTimeRemaining()
		if unit:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			if advanced_level>=15 and currentCooldown<10 then
				local dis = CalculateDistance(unit,self:GetParent())
				if dis>1000 then
					return
				end
				local index= math.min(1,cooldown/10)
				local caster = self:GetCaster()
				local radius = ability:GetSpecialValueFor("radius")+100
				if ability.unlock2 then
					radius = radius +300
				end
				local damage = ability:GetSpecialValueFor("damage")+(caster:GetStrength())*ability:GetSpecialValueFor("bonus_damage")
				local duration = ability:GetSpecialValueFor("duration")*index
				damage =damage *index
				if type==4 then
					duration = 0.2
				end
				local modifier = caster:FindModifierByName("modifier_Advanced_aftershock_buff")
				if modifier then
					local index = modifier:GetStackCount()*0.15+1
					damage = damage*index
					duration = duration * index
				end
				local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					unit:GetOrigin(),	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					0,	-- int, flag filter
					0,	-- int, order filter
					false	-- bool, can grow cache
				)
		
				local damagetable= {
					attacker = caster,
					damage = damage,
					damage_type = ability:GetAbilityDamageType(),
					ability = ability,
					}
		
				local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
				for _,enemy in pairs(enemies) do
					local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
					enemy:AddNewModifier(caster,ability,"modifier_stunned",{ duration = duration*StatusResistance })
					damagetable.victim = enemy
					ApplyDamage(damagetable)

				end

				local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, unit )
				ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
				ParticleManager:ReleaseParticleIndex( effect_cast )
				
				if ability.unlock2 then
					self:BonusRandomTrigger(caster,damage,radius,duration)
				end
				if Gocooldown then
					ability:StartCooldown(currentCooldown+1.5)
				end
			end
			
		elseif advanced_level>=20 and currentCooldown<10 then
			local dis = CalculateDistance(unit,self:GetParent())
			if dis>500 then
				return
			end
			local index= math.min(1,cooldown/10)
			local caster = self:GetCaster()
			local radius = ability:GetSpecialValueFor("radius")+100
			if ability.unlock2 then
				radius = radius +300
			end
			local damage = ability:GetSpecialValueFor("damage")+(caster:GetStrength())*ability:GetSpecialValueFor("bonus_damage")
			local duration = ability:GetSpecialValueFor("duration")*index
			damage =damage *index
			local modifier = caster:FindModifierByName("modifier_Advanced_aftershock_buff")
			if modifier then
				local index = modifier:GetStackCount()*0.15+1
				damage = damage*index
				duration = duration * index
			end
			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),	-- int, your team number
				unit:GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				0,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)
	
			local damagetable= {
				attacker = caster,
				damage = damage,
				damage_type = ability:GetAbilityDamageType(),
				ability = ability,
				}
	
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			for _,enemy in pairs(enemies) do
				local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				enemy:AddNewModifier(caster,ability,"modifier_stunned",{ duration = duration*StatusResistance })
				damagetable.victim = enemy
				ApplyDamage(damagetable)

			end

			local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW,unit )
			ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
			ParticleManager:ReleaseParticleIndex( effect_cast )
			
			
			if ability.unlock2 then
				self:BonusRandomTrigger(caster,damage,radius,duration)
			end
			if Gocooldown then
				ability:StartCooldown(currentCooldown+2)
			end

		end
	end



end


function modifier_Advanced_aftershock:BonusRandomTrigger(caster,damage,radius,duration)
	local particle = "particles/rebuild/spell/aftershock/unlock2.vpcf"

	local ability = self:GetAbility()
	local pos = caster:GetOrigin()
	for i = 1, 2, 1 do
		local new_pos = pos
		local dir1 = 1
		local dir2 = 1
		if RandomInt(1, 2)==1 then
			dir1 = -1
		end
		if RandomInt(1, 2)==1 then
			dir2 = -1
		end
		new_pos.x = new_pos.x +  dir1 * RandomInt(200, 900)
		new_pos.y = new_pos.y +  dir2 * RandomInt(200, 900)
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		new_pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
		)

		local damagetable= {
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability,
			}

		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		
		for _,enemy in pairs(enemies) do
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster,ability,"modifier_stunned",{ duration = duration*StatusResistance })
			damagetable.victim = enemy
			ApplyDamage(damagetable)
		end

		local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN , nil )
		ParticleManager:SetParticleControl( effect_cast, 0, new_pos)
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end
	
end



modifier_Advanced_aftershock_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_aftershock_buff:IsHidden()	return false end
function modifier_Advanced_aftershock_buff:IsPurgable()	return false end
function modifier_Advanced_aftershock_buff:OnCreated(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_aftershock_buff:OnRefresh(keys)
	if IsServer() then
		local max = 4
		if self:GetAbility().advanced_level>=10 then
			max = 5
		end

		if self:GetStackCount()<max then
			self:IncrementStackCount()
		end
	end
end



modifier_Advanced_aftershock_unlock1_effect = class({})

function modifier_Advanced_aftershock_unlock1_effect:IsDebuff()			return false end
function modifier_Advanced_aftershock_unlock1_effect:IsHidden() 			return true end
function modifier_Advanced_aftershock_unlock1_effect:IsPurgable() 		return false end
function modifier_Advanced_aftershock_unlock1_effect:IsPurgeException() 	return false end
function modifier_Advanced_aftershock_unlock1_effect:RemoveOnDeath() return false end
function modifier_Advanced_aftershock_unlock1_effect:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_aftershock_unlock1_effect:OnCreated()
	if IsServer() then
		self.targetModifier = self:GetParent():FindModifierByName("modifier_Advanced_aftershock")
	end
end

function modifier_Advanced_aftershock_unlock1_effect:Trigger(type,caster)
	if not self.targetModifier or self.targetModifier:IsNull() then
		self.targetModifier = self:GetParent():FindModifierByName("modifier_Advanced_aftershock")
		return
	end

	self.targetModifier:Trigger(type,5,caster,true)
end