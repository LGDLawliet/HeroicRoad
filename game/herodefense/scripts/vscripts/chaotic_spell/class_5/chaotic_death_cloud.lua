LinkLuaModifier("modifier_chaotic_death_cloud_thinker", "chaotic_spell/class_5/chaotic_death_cloud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_death_cloud_debuff", "chaotic_spell/class_5/chaotic_death_cloud", LUA_MODIFIER_MOTION_NONE)

chaotic_death_cloud = class ({})

function chaotic_death_cloud:IsHiddenWhenStolen()return false end
function chaotic_death_cloud:GetAOERadius()return self:GetSpecialValueFor("radius") end

function chaotic_death_cloud:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/death_cloud/death_cloud.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/death_cloud/cast_effect/effect_moonfall.vpcf", context )


end



function chaotic_death_cloud:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	CreateModifierThinker(caster, self, "modifier_chaotic_death_cloud_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)

	local particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/death_cloud/cast_effect/effect_moonfall.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, pos)
	ParticleManager:SetParticleControl(particle, 1, pos)
	ParticleManager:SetParticleControl(particle, 5, pos)
	ParticleManager:SetParticleControl(particle, 6, pos)
	DestroyParticleByDelay(particle,2)

end

modifier_chaotic_death_cloud_thinker = advanced_modifier({})
function modifier_chaotic_death_cloud_thinker:IsAura()return true end
function modifier_chaotic_death_cloud_thinker:OnCreated()
	if IsServer() then
		self:GetParent().ability_gain = self:GetAbility():GetEffectGain()
		EmitSoundOn( "Hero_Alchemist.AcidSpray", self:GetParent() )
		local parent = self:GetParent()
		parent:EmitSound("Hero_Luna.LucentBeam.Target")
		self.radius	= self:GetAbility():GetSpecialValueFor("radius")
		if not self:GetCaster():IsHero() then
			self.radius = self.radius *1.6
		end
		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/death_cloud/death_cloud.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particle, 0, (Vector(0, 0, 0)))
		ParticleManager:SetParticleControl(self.particle, 1, (Vector(self.radius, 1, 1)))
		ParticleManager:SetParticleControl(self.particle, 15, (Vector(25, 150, 25)))
		ParticleManager:SetParticleControl(self.particle, 16, (Vector(0, 0, 0)))


		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_death_cloud_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
end

function modifier_chaotic_death_cloud_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_death_cloud_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_death_cloud_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chaotic_death_cloud_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_chaotic_death_cloud_thinker:GetModifierAura()return "modifier_chaotic_death_cloud_debuff" end


function modifier_chaotic_death_cloud_thinker:OnDestroy()
	if IsServer() then
		local thinker = self:GetParent()
		thinker:StopSound("Hero_Alchemist.AcidSpray")
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self:GetParent())
		
	end
end



modifier_chaotic_death_cloud_debuff = modifier_chaotic_death_cloud_debuff or advanced_modifier({})

function modifier_chaotic_death_cloud_debuff:IsDebuff()return true end
function modifier_chaotic_death_cloud_debuff:IsPurgable()return true end

function modifier_chaotic_death_cloud_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_death_cloud_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_chaotic_death_cloud_debuff:OnCreated()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	self.gain = 1
	if self:GetAuraOwner() then
		self.gain = self:GetAuraOwner().ability_gain or 1
	end
	self.reduce = -ability:GetSpecialValueFor("magical_resistance_reduce")
	if IsServer() then
		self.bonus_damage_index = ability:GetSpecialValueFor("bonus_damage_index")
		self.base_damage = ability:GetSpecialValueFor("base_damage")

		self.damageTable = {
			attacker	= self:GetCaster(),
			victim = self:GetParent(),
			damage		= self.damage,
			damage_type	= ability:GetAbilityDamageType(),
			ability		= ability,
			hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
		}
		self:StartIntervalThink(ability:GetSpecialValueFor("damage_interval"))
	end
end

function modifier_chaotic_death_cloud_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	self.damageTable.damage = (self.base_damage + self.bonus_damage_index * self:GetCaster():HDGetPrimaryStatValue())*self.gain
	ApplyDamage(self.damageTable)
	if not self:GetParent():IsAlive() and ability and ability:GetRuneType() == 1 then
		if not ability:IsCooldownReady() then
			local newcooldown = math.max(ability:GetCooldownTimeRemaining() - ability:GetSpecialValueFor("rune_1_cd"), 0)
			ability:EndCooldown()
			ability:StartCooldown(newcooldown)
		end
	end
end





function modifier_chaotic_death_cloud_debuff:GetModifierMagicalResistanceBonus()
    return self.reduce
end

