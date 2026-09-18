LinkLuaModifier("modifier_chaotic_Arc_Lightning", "chaotic_spell/class_4/chaotic_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Arc_Lightning_rune1", "chaotic_spell/class_4/chaotic_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Arc_Lightning_rune1_buff", "chaotic_spell/class_4/chaotic_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Arc_Lightning_auto", "chaotic_spell/class_4/chaotic_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)
chaotic_Arc_Lightning = chaotic_Arc_Lightning or class({})

function chaotic_Arc_Lightning:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc_head.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc_beam.vpcf", context )
end
function chaotic_Arc_Lightning:GetIntrinsicModifierName()
	return "modifier_chaotic_Arc_Lightning_auto"
end
function chaotic_Arc_Lightning:GetManaCost(iLevel)
	if self:GetCaster():HasModifier("modifier_chaotic_Arc_Lightning_rune1_buff") then
		return 0
	end
	if self:GetRuneType() == 3 then
		return self:GetSpecialValueFor("mana_cost")*(1+self:GetSpecialValueFor("rune_3_mana")*0.01)
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end
function chaotic_Arc_Lightning:GetCooldown(iLevel)
	if self:GetRuneType() == 2 then
		return self:GetSpecialValueFor("rune_2_cd")
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function chaotic_Arc_Lightning:GetAOERadius()
	return 1000 + self:GetCaster():GetCastRangeBonus()
end

function chaotic_Arc_Lightning:GetTexture()
	if self:GetCaster():HasModifier("modifier_chaotic_Arc_Lightning_rune1_buff") then
		return "zuus_lightning_hands"
	end
	return "zuus_arc_lightning"
end

function chaotic_Arc_Lightning:OnSpellStart()
	if not IsServer() then
		return
	end
	self.runetype = self:GetRuneType()
	if not self.count then
		self.count = 1
	else
		self.count = self.count + 1
	end

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil,  self:GetAOERadius(),
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	for _, unit in pairs(units) do
		local rune1_buff = self:GetCaster():FindModifierByName("modifier_chaotic_Arc_Lightning_rune1_buff")
		local target =  unit
	
		if self.count >= 3 then 
			if rune1_buff and rune1_buff:GetStackCount() >= 1 then
				self:ArcLightningRune1(target, 1+self:GetSpecialValueFor("count_index")*0.01)
	
				rune1_buff:SetStackCount(rune1_buff:GetStackCount()-1)
				self:EndCooldown()
				if rune1_buff:GetStackCount() <= 0 then
					rune1_buff:SafeDestroy()
				end
			else
				self:ArcLightning(target, 1+self:GetSpecialValueFor("count_index")*0.01)
				if self.runetype == 3 then
					self:ArcLightning(target, 1+self:GetSpecialValueFor("count_index")*0.01)
				end
			end
			self.count = nil
		else
			if rune1_buff and rune1_buff:GetStackCount() >= 1 then
				self:ArcLightningRune1(target, 1)
				
				rune1_buff:SetStackCount(rune1_buff:GetStackCount()-1)
				self:EndCooldown()
				if rune1_buff:GetStackCount() <= 0 then
					rune1_buff:SafeDestroy()
				end
			else
				self:ArcLightning(target, 1)
				if self.runetype == 3 then
					self:ArcLightning(target, 1)
				end
			end
		end
		break
	end
end

function chaotic_Arc_Lightning:ArcLightning(target,index)
	if not IsServer() then return end
	if not target then return end
	local caster = self:GetCaster()
	local index = index
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(head_particle)
		
	caster:AddNewModifier(caster, self, "modifier_chaotic_Arc_Lightning", {starting_unit_entindex = target:entindex(), index = index})
	if self.runetype == 1 then
		self.chance = self:GetSpecialValueFor("rune_1_chance")
		if self.chance >= math.random(1,100) then
			caster:AddNewModifier(caster, self, "modifier_chaotic_Arc_Lightning_rune1_buff", {stack = self:GetSpecialValueFor("rune_1_count")})
			self:EndCooldown()
		end
	end
end

function chaotic_Arc_Lightning:ArcLightningRune1(target,index)
	if not IsServer() then return end
	if not target then return end
	
	local caster = self:GetCaster()
	local index = index

	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	local head_particle = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(head_particle)
		
	caster:AddNewModifier(caster, self, "modifier_chaotic_Arc_Lightning_rune1", {starting_unit_entindex = target:entindex(), index = index})
	if self.runetype == 1 then
		self.chance = self:GetSpecialValueFor("rune_1_chance")
		if self.chance >= math.random(1,100) then
			caster:AddNewModifier(caster, self, "modifier_chaotic_Arc_Lightning_rune1_buff", {stack = self:GetSpecialValueFor("rune_1_count")})
			self:EndCooldown()
		end
	end
end

--------------------------------------
modifier_chaotic_Arc_Lightning_auto = advanced_modifier({})

function modifier_chaotic_Arc_Lightning_auto:IsHidden()		return true end
function modifier_chaotic_Arc_Lightning_auto:IsPurgable()		return false end
function modifier_chaotic_Arc_Lightning_auto:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.6)
	end
end
function modifier_chaotic_Arc_Lightning_auto:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability and self:GetParent():IsAlive() then
		if HDCanAutoCast(caster, ability)==true then
			-- ability:OnSpellStart()
			-- ability:UseResources(true,true,true,true)
			self:GetParent():CastAbilityNoTarget(ability, self:GetParent():GetPlayerOwnerID())
		end
	end
end
--------------------------------------
modifier_chaotic_Arc_Lightning = advanced_modifier({})

function modifier_chaotic_Arc_Lightning:IsHidden()		return true end
function modifier_chaotic_Arc_Lightning:IsPurgable()		return false end
function modifier_chaotic_Arc_Lightning:RemoveOnDeath()	return false end
function modifier_chaotic_Arc_Lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_Arc_Lightning:OnCreated(keys)
	self.ability = self:GetAbility()
	if not IsServer() or not self.ability then return end
	self.index = keys.index or 1

	self.arc_damage			= (self.ability:GetSpecialValueFor("base_damage") +self.ability:GetSpecialValueFor("bounus_damage")*self:GetCaster():HDGetPrimaryStatValue())*self.index
	self.radius				= self.ability:GetSpecialValueFor("radius")
	self.jump_count			= self.ability:GetSpecialValueFor("jump_count")
	self.jump_delay			= self.ability:GetSpecialValueFor("jump_delay")
	self.down 				= 1-self.ability:GetSpecialValueFor("down")*0.01

	if self.ability:GetRuneType() == 2 then
		self.arc_damage = self.arc_damage*(1+self.ability:GetSpecialValueFor("rune_2_damage")*0.01)
		self.radius = 10000
		self.jump_count = 100
		self.jump_delay = 0.2
		self.down = 1
	end
	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit  and not self.current_unit:IsNull() then  
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		
		self.current_unit:ApplyMergeDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= self.ability:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self.ability,
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		})
		if self.index > 1 and self.current_unit:IsAlive() then
			self.current_unit:Elecshocking(self:GetCaster(), self.ability, self.ability:GetSpecialValueFor("count_elecshocking"))
		end
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()
	self:StartIntervalThink(self.jump_delay)
end

function modifier_chaotic_Arc_Lightning:OnIntervalThink()
	if not self:GetAbility() then return end
	if not self.current_unit or self.current_unit:IsNull() then
		self:SafeDestroy()
		return
	end
	
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	for _, enemy in pairs(units) do
		if not self.units_affected[enemy]  and enemy ~= self.current_unit and enemy ~= self.previous_unit then
			enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
	
			self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(0, 0, 100))  
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
	
			self.previous_unit						= self.current_unit
			self.current_unit						= enemy
			
			self.pos = self.current_unit:GetAbsOrigin()
            self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
            self.unit_counter						= self.unit_counter + 1

			enemy:ApplyMergeDamage({
				victim 			= enemy,
				damage 			= self.arc_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self.ability,
				hd_flags 		= HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			})
			if self.index > 1 and self.current_unit:IsAlive() then
				self.current_unit:Elecshocking(self:GetCaster(), self.ability, self.ability:GetSpecialValueFor("count_elecshocking"))
			end
			self.arc_damage = self.arc_damage *self.down
			if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
				self:StartIntervalThink(-1)
				self:SafeDestroy()
			end
			return
		end
	end

	self:SafeDestroy()
end
--------------------------------------
modifier_chaotic_Arc_Lightning_rune1_buff = advanced_modifier({})

function modifier_chaotic_Arc_Lightning_rune1_buff:IsHidden()		return false end
function modifier_chaotic_Arc_Lightning_rune1_buff:IsPurgable()		return false end
function modifier_chaotic_Arc_Lightning_rune1_buff:RemoveOnDeath()	return false end
function modifier_chaotic_Arc_Lightning_rune1_buff:OnCreated(keys)
	if IsServer() then
		self.stack = keys.stack
		self:SetStackCount(self.stack)
	end
end
function modifier_chaotic_Arc_Lightning_rune1_buff:OnRefresh(keys)
	if IsServer() then
		self.stack = keys.stack
		self:SetStackCount(self.stack)
	end
end
--------------------------------------
modifier_chaotic_Arc_Lightning_rune1 = advanced_modifier({})

function modifier_chaotic_Arc_Lightning_rune1:IsHidden()		return true end
function modifier_chaotic_Arc_Lightning_rune1:IsPurgable()		return false end
function modifier_chaotic_Arc_Lightning_rune1:RemoveOnDeath()	return false end
function modifier_chaotic_Arc_Lightning_rune1:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_Arc_Lightning_rune1:OnCreated(keys)
	self.ability = self:GetAbility()
	if not IsServer() or not self.ability then return end
	self.index = keys.index or 1

	self.arc_damage			= (self.ability:GetSpecialValueFor("base_damage") +self.ability:GetSpecialValueFor("bounus_damage")*self:GetCaster():HDGetPrimaryStatValue())*self.index*(1+self.ability:GetSpecialValueFor("rune_1_damage")*0.01)
	self.radius				= self.ability:GetSpecialValueFor("radius")
	self.jump_count			= self.ability:GetSpecialValueFor("jump_count") + self.ability:GetSpecialValueFor("rune_1_number")
	self.jump_delay			= self.ability:GetSpecialValueFor("jump_delay")
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit  and not self.current_unit:IsNull() then  
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		self.current_unit:ApplyMergeDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= self.ability:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self.ability,
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		})
		if self.index > 1 and self.current_unit:IsAlive() then
			self.current_unit:Elecshocking(self:GetCaster(), self.ability, self.ability:GetSpecialValueFor("count_elecshocking"))
		end
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()
	self:StartIntervalThink(self.jump_delay)
end

function modifier_chaotic_Arc_Lightning_rune1:OnIntervalThink()
	if not self:GetAbility() then return end
	if not self.current_unit or self.current_unit:IsNull() then
		self:SafeDestroy()
		return
	end
	
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	for _, enemy in pairs(units) do
		if not self.units_affected[enemy]  and enemy ~= self.current_unit and enemy ~= self.previous_unit then
			enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
	
			self.lightning_particle = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(0, 0, 100))  
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
	
			self.previous_unit						= self.current_unit
			self.current_unit						= enemy
			
			self.pos = self.current_unit:GetAbsOrigin()
            self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
            self.unit_counter						= self.unit_counter + 1

			enemy:ApplyMergeDamage({
				victim 			= enemy,
				damage 			= self.arc_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self.ability,
				hd_flags 		= HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			})
			if self.index > 1 and self.current_unit:IsAlive() then
				self.current_unit:Elecshocking(self:GetCaster(), self.ability, self.ability:GetSpecialValueFor("count_elecshocking"))
			end
			if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
				self:StartIntervalThink(-1)
				self:SafeDestroy()
			end
			return
		end
	end

	self:SafeDestroy()
end
