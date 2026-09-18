Advanced_cold_embrace = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_cold_embrace_buff", "skills/Advanced_cold_embrace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_cold_embrace_buff_bonus", "skills/Advanced_cold_embrace", LUA_MODIFIER_MOTION_NONE)
function Advanced_cold_embrace:CheckKV(key)
	local table = {
		base_heal =5,
		bonus_heal =0.13,

	}
	local value = table[key] or -1
	return value

end

function Advanced_cold_embrace:UnlockFirstCore(key)
	return true
end
function Advanced_cold_embrace:UnlockSecondCore(key)
	return true
end
function Advanced_cold_embrace:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_aether_remnant_passive",{})
	return true
end


function Advanced_cold_embrace:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	if self:GetAutoCastState() then
		duration = -1
	end
	target:AddNewModifier(caster, self, "modifier_Advanced_cold_embrace_buff", {duration = duration })
	caster:EmitSound("Hero_Winter_Wyvern.ColdEmbrace")
	target:EmitSound("Hero_Winter_Wyvern.ColdEmbrace.Cast")
end


function Advanced_cold_embrace:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_flash_g.vpcf", context )


	
end

function Advanced_cold_embrace:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")
	

	if advanced_level>=20 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else 
		return self.BaseClass.GetBehavior(self)
	end
end


modifier_Advanced_cold_embrace_buff = advanced_modifier({})

function modifier_Advanced_cold_embrace_buff:IsDebuff() return false end
function modifier_Advanced_cold_embrace_buff:IsHidden() return false end
function modifier_Advanced_cold_embrace_buff:IsPurgable() return false end
function modifier_Advanced_cold_embrace_buff:IsPurgeException() return false end
-- function modifier_Advanced_cold_embrace_buff:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
-- function modifier_Advanced_cold_embrace_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_cold_embrace_buff:OnCreated(keys)
	if self:GetRemainingTime()<=0 then
		self.auto = true
	end
	local ability = self:GetAbility()
	if ability:GetUnlock(1)==1 then
		self.unlock1 = true
	end
	local level = ability:GetSpecialValueFor("advanced_level")
	self.bonus_status_resistance = 0
	if level>=5 then
		self.bonus_status_resistance = 50
	end
	if IsServer() then

		local parent = self:GetParent()
		
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		self.interval = 0.25
		self:StartIntervalThink(self.interval)
		self.block = ability:GetSpecialValueFor("bonus_block")*self:GetCaster():GetIntellect(false)

		if ability.unlock3 then
			self.unlock3_release = GameRules:GetGameTime()+1
		end

	end
end
function modifier_Advanced_cold_embrace_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
		local ability = self:GetAbility()
		if not ability then
			return
		end
		if ability.advanced_level>=15 then
			self:GetParent():AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_cold_embrace_buff_bonus", {duration = 5})
		end
	end
end


function modifier_Advanced_cold_embrace_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_EVENT_ON_ORDER,
	}
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end
	return funcs
end
function modifier_Advanced_cold_embrace_buff:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local health = (ability:GetSpecialValueFor("base_heal")+ability:GetSpecialValueFor("bonus_heal")*parent:GetMaxHealth()*0.01)*self.interval
	if self.auto then
		health = health *0.5
		if ability.unlock2 then
			self:RefreshAbilityCooldown(parent)
		end
	end
	local healing = HealWithGain(health,caster,parent,ability)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
	if self.unlock3_release  and GameRules:GetGameTime()>=self.unlock3_release  then
		self.unlock3_release = GameRules:GetGameTime()+1
		local stack = self:GetStackCount()
		if stack>=10 then
			local effect = ParticleManager:CreateParticle( "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_flash_g.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			ParticleManager:SetParticleControl(effect, 0, parent:GetOrigin())
			ParticleManager:ReleaseParticleIndex(effect)
			parent:EmitSound("Ability.FrostNova")
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 500,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local damage = {
				-- victim = self.last_hit_source,
				attacker = caster,
				damage = stack,
				ability = ability,
				damage_flags =DOTA_DAMAGE_FLAG_REFLECTION,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			for i, unit in ipairs(enemies) do
				damage.victim = unit
				ApplyDamage( damage )
				if i>=7 then
					break
				end
			end
			
			self:SetStackCount(0)
		end
	end
end
function modifier_Advanced_cold_embrace_buff:RefreshAbilityCooldown(target)
	local base_redece = self.interval*0.8
	for i=0, self:GetParent():GetAbilityCount() - 1 do
		local Ability = self:GetParent():GetAbilityByIndex(i)
		if Ability ~= nil and Ability:IsRefreshable() and not Ability:IsCooldownReady() then
			local newCooldown = Ability:GetCooldownTimeRemaining() - base_redece
			base_redece  = base_redece *0.9
			Ability:EndCooldown()
			if newCooldown>=0 then
				Ability:StartCooldown(newCooldown)
			end
		end
	end
end

function modifier_Advanced_cold_embrace_buff:GetModifierMagicalResistanceBonus() return 70 end
function modifier_Advanced_cold_embrace_buff:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL= {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_StatusResistance,
	}
end
function modifier_Advanced_cold_embrace_buff:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
		return 0
	end
	local block = self.block
	if self.unlock1 then
		local index = 0.5
		if self.auto then
			index = 0.25
		end
		block = math.max(block,keys.damage*index)
	end
	return math.min(keys.damage,block) 
end


function modifier_Advanced_cold_embrace_buff:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end







function modifier_Advanced_cold_embrace_buff:CheckState()
	if self.auto then
		return  {
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_FROZEN] = true,
	
		}
	end
	local ability = self:GetAbility()
	if not ability or ability:GetSpecialValueFor("advanced_level")>=10 then
		return
	end
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		-- [MODIFIER_STATE_STUNNED] = true,
		-- [MODIFIER_STATE_FROZEN] = true,

	}

	return state

end


function modifier_Advanced_cold_embrace_buff:OnOrder(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() and self.auto then

		if keys.order_type==DOTA_UNIT_ORDER_HOLD_POSITION    then
			self:SafeDestroy()
		end


	end
end


function modifier_Advanced_cold_embrace_buff:OnTakeDamage( params )

	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent()  then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if flDamage<=0 then
			return 
		end

		local index = 0.75
		if self.auto then
			index = 0.5
		end
		self:SetStackCount(math.min((self:GetStackCount()+flDamage*index),self:GetParent():GetMaxHealth()*0.5))
		-- self.last_hit_source = params.attacker

	end

	return 0.0

end




modifier_Advanced_cold_embrace_buff_bonus = class({})

function modifier_Advanced_cold_embrace_buff_bonus:IsDebuff() return false end
function modifier_Advanced_cold_embrace_buff_bonus:IsHidden() return false end
function modifier_Advanced_cold_embrace_buff_bonus:IsPurgable() return false end
function modifier_Advanced_cold_embrace_buff_bonus:IsPurgeException() return false end
-- function modifier_Advanced_cold_embrace_buff_bonus:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" end
-- function modifier_Advanced_cold_embrace_buff_bonus:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_cold_embrace_buff_bonus:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		self.interval = 0.25
		self:StartIntervalThink(self.interval)


	end
end
function modifier_Advanced_cold_embrace_buff_bonus:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end
function modifier_Advanced_cold_embrace_buff_bonus:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local health = (ability:GetSpecialValueFor("base_heal")+ability:GetSpecialValueFor("bonus_heal")*parent:GetMaxHealth()*0.01)*self.interval
	local healing = HealWithGain(health,caster,parent,ability)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
end