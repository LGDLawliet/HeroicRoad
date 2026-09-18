item_hd_wingfall_hammer =item_hd_wingfall_hammer or  class({})
-- LinkLuaModifier("modifier_item_hd_wingfall_hammer_arua", "items/item_hd_wingfall_hammer", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_wingfall_hammer_arua_effect", "items/item_hd_wingfall_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wingfall_hammer", "items/item_hd_wingfall_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_wingfall_hammer_active", "items/item_hd_wingfall_hammer", LUA_MODIFIER_MOTION_NONE)


function item_hd_wingfall_hammer:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", context )

end
function item_hd_wingfall_hammer:GetIntrinsicModifierName()
	return "modifier_item_hd_wingfall_hammer"
end



modifier_item_hd_wingfall_hammer = modifier_item_hd_wingfall_hammer or class({})

function modifier_item_hd_wingfall_hammer:IsDebuff() return false end
function modifier_item_hd_wingfall_hammer:IsHidden() return true end
function modifier_item_hd_wingfall_hammer:IsPurgable() return false end
function modifier_item_hd_wingfall_hammer:IsPurgeException() return false end
function modifier_item_hd_wingfall_hammer:RemoveOnDeath() return false end

function modifier_item_hd_wingfall_hammer:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	self.bonus_str = ability:GetSpecialValueFor("bonus_str")
	-- if IsServer() then
	-- 	-- local parent = self:GetParent()
	-- 	self:StartIntervalThink(1)
	-- end
end


function modifier_item_hd_wingfall_hammer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_item_hd_wingfall_hammer:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_wingfall_hammer:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
function modifier_item_hd_wingfall_hammer:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	local ability = self:GetAbility()
	if ability:IsCooldownReady() then
		if keys.damage<=0 then
			return
		end
		local caster = self:GetCaster()
		local particle = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_CUSTOMORIGIN, nil)
		local caster_pos = caster:GetOrigin()
		ParticleManager:SetParticleControl(particle, 0, caster_pos)
		ParticleManager:SetParticleControl(particle, 1, Vector(400,0,0))
		DestroyParticleByDelay(particle,2)
		caster:EmitSound("Hero_Omniknight.Purification.Wingfall")
		ability:UseResources(true, true, true, true)
		local units = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)

		local heal =keys.damage *0.75
		for _,unit in pairs(units) do

			local healing = HealWithGain(heal,caster,unit,ability)
	
    		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
		end
	end

	
end
