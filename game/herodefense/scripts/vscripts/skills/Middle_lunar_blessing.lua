
Middle_lunar_blessing = class({})

LinkLuaModifier("modifier_Middle_lunar_blessing_passive", "skills/Middle_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_lunar_blessing_effect", "skills/Middle_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_lunar_blessing_active", "skills/Middle_lunar_blessing", LUA_MODIFIER_MOTION_NONE)

-- require('internal/timers')   --计时器功能
function Middle_lunar_blessing:CastFilterResult()
	-- check nohammer
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if  _G.GAME_CHANGING_TIME_OF_DAY or not Game_State:IsInBattle()  then
		return UF_FAIL_CUSTOM
	end
	if time<0.25 or time>0.75 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function Middle_lunar_blessing:GetCustomCastError()
	if IsClient() then
		return
	end
	local time = GameRules:GetTimeOfDay()
	if _G.GAME_CHANGING_TIME_OF_DAY then
		return "#dota_hud_still_chaghing"
	end
	if not Game_State:IsInBattle()  then
		return "dota_hud_not_in_battle"
	end
	if time<0.25 or time>0.75 then
		return "dota_hud_still_night"
	end
	return ""
end

-- function Middle_howl:Precache( context )
-- 	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
-- end
function Middle_lunar_blessing:OnSpellStart()

	local caster    =   self:GetCaster()

	caster:EmitSound("Hero_Luna.Eclipse.Cast")


	local particle_caster_ground_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN, caster)
	-- ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_caster_ground_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)




	local time = GameRules:GetTimeOfDay() --记录当前时间
	GameRules:SetTimeOfDay(0.75)  --强制黑夜
	local duration = 10
	caster:AddNewModifier(caster, self, "modifier_Middle_lunar_blessing_active", {duration = duration,time = time})
	-- _G.GAME_CHANGING_TIME_OF_DAY = true
	-- Timers:CreateTimer(duration, function()
	-- 	if _G.GAME_CHANGING_NIGHT_WORLD_RULE then  --返回强制黑夜关卡
	-- 		GameRules:SetTimeOfDay(-1)
	-- 	else  --说明当前不是强制黑夜关卡了 那么返回记录的过去时间
	-- 		GameRules:SetTimeOfDay(time)
	-- 	end
	-- 	_G.GAME_CHANGING_TIME_OF_DAY = false

	-- end)
end

function Middle_lunar_blessing:GetIntrinsicModifierName() return "modifier_Middle_lunar_blessing_passive" end

modifier_Middle_lunar_blessing_passive = advanced_modifier({})

function modifier_Middle_lunar_blessing_passive:IsHidden() return true end
function modifier_Middle_lunar_blessing_passive:IsAura() return not self:GetCaster():PassivesDisabled() end
function modifier_Middle_lunar_blessing_passive:GetAuraDuration() return 0.5 end
function modifier_Middle_lunar_blessing_passive:GetModifierAura() return "modifier_Middle_lunar_blessing_effect" end
function modifier_Middle_lunar_blessing_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_Middle_lunar_blessing_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_Middle_lunar_blessing_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_lunar_blessing_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO  end


function modifier_Middle_lunar_blessing_passive:Advanced_GetBonusNightVision()	
	return self:GetCaster():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("self_night_vision_bonus")
end

-- advanced_modifier
function modifier_Middle_lunar_blessing_passive:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION


    }
end



modifier_Middle_lunar_blessing_effect = class({})

function modifier_Middle_lunar_blessing_effect:IsDebuff()			return false end
function modifier_Middle_lunar_blessing_effect:IsHidden() 			return false end
function modifier_Middle_lunar_blessing_effect:IsPurgable() 			return false end
function modifier_Middle_lunar_blessing_effect:IsPurgeException() 	return false end
function modifier_Middle_lunar_blessing_effect:OnCreated(table)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	
end
function modifier_Middle_lunar_blessing_effect:OnRefresh()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_Middle_lunar_blessing_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,     


	}
end


function modifier_Middle_lunar_blessing_effect:GetModifierBaseAttack_BonusDamage()	
	if self:GetCaster():HasModifier("modifier_Middle_lunar_blessing_active") then
		return 2*self.bonus_damage  
	end
	return self.bonus_damage  
end


modifier_Middle_lunar_blessing_active = class({})

function modifier_Middle_lunar_blessing_active:IsDebuff() return false end
function modifier_Middle_lunar_blessing_active:IsHidden() return false end
function modifier_Middle_lunar_blessing_active:IsPurgable() return false end
function modifier_Middle_lunar_blessing_active:IsPurgeException() return false end
function modifier_Middle_lunar_blessing_active:OnCreated(keys) 
	if IsServer() then
		self.time = keys.time
		_G.GAME_CHANGING_TIME_OF_DAY = true
		
	end
end
function modifier_Middle_lunar_blessing_active:OnDestroy()
	if _G.GAME_CHANGING_NIGHT_WORLD_RULE then  --返回强制黑夜关卡
		GameRules:SetTimeOfDay(-1)
	else  --说明当前不是强制黑夜关卡了 那么返回记录的过去时间
		GameRules:SetTimeOfDay(self.time)
	end
	_G.GAME_CHANGING_TIME_OF_DAY = false
end