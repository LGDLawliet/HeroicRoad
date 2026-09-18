
Primary_Coup_De_Grace = class({})

LinkLuaModifier("modifier_Primary_Coup_De_Grace", "skills/Primary_Coup_De_Grace", LUA_MODIFIER_MOTION_NONE)

function Primary_Coup_De_Grace:GetIntrinsicModifierName() return "modifier_Primary_Coup_De_Grace" end

modifier_Primary_Coup_De_Grace = advanced_modifier({})

function modifier_Primary_Coup_De_Grace:IsDebuff()			return false end
function modifier_Primary_Coup_De_Grace:IsHidden() 		return true end
function modifier_Primary_Coup_De_Grace:IsPurgable() 		return false end
function modifier_Primary_Coup_De_Grace:IsPurgeException() return false end
function modifier_Primary_Coup_De_Grace:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	  	MODIFIER_EVENT_ON_ATTACK_FAIL
	} 
end

function modifier_Primary_Coup_De_Grace:OnCreated() self.crit = {} end
function modifier_Primary_Coup_De_Grace:OnDestroy() self.crit = nil end

function modifier_Primary_Coup_De_Grace:Advanced_GetModifierCriticalStrike(keys)

	if IsServer() and keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then
		local pct = self:GetAbility():GetSpecialValueFor("crit_chance")
		local random = math.random
		if pct > random(0,100) then
			self.crit[keys.record] = true
			local caster = self:GetParent()
			local damage_mul = self:GetAbility():GetSpecialValueFor("crit_bonus")
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

function modifier_Primary_Coup_De_Grace:OnAttackFail(keys) self.crit[keys.record] = nil end


function modifier_Primary_Coup_De_Grace:OnAttackLanded(keys)
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


function modifier_Primary_Coup_De_Grace:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
