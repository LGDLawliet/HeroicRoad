
Middle_Coup_De_Grace = class({})

LinkLuaModifier("modifier_Middle_Coup_De_Grace", "skills/Middle_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Coup_De_Grace_break", "skills/Middle_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)

function Middle_Coup_De_Grace:GetIntrinsicModifierName() return "modifier_Middle_Coup_De_Grace" end

modifier_Middle_Coup_De_Grace = advanced_modifier({})

function modifier_Middle_Coup_De_Grace:IsDebuff()			return false end
function modifier_Middle_Coup_De_Grace:IsHidden() 		return true end
function modifier_Middle_Coup_De_Grace:IsPurgable() 		return false end
function modifier_Middle_Coup_De_Grace:IsPurgeException() return false end
function modifier_Middle_Coup_De_Grace:OnCreated() 
	if not IsServer() then
		return
	end
	self.crit = {}
	self.no_armor = self:GetAbility():GetSpecialValueFor("no_armor")
	self.break_duration = self:GetAbility():GetSpecialValueFor("break_duration")
end
function modifier_Middle_Coup_De_Grace:OnDestroy() self.crit = nil end

function modifier_Middle_Coup_De_Grace:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	  	MODIFIER_EVENT_ON_ATTACK_FAIL
	} 
end

function modifier_Middle_Coup_De_Grace:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
    }
end

function modifier_Middle_Coup_De_Grace:Advanced_GetModifierAttackArmor_Ignore(keys)
	return self.no_armor
end

function modifier_Middle_Coup_De_Grace:Advanced_GetModifierCriticalStrike(keys)

	if IsServer() and keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then
		local pct = self:GetAbility():GetSpecialValueFor("crit_chance")
		local random = math.random
		if pct > random(0,100) then
			self.crit[keys.record] = true
			local caster = self:GetParent()
			local damage_mul = self:GetAbility():GetSpecialValueFor("crit_bonus")

			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_Middle_Coup_De_Grace_break", {duration = self.break_duration})
			---天赋部分
			local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_phantom_assassin_4")
			if ability then
				if keys.target:GetHealth()<=caster:GetAverageTrueAttackDamage(nil) then
					ability:CritEffect(keys.target)
					TrueKill(self:GetParent(), keys.target, self:GetAbility())
				else
					if ability:IsCooldownReady() then
						damage_mul =( damage_mul + 100)*2
						ability:UseResources(true, true, true, true)
					else
						damage_mul = damage_mul +100
					end
				end
			end
			---------
			return damage_mul 
		else		
			return 0
		end
	end
end

function modifier_Middle_Coup_De_Grace:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	local caster = self:GetParent()
	if self.crit[keys.record] then
		local pfx_name = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop_r.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
		self:GetParent():EmitSound("Hero_PhantomAssassin.CoupDeGrace")
		ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, keys.target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pfx, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx)
		local pfx_name2 = "particles/econ/events/ti4/blink_dagger_start_sparkles_ti4.vpcf"
		local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN, keys.target)
		ParticleManager:SetParticleControlEnt(pfx2, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx2, 1, keys.target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pfx2, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx2)
	end
	self.crit[keys.record] = nil
end

function modifier_Middle_Coup_De_Grace:OnAttackFail(keys) self.crit[keys.record] = nil end


------------------
modifier_Middle_Coup_De_Grace_break = advanced_modifier({})

function modifier_Middle_Coup_De_Grace_break:IsDebuff()			return true end
function modifier_Middle_Coup_De_Grace_break:IsHidden() 			return false end
function modifier_Middle_Coup_De_Grace_break:IsPurgable() 	    	return false end
function modifier_Middle_Coup_De_Grace_break:IsPurgeException() 	return false end
function modifier_Middle_Coup_De_Grace_break:CheckState()
	return{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end