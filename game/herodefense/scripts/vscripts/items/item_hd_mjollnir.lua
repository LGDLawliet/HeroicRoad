item_hd_mjollnir = class({})
-- LinkLuaModifier("modifier_item_hd_mjollnir_arua", "items/item_hd_mjollnir", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mjollnir_arua_effect", "items/item_hd_mjollnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mjollnir", "items/item_hd_mjollnir", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mjollnir_active", "items/item_hd_mjollnir", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mjollnir_active_standby", "items/item_hd_mjollnir", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mjollnir_active_debuff", "items/item_hd_mjollnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mjollnir_Arc_Lightning", "items/item_hd_mjollnir", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_mjollnir:GetIntrinsicModifierName()
	return "modifier_item_hd_mjollnir"
end





modifier_item_hd_mjollnir = advanced_modifier({})

function modifier_item_hd_mjollnir:IsDebuff() return false end
function modifier_item_hd_mjollnir:IsHidden() return false end
function modifier_item_hd_mjollnir:IsPurgable() return false end
function modifier_item_hd_mjollnir:GetTexture() return "item_mjollnir" end
function modifier_item_hd_mjollnir:CheckState()
	local state = {}
	
	if self.pierce_proc then   --几率穿刺（无视闪避）
		self.pierce_proc = false
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end



function modifier_item_hd_mjollnir:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.energy_get = self.ability:GetSpecialValueFor("energy_get")
	self.energy_max = self.ability:GetSpecialValueFor("energy_max")
	
end



function modifier_item_hd_mjollnir:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
		MODIFIER_EVENT_ON_ATTACK,                         --攻击事件
	}
end
function modifier_item_hd_mjollnir:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
	}
end


function modifier_item_hd_mjollnir:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_mjollnir:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end


function modifier_item_hd_mjollnir:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() and self:GetAbility():IsCooldownReady() and not keys.attacker:IsInSpecialAttack() then
	
			if self:GetStackCount() >= self.energy_max then
				local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(head_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
				ParticleManager:ReleaseParticleIndex(head_particle)
				
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_mjollnir_Arc_Lightning", {
					starting_unit_entindex	= keys.target:entindex()
				})
				self:GetAbility():UseResources(true, true, true,true)
				self.pierce_proc = true 
				self:SetStackCount(0)
			else
				self:SetStackCount(math.min(self:GetStackCount()+self.energy_get,self.energy_max))
			end
		end
	end
end

----------------------------------

modifier_item_hd_mjollnir_Arc_Lightning = advanced_modifier({})

function modifier_item_hd_mjollnir_Arc_Lightning:IsHidden()		return true end
function modifier_item_hd_mjollnir_Arc_Lightning:IsPurgable()		return false end
function modifier_item_hd_mjollnir_Arc_Lightning:RemoveOnDeath()	return false end
function modifier_item_hd_mjollnir_Arc_Lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_hd_mjollnir_Arc_Lightning:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end
	self.ability = self:GetAbility()
	self.damage_index = self.ability:GetSpecialValueFor("damage_index")
	self.limit = self.ability:GetSpecialValueFor("limit")

	self.arc_damage			= self:GetCaster():GetAverageTrueAttackDamage(nil)*self.damage_index
	self.radius				= 700
	self.jump_count			= self.limit
	self.jump_delay			= 0.02

	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit and not self.current_unit:IsNull() then  
		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
		-- self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility(),
			hd_flags		= HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
		})
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()

	self:StartIntervalThink(self.jump_delay)
end

function modifier_item_hd_mjollnir_Arc_Lightning:OnIntervalThink()

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
			-- ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(0, 0, 100))  
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
			
			
			self.previous_unit						= self.current_unit
			self.current_unit						= enemy
			
			-- if self.units_affected[self.current_unit] then
			-- 	self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
			-- else
			-- 	self.units_affected[self.current_unit]	= 1
			-- end
			self.pos = self.current_unit:GetAbsOrigin()
			self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
				self.unit_counter						= self.unit_counter + 1
			

			
			-- if self:GetCaster():HasModifier("modifier_imba_zuus_static_field") then
				-- self:GetCaster():FindModifierByName("modifier_imba_zuus_static_field"):Apply(enemy)
			-- end
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.arc_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility(),
				hd_flags		= HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_LIGHTING_DAMAGE
			})
			self.arc_damage = self.arc_damage *1.05
			-- print("self.unit_counter="..self.unit_counter)
			-- print("self.unit_counter="..self.unit_counter)
			if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
				self:StartIntervalThink(-1)
				self:SafeDestroy()
			end
			return
		end
	end
	--区域内没有符合的单位了 就去除
	self:SafeDestroy()
	-- print("remove")
	-- Check again...

end

function modifier_item_hd_mjollnir_Arc_Lightning:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,         --攻击力
	}
end

function modifier_item_hd_mjollnir_Arc_Lightning:Advanced_GetModifierDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("active_damage") end



