--特效优化 √
Advanced_lunar_blessing = class({})

LinkLuaModifier("modifier_Advanced_lunar_blessing_passive", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_lunar_blessing_effect", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_lunar_blessing_active", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_lunar_blessing_active_lv20", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_lunar_blessing_unlock1", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_lunar_blessing_unlock1_trigger", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_lunar_blessing_unlock1_buff", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_lunar_blessing_unlock2_bonus_check", "skills/Advanced_lunar_blessing", LUA_MODIFIER_MOTION_NONE)

function Advanced_lunar_blessing:Precache( context )

	
	PrecacheResource( "particle", "particles/rebuild/lunar_blessing/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", context )

	

end

function Advanced_lunar_blessing:Spawn()
	if not self.unlock1_bonus then
		self.unlock1_bonus = 0
	end
	if not self.unlock2_bonus then
		self.unlock2_bonus = 0
	end
end
function Advanced_lunar_blessing:ModifyUnlock1Bonus(value)
	self.unlock1_bonus =self.unlock1_bonus+value
end
function Advanced_lunar_blessing:GetUnlock1Bonus()
	return self.unlock1_bonus *10
end

function Advanced_lunar_blessing:ModifyUnlock2Bonus(value)
	if self.unlock2_bonus>=200 then
		self.unlock2_bonus =self.unlock2_bonus+value*0.5
	else
		self.unlock2_bonus =self.unlock2_bonus+value
	end
	
end
function Advanced_lunar_blessing:GetUnlock2Bonus()
	local bonus = self.unlock2_bonus*0.12
	-- print("bonus="..bonus)
	return bonus
end


function Advanced_lunar_blessing:UnlockFirstCore(key)
    local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_lunar_blessing_unlock1",{})
	self:SetLevel(0)
	self:SetLevel(1)
	return true
end
function Advanced_lunar_blessing:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_lunar_blessing:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Blood_Sacrifice_unlock3",{})
	return true
end
-- require('internal/timers')   --计时器功能
function Advanced_lunar_blessing:CastFilterResult()
	-- check nohammer
	if IsClient() then
		return
	end
	if self:GetAutoCastState() then
		if self:GetCaster():GetGold()<500 then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
	local time = GameRules:GetTimeOfDay()
	if  _G.GAME_CHANGING_TIME_OF_DAY or not Game_State:IsInBattle()  then
		return UF_FAIL_CUSTOM
	end
	if time<0.25 or time>0.75 then
		if self:GetSpecialValueFor("advanced_level")>=5 then
			return UF_SUCCESS
		end
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function Advanced_lunar_blessing:GetCustomCastError()
	if IsClient() then
		return
	end
	if self:GetAutoCastState() then
		if self:GetCaster():GetGold()<500 then
			-- return "#dota_hud_error_nohammer"
			return "#dota_hud_greevils_not_enough_gold"
		end
		return ""
	end
	local time = GameRules:GetTimeOfDay()
	if _G.GAME_CHANGING_TIME_OF_DAY then
		return "#dota_hud_still_chaghing"
	end
	if not Game_State:IsInBattle()  then
		return "dota_hud_not_in_battle"
	end
	if time<0.25 or time>0.75 then
		if self:GetSpecialValueFor("advanced_level")>=5 then
			return ""
		end
		return "dota_hud_still_night"
	end
	return ""
end
function Advanced_lunar_blessing:OnAdvancedUpgrade()
	self:SetLevel(0)
	self:SetLevel(1)
end
function Advanced_lunar_blessing:CheckKV(key)
	local table = {
		bonus_damage =3,

	}
	if self:GetUnlock(2)==2 then
		table.bonus_damage = (3 + self:GetUnlock2Bonus())
	end
	local value = table[key] or -1
	return value

end

function Advanced_lunar_blessing:GetBehavior()


	if  self:GetUnlock(2)==2 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
end


function Advanced_lunar_blessing:GetManaCost(iLevel)
	if IsServer() and self:GetAutoCastState() then
		return 0
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end
function Advanced_lunar_blessing:GetCooldown(iLevel)
	if IsServer() and self:GetAutoCastState() then
		return 0.2
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end

function Advanced_lunar_blessing:OnSpellStart()

	local caster    =   self:GetCaster()

	caster:EmitSound("Hero_Luna.Eclipse.Cast")


	local particle_caster_ground_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN, caster)
	-- ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_caster_ground_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)

	if self:GetAutoCastState() then
		caster:ModifyGoldFiltered(-500,true,DOTA_ModifyGold_PurchaseItem  )  --金币
		caster:AddNewModifier(caster, self, "modifier_Advanced_lunar_blessing_unlock2_bonus_check", {duration = 1})
		self:SetLevel(0)
		self:SetLevel(1)
		return
	end



	local time = GameRules:GetTimeOfDay() --记录当前时间
	GameRules:SetTimeOfDay(0.75)  --强制黑夜
	local duration = 10
	if self.advanced_level>=20 then
		duration = 15
		caster:AddNewModifier(caster, self, "modifier_Advanced_lunar_blessing_active_lv20", {duration = duration,time = time})
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_lunar_blessing_active", {duration = duration,time = time})

end

function Advanced_lunar_blessing:GetIntrinsicModifierName() return "modifier_Advanced_lunar_blessing_passive" end

modifier_Advanced_lunar_blessing_passive = advanced_modifier({})

function modifier_Advanced_lunar_blessing_passive:IsHidden() return true end
function modifier_Advanced_lunar_blessing_passive:IsAura() return not self:GetCaster():PassivesDisabled() end
function modifier_Advanced_lunar_blessing_passive:GetAuraDuration() return 0.5 end
function modifier_Advanced_lunar_blessing_passive:GetModifierAura() return "modifier_Advanced_lunar_blessing_effect" end
function modifier_Advanced_lunar_blessing_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_Advanced_lunar_blessing_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_Advanced_lunar_blessing_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_lunar_blessing_passive:GetAuraSearchType() 
	if self:GetAbility().unlock2 then
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end
	return DOTA_UNIT_TARGET_HERO
 end


function modifier_Advanced_lunar_blessing_passive:Advanced_GetBonusNightVision()	
	if self:GetCaster():HasModifier("modifier_Advanced_lunar_blessing_active_lv20") then
		return self:GetCaster():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("self_night_vision_bonus")*2
	end
	return self:GetCaster():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("self_night_vision_bonus")
end



-- advanced_modifier
function modifier_Advanced_lunar_blessing_passive:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION


    }
end





modifier_Advanced_lunar_blessing_effect = class({})

function modifier_Advanced_lunar_blessing_effect:IsDebuff()			return false end
function modifier_Advanced_lunar_blessing_effect:IsHidden() 			return false end
function modifier_Advanced_lunar_blessing_effect:IsPurgable() 			return false end
function modifier_Advanced_lunar_blessing_effect:IsPurgeException() 	return false end
function modifier_Advanced_lunar_blessing_effect:OnCreated(table)
	local ability = self:GetAbility()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if ability:GetUnlock(1)==1 then
		self.unlock1 = true
	end
	if IsServer() then

		local level = ability:GetSpecialValueFor("advanced_level")
		self.bonus_str = 0
		self.bonus_agi = 0
		self.bonus_int = 0
		if not self:GetParent():IsRealHero() then
			return
		end
		local bonus = 25
		if level>=10 then
			bonus = 40
		end
		local attriubute = self:GetParent():GetPrimaryAttribute()
		if attriubute==0 then
			self.bonus_str = bonus
		elseif attriubute==1 then
			self.bonus_agi = bonus
		else
			self.bonus_int =bonus
		end
		if level>=15 then
			self.bonus_str = self.bonus_str+self:GetParent():GetStrengthGain() *4
			self.bonus_agi =self.bonus_agi+ self:GetParent():GetAgilityGain() *4
			self.bonus_int = self.bonus_int+self:GetParent():GetIntellectGain() *4
		end

	end
	
end

function modifier_Advanced_lunar_blessing_effect:OnRefresh()
	self:OnCreated()
end

function modifier_Advanced_lunar_blessing_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	if self:GetParent():IsRealHero() then
		table.insert(funcs,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
		table.insert(funcs,MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
		table.insert(funcs,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
	end
	
	return funcs
end
-- :GetUnlock1Bonus()

function modifier_Advanced_lunar_blessing_effect:GetModifierBaseAttack_BonusDamage()	
	if self:GetCaster():HasModifier("modifier_Advanced_lunar_blessing_active") then
		return 2*self.bonus_damage  
	end
	return self.bonus_damage  
end





function modifier_Advanced_lunar_blessing_effect:GetModifierBonusStats_Strength()	
	local bonus = self.bonus_str
	if self:GetCaster():HasModifier("modifier_Advanced_lunar_blessing_active_lv20") then
		bonus = bonus * 2
	end
	if self.unlock1 then
		bonus = bonus+self:GetAbility():GetUnlock1Bonus()
	end
	return bonus
end

function modifier_Advanced_lunar_blessing_effect:GetModifierBonusStats_Agility()	
	local bonus = self.bonus_agi
	if self:GetCaster():HasModifier("modifier_Advanced_lunar_blessing_active_lv20") then
		bonus = bonus * 2
	end
	if self.unlock1 then
		bonus = bonus+self:GetAbility():GetUnlock1Bonus()
	end
	return bonus 
end

function modifier_Advanced_lunar_blessing_effect:GetModifierBonusStats_Intellect()	
	local bonus = self.bonus_int
	if self:GetCaster():HasModifier("modifier_Advanced_lunar_blessing_active_lv20") then
		bonus = bonus * 2
	end
	if self.unlock1 then
		bonus = bonus+self:GetAbility():GetUnlock1Bonus()
	end
	return bonus
end

function modifier_Advanced_lunar_blessing_effect:OnAttackLanded(keys)
	if not IsServer() then return end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	if not ability.unlock3 then
		return
	end
	local parent = self:GetParent()
	if keys.attacker == parent and keys.target and keys.target:GetTeamNumber() ~= parent:GetTeamNumber() and  not self:GetCaster():PassivesDisabled() then	
		if not parent:IsRealHero() then
			return false
		end
		if parent:GetRandomEffect(15,INT_TYPE,1)  > RandomInt(1, 100) then
			local pass = false
			if self.ability and not self.ability:IsNull() then
				pass = true
			else
				self.ability = parent:FindAbilityByName("Advanced_lucent_beam")
				if self.ability then
					pass = true
				end
			end
			if pass then
				self.ability:CreateSingleLucent(keys.target)
			end
		end
	end
end


modifier_Advanced_lunar_blessing_active = class({})

function modifier_Advanced_lunar_blessing_active:IsDebuff() return false end
function modifier_Advanced_lunar_blessing_active:IsHidden() return false end
function modifier_Advanced_lunar_blessing_active:IsPurgable() return false end
function modifier_Advanced_lunar_blessing_active:IsPurgeException() return false end
function modifier_Advanced_lunar_blessing_active:OnCreated(keys) 
	if IsServer() then
		self.time = keys.time
		_G.GAME_CHANGING_TIME_OF_DAY = true
		
	end
end
function modifier_Advanced_lunar_blessing_active:OnDestroy()
	if IsClient() then
		return
	end
	if _G.GAME_CHANGING_NIGHT_WORLD_RULE then  --返回强制黑夜关卡
		GameRules:SetTimeOfDay(-1)
	else  --说明当前不是强制黑夜关卡了 那么返回记录的过去时间
		GameRules:SetTimeOfDay(self.time)
	end
	_G.GAME_CHANGING_TIME_OF_DAY = false
end


modifier_Advanced_lunar_blessing_active_lv20 = class({})

function modifier_Advanced_lunar_blessing_active_lv20:IsDebuff() return false end
function modifier_Advanced_lunar_blessing_active_lv20:IsHidden() return true end
function modifier_Advanced_lunar_blessing_active_lv20:IsPurgable() return false end
function modifier_Advanced_lunar_blessing_active_lv20:IsPurgeException() return false end







modifier_Advanced_lunar_blessing_unlock1 = class({})

function modifier_Advanced_lunar_blessing_unlock1:IsDebuff() return false end
function modifier_Advanced_lunar_blessing_unlock1:IsHidden() return true end
function modifier_Advanced_lunar_blessing_unlock1:IsPurgable() return false end
function modifier_Advanced_lunar_blessing_unlock1:IsPurgeException() return false end
function modifier_Advanced_lunar_blessing_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_lunar_blessing_unlock1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(5)
	end
end
function modifier_Advanced_lunar_blessing_unlock1:OnIntervalThink()
	local parent = self:GetParent()
	if parent:IsAlive() then
		local pos = GetGroundPosition(parent:GetOrigin() + Vector(RandomInt(-1200, 1200),RandomInt(-1200, 1200),0), parent)
		parent:AddNewModifier(parent,self:GetAbility(),"modifier_Advanced_lunar_blessing_unlock1_trigger",{duration = 5 , pos = pos})
	end
end


modifier_Advanced_lunar_blessing_unlock1_trigger = class({})

function modifier_Advanced_lunar_blessing_unlock1_trigger:IsDebuff() return false end
function modifier_Advanced_lunar_blessing_unlock1_trigger:IsHidden() return true end
function modifier_Advanced_lunar_blessing_unlock1_trigger:IsPurgable() return false end
function modifier_Advanced_lunar_blessing_unlock1_trigger:IsPurgeException() return false end
function modifier_Advanced_lunar_blessing_unlock1_trigger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_lunar_blessing_unlock1_trigger:OnCreated(keys)
	if IsServer() then
		self.pos = StringToVector(keys.pos)
		self.caster = self:GetCaster()
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/lunar_blessing/unlock1/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self.pos )
		ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(300, 0, 0 ) )
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_lunar_blessing_unlock1_trigger:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end
function modifier_Advanced_lunar_blessing_unlock1_trigger:OnIntervalThink()

	if CalculateDistance(self.caster,self.pos)<=300 then
		self.caster:AddNewModifier(self.caster,self:GetAbility(),"modifier_Advanced_lunar_blessing_unlock1_buff",{duration = 60})
		self:SafeDestroy()
	end
end




modifier_Advanced_lunar_blessing_unlock1_buff = class({})

function modifier_Advanced_lunar_blessing_unlock1_buff:IsHidden()	return false end
function modifier_Advanced_lunar_blessing_unlock1_buff:IsDebuff()	return false end
function modifier_Advanced_lunar_blessing_unlock1_buff:IsPurgable()	return false end
function modifier_Advanced_lunar_blessing_unlock1_buff:IsPurgeException() return false end
function modifier_Advanced_lunar_blessing_unlock1_buff:OnCreated(params)
	self.tData = {}
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	self:StartIntervalThink(0.1)
	
	if IsServer() then
		self:GetAbility():ModifyUnlock1Bonus(1)
		self:PlayEffects( self:GetParent() )
		self:IncrementStackCount()
	end
end
function modifier_Advanced_lunar_blessing_unlock1_buff:OnRefresh(params)
	table.insert(self.tData, {dieTime =  self:GetDieTime() })
	
	if IsServer() then
		self:PlayEffects( self:GetParent() )
		self:GetAbility():ModifyUnlock1Bonus(1)
		self:IncrementStackCount()
	end
end

function modifier_Advanced_lunar_blessing_unlock1_buff:OnIntervalThink()
	local fGameTime = GameRules:GetGameTime()

	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].dieTime then
			table.remove(self.tData, i)
			
			if IsServer() then
				self:GetAbility():ModifyUnlock1Bonus(-1)
				self:DecrementStackCount()
			end
			
		end
	end

end


function modifier_Advanced_lunar_blessing_unlock1_buff:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Cast"
	local sound_target = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		6,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end



modifier_Advanced_lunar_blessing_unlock2_bonus_check = class({})

function modifier_Advanced_lunar_blessing_unlock2_bonus_check:IsHidden()	return true end
function modifier_Advanced_lunar_blessing_unlock2_bonus_check:IsDebuff()	return false end
function modifier_Advanced_lunar_blessing_unlock2_bonus_check:IsPurgable()	return false end
function modifier_Advanced_lunar_blessing_unlock2_bonus_check:IsPurgeException() return false end
function modifier_Advanced_lunar_blessing_unlock2_bonus_check:OnCreated(params)
	self:GetAbility():ModifyUnlock2Bonus(1)
end
function modifier_Advanced_lunar_blessing_unlock2_bonus_check:OnRefresh(params)
	self:GetAbility():ModifyUnlock2Bonus(1)
end
