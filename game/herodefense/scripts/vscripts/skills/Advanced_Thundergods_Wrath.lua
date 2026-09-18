--特效优化 √

LinkLuaModifier("modifier_Advanced_Thundergods_Wrath_Power", "skills/Advanced_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thundergods_Wrath_Liquid_Cloud", "skills/Advanced_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning", "skills/Advanced_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thundergods_Wrath_buff", "skills/Advanced_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thundergods_Wrath_unlock1", "skills/Advanced_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Thundergods_Wrath_unlock3", "skills/Advanced_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_stormcrafter_active", "items/item_hd_stormcrafter", LUA_MODIFIER_MOTION_NONE)

Advanced_Thundergods_Wrath = class({})


function Advanced_Thundergods_Wrath:CheckKV(key)
	local table = {
		basic_damage=40,
		bonus_damage=0.4,


	}
	local value = table[key] or -1
	return value

end


function Advanced_Thundergods_Wrath:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Thundergods_Wrath_unlock1",{})
	return true
end
function Advanced_Thundergods_Wrath:UnlockSecondCore(key)
	return true
end
function Advanced_Thundergods_Wrath:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Thundergods_Wrath_unlock1",{})
	return true
end


function Advanced_Thundergods_Wrath:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock1_thuner/effect_thundergods_wrath.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", context )

end


function Advanced_Thundergods_Wrath:GetBehavior()

	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
	end
	return self.BaseClass.GetBehavior(self)
	
end



function Advanced_Thundergods_Wrath:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath")
	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))

	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControl(self.thundergod_spell_cast, 0, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	-- ParticleManager:SetParticleControl(self.thundergod_spell_cast, 1, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	-- ParticleManager:SetParticleControl(self.thundergod_spell_cast, 2, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	return true
end

function Advanced_Thundergods_Wrath:GetAOERadius()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return 500
		end
		
	end
	return 1500
end

function Advanced_Thundergods_Wrath:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end

function Advanced_Thundergods_Wrath:OnSpellStart(unlock3) 
	if not IsServer() then
		return
	end
		local ability 				= self
		local caster 				= self:GetCaster()
		if self.unlock2 then
			local pos = self:GetCursorPosition()
			local caster_pos = caster:GetOrigin()
			local dir = CalculateDirection(pos,caster_pos)
			local start_pos = pos - dir *3000 + Vector(0,0,1000)

			local particle_target = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(particle_target, 0, pos)
			ParticleManager:SetParticleControl(particle_target, 1,start_pos)
			ParticleManager:ReleaseParticleIndex(particle_target)
			CreateModifierThinker(caster, ability, "modifier_true_sight_dummy", {duration = 4,stack=700}, pos, caster:GetTeamNumber(), false)

			caster:EmitSound("Hero_Zuus.GodsWrath.Target")

			local pos_table = {}
			table.insert(pos_table,pos)
			local count = 2
			if self:GetAutoCastState() then
				local bonus = math.floor(caster:GetMana()/1400)
				bonus = math.min(bonus,7)
				caster:SpendMana( bonus*1000, ability )
				count = count + bonus
			end
	
			--命石：雷神之怒，雷暴
			local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_stormcrafter")
			if equip_sp then
				count = count*equip_sp:GetAbility():GetSpecialValueFor("unlock2")
			end

			for i = 1, count, 1 do
				local new_pos = pos + Vector(RandomInt(-700, 700),RandomInt(-700, 700),0)
				local start_pos = new_pos - dir *3000 + Vector(0,0,1000)
				local particle_target = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(particle_target, 0, new_pos)
				ParticleManager:SetParticleControl(particle_target, 1,start_pos)
				ParticleManager:ReleaseParticleIndex(particle_target)
				table.insert(pos_table,new_pos)
			end
			

			-- 伤害
			local stunduration = ability:GetSpecialValueFor("stun_duration")
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			local damage = ability:GetSpecialValueFor("basic_damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
			caster:AddNewModifier(caster, ability, "modifier_Advanced_Thundergods_Wrath_Liquid_Cloud", {duration = 10})


			local damage_table 			= {}
			damage_table.attacker 		= caster
			damage_table.ability 		= ability
			damage_table.damage_type 	= ability:GetAbilityDamageType() 
			damage_table.damage			= damage
			damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			for _, target_pos in ipairs(pos_table) do
				local nearby_enemy_units = FindUnitsInRadius(
					caster:GetTeamNumber(), 
					target_pos , 
					nil, 
					500, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_CLOSEST, 
					false
				)
				if #nearby_enemy_units ~= 0 then
					
					for i, unit in pairs(nearby_enemy_units) do
						local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
						unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = stunduration * StatusResistance})
						damage_table.victim 		= unit
						ApplyDamage(damage_table)
			
						if i>=5 then
							break
						end
					end

				end
			end
			caster:AddNewModifier(caster, ability, "modifier_Advanced_Thundergods_Wrath_buff", {duration = 15})

			-- ParticleManager:SetParticleControl(self.thundergod_spell_cast, 2, Vector(attack_lock.x, attack_lock.y, attack_lock.z))

			return
		end


		local position	= self:GetCaster():GetAbsOrigin()	
		CreateModifierThinker(caster, ability, "modifier_true_sight_dummy", {duration = 4,stack=700}, position, caster:GetTeamNumber(), false)
		local stunduration = ability:GetSpecialValueFor("stun_duration")
		if self.thundergod_spell_cast then
			ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
		end
		-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			position , 
			nil, 
			ability:GetSpecialValueFor("radius"), 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_CLOSEST, 
			false
		)
		local i = 0
		local damage = ability:GetSpecialValueFor("basic_damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
		caster:AddNewModifier(caster, ability, "modifier_Advanced_Thundergods_Wrath_Liquid_Cloud", {duration = 10})

		--LV20解锁流电
		if self.advanced_level>=20 and self:GetAutoCastState() then
			if self.unlock3 and not unlock3 then
				caster:AddNewModifier(caster, ability, "modifier_Advanced_Thundergods_Wrath_unlock3", {})
			else
				local units = FindUnitsInRadius(
					caster:GetTeamNumber(), 
					position , 
					nil, 
					ability:GetSpecialValueFor("radius"), 
					DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
					DOTA_UNIT_TARGET_HERO, 
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_CLOSEST, 
					false
				)
				local bonus_damage = 0
				for _, unit in ipairs(units) do
					if unit:IsRealHero() then
						local mana = unit:GetMana()*0.15
						bonus_damage = bonus_damage + mana
						unit:Script_ReduceMana(mana,ability)
						--添加特效
						if unit~=caster then
							local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
							ParticleManager:SetParticleControlEnt(head_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
							ParticleManager:SetParticleControlEnt(head_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
							ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
							ParticleManager:ReleaseParticleIndex(head_particle)
						end
	
					end
				end
				damage = damage +bonus_damage
			end

		end

		--LV15解锁通电
		if self.advanced_level>=15 then
			caster:AddNewModifier(caster, ability, "modifier_Advanced_Thundergods_Wrath_buff", {duration = 15})
			
		end

		if #nearby_enemy_units ~= 0 then
			local unit = caster
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
				local pos = unit:GetAbsOrigin()
				ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
				ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
				ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
				ParticleManager:ReleaseParticleIndex(particle)
			
			local totalDamage = 0
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)

			--命石：雷神之怒，雷暴
			local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_stormcrafter")
			if equip_sp then
				damage = (ability:GetSpecialValueFor("basic_damage") + ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)) * (1-equip_sp:GetAbility():GetSpecialValueFor("damage_down")*0.01)
				local equip_sp_active = self:GetCaster():FindModifierByName("modifier_item_hd_stormcrafter_active")
				if not equip_sp_active then
					self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_hd_stormcrafter_active",{duration = equip_sp:GetAbility():GetSpecialValueFor("storm_duration")})
				end
			end

			for _, unit in pairs(nearby_enemy_units) do
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
				local pos = unit:GetAbsOrigin()
				ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
				ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
				ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
				ParticleManager:ReleaseParticleIndex(particle)
				local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
				unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = stunduration * StatusResistance})
				unit:EmitSound("Hero_Zuus.GodsWrath.Target")
	
	
				local damage_table 			= {}
				damage_table.attacker 		= caster
				damage_table.ability 		= ability
				damage_table.damage_type 	= ability:GetAbilityDamageType() 
				damage_table.damage			= damage
				damage_table.victim 		= unit
				damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
				local damage = ApplyDamage(damage_table)
				i=i+1
				totalDamage = totalDamage + damage
				if i>=20 then
					break
				end
			end
		end
		i = 20 - i
	
		if i<1 then
			return
		end
	
		
		local modifier = caster:AddNewModifier(caster, ability, "modifier_Advanced_Thundergods_Wrath_Power", {duration = 20})
		if modifier then
			modifier:SetStackCount(i)
		end
end



modifier_Advanced_Thundergods_Wrath_Power = class({})

function modifier_Advanced_Thundergods_Wrath_Power:IsDebuff()			return false end
function modifier_Advanced_Thundergods_Wrath_Power:IsHidden() 		return false end
function modifier_Advanced_Thundergods_Wrath_Power:IsPurgable() 		return false end
function modifier_Advanced_Thundergods_Wrath_Power:IsPurgeException() return false end
function modifier_Advanced_Thundergods_Wrath_Power:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,} end



function modifier_Advanced_Thundergods_Wrath_Power:OnAttackLanded( params )
	if params.attacker~=self:GetParent() then
		return
	end
	if params.damage <1 then
		return
	end
	if self:GetStackCount()<1 then
		self:SafeDestroy()
	end

	local ability = self:GetAbility()
	local level = ability.advanced_level
	local caster = ability:GetCaster()
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local damage = ability:GetSpecialValueFor("basic_damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
	--LV5解锁重利用+
	if level>=5 then
		damage = damage*0.5
	else
		damage = damage *0.25
	end
	self.damage = damage
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, params.target)
	local pos = params.target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z))
	ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z+3000))
	ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
	ParticleManager:ReleaseParticleIndex(particle)
	params.target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration * 0.5*(1 - params.target:GetStatusResistance())})
	params.target:EmitSound("Hero_Zuus.GodsWrath.Target")


	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= ability:GetAbilityDamageType() 
	damage_table.damage			= self.damage
	damage_table.victim 		= params.target
	damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
	ApplyDamage(damage_table)


	self:DecrementStackCount()
	if self:GetStackCount()<1 then
		self:SafeDestroy()
	end
end


modifier_Advanced_Thundergods_Wrath_Liquid_Cloud= modifier_Advanced_Thundergods_Wrath_Liquid_Cloud or class({})

function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud:IsHidden()		return false end
function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud:IsPurgable()		return false end
function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud:RemoveOnDeath()	return false end
function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end
	self:StartIntervalThink(1)
end

function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud:OnIntervalThink()

	
	
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1000,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	--  print("units="..#units)
	if #units ~=0 then
		local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, units[1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[1]:GetAbsOrigin(), true)
		-- No reason for this CP besides that I like colours
		ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))

		ParticleManager:ReleaseParticleIndex(head_particle)
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning", {
			starting_unit_entindex	= units[1]:entindex()
		})
		-- print("hjhhhh")
	end


end




modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning= modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning or class({})

function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning:IsHidden()		return true end
function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning:IsPurgable()		return false end
function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning:RemoveOnDeath()	return false end
function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning:OnCreated(keys)
	local ability = self:GetAbility()
	if not IsServer() or not ability then return end

	
	local int_index = 2
	--LV10解锁流云+
	if ability.advanced_level>=10 then
		int_index = 3
	end

	self.arc_damage			= int_index*self:GetCaster():GetIntellect(false)
	self.radius				= 400
	self.jump_count			= 3
	self.jump_delay			= 0.5
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	self.units_affected			= {}  
	self.current_unit		= EntIndexToHScript(self.starting_unit_entindex)
	if IsValid(self.current_unit ) then  
		self.current_unit:EmitSound("Hero_Zuus.ArcLightning.Target")
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= ability:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= ability,
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		})
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()
	self:StartIntervalThink(self.jump_delay)
end

function modifier_Advanced_Thundergods_Wrath_Liquid_Cloud_Arc_Lightning:OnIntervalThink()
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	for _, enemy in pairs(units) do
		if not self.units_affected[enemy]  and enemy ~= self.current_unit and enemy ~= self.previous_unit and not self.current_unit:IsNull() then
			enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
			
			self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(0, 0, 100))  
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
			
			
			self.previous_unit						= self.current_unit
			self.current_unit						= enemy
			self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
			self.unit_counter						= self.unit_counter + 1
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.arc_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility(),
				hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
			})


			if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
				self:StartIntervalThink(-1)
				self:SafeDestroy()
			end
			return
		end
	end
	self:SafeDestroy()



end













modifier_Advanced_Thundergods_Wrath_buff = advanced_modifier({})

function modifier_Advanced_Thundergods_Wrath_buff:IsDebuff() return false end
function modifier_Advanced_Thundergods_Wrath_buff:IsHidden() return false end
function modifier_Advanced_Thundergods_Wrath_buff:IsPurgable() return false end

function modifier_Advanced_Thundergods_Wrath_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Advanced_Thundergods_Wrath_buff:Advanced_GetModifierSpellAmplifyBonus()return self:GetStackCount()*3 end



function modifier_Advanced_Thundergods_Wrath_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Thundergods_Wrath_buff:OnRefresh(keys)
    self.ability = self:GetAbility()
    if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(1)
	end
end



function modifier_Advanced_Thundergods_Wrath_buff:OnIntervalThink(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end




modifier_Advanced_Thundergods_Wrath_unlock1 = class({})

function modifier_Advanced_Thundergods_Wrath_unlock1:IsDebuff()			return false end
function modifier_Advanced_Thundergods_Wrath_unlock1:IsHidden() 			return false end
function modifier_Advanced_Thundergods_Wrath_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Thundergods_Wrath_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Thundergods_Wrath_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Thundergods_Wrath_unlock1:OnCreated()
	if IsServer() then
		local caster = self:GetParent()
		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock1/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle,1,Vector(1000,0,0))
		self:AddParticle( self.particle, false, false, -1, true, false )
		self:StartIntervalThink(3)
	end
end
function modifier_Advanced_Thundergods_Wrath_unlock1:OnIntervalThink()
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetOrigin(), 
		nil, 
		1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)
	if #units>=6 then
		self:TunderTriger(units[RandomInt(1, #units)]:GetOrigin())
	else
		self:TunderTriger(parent:GetOrigin()+Vector(RandomFloat(-707, 707),RandomFloat(-707, 707),0))
	end


end


function modifier_Advanced_Thundergods_Wrath_unlock1:TunderTriger(pos)
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		pos, 
		nil, 
		350, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)
	if #units == 0 then
		local unit = parent
		local particle = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock1_thuner/effect_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
		-- local pos = unit:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
		ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
		ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
		ParticleManager:ReleaseParticleIndex(particle)
		EmitSoundOnLocationWithCaster(pos, "Hero_Zuus.GodsWrath.Target", unit)
	
	else	
		local ability =  self:GetAbility()
		local damage_table 			= {}
		damage_table.attacker 		= parent
		damage_table.ability 		=ability
		damage_table.damage_type 	= DAMAGE_TYPE_MAGICAL
		damage_table.damage			= (ability:GetSpecialValueFor("basic_damage") + (ability:GetSpecialValueFor("bonus_damage"))*parent:GetIntellect(false))*0.25
		damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		local stunduration = ability:GetSpecialValueFor("stun_duration")
		local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
		for i, unit in pairs(units) do
			local particle = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock1_thuner/effect_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
			ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
			ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
			ParticleManager:ReleaseParticleIndex(particle)
			local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			unit:AddNewModifier(parent, ability, "modifier_stunned", {duration = stunduration * StatusResistance})
			unit:EmitSound("Hero_Zuus.GodsWrath.Target")
			damage_table.victim 		= unit
			ApplyDamage(damage_table)
			if i>=6 then
				break
			end
		
		end
	end
end








modifier_Advanced_Thundergods_Wrath_unlock3 = class({})

function modifier_Advanced_Thundergods_Wrath_unlock3:IsDebuff()			return false end
function modifier_Advanced_Thundergods_Wrath_unlock3:IsHidden() 			return true end
function modifier_Advanced_Thundergods_Wrath_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Thundergods_Wrath_unlock3:IsPurgeException() 	return false end
-- function modifier_Advanced_Thundergods_Wrath_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Thundergods_Wrath_unlock3:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
		self:SetStackCount(1)
		self.mana_cost = self:GetAbility():GetManaCost(-1)
		self:TriggerSelfDamage()
	end
end
function modifier_Advanced_Thundergods_Wrath_unlock3:OnIntervalThink()

	local ability = self:GetAbility()
	self:IncrementStackCount()
	self.mana_cost = self.mana_cost *2
	self:GetCaster():SpendMana( self.mana_cost, ability )
	self:TriggerSelfDamage()
	ability:OnSpellStart(true)
end

function modifier_Advanced_Thundergods_Wrath_unlock3:TriggerSelfDamage()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	local damage = ability:GetSpecialValueFor("basic_damage") + (ability:GetSpecialValueFor("bonus_damage"))*caster:GetIntellect(false)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, caster)
	local pos = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
	ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
	ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
	ParticleManager:ReleaseParticleIndex(particle)
	local stunduration = ability:GetSpecialValueFor("stun_duration")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = caster:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	caster:AddNewModifier(caster, ability, "modifier_stunned", {duration = stunduration * StatusResistance})
	caster:EmitSound("Hero_Zuus.GodsWrath.Target")


	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= ability:GetAbilityDamageType() 
	damage_table.damage			= damage * self:GetStackCount()
	damage_table.victim 		= caster
	damage_table.hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
	ApplyDamage(damage_table)
	if not caster:IsAlive() or caster:GetMana()<=0 then
		self:SafeDestroy()
	end

end