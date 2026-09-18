Middle_Corrosive_Skin = class({})
LinkLuaModifier( "modifier_Middle_Corrosive_Skin", "skills/Middle_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Corrosive_Skin_debuff", "skills/Middle_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Corrosive_Skin_thinker", "skills/Middle_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Corrosive_Skin_thinker_friendly", "skills/Middle_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Corrosive_Skin_thinker_enemy", "skills/Middle_Corrosive_Skin", LUA_MODIFIER_MOTION_NONE )
function Middle_Corrosive_Skin:GetIntrinsicModifierName()
	return "modifier_Middle_Corrosive_Skin"
end
function Middle_Corrosive_Skin:GetCastRange()
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end


modifier_Middle_Corrosive_Skin = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Corrosive_Skin:IsHidden()	return false end
function modifier_Middle_Corrosive_Skin:IsPurgable()	return false end
function modifier_Middle_Corrosive_Skin:IsPurgeException() return false end
function modifier_Middle_Corrosive_Skin:RemoveOnDeath() return false end
function modifier_Middle_Corrosive_Skin:DestroyOnExpire()	return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Corrosive_Skin:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Middle_Corrosive_Skin:OnRefresh( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_Middle_Corrosive_Skin:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
	}
	return funcs
end

function modifier_Middle_Corrosive_Skin:OnTakeDamage( params )
	if not IsServer() then return end
	local caster = self:GetCaster()
	-- filter
	if params.unit~=caster then return end
	if caster:PassivesDisabled() then return end
	if params.attacker:GetTeamNumber()==caster:GetTeamNumber() then return end
	if params.attacker:IsMagicImmune() then return end

	local distance = (params.attacker:GetOrigin()-params.unit:GetOrigin()):Length2D()
	if distance>self.max_range then return end
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = params.attacker:GetHDStatusResistanceIndex(0.2)*ModifierStatusNegativeGain

	params.attacker:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Corrosive_Skin_debuff", { duration = self.duration*StatusResistance } )

	local sound_cast = "hero_viper.CorrosiveSkin"
	EmitSoundOn( sound_cast, params.attacker )

	self:SetStackCount(self:GetStackCount()+params.damage)
	local need = caster:GetMaxHealth()*self:GetAbility():GetSpecialValueFor("line")*0.01
	if self:GetStackCount() >= need and self:GetRemainingTime() <=0 then
		self:SetStackCount(0)
		self:SetDuration(self:GetAbility():GetSpecialValueFor("middle_duration"),true)

		local pos = caster:GetAbsOrigin()
        CreateModifierThinker(caster, self:GetAbility(), "modifier_Middle_Corrosive_Skin_thinker", 
        {duration = self:GetAbility():GetSpecialValueFor("middle_duration")}, pos, caster:GetTeamNumber(), false)
	end
end

---------------------------------------------------------------------------------------------------------

modifier_Middle_Corrosive_Skin_debuff = advanced_modifier({})


function modifier_Middle_Corrosive_Skin_debuff:IsHidden()	return false end
function modifier_Middle_Corrosive_Skin_debuff:IsDebuff()	return true end
function modifier_Middle_Corrosive_Skin_debuff:IsPoisonDeBuff()	return true end
function modifier_Middle_Corrosive_Skin_debuff:IsPurgable()	return false end

function modifier_Middle_Corrosive_Skin_debuff:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "attack_speed_down" )
	if not IsServer() then return end
	self:StartIntervalThink(1)
end

function modifier_Middle_Corrosive_Skin_debuff:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "attack_speed_down" )
end


function modifier_Middle_Corrosive_Skin_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_Middle_Corrosive_Skin_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.slow
end

function modifier_Middle_Corrosive_Skin_debuff:OnIntervalThink()
	if self:GetAbility() then
		local poison = self:GetAbility():GetSpecialValueFor("poison")+self:GetAbility():GetSpecialValueFor("bonus_poison")*self:GetCaster():GetStrength()
		self:GetParent():Poison(self:GetCaster(), self:GetAbility(), poison)
	end
end


function modifier_Middle_Corrosive_Skin_debuff:GetEffectName()	return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf" end
function modifier_Middle_Corrosive_Skin_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
-------------------------------------------------------------------------------------------------------------

modifier_Middle_Corrosive_Skin_thinker = advanced_modifier({})

function modifier_Middle_Corrosive_Skin_thinker:RemoveOnDeath() return true end
function modifier_Middle_Corrosive_Skin_thinker:IsAura()return true end

function modifier_Middle_Corrosive_Skin_thinker:GetModifierAura()	return "modifier_Middle_Corrosive_Skin_thinker_friendly" end
function modifier_Middle_Corrosive_Skin_thinker:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("middle_radius")  end
function modifier_Middle_Corrosive_Skin_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_Corrosive_Skin_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Middle_Corrosive_Skin_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end
function modifier_Middle_Corrosive_Skin_thinker:OnCreated(keys)
    if IsServer() then
		local ability = self:GetAbility()
		self.poison = self:GetAbility():GetSpecialValueFor( "poison" )+self:GetAbility():GetSpecialValueFor( "bonus_poison" )*self:GetCaster():GetStrength()
        self.radius = self:GetAbility():GetSpecialValueFor("middle_radius")

        self:StartIntervalThink(0.3)
        self.caster = ability:GetCaster()
        self.ability = ability

		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/nethertoxin_with_radius/hethertoxin.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 61, Vector(self.radius, self.radius/400, 0))

		self:AddParticle(pfx, false, false, 15, false, false)
        self.team = self.caster:GetTeamNumber()
	end
end

function modifier_Middle_Corrosive_Skin_thinker:OnIntervalThink()
	local caster = self.caster
	local enemies = FindUnitsInRadius(self.team, self:GetParent():GetAbsOrigin(), nil, self.radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Middle_Corrosive_Skin_thinker_enemy",{duration = 0.35})
	end
end



function modifier_Middle_Corrosive_Skin_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end





modifier_Middle_Corrosive_Skin_thinker_friendly = advanced_modifier({})
function modifier_Middle_Corrosive_Skin_thinker_friendly:IsHidden()	return true end
function modifier_Middle_Corrosive_Skin_thinker_friendly:IsDebuff()	return false end
function modifier_Middle_Corrosive_Skin_thinker_friendly:IsPurgable()	return false end
function modifier_Middle_Corrosive_Skin_thinker_friendly:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Middle_Corrosive_Skin_thinker_friendly:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end


function modifier_Middle_Corrosive_Skin_thinker_friendly:AdvancedGetModifierConstantHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("middle_heal")
end

modifier_Middle_Corrosive_Skin_thinker_enemy = advanced_modifier({})
function modifier_Middle_Corrosive_Skin_thinker_enemy:IsHidden()	return true end
function modifier_Middle_Corrosive_Skin_thinker_enemy:IsDebuff()	return true end
function modifier_Middle_Corrosive_Skin_thinker_enemy:IsPurgable()	return false end

function modifier_Middle_Corrosive_Skin_thinker_enemy:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end


function modifier_Middle_Corrosive_Skin_thinker_enemy:GetModifierMagicalResistanceBonus()
	return -self:GetAbility():GetSpecialValueFor("magic_resist_down")
end
