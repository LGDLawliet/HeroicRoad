LinkLuaModifier("modifier_chaotic_emp_thinker", "chaotic_spell/class_8/chaotic_emp", LUA_MODIFIER_MOTION_NONE)
chaotic_emp = class({})

function chaotic_emp:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_emp.vpcf", context )
end
function chaotic_emp:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function chaotic_emp:GetCooldown(iLevel)
	if self:GetRuneType() == 1 then
		return self:GetSpecialValueFor("rune_1_cd")
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end

function chaotic_emp:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	CreateModifierThinker(caster, self, "modifier_chaotic_emp_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
	
	if self:GetRuneType() == 1 then
		local count = self:GetSpecialValueFor("rune_1_count")
		for i=1,count do
			local angle = RandomFloat(0, 360)
			local distance = RandomFloat(500, 850)
			local offset = Vector(math.cos(angle)*distance, math.sin(angle)*distance, 0)
			local new_pos = pos + offset
			CreateModifierThinker(caster, self, "modifier_chaotic_emp_thinker", {duration = self:GetSpecialValueFor("duration")}, new_pos, caster:GetTeamNumber(), false)
		end
	end
end

-------------
modifier_chaotic_emp_thinker = advanced_modifier({})
function modifier_chaotic_emp_thinker:IsAura()return true end
function modifier_chaotic_emp_thinker:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		self.elecshocking = ability:GetSpecialValueFor("elecshocking")
		self.radius = ability:GetSpecialValueFor("radius")
		self.damage = ability:GetSpecialValueFor("damage")
		self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
		self.silence_duration = ability:GetSpecialValueFor("silence_duration")
		self.mana_cost = ability:GetSpecialValueFor("mana_cost")*0.01
		self.bonus = ability:GetSpecialValueFor("bonus")*0.01
		self.rune = ability:GetRuneType()

		if self.rune == 1 then
			self.rune_1_index = ability:GetSpecialValueFor("rune_1_index")*0.01
			self.damage = self.damage*(1-self.rune_1_index)
			self.bonus_damage = self.bonus_damage*(1-self.rune_1_index)
			self.elecshocking = self.elecshocking*(1-self.rune_1_index)
		end
		self.damageTable = {
			--victim = ,
			attacker = caster,
			--damage = ,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_LIGHTNING,
		}


		parent:EmitSound("Hero_Invoker.EMP.Cast")
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		self:AddParticle(self.particle, false, false, -1, false, false)

		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_emp_thinker:OnDestroy(keys)
	if IsServer() then
		self:EMPblast(self:GetParent():GetAbsOrigin())
		if self.particle then
			ParticleManager:DestroyParticle(self.particle,false)
		end
		UTIL_Remove(self:GetParent())
	end
end

function modifier_chaotic_emp_thinker:EMPblast(pos)
	if not self:GetAbility() or not pos then return end
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local center = pos
		local damage = self.damage + self.bonus_damage*caster:HDGetPrimaryStatValue()

		if caster:GetManaPercent() >= self.mana_cost then
			caster:SpendMana(self.mana_cost*caster:GetMaxMana(),ability)
			damage = damage*(1+self.bonus)
		end
		parent:EmitSound("Hero_Invoker.EMP.Discharge")
		local enemies = FindUnitsInRadius(parent:GetTeamNumber(), center, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(enemies) do
			self.damageTable.victim = unit
			self.damageTable.damage = damage
			ApplyDamage(self.damageTable)
			if unit:IsAlive() then
				unit:AddNewModifier(caster, ability, "modifier_silence", {duration = self.silence_duration})
			end
		end
	end
end

function modifier_chaotic_emp_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:Destroy()
		return
	end
	
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local center = parent:GetAbsOrigin()
	local elecshocking = self.elecshocking
	local enemies = FindUnitsInRadius(parent:GetTeamNumber(), center, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, unit in ipairs(enemies) do
		unit:Elecshocking(caster, ability, elecshocking)
	end
end





