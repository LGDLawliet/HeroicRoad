
LinkLuaModifier( "modifier_Advanced_rage", "skills/Advanced_rage", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_rage_unlock1", "skills/Advanced_rage", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_rage_unlock1_effect", "skills/Advanced_rage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_rage_unlock2_active", "skills/Advanced_rage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_rage_unlock3", "skills/Advanced_rage", LUA_MODIFIER_MOTION_NONE )

Advanced_rage						= Advanced_rage or class({})
function Advanced_rage:CheckKV(key)
	local table = {

	


		bonus_move = 1,
		duration = 0.2,





	}
	local value = table[key] or -1
	return value

end

function Advanced_rage:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_rage_unlock1",{})
	return true
end
function Advanced_rage:UnlockSecondCore(key)
	self.count = 100
	return true
end
function Advanced_rage:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_rage_unlock3",{})
	return true
end





function Advanced_rage:IsRefreshable() return false end
function Advanced_rage:OnSpellStart()
	local caster =self:GetCaster()
	local Gain = caster:GetModifierDurationGainIndex(0.5)
	local duration = self:GetSpecialValueFor("duration")
	--LV15解锁群起而攻之
	if self.advanced_level>=15 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  500,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		for _, unit in pairs(units) do
			if not unit:HasModifier("modifier_Advanced_rage") then
				unit:AddNewModifier(caster, self, "modifier_Advanced_rage", {duration =duration*Gain*0.5})
			end
			
		end
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_rage", {duration =duration*Gain})
	if self.unlock2 then
		caster:AddNewModifier(caster, self, "modifier_Advanced_rage_unlock2_active", {duration =5,count = self.count})
		self.count = math.min(self.count + 2,300)
	end
end





modifier_Advanced_rage = advanced_modifier({})

-----------------------------------------------------------------------------------------
function modifier_Advanced_rage:IsDebuff() return false end
function modifier_Advanced_rage:IsHidden() return false end
function modifier_Advanced_rage:IsPurgable()
	return false
end

function modifier_Advanced_rage:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_Advanced_rage:StatusEffectPriority()
	return 60
end

-----------------------------------------------------------------------------------------

function modifier_Advanced_rage:OnCreated( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.enrage_movespeed_bonus = self:GetAbility():GetSpecialValueFor( "bonus_move" )

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		self.take_damage = 0 --记录受到伤害
		self.bonus_count = 0
		EmitSoundOn( "Hero_LifeStealer.Rage", self:GetParent() )
		self:GetParent():Purge(false, true, false, true, true)  --强驱散


	end
end

function modifier_Advanced_rage:OnRefresh(table)
	if IsServer() then
		self.bonus_count = 0
		EmitSoundOn( "Hero_LifeStealer.Rage", self:GetParent() )
		self:GetParent():Purge(false, true, false, true, true)  --强驱散
	end
end


-----------------------------------------------------------------------------------------

function modifier_Advanced_rage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_Advanced_rage:GetModifierMoveSpeedBonus_Percentage( params )
	return self.enrage_movespeed_bonus
end



-----------------------------------------------------------------------------------------

function modifier_Advanced_rage:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end

	return state
end

-----------------------------------------------------------------------------------------

function modifier_Advanced_rage:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.attacker == self:GetParent() then
		local heal_index = 0.1
		--LV5解锁食尸鬼+
		if self.advanced_level>=5 then
			heal_index = 0.15
		end
        keys.attacker:Heal(keys.attacker:GetMaxHealth()*heal_index, self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, keys.attacker:GetMaxHealth()*0.1, nil)
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_loadout.vpcf", PATTACH_POINT_FOLLOW,keys.attacker)
		-- ParticleManager:SetParticleControl(particle, 0, keys.unit:GetAbsOrigin())
		-- ParticleManager:SetParticleControl(particle, 1, keys.attacker:GetAbsOrigin())
		-- ParticleManager:ReleaseParticleIndex(particle)
		keys.attacker:EmitSound("Hero_LifeStealer.Infest")
		--LV20解锁狂化++
		if self.advanced_level>=20 then
			local time = self:GetRemainingTime()
			if time>0 then
				self:SetDuration(self:GetRemainingTime()+0.5, true)
			end
			
		end
    end


   
end



function modifier_Advanced_rage:OnTakeDamage(tg)
    if IsServer() then   
		-- local Ability = tg.inflictor
		--初始判断 满足以下:
		--造成伤害者是状态携带者
		--伤害者不是幻象
		--伤害类型是攻击伤害
		--不带反甲伤害标签
		--不带不造成吸血标签
		local parent = self:GetParent()
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION  then return end
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then return end


		local time = self:GetRemainingTime()
		if time<0 then
			return
		end

		if self.bonus_count>=10 then
			return
		end
		--触发受到伤害
		if tg.unit==parent 	and not parent:IsIllusion()  then 
			self.take_damage = self.take_damage +tg.damage
			local gain_index = 0.1
			--LV10解锁狂化+
			if self.advanced_level>=10 then
				gain_index = 0.07
			end

			local parent_health = parent:GetMaxHealth()*gain_index

			if self.take_damage>=parent_health then
				local stack = self.take_damage / parent_health
				stack = stack-stack%1
				self.take_damage =self.take_damage -parent_health * stack
				self:SetDuration(self:GetRemainingTime()+1, true)
				self.bonus_count = self.bonus_count +1
			end

			

        end 




    end 
end

function modifier_Advanced_rage:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end




function modifier_Advanced_rage:OnWaveEnd()
    if IsServer() then
		self:Destroy()
	end
end




modifier_Advanced_rage_unlock1 = class({})

function modifier_Advanced_rage_unlock1:IsDebuff()			return false end
function modifier_Advanced_rage_unlock1:IsHidden() 			return true end
function modifier_Advanced_rage_unlock1:IsPurgable() 		return false end
function modifier_Advanced_rage_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_rage_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_rage_unlock1:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()

		unit:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_rage_unlock1_effect", {})

	end
end

modifier_Advanced_rage_unlock1_effect = class({})

function modifier_Advanced_rage_unlock1_effect:IsDebuff()			return false end
function modifier_Advanced_rage_unlock1_effect:IsHidden() 			return true end
function modifier_Advanced_rage_unlock1_effect:IsPurgable() 		return false end
function modifier_Advanced_rage_unlock1_effect:IsPurgeException() 	return false end
function modifier_Advanced_rage_unlock1_effect:RemoveOnDeath() return false end
function modifier_Advanced_rage_unlock1_effect:OnCreated()
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(10)
	end
end

function modifier_Advanced_rage_unlock1_effect:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_rage", {duration =5})
end







modifier_Advanced_rage_unlock2_active = class({})

function modifier_Advanced_rage_unlock2_active:IsDebuff()			return false end
function modifier_Advanced_rage_unlock2_active:IsHidden() 			return true end
function modifier_Advanced_rage_unlock2_active:IsPurgable() 		return true end
function modifier_Advanced_rage_unlock2_active:IsPurgeException() 	return true end
function modifier_Advanced_rage_unlock2_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_rage_unlock2_active:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.count)
		self.count = keys.count
		self:StartIntervalThink(0.033)
	end
end
function modifier_Advanced_rage_unlock2_active:OnIntervalThink()
	local index = self.count * self:GetRemainingTime()/5
	self:SetStackCount(index)
end
function modifier_Advanced_rage_unlock2_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Advanced_rage_unlock2_active:GetModifierBonusStats_Strength()	return self:GetStackCount() end
function modifier_Advanced_rage_unlock2_active:GetModifierBonusStats_Intellect()	return self:GetStackCount() end
function modifier_Advanced_rage_unlock2_active:GetModifierBonusStats_Agility()	return self:GetStackCount() end









modifier_Advanced_rage_unlock3 = class({})

function modifier_Advanced_rage_unlock3:IsDebuff()			return false end
function modifier_Advanced_rage_unlock3:IsHidden() 			return true end
function modifier_Advanced_rage_unlock3:IsPurgable() 		return false end
function modifier_Advanced_rage_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_rage_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_rage_unlock3:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()
		if unit:GetUnitName()=="npc_hd_jack_the_ripper" and keys.inflictor:GetAbilityName()=="Advanced_summons_undead_jack_the_ripper"  then
			unit:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_rage", {})
		end

		

	end
end
