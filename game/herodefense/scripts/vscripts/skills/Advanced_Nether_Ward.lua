
Advanced_Nether_Ward = class({})

LinkLuaModifier("modifier_Advanced_Nether_Ward", "skills/Advanced_Nether_Ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nether_Ward_debuff", "skills/Advanced_Nether_Ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Nether_Ward_silenced", "skills/Advanced_Nether_Ward", LUA_MODIFIER_MOTION_NONE)

function Advanced_Nether_Ward:IsHiddenWhenStolen() 	return false end
function Advanced_Nether_Ward:IsRefreshable() 		return true end
function Advanced_Nether_Ward:IsStealable() 			return true end
function Advanced_Nether_Ward:IsNetherWardStealable()	return false end
function Advanced_Nether_Ward:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Advanced_Nether_Ward:GetCastRange()
	local caster = self:GetCaster()
	return 700 - caster:GetCastRangeBonus()

end
function Advanced_Nether_Ward:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock1",{})
	return true
end
function Advanced_Nether_Ward:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	return true
end
function Advanced_Nether_Ward:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_mana_shield_unlock3",{})
	return true
end
function Advanced_Nether_Ward:CheckKV(key)
	local table = {

	


		basic_damage = 2,
		intelligence_index = 0.03,





	}
	local value = table[key] or -1
	return value

end

function Advanced_Nether_Ward:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/nether_ward/unlock3/effect_attack_light_ti_5.vpcf", context )

end
function Advanced_Nether_Ward:GetBehavior()


	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_AOE
		end
		
	end


	return self.BaseClass.GetBehavior(self)
	
end

function Advanced_Nether_Ward:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()

	local ward = CreateUnitByName("npc_nether_ward", pos, true, caster, caster, caster:GetTeamNumber())
	SetCreatureHealth(ward, self:GetSpecialValueFor("ward_health"), true)
	ward:AddNewModifier(caster, self, "modifier_Advanced_Nether_Ward", {duration = self:GetSpecialValueFor("duration")})
	ward:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
	ward:AddNewModifier(caster, self, "modifier_rooted", {duration = self:GetSpecialValueFor("duration")})
	ward:SetControllableByPlayer(caster:GetPlayerID(), false)
	ward:EmitSound("Hero_Pugna.NetherWard")
	local health =self:GetSpecialValueFor("ward_health")
	--LV15解锁增幅
	if self.advanced_level >=15 then
		health=health*2
	end
	SetCreatureHealth(ward, health, true)
end


function Advanced_Nether_Ward:AttackEffect(source,target)
	local caster = self:GetCaster()
	-- local mana_spent = keys.cost
	local int_index = self:GetSpecialValueFor("damage_times")
	--LV5解锁幽冥魂能+
	if self.advanced_level>=5 then
		int_index = int_index*2
		if self.unlock1 then
			int_index = int_index * 2
		end
	end
	local damage = caster:GetIntellect(false)*int_index
	local pfx_name = damage < 1000 and "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_light_ti_5.vpcf" or (damage < 2000 and "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf" or "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf")
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, source, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	source:EmitSound("Hero_Pugna.NetherWard.Attack")

	target:EmitSound("Hero_Pugna.NetherWard.Target")
	local damage_gain = self:GetSpecialValueFor("gain_time") --伤害增幅倍数
	local gain_chance =self:GetSpecialValueFor("gain_chance")  --伤害增幅几率
	--LV10解锁幽冥静默
	if self.advanced_level>=10 then
		gain_chance = gain_chance+20
	end
	if caster:GetRandomEffect(gain_chance,INT_TYPE,1) >=RandomInt(1, 100)  then
		damage =damage * damage_gain
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(
			        caster, -- player source
					self, -- ability source
					"modifier_Advanced_Nether_Ward_silenced", -- modifier name
					{ duration = 5 *StatusResistance} -- kv
				)

	end
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = damage,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	ApplyDamage(damageTable)
end

modifier_Advanced_Nether_Ward = class({})

function modifier_Advanced_Nether_Ward:IsDebuff()			return false end
function modifier_Advanced_Nether_Ward:IsHidden() 			return true end
function modifier_Advanced_Nether_Ward:IsPurgable() 		return false end
function modifier_Advanced_Nether_Ward:IsPurgeException() 	return false end
function modifier_Advanced_Nether_Ward:IsAura() 			return self:GetAbility() and true or false end
function modifier_Advanced_Nether_Ward:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Nether_Ward:GetAuraDuration() return 0.5 end
function modifier_Advanced_Nether_Ward:GetModifierAura() return "modifier_Advanced_Nether_Ward_debuff" end
function modifier_Advanced_Nether_Ward:GetAuraRadius() return self.radius end
function modifier_Advanced_Nether_Ward:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Nether_Ward:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Nether_Ward:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_Nether_Ward:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
	

	return state
end

function modifier_Advanced_Nether_Ward:DeclareFunctions() 
	local funcs =	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	} 



	if self:GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_ABILITY_FULLY_CAST)
	end
	
	
	
	return funcs
end
function modifier_Advanced_Nether_Ward:GetModifierPercentageCasttime() return -100 end
function modifier_Advanced_Nether_Ward:GetAbsoluteNoDamageMagical() return 1 end
function modifier_Advanced_Nether_Ward:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_Advanced_Nether_Ward:GetAbsoluteNoDamagePure() return 1 end
function modifier_Advanced_Nether_Ward:GetModifierIgnoreCastAngle() return 360 end
function modifier_Advanced_Nether_Ward:GetDisableHealing() return 1 end


function modifier_Advanced_Nether_Ward:OnCreated(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.advanced_level = self:GetAbility().advanced_level
		self.damage = self:GetCaster():GetIntellect(false)*4
		if self:GetAbility().unlock1 then
			self.damage = self.damage * 2
			self.effect_table = {}
			self:StartIntervalThink(2)
		end
		if self:GetAbility().unlock3 and self:GetAbility():GetAutoCastState() then
			self.mana_cost = 0
			self:StartIntervalThink(1)
		end
		self.caster = self:GetCaster()

	end
end


function modifier_Advanced_Nether_Ward:OnAttackLanded(keys)
	if not IsServer() or keys.target ~= self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local dmg = keys.attacker:IsTrueHero() and 4 or 1

	if dmg >= self:GetParent():GetHealth() then
		self:GetParent():Kill(self:GetAbility(), keys.attacker)
		self:SafeDestroy()
		return
	end
	-- self:GetParent():SetHealth(self:GetParent():GetHealth() - dmg)
	self:GetParent():ModifyHealth(self:GetParent():GetHealth() - dmg, self, false, 0)
	local ability = self:GetAbility()
	--LV20解锁反能
	if self.advanced_level>=20 then
		local damageTable = {
			victim = keys.attacker,
			attacker = self.caster,
			damage = self.damage,
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}
		ApplyDamage(damageTable)
	end
end


function modifier_Advanced_Nether_Ward:OnIntervalThink()
	local ability =self:GetAbility()
	if ability.unlock1 then
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _, unit in ipairs(enemies) do
			if not self.effect_table[unit] or  GameRules:GetGameTime()>=self.effect_table[unit] then
				self.effect_table[unit] =  GameRules:GetGameTime() + 8
				ability:AttackEffect(self:GetParent(),unit)
				break
			end
		end
	else

		local parent = self:GetParent()
		local caster = self:GetCaster()
		if CalculateDistance(parent,caster)>self.radius then
			return
		end
		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/nether_ward/unlock3/effect_attack_light_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)

		local current_mana =  caster:GetMana()
		local mana = current_mana*0.05+50

		caster:SpendMana( mana, ability )

		local mana_dif = current_mana-caster:GetMana()
		if mana_dif>0 then
			self.mana_cost = self.mana_cost + mana_dif
			if self.mana_cost>=1000 then
				self.mana_cost = self.mana_cost - 1000
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius*1.5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for i, unit in ipairs(enemies) do
					ability:AttackEffect(self:GetParent(),unit)
					if i>=5 then
						break
					end
				end

			end
		end


	end
	
end

function modifier_Advanced_Nether_Ward:OnAbilityFullyCast(keys)
	-- print("b")
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) < 3 then
		return
	end

	local caster = self:GetCaster()
	if not IsEnemy(keys.unit, caster) and CalculateDistance(keys.unit,self:GetParent())<=self.radius   then
		if caster:GetRandomEffect(30,INT_TYPE,1)  > RandomInt(1, 100) then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local ability =self:GetAbility()
			for _, unit in ipairs(enemies) do
				ability:AttackEffect(self:GetParent(),unit)
				break
			end
		end
	end
	


end

modifier_Advanced_Nether_Ward_debuff = class({})

function modifier_Advanced_Nether_Ward_debuff:IsDebuff()			return true end
function modifier_Advanced_Nether_Ward_debuff:IsHidden() 			return false end
function modifier_Advanced_Nether_Ward_debuff:IsPurgable() 			return false end
function modifier_Advanced_Nether_Ward_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Nether_Ward_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_Advanced_Nether_Ward_debuff:GetModifierTotalPercentageManaRegen() return self.mana_regen_tooltip end
function modifier_Advanced_Nether_Ward_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Advanced_Nether_Ward_debuff:OnCreated(table)
	self.ability = self:GetAbility()
	if not self.ability then
		self:SafeDestroy()
		return
	end
	self.mana_regen_tooltip = - self:GetAbility():GetSpecialValueFor("mana_regen_tooltip")
	if IsServer() then
		-- self.ability = self:GetAbility()
		self.caster = self.ability:GetCaster()
		self.advanced_level = self.ability.advanced_level
		self.damage = self.caster:GetIntellect(false) * (self.ability:GetSpecialValueFor("intelligence_index")) + self.ability:GetSpecialValueFor("basic_damage")
		if self.ability.unlock1 then
			self.damage = self.damage * 3
		end
		self.manaloss =  self.ability:GetSpecialValueFor("mana_loss_intelligence_index") * self.caster:GetIntellect(false)
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Nether_Ward_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	local damageTable = {
		victim = self:GetParent(),
		attacker = self.caster,
		damage = self.damage,
		damage_type = self.ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability =self.ability, --Optional.
		}
	ApplyDamage(damageTable)
	self:GetParent():Script_ReduceMana(self.manaloss,self.ability)
end

function modifier_Advanced_Nether_Ward_debuff:OnAbilityFullyCast(keys)
	-- print("b")
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	if not IsEnemy(keys.unit, self:GetCaster()) or keys.unit~=self:GetParent() or keys.cost == 0  then
		return
	end
	-- print("c")
	if not self:GetParent():IsAlive() then
		self:SafeDestroy()
		return
	end

	-- print("d")

	local target = keys.unit
	local ability = self:GetAbility()
	ability:AttackEffect(self:GetAuraOwner(),target)
	-- self.advanced_level = ability.advanced_level
	-- local caster = ability:GetCaster()
	-- -- local mana_spent = keys.cost
	-- local int_index = ability:GetSpecialValueFor("damage_times")
	-- --LV5解锁幽冥魂能+
	-- if self.advanced_level>=5 then
	-- 	int_index = int_index*2
	-- 	if ability.unlock1 then
	-- 		int_index = int_index * 2
	-- 	end
	-- end
	-- local mana_spent = caster:GetIntellect(false)*int_index
	-- local pfx_name = mana_spent < 1000 and "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_light_ti_5.vpcf" or (mana_spent < 2000 and "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf" or "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_heavy_ti_5.vpcf")
	-- local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:ReleaseParticleIndex(pfx)
	-- self:GetParent():EmitSound("Hero_Pugna.NetherWard.Attack")
	-- local damage = mana_spent 
	-- target:EmitSound("Hero_Pugna.NetherWard.Target")
	-- local damage_gain = ability:GetSpecialValueFor("gain_time") --伤害增幅倍数
	-- local gain_chance =ability:GetSpecialValueFor("gain_chance")  --伤害增幅几率
	-- --LV10解锁幽冥静默
	-- if self.advanced_level>=10 then
	-- 	gain_chance = gain_chance+20
	-- end
	-- if self:GetCaster():GetRandomEffect(gain_chance,INT_TYPE,1) >=RandomInt(1, 100)  then
	-- 	damage =damage * damage_gain
	-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	-- 	target:AddNewModifier(
	-- 		        caster, -- player source
	-- 				ability, -- ability source
	-- 				"modifier_Advanced_Nether_Ward_silenced", -- modifier name
	-- 				{ duration = 5 *StatusResistance} -- kv
	-- 			)

	-- end
	-- local damageTable = {
	-- 					victim = target,
	-- 					attacker = caster,
	-- 					damage = damage,
	-- 					damage_type = ability:GetAbilityDamageType(),
	-- 					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	-- 					ability = ability, --Optional.
	-- 					}
	-- ApplyDamage(damageTable)

end

modifier_Advanced_Nether_Ward_silenced = class({})

function modifier_Advanced_Nether_Ward_silenced:IsDebuff()			return true end
function modifier_Advanced_Nether_Ward_silenced:IsHidden() 		    return false end
function modifier_Advanced_Nether_Ward_silenced:IsPurgable() 		return true end
function modifier_Advanced_Nether_Ward_silenced:IsPurgeException()   return true end
function modifier_Advanced_Nether_Ward_silenced:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Nether_Ward_silenced:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_Advanced_Nether_Ward_silenced:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_Advanced_Nether_Ward_silenced:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Advanced_Nether_Ward_silenced:ShouldUseOverheadOffset() return true end