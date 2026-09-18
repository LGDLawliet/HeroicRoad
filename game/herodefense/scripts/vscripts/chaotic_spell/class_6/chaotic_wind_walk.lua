LinkLuaModifier( "modifier_chaotic_wind_walk", "chaotic_spell/class_6/chaotic_wind_walk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_wind_walk_advanced", "chaotic_spell/class_6/chaotic_wind_walk", LUA_MODIFIER_MOTION_NONE )

chaotic_wind_walk = class({})
function chaotic_wind_walk:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_wind_walk/effect_cast/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_wind_walk/cloud_effect/effect.vpcf", context )
end
function chaotic_wind_walk:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_wind_walk:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("chaotic_wind_walk_cast")  
	local pos = caster:GetOrigin()+Vector(0,0,64)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_wind_walk/effect_cast/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	DestroyParticleByDelay(effect_cast1,5)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	-- local heal =  self:GetSpecialValueFor("base_damage")+self:GetSpecialValueFor("bonus_damage") * caster:HDGetPrimaryStatValue()
	local duration = self:GetSpecialValueFor("duration")*caster:GetModifierDurationGainIndex(1)

	local count = self:GetSpecialValueFor("count")
	for _, unit in ipairs(units) do
		count = count - 1
		self:ApplyModifier(unit, duration)
		if unit:IsRealHero() then
			self:ApplyModifier2(unit, duration)
	
		end
		if count<=0 then
			break
		end
	end
end


-- function chaotic_wind_walk:PlayEffect(target)
-- 	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_wind_walk/food_hit/food_end_right.vpcf", PATTACH_CUSTOMORIGIN, target )
-- 	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
-- 	ParticleManager:ReleaseParticleIndex(effect_cast1)
-- 	-- target:EmitSound("chaotic_wind_walk_target")
-- end

function chaotic_wind_walk:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_wind_walk", {duration = duration})
end
function chaotic_wind_walk:ApplyModifier2(target, duration)
	local caster = self:GetCaster()
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_wind_walk_advanced", {duration = duration})
end










modifier_chaotic_wind_walk = advanced_modifier({})

function modifier_chaotic_wind_walk:IsHidden() 			return false end
function modifier_chaotic_wind_walk:IsPurgable() 			return true end
function modifier_chaotic_wind_walk:IsPurgeException() 	return true end
function modifier_chaotic_wind_walk:IsDebuff() return false end
function modifier_chaotic_wind_walk:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_wind_walk/cloud_effect/effect.vpcf" end

function modifier_chaotic_wind_walk:OnCreated(keys)
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
end
function modifier_chaotic_wind_walk:OnRefresh(keys)
	self:OnCreated(keys)
end
function modifier_chaotic_wind_walk:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_chaotic_wind_walk:Advanced_GetModifier_FlyingPathing()	
	return 1
end

function modifier_chaotic_wind_walk:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end
function modifier_chaotic_wind_walk:GetModifierMoveSpeedBonus_Constant() return   self.bonus_move_speed end
function modifier_chaotic_wind_walk:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end

function modifier_chaotic_wind_walk:GetVisualZDelta( params )
	return 150
end





modifier_chaotic_wind_walk_advanced = advanced_modifier({})

function modifier_chaotic_wind_walk_advanced:IsHidden() 			return false end
function modifier_chaotic_wind_walk_advanced:IsPurgable() 			return true end
function modifier_chaotic_wind_walk_advanced:IsPurgeException() 	return true end
function modifier_chaotic_wind_walk_advanced:IsDebuff() return false end


function modifier_chaotic_wind_walk_advanced:OnCreated(keys)
	self.damage_reduction = -self:GetAbility():GetSpecialValueFor("damage_reduction")

end
function modifier_chaotic_wind_walk_advanced:OnRefresh(keys)
	self:OnCreated(keys)
end
function modifier_chaotic_wind_walk_advanced:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end



function modifier_chaotic_wind_walk_advanced:OnTooltip() return self.damage_reduction end
function modifier_chaotic_wind_walk_advanced:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end



function modifier_chaotic_wind_walk_advanced:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },

    }
end


function modifier_chaotic_wind_walk_advanced:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL   then
		return self.damage_reduction
	end

end



function modifier_chaotic_wind_walk_advanced:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() then 
		return 
	end
	local mana_cast = keys.ability:GetManaCost(keys.ability:GetLevel())
	if mana_cast < 1 then
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel())<0.5 then
		return
	end
	if keys.ability==self:GetAbility() then
		return
	end
	
	self:SafeDestroy()
	
end
