
LinkLuaModifier("modifier_Advanced_Moment_of_Courage_buff", "skills/Advanced_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Moment_of_Courage_active", "skills/Advanced_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Moment_of_Courage_debuff", "skills/Advanced_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Moment_of_Courage_active2", "skills/Advanced_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Moment_of_Courage_active_lv10", "skills/Advanced_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Moment_of_Courage_active_lv20", "skills/Advanced_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Moment_of_Courage_active_unlock2", "skills/Advanced_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)

Advanced_Moment_of_Courage	= Advanced_Moment_of_Courage or class({})
require("internal/timers")

function Advanced_Moment_of_Courage:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/moment_of_courage/lv10_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/moment_of_courage/lv20_effect.vpcf", context )

	
end

function Advanced_Moment_of_Courage:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_mist_coil_unlock1",{})
	return true
end
function Advanced_Moment_of_Courage:UnlockSecondCore(key)
	return true
end
function Advanced_Moment_of_Courage:UnlockThirdCore(key)
	return true
end

function Advanced_Moment_of_Courage:CheckKV(key)
	local table = {
		life_steal = 3,
	}
	local value = table[key] or -1
	return value

end

function Advanced_Moment_of_Courage:GetIntrinsicModifierName()
	return "modifier_Advanced_Moment_of_Courage_buff"
end

function Advanced_Moment_of_Courage:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")

	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else 
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end
function Advanced_Moment_of_Courage:OnSpellStart()
	-- local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_LegionCommander.Overwhelming.Buff")
	local duration = 7
	if self.unlock1 then
		duration = 20
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_Moment_of_Courage_active_lv20", {duration =duration})
	self:StartCooldown(10)
	

end

modifier_Advanced_Moment_of_Courage_buff = advanced_modifier({})
function modifier_Advanced_Moment_of_Courage_buff:IsDebuff()	return false end
function modifier_Advanced_Moment_of_Courage_buff:IsHidden()	return true end
function modifier_Advanced_Moment_of_Courage_buff:OnCreated()
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
	end
end
function modifier_Advanced_Moment_of_Courage_buff:OnRefresh()
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
	end
end
function modifier_Advanced_Moment_of_Courage_buff:ADDeclareFunctions()	
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		}
end

function modifier_Advanced_Moment_of_Courage_buff:DeclareFunctions()	
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT
		}
end
function modifier_Advanced_Moment_of_Courage_buff:GetModifierEvasion_Constant()
	if self:GetParent():PassivesDisabled() then
		return
	end
	self.eva_down = self:GetAbility():GetSpecialValueFor("eva_down")
	return -self.eva_down
end

function modifier_Advanced_Moment_of_Courage_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self:GetParent() or keys.target == nil then
		return 0
	end
	if keys.target:PassivesDisabled() then
		return
	end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
		return 0
	end

	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	if not self:GetAbility():IsCooldownReady() then
		self.incoming = self.incoming + self:GetAbility():GetSpecialValueFor("bonus_incoming")
	end
	if self:GetAbility().advanced_level >= 15 and not self:GetAbility():IsCooldownReady() then
		local random = math.random
		if 10 >= random(1,100) then
			self.incoming = 100
		end
	end
	return -self.incoming
end

function modifier_Advanced_Moment_of_Courage_buff:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local caster = self:GetCaster()
	if keys.target ~= caster or caster:PassivesDisabled() then
		return
	end
	if caster:HasModifier("modifier_Advanced_Moment_of_Courage_active_lv20") then
		if self:GetAbility().unlock1 then
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Moment_of_Courage_active", {duration = 2})
		else
			local random = math.random
			self.chance = self:GetAbility():GetSpecialValueFor("chance")
			if not caster:IsRangedAttacker() then
				self.chance = self.chance + 20
			end
			if self.chance+30 >= random(1,100) then
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Moment_of_Courage_active", {duration = 2})
			end
		end
	else
		if self:GetAbility():IsCooldownReady() then
			local random = math.random
			self.chance = self:GetAbility():GetSpecialValueFor("chance")
			if not caster:IsRangedAttacker() then
				self.chance = self.chance + 20
			end
			if self.chance >= random(1,100) then
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Moment_of_Courage_active", {duration = 2})
			end
		end
	end

end



modifier_Advanced_Moment_of_Courage_active = advanced_modifier({})

function modifier_Advanced_Moment_of_Courage_active:IsDebuff()	return false end
function modifier_Advanced_Moment_of_Courage_active:IsHidden()	return true end
function modifier_Advanced_Moment_of_Courage_active:IsPurgable() return false end
function modifier_Advanced_Moment_of_Courage_active:IsPurgeException() return false end
function modifier_Advanced_Moment_of_Courage_active:DeclareFunctions()	
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 then
		table.insert(funcs,MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL)
	end
	return funcs
	
end
function modifier_Advanced_Moment_of_Courage_active:OnCreated(keys)
	if IsServer() then
		self.active = false
	end
end
function modifier_Advanced_Moment_of_Courage_active:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local caster = self:GetCaster()
	if keys.attacker ~= caster then
		return
	end
	if self.active then
		return
	end
	self.modifier = false
	self:SetDuration(0.3, false)
	self.active =true
	Timers:CreateTimer(0.05, function()
		if keys.target and  not keys.target:IsNull() and  keys.target:IsAlive() then
			local ability = self:GetAbility()
			
			if ability then

				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 1,
					iDisableCleave =1,
					iDisableSplit = 1,
				}
				
				local effect_name = "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf"

				if ability.advanced_level >= 10 then
					effect_name =  "particles/rebuild/spell/moment_of_courage/lv10_effect/effect.vpcf"
					self.modifier = true
					modifier_keys.iDisableApplyModifier = 0
				end

				self.life_steal = true

				local modifier =  keys.target:AddNewModifier(caster, ability, "modifier_Advanced_Moment_of_Courage_debuff", {duration = 2})

				if ability.unlock2 then

					local unlock2_modifier = caster:AddNewModifier(caster, ability, "modifier_Advanced_Moment_of_Courage_active_unlock2", {duration = 2})
					local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
					caster:PerformAttack(keys.target, self.modifier, self.modifier, true, false, true, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
					if IsValid(attackEffectRecord) then
						attackEffectRecord:Destroy()
					end
					if unlock2_modifier then
						unlock2_modifier:SafeDestroy()
					end

				else

					local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
					caster:PerformAttack(keys.target, self.modifier, self.modifier, true, false, true, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
					if IsValid(attackEffectRecord) then
						attackEffectRecord:Destroy()
					end

				end
				
				
				if modifier then
					modifier:SafeDestroy()
				end
				local pfx = ParticleManager:CreateParticle( effect_name, PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( pfx, 0, caster:GetOrigin()  )
				ParticleManager:SetParticleControlForward(pfx, 0, caster:GetForwardVector())  --方向
				DestroyParticleByDelay(pfx,0.6)
				caster:EmitSound("Hero_LegionCommander.Courage")
				caster:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_ATTACK, 0.1, 0.9, 20)
				-- :UseResources(true, true, true, true)
				ability:StartCooldown(ability:GetCooldownTimeRemaining()+ability:GetCooldown(ability:GetLevel())* caster:GetCooldownReduction() )
				
				--caster:AddNewModifier(caster, ability, "modifier_Advanced_Moment_of_Courage_active2", {duration = 2})
				if self and not self:IsNull() then
					self:SafeDestroy()
				end
			end
			
			
		else
			if self and not self:IsNull() then
				self:SafeDestroy()
			end
		end
	end)

	
end


function modifier_Advanced_Moment_of_Courage_active:OnTakeDamage( params )

	if IsServer() then
		if not self.life_steal then
			return
		end
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if Attacker:PassivesDisabled() then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		local life_steal = self:GetAbility():GetSpecialValueFor("life_steal")*0.01
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * life_steal*gain
		Attacker:Heal( flLifesteal, self:GetAbility() )
	end

	return 0.0

end

function modifier_Advanced_Moment_of_Courage_active:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		if not self.life_steal then
			return
		end
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end

		local index = 0.5
		if self:GetAbility().unlock2 then
			index = 1.5
		end
		local bonus_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*index

		return bonus_damage
	end
end




modifier_Advanced_Moment_of_Courage_debuff =modifier_Advanced_Moment_of_Courage_debuff or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Moment_of_Courage_debuff:IsHidden()	return true end
function modifier_Advanced_Moment_of_Courage_debuff:IsDebuff()	return true end
function modifier_Advanced_Moment_of_Courage_debuff:IsStunDebuff()	return false end
function modifier_Advanced_Moment_of_Courage_debuff:IsPurgable()	return true end
function modifier_Advanced_Moment_of_Courage_debuff:OnCreated()
	self.armor_down = self:GetAbility():GetSpecialValueFor("armor_down")
end

function modifier_Advanced_Moment_of_Courage_debuff:CheckState()
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 5 then
		return {
			[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_STUNNED] = true,
		}
	end

	return{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end

function modifier_Advanced_Moment_of_Courage_debuff:DeclareFunctions()
	local funcs = {

	}
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end

	return funcs
end

function modifier_Advanced_Moment_of_Courage_debuff:Advanced_GetModifierPhysicalArmorBonus()
		
	return -self.armor_down
end

function modifier_Advanced_Moment_of_Courage_debuff:Advanced_GetModifierIncomingDamage_Percentage()
	return 150
end

function modifier_Advanced_Moment_of_Courage_debuff:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetCaster() or Target == nil then
			return 0
		end
		if Target~=self:GetParent() then
			return
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end
		if self.done then
			return
		end
		if (flDamage+100)>=Target:GetHealth() and Target:GetHealthPercent()<=30 then
			self.done = true
			-- 即死效果也是一次伤害
			TrueKill(Attacker, Target, self:GetAbility())
		end

	end

	return 0.0

end


function modifier_Advanced_Moment_of_Courage_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end

	return funcs
end




modifier_Advanced_Moment_of_Courage_active2 =modifier_Advanced_Moment_of_Courage_active2 or  class({})

function modifier_Advanced_Moment_of_Courage_active2:IsDebuff()	return false end
function modifier_Advanced_Moment_of_Courage_active2:IsHidden()	return false end
function modifier_Advanced_Moment_of_Courage_active2:IsPurgable() return false end
function modifier_Advanced_Moment_of_Courage_active2:IsPurgeException() return false end
function modifier_Advanced_Moment_of_Courage_active2:DeclareFunctions()	return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	} 
end
function modifier_Advanced_Moment_of_Courage_active2:OnCreated(keys)
	if IsServer() then
		if self:GetAbility().advanced_level>=15 then
			self:SetStackCount(2)
		else
			self:SetStackCount(1)
		end
		
		self.bonus_speed = 1300
	end
end
function modifier_Advanced_Moment_of_Courage_active2:GetModifierAttackSpeedBonus_Constant(keys)
	return self.bonus_speed
end
function modifier_Advanced_Moment_of_Courage_active2:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local caster = self:GetCaster()
	if keys.attacker ~= caster then
		return
	end
	if self.active then
		return
	end
	self:DecrementStackCount()
	if self:GetStackCount()<=0 then
		self:SafeDestroy()
	end
	
end







modifier_Advanced_Moment_of_Courage_active_lv20 =modifier_Advanced_Moment_of_Courage_active_lv20 or  class({})

function modifier_Advanced_Moment_of_Courage_active_lv20:IsDebuff()	return false end
function modifier_Advanced_Moment_of_Courage_active_lv20:IsHidden()	return false end
function modifier_Advanced_Moment_of_Courage_active_lv20:IsPurgable() return false end
function modifier_Advanced_Moment_of_Courage_active_lv20:IsPurgeException() return false end
function modifier_Advanced_Moment_of_Courage_active_lv20:GetEffectName() return "particles/rebuild/spell/moment_of_courage/lv20_effect.vpcf" end


function modifier_Advanced_Moment_of_Courage_active_lv20:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock1 then
			local cooldown = ability:GetCooldownTimeRemaining()
			if cooldown>0 then
				ability:EndCooldown()
				ability:StartCooldown(cooldown*0.5)
			end
		end
	end
end





modifier_Advanced_Moment_of_Courage_active_unlock2 =  modifier_Advanced_Moment_of_Courage_active_unlock2 or advanced_modifier({})

function modifier_Advanced_Moment_of_Courage_active_unlock2:IsDebuff() return false end
function modifier_Advanced_Moment_of_Courage_active_unlock2:IsHidden() return true end
function modifier_Advanced_Moment_of_Courage_active_unlock2:IsPurgable() return false end
function modifier_Advanced_Moment_of_Courage_active_unlock2:IsPurgeException() return false end
function modifier_Advanced_Moment_of_Courage_active_unlock2:RemoveOnDeath() return false end

function modifier_Advanced_Moment_of_Courage_active_unlock2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp,
    }
end
function modifier_Advanced_Moment_of_Courage_active_unlock2:Advanced_GetModifier_PhysicalCriticalAmp(keys)
	return 150
end