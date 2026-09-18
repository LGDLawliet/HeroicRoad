heroTalent_npc_dota_hero_bane = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bane", "heroTalent/heroTalent_npc_dota_hero_bane", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bane_buff", "heroTalent/heroTalent_npc_dota_hero_bane", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bane_debuff", "heroTalent/heroTalent_npc_dota_hero_bane", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_bane_self", "heroTalent/heroTalent_npc_dota_hero_bane", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_bane:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_bane"
end

function heroTalent_npc_dota_hero_bane:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	self.talentgain = self:GetTalentGain(0.7)
	self.attack = self:GetSpecialValueFor("attack")
	self.spell_amp = self:GetSpecialValueFor("spell_amp")
	self.profic = self:GetSpecialValueFor("profic")
	self.incoming = self:GetSpecialValueFor("incoming")
	self.attack_t = self.attack * self.talentgain
	self.spell_amp_t = self.spell_amp * self.talentgain
	self.profic_t = self.profic * self.talentgain
	self.incoming_t = self.incoming * self.talentgain

	local duration = self:GetSpecialValueFor("duration")
	local buff = target:FindModifierByName("modifier_heroTalent_npc_dota_hero_bane_buff")
	if buff then
		buff:Destroy()
	else
		local newbuff = target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_bane_buff", 
		{	duration = duration,
			attack = self.attack_t,
			spell_amp = self.spell_amp_t,
			profic = self.profic_t,
			incoming = self.incoming_t,
		}
		)
	end

	if target ~= caster then
		caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_bane_self", {duration = duration})
	end
end
modifier_heroTalent_npc_dota_hero_bane = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bane:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_bane:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bane:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bane:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bane:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_bane:OnCreated(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.talentgain = self.ability:GetTalentGain(0.7)
	self.attack = self.ability:GetSpecialValueFor("attack")
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.attack_t = self.attack * self.talentgain
	self.spell_amp_t = self.spell_amp * self.talentgain
	self.profic_t = self.profic * self.talentgain
	self.incoming_t = self.incoming * self.talentgain
end
function modifier_heroTalent_npc_dota_hero_bane:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_heroTalent_npc_dota_hero_bane:OnTooltip()
	self.talentgain = self.ability:GetTalentGain(0.7)
	self.attack = self.ability:GetSpecialValueFor("attack")
	self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")
	self.profic = self.ability:GetSpecialValueFor("profic")
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.attack_t = self.attack * self.talentgain
	self.spell_amp_t = self.spell_amp * self.talentgain
	self.profic_t = self.profic * self.talentgain
	self.incoming_t = self.incoming * self.talentgain

	self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return self.attack_t
	elseif self._tooltip == 2 then
		return self.spell_amp_t
	elseif self._tooltip == 3 then
		return self.profic_t
	elseif self._tooltip == 4 then
		return self.incoming_t
	end
end
modifier_heroTalent_npc_dota_hero_bane_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bane_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_bane_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_bane_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_bane_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_bane_buff:GetEffectName()
	return "particles/rebuild/spell/nightmare/bane_slumber_nightmare.vpcf"
end
function modifier_heroTalent_npc_dota_hero_bane_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_heroTalent_npc_dota_hero_bane_buff:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("fear_duration")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.hpcost = self.ability:GetSpecialValueFor("hpcost")*0.01
	if IsServer() then
		self.attack = keys.attack
		self.spell_amp = keys.spell_amp
		self.profic = keys.profic
		self.incoming = keys.incoming
		self:SetHasCustomTransmitterData( true )-- 同步cy
		self:StartIntervalThink(1)
	end
end
function modifier_heroTalent_npc_dota_hero_bane_buff:OnIntervalThink()
	if self.parent:IsAlive() then
		self.parent:ModifyHealth(self.parent:GetHealth() - self.parent:GetMaxHealth()*self.hpcost, self.ability, false, 0)
	end
end
function modifier_heroTalent_npc_dota_hero_bane_buff:OnDestroy(keys)
	if not IsServer() then return end
	if self:GetAbility() then
		self:NightmareOverflow(self.parent)
		if self.caster:IsAlive() and self.parent ~= self.caster then
			self.caster:RemoveNoDraw()
		end
	end
end
function modifier_heroTalent_npc_dota_hero_bane_buff:AddCustomTransmitterData( )
	return
	{
		attack = self.attack,
		spell_amp = self.spell_amp,
		profic = self.profic,
		incoming = self.incoming,
	}
end
function modifier_heroTalent_npc_dota_hero_bane_buff:HandleCustomTransmitterData( data )
	self.attack = data.attack
	self.spell_amp = data.spell_amp
	self.profic = data.profic
	self.incoming = data.incoming
end
function modifier_heroTalent_npc_dota_hero_bane_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
    }
end
function modifier_heroTalent_npc_dota_hero_bane_buff:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_heroTalent_npc_dota_hero_bane_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage(keys)
	return self.attack
end
function modifier_heroTalent_npc_dota_hero_bane_buff:Advanced_GetModifierSpellAmplifyBonus(keys)
	return self.spell_amp
end
function modifier_heroTalent_npc_dota_hero_bane_buff:Advanced_GetModifier_TalentEffectGain(keys)
	return self.profic
end
-- 噩梦满溢恐惧效果
function modifier_heroTalent_npc_dota_hero_bane_buff:NightmareOverflow(target)
	if not IsServer() then return end

	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			enemy:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_bane_debuff", {
				duration = self.duration,
				incoming = self.incoming
			})
		end
	end
end
function modifier_heroTalent_npc_dota_hero_bane_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	elseif self._tooltip == 2 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
	elseif self._tooltip == 3 then
        return self:Advanced_GetModifier_TalentEffectGain()
    end
end
function modifier_heroTalent_npc_dota_hero_bane_buff:PlayEffects(target)
	local particle_cast = "particles/units/heroes/hero_bane/bane_sap.vpcf"
	local sound_cast = "Hero_Bane.BrainSap"
	local sound_target = "Hero_Bane.BrainSap.Target"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(),
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self.parent:GetOrigin(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self.parent )
	EmitSoundOn( sound_target, target )
end
-- 恐惧modifier
modifier_heroTalent_npc_dota_hero_bane_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bane_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_bane_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_bane_debuff:IsStunDebuff() return false end
function modifier_heroTalent_npc_dota_hero_bane_debuff:IsPurgable() return true end
function modifier_heroTalent_npc_dota_hero_bane_debuff:GetEffectName()
    return "particles/generic_gameplay/generic_feared.vpcf"
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:OnCreated(kv)
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
    if IsServer() then
        self:StartIntervalThink(FrameTime())
        self.direction = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
		self:SetStackCount(kv.incoming)
    end
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:OnIntervalThink()
    if IsServer() then
        if self.parent:IsNull() or not self.parent:IsAlive() then return end
        
        -- 更新逃跑方向
        self.direction = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
        self.parent:MoveToPosition(self.parent:GetAbsOrigin() + self.direction * 200)
    end
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_FEARED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:GetModifierMoveSpeed_Absolute()
    return 200 -- 恐惧移动速度
end
function modifier_heroTalent_npc_dota_hero_bane_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    return self:GetStackCount()
end

----
modifier_heroTalent_npc_dota_hero_bane_self = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_bane_self:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_bane_self:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_bane_self:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_bane_self:OnCreated()
	if IsServer() then
		self:GetCaster():AddNoDraw()
	end
end
function modifier_heroTalent_npc_dota_hero_bane_self:CheckState()
	return{
		[MODIFIER_STATE_SILENCED]						= true,
		[MODIFIER_STATE_INVULNERABLE] 					= true,
		[MODIFIER_STATE_DISARMED]						= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]				= true,
		[MODIFIER_STATE_UNSELECTABLE]					= true,
		[MODIFIER_STATE_MUTED]							= true,
		[MODIFIER_STATE_ROOTED]							= true,
	}
end
