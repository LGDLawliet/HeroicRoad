Primary_Culling_Blade = class({})

LinkLuaModifier("modifier_Primary_Culling_Blade_sprint", "skills/Primary_Culling_Blade", LUA_MODIFIER_MOTION_NONE)

function Primary_Culling_Blade:IsHiddenWhenStolen() 		return false end
function Primary_Culling_Blade:IsRefreshable() 			return true end
function Primary_Culling_Blade:IsStealable() 				return true end
function Primary_Culling_Blade:IsNetherWardStealable() 	return true end

function Primary_Culling_Blade:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	return true
end


function Primary_Culling_Blade:OnAbilityPhaseInterrupted() self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4) end

function Primary_Culling_Blade:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local kill_index = self:GetSpecialValueFor("caster_health_percent")
	local talent_1 = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_axe_4")
	local talent_2 = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_axe_4_buff")
	if talent_1 then
		kill_index = kill_index * (1+talent_1:GetAbility():GetSpecialValueFor("hp_line")*0.01)
	end
	if talent_2 then
		kill_index = kill_index * (1+talent_1:GetAbility():GetSpecialValueFor("active_line")*0.01)
		talent_2:SafeDestroy()
	end

	local kill_threshold = kill_index*0.01* caster:GetMaxHealth()
	local buff_duration = self:GetSpecialValueFor("speed_duration")

	if target:GetHealth() <= kill_threshold then
		
		target:EmitSound("Hero_Axe.Culling_Blade_Success")
		local culling_kill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, caster)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 3, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(culling_kill_particle, 4,target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(culling_kill_particle, 4, caster:GetForwardVector(), Vector(0,0,0), caster:GetUpVector())
		-- ParticleManager:SetParticleControl(culling_kill_particle, 8, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("speed_aoe"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(allies) do
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", PATTACH_POINT_FOLLOW, ally)
			ParticleManager:SetParticleControlEnt(pfx, 1, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)

			ally:AddNewModifier(caster, self, "modifier_Primary_Culling_Blade_sprint", {duration = buff_duration})
		end
		TrueKill(caster, target, self)
		self:EndCooldown()
	else 
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(pfx, 4, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Axe.Culling_Blade_Fail", caster)
		local damageTable = {
							victim = target,
							attacker = self:GetCaster(),
							damage = self:GetSpecialValueFor("health_damage")* caster:GetMaxHealth()*0.01,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)

	end
end

modifier_Primary_Culling_Blade_sprint = class({})

function modifier_Primary_Culling_Blade_sprint:IsDebuff()				return false end
function modifier_Primary_Culling_Blade_sprint:IsPurgable() 			return true end
function modifier_Primary_Culling_Blade_sprint:IsPurgeException() 		return true end
function modifier_Primary_Culling_Blade_sprint:IsHidden()				return false end
function modifier_Primary_Culling_Blade_sprint:OnCreated()
	self.as_bonus = self:GetAbility():GetSpecialValueFor("as_bonus")
	self.move = self:GetAbility():GetSpecialValueFor("speed_bonus")
end
function modifier_Primary_Culling_Blade_sprint:OnRefresh()
	self.as_bonus = self:GetAbility():GetSpecialValueFor("as_bonus")
	self.move = self:GetAbility():GetSpecialValueFor("speed_bonus")
end
function modifier_Primary_Culling_Blade_sprint:GetEffectName()	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf" end

function modifier_Primary_Culling_Blade_sprint:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_Primary_Culling_Blade_sprint:GetModifierAttackSpeedBonus_Constant()	
	if not self:GetAbility() then
		self:Destroy()
		return 
	end
	return self.as_bonus
	
end
function modifier_Primary_Culling_Blade_sprint:GetModifierMoveSpeedBonus_Percentage()	
	if not self:GetAbility() then
		self:Destroy()
		return 
	end
	return self.move
	
end


