
LinkLuaModifier( "modifier_Advanced_summons_undead_jack_the_ripper_buff", "skills/Advanced_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_undead_jack_the_ripper_buff_attack", "skills/Advanced_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_undead_jack_the_ripper_debuff", "skills/Advanced_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_undead_jack_the_ripper_unlock1", "skills/Advanced_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_undead_jack_the_ripper_unlock2", "skills/Advanced_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect", "skills/Advanced_summons_undead_jack_the_ripper", LUA_MODIFIER_MOTION_NONE )
Advanced_summons_undead_jack_the_ripper						= Advanced_summons_undead_jack_the_ripper or class({})
-- require("internal/timers")


function Advanced_summons_undead_jack_the_ripper:IsSummonSpell()return true end


function Advanced_summons_undead_jack_the_ripper:CheckKV(key)
	local table = {
		bonus_damage=3,
		bonus_health=1.5,

	}
	local value = table[key] or -1
	return value

end


function Advanced_summons_undead_jack_the_ripper:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step_dmg_blood.vpcf", context )

end


function Advanced_summons_undead_jack_the_ripper:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	self.unlock1_bonus = 0
	return true
end
function Advanced_summons_undead_jack_the_ripper:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_summons_undead_jack_the_ripper:UnlockThirdCore(key)

	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_earth_spirit" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true

end
function Advanced_summons_undead_jack_the_ripper:Unlock1AddStack()
	self.unlock1_bonus = math.min(self.unlock1_bonus + 3,1500)
end

function Advanced_summons_undead_jack_the_ripper:OnSpellStart()

	
	local caster =self:GetCaster()



	if not self.summon_table then
		self.summon_table = {}
	end
	for _, unit in ipairs(self.summon_table) do
		if IsValidEntity(unit) then
			unit:ForceKill(false)	
		end
	end
	

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage_index = caster:GetBaseDamageMax()
	if self.advanced_level>=20 then
		damage_index = caster:GetAverageTrueAttackDamage(nil)*0.3+damage_index*0.7
	end
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * damage_index

	if self.unlock3 then
		local health = caster:GetHealth()*0.5
		caster:SetHealth(health+1)
		damage =  math.min(self:GetSpecialValueFor("bonus_damage")*0.01 *caster:GetAverageTrueAttackDamage(nil),health*1.5)
		local count = 20
		Timers(FrameTime(), function()
			local infest_particle = ParticleManager:CreateParticle("particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step_dmg_blood.vpcf", PATTACH_POINT, caster)
			ParticleManager:SetParticleControlEnt(infest_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(infest_particle)
			count = count - 1
			if count>0 then
				return FrameTime()
			end
			
		end)
	
	end
	

	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local unit = caster:SummonUnit("npc_hd_jack_the_ripper",life_duration,
	unit_pos,
	self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	-- Add spawn particles in spawn location
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	ParticleManager:SetParticleControlEnt(infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	caster:EmitSound("Hero_LifeStealer.Consume")
    local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW,  unit)
    ParticleManager:ReleaseParticleIndex(infest_particle)
 

	unit:AddNewModifier(caster, self, "modifier_Advanced_summons_undead_jack_the_ripper_buff", {})
	if self.unlock1 then
		local modifier = unit:AddNewModifier(caster, self, "modifier_Advanced_summons_undead_jack_the_ripper_unlock1", {})
		if modifier then
			modifier:SetStackCount(self.unlock1_bonus)
		end
		
	end
	if self.unlock2 then
		local modifier = unit:AddNewModifier(caster, self, "modifier_Advanced_summons_undead_jack_the_ripper_unlock2", {})
	end
	if not caster:HasModifier("modifier_Advanced_rage_unlock3") then
		table.insert(self.summon_table,unit)
	end
	
end




modifier_Advanced_summons_undead_jack_the_ripper_buff = class({})

function modifier_Advanced_summons_undead_jack_the_ripper_buff:IsDebuff() return false end
function modifier_Advanced_summons_undead_jack_the_ripper_buff:IsHidden() return false end
function modifier_Advanced_summons_undead_jack_the_ripper_buff:IsPurgable() 		return false end
function modifier_Advanced_summons_undead_jack_the_ripper_buff:IsPurgeException() 	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_buff:RemoveOnDeath()  return false end
function modifier_Advanced_summons_undead_jack_the_ripper_buff:OnCreated(keys)
	if IsServer() then
		self.lifesteal_count = 0
		self.health_needed_index = 0.7
		self.attack_speed_index = 1
		self.advanced_level = self:GetAbility().advanced_level
		if self.advanced_level>=5 then
			self.attack_speed_index = 0.5
			if self.advanced_level>=10 then
				self.health_needed_index = 0.4
			end
		end

	end
end
function modifier_Advanced_summons_undead_jack_the_ripper_buff:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
	}
end


function modifier_Advanced_summons_undead_jack_the_ripper_buff:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
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
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * 0.1*gain
		self.lifesteal_count = self.lifesteal_count +flLifesteal
		local health_needed = Attacker:GetAverageTrueAttackDamage(nil)*self.health_needed_index
		if health_needed>0 and self.lifesteal_count>=health_needed then
			self.lifesteal_count = self.lifesteal_count - health_needed
			self:SetStackCount(math.min(self:GetStackCount()+1,20))
		end

		if self:GetParent():GetHealthPercent()>=100 then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		

		Attacker:Heal( flLifesteal, self:GetAbility() )
	end

	return 0.0

end



function modifier_Advanced_summons_undead_jack_the_ripper_buff:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	--self:GetParent():IsIllusion()
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() then
		return
	end


	local stack =100- keys.target:GetHealthPercent()*self.attack_speed_index
	keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_summons_undead_jack_the_ripper_buff_attack", {duration = 1,stack = stack})
	if self.advanced_level>=15 then
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_summons_undead_jack_the_ripper_debuff", {duration = 5})
	end
end




function modifier_Advanced_summons_undead_jack_the_ripper_buff:GetModifierBaseDamageOutgoing_Percentage()	return self:GetStackCount()*5 end


modifier_Advanced_summons_undead_jack_the_ripper_buff_attack = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_summons_undead_jack_the_ripper_buff_attack:IsHidden()	return true end
function modifier_Advanced_summons_undead_jack_the_ripper_buff_attack:IsDebuff()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_buff_attack:IsPurgable()	return false end

function modifier_Advanced_summons_undead_jack_the_ripper_buff_attack:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_Advanced_summons_undead_jack_the_ripper_buff_attack:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_Advanced_summons_undead_jack_the_ripper_buff_attack:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }

	return funcs

end

function modifier_Advanced_summons_undead_jack_the_ripper_buff_attack:Advanced_GetModifierAttackSpeedPercentage()	return self:GetStackCount() end












modifier_Advanced_summons_undead_jack_the_ripper_debuff =modifier_Advanced_summons_undead_jack_the_ripper_debuff or class({})

function modifier_Advanced_summons_undead_jack_the_ripper_debuff:IsHidden()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_debuff:IsDebuff()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_debuff:IsPurgable()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_debuff:IsPurgeException() return false end
function modifier_Advanced_summons_undead_jack_the_ripper_debuff:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	}
end


function modifier_Advanced_summons_undead_jack_the_ripper_debuff:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage
		if Target~=self:GetParent() then
			return
		end
		if not Attacker then
			return
		end
		if Attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() or Target == nil then
			return 0
		end
		if params.damage_category~=1 then
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



		if Attacker:GetHealthPercent()>=100 then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		local lifeSteal = self:GetStackCount()*0.01
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * lifeSteal*gain

		Attacker:Heal( flLifesteal, self:GetAbility() )
	end

	return 0.0

end




function modifier_Advanced_summons_undead_jack_the_ripper_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_summons_undead_jack_the_ripper_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		
		-- if self:GetStackCount()>= (10+_G.GAME_ROUND*4) then
		-- 	--移除第一个 添加一个
		-- 	table.remove(self.tData, 1)
		-- 	table.insert(self.tData, {dieTime = dieTime })

		-- else
		-- 	--当叠加乘数没达到最高时
		-- 	table.insert(self.tData, {dieTime = dieTime })
		-- 	self:IncrementStackCount()
		-- end
	end
end

function modifier_Advanced_summons_undead_jack_the_ripper_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end





modifier_Advanced_summons_undead_jack_the_ripper_unlock1 =modifier_Advanced_summons_undead_jack_the_ripper_unlock1 or class({})

function modifier_Advanced_summons_undead_jack_the_ripper_unlock1:IsHidden()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock1:IsDebuff()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock1:IsPurgable()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock1:IsPurgeException() return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock1:GetModifierAttackSpeedBonus_Constant()	return self:GetStackCount() end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock1:OnDeath(keys)
    if not IsServer() then
        return
    end
	
	if keys.attacker==self:GetParent() and IsEnemy(keys.unit, keys.attacker) then
		local ability = self:GetAbility()
		if ability then
			ability:Unlock1AddStack()
			self:SetStackCount(self:GetStackCount()+10)
			local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, keys.attacker:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( effect_cast )
			local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
			ParticleManager:ReleaseParticleIndex( effect_cast )
			keys.attacker:EmitSound("hero_bloodseeker.bloodRite")
	
		end
		
	end

end








modifier_Advanced_summons_undead_jack_the_ripper_unlock2 =modifier_Advanced_summons_undead_jack_the_ripper_unlock2 or class({})

function modifier_Advanced_summons_undead_jack_the_ripper_unlock2:IsHidden()	return true end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2:IsDebuff()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2:IsPurgable()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2:IsPurgeException() return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2:OnDeath(keys)
    if not IsServer() then
        return
    end

	if keys.attacker==self:GetParent() and IsEnemy(keys.unit, keys.attacker) then
		if keys.attacker:HasModifier("modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect") then
			return
		end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),  self:GetParent():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in ipairs(enemies) do
			if unit~=keys.unit then
				keys.attacker:EmitSound("Hero_LifeStealer.Infest")
				local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, unit)
				ParticleManager:SetParticleControl(infest_particle, 0, keys.attacker:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(infest_particle)
				local infest_modifier = keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect", 
				{
					duration =3,
					target_ent = unit:entindex(),
				})
				break
			end

		end
	end

end



modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect = class ({})
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect:IsHidden() return true end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect:IsPurgable()	return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect:IsPurgeException() return false end
function modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect:OnCreated(params)

	if not IsServer() then return end
	self:GetParent():AddNoDraw()
	self.target	= EntIndexToHScript(params.target_ent)
	self.timer = GameRules:GetGameTime()
	self:StartIntervalThink(FrameTime())
end

function modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect:OnIntervalThink()
	if not self.target then
		self:SafeDestroy()
		return
	end
	if self.target:IsNull() then
		self:SafeDestroy()
		return
	end
	if not self.target:IsAlive() then
		self:SafeDestroy()
		return
	end
	local parent = self:GetParent()
	parent:SetAbsOrigin(self.target:GetAbsOrigin())
	if GameRules:GetGameTime()>=self.timer then
		self.timer = GameRules:GetGameTime()+parent:GetSecondsPerAttack(false)
		parent:PerformAttack(self.target, true, true, true, true, true, false, false)
	end
	
end

function modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect:OnDestroy()
	if not IsServer() then return end

    self:GetParent():EmitSound("Hero_LifeStealer.Consume")
    local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:ReleaseParticleIndex(infest_particle)
    self:GetParent():StartGesture(ACT_DOTA_SPAWN)
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),  self:GetParent():GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    local damage = self:GetParent():GetAverageTrueAttackDamage(nil)*2
	for _, enemy in pairs(enemies) do
        local damageTable = {
            victim 			= enemy,
            damage 			= damage,
            damage_type		= DAMAGE_TYPE_PHYSICAL,
            damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
            attacker 		= self:GetCaster(),
            ability 		= self:GetAbility()
        }

        ApplyDamage(damageTable)
    end
    
    FindClearSpaceForUnit(self:GetParent(),  self:GetParent():GetAbsOrigin(), false)
	
	self:GetParent():RemoveNoDraw()

end




function modifier_Advanced_summons_undead_jack_the_ripper_unlock2_effect:CheckState(keys)
	if not IsServer() then return end
	local state = {
		[MODIFIER_STATE_INVULNERABLE] 						= true,
		-- [MODIFIER_STATE_OUT_OF_GAME]						= true,
		[MODIFIER_STATE_DISARMED]							= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_UNSELECTABLE]						= true,
		[MODIFIER_STATE_SILENCED]						= true,
		[MODIFIER_STATE_MUTED]						= true,
	}
	return state
end
