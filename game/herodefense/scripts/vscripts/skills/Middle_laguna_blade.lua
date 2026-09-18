
LinkLuaModifier("modifier_Middle_laguna_blade", "skills/Middle_laguna_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_laguna_blade_talent_debuff", "skills/Middle_laguna_blade", LUA_MODIFIER_MOTION_NONE)


Middle_laguna_blade			= Middle_laguna_blade or class({})



function Middle_laguna_blade:OnSpellStart()
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

	local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- No reason for this CP besides that I like colours
	-- ParticleManager:SetParticleControl(head_particle, 62, Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(head_particle)
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Middle_laguna_blade", {
		starting_unit_entindex	= target:entindex()
	})
end
function Middle_laguna_blade:CheckTalent(target)
	local talent = 0
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_lina_2") then
		local magic_res = target:Script_GetMagicalArmorValue(true,self)
		if magic_res>0 then
			talent = magic_res*100
		end
	end

	if talent>0 then
		
		return  target:AddNewModifier(caster, self, "modifier_Middle_laguna_blade_talent_debuff", {
			duration = 0.1,stack = talent
		})
	end
	return nil

end

modifier_Middle_laguna_blade= modifier_Middle_laguna_blade or class({})

function modifier_Middle_laguna_blade:IsHidden()		return true end
function modifier_Middle_laguna_blade:IsPurgable()		return false end
function modifier_Middle_laguna_blade:RemoveOnDeath()	return false end
function modifier_Middle_laguna_blade:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Middle_laguna_blade:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	self.arc_damage			= self:GetAbility():GetSpecialValueFor("damage") +self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)
	local caster = self:GetCaster()
	-- self.radius				= 0
	-- self.jump_count			= 0
	-- self.jump_delay			= 0

	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit then  
		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
		-- self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		local talent_modifier =  self:GetAbility():CheckTalent(self.current_unit)
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= self:GetAbility():GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= caster,
			ability 		= self:GetAbility(),
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		})
		if talent_modifier then
			talent_modifier:SafeDestroy()
		end
		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), self.current_unit:GetAbsOrigin(), nil, 150,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

		for _, enemy in pairs(tTargets) do
			if enemy~=self.current_unit then
				local damageTable = {
					victim = enemy,
					attacker = caster,
					damage = self.arc_damage*0.3,
					damage_type =  self:GetAbility():GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self, --Optional.
					hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
				}
				local talent_modifier =  self:GetAbility():CheckTalent(enemy)
		
				ApplyDamage(damageTable)
				if talent_modifier then
					talent_modifier:SafeDestroy()
				end
			end
		
		end
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()
end







modifier_Middle_laguna_blade_talent_debuff = class({})

function modifier_Middle_laguna_blade_talent_debuff:IsDebuff()			return true end
function modifier_Middle_laguna_blade_talent_debuff:IsHidden() 			return true end
function modifier_Middle_laguna_blade_talent_debuff:IsPurgable() 		return false end
function modifier_Middle_laguna_blade_talent_debuff:IsPurgeException() 	return false end
function modifier_Middle_laguna_blade_talent_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end	
function modifier_Middle_laguna_blade_talent_debuff:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end
function modifier_Middle_laguna_blade_talent_debuff:GetModifierMagicalResistanceBonus() return -self:GetStackCount() end

