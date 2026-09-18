Advanced_unrivaled = class({})
LinkLuaModifier( "modifier_Advanced_unrivaled", "skills/Advanced_unrivaled", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_unrivaled_passive", "skills/Advanced_unrivaled", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Ability Start
function Advanced_unrivaled:UnlockFirstCore(key)
	return true
end
function Advanced_unrivaled:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_unrivaled_passive",{})
	return true
end
function Advanced_unrivaled:UnlockThirdCore(key)
	return true
end

function Advanced_unrivaled:CheckKV(key)
	local table = {
		bonus_attack_speed=1,
		bonus_move_speed=1,


	}
	local value = table[key] or -1
	return value

end


function Advanced_unrivaled:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/unrivaled_cleave/unrivaled_crit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/unrivaled_cleave/unrivaled_impact_b.vpcf", context )
	
	PrecacheResource( "particle", "particles/rebuild/spell/unrivaled/particle_15/effect_ambient.vpcf", context )
	

	
end






function Advanced_unrivaled:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_Sven.SignetLayer")

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local gain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_Advanced_unrivaled", {duration = self:GetSpecialValueFor("duration")*gain})

end
function Advanced_unrivaled:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end


	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	
end

modifier_Advanced_unrivaled = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_unrivaled:IsHidden()	return false end
function modifier_Advanced_unrivaled:IsDebuff()	return false end
function modifier_Advanced_unrivaled:IsPurgable()	return false end
function modifier_Advanced_unrivaled:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end





function modifier_Advanced_unrivaled:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临
	
		

	}
end

function modifier_Advanced_unrivaled:OnCreated()
	local ability = self:GetAbility()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = ability:GetSpecialValueFor("bonus_move_speed")
	self.radius = 600
	self.need_health = 20
	self.bonus_attribute = 50
	self.cooldown = 1
	self.cooldowning = false
	self.bonus_outgoing_damage = 30
	if self.advanced_level>=5 then
		self.radius = 400
		if self.advanced_level>=10 then
			self.need_health = 30
			self.bonus_attribute = 70
			if self.advanced_level>=20 then
				self.cooldown = 0.5
				if ability:GetUnlock(1)==1 then
					self.need_health = 100
					self.bonus_attribute = 140
				end
			end
		end
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_sven_3") then
		self.seven_talent = true
	end
	if IsServer() then
		
		self.cooldownTime = GameRules:GetGameTime()
		if ability.unlock3 then
			self.cooldown = 0.2
		end
		
		if ability.unlock1 then
			self.bonus_damage = true
			self.bonus_outgoing_damage = 50
		else
			self.bonus_damage = false
			if self.seven_talent then
				self.bonus_damage = true
			else
				self:StartIntervalThink(1)
			end
			
		end
		local parent = self:GetParent()
		local particle = "particles/rebuild/spell/unrivaled/unrivaled_ambient.vpcf"
		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_15" then
			particle = "particles/rebuild/spell/unrivaled/particle_15/effect_ambient.vpcf"
			self.saiyazin = true
			parent:EmitSound("unrivaled.saiyazin_Start")
			parent:EmitSound("unrivaled.saiyazin_Loop")
		end
		
		
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		
	end
end


function modifier_Advanced_unrivaled:OnDestroy()

	if IsServer() then
		if self.saiyazin then
			self:GetParent():StopSound("unrivaled.saiyazin_Loop")
		end
		

		
	end
end



function modifier_Advanced_unrivaled:OnIntervalThink()
	local caster = self:GetCaster()
	if not self:GetParent():IsAlive() then
		return
	end

	
	local uints = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)


	if #uints>1 then
		self.bonus_damage = false
	else
		self.bonus_damage = true
	end


	


end

function modifier_Advanced_unrivaled:GetActivityTranslationModifiers()	return "haste" end

function modifier_Advanced_unrivaled:Advanced_GetModifierAttackSpeedPercentage()	return self.bonus_attack_speed  end
function modifier_Advanced_unrivaled:GetModifierMoveSpeedBonus_Percentage()	return  self.bonus_move_speed  end

function modifier_Advanced_unrivaled:GetModifierBonusStats_Strength()	return (self.seven_talent or self:GetParent():GetHealthPercent()<=self.need_health )and self.bonus_attribute end
function modifier_Advanced_unrivaled:GetModifierBonusStats_Intellect()	return (self.seven_talent or self:GetParent():GetHealthPercent()<=self.need_health ) and self.bonus_attribute end
function modifier_Advanced_unrivaled:GetModifierBonusStats_Agility()	return (self.seven_talent or self:GetParent():GetHealthPercent()<=self.need_health ) and self.bonus_attribute end

function modifier_Advanced_unrivaled:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self.advanced_level>=15 and GameRules:GetGameTime()>=self.cooldownTime then
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			local target =keys.target
			self.cooldownTime = GameRules:GetGameTime()+self.cooldown
			if ability.unlock3 then
				
				local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/unrivaled_cleave/unrivaled_crit.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControlForward(pfx, 0, (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
				ParticleManager:ReleaseParticleIndex(pfx)
				local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
		
				local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				for i, hTarget in pairs(units) do
					if hTarget~=target then
						caster:PerformAttack(hTarget,false, true, true, true, false, false, true)
						local pfx2 = ParticleManager:CreateParticle("particles/rebuild/spell/unrivaled_cleave/unrivaled_impact_b.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
						-- ParticleManager:SetParticleControl(pfx2, 2, caster:GetAbsOrigin())
						
						ParticleManager:SetParticleControl(pfx2, 1,Vector(0,0,1))
						ParticleManager:SetParticleControlEnt(pfx2, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)

						ParticleManager:ReleaseParticleIndex(pfx2)
					end
				end
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
			else
			

				local norm = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
				
				local pos = target:GetAbsOrigin()

				local pos_1 = pos + norm * 600
				
				local tTargets = FindUnitsInLine(caster:GetTeamNumber(), pos_1, pos, nil, 150,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
		
				local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				for i, hTarget in pairs(tTargets) do
					if hTarget~=target then
						caster:PerformAttack(hTarget,false, true, true, true, false, false, true)
					end
				end
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				local iPtclID = ParticleManager:CreateParticle('particles/rebuild/spell/quadruple_chop_3/quadruple_chop_3.vpcf', PATTACH_CUSTOMORIGIN, nil)

				ParticleManager:SetParticleControl(iPtclID, 1, pos_1)
				ParticleManager:SetParticleControl(iPtclID, 0, pos)
				ParticleManager:ReleaseParticleIndex(iPtclID)

			end
			
			

		end
	end
end

-- advanced_modifier
function modifier_Advanced_unrivaled:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }


	return funcs

end
function modifier_Advanced_unrivaled:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if self.advanced_level>=5 and self.bonus_damage  then
		return self.bonus_outgoing_damage
	end	
    if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK and self.bonus_damage  then
        return self.bonus_outgoing_damage
    end
    return 0
end





modifier_Advanced_unrivaled_passive = class({})

function modifier_Advanced_unrivaled_passive:IsDebuff()			return false end
function modifier_Advanced_unrivaled_passive:IsHidden() 			return true end
function modifier_Advanced_unrivaled_passive:IsPurgable() 		return false end
function modifier_Advanced_unrivaled_passive:IsPurgeException() 	return false end
function modifier_Advanced_unrivaled_passive:RemoveOnDeath() return false end
function modifier_Advanced_unrivaled_passive:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_unrivaled_passive:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_unrivaled_passive:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if not caster:HasModifier("modifier_Advanced_unrivaled") then
		caster:AddNewModifier(caster, ability, "modifier_Advanced_unrivaled", {})
	end
	

		
end