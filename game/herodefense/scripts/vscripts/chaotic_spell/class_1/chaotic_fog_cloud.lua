chaotic_fog_cloud = class ({})

LinkLuaModifier("modifier_chaotic_fog_cloud_thinker", "chaotic_spell/class_1/chaotic_fog_cloud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_fog_cloud_buff", "chaotic_spell/class_1/chaotic_fog_cloud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_hold_monster", "chaotic_spell/class_5/chaotic_hold_monster", LUA_MODIFIER_MOTION_NONE)
function chaotic_fog_cloud:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_fog_cloud/effect_cast/chaotic_fog_cloud.vpcf", context )
end

function chaotic_fog_cloud:GetAOERadius()
    return self:GetSpecialValueFor("radius") 
end

function chaotic_fog_cloud:OnSpellStart()
	local caster = self:GetCaster()
	local ability = caster:HasModifier("modifier_heroTalent_npc_dota_hero_riki_2")
	if ability then
		caster:AddNewModifier(nil, nil, "modifier_phased", {duration=1}) --提供相位，防止卡位
		caster:SetAbsOrigin(self:GetCursorPosition())
	end
	CreateModifierThinker(caster, self, "modifier_chaotic_fog_cloud_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
	
end
-----------------------------------------------------------
modifier_chaotic_fog_cloud_thinker = class({})
function modifier_chaotic_fog_cloud_thinker:IsAura()return true end

function modifier_chaotic_fog_cloud_thinker:OnCreated()
	self.team = DOTA_UNIT_TARGET_TEAM_BOTH
	if self:GetAbility():GetRuneType()==1 or self:GetAbility():GetRuneType()==2 or self:GetAbility():GetRuneType()==3 then
		self.team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end

	if IsServer() then

		-- local caster = self:GetCaster()
		local thinker = self:GetParent()
		local ability = self:GetAbility()

		self.radius = ability:GetAOERadius()
		
		thinker:EmitSound("Hero_Riki.Smoke_Screen")
		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_fog_cloud/effect_cast/chaotic_fog_cloud.vpcf", PATTACH_POINT_FOLLOW, thinker)
		ParticleManager:SetParticleControl(self.particle, 0, thinker:GetAbsOrigin()+Vector(0,0,64))
		ParticleManager:SetParticleControl(self.particle, 1, (Vector(self.radius, self.radius, self.radius)))
		-- self:StartIntervalThink(1)
	end
end

function modifier_chaotic_fog_cloud_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_fog_cloud_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_fog_cloud_thinker:GetAuraSearchTeam() return self.team end
function modifier_chaotic_fog_cloud_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_chaotic_fog_cloud_thinker:GetModifierAura()return "modifier_chaotic_fog_cloud_buff" end


function modifier_chaotic_fog_cloud_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end

-------------------------------------------------------

modifier_chaotic_fog_cloud_buff = modifier_chaotic_fog_cloud_buff or advanced_modifier({})

function modifier_chaotic_fog_cloud_buff:IsDebuff()return false end
function modifier_chaotic_fog_cloud_buff:IsPurgable()return true end
-- function modifier_chaotic_fog_cloud_buff:GetAttributes() 
--     return MODIFIER_ATTRIBUTE_MULTIPLE
-- end
function modifier_chaotic_fog_cloud_buff:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	self.evasion = self:GetAbility():GetSpecialValueFor("evasion")
	if self:GetAbility():GetRuneType()==2 then
		self.evasion = self.evasion + self:GetAbility():GetSpecialValueFor("rune_2_evasion")
	end
	self.miss_rate = self:GetAbility():GetSpecialValueFor("miss")
	if IsServer() and self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invulnerable", {duration = 0.1})
	end
end
function modifier_chaotic_fog_cloud_buff:CheckState()
	if IsServer() then
		return {
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		}
	end
	return
end

function modifier_chaotic_fog_cloud_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_fog_cloud_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil}
	}
end
function modifier_chaotic_fog_cloud_buff:AdvancedGetModifierConstantManaRegen()
	if not self:GetAbility() then self:Destroy() return end
	if self:GetAbility():GetRuneType()==1 then
		return self:GetAbility():GetSpecialValueFor("rune_1_mana_regen")
	end
	return 0
end

function modifier_chaotic_fog_cloud_buff:GetModifierEvasion_Constant()
	if not self:GetAbility() then self:Destroy() return end
    return self.evasion
end
function modifier_chaotic_fog_cloud_buff:OnAttack(keys)
	if not IsServer() then
		return
	end
	if not self:GetAbility() then self:Destroy() return end
	if keys.attacker~=self:GetCaster() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	if keys.attacker:IsRangedAttacker() then
		return
	end
	if self:GetAbility():GetRuneType()~=3 then
		return
	end
	local ability = keys.attacker:FindAbilityByName("chaotic_hold_monster")
	local random = math.random
	local chance = self:GetAbility():GetSpecialValueFor("rune_3_chance")
	local duration = self:GetAbility():GetSpecialValueFor("rune_3_duration")
	if ability then
		if chance >= random(1,100) then
			keys.target:AddNewModifier(keys.attacker, ability, "modifier_chaotic_hold_monster", {duration = duration,gain=1})
		end
	end
end
function modifier_chaotic_fog_cloud_buff:GetModifierMiss_Percentage()
	return self.miss_rate
end

function modifier_chaotic_fog_cloud_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:GetModifierEvasion_Constant()
	elseif self._tooltip == 2 then
		return self:GetModifierMiss_Percentage()
	end
end
