
Advanced_Reapers_Scythe = Advanced_Reapers_Scythe or class({})
LinkLuaModifier("modifier_Advanced_Reapers_Scythe", "skills/Advanced_Reapers_Scythe", LUA_MODIFIER_MOTION_NONE)

function Advanced_Reapers_Scythe:OnSpellStart()
	local target = self:GetCursorTarget()
	self:Reap(target,1)
end
function Advanced_Reapers_Scythe:CheckKV(key)
	local table = {
		limit = 0.6,

	}
	local value = table[key] or -1
	return value

end
function Advanced_Reapers_Scythe:Reap(target,index)
	local caster = self:GetCaster()
	if target:TriggerSpellAbsorb(self) then
		return nil
	end

	caster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
	target:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
	if (math.random(1,100) <= 30) and (caster:GetName() == "npc_dota_hero_necrolyte") then
		caster:EmitSound("necrolyte_necr_ability_reap_0"..math.random(1,3))
	end

	local targethealth = target:GetHealth()
	local poison = self:GetSpecialValueFor("poison")*0.01
	local poison_max = caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("limit")
	local addpoison = math.min(poison*(target:GetMaxHealth() - targethealth)*index,poison_max)

	target:AddNewModifier(caster, self, "modifier_Advanced_Reapers_Scythe", {duration = self:GetSpecialValueFor("stun_duration")})
	target:Poison(caster,self,addpoison)

	local radius = self:GetSpecialValueFor("radius")
	local max = self:GetSpecialValueFor("max")
	local percent = self:GetSpecialValueFor("percent")*0.01
	local poisoned= target:FindModifierByName("modifier_hd_poison")
	if self.advanced_level >= 15 then
		max = 6
		percent = 0.7
	end

	if poisoned then
		local wave = poisoned:GetStackCount()*percent
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil,  radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)  
		for i ,enemy in pairs(enemies) do 
			if enemy ~= target then
				enemy:Poison(caster,self,wave)
				i = i+1
				if i >= max then
					break
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Reapers_Scythe = advanced_modifier({})
function modifier_Advanced_Reapers_Scythe:IsDebuff() return true end 
function modifier_Advanced_Reapers_Scythe:IsHidden() return true end 
function modifier_Advanced_Reapers_Scythe:IsPurgable() return true end 
function modifier_Advanced_Reapers_Scythe:IgnoreTenacity() return true end  --忽略韧性
function modifier_Advanced_Reapers_Scythe:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Reapers_Scythe:GetEffectName()return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf" end
function modifier_Advanced_Reapers_Scythe:StatusEffectPriority()return MODIFIER_PRIORITY_ULTRA end
function modifier_Advanced_Reapers_Scythe:GetPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_Advanced_Reapers_Scythe:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Reapers_Scythe:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.ability = self:GetAbility()

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(orig_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(orig_fx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_Advanced_Reapers_Scythe:OnRefresh()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.ability = self:GetAbility()

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(orig_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(orig_fx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_Advanced_Reapers_Scythe:CheckState()
	local state ={
		[MODIFIER_STATE_STUNNED] = true
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 20 then
		state = {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_SILENCED] = true
		}
	end
	return state
end

function modifier_Advanced_Reapers_Scythe:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		}
	return decFuncs
end

function modifier_Advanced_Reapers_Scythe:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_Advanced_Reapers_Scythe:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		
		if target:IsAlive() and self.ability then
			local poison = target:FindModifierByName("modifier_hd_poison")
			if poison then
				local poison_end = self.ability:GetSpecialValueFor("poison_end")*0.0446
				ApplyPoisonDamage(caster,self.ability,target,poison:GetStackCount()*poison_end)
				poison:Destroy()
				if self.ability.advanced_level >= 10 then
					local damageTable = {
						victim = target,
						attacker = caster,
						damage = caster:HDGetPrimaryStatValue()*5,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self.ability
					}
					ApplyDamage(damageTable)
				end
			end
		end

		if not target:IsAlive() and self.ability then
			local lostmp = self.ability:GetSpecialValueFor("lostmp")*0.01
			if self.ability.advanced_level >= 5 then
				lostmp = 0.3
			end
			local mp = (caster:GetMaxMana()-caster:GetMana())*lostmp
			caster:GiveMana(mp)
			self.ability:EndCooldown()
		end
	end
end

