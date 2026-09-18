LinkLuaModifier( "modifier_supreme_spell_nevermore_basic", "creeps_spell/supreme_spell_nevermore_basic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_basic_check", "creeps_spell/supreme_spell_nevermore_basic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_basic_p0", "creeps_spell/supreme_spell_nevermore_basic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_basic_end", "creeps_spell/supreme_spell_nevermore_basic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_basic_during", "creeps_spell/supreme_spell_nevermore_basic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_basic_end_check", "creeps_spell/supreme_spell_nevermore_basic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_basic", "creeps_spell/supreme_spell_nevermore_basic.lua", LUA_MODIFIER_MOTION_NONE )

supreme_spell_nevermore_basic = class({})

function supreme_spell_nevermore_basic:GetIntrinsicModifierName()
	return "modifier_supreme_spell_nevermore_basic"
end

function supreme_spell_nevermore_basic:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/sf/final_end.vpcf", context )
    --PrecacheResource( "particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect.vpcf", context )
    --PrecacheResource( "particle", "particles/rebuild/spell/chronoshere/effect2/faceless_void_chronosphere.vpcf", context )
    --PrecacheResource( "particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect_purple.vpcf", context )
end
---------------------------------------------------------------------

modifier_supreme_spell_nevermore_basic = advanced_modifier({})
function modifier_supreme_spell_nevermore_basic:IsDebuff() return false end
function modifier_supreme_spell_nevermore_basic:IsHidden() return true end
function modifier_supreme_spell_nevermore_basic:IsPurgable() return false end

function modifier_supreme_spell_nevermore_basic:OnCreated(params)
	self.cd = self:GetAbility():GetSpecialValueFor("all_limit_time")
	self.duration = self:GetAbility():GetSpecialValueFor("start_duration")
	self.each = self:GetAbility():GetSpecialValueFor("each_time_left")
	if IsServer() then
		local heroes = GetAllRealHeroes()
		if #heroes >= 2 then
			self.cd = self.cd - (#heroes-1)*self.each
		end
		self:GetCaster():GameTimer(0.05,function ()
			self:GetAbility():StartCooldown(self.cd)
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_supreme_spell_nevermore_basic_check",{duration = self.cd})
			-- 开场瞬移到中心
			self:GetCaster():SetOrigin(Vector(-300,-1053,64))
			self:GetCaster():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
			-- 开场aoe，设置半血，并添加检测血量回复modifier和自身的无敌modifier
			local caster = self:GetCaster()
			local effect_name = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
			local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleShouldCheckFoW( effect_cast,false )
			ParticleManager:SetParticleControl(effect_cast,0,Vector(-300,-1053,64))
			ParticleManager:ReleaseParticleIndex(effect_cast)

			local effect_name2 = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
			local effect_cast2 = ParticleManager:CreateParticle( effect_name2, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleShouldCheckFoW( effect_cast2,false )
			ParticleManager:SetParticleControl(effect_cast2,0,Vector(-300,-1053,64))
			ParticleManager:ReleaseParticleIndex(effect_cast2)
		
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 100000,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE , FIND_ANY_ORDER, false )
			for _,enemy in pairs(enemies)do
				caster:AddNewModifier(caster,self:GetAbility(),"modifier_invulnerable",{duration = self.duration})
				caster:AddNewModifier(caster,self:GetAbility(),"modifier_disarmed",{duration = 3})
				enemy:SetHealth(1)
				enemy:AddNewModifier(caster,self:GetAbility(),"modifier_supreme_spell_nevermore_basic_p0",{duration = self.duration})
				enemy:AddNewModifier(caster,self:GetAbility(),"modifier_stunned",{duration = 0.5})
				if not enemy:IsRealHero() then
					enemy:ForceKill(false)
				end
			end

		end)
		self:StartIntervalThink(1)
	end
end

function modifier_supreme_spell_nevermore_basic:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() then
		
		if not self:GetCaster():FindModifierByName("modifier_supreme_spell_nevermore_basic_end") then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_supreme_spell_nevermore_basic_end",{})
		end
		if not self:GetCaster():FindModifierByName("modifier_supreme_spell_nevermore_basic_during") then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_supreme_spell_nevermore_basic_during",{duration = 3})
		end
	end
	if self.nFXIndex == nil then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) -- 特效4：红光
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end

---------------------------------------------------------------------

modifier_supreme_spell_nevermore_basic_end = advanced_modifier({})
function modifier_supreme_spell_nevermore_basic_end:IsDebuff() return false end
function modifier_supreme_spell_nevermore_basic_end:IsHidden() return true end
function modifier_supreme_spell_nevermore_basic_end:IsPurgable() return false end
function modifier_supreme_spell_nevermore_basic_end:RemoveOnDeath() return true end

function modifier_supreme_spell_nevermore_basic_end:OnCreated(params)
	self.end_channel_time = self:GetAbility():GetSpecialValueFor("end_channel_time")
	local caster = self:GetCaster()
	if IsServer() then
		self:GetCaster():GameTimer(0.05,function ()
			local modifier = self:GetCaster():FindModifierByName("modifier_supreme_spell_nevermore_normal_last")
			if modifier then
				modifier:StartIntervalThink(-1)
			end
			self:GetCaster():SetOrigin(Vector(-300,-1053,64))
			self:GetCaster():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
			-- 开始10秒倒计时
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_supreme_spell_nevermore_basic_end_check",{duration = self.end_channel_time})
			self:GetCaster():GameTimer(self.end_channel_time,function ()
				local effect_name = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
				local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
				ParticleManager:SetParticleShouldCheckFoW(effect_cast,false )
				ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
				ParticleManager:ReleaseParticleIndex(effect_cast)
				self:StartIntervalThink(3)
			end)
		end)
	end
end

function modifier_supreme_spell_nevermore_basic_end:OnIntervalThink()
	local caster = self:GetCaster()

	local effect_name = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
	local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleShouldCheckFoW( effect_cast,false )
	ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 100000,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE , FIND_ANY_ORDER, false )
	local damage = 9999999
	for _,enemy in pairs(enemies)do
		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			--damage = ,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
			hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY,
		}

		self.damageTable.damage = damage

		ApplyDamage(self.damageTable)
		if enemy:IsAlive() then
			enemy:ForceKill(false)
		end
	end
end
-----------------------------------------------------------------------
modifier_supreme_spell_nevermore_basic_during = advanced_modifier({})

function modifier_supreme_spell_nevermore_basic_during:IsHidden()	return true end
function modifier_supreme_spell_nevermore_basic_during:IsDebuff()	return true end
function modifier_supreme_spell_nevermore_basic_during:RemoveOnDeath()	return true end
function modifier_supreme_spell_nevermore_basic_during:IsPurgable()	return false end
function modifier_supreme_spell_nevermore_basic_during:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_supreme_spell_nevermore_basic_during:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_supreme_spell_nevermore_basic_during:GetOverrideAnimationRate( params )
	return 0.7
end

function modifier_supreme_spell_nevermore_basic_during:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_6
end

-----------------------------------------------------------------------
modifier_supreme_spell_nevermore_basic_check = advanced_modifier({})

function modifier_supreme_spell_nevermore_basic_check:IsHidden()	return false end
function modifier_supreme_spell_nevermore_basic_check:IsDebuff()	return false end
function modifier_supreme_spell_nevermore_basic_check:RemoveOnDeath()	return true end
function modifier_supreme_spell_nevermore_basic_check:IsPurgable()	return false end
-----------------------------------------------------------------------
modifier_supreme_spell_nevermore_basic_end_check = advanced_modifier({})

function modifier_supreme_spell_nevermore_basic_end_check:IsHidden()	return false end
function modifier_supreme_spell_nevermore_basic_end_check:IsDebuff()	return false end
function modifier_supreme_spell_nevermore_basic_end_check:RemoveOnDeath()	return true end
function modifier_supreme_spell_nevermore_basic_end_check:IsPurgable()	return false end

-----------------------------------------------------------------------
modifier_supreme_spell_nevermore_basic_p0 = advanced_modifier({})

function modifier_supreme_spell_nevermore_basic_p0:IsHidden()	return false end
function modifier_supreme_spell_nevermore_basic_p0:IsDebuff()	return true end
function modifier_supreme_spell_nevermore_basic_p0:RemoveOnDeath()	return false end
function modifier_supreme_spell_nevermore_basic_p0:IsPurgable()	return false end
function modifier_supreme_spell_nevermore_basic_p0:OnCreated(table)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_supreme_spell_nevermore_basic_p0:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local inv = caster:FindModifierByName("modifier_invulnerable")
	if inv then
		if inv:GetRemainingTime() > self:GetAbility():GetSpecialValueFor("each_bingo") then
			inv:SetDuration(inv:GetRemainingTime() - self:GetAbility():GetSpecialValueFor("each_bingo"),true)
		else
			inv:Destroy()
		end
	end
end
function modifier_supreme_spell_nevermore_basic_p0:OnIntervalThink()

	if self:GetParent():GetHealthPercent() >= 99 then
		self:Destroy()
	end
end
function modifier_supreme_spell_nevermore_basic_p0:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_LifeSteal_Disable,
		advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
	}
end	
function modifier_supreme_spell_nevermore_basic_p0:Advanced_GetModifier_LifeSteal_Intensity()
	return -999999
end
function modifier_supreme_spell_nevermore_basic_p0:Advanced_GetModifier_LifeSteal_Disable()
	return 1
end