
LinkLuaModifier("modifier_Middle_Acid_Sparay_thinker", "skills/Middle_Acid_Sparay", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Acid_Sparay_debuff", "skills/Middle_Acid_Sparay", LUA_MODIFIER_MOTION_NONE)

Middle_Acid_Sparay = class ({})


function Middle_Acid_Sparay:IsHiddenWhenStolen()return false end

function Middle_Acid_Sparay:GetAOERadius()return self:GetSpecialValueFor("radius") end

function Middle_Acid_Sparay:OnSpellStart()
	local caster = self:GetCaster()
	CreateModifierThinker(caster, self, "modifier_Middle_Acid_Sparay_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
end

modifier_Middle_Acid_Sparay_thinker = class({})

function modifier_Middle_Acid_Sparay_thinker:IsAura()return self:GetAbility() and true or false end
function modifier_Middle_Acid_Sparay_thinker:OnCreated(keys)
	if IsServer() then
		EmitSoundOn( "Hero_Alchemist.AcidSpray", self:GetParent() )
		self.caster = self:GetCaster()
		self.thinker = self:GetParent()
		self.ability = self:GetAbility()
		self.thinker_loc = self.thinker:GetAbsOrigin()
		self.thinker:EmitSound("Hero_Alchemist.AcidSpray")
		self.radius			= self.ability:GetSpecialValueFor("radius")
		self.damage			= self.ability:GetSpecialValueFor("damage") +self.ability:GetSpecialValueFor("bonus_damage")*self.caster:GetBaseDamageMax()


		if self.caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_alchemist_3") then
			self.radius = self.radius + self.caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_alchemist_3"):GetStackCount()*100
			print("radius="..self.radius)
		end


		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_POINT_FOLLOW, self.thinker)
		ParticleManager:SetParticleControl(self.particle, 0, (Vector(0, 0, 0)))
		ParticleManager:SetParticleControl(self.particle, 1, (Vector(self.radius, 1, 1)))
		ParticleManager:SetParticleControl(self.particle, 15, (Vector(25, 150, 25)))
		ParticleManager:SetParticleControl(self.particle, 16, (Vector(0, 0, 0)))


		self:StartIntervalThink(1)
	end
end

function modifier_Middle_Acid_Sparay_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local units = FindUnitsInRadius(self.thinker:GetTeamNumber(),
		self.thinker_loc,nil,self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
		-- print(#units)


	local damageTable = {
		attacker	= self:GetCaster(),
		damage		= self.damage,
		damage_type	= self.ability:GetAbilityDamageType(),
		ability		= self.ability,
	}
	for _, unit in ipairs(units) do
		damageTable.victim = unit
		ApplyDamage( damageTable)
	end
	

end

function modifier_Middle_Acid_Sparay_thinker:GetAuraRadius()return self.radius end
function modifier_Middle_Acid_Sparay_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Middle_Acid_Sparay_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Middle_Acid_Sparay_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Middle_Acid_Sparay_thinker:GetModifierAura()return "modifier_Middle_Acid_Sparay_debuff" end


function modifier_Middle_Acid_Sparay_thinker:OnDestroy(keys)
	if IsServer() then
		local thinker = self:GetParent()
		thinker:StopSound("Hero_Alchemist.AcidSpray")
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self:GetParent())
	end
end




modifier_Middle_Acid_Sparay_debuff = modifier_Middle_Acid_Sparay_debuff or advanced_modifier({})

function modifier_Middle_Acid_Sparay_debuff:IsDebuff()return true end
function modifier_Middle_Acid_Sparay_debuff:IsPurgable()return true end

function modifier_Middle_Acid_Sparay_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_Acid_Sparay_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_Middle_Acid_Sparay_debuff:Advanced_GetModifierPhysicalArmorBonus() return -self:GetAbility():GetSpecialValueFor("armor_reduce") end
function modifier_Middle_Acid_Sparay_debuff:GetModifierMoveSpeedBonus_Constant() return -80-self:GetStackCount()*4 end
function modifier_Middle_Acid_Sparay_debuff:GetModifierAttackSpeedBonus_Constant() return -self:GetStackCount()*3 end



function modifier_Middle_Acid_Sparay_debuff:OnCreated()
	if not IsServer() then
		return
	end

	self:StartIntervalThink(1)
end

function modifier_Middle_Acid_Sparay_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if not IsServer() then
		return
	end

	self:IncrementStackCount()
end
function modifier_Middle_Acid_Sparay_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end