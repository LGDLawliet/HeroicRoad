
LinkLuaModifier("modifier_Primary_Arc_Lightning", "skills/Primary_Arc_Lightning", LUA_MODIFIER_MOTION_NONE)

Primary_Arc_Lightning			= Primary_Arc_Lightning or class({})

function Primary_Arc_Lightning:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_fade_bolt_head.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_fade_bolt_impact_burst.vpcf", context )
	
end
function Primary_Arc_Lightning:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_rubick_3") then
		return	"rubick/harlequin_icons/rubick_fade_bolt"
	end
	return "zuus_arc_lightning"
end
function Primary_Arc_Lightning:OnSpellStart()
	if not IsServer() then
		return
	end
	local target = self:GetCursorTarget()
	self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
	
	if not target:TriggerSpellAbsorb(self) then
		local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_rubick_3") then
			head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_fade_bolt_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		end
		ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		-- No reason for this CP besides that I like colours
		ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))

		ParticleManager:ReleaseParticleIndex(head_particle)
		
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Primary_Arc_Lightning", {
			starting_unit_entindex	= target:entindex()
		})
	end
end

--------------------------------------
--创建一个可同时存在多个的modifier 记录在施法者身上且死亡不移除
--会将已经影响的单位记录在这个实例中的一个表
modifier_Primary_Arc_Lightning= modifier_Primary_Arc_Lightning or class({})

function modifier_Primary_Arc_Lightning:IsHidden()		return true end
function modifier_Primary_Arc_Lightning:IsPurgable()		return false end
function modifier_Primary_Arc_Lightning:RemoveOnDeath()	return false end
function modifier_Primary_Arc_Lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Primary_Arc_Lightning:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	self.arc_damage			= self:GetAbility():GetSpecialValueFor("base_damage") +self:GetAbility():GetSpecialValueFor("bounus_damage")*self:GetCaster():GetIntellect(false)
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.jump_count			= self:GetAbility():GetSpecialValueFor("jump_count")
	self.jump_delay			= self:GetAbility():GetSpecialValueFor("jump_delay")

	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit  and not self.current_unit:IsNull() then  
		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
		-- self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= self:GetAbility():GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility(),
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		})
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
	self:StartIntervalThink(self.jump_delay)
end

function modifier_Primary_Arc_Lightning:OnIntervalThink()

	if not self.current_unit or self.current_unit:IsNull() then
		self:SafeDestroy()
		return
	end
	
	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
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
			
			-- if self.units_affected[self.current_unit] then
			-- 	self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
			-- else
			-- 	self.units_affected[self.current_unit]	= 1
			-- end
			self.pos = self.current_unit:GetAbsOrigin()
            self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
            self.unit_counter						= self.unit_counter + 1

			ApplyDamage({
				victim 			= enemy,
				damage 			= self.arc_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
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

			

			if (self.unit_counter >= self.jump_count and self.jump_count > 0)  then
				self:StartIntervalThink(-1)
				self:SafeDestroy()
			end
			return
		end
	end

	self:SafeDestroy()
end


