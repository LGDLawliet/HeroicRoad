
chaotic_Tidebringer = chaotic_Tidebringer or class({})
LinkLuaModifier("modifier_chaotic_Tidebringer", "chaotic_spell/class_6/chaotic_Tidebringer", LUA_MODIFIER_MOTION_NONE)
function chaotic_Tidebringer:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", context )
end
function chaotic_Tidebringer:GetIntrinsicModifierName()	return "modifier_chaotic_Tidebringer" end


-----------------------------

modifier_chaotic_Tidebringer =modifier_chaotic_Tidebringer or advanced_modifier({})
function modifier_chaotic_Tidebringer:IsHidden()	return true end
function modifier_chaotic_Tidebringer:RemoveOnDeath()	return false end
function modifier_chaotic_Tidebringer:IsPurgable()	return false end
function modifier_chaotic_Tidebringer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED
	}
end
function modifier_chaotic_Tidebringer:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end
function modifier_chaotic_Tidebringer:OnCreated()
	local ability = self:GetAbility()
    self.bonus_attack = ability:GetSpecialValueFor("bonus_attack")
    self.bonus_attack_cd = ability:GetSpecialValueFor("bonus_attack_cd")
    self.cleave_index = ability:GetSpecialValueFor("cleave_index")*0.01
    self.range = ability:GetSpecialValueFor("range")
    self.start_radius = ability:GetSpecialValueFor("start_radius")
    self.end_radius = ability:GetSpecialValueFor("end_radius")
	if IsServer() then
		self.damageRecord  = {}
	end
end

function modifier_chaotic_Tidebringer:OnAttackStart( params )
	if IsClient() then
		return
	end
	local parent = self:GetParent()
	local target = params.target
	if (parent == params.attacker) and (target:GetTeamNumber() ~= parent:GetTeamNumber()) and (target.IsCreep or target.IsHero) then
		if not target:IsBuilding() then
			local ability = self:GetAbility()
			self.sound_triggered = false
			if ability:IsCooldownReady() then
				if ability:GetAutoCastState() then
					self.pass_attack = true
					self.bonus_damage = self.bonus_attack
				else
					self.pass_attack = false
					self.bonus_damage = 0
				end
			end
		end
	end
end

function modifier_chaotic_Tidebringer:OnAttackLanded( keys )
	if IsClient() then
		return
	end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if keys.attacker == parent and self.pass_attack then
		self.pass_attack = false
		self.bonus_damage = 0

		-- If you get break during attack-swing
		if parent:PassivesDisabled() then
			return 0
		end
		local target = keys.target
		if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			self.damageRecord[keys.record] = true


			ability:UseResources(false, false, true,true)


		end
	end
	return 0
end

function modifier_chaotic_Tidebringer:Advanced_GetModifierPreAttack_BonusDamage(params)
	self.bonus_damage = self.bonus_damage or 0
	return self.bonus_damage
end
function modifier_chaotic_Tidebringer:Advanced_GetModifierBaseAttack_BonusDamage(params)
    return self.bonus_attack_cd
end

function modifier_chaotic_Tidebringer:OnDamageCalculated(keys)
	if IsServer() then
		if self.damageRecord[keys.record] then
			self.damageRecord[keys.record] = nil
			local ability = self:GetAbility()
			local fDistance = self.range
			local fStartRadius = self.start_radius
			local fEndRadius = self.end_radius
			local cleaveDamage = keys.damage * self.cleave_index
			local damageTable = {
				attacker =  keys.attacker,
				damage = cleaveDamage,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
				ability = ability, --Optional.
                hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT
			}

			-- 分裂攻击在这运算 不使用API
			local target = keys.attacker
			local pos = keys.target:GetAbsOrigin()
			local direction = GetDirection2D(pos, keys.attacker:GetAbsOrigin())
			local units = FindUnitsInTrapezoid(keys.attacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, keys.attacker)
			ParticleManager:SetParticleControl(pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:SetParticleControlForward(pfx, 0, (pos - keys.attacker:GetAbsOrigin()):Normalized())
			local max_count = 10
			local count = math.min(#units,max_count)
			ParticleManager:SetParticleControl(pfx, 1, Vector(0,0,count))
			keys.attacker:EmitSound("Hero_Kunkka.Tidebringer.Attack")

			for i, unit in ipairs(units) do
				if self:GetAbility():GetRuneType() == 1 then
					if i<=max_count then
						ParticleManager:SetParticleControlEnt(pfx, i + 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
					else
						break
					end
					unit:EmitSound("Hero_Kunkaa.Tidebringer")
					damageTable.victim = unit
					damageTable.hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_FIRE_DAMAGE
					ApplyDamage(damageTable)
				else
					if unit~=keys.target then
						if i<=max_count then
							ParticleManager:SetParticleControlEnt(pfx, i + 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
						else
							break
						end
						unit:EmitSound("Hero_Kunkaa.Tidebringer")
						damageTable.victim = unit
						ApplyDamage(damageTable)
					end
				end
			end
			DestroyParticleByDelay(pfx,2)
		end
	end
end





