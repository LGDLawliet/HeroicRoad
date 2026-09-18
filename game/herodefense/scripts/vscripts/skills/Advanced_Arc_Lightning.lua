
--特效优化 √
LinkLuaModifier("modifier_Advanced_Arc_Lightning", "skills/Advanced_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Arc_Lightning_thinker", "skills/Advanced_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Arc_Lightning_passive", "skills/Advanced_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Arc_Lightning_passive_effect", "skills/Advanced_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
Advanced_Arc_Lightning			= Advanced_Arc_Lightning or class({})


-- function Advanced_Arc_Lightning:GetCastRange(location, target)
-- 	return self.BaseClass.GetCastRange(self, location, target)
-- end

function Advanced_Arc_Lightning:UnlockFirstCore(key)
	return true
end
function Advanced_Arc_Lightning:UnlockSecondCore(key)
	return true
end
function Advanced_Arc_Lightning:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Arc_Lightning_passive",{})
	return true
end
function Advanced_Arc_Lightning:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_rubick_3") then
		return	"rubick/harlequin_icons/rubick_fade_bolt"
	end
	return "zuus_arc_lightning"
end



function Advanced_Arc_Lightning:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning/lightning_rod/f_formation.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning_aoe/arc_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/arc_lightning_continued/arc_lightning.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_fade_bolt_head.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_fade_bolt_impact_burst.vpcf", context )
	
	
end

function Advanced_Arc_Lightning:Spawn()
	self.thinker = {}
end

function Advanced_Arc_Lightning:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_POINT
		elseif coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end

	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AOE
	else 
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end
function Advanced_Arc_Lightning:GetAOERadius()
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if advanced_level>=20 then
		return 600
	else 
		return 0
	end
end

function Advanced_Arc_Lightning:GetManaCost(level)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	local advanced_level = self:GetSpecialValueFor("advanced_level")
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return 70
		elseif coreUnlockKV.coreUnlock ==3 then
			return 70
		end
		
	end
	if advanced_level>=20 then
		return 210
	else 
		return 70
	end
end


function Advanced_Arc_Lightning:OnSpellStart()
	if not IsServer() then
		return
	end
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	if self.unlock1 then
		local target_point 	= self:GetCursorPosition()
		local particleName = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, unit)
		ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, 5000))
		ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y,  target_point.z))
		ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
		ParticleManager:ReleaseParticleIndex(particle)
		target_point.z = target_point.z + 400
		local thinker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_Advanced_Arc_Lightning_thinker", 
			{duration = 70}, -- kv
			target_point,
			caster:GetTeamNumber(),
			false
		)
		-- print(thinker:GetUnitName())
	else
		if not target:TriggerSpellAbsorb(self) then

			local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_rubick_3") then
				head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_fade_bolt_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			end
			ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
			ParticleManager:ReleaseParticleIndex(head_particle)
			
			caster:AddNewModifier(caster, self, "modifier_Advanced_Arc_Lightning", {
				starting_unit_entindex	= target:entindex()
			})
			--LV20解锁魔法二重化
			if self.advanced_level>=20 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
		
				if #enemies>=1 then
					local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
					if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_rubick_3") then
						head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_fade_bolt_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					end
					ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(head_particle, 1, enemies[1], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[1]:GetAbsOrigin(), true)
					-- No reason for this CP besides that I like colours
					ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
			
					ParticleManager:ReleaseParticleIndex(head_particle)
					caster:AddNewModifier(caster, self, "modifier_Advanced_Arc_Lightning", {
						starting_unit_entindex	= enemies[1]:entindex()
					})
				end
			end
		end
	end
	

end
function Advanced_Arc_Lightning:CheckKV(key)
	local table = {
		base_damage = 6,
		bounus_damage = 0.05,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Arc_Lightning:RemoveThinker(thinker)
	self.thinker[thinker] = nil
end
function Advanced_Arc_Lightning:AddThinker(thinker)
	self.thinker[thinker] = self.thinker
end
--------------------------------------
--创建一个可同时存在多个的modifier 记录在施法者身上且死亡不移除
--会将已经影响的单位记录在这个实例中的一个表
modifier_Advanced_Arc_Lightning= modifier_Advanced_Arc_Lightning or class({})

function modifier_Advanced_Arc_Lightning:IsHidden()		return false end
function modifier_Advanced_Arc_Lightning:IsPurgable()		return false end
function modifier_Advanced_Arc_Lightning:RemoveOnDeath()	return false end
function modifier_Advanced_Arc_Lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Arc_Lightning:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	local ability = self:GetAbility()
	self.advanced_level = ability.advanced_level
	self.arc_damage			= ability:GetSpecialValueFor("base_damage") +(ability:GetSpecialValueFor("bounus_damage"))*self:GetCaster():GetIntellect(false)
	self.radius				= ability:GetSpecialValueFor("radius")
	self.jump_count			= ability:GetSpecialValueFor("jump_count")
	self.jump_delay			= ability:GetSpecialValueFor("jump_delay")
	if ability.unlock1 then
		self.jump_delay	 = 1
	end
	self.bonus_count = 0
	self.no_cost_chance = 12
	self.bonus_damage_per_damage = 1.03
	--LV5解锁闪电充能+
	if self.advanced_level>=5 then
		self.no_cost_chance = 20
	end
	--LV10解锁闪电蓄能+
	if self.advanced_level>=10 then
		self.bonus_damage_per_damage = 1.05
	end
	--LV15解锁取消极限
	if self.advanced_level>=15 then
		self.jump_count = self.jump_count+5
		if ability.unlock2 then
			self.jump_count = 4
		end
	end


	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit and not self.current_unit:IsNull() then  
		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
		-- self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		--如果对避雷针释放则不造成伤害
		if not self.current_unit:HasModifier("modifier_Advanced_Arc_Lightning_thinker") then
			if not (self.no_cost_chance>=RandomInt(1, 100)) then

				self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
			end
			
			
			self:CauseDamage(self.current_unit)
			

		end
		local talent = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_rubick_3")
		if talent then
			talent:SetStackCount(talent:GetStackCount() + 1)
			if talent:GetStackCount() >= talent:GetAbility():GetSpecialValueFor("line") then
				for i=0, self:GetParent():GetAbilityCount() - 1 do
					local Ability = self:GetParent():GetAbilityByIndex(i)
					if Ability ~= nil  and not Ability:IsCooldownReady() then
						if Ability:IsRefreshable() then
							local newCooldown = math.max(Ability:GetCooldownTimeRemaining() - talent:GetAbility():GetSpecialValueFor("cd_reduce"), 0)
							Ability:EndCooldown()
							if newCooldown > 0 then
								Ability:StartCooldown(newCooldown)
							end
						elseif talent:GetAbility():IsCooldownReady() then
							local newCooldown = math.max(Ability:GetCooldownTimeRemaining() - talent:GetAbility():GetSpecialValueFor("cd_reduce"), 0)
							Ability:EndCooldown()
							if newCooldown > 0 then
								Ability:StartCooldown(newCooldown)
							end
							talent:GetAbility():UseResources(true, true, true, true)
						end
						talent:SetStackCount(0)
						break
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
	self.arc_damage = self.arc_damage *self.bonus_damage_per_damage
	self.bonus_count = self.bonus_count +1
	self:StartIntervalThink(self.jump_delay)
end

function modifier_Advanced_Arc_Lightning:OnIntervalThink()

	if not self.current_unit or self.current_unit:IsNull() then
		self:SafeDestroy()
		return
	end
	
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	
	local ability = self:GetAbility()
	for _, enemy in pairs(units) do
		if not self.units_affected[enemy]  and enemy ~= self.current_unit and enemy ~= self.previous_unit then
			enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
			self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			local talent = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_rubick_3")
			if talent then
				self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_fade_bolt_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			end
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(0, 0, 100))  
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
			self.previous_unit						= self.current_unit
			self.current_unit						= enemy

			self.pos = self.current_unit:GetAbsOrigin()
			if  not (self.no_cost_chance>=RandomInt(1, 100)) then
				self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
				self.unit_counter						= self.unit_counter + 1
			end
		

			self:CauseDamage(enemy)


			if self.bonus_count<7 then
				self.bonus_count = self.bonus_count +1
				self.arc_damage = self.arc_damage *self.bonus_damage_per_damage
			end
			local talent = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_rubick_3")
			talent:SetStackCount(talent:GetStackCount() + 1)
			if talent:GetStackCount() >= talent:GetAbility():GetSpecialValueFor("line") then
				for i=0, self:GetParent():GetAbilityCount() - 1 do
					local Ability = self:GetParent():GetAbilityByIndex(i)
					if Ability ~= nil  and not Ability:IsCooldownReady() then
						if Ability:IsRefreshable() then
							local newCooldown = math.max(Ability:GetCooldownTimeRemaining() - talent:GetAbility():GetSpecialValueFor("cd_reduce"), 0)
							Ability:EndCooldown()
							if newCooldown > 0 then
								Ability:StartCooldown(newCooldown)
							end
						elseif talent:GetAbility():IsCooldownReady() then
							local newCooldown = math.max(Ability:GetCooldownTimeRemaining() - talent:GetAbility():GetSpecialValueFor("cd_reduce"), 0)
							Ability:EndCooldown()
							if newCooldown > 0 then
								Ability:StartCooldown(newCooldown)
							end
							talent:GetAbility():UseResources(true, true, true, true)
						end
						talent:SetStackCount(0)
						break
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
	--避雷针效果 搜寻避雷针进行弹射
	if ability.unlock1 then
		local thinkers = Entities:FindAllByClassnameWithin("npc_dota_thinker", self.pos, self.radius)
		for _, unit in ipairs(thinkers) do
			if unit:HasModifier("modifier_Advanced_Arc_Lightning_thinker") then
				if unit ~= self.current_unit and unit ~= self.previous_unit then
					unit:EmitSound("Hero_Zuus.ArcLightning.Target")
					--避雷针没有附着点且需要改变特效点的高度
					if self.current_unit:GetClassname()=="npc_dota_thinker" then
						local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
					
						ParticleManager:SetParticleControlEnt(head_particle, 0,unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
						local pos = self.current_unit:GetAbsOrigin()
						pos.z = pos.z -400
						ParticleManager:SetParticleControl( head_particle, 1, pos  )

						ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
						ParticleManager:ReleaseParticleIndex(head_particle)
					else
						local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)

						ParticleManager:SetParticleControlEnt(head_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(head_particle, 1, unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
						ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
						ParticleManager:ReleaseParticleIndex(head_particle)
					end

					self.previous_unit						= self.current_unit
					self.current_unit						= unit
		
					self.pos = self.current_unit:GetAbsOrigin()
					if not(self.no_cost_chance>=RandomInt(1, 100)) then

						self.unit_counter						= self.unit_counter + 1
					end
				
	
					if self.bonus_count<7 then
						self.bonus_count = self.bonus_count +1
						self.arc_damage = self.arc_damage *self.bonus_damage_per_damage
					end
					
					if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
						self:StartIntervalThink(-1)
						self:SafeDestroy()
					end
					return
				end
			end
		end
	end

	-- print("------------------------------")
	-- for key, value in pairs(ability.thinker) do
	-- 	PrintTable(value)
	-- end
	-- print("------------------------------")
	--区域内没有符合的单位了 就去除
	self:SafeDestroy()



end


function modifier_Advanced_Arc_Lightning:CauseDamage(target)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local damage_table ={
		victim 			= target,
		damage 			= self.arc_damage,
		damage_type		= ability:GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= caster,
		ability 		= ability,
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	if ability.unlock2 then
		
		local pfx_aoe = ParticleManager:CreateParticle("particles/rebuild/spell/arc_lightning_aoe/arc_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_aoe, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx_aoe, 2, Vector(300, 300, 300))
		ParticleManager:ReleaseParticleIndex(pfx_aoe)
		local unit = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i=1, #unit do
			local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, unit[i]:GetAttachmentOrigin(unit[i]:ScriptLookupAttachment("attach_hitloc")))
			ParticleManager:ReleaseParticleIndex(pfx)
			damage_table.victim = unit[i]
			ApplyDamage(damage_table)
			unit[i]:EmitSound("Hero_Zuus.StaticField")
		end
	else
		ApplyDamage(damage_table)
	end
end


modifier_Advanced_Arc_Lightning_thinker= modifier_Advanced_Arc_Lightning_thinker or class({})

function modifier_Advanced_Arc_Lightning_thinker:IsHidden()		return true end
function modifier_Advanced_Arc_Lightning_thinker:IsPurgable()		return false end
function modifier_Advanced_Arc_Lightning_thinker:RemoveOnDeath()	return false end
function modifier_Advanced_Arc_Lightning_thinker:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		ability:AddThinker(self:GetParent())
		self.count = 0
		local particle_cast = "particles/rebuild/spell/arc_lightning/lightning_rod/f_formation.vpcf"


		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN  , self:GetCaster() )
		local pos = self:GetParent():GetOrigin()
		pos.z = pos.z -400
		ParticleManager:SetParticleControl( effect_cast, 0, pos )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 10, 0, 0 ) )
		ParticleManager:SetParticleControl( effect_cast, 2, Vector(self:GetRemainingTime(), 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Arc_Lightning_thinker:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability then
			ability:RemoveThinker(self:GetParent())
		end
		UTIL_Remove( self:GetParent() )
	end
end



--每秒搜寻，如果有敌人则对敌人释放 如果没有敌人则找避雷针释放 但对象不能是自己
function modifier_Advanced_Arc_Lightning_thinker:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster:IsAlive() or not ability then
		return
	end
	local search_radius = 1000
	local pass = true
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	for _, unit in ipairs(enemies) do

		-- local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	
		-- ParticleManager:SetParticleControlEnt(head_particle, 0,unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
		-- local pos = self.current_unit:GetAbsOrigin()
		-- pos.z = pos.z -400
		-- ParticleManager:SetParticleControl( head_particle, 1, pos  )

		-- ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
		-- ParticleManager:ReleaseParticleIndex(head_particle)


		-- local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		-- ParticleManager:SetParticleControlEnt(head_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(head_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
		-- ParticleManager:ReleaseParticleIndex(head_particle)

		local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

		ParticleManager:SetParticleControlEnt(head_particle, 0,unit, PATTACH_POINT_FOLLOW,  "attach_hitloc", unit:GetAbsOrigin(), true)
		local pos = parent:GetAbsOrigin()
		pos.z = pos.z -400
		ParticleManager:SetParticleControl( head_particle, 1, pos  )

		ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
		ParticleManager:ReleaseParticleIndex(head_particle)

		parent:EmitSound("Hero_Zuus.ArcLightning.Cast")
		local modifier = caster:AddNewModifier(caster, ability, "modifier_Advanced_Arc_Lightning", {
			starting_unit_entindex	= unit:entindex()
		})
		modifier.previous_unit = parent
		
		self.count = self.count +1
		pass = false
		break
	end
	if pass then
		local thinkers = Entities:FindAllByClassnameWithin("npc_dota_thinker", parent:GetAbsOrigin(),  search_radius)
		for _, unit in ipairs(thinkers) do
			if unit:HasModifier("modifier_Advanced_Arc_Lightning_thinker") then
				if unit~=parent then
					-- local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
					-- ParticleManager:SetParticleControlEnt(head_particle, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControlEnt(head_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					-- ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
					-- ParticleManager:ReleaseParticleIndex(head_particle)
					local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

					ParticleManager:SetParticleControlEnt(head_particle, 0,unit, PATTACH_POINT_FOLLOW, nil, unit:GetAbsOrigin(), true)
					local pos = parent:GetAbsOrigin()
					pos.z = pos.z -400
					ParticleManager:SetParticleControl( head_particle, 1, pos  )

					ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
					ParticleManager:ReleaseParticleIndex(head_particle)


					parent:EmitSound("Hero_Zuus.ArcLightning.Cast")
					local modifier = caster:AddNewModifier(caster, ability, "modifier_Advanced_Arc_Lightning", {
						starting_unit_entindex	= unit:entindex()
					})
					modifier.previous_unit = parent
					
					self.count = self.count +1
					break
				end
			
			end
		end
	end



	if self.count>=3 then
		self:StartIntervalThink(-1)
	end


end








modifier_Advanced_Arc_Lightning_passive = class({})

function modifier_Advanced_Arc_Lightning_passive:IsDebuff()			return false end
function modifier_Advanced_Arc_Lightning_passive:IsHidden() 			return true end
function modifier_Advanced_Arc_Lightning_passive:IsPurgable() 		return false end
function modifier_Advanced_Arc_Lightning_passive:IsPurgeException() 	return false end
function modifier_Advanced_Arc_Lightning_passive:RemoveOnDeath() return false end
function modifier_Advanced_Arc_Lightning_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Arc_Lightning_passive:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_Arc_Lightning_passive:OnIntervalThink()
	local ability = self:GetAbility()
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	local caster = self:GetCaster()
	if caster:IsSilenced() or not caster:IsAlive() then
		return
	end
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if unit then

			caster:EmitSound("Ability.static.start")
			-- caster:SetCursorCastTarget(unit)
			ability:StartCooldown(2)
			caster:AddNewModifier(caster, ability, "modifier_Advanced_Arc_Lightning_passive_effect", {
				duration = 2,
				target	= unit:entindex()
			})
			break
		end
	end
		
end



modifier_Advanced_Arc_Lightning_passive_effect = class({})

function modifier_Advanced_Arc_Lightning_passive_effect:IsDebuff()			return false end
function modifier_Advanced_Arc_Lightning_passive_effect:IsHidden() 			return true end
function modifier_Advanced_Arc_Lightning_passive_effect:IsPurgable() 		return false end
function modifier_Advanced_Arc_Lightning_passive_effect:IsPurgeException() 	return false end
function modifier_Advanced_Arc_Lightning_passive_effect:RemoveOnDeath() return false end
function modifier_Advanced_Arc_Lightning_passive_effect:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE+ MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Arc_Lightning_passive_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
		
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		
		local target						= EntIndexToHScript(keys.target)
		local pos  =  target:GetAbsOrigin()
		HdEmitSoundOnLocation(caster,pos,"Ability.static.loop",2)
		local dir = ( pos-caster:GetAbsOrigin()):Normalized()
		self.arc_damage			= ability:GetSpecialValueFor("base_damage") +(ability:GetSpecialValueFor("bounus_damage"))*caster:GetIntellect(false)
		self.pos = caster:GetAbsOrigin() + dir *1200
		self.pos.z = self.pos.z + 128
		self.nBeamFX = ParticleManager:CreateParticle( "particles/rebuild/spell/arc_lightning_continued/arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControlEnt( self.nBeamFX, 1, self.hBeamEnd, PATTACH_ABSORIGIN_FOLLOW, nil, self.vBeamEnd, true )
		ParticleManager:SetParticleControl( self.nBeamFX, 1, self.pos   )
		ParticleManager:ReleaseParticleIndex(self.nBeamFX)
	end
end

function modifier_Advanced_Arc_Lightning_passive_effect:OnDestroy()
	if IsServer() then
		-- ParticleManager:DestroyParticle(self.nBeamFX, false)
		-- ParticleManager:ReleaseParticleIndex(self.nBeamFX)
	end
end


function modifier_Advanced_Arc_Lightning_passive_effect:OnIntervalThink()
	local caster = self:GetCaster()

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(),self.pos,nil, 100,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE)
	local ability = self:GetAbility()

	for _, hitEnemy in pairs( tTargets ) do
		hitEnemy:EmitSound("Hero_ArcWarden.SparkWraith.Cast")
		local damage =
		{
			victim = hitEnemy,
			attacker = caster,
			damage = self.arc_damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability,
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
		ApplyDamage( damage )

		if 30>=RandomInt(1, 100) then
			local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, hitEnemy:GetAttachmentOrigin(hitEnemy:ScriptLookupAttachment("attach_hitloc")))
			ParticleManager:ReleaseParticleIndex(pfx)
		end



	end
end