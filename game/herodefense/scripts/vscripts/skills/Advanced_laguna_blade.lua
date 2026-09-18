--特效优化 √
LinkLuaModifier("modifier_Advanced_laguna_blade", "skills/Advanced_laguna_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_laguna_blade_buff", "skills/Advanced_laguna_blade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_laguna_blade_passive", "skills/Advanced_laguna_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_laguna_blade_passive_handler", "skills/Advanced_laguna_blade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_laguna_blade_talent_debuff", "skills/Advanced_laguna_blade", LUA_MODIFIER_MOTION_NONE)


Advanced_laguna_blade			= Advanced_laguna_blade or class({})


function Advanced_laguna_blade:UnlockFirstCore(key)
	return true
end
function Advanced_laguna_blade:UnlockSecondCore(key)

	return true
end
function Advanced_laguna_blade:UnlockThirdCore(key)

	self.spirits_num_spirits		= 0
	self.spirits_movementFactor				= 1	
	self.spirits_spiritsSpawned		= {}
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_laguna_blade_passive",{})
	return true
end
function Advanced_laguna_blade:CheckKV(key)
	local table = {

	


		damage = 60,
		bonus_damage = 0.5,



	}
	local value = table[key] or -1
	return value

end


function Advanced_laguna_blade:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/laguna_blade_ball/laguna_blade_ball.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/laguna_blade/efect2/effect.vpcf", context )

	
end



function Advanced_laguna_blade:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	self:GetCaster():EmitSound("Ability.LagunaBladeImpact")
	local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_lina_2")
	if ability then
		if ability:IsCooldownReady() then
			local cooldown = self:GetCooldownTimeRemaining()
			self:EndCooldown()
			ability:StartCooldown(cooldown*0.5)
		end
	else
		if target:TriggerSpellAbsorb(self) then
			return
		end
	end



	local bonus_damage = 0
	local particleName = "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf"
	local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),self:GetAbilityName())
	if type=="ability_particle_7" then
		particleName = "particles/rebuild/spell/laguna_blade/efect2/effect.vpcf"
	end
	if self.unlock2 then

		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, unit in ipairs(heroes) do
			if unit~=caster then
				bonus_damage = bonus_damage + unit:GetDamageMax()
				local head_particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(head_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(head_particle)
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local i = 0
		for _, unit in ipairs(units) do
			if unit:GetDamageMax()>=10 then
				bonus_damage = bonus_damage + unit:GetDamageMax()
				i = i + 1
				if i>=10 then
					break
				end
			end
		end


		particleName = "particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf"
	end



	local head_particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- No reason for this CP besides that I like colours
	-- ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(head_particle)
	
	caster:AddNewModifier(caster, self, "modifier_Advanced_laguna_blade", {
		starting_unit_entindex	= target:entindex(),
		bonus_damage = bonus_damage,
	})
end
function Advanced_laguna_blade:GetIntrinsicModifierName()   return "modifier_Advanced_laguna_blade_buff" end

function Advanced_laguna_blade:GetBehavior()


	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end


	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	
end
function Advanced_laguna_blade:GetCooldown(iLevel)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return 10
		end
		
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function Advanced_laguna_blade:GetManaCost(iLevel)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return 0
		end
		
	end
	return  self.BaseClass.GetManaCost(self,iLevel)
end


function Advanced_laguna_blade:CheckTalent(target)
	local talent = 0
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_lina_2") then
		local magic_res = target:Script_GetMagicalArmorValue(true,self)
		if magic_res>0 then
			talent = magic_res*100
		end
	end

	if talent>0 then
		
		return  target:AddNewModifier(caster, self, "modifier_Advanced_laguna_blade_talent_debuff", {
			duration = 0.1,stack = talent
		})
	end
	return nil

end





modifier_Advanced_laguna_blade= modifier_Advanced_laguna_blade or class({})

function modifier_Advanced_laguna_blade:IsHidden()		return true end
function modifier_Advanced_laguna_blade:IsPurgable()		return false end
function modifier_Advanced_laguna_blade:RemoveOnDeath()	return false end
function modifier_Advanced_laguna_blade:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_laguna_blade:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end
	local ability = self:GetAbility()
	self.advanced_level = ability.advanced_level
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Advanced_laguna_blade_buff")
	local max_bonus_damage_index = 10
	self.sub_damage_index = 0.3
	--LV5解锁神灭直斩
	if self.advanced_level>=5 then
		self.sub_damage_index = 0.5
	end
	--LV10解锁魂匣+
	if self.advanced_level>=10 then
		max_bonus_damage_index = 17
	end
	local max_damage = caster:GetIntellect(false)*max_bonus_damage_index
	local soul_box_bonus = 0
	if ability.unlock2 then
		soul_box_bonus = max_damage
	else
		soul_box_bonus = math.min(50*modifier:GetStackCount(),max_damage)
	end
	self.arc_damage			= ability:GetSpecialValueFor("damage") +(ability:GetSpecialValueFor("bonus_damage"))*self:GetCaster():GetIntellect(false) +soul_box_bonus+keys.bonus_damage

	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	
	if self.current_unit and not  self.current_unit:IsNull() then  
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		if self.advanced_level>=20 then
			local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)
			if ability.unlock1 then
				if #units==1 then
					if  self.current_unit:GetHealth()<=self.arc_damage*3*(caster:GetSpellAmplification(false)+1) then
						TrueKill(caster, self.current_unit, ability)
					else
						local talent_modifier = ability:CheckTalent(self.current_unit)
						ApplyDamage({
							victim 			= self.current_unit,
							damage 			= self.arc_damage*1.5,
							damage_type		= ability:GetAbilityDamageType(),
							damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
							attacker 		= caster,
							ability 		= ability,
							hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
						})
						if talent_modifier then
							talent_modifier:SafeDestroy()
						end
					end
		
				else
					if  self.current_unit:GetHealth()<=self.arc_damage*2*(caster:GetSpellAmplification(false)+1) then
						TrueKill(caster, self.current_unit, ability)
					else
						local talent_modifier = ability:CheckTalent(self.current_unit)
						ApplyDamage({
							victim 			= self.current_unit,
							damage 			= self.arc_damage,
							damage_type		= ability:GetAbilityDamageType(),
							damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
							attacker 		= caster,
							ability 		= ability,
							hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
						})
						if talent_modifier then
							talent_modifier:SafeDestroy()
						end
					end
				end
			else
				if #units==1 then
					local talent_modifier = ability:CheckTalent(self.current_unit)
					ApplyDamage({
						victim 			= self.current_unit,
						damage 			= self.arc_damage*1.5,
						damage_type		= ability:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= caster,
						ability 		= ability,
						hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
					})
					if talent_modifier then
						talent_modifier:SafeDestroy()
					end
				else
					local talent_modifier = ability:CheckTalent(self.current_unit)
					ApplyDamage({
						victim 			= self.current_unit,
						damage 			= self.arc_damage,
						damage_type		= ability:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= caster,
						ability 		= ability,
						hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
					})
					if talent_modifier then
						talent_modifier:SafeDestroy()
					end
				end
			end
		else
			local talent_modifier = ability:CheckTalent(self.current_unit)
			ApplyDamage({
				victim 			= self.current_unit,
				damage 			= self.arc_damage,
				damage_type		= ability:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= caster,
				ability 		= ability,
				hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
			})
			if talent_modifier then
				talent_modifier:SafeDestroy()
			end
		end
		
		
		if self.current_unit:GetHealth()<=0 then
			modifier:IncrementStackCount()
		end
		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), self.current_unit:GetAbsOrigin(), nil, 150,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

		local damageTable = {
			-- victim = enemy,
			attacker = caster,
			damage = self.arc_damage*self.sub_damage_index ,
			damage_type =  ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
			
		}
		--解锁第一奥义时看血量造成即死

		if ability.unlock1 then
			for _, enemy in pairs(tTargets) do
				if enemy~=self.current_unit then
					if  self.current_unit:GetHealth()<=(self.arc_damage*self.sub_damage_index*2*(caster:GetSpellAmplification(false)+1)) then
						TrueKill(caster, enemy, ability)
					else
						damageTable.victim = enemy
						local talent_modifier = ability:CheckTalent(enemy)
						ApplyDamage(damageTable)
						if talent_modifier then
							talent_modifier:SafeDestroy()
						end
					end
	
					if enemy:GetHealth()<=0 then
						modifier:IncrementStackCount()
					end
				end
			
			end
	
		else
			for _, enemy in pairs(tTargets) do
				if enemy~=self.current_unit then
					damageTable.victim = enemy
					local talent_modifier = ability:CheckTalent(enemy)
					ApplyDamage(damageTable)
					if talent_modifier then
						talent_modifier:SafeDestroy()
					end
					if enemy:GetHealth()<=0 then
						modifier:IncrementStackCount()
					end
				end
			
			end
		end

	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()
	self.jump_count			= 0
	self.jump_delay			= 0
	if self.advanced_level>=15 then
		self.jump_count = 6
		self:StartIntervalThink(self.jump_delay)
	end
	
end

function modifier_Advanced_laguna_blade:OnIntervalThink()
	local caster = self:GetCaster()

	local ability = self:GetAbility()
	local particleName = "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf"
	
	if ability.unlock2 then
		particleName = "particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf"
	else
		local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),ability:GetAbilityName())
		if type=="ability_particle_7" then
			particleName = "particles/rebuild/spell/laguna_blade/efect2/effect.vpcf"
		end

	end
	local modifier = caster:FindModifierByName("modifier_Advanced_laguna_blade_buff")
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)
	for _, enemy in pairs(units) do
		if not self.units_affected[enemy]  and enemy ~= self.current_unit and enemy ~= self.previous_unit and not self.current_unit:IsNull() then
			enemy:EmitSound("Ability.LagunaBladeImpact")
			
			self.lightning_particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			-- ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(0, 0, 100))  
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
			
			
			self.previous_unit						= self.current_unit
			self.current_unit						= enemy
			

			self.pos = self.current_unit:GetAbsOrigin()
            self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
            self.unit_counter						= self.unit_counter + 1
		
			local damageTable = {
				victim 			= self.current_unit,
				damage 			= self.arc_damage,
				damage_type		= ability:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= caster,
				ability 		= ability,
				hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
			}
		
			

			if ability.unlock1 then
				if  self.current_unit:GetHealth()<=self.arc_damage*(caster:GetSpellAmplification(false)+1) then
					TrueKill(caster, self.current_unit, ability)
				else
					local talent_modifier = ability:CheckTalent(self.current_unit)
					ApplyDamage(damageTable)
					if talent_modifier then
						talent_modifier:SafeDestroy()
					end

				end
			else
				local talent_modifier = ability:CheckTalent(self.current_unit)
				ApplyDamage(damageTable)
				if talent_modifier then
					talent_modifier:SafeDestroy()
				end
			end
			

			if self.current_unit:GetHealth()<=0 then
				modifier:IncrementStackCount()
			end
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), self.current_unit:GetAbsOrigin(), nil, 150,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
			damageTable.damage = self.arc_damage*self.sub_damage_index
			if ability.unlock1 then
				for _, enemy in pairs(tTargets) do
					if enemy~=self.current_unit and enemy:GetHealth()>0 then
						if enemy:GetHealth()<=self.arc_damage*self.sub_damage_index*(caster:GetSpellAmplification(false)+1) then
							TrueKill(caster, enemy, ability)
						else
							damageTable.victim = enemy
							local talent_modifier = ability:CheckTalent(enemy)
							ApplyDamage(damageTable)
							if talent_modifier then
								talent_modifier:SafeDestroy()
							end
						end
						
						if enemy:GetHealth()<=0 then
							modifier:IncrementStackCount()
						end
					end
				
				end

			else
				for _, enemy in pairs(tTargets) do
					if enemy~=self.current_unit and enemy:GetHealth()>0 then
						damageTable.victim = enemy
						local talent_modifier = ability:CheckTalent(enemy)
						ApplyDamage(damageTable)
						if talent_modifier then
							talent_modifier:SafeDestroy()
						end
						if enemy:GetHealth()<=0 then
							modifier:IncrementStackCount()
						end
					end
				
				end

			end
	
			

			

			if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
				self:StartIntervalThink(-1)
				self:SafeDestroy()
			end
			return
		end
	end
	--区域内没有符合的单位了 就去除
	self:SafeDestroy()


end




modifier_Advanced_laguna_blade_buff = class({})


function modifier_Advanced_laguna_blade_buff:IsBuff()				return true end
function modifier_Advanced_laguna_blade_buff:IsPurgable()     	return false end
function modifier_Advanced_laguna_blade_buff:IsPurgeException() 	return false end
function modifier_Advanced_laguna_blade_buff:IsHidden()			return false end
function modifier_Advanced_laguna_blade_buff:RemoveOnDeath()			return false end












modifier_Advanced_laguna_blade_passive = class({})

function modifier_Advanced_laguna_blade_passive:IsDebuff()			return false end
function modifier_Advanced_laguna_blade_passive:IsHidden() 			return true end
function modifier_Advanced_laguna_blade_passive:IsPurgable() 		return false end
function modifier_Advanced_laguna_blade_passive:IsPurgeException() 	return false end
function modifier_Advanced_laguna_blade_passive:RemoveOnDeath() return false end
function modifier_Advanced_laguna_blade_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_Advanced_laguna_blade_passive:OnCreated(params)
	if IsServer() then
		self.start_time 				= GameRules:GetGameTime()
		self.spirit_summon_interval 	= 0.5
		self.max_spirits				= 3
		self.collision_radius			= 0
		self.explosion_radius			= 0
		self.spirit_radius 				= 0
		self.spirit_min_radius			= 80
		self.spirit_max_radius			= 200
		self.spirit_movement_rate 		= 50
		self.spirit_turn_rate			= 60




		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	

		self:StartIntervalThink(0.03)
	end
end

function modifier_Advanced_laguna_blade_passive:OnIntervalThink()
	if IsServer() then
		local caster 					= self:GetCaster()
		local caster_position 			= caster:GetAbsOrigin()
		local ability 					= self:GetAbility()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval




		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)

		if ability.spirits_num_spirits < idealNumSpiritsSpawned then

			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_dota_wisp_spirit", caster_position, false, caster, caster, caster:GetTeam())


			local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/laguna_blade_ball/laguna_blade_ball.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			newSpirit.spirit_pfx = pfx
	

			
			--增加数量记录
			local spiritIndex = ability.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			ability.spirits_num_spirits = spiritIndex
			ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(
				caster, 
				ability, 
				"modifier_Advanced_laguna_blade_passive_handler", 
				{ 
					duraiton 			= -1,
					tinkerval 			= 360 / self.spirit_turn_rate / self.max_spirits,

				}
			)
		end
		
		--------------------------------------------------------------------------------
		-- Update the radius
		--------------------------------------------------------------------------------
		local currentRadius	= self.spirit_radius

		local deltaRadius 	= ability.spirits_movementFactor * self.spirit_movement_rate * 0.03
		currentRadius 		= currentRadius + deltaRadius
		-- currentRadius 		= math.min( math.max( currentRadius, self.spirit_min_radius ), self.spirit_max_radius )
		if currentRadius<= self.spirit_min_radius then
			ability.spirits_movementFactor = 1
		end
		if currentRadius>= self.spirit_max_radius then
			ability.spirits_movementFactor = -1
		end
		self.spirit_radius 	= currentRadius


		--------------------------------------------------------------------------------
		-- Update the spirits' positions
		--------------------------------------------------------------------------------
		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset	= 360 / self.max_spirits
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				numSpiritsAlive = numSpiritsAlive + 1

				-- Rotate
				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos 		= Vector(0, currentRadius, 0)
				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)

				spirit:SetAbsOrigin(absPos)

				-- Update particle... switch particle depending on currently active effect. 
				-- the dealy is needed since it takes 0.3s for spirits to fade in.
				
				
				-- if spirit.spirit_pfx then
				-- 	spirit.currentRadius = Vector(currentRadius, 0, 0)
				-- 	ParticleManager:SetParticleControl(spirit.spirit_pfx, 1, Vector(currentRadius, 0, 0))
				-- end
			end
		end


	end
end








modifier_Advanced_laguna_blade_passive_handler = class({})
function modifier_Advanced_laguna_blade_passive_handler:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
	}

	return state
end

function modifier_Advanced_laguna_blade_passive_handler:OnCreated(params)
	if IsServer() then

		self.cooldownTime = GameRules:GetGameTime()
		self.currentRadius = 150
		self:StartIntervalThink(0.2)
	end
end

function modifier_Advanced_laguna_blade_passive_handler:OnIntervalThink()
	if IsServer() then 
		local spirit = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			if spirit.spirit_pfx~= nil then
				ParticleManager:DestroyParticle(spirit.spirit_pfx, true)
			end
			spirit:ForceKill( true )
			return
		end
		if not caster:IsAlive() or caster:IsSilenced() then
			return
		end
		if GameRules:GetGameTime()>=self.cooldownTime then
			if spirit.spirit_pfx then
				self.currentRadius = math.min(150,self.currentRadius+15)
				ParticleManager:SetParticleControl(spirit.spirit_pfx,61, Vector(self.currentRadius, 0, 0))
			end
			local units = FindUnitsInRadius(
				caster:GetTeam(),
				spirit:GetAbsOrigin(), 
				nil, 
				1000, 
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false
			)
	
			for i, unit in ipairs(units) do
				self.cooldownTime =  GameRules:GetGameTime() + ability:GetCooldown(ability:GetLevel())* caster:GetCooldownReduction()
				if spirit.spirit_pfx then
					self.currentRadius = 0
					ParticleManager:SetParticleControl(spirit.spirit_pfx,61, Vector(self.currentRadius, 0, 0))
				end
				local particleName = "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf"
				local type = particleManager:GetSpellParticle(caster:GetPlayerOwnerID(),ability:GetAbilityName())
				if type=="ability_particle_7" then
					particleName = "particles/rebuild/spell/laguna_blade/efect2/effect.vpcf"
				end
				local head_particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(head_particle, 0, spirit, PATTACH_POINT_FOLLOW, nil, spirit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(head_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(head_particle)
				spirit:EmitSound("Ability.LagunaBladeImpact")
				local modifier = caster:FindModifierByName("modifier_Advanced_laguna_blade_buff")
				local max_damage = caster:GetIntellect(false)*12
				local soul_box_bonus = math.min(30*modifier:GetStackCount(),max_damage)
				local arc_damage			= ability:GetSpecialValueFor("damage") +(ability:GetSpecialValueFor("bonus_damage"))*self:GetCaster():GetIntellect(false) +soul_box_bonus
				
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = arc_damage,
					damage_type =  ability:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = ability, --Optional.
					hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
				}
				local talent_modifier = ability:CheckTalent(unit)
				ApplyDamage(damageTable)
				if talent_modifier then
					talent_modifier:SafeDestroy()
				end
				if unit:GetHealth()<=0 then
					modifier:IncrementStackCount()
				end
				if i>=2 then
					break
				end
			end
		
		
		end





	end
end


function modifier_Advanced_laguna_blade_passive_handler:OnRemoved()
	if IsServer() then
		local spirit	= self:GetParent()
		if spirit.spirit_pfx~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx, true)
		end
		spirit:ForceKill( true )
	end
end







modifier_Advanced_laguna_blade_talent_debuff = class({})

function modifier_Advanced_laguna_blade_talent_debuff:IsDebuff()			return true end
function modifier_Advanced_laguna_blade_talent_debuff:IsHidden() 			return true end
function modifier_Advanced_laguna_blade_talent_debuff:IsPurgable() 		return false end
function modifier_Advanced_laguna_blade_talent_debuff:IsPurgeException() 	return false end
function modifier_Advanced_laguna_blade_talent_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end	
function modifier_Advanced_laguna_blade_talent_debuff:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end
function modifier_Advanced_laguna_blade_talent_debuff:GetModifierMagicalResistanceBonus() return -self:GetStackCount() end

