LinkLuaModifier("modifier_Advanced_summon_immortal_sarcophagus_idle", "skills/Advanced_summon_immortal_sarcophagus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_summon_immortal_sarcophagus_unlock1_block", "skills/Advanced_summon_immortal_sarcophagus", LUA_MODIFIER_MOTION_NONE)


require("internal/timers")
Advanced_summon_immortal_sarcophagus						= Advanced_summon_immortal_sarcophagus or class({})
function Advanced_summon_immortal_sarcophagus:IsSummonSpell()return true end

function Advanced_summon_immortal_sarcophagus:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_immortal_sarcophagus/dead_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold.vpcf", context )
	PrecacheResource( "particle", "particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_sparkle.vpcf", context )
	PrecacheResource( "particle", "particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_ray.vpcf", context )
	PrecacheResource( "particle", "particles/world_tower/tower_upgrade/ti7_radiant_tower_orb.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/disruptor/disruptor_2022_immortal/disruptor_2022_immortal_static_storm_lightning_start.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/ti10/high_five/towers/radiant_tower_2021/high_five_radiant_tower_2021_impact_steam.vpcf", context )
	PrecacheResource( "particle", "particles/world_tower/tower_upgrade/ti7_radiant_tower_lvl11_orb.vpcf", context )


	
	
end

function Advanced_summon_immortal_sarcophagus:CheckKVFixedOverride(key)
	
	if key=="damage_change_rate" then
		local level = self:GetSpecialValueFor("advanced_level")
		if level>=15 then
			return 75+level
		end
	end

	return -999999

end
function Advanced_summon_immortal_sarcophagus:CheckKV(key)
	local table = {

		bonus_damage = 1.3,
		bonus_health=1.5,



	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_immortal_sarcophagus:UnlockFirstCore(key)
	return true
end
function Advanced_summon_immortal_sarcophagus:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_summon_immortal_sarcophagus:UnlockThirdCore(key)
	
	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_earth_spirit" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true

end












function Advanced_summon_immortal_sarcophagus:Spawn()
	self.castTime = 0
end

function Advanced_summon_immortal_sarcophagus:OnSpellStart()

	
	local caster =self:GetCaster()
	EmitSoundOn("Creep_Siege_Dire.Destruction", caster)	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	if self.unlock1 then
		life_duration = life_duration +10
	end
	if self.advanced_level>=20 then
		damage = damage +150
	end
	
	local pos = caster:GetAbsOrigin() + (caster:GetForwardVector() * 200)
	local unit = caster:SummonUnit("npc_hd_immortal_sarcophagus",life_duration,
	pos,
	caster:GetForwardVector(),self,0,heal,0,damage,armor,1,1)

	unit:AddNewModifier(caster, self, "modifier_Advanced_summon_immortal_sarcophagus_idle", {})
	local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold.vpcf", PATTACH_ABSORIGIN, unit)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetOrigin())
	DestroyParticleByDelay(particle_cast_fx,4)
	if self.unlock1 then
		unit:AddNewModifier(caster, self, "modifier_Advanced_summon_immortal_sarcophagus_unlock1_block", {})
	end
	

	self.castTime = self.castTime + 1
	local need_cast = 4
	if self.advanced_level>=10 then
		need_cast = 2
	end
	if self.castTime>=need_cast then
		self.castTime = 0
		local max = 75
		if self.unlock2 then
			max = 200
		end
		skillshop:UpgradeAbilitiesPassLV25(self,max)
	end
end


modifier_Advanced_summon_immortal_sarcophagus_idle = modifier_Advanced_summon_immortal_sarcophagus_idle or class({})

function modifier_Advanced_summon_immortal_sarcophagus_idle:IsDebuff()			return false end
function modifier_Advanced_summon_immortal_sarcophagus_idle:IsHidden() 			return false end
function modifier_Advanced_summon_immortal_sarcophagus_idle:IsPurgable() 		return false end
function modifier_Advanced_summon_immortal_sarcophagus_idle:IsPurgeException() 	return false  end
-- function modifier_Advanced_summon_immortal_sarcophagus_idle:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE  end

function modifier_Advanced_summon_immortal_sarcophagus_idle:OnCreated()
	local ability = self:GetAbility()
	self.level = 2
	local level = ability:GetSpecialValueFor("advanced_level")
	local particleName = "particles/world_tower/tower_upgrade/ti7_radiant_tower_orb.vpcf"
	if level>=5 then
		self.lv5 = true
		self.level = 3
		if level>=15 then
			self.level = 4
			if level>=20 then
				self.level = 5
				self.lv20 = true
				if ability:GetUnlock(1)==1 then
					self.unlock1 = true
					self.level = 6
					particleName = "particles/world_tower/tower_upgrade/ti7_radiant_tower_lvl11_orb.vpcf"
				end
				if ability:GetUnlock(2)==2 then
					self.unlock2 = true
					self.level = 6
					particleName = "particles/world_tower/tower_upgrade/ti7_radiant_tower_lvl11_orb.vpcf"
				end
				if ability:GetUnlock(3)==3 then
					self.unlock3 = true
					self.level = 6
					particleName = "particles/world_tower/tower_upgrade/ti7_radiant_tower_lvl11_orb.vpcf"
				end
			end
		end
	end
	local parent = self:GetParent()
	self.bonus_radius = 0
	self:StartIntervalThink(1.5)
	self.bonus_base_damage = 0
	if IsServer() then

		self.unlock3Timer = GameRules:GetGameTime()
		parent:AddActivityModifier("showcase")



		-- self.activity = "level"..self.level
		-- parent:AddActivityModifier(self.activity)
		if self.level==6 then
			parent:AddActivityModifier("level5")
			parent:StartGesture(ACT_DOTA_IDLE)
			Timers:CreateTimer(0.3, function()
				parent:ClearActivityModifiers()
				parent:AddActivityModifier("showcase")
			end)
		else
			self.activity = "level"..self.level
			parent:AddActivityModifier(self.activity)
			parent:StartGesture(ACT_DOTA_IDLE)
		end
	
		


		self.damage_index = ability:GetSpecialValueFor("damage_change_rate")*0.01
		self.radius =  ability:GetSpecialValueFor("radius")
		self.effect_count = 4
		self.damageTable ={
			-- victim = parent, 
			attacker = self:GetCaster(),
			-- damage = dmg, 
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = ability
		}
		
		self.bonus_damage_index = 0.7
		self.timer = 0


		self.nFXIndex = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )


	end
end

function modifier_Advanced_summon_immortal_sarcophagus_idle:OnIntervalThink()

	if not self.damage then
		self.damage = math.min(self:GetParent():GetDamageMax(),2000)*0.05
		self:StartIntervalThink(-1)
		if IsServer() then
			self:StartIntervalThink(1.5)
		end
	end

	if IsServer() then
		self:SetStackCount(self:GetStackCount()*0.92)
		self:ReleaseDamage(1)
	end

end

function modifier_Advanced_summon_immortal_sarcophagus_idle:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/summon_immortal_sarcophagus/dead_effect/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin())
		ParticleManager:SetParticleControlForward(effect_cast, 0, parent:GetForwardVector()) 
		local skin_type = 0
		local level = self.level
		
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(skin_type,level-1,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		-- local scale = parent:GetModelScale()
		-- local timer = 0

		parent:EmitSound("Building_Generic.PartialDestruction")
		parent:StartGesture(ACT_DOTA_CAPTURE)
		local scale = parent:GetModelScale()
		local timer = 0
		Timers:CreateTimer(FrameTime(), function()
			timer = timer + FrameTime()
			if timer>=0.4 then
				parent:AddNoDraw()
				return nil
			end
			scale = scale*0.95
			parent:SetModelScale(scale)

			return FrameTime()
			
		end)
		
	end
end
function modifier_Advanced_summon_immortal_sarcophagus_idle:DeclareFunctions()
	local funcs =  {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=20 then
		-- 
		table.insert(funcs,MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE)
	end
	return funcs
end


function modifier_Advanced_summon_immortal_sarcophagus_idle:GetModifierBaseAttack_BonusDamage() return self.bonus_base_damage end




function modifier_Advanced_summon_immortal_sarcophagus_idle:GetOverrideAnimation(params)
	return ACT_DOTA_CAPTURE
end
function modifier_Advanced_summon_immortal_sarcophagus_idle:GetActivityTranslationModifiers()	
	return "level"..self.level
end
function modifier_Advanced_summon_immortal_sarcophagus_idle:ReleaseDamage(mul)
	if self.unlock3 then
		if self:ReleaseDamageUnlock3(mul) then
			return
		end
	end
	local parent = self:GetParent()
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius+self.bonus_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.damageTable.damage = parent:GetDamageMax() * self.damage_index*mul
	local count = self.effect_count
	local damageRecord = 0
	for i, unit in ipairs(units) do
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_ray.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetOrigin())
		DestroyParticleByDelay(particle_cast_fx,1.5)
		self.damageTable.victim = unit
		damageRecord = damageRecord + ApplyDamage(self.damageTable)
		count = count - 1
		if count<=0 then
			break
		end
	end
	if self.unlock1 and damageRecord>=20 then
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/events/ti10/high_five/towers/radiant_tower_2021/high_five_radiant_tower_2021_impact_steam.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		-- ParticleManager:SetParticleControl(effect_cast, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt( effect_cast, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
		DestroyParticleByDelay(effect_cast,1.5)
		local healing = HealWithGain(damageRecord*0.2,self:GetCaster(),parent,self:GetAbility())

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
	end
	

	if count<self.effect_count then
		parent:EmitSound("Tower.Fire.Attack")
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_sparkle.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetOrigin())
		DestroyParticleByDelay(particle_cast_fx,3)
	end
	if self.lv5 then
		self.bonus_radiuss = math.min(self.bonus_radius+10,400)
	end
	if self.lv20 and self.damage then
		self.bonus_base_damage = self.bonus_base_damage + self.damage
	end
end

function modifier_Advanced_summon_immortal_sarcophagus_idle:OnTakeDamage( params )

	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent() then
			return 0
		end
		if flDamage<=0 then
			
			return
		end
		self:SetStackCount(self:GetStackCount()+flDamage*0.5)


		local parent_damage = Target:GetDamageMax()
		local stack = self:GetStackCount()
		if stack>=parent_damage then
			local time = GameRules:GetGameTime()
			if self.timer>=time then
				return
			end
			if 20>=RandomInt(1, 100) then
				local mul = math.floor(stack/parent_damage)
			
				if mul>1 then
					mul = 1 + (mul-1)*self.bonus_damage_index 
				end
				self:ReleaseDamage(mul)
				self:SetStackCount(0)
				self.timer = time +0.3
			end
		end


	end

	return 0.0

end






function modifier_Advanced_summon_immortal_sarcophagus_idle:ReleaseDamageUnlock3(mul)





	local time  = GameRules:GetGameTime()
	if self.unlock3Timer<=time then
		self.unlock3Timer =  GameRules:GetGameTime()+2
		local parent = self:GetParent()
		local units_enemy = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius+self.bonus_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local effect_unit_list = {} --影响的敌人
		local trigget_unit_list = {}  --被获取到的石棺列表
		for _, unit in ipairs(units_enemy) do
			if not effect_unit_list[unit] then
				effect_unit_list[unit] = true
			end
		end
		local count = self.effect_count
		table.insert(trigget_unit_list,parent)
		
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(units) do
			if unit:GetPlayerOwnerID()==parent:GetPlayerOwnerID() then
				local modifier = unit:FindModifierByName("modifier_Advanced_summon_immortal_sarcophagus_idle")
				if modifier then
					local units_enemy = FindUnitsInRadius(parent:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.radius+self.bonus_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _, unit in ipairs(units_enemy) do
						if not effect_unit_list[unit] then
							effect_unit_list[unit] = true
						end
					end
					count = count + self.effect_count
					table.insert(trigget_unit_list,unit)
				end
			end
			
		end
		local max_effect = count
		-- 对获取到的单位列表造成一次伤害
		mul = mul * (1+(#trigget_unit_list-1)*0.2)
		self.damageTable.damage = parent:GetDamageMax() * self.damage_index*mul
		local damageRecord = 0
		for unit, value in pairs(effect_unit_list) do
			local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_ray.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetOrigin())
			DestroyParticleByDelay(particle_cast_fx,1.5)
			self.damageTable.victim = unit
			damageRecord = damageRecord + ApplyDamage(self.damageTable)
			count = count - 1
			if count<=0 then
				break
			end
		end
		if count<max_effect then
			for _, target_unit in ipairs(trigget_unit_list) do
				target_unit:EmitSound("Tower.Fire.Attack")
				local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_sparkle.vpcf", PATTACH_ABSORIGIN, target_unit)
				ParticleManager:SetParticleControl(particle_cast_fx, 0, target_unit:GetOrigin())
				DestroyParticleByDelay(particle_cast_fx,3)
			end

		end
		if self.lv5 then
			self.bonus_radius = math.min(self.bonus_radius+10,800)
		end
		if self.lv20 and self.damage then
			self.bonus_base_damage = self.bonus_base_damage + self.damage
		end

		return true
	else
		return false
	end




end







modifier_Advanced_summon_immortal_sarcophagus_unlock1_block = advanced_modifier({})

function modifier_Advanced_summon_immortal_sarcophagus_unlock1_block:IsDebuff()			return false end
function modifier_Advanced_summon_immortal_sarcophagus_unlock1_block:IsHidden() 			return true end
function modifier_Advanced_summon_immortal_sarcophagus_unlock1_block:IsPurgable() 		return false end
function modifier_Advanced_summon_immortal_sarcophagus_unlock1_block:IsPurgeException() 	return false end



function modifier_Advanced_summon_immortal_sarcophagus_unlock1_block:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_summon_immortal_sarcophagus_unlock1_block:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	-- if keys.block_disabled then
    --     return 0 
    -- end
	local health = self:GetParent():GetMaxHealth()*0.05
	if keys.damage>=health then
		local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/disruptor/disruptor_2022_immortal/disruptor_2022_immortal_static_storm_lightning_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetAbsOrigin())
		DestroyParticleByDelay(effect_cast,1)
		return keys.damage - health
	end
	return 0 
end
