item_hd_jasper_daggers = class({})

LinkLuaModifier("modifier_item_hd_jasper_daggers", "items/item_hd_jasper_daggers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_jasper_daggers_active", "items/item_hd_jasper_daggers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_jasper_daggers_delay", "items/item_hd_jasper_daggers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_jasper_daggers_frozen", "items/item_hd_jasper_daggers", LUA_MODIFIER_MOTION_NONE)
function item_hd_jasper_daggers:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_attack_blur_crit.vpcf", context )


	
	
end



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_jasper_daggers:GetIntrinsicModifierName()
	return "modifier_item_hd_jasper_daggers"
end


modifier_item_hd_jasper_daggers = class({})

function modifier_item_hd_jasper_daggers:IsDebuff() return false end
function modifier_item_hd_jasper_daggers:IsHidden() return true end
function modifier_item_hd_jasper_daggers:IsPurgable() return false end
function modifier_item_hd_jasper_daggers:IsPurgeException() return false end
function modifier_item_hd_jasper_daggers:RemoveOnDeath() return false end
function modifier_item_hd_jasper_daggers:DestroyOnExpire() return false end
function modifier_item_hd_jasper_daggers:OnCreated(keys)
	self.bonus_agi =  self:GetAbility():GetSpecialValueFor("bonus_agi")
	
	if IsServer() then
		-- self:StartIntervalThink(0.2)
	end
end

function modifier_item_hd_jasper_daggers:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,     
		MODIFIER_EVENT_ON_ATTACK_LANDED 

	}
end
function modifier_item_hd_jasper_daggers:GetModifierBonusStats_Agility()return self.bonus_agi end

-- function modifier_item_hd_jasper_daggers:OnIntervalThink()
-- 	local ability = self:GetAbility()
-- 	if ability:IsCooldownReady() then
-- 		local parent = self:GetParent()
-- 		if not parent:HasModifier("modifier_item_hd_jasper_daggers_active") and parent:IsAlive() then
-- 			parent:AddNewModifier(parent, ability, "modifier_item_hd_jasper_daggers_active", {})
-- 		end
-- 	end
-- end	



function modifier_item_hd_jasper_daggers:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	local ability = self:GetAbility()
	if self:GetAbility():IsCooldownReady() then
		if keys.target:HasModifier("modifier_item_hd_jasper_daggers_delay") then
			return
		end
		local caster = self:GetCaster()
		if math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(CalculateDirection(keys.target:GetAbsOrigin(),caster:GetAbsOrigin())).y)) <=55 then
			keys.target:AddNewModifier(caster, ability, "modifier_item_hd_jasper_daggers_delay", {duration = 5})
			keys.target:AddNewModifier(caster, ability, "modifier_item_hd_jasper_daggers_frozen", {duration = 1})
			caster:AddNewModifier(caster, ability, "modifier_item_hd_jasper_daggers_active", {duration = 1})

			local pfx_name = "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_crit_impact.vpcf"
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
			self:GetParent():EmitSound("Hero_PhantomAssassin.CoupDeGrace")
			ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc",  keys.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1,  keys.target:GetAbsOrigin())
			ParticleManager:SetParticleControlOrientation(pfx, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
			ParticleManager:ReleaseParticleIndex(pfx)



			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin_persona/pa_persona_attack_blur_crit.vpcf", PATTACH_ABSORIGIN,caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc",  caster:GetAbsOrigin(), true)
			-- ParticleManager:SetParticleControl(pfx, 1,  keys.target:GetAbsOrigin())
			-- ParticleManager:SetParticleControlOrientation(pfx, 1, caster:GetForwardVector() * -1, caster:GetRightVector(), caster:GetUpVector())
			ParticleManager:ReleaseParticleIndex(pfx)


			
		end
	
	end
	
end



modifier_item_hd_jasper_daggers_active = class({})

function modifier_item_hd_jasper_daggers_active:IsDebuff() return false end
function modifier_item_hd_jasper_daggers_active:IsHidden() return true end
function modifier_item_hd_jasper_daggers_active:IsPurgable() return false end
function modifier_item_hd_jasper_daggers_active:IsPurgeException() return false end
function modifier_item_hd_jasper_daggers_active:RemoveOnDeath() return false end
function modifier_item_hd_jasper_daggers_active:GetTexture() return "item_jasper_daggers" end
function modifier_item_hd_jasper_daggers_active:GetModifierBaseAttackTimeConstant() return 0.3 end
function modifier_item_hd_jasper_daggers_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

modifier_item_hd_jasper_daggers_delay = class({})

function modifier_item_hd_jasper_daggers_delay:IsDebuff() return true end
function modifier_item_hd_jasper_daggers_delay:IsHidden() return false end
function modifier_item_hd_jasper_daggers_delay:IsPurgable() return false end
function modifier_item_hd_jasper_daggers_delay:IsPurgeException() return false end
function modifier_item_hd_jasper_daggers_delay:RemoveOnDeath() return false end


modifier_item_hd_jasper_daggers_frozen = class({})

function modifier_item_hd_jasper_daggers_frozen:IsDebuff() return true end
function modifier_item_hd_jasper_daggers_frozen:IsHidden() return true end
function modifier_item_hd_jasper_daggers_frozen:IsPurgable() return false end
function modifier_item_hd_jasper_daggers_frozen:IsPurgeException() return false end
function modifier_item_hd_jasper_daggers_frozen:RemoveOnDeath() return false end
function modifier_item_hd_jasper_daggers_frozen:CheckState()
	return  {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,

	}



end
