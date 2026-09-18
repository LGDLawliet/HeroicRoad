heroTalent_npc_dota_hero_nevermore = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_nevermore", "heroTalent/heroTalent_npc_dota_hero_nevermore", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_nevermore_effect", "heroTalent/heroTalent_npc_dota_hero_nevermore", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_nevermore:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_nevermore"
end

----------------------------
modifier_heroTalent_npc_dota_hero_nevermore = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_nevermore:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_nevermore:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_nevermore:OnCreated( kv )
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.armor_down = self.ability:GetSpecialValueFor("armor_down")*0.01

	self.talentgain = self.ability:GetTalentGain(0.6)
	self.armor_down_max = self.ability:GetSpecialValueFor("armor_down_max")*self.talentgain
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")*self.talentgain
	if IsServer() then
		self:StartIntervalThink(3)
	end
end	
function modifier_heroTalent_npc_dota_hero_nevermore:OnIntervalThink()
	if self.parent:IsAlive() then

		self.talentgain = self.ability:GetTalentGain(0.6)
		self.armor_down_max = self.ability:GetSpecialValueFor("armor_down_max")*self.talentgain
		self.outgoing = self.ability:GetSpecialValueFor("outgoing")*self.talentgain

		self.armor_down_final = math.min(self.armor_down*self.parent:GetAgility(), self.armor_down_max)
		local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, 50000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for i, enemy in ipairs(enemies) do
			enemy:AddNewModifier(self.parent, self.ability,"modifier_heroTalent_npc_dota_hero_nevermore_effect",{duration = 3, armor_down = self.armor_down_final})
		end
	end
end
function modifier_heroTalent_npc_dota_hero_nevermore:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_nevermore:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end
function modifier_heroTalent_npc_dota_hero_nevermore:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if keys.target:GetPhysicalArmorValue(false) >= 0 then return end
	return self.outgoing
end
function modifier_heroTalent_npc_dota_hero_nevermore:OnTooltip(keys)
	self.talentgain = self.ability:GetTalentGain(0.6)
	self.armor_down_max = self.ability:GetSpecialValueFor("armor_down_max")*self.talentgain
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")*self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.armor_down_max
	elseif self._tooltip == 2 then
		return  self.outgoing
	end
end


--------------------------------------------------------

modifier_heroTalent_npc_dota_hero_nevermore_effect = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_nevermore_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:OnCreated(keys)
	if IsServer() then
		self.armor_down = keys.armor_down
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:OnRefresh(keys)
	if IsServer() then
		self.armor_down = keys.armor_down
	end
end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:Advanced_GetModifierPhysicalArmorBonus()
    return -self.armor_down
end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.armor_down
	end
end
function modifier_heroTalent_npc_dota_hero_nevermore_effect:AddCustomTransmitterData( )
	return
	{
		armor_down = self.armor_down,
	}
end

function modifier_heroTalent_npc_dota_hero_nevermore_effect:HandleCustomTransmitterData( data )
	self.armor_down = data.armor_down

end