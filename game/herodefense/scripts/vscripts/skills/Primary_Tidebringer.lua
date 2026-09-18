
Primary_Tidebringer = Primary_Tidebringer or class({})
LinkLuaModifier("modifier_Primary_Tidebringer", "skills/Primary_Tidebringer", LUA_MODIFIER_MOTION_NONE)
function Primary_Tidebringer:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", context )
end
function Primary_Tidebringer:GetIntrinsicModifierName()	return "modifier_Primary_Tidebringer" end
function Primary_Tidebringer:GetCastRange(location, target)
	return self:GetCaster():Script_GetAttackRange()
end
-- function Primary_Tidebringer:GetCooldown( nLevel )
-- 	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
-- 	local caster = self:GetCaster()

-- 	if caster:HasModifier("modifier_imba_ebb_and_flow_tide_wave") or caster:HasModifier("modifier_imba_ebb_and_flow_tsunami") or (caster:HasTalent("special_bonus_imba_kunkka_2") and caster:HasModifier("modifier_imba_ghostship_rum")) then
-- 		cooldown = 0
-- 	end
-- 	return cooldown
-- end



modifier_Primary_Tidebringer =modifier_Primary_Tidebringer or class({})
function modifier_Primary_Tidebringer:IsHidden()	return true end
function modifier_Primary_Tidebringer:RemoveOnDeath()	return false end
function modifier_Primary_Tidebringer:IsPurgable()	return false end
function modifier_Primary_Tidebringer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED
	}
end

function modifier_Primary_Tidebringer:OnCreated()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if IsServer() then
		self.damageRecord  = {}
	end
end

-- function modifier_Primary_Tidebringer:OnRefresh()
-- 	local caster = self:GetCaster()
-- 	local ability = self:GetAbility()
-- 	if IsServer() then

-- 	end
-- end

function modifier_Primary_Tidebringer:OnAttackStart( params )
	if IsClient() then
		return
	end
	local parent = self:GetParent()
	local target = params.target
	if (parent == params.attacker) and (target:GetTeamNumber() ~= parent:GetTeamNumber()) and (target.IsCreep or target.IsHero) then
		if not target:IsBuilding() then
			local ability = self:GetAbility()
			self.sound_triggered = false
			if ability:IsCooldownReady() and not (parent:PassivesDisabled()) then
				if ability:GetAutoCastState() then
					self.pass_attack = true
					self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
				else
					self.pass_attack = false
					self.bonus_damage = 0
				end
			end
		end
	end
end

function modifier_Primary_Tidebringer:OnAttackLanded( keys )
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

function modifier_Primary_Tidebringer:GetModifierPreAttack_BonusDamage(params)
	self.bonus_damage = self.bonus_damage or 0
	return self.bonus_damage
end


function modifier_Primary_Tidebringer:OnDamageCalculated(keys)
	if IsServer() then
		if self.damageRecord[keys.record] then
			self.damageRecord[keys.record] = nil
			local ability = self:GetAbility()
			local fDistance = ability:GetSpecialValueFor("range")
			local fStartRadius = ability:GetSpecialValueFor("start_radius")
			local fEndRadius = ability:GetSpecialValueFor("end_radius")
			local cleaveDamage = keys.damage * (ability:GetSpecialValueFor("cleave_damage") / 100)
			local damageTable = {
				attacker =  keys.attacker,
				damage = cleaveDamage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
				ability = ability, --Optional.
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


			local talent4 = keys.attacker:FindAbilityByName("heroTalent_npc_dota_hero_kunkka_4")
			if talent4 then
				damageTable.damage = damageTable.damage +keys.attacker:GetAverageTrueAttackDamage(nil) * talent4:GetSpecialValueFor("attack_index")*0.01
				damageTable.damage_type = DAMAGE_TYPE_PURE
				local chance =  talent4:GetSpecialValueFor("chance")
				for i, unit in ipairs(units) do
					if unit~=keys.target then
						if i<=max_count then
							ParticleManager:SetParticleControlEnt(pfx, i + 1, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
						end
						unit:EmitSound("Hero_Kunkaa.Tidebringer")
						damageTable.victim = unit
						ApplyDamage(damageTable)
						if IsValid(unit) and unit:IsAlive() and chance>=RandomInt(1, 100) then
							talent4:Trigger(damageTable)
						end
						
					end
				end
			else
				for i, unit in ipairs(units) do
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

			local ability = keys.attacker:FindAbilityByName("heroTalent_npc_dota_hero_kunkka_3")
			if ability then
				ability:Trigger(cleaveDamage,pos)
			end

			DestroyParticleByDelay(pfx,2)
		end
	end
end





