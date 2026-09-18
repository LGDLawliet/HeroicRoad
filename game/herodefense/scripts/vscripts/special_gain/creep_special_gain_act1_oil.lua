creep_special_gain_act1_oil = class({})

LinkLuaModifier("modifier_creep_special_gain_act1_oil", "special_gain/creep_special_gain_act1_oil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_act1_oil_effect", "special_gain/creep_special_gain_act1_oil", LUA_MODIFIER_MOTION_NONE)
function creep_special_gain_act1_oil:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_act1_oil"
end



modifier_creep_special_gain_act1_oil = advanced_modifier({})


function modifier_creep_special_gain_act1_oil:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", context )
end
function modifier_creep_special_gain_act1_oil:IsHidden()return true end
function modifier_creep_special_gain_act1_oil:IsDebuff()return true end
function modifier_creep_special_gain_act1_oil:IsPurgable()return false end
function modifier_creep_special_gain_act1_oil:IsPurgeException() 	return false end
function modifier_creep_special_gain_act1_oil:RemoveOnDeath() return false end
function modifier_creep_special_gain_act1_oil:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creep_special_gain_act1_oil:OnCreated(table)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_creep_special_gain_act1_oil:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end
function modifier_creep_special_gain_act1_oil:OnDeath(keys)
    if not IsServer() then
        return
    end
    if not keys.attacker then
        return
    end
    if keys.unit == self:GetParent() then
		local parent = self:GetParent()
		local pos = keys.attacker:GetAbsOrigin()
		local units = FindUnitsInRadius(parent:GetTeamNumber(), pos, nil, self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	  	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		
		ParticleManager:SetParticleControl( effect_cast, 0,pos )
		ParticleManager:SetParticleControl( effect_cast, 0,Vector(self.radius,0,0) )
		pos.z = pos.z +64
		ParticleManager:SetParticleControl( effect_cast, 2,pos )
		ParticleManager:ReleaseParticleIndex(effect_cast)
		parent:EmitSound("Hero_Batrider.StickyNapalm.Impact")
		for i, unit in pairs(units) do
			local StatusResistance = unit:GetHDStatusResistanceIndex(0.8)
			unit:AddNewModifier(unit, nil, "modifier_creep_special_gain_act1_oil_effect", {duration = self.duration*StatusResistance})
		end

    end
   
end




modifier_creep_special_gain_act1_oil_effect = advanced_modifier({})

function modifier_creep_special_gain_act1_oil_effect:IsDebuff() return true end
function modifier_creep_special_gain_act1_oil_effect:IsHidden() return false end
function modifier_creep_special_gain_act1_oil_effect:IsPurgable() 		return true end
function modifier_creep_special_gain_act1_oil_effect:RemoveOnDeath()  return false end
function modifier_creep_special_gain_act1_oil_effect:GetTexture() return "batrider_sticky_napalm" end
function modifier_creep_special_gain_act1_oil_effect:OnCreated(keys)

	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	self.move = self:GetAbility():GetSpecialValueFor("move")


	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)

		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_creep_special_gain_act1_oil_effect:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_creep_special_gain_act1_oil_effect:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_creep_special_gain_act1_oil_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}
end
function modifier_creep_special_gain_act1_oil_effect:GetModifierAttackSpeedBonus_Constant() return -self:GetStackCount()*15 end
function modifier_creep_special_gain_act1_oil_effect:GetModifierMoveSpeedBonus_Percentage() return -self:GetStackCount()*10 end