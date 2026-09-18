item_hd_bullwhip = class({})

LinkLuaModifier("modifier_item_hd_bullwhip", "items/item_hd_bullwhip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bullwhip_active", "items/item_hd_bullwhip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_bullwhip_active_effect", "items/item_hd_bullwhip", LUA_MODIFIER_MOTION_NONE)

function item_hd_bullwhip:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/bullwhip/self.vpcf", context )
end
function item_hd_bullwhip:GetCustomCastErrorTarget(target)
	return self.error
end

function item_hd_bullwhip:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target.GetPlayerOwnerID and caster.GetPlayerOwnerID  then
			if PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(),caster:GetPlayerOwnerID()) then
				self.error = "#DOTA_CUSTOM_CAST_DENY_DISABLE_HELP"
				return UF_FAIL_CUSTOM
			end
			
		end
		local result = self.BaseClass.CastFilterResultTarget(self,target)
		return result or UF_SUCCESS
	end
end

function item_hd_bullwhip:OnSpellStart()
 	local caster = self:GetCaster()
 	local target = self:GetCursorTarget()
 	target:EmitSound("Item.Bullwhip.Ally")
 	local effect_name = "particles/rebuild/items/bullwhip/self.vpcf"
	local particle = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 6, Vector(0,0,0))
	ParticleManager:ReleaseParticleIndex(particle)
	
	local damage = math.max(self:GetSpecialValueFor("damage_pct")*0.01*target:GetHealth(),self:GetSpecialValueFor("damage"))
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	target:AddNewModifier(caster, self, "modifier_item_hd_bullwhip", {duration = self:GetSpecialValueFor("duration")})
end

-----------------------------

modifier_item_hd_bullwhip = advanced_modifier({})

function modifier_item_hd_bullwhip:IsDebuff() return false end
function modifier_item_hd_bullwhip:IsHidden() return false end
function modifier_item_hd_bullwhip:IsPurgable() return false end


function modifier_item_hd_bullwhip:OnCreated(keys)
    self.ability = self:GetAbility()
	self.active_move = self.ability:GetSpecialValueFor("active_move")
	self.active_attack_speed = self.ability:GetSpecialValueFor("active_attack_speed")

end

function modifier_item_hd_bullwhip:OnRefresh(keys)
    self.ability = self:GetAbility()
	self.active_move = self.ability:GetSpecialValueFor("active_move")
	self.active_attack_speed = self.ability:GetSpecialValueFor("active_attack_speed")

end

function modifier_item_hd_bullwhip:GetModifierAttackSpeedBonus_Constant()	return self.active_attack_speed end
function modifier_item_hd_bullwhip:GetModifierMoveSpeedBonus_Constant()	return self.active_move end


function modifier_item_hd_bullwhip:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

