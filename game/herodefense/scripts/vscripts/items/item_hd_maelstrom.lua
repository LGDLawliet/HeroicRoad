item_hd_maelstrom = class({})

LinkLuaModifier("modifier_item_hd_maelstrom", "items/item_hd_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_maelstrom_Arc_Lightning", "items/item_hd_maelstrom", LUA_MODIFIER_MOTION_NONE)

function item_hd_maelstrom:GetIntrinsicModifierName()
	return "modifier_item_hd_maelstrom"
end





modifier_item_hd_maelstrom = advanced_modifier({})

function modifier_item_hd_maelstrom:IsDebuff() return false end
function modifier_item_hd_maelstrom:IsHidden() return true end
function modifier_item_hd_maelstrom:IsPurgable() return false end


function modifier_item_hd_maelstrom:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

end


function modifier_item_hd_maelstrom:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,         --攻击力
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},                         --攻击事件
	}
end



function modifier_item_hd_maelstrom:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end


function modifier_item_hd_maelstrom:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() and self:GetAbility():IsCooldownReady() then
	

				local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(head_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
				-- No reason for this CP besides that I like colours
				ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
		
				ParticleManager:ReleaseParticleIndex(head_particle)
				
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_maelstrom_Arc_Lightning", {
					starting_unit_entindex	= keys.target:entindex()
				})
				self:GetAbility():UseResources(true, true, true,true)

		end
	end
end









modifier_item_hd_maelstrom_Arc_Lightning= modifier_item_hd_maelstrom_Arc_Lightning or class({})

function modifier_item_hd_maelstrom_Arc_Lightning:IsHidden()		return true end
function modifier_item_hd_maelstrom_Arc_Lightning:IsPurgable()		return false end
function modifier_item_hd_maelstrom_Arc_Lightning:RemoveOnDeath()	return false end
function modifier_item_hd_maelstrom_Arc_Lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_hd_maelstrom_Arc_Lightning:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	self.arc_damage			= self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor("damage")
	self.radius				= 600
	self.jump_count			= self:GetAbility():GetSpecialValueFor("count")
	self.jump_delay			= 0.1

	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit then  
		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
		-- self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= self:GetAbility():GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()

	self:StartIntervalThink(self.jump_delay)
end

function modifier_item_hd_maelstrom_Arc_Lightning:OnIntervalThink()
	
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
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
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





