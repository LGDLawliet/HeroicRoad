
Primary_Reapers_Scythe = Primary_Reapers_Scythe or class({})
LinkLuaModifier("modifier_Primary_Reapers_Scythe", "skills/Primary_Reapers_Scythe", LUA_MODIFIER_MOTION_NONE)

function Primary_Reapers_Scythe:OnSpellStart()
	local target = self:GetCursorTarget()
	self:Reap(target,1)
end

function Primary_Reapers_Scythe:Reap(target,index)
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

	target:AddNewModifier(caster, self, "modifier_Primary_Reapers_Scythe", {duration = self:GetSpecialValueFor("stun_duration")})
	target:Poison(caster,self,addpoison)
end

----------------------------------------------------------------------------------------------------------------------
modifier_Primary_Reapers_Scythe = advanced_modifier({})
function modifier_Primary_Reapers_Scythe:IsDebuff() return true end 
function modifier_Primary_Reapers_Scythe:IsHidden() return true end 
function modifier_Primary_Reapers_Scythe:IsPurgable() return true end 
function modifier_Primary_Reapers_Scythe:IgnoreTenacity() return true end  --忽略韧性
function modifier_Primary_Reapers_Scythe:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_Reapers_Scythe:GetEffectName()return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf" end
function modifier_Primary_Reapers_Scythe:StatusEffectPriority()return MODIFIER_PRIORITY_ULTRA end
function modifier_Primary_Reapers_Scythe:GetPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_Primary_Reapers_Scythe:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Primary_Reapers_Scythe:OnCreated()
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

function modifier_Primary_Reapers_Scythe:OnRefresh()
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

function modifier_Primary_Reapers_Scythe:CheckState()
	local state ={
		[MODIFIER_STATE_STUNNED] = true
		}
	return state
end

function modifier_Primary_Reapers_Scythe:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		}
	return decFuncs
end

function modifier_Primary_Reapers_Scythe:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_Primary_Reapers_Scythe:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		
		if target:IsAlive() and self.ability then
			local poison = target:FindModifierByName("modifier_hd_poison")
			if poison then
				local poison_end = self.ability:GetSpecialValueFor("poison_end")*0.0446
				ApplyPoisonDamage(caster,self.ability,target,poison:GetStackCount()*poison_end)
				poison:Destroy()
			end
		end
	end
end

