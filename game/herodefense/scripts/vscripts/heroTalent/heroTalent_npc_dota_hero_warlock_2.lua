heroTalent_npc_dota_hero_warlock_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_warlock_2", "heroTalent/heroTalent_npc_dota_hero_warlock_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_warlock_2_pain", "heroTalent/heroTalent_npc_dota_hero_warlock_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_warlock_2_heal", "heroTalent/heroTalent_npc_dota_hero_warlock_2", LUA_MODIFIER_MOTION_NONE)


function heroTalent_npc_dota_hero_warlock_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_warlock_2" end
function heroTalent_npc_dota_hero_warlock_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/warlock/warlock_ti9/warlock_ti9_shadow_word_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/warlock/warlock_ti9/warlock_ti9_shadow_word_buff.vpcf", context )
end

function heroTalent_npc_dota_hero_warlock_2:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local summon_table = {}
	local summons = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 10000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE,FIND_ANY_ORDER, false)
	if #summons > 0 then
		for _,summon in pairs(summons) do
			if summon:IsHDSummoned() and summon:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
				local pain = summon:FindModifierByName("modifier_heroTalent_npc_dota_hero_warlock_2_pain")
				local heal = summon:FindModifierByName("modifier_heroTalent_npc_dota_hero_warlock_2_heal")
				if pain then
					pain:Destroy()
				end
				if heal then
					heal:Destroy()
				end
				table.insert(summon_table, summon)
			end
		end
	end
	self.outgoing = self:GetSpecialValueFor("outgoing")
	self.incoming = self:GetSpecialValueFor("incoming")
	self.talentgain1 = self:GetTalentGain(0.7)
	self.talentgain2 = self:GetTalentGain(0.3)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.incoming_t = math.min(self.incoming*self.talentgain2, 90)

	if self:GetToggleState() then
		if #summon_table > 0 then
			for _,summon in pairs(summon_table) do
				summon:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_warlock_2_pain",{outgoing = self.outgoing_t})
			end
		end

	else
		if #summon_table > 0 then
			for _,summon in pairs(summon_table) do
				summon:AddNewModifier(caster,self,"modifier_heroTalent_npc_dota_hero_warlock_2_heal",{incoming = self.incoming_t})
			end
		end
	end
end
----
modifier_heroTalent_npc_dota_hero_warlock_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_warlock_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_warlock_2:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_warlock_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_warlock_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_warlock_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_warlock_2:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.incoming = self.ability:GetSpecialValueFor("incoming")

	self.talentgain1 = self.ability:GetTalentGain(0.7)
	self.talentgain2 = self.ability:GetTalentGain(0.3)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.incoming_t = math.min(self.incoming*self.talentgain2, 90)
end

function modifier_heroTalent_npc_dota_hero_warlock_2:OnSummonUnitFinished(keys)
	if not IsServer() then return end
    local summoner = self.parent
    local target = keys.target
    if not IsValid(target) then return end

	self.talentgain1 = self.ability:GetTalentGain(0.75)
	self.talentgain2 = self.ability:GetTalentGain(0.35)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.incoming_t = math.min(self.incoming*self.talentgain2, 90)

	self.toggle_state = self.ability:GetToggleState()
	if self.toggle_state then
		target:AddNewModifier(summoner,self.ability,"modifier_heroTalent_npc_dota_hero_warlock_2_pain",{outgoing = self.outgoing_t})
	else
		target:AddNewModifier(summoner,self.ability,"modifier_heroTalent_npc_dota_hero_warlock_2_heal",{incoming = self.incoming_t})
	end
end

function modifier_heroTalent_npc_dota_hero_warlock_2:DeclareFunctions()
	return{MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_heroTalent_npc_dota_hero_warlock_2:OnTooltip()
	self.talentgain1 = self.ability:GetTalentGain(0.7)
	self.talentgain2 = self.ability:GetTalentGain(0.3)
	self.outgoing_t = self.outgoing*self.talentgain1
	self.incoming_t = math.min(self.incoming*self.talentgain2, 90)

	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.outgoing_t
    elseif self._tooltip == 2 then
        return self.incoming_t
	end
end
----
modifier_heroTalent_npc_dota_hero_warlock_2_pain = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_warlock_2_pain:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_warlock_2_pain:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_warlock_2_pain:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_warlock_2_pain:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_warlock_2_pain:GetEffectName() return "particles/econ/items/warlock/warlock_ti9/warlock_ti9_shadow_word_debuff.vpcf" end
function modifier_heroTalent_npc_dota_hero_warlock_2_pain:OnCreated(kv)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.hp_lost = self.ability:GetSpecialValueFor("hp_lost")*0.01
	if IsServer() then
		self:SetStackCount(kv.outgoing)
		self:StartIntervalThink(1)
	end
end

function modifier_heroTalent_npc_dota_hero_warlock_2_pain:OnIntervalThink()
	if not self.parent:IsAlive() then
		self:Destroy()
	end
	self.parent:ModifyHealth(self.parent:GetHealth()*(1-self.hp_lost), self.ability, false, 0)
end

function modifier_heroTalent_npc_dota_hero_warlock_2_pain:ADDeclareFunctions()
	return{advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL}
end

function modifier_heroTalent_npc_dota_hero_warlock_2_pain:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return self:GetStackCount()
end
----
modifier_heroTalent_npc_dota_hero_warlock_2_heal = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_warlock_2_heal:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_warlock_2_heal:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_warlock_2_heal:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_warlock_2_heal:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_warlock_2_heal:GetEffectName() return "particles/econ/items/warlock/warlock_ti9/warlock_ti9_shadow_word_buff.vpcf" end
function modifier_heroTalent_npc_dota_hero_warlock_2_heal:OnCreated(kv)
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.hp_regen = self.ability:GetSpecialValueFor("hp_regen")*0.01
	if IsServer() then
		self:SetStackCount(kv.incoming)
		self:StartIntervalThink(1)
	end
end

function modifier_heroTalent_npc_dota_hero_warlock_2_heal:OnIntervalThink()
	if not self.parent:IsAlive() then
		self:Destroy()
	end
	self.parent:Heal(self.parent:GetMaxHealth()*self.hp_regen, self.ability)
end

function modifier_heroTalent_npc_dota_hero_warlock_2_heal:ADDeclareFunctions()	
	return{advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

function modifier_heroTalent_npc_dota_hero_warlock_2_heal:Advanced_GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()
end