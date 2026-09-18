
Advanced_Desolate = class({})

LinkLuaModifier("modifier_Advanced_Desolate_passive", "skills/Advanced_Desolate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Desolate_alone", "skills/Advanced_Desolate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Desolate_break", "skills/Advanced_Desolate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Desolate_forever", "skills/Advanced_Desolate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Desolate_grow", "skills/Advanced_Desolate", LUA_MODIFIER_MOTION_NONE)
function Advanced_Desolate:CheckKV(key)
	local table = {
		alone_damage = 1,
		middle_damage = 1,
	}
	local value = table[key] or -1
	return value

end
function Advanced_Desolate:UnlockFirstCore(key)
	return true
end
function Advanced_Desolate:UnlockSecondCore(key)
	return true
end
function Advanced_Desolate:UnlockThirdCore(key)

	return true
end

function Advanced_Desolate:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_tgt_golden.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spectre/spectre_desolate.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons", context )
end

function Advanced_Desolate:GetIntrinsicModifierName()
	return "modifier_Advanced_Desolate_passive"
end

----------------------------------------------
modifier_Advanced_Desolate_passive = advanced_modifier({})

function modifier_Advanced_Desolate_passive:IsDebuff()			return false end
function modifier_Advanced_Desolate_passive:IsHidden() 			return true end
function modifier_Advanced_Desolate_passive:IsPurgable() 		return false end
function modifier_Advanced_Desolate_passive:IsPurgeException() 	return false end
function modifier_Advanced_Desolate_passive:OnDestroy()
	if not IsServer() then
		return
	end
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 30000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _ , enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByName("modifier_Advanced_Desolate_alone")
		if modifier then
			modifier:SafeDestroy()
		end
	end
end
function modifier_Advanced_Desolate_passive:DeclareFunctions()	
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
end

function modifier_Advanced_Desolate_passive:ADDeclareFunctions()	
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
end

function modifier_Advanced_Desolate_passive:GetModifierProcAttack_BonusDamage_Physical()
	return self:GetAbility():GetSpecialValueFor("bonus_attack")*self:GetCaster():GetAverageTrueAttackDamage(nil)*0.01
end

function modifier_Advanced_Desolate_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() then
		return
	end
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Desolate_grow")
	if modifier then
		self.alone = (self:GetAbility():GetSpecialValueFor("alone_damage") + modifier:GetStackCount())*0.01
	end
	self.alone = self:GetAbility():GetSpecialValueFor("alone_damage")*0.01
	local caster = keys.attacker
	local damage = caster:GetAverageTrueAttackDamage(nil) * self.alone
	local target = keys.target

	

	target:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Desolate_alone", {stack = damage})

	if self:GetAbility():IsCooldownReady() then 
		if self:GetCaster():GetRandomEffect(self:GetAbility():GetSpecialValueFor("collapse_chance"),INT_TYPE,1)  >=RandomInt(1, 100) then
			local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Desolate_grow")
			local radius = self:GetAbility():GetSpecialValueFor("middle_radius")
			if self.advanced_level >= 15 and modifier then
				radius = radius + modifier:GetStackCount()*4
			end

			local pos = keys.target:GetAbsOrigin()
			local pfx_name = "particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf"
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, pos)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
			self:AddParticle(pfx, false, false, 16, false, false)

			self:GetCaster():GameTimer(0.01, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
			
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			local pure_dmg = self:GetParent():GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor("middle_damage")*0.01
			if self.advanced_level >= 15 and modifier then
				pure_dmg = self:GetParent():GetAverageTrueAttackDamage(nil) * (self:GetAbility():GetSpecialValueFor("middle_damage") + modifier:GetStackCount()*0.3)*0.01
			end
			for _, enemy in pairs(enemies) do
				local damageTable = {
									victim = enemy,
									attacker = self:GetParent(),
									damage = pure_dmg,
									damage_type = self:GetAbility():GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, 
									hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT,
									ability = self:GetAbility(), 
									}
				ApplyDamage(damageTable)
				if self.advanced_level >= 5 then
					enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_Advanced_Desolate_break",{duration = 2})
				end
			end
			self:GetAbility():StartCooldown((self:GetAbility():GetSpecialValueFor("middle_cd")) * self:GetParent():GetCooldownReduction())
			
		end
	end

end

----------------------------------------------
modifier_Advanced_Desolate_alone = advanced_modifier({})

function modifier_Advanced_Desolate_alone:IsDebuff()			return true end
function modifier_Advanced_Desolate_alone:IsHidden() 			return false end
function modifier_Advanced_Desolate_alone:IsPurgable() 		return false end
function modifier_Advanced_Desolate_alone:IsPurgeException() 	return false end

function modifier_Advanced_Desolate_alone:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self.duration = self:GetAbility():GetSpecialValueFor("duration")

		local talent = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_spectre_4")
		if talent then
			if talent:GetAutoCastState() then
				self.duration = talent:GetSpecialValueFor("alone_time_2")
			else
				self.duration = talent:GetSpecialValueFor("alone_time")
			end
		end

		self:StartIntervalThink(self.duration)
		self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	end
end

function modifier_Advanced_Desolate_alone:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_Advanced_Desolate_alone:OnIntervalThink()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.alone_line = self:GetAbility():GetSpecialValueFor("alone_line")
	self.alone_index = self:GetAbility():GetSpecialValueFor("alone_index")*0.01 + 1
	local target = self:GetParent()
	if not ability then
		self:SafeDestroy()
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, 
		hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT,
		ability = ability,
		}
	
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #enemies <= self.alone_line or self:GetParent():HasModifier("modifier_Advanced_Desolate_forever") then
		damageTable.damage = self.alone_index * damageTable.damage
	end
	
	local talent = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_spectre_4")
	if talent then
		if talent:GetAutoCastState() then
			damageTable.damage = damageTable.damage * (1+talent:GetSpecialValueFor("alone_index")*0.01)
		end
	end
	
	if self.advanced_level >= 10 and #enemies <= 2 then
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_Desolate_forever",{})
	end
	if self.advanced_level >= 20 and self:GetParent():IsSilenced() then
		damageTable.damage = damageTable.damage*1.3
	end

	ApplyDamage(damageTable)
	if not self:GetParent():IsAlive() then
		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_Advanced_Desolate_grow",{})
	end
	--self:GetParent():EmitSound("Hero_Spectre.Desolate")
	--local particle_cast = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
	--local forward = (-target:GetOrigin()+self:GetCaster():GetOrigin()):Normalized()
	--local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW , target )
	--ParticleManager:SetParticleControlEnt(effect_cast,0,target,PATTACH_CENTER_FOLLOW,nil,Vector(0,0,0),true)
	--ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
	--ParticleManager:SetParticleControlForward( effect_cast, 0, forward )
	--ParticleManager:ReleaseParticleIndex( effect_cast )

	local pfx = ParticleManager:CreateParticle("particles/rebuild/talent/spectre_2/effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
	DestroyParticleByDelay(pfx,1)
	parent:EmitSound("Hero_Spectre.Attack.Arcana")
	
	self:SetStackCount(0)
	self:SafeDestroy()
end

----------------------------------------------
modifier_Advanced_Desolate_break = advanced_modifier({})

function modifier_Advanced_Desolate_break:IsDebuff()			return true end
function modifier_Advanced_Desolate_break:IsHidden() 			return true end
function modifier_Advanced_Desolate_break:IsPurgable() 		return false end
function modifier_Advanced_Desolate_break:IsPurgeException() 	return false end
function modifier_Advanced_Desolate_break:CheckState()
	return{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end
----------------------------------------------
modifier_Advanced_Desolate_forever = advanced_modifier({})

function modifier_Advanced_Desolate_forever:IsDebuff()			return true end
function modifier_Advanced_Desolate_forever:IsHidden() 			return true end
function modifier_Advanced_Desolate_forever:IsPurgable() 		return false end
function modifier_Advanced_Desolate_forever:IsPurgeException() 	return false end

----------------------------------------------
modifier_Advanced_Desolate_grow = advanced_modifier({})

function modifier_Advanced_Desolate_grow:IsDebuff()			return false end
function modifier_Advanced_Desolate_grow:IsHidden() 			return false end
function modifier_Advanced_Desolate_grow:IsPurgable() 		return false end
function modifier_Advanced_Desolate_grow:IsPurgeException() 	return false end
function modifier_Advanced_Desolate_grow:RemoveOnDeath() 	return false end
function modifier_Advanced_Desolate_grow:OnRefresh()
	self:SetStackCount(self:GetStackCount() + 1)
end
function modifier_Advanced_Desolate_grow:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_Advanced_Desolate_grow:OnTooltip()
	return	self:GetAbility():GetSpecialValueFor("alone_damage") + self:GetStackCount()*1
end