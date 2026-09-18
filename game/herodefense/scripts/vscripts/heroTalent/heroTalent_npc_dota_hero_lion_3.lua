LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lion_3", "heroTalent/heroTalent_npc_dota_hero_lion_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lion_3_cd", "heroTalent/heroTalent_npc_dota_hero_lion_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_lion_3_debuff", "heroTalent/heroTalent_npc_dota_hero_lion_3.lua", LUA_MODIFIER_MOTION_NONE )
heroTalent_npc_dota_hero_lion_3 = class({})
function heroTalent_npc_dota_hero_lion_3:Precache( context )
    PrecacheResource( "particle", "particles/econ/items/lion/fish_stick/fish_stick_spell_fish.vpcf", context )
end
function heroTalent_npc_dota_hero_lion_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_lion_3"
end
---------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_lion_3 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_lion_3:IsHidden()return false end
function modifier_heroTalent_npc_dota_hero_lion_3:IsDebuff()return false end
function modifier_heroTalent_npc_dota_hero_lion_3:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_lion_3:OnCreated( kv )
	self.ability = self:GetAbility()
	self.cd = self.ability:GetSpecialValueFor("cd")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.mpregen = self.ability:GetSpecialValueFor("mpregen")*0.01
	if IsServer() then
		self.talentgain = self.ability:GetTalentGain(0.8)
		self.chance = self.ability:GetSpecialValueFor("chance")*self.talentgain
		self.outgoing = self.ability:GetSpecialValueFor("outgoing")*self.talentgain
		self:SetHasCustomTransmitterData( true )-- 同步cy
	end
end
function modifier_heroTalent_npc_dota_hero_lion_3:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_lion_3:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		MODIFIER_EVENT_ON_DEATH = {}
	}
end
function modifier_heroTalent_npc_dota_hero_lion_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = self:GetCaster()
	local target = keys.target
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and not target:HasModifier("modifier_heroTalent_npc_dota_hero_lion_3_cd") then

		self.talentgain = self.ability:GetTalentGain(0.8)
		self.chance = self.ability:GetSpecialValueFor("chance")*self.talentgain
		self.outgoing = self.ability:GetSpecialValueFor("outgoing")*self.talentgain

		local random = math.random
		local chance = self.chance
		if chance >= random(1,100) then
			target:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_lion_3_debuff", {duration = self.duration})
			target:AddNewModifier(attacker, self.ability, "modifier_heroTalent_npc_dota_hero_lion_3_cd", {duration = self.cd})
		end
	end
	if target:IsHexed() then
		-- print("增伤生效")
		return self.outgoing
	end
end
function modifier_heroTalent_npc_dota_hero_lion_3:OnDeath(keys)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local attacker = keys.attacker
	local unit = keys.unit
	if not attacker or attacker:GetTeamNumber() ~= caster:GetTeamNumber() or IsEnemy(attacker,unit) then return end
	if not caster:IsAlive() then return end
	if not unit:IsHexed() then return end
	
	attacker:GiveMana(attacker:GetMaxMana()*self.mpregen)
	caster:GiveMana(caster:GetMaxMana()*self.mpregen)
end
function modifier_heroTalent_npc_dota_hero_lion_3:OnTooltip(keys)
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.chance
	elseif self._tooltip == 2 then
		return  self.outgoing
	end
end
function modifier_heroTalent_npc_dota_hero_lion_3:AddCustomTransmitterData( )
	return
	{
		chance = self.chance,
		outgoing = self.outgoing,
		talentgain = self.talentgain,
	}
end

function modifier_heroTalent_npc_dota_hero_lion_3:HandleCustomTransmitterData( data )
	self.chance = data.chance
	self.outgoing = data.outgoing
	self.talentgain = data.talentgain
end
modifier_heroTalent_npc_dota_hero_lion_3_cd = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_lion_3_cd:IsHidden()return true end
function modifier_heroTalent_npc_dota_hero_lion_3_cd:IsDebuff()return false end
function modifier_heroTalent_npc_dota_hero_lion_3_cd:IsPurgable()return false end

modifier_heroTalent_npc_dota_hero_lion_3_debuff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_lion_3_debuff:IsHidden()return false end
function modifier_heroTalent_npc_dota_hero_lion_3_debuff:IsDebuff()return true end
function modifier_heroTalent_npc_dota_hero_lion_3_debuff:IsPurgable()return false end
function modifier_heroTalent_npc_dota_hero_lion_3_debuff:OnCreated( kv )
	self.model = "models/items/hex/fish_hex/fish_hex.vmdl"
	if IsServer() then
		self:PlayEffects( true )
	end
end

function modifier_heroTalent_npc_dota_hero_lion_3_debuff:OnRefresh( kv )
	if IsServer() then
		self:PlayEffects( true )
	end
end

function modifier_heroTalent_npc_dota_hero_lion_3_debuff:OnDestroy( kv )
	if IsServer() then
		self:PlayEffects( false )
	end
end

function modifier_heroTalent_npc_dota_hero_lion_3_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_lion_3_debuff:GetModifierMoveSpeedOverride()
	return 100
end
function modifier_heroTalent_npc_dota_hero_lion_3_debuff:GetModifierModelChange()
	return self.model
end

function modifier_heroTalent_npc_dota_hero_lion_3_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}
	return state
end

function modifier_heroTalent_npc_dota_hero_lion_3_debuff:PlayEffects( bStart )
	local sound_cast = "Hero_Lion.Hex.Target"
	local particle_cast = "particles/econ/items/lion/fish_stick/fish_stick_spell_fish.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	if bStart then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end