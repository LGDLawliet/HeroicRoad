LinkLuaModifier("modifier_chaotic_earthquake_thinker", "chaotic_spell/class_8/chaotic_earthquake", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_earthquake_debuff", "chaotic_spell/class_8/chaotic_earthquake", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_chaotic_earthquake_rune_1_debuff", "chaotic_spell/class_8/chaotic_earthquake", LUA_MODIFIER_MOTION_NONE)



chaotic_earthquake = class({})






function chaotic_earthquake:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_earthquake/effect_ground/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_earthquake/earthquake_effect/effect_burrowstrike.vpcf", context )
end
function chaotic_earthquake:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



function chaotic_earthquake:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	-- local thinker = CreateUnitByName("npc_dota_thinker", pos, false, caster, caster, caster:GetTeam())
	-- if thinker then
	-- 	thinker:AddNewModifier(caster, self, "modifier_chaotic_earthquake_thinker", {duration =   self:GetSpecialValueFor("duration")})

	-- end

	local duration = self:GetSpecialValueFor("duration")
	if self:GetRuneType()==2 and not self.rune2_active then
		self.rune2_active = true
		duration = -1
		CreateModifierThinker(caster, self, "modifier_chaotic_earthquake_thinker", {duration = duration,rune2_effect = 1}, pos, caster:GetTeamNumber(), false)
	else
		CreateModifierThinker(caster, self, "modifier_chaotic_earthquake_thinker", {duration = duration}, pos, caster:GetTeamNumber(), false)
	end


	
end



modifier_chaotic_earthquake_thinker = advanced_modifier({})

function modifier_chaotic_earthquake_thinker:IsAura()return true end
function modifier_chaotic_earthquake_thinker:OnCreated(keys)
	if IsServer() then
		self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.length = self:GetAbility():GetSpecialValueFor("length")
		self.width = self:GetAbility():GetSpecialValueFor("width")

		self.rune_1_chance = self:GetAbility():GetSpecialValueFor("rune_1_chance")
		self.rune_1_duration = self:GetAbility():GetSpecialValueFor("rune_1_duration")
		self.rune_1_stun_duration = self:GetAbility():GetSpecialValueFor("rune_1_stun_duration")
		self.rune_1_bonus_damage = 1+self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")*0.01

		self.gain = self:GetAbility():GetEffectGain()
		if keys.rune2_effect then
			self.rune2_damage_index = 1-self:GetAbility():GetSpecialValueFor("rune_2_reduction")*0.01
		end


		local parent = self:GetParent()
		parent:EmitSound("Hero_EarthShaker.Gravelmaw.Cast")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_earthquake/effect_ground/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		-- ParticleManager:SetParticleControlEnt( self.particle,1, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,1,1))
		-- ParticleManager:SetParticleControl(self.particle,10,Vector(self:GetRemainingTime(),1,1))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
	end
end
function modifier_chaotic_earthquake_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_earthquake_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:Destroy()
		return
	end
	-- self:GetParent():MoveToPosition(self:GetCaster():GetOrigin())
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local center = parent:GetAbsOrigin()


	local pos_0 = center +RandomVector(RandomInt(1, self.radius*0.7))
	local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
	local pos_1 = pos_0 + vDir * (self.length*0.5)
	local pos_2 = pos_0 - vDir * (self.length*0.5)
	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), pos_1, pos_2, nil, self.width,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)


	local iPtclID = ParticleManager:CreateParticle('particles/rebuild/chaotic_spell/chaotic_earthquake/earthquake_effect/effect_burrowstrike.vpcf', PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iPtclID, 0, pos_2)
	ParticleManager:SetParticleControl(iPtclID, 1, pos_1)
	ParticleManager:ReleaseParticleIndex(iPtclID)

	parent:EmitSound("Hero_EarthShaker.Gravelmaw")

	local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*caster:HDGetPrimaryStatValue()
	if self.rune2_damage_index then
		damage = damage * self.rune2_damage_index
	end
	local damageTable = {
		-- victim = self:GetParent(),
		attacker = caster,
		damage = damage*self.gain,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
	}

	local duration = ability:GetSpecialValueFor("move_slow_duration")* caster:GetModifierStatusNegativeGainIndex(1)

	self.rune_1_chance = self:GetAbility():GetSpecialValueFor("rune_1_chance")
	self.rune_1_duration = self:GetAbility():GetSpecialValueFor("rune_1_duration")
	self.rune_1_stun_duration = self:GetAbility():GetSpecialValueFor("rune_1_stun_duration")
	self.rune_1_bonus_damage = 1+self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")*0.01
	self.rune_1_bonus_damage_stun = 1+self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage_stun")*0.01

	if ability:GetRuneType()==1   then
		for _, unit in ipairs(tTargets) do
			damageTable.victim = unit
			if unit:IsStunned() then
				damageTable.damage = damage * self.rune_1_bonus_damage_stun
			elseif unit:HasModifier("modifier_chaotic_earthquake_rune_1_debuff") then
				damageTable.damage = damage * self.rune_1_bonus_damage
			else
				damageTable.damage = damage
			end
			ApplyDamage(damageTable)
			if IsValid(unit) and unit:IsAlive() then
				
				local StatusResistance = unit:GetHDStatusResistanceIndex(1)
				unit:AddNewModifier(caster, ability, "modifier_chaotic_earthquake_debuff", {duration =duration*StatusResistance})
				if caster:RollRandom(self.rune_1_chance,1)  then
					if unit:HasModifier("modifier_chaotic_earthquake_rune_1_debuff") then
						unit:RemoveModifierByName("modifier_chaotic_earthquake_rune_1_debuff")
						unit:AddNewModifier(caster, ability, "modifier_stunned", {duration =self.rune_1_stun_duration*StatusResistance})
					else
						unit:AddNewModifier(caster, ability, "modifier_chaotic_earthquake_rune_1_debuff", {duration =self.rune_1_duration*StatusResistance})
					end
					
				end
			end
		end
	else
		for _, unit in ipairs(tTargets) do
			damageTable.victim = unit
			ApplyDamage(damageTable)
			if IsValid(unit) and unit:IsAlive() then
				
				local StatusResistance = unit:GetHDStatusResistanceIndex(1)
				unit:AddNewModifier(caster, ability, "modifier_chaotic_earthquake_debuff", {duration =duration*StatusResistance})
			end
		end
	end







	
end



modifier_chaotic_earthquake_debuff = advanced_modifier({})

function modifier_chaotic_earthquake_debuff:IsHidden() 			return false end
function modifier_chaotic_earthquake_debuff:IsPurgable() 			return false end
function modifier_chaotic_earthquake_debuff:IsPurgeException() 	return false end
function modifier_chaotic_earthquake_debuff:IsDebuff() return true end
function modifier_chaotic_earthquake_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	self.move_speed_reduction = -ability:GetSpecialValueFor("move_slow")
end

function modifier_chaotic_earthquake_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_earthquake_debuff:GetModifierMoveSpeedBonus_Constant() return   self.move_speed_reduction end
function modifier_chaotic_earthquake_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end





modifier_chaotic_earthquake_rune_1_debuff = advanced_modifier({})

function modifier_chaotic_earthquake_rune_1_debuff:IsHidden() 			return false end
function modifier_chaotic_earthquake_rune_1_debuff:IsPurgable() 			return false end
function modifier_chaotic_earthquake_rune_1_debuff:IsPurgeException() 	return false end
function modifier_chaotic_earthquake_rune_1_debuff:IsDebuff() return true end