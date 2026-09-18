
LinkLuaModifier("modifier_Middle_Moment_of_Courage_buff", "skills/Middle_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Moment_of_Courage_active", "skills/Middle_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Moment_of_Courage_debuff", "skills/Middle_Moment_of_Courage", LUA_MODIFIER_MOTION_NONE)


Middle_Moment_of_Courage	= Middle_Moment_of_Courage or class({})
require("internal/timers")

function Middle_Moment_of_Courage:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", context )
end
function Middle_Moment_of_Courage:GetIntrinsicModifierName()
	return "modifier_Middle_Moment_of_Courage_buff"
end



modifier_Middle_Moment_of_Courage_buff = advanced_modifier({})
function modifier_Middle_Moment_of_Courage_buff:IsDebuff()	return false end
function modifier_Middle_Moment_of_Courage_buff:IsHidden()	return true end
function modifier_Middle_Moment_of_Courage_buff:OnCreated()
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
	end
end
function modifier_Middle_Moment_of_Courage_buff:OnRefresh()
	if IsServer() then
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
	end
end
function modifier_Middle_Moment_of_Courage_buff:ADDeclareFunctions()	
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		}
end

function modifier_Middle_Moment_of_Courage_buff:DeclareFunctions()	
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT
		}
end
function modifier_Middle_Moment_of_Courage_buff:GetModifierEvasion_Constant()
	if self:GetParent():PassivesDisabled() then
		return
	end
	self.eva_down = self:GetAbility():GetSpecialValueFor("eva_down")
	return -self.eva_down
end

function modifier_Middle_Moment_of_Courage_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)
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
	return -self.incoming
end

function modifier_Middle_Moment_of_Courage_buff:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local caster = self:GetCaster()
	if keys.target ~= caster or caster:PassivesDisabled() then
		return
	end
    if  self:GetAbility():IsCooldownReady() then
		local random = math.random
		self.chance = self:GetAbility():GetSpecialValueFor("chance")
		if not caster:IsRangedAttacker() then
			self.chance = self.chance + 20
		end
		if self.chance >= random(1,100) then
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Moment_of_Courage_active", {duration = 2})
	    end
    end
end



modifier_Middle_Moment_of_Courage_active = advanced_modifier({})

function modifier_Middle_Moment_of_Courage_active:IsDebuff()	return false end
function modifier_Middle_Moment_of_Courage_active:IsHidden()	return true end
function modifier_Middle_Moment_of_Courage_active:IsPurgable() return false end
function modifier_Middle_Moment_of_Courage_active:IsPurgeException() return false end
function modifier_Middle_Moment_of_Courage_active:DeclareFunctions()	return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end
function modifier_Middle_Moment_of_Courage_active:OnCreated(keys)
	if IsServer() then
		self.active = false
	end
end
function modifier_Middle_Moment_of_Courage_active:OnAttackLanded(keys)
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
	self:SetDuration(0.3, false)
	self.active =true
	Timers:CreateTimer(0.1, function()
		if keys.target and  not keys.target:IsNull() and  keys.target:IsAlive() then
			if not self or self:IsNull() then
				return
			end
			self.life_steal = true
			local modifier =  keys.target:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Moment_of_Courage_debuff", {duration = 2})
			local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 1,
					iDisableCleave =1,
					iDisableSplit = 1,
				}
			local attackEffectRecord =self:GetParent():AddAttackEffectModifier(self:GetAbility(),modifier_keys)
			self.life_steal = true
			caster:PerformAttack(keys.target, false, false, true, false, true, false, true)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
			if modifier then
				modifier:SafeDestroy()
			end
			local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, caster:GetOrigin()  )
			ParticleManager:SetParticleControlForward(pfx, 0, caster:GetForwardVector())  --方向
			DestroyParticleByDelay(pfx,0.6)
			caster:EmitSound("Hero_LegionCommander.Courage")
			caster:StartGestureWithFadeAndPlaybackRate(ACT_DOTA_ATTACK, 0.1, 0.9, 20)
			self:GetAbility():UseResources(true, true, true,true)
			self:SafeDestroy()
		else
			if self and not self:IsNull() then
				self:SafeDestroy()
			end
		end
	end)

	
end


function modifier_Middle_Moment_of_Courage_active:OnTakeDamage( params )

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




modifier_Middle_Moment_of_Courage_debuff =modifier_Middle_Moment_of_Courage_debuff or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Moment_of_Courage_debuff:IsHidden()	return true end
function modifier_Middle_Moment_of_Courage_debuff:IsDebuff()	return true end
function modifier_Middle_Moment_of_Courage_debuff:IsStunDebuff()	return false end
function modifier_Middle_Moment_of_Courage_debuff:IsPurgable()	return true end
function modifier_Middle_Moment_of_Courage_debuff:OnCreated()
	self.armor_down = self:GetAbility():GetSpecialValueFor("armor_down")
end
function modifier_Middle_Moment_of_Courage_debuff:CheckState()
	return{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end
function modifier_Middle_Moment_of_Courage_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Middle_Moment_of_Courage_debuff:Advanced_GetModifierPhysicalArmorBonus()
	return -self.armor_down
end
