
LinkLuaModifier("modifier_Primary_laguna_blade", "skills/Primary_laguna_blade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Primary_laguna_blade_talent_debuff", "skills/Primary_laguna_blade", LUA_MODIFIER_MOTION_NONE)




Primary_laguna_blade			= Primary_laguna_blade or class({})


-- function Primary_laguna_blade:GetCastRange(location, target)
-- 	return self.BaseClass.GetCastRange(self, location, target)
-- end

function Primary_laguna_blade:OnSpellStart()
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
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Primary_laguna_blade", {
		starting_unit_entindex	= target:entindex()
	})
end


modifier_Primary_laguna_blade= modifier_Primary_laguna_blade or class({})

function modifier_Primary_laguna_blade:IsHidden()		return true end
function modifier_Primary_laguna_blade:IsPurgable()		return false end
function modifier_Primary_laguna_blade:RemoveOnDeath()	return false end
function modifier_Primary_laguna_blade:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Primary_laguna_blade:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	self.arc_damage			= self:GetAbility():GetSpecialValueFor("damage") +self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)
	
	self.starting_unit_entindex	= keys.starting_unit_entindex  --这是施法目标的index
	
	self.units_affected			= {}  
	self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	if self.current_unit then  
		self.units_affected[self.current_unit]	= 1  --记录这个单位到表里 接下来这个实例就不会影响它了
		
		local talent = 0
		if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_lina_2") then
			local magic_res = self.current_unit:Script_GetMagicalArmorValue(true,self:GetAbility())
			if magic_res>0 then
				talent = magic_res*100
			end
		end
		local modifier 
		if talent>0 then
			
			modifier = self.current_unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Primary_laguna_blade_talent_debuff", {
				duration = 0.1,stack = talent
			})
		end
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= self:GetAbility():GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility(),
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		})
		if modifier then
			modifier:SafeDestroy()
		end
	else  --目标不存在了 移除掉
		self:SafeDestroy()
		return
	end
	
	self.unit_counter			= 0
	self.pos = self.current_unit:GetAbsOrigin()
	-- self:StartIntervalThink(self.jump_delay)
end





modifier_Primary_laguna_blade_talent_debuff = class({})

function modifier_Primary_laguna_blade_talent_debuff:IsDebuff()			return true end
function modifier_Primary_laguna_blade_talent_debuff:IsHidden() 			return true end
function modifier_Primary_laguna_blade_talent_debuff:IsPurgable() 		return false end
function modifier_Primary_laguna_blade_talent_debuff:IsPurgeException() 	return false end
function modifier_Primary_laguna_blade_talent_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end	
function modifier_Primary_laguna_blade_talent_debuff:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end
function modifier_Primary_laguna_blade_talent_debuff:GetModifierMagicalResistanceBonus() return -self:GetStackCount() end

