heroTalent_npc_dota_hero_shadow_shaman = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_shaman", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_channeling", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_shadow_shaman_health", "heroTalent/heroTalent_npc_dota_hero_shadow_shaman", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_shadow_shaman:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_shadow_shaman:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_shadow_shaman:IsStealable() 				return true end
function heroTalent_npc_dota_hero_shadow_shaman:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_shadow_shaman:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_shadow_shaman" end
function heroTalent_npc_dota_hero_shadow_shaman:OnSpellStart()
	self.caster = self:GetCaster()
	local cha_duration = self:GetChannelTime()-0.05
	self.channeling = self.caster:AddNewModifier(self.caster, self, "modifier_channeling", {duration = cha_duration})
   
end

function heroTalent_npc_dota_hero_shadow_shaman:OnChannelFinish()
	if self:GetCaster():FindModifierByName("modifier_channeling")	then 
        self:EndCooldown()
		self:StartCooldown(2)
		self.channeling:SetDuration( 0, true )
		self.channeling = nil
	else
        local a_duration = self:GetSpecialValueFor("a_duration")
        local pos = self.caster:GetAbsOrigin()
		local a_units = FindUnitsInRadius(
            self.caster:GetTeamNumber(),	-- int, your team number
            pos,	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            19999,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
        ) 
        for _, a_unit in ipairs(a_units) do
            if a_unit:IsAlive() then
                local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.5)
                a_unit:AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff", {duration = a_duration*ModifierStatusNegativeGain})
                a_unit:EmitSound("Hero_Lion.Voodoo")
            end
        end
	end
	
end



modifier_heroTalent_npc_dota_hero_shadow_shaman = class({})

function modifier_heroTalent_npc_dota_hero_shadow_shaman:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_shadow_shaman:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_shadow_shaman:DeclareFunctions()
    return 
    {MODIFIER_EVENT_ON_DEATH,} 
end

function modifier_heroTalent_npc_dota_hero_shadow_shaman:OnDeath(keys)
    if not IsServer() then
        return
    end
    if keys.attacker == self:GetParent() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        local pos = keys.unit:GetAbsOrigin()
        local radius =self:GetAbility():GetSpecialValueFor("radius")
        local duration =self:GetAbility():GetSpecialValueFor("duration")
        local caster = self:GetParent()
        if caster:PassivesDisabled() then
            return
        end
        local ability =self:GetAbility()
        local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(),	-- int, your team number
            pos,	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            0,-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
        )

        for _, unit in ipairs(enemies) do
            if unit:IsAlive() then
                local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
                local StatusResistance = unit:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
                unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff", {duration = duration*StatusResistance})
                unit:EmitSound("Hero_Lion.Voodoo")
                break
            end
        end

    end
end






modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff = class({})


function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:IsPurgeException() 	return false end
-- function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:GetTexture() return "lion_voodoo" end
function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:OnCreated( kv )
	if IsServer() then
		self:PlayEffects( true )
	end
end

function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end


function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:GetModifierModelChange()	return "models/items/hex/sheep_hex/sheep_hex.vmdl" end

function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}

	return state
end


function modifier_heroTalent_npc_dota_hero_shadow_shaman_debuff:PlayEffects( bStart )
	local sound_cast = "Hero_Lion.Hex.Target"
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if bStart then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

------------
modifier_channeling = advanced_modifier({})

function modifier_channeling:IsDebuff()			return false end
function modifier_channeling:IsHidden() 			return true end
function modifier_channeling:IsPurgable() 		return false end
function modifier_channeling:IsPurgeException() 	return false end
function modifier_channeling:OnCreated()
	self.caster = self:GetCaster()
end

function modifier_channeling:DeclareFunctions() return   {MODIFIER_EVENT_ON_TAKEDAMAGE,} end


function modifier_channeling:OnTakeDamage(keys)
	self.caster = self:GetCaster()
	local caster = self.caster
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if not keys.attacker then
		return
	end
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", { duration = 0.1})
end
