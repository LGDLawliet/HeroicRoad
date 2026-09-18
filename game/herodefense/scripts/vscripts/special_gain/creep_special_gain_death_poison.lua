LinkLuaModifier( "modifier_creep_special_gain_death_poison", "special_gain/creep_special_gain_death_poison.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_special_gain_death_poison_thinker", "special_gain/creep_special_gain_death_poison.lua", LUA_MODIFIER_MOTION_NONE )
creep_special_gain_death_poison = class({})

function creep_special_gain_death_poison:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_death_poison"
end
---------------------------------------------------------------------

modifier_creep_special_gain_death_poison = advanced_modifier({})
function modifier_creep_special_gain_death_poison:IsDebuff() return false end
function modifier_creep_special_gain_death_poison:IsHidden() return false end
function modifier_creep_special_gain_death_poison:IsPurgable() return false end

function modifier_creep_special_gain_death_poison:OnCreated(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_creep_special_gain_death_poison:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end
function modifier_creep_special_gain_death_poison:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	local caster = self:GetParent()
	if not keys.attacker then
		return
	end
	local pos = keys.attacker:GetAbsOrigin()
	if caster:PassivesDisabled() then
		self.duration = 0.5*self.duration
	end

	CreateModifierThinker(caster, self:GetAbility(), "modifier_creep_special_gain_death_poison_thinker", 
	{duration = self.duration}, pos, caster:GetTeamNumber(), false)
end

---------------------------------------------------------------------
modifier_creep_special_gain_death_poison_thinker = advanced_modifier({})

function modifier_creep_special_gain_death_poison_thinker:RemoveOnDeath() return true end

function modifier_creep_special_gain_death_poison_thinker:OnCreated(keys)
    if IsServer() then
		local ability = self:GetAbility()
		--self.poison = self:GetAbility():GetSpecialValueFor("poison")*0.01 * self:GetCaster():GetMaxHealth()
		self.poison = 0
        self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.index = self:GetAbility():GetSpecialValueFor("poison")*0.01
        self:StartIntervalThink(1)
        self.caster = ability:GetCaster()
        self.ability = ability
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_nethertoxin.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
        ParticleManager:SetParticleControl(pfx, 3, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 15, false, false)
        self.team = self.caster:GetTeamNumber()
		self:GetParent():EmitSound("Hero_Viper.NetherToxin.TI8")
	end
end

function modifier_creep_special_gain_death_poison_thinker:OnDestroy(keys)
    if IsServer() then
		self:GetParent():StopSound("Hero_Viper.NetherToxin.TI8")
		UTIL_Remove(self:GetParent())
	end
end

function modifier_creep_special_gain_death_poison_thinker:OnIntervalThink()
	local caster = self.caster
    local ability = self.ability

	local enemy = FindUnitsInRadius(self.team, self:GetParent():GetAbsOrigin(), nil, self.radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	
    for i=1, #enemy do
		self.poison = self.index * enemy[i]:GetMaxHealth()
		enemy[i]:Poison(caster,ability,self.poison)
        --enemy[i]:AddNewModifier(caster, ability, "modifier_item_hd_poison_coat_debuff", {duration = 1})
	end
end