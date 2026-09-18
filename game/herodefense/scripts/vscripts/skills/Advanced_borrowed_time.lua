--特效优化 √
LinkLuaModifier("modifier_Advanced_borrowed_time_handler", "skills/Advanced_borrowed_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_borrowed_time_buff_hot_caster", "skills/Advanced_borrowed_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_borrowed_time_debuff", "skills/Advanced_borrowed_time", LUA_MODIFIER_MOTION_NONE)
Advanced_borrowed_time = Advanced_borrowed_time or class({})
function Advanced_borrowed_time:CheckKV(key)
	local table = {
		duration = 0.2,




	}
	local value = table[key] or -1
	return value

end

function Advanced_borrowed_time:UnlockFirstCore(key)
	return true
end
function Advanced_borrowed_time:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_borrowed_time:UnlockThirdCore(key)

	return true
end





function Advanced_borrowed_time:GetIntrinsicModifierName()
	if self:GetCaster():IsRealHero() then
		return "modifier_Advanced_borrowed_time_handler"
	end
end
function Advanced_borrowed_time:GetCastRange()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if advanced_level>=5 then
		return 1100
	end
	return 700
end


function Advanced_borrowed_time:OnSpellStart(passive)
	-- if IsServer() then
		local caster = self:GetCaster()
		local buff_duration = self:GetSpecialValueFor("duration") 

		-- print(passive)
		if self.unlock3 and not passive then
			buff_duration = 1.5
			if caster:HasAbility("heroTalent_npc_dota_hero_abaddon_2") then
				buff_duration = buff_duration + 2*0.3
				caster:EmitSound("HeroTime")
			end
			self:EndCooldown()
			caster:AddNewModifier(caster, self, "modifier_Advanced_borrowed_time_buff_hot_caster", { duration = buff_duration,unlock3 = true })
		else
			if caster:HasAbility("heroTalent_npc_dota_hero_abaddon_2") then
				buff_duration = buff_duration + 2
				caster:EmitSound("HeroTime")
			end
			caster:AddNewModifier(caster, self, "modifier_Advanced_borrowed_time_buff_hot_caster", { duration = buff_duration })
		end
		
		caster:EmitSound("Hero_Abaddon.BorrowedTime")

	-- end
end

--自动施法
modifier_Advanced_borrowed_time_handler = modifier_Advanced_borrowed_time_handler or class({})
function modifier_Advanced_borrowed_time_handler:IsDebuff() return false end
function modifier_Advanced_borrowed_time_handler:IsHidden() return  false end
function modifier_Advanced_borrowed_time_handler:IsPurgable() 		return false end
function modifier_Advanced_borrowed_time_handler:IsPurgeException() 	return false end
function modifier_Advanced_borrowed_time_handler:RemoveOnDeath()  return false end
function modifier_Advanced_borrowed_time_handler:AllowIllusionDuplicate() return false end
function modifier_Advanced_borrowed_time_handler:DestroyOnExpire()	return false end
function modifier_Advanced_borrowed_time_handler:_CheckHealth(damage)
	local target = self:GetParent()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
	end

	-- Check state
	if not ability:IsHidden() and target:IsAlive() then
		local hp_threshold = target:GetMaxHealth()*0.15
		local current_hp = target:GetHealth()
		if current_hp <= hp_threshold then
			--LV15解锁触碰式开关
			if ability.advanced_level>=15  then
				if self:GetRemainingTime()>=0 then
					return
				end
				self:SetDuration(120, true)


				ability:OnSpellStart(true)
			else
				if not ability:IsCooldownReady() then
					return
				end
		
				ability:OnSpellStart(true)
				ability:UseResources(false, false, true,true)
				-- target:CastAbilityImmediately(ability, target:GetPlayerID())
			end

		end
	end
end

function modifier_Advanced_borrowed_time_handler:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		
		if target:IsIllusion() then
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_borrowed_time_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function modifier_Advanced_borrowed_time_handler:OnTakeDamage(kv)

	if IsServer() then
		local target = self:GetParent()

		if target == kv.unit then
			self:_CheckHealth(kv.damage)
		end
	end

end



modifier_Advanced_borrowed_time_buff_hot_caster = modifier_Advanced_borrowed_time_buff_hot_caster or advanced_modifier({})
function modifier_Advanced_borrowed_time_buff_hot_caster:IsDebuff() return false end
function modifier_Advanced_borrowed_time_buff_hot_caster:IsHidden() return false end
function modifier_Advanced_borrowed_time_buff_hot_caster:IsPurgable() return false end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW  end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_Advanced_borrowed_time_buff_hot_caster:StatusEffectPriority() return 10 end
function modifier_Advanced_borrowed_time_buff_hot_caster:IsAura() return true end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetAuraDuration() return 0.5 end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetModifierAura() return "modifier_Advanced_borrowed_time_debuff" end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetAuraRadius() return self.radius end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Advanced_borrowed_time_buff_hot_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
	if self:GetAbility():GetUnlock(1)==1 or self:GetAbility():GetUnlock(2)==2 then
		table.insert(funcs,MODIFIER_EVENT_ON_TAKEDAMAGE)
	end
	if IsServer() then
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"hero_time_1") then
			self.attachment_1 = true
		end
		if self:GetCaster():HasAbility("heroTalent_npc_dota_hero_abaddon_2") and not self.attachment_1  then
			-- 仅当剩余亚巴顿一个人时（必须有队友死亡）
			local alive = 0
			for _, unit in pairs(_G.GAME_HERO_GROUP) do
				if unit:IsAlive() then
					alive = alive +1
				end
			end
			if alive==1 then
				self.talentKillRecord = 0
				table.insert(funcs,MODIFIER_EVENT_ON_DEATH)
			end
		end
	end


	return funcs
end




function modifier_Advanced_borrowed_time_buff_hot_caster:OnCreated(keys)
	if IsServer() then
		local target = self:GetParent()
		target:Purge(false, true, false, true, false)
		self.radius = 700
		self.advanced_level = self:GetAbility().advanced_level
		self.hp_return = 0.3
		self.bonus_str = 0
		self.bonus_agi = 0
		self.bonus_int = 0
		--LV5解锁嘲弄之域+
		if self.advanced_level>=5 then
			self.radius=1100
		end
		--LV10解锁洗礼+
		if self.advanced_level>=10 then
			self.hp_return= 0.5
		end

		--LV20解锁主角光环
		if self.advanced_level>=20 then
			self.bonus_str =target:GetStrength()*0.5
			self.bonus_agi = target:GetAgility()*0.5
			self.bonus_int = target:GetIntellect(false)*0.5
		end

		if target:HasAbility("heroTalent_npc_dota_hero_abaddon_2") then
			local index = 0.55
			if self.attachment_1 then
				index = index +0.07				
			end
			local bonus = math.min(math.max(target:GetStrength()*index,80),400)
			self.bonus_str =self.bonus_str+bonus
			self.bonus_agi = self.bonus_agi+bonus
			self.bonus_int = self.bonus_int+bonus
		end

		if target:HasModifier("modifier_Advanced_mist_coil_unlock1") then
			self.mist_ability = target:FindAbilityByName("Advanced_mist_coil")
			self.damage_count = 0
			self.timer = GameRules:GetGameTime()
		end

		self.borrowed_unlock1 = {}
		self.borrowed_unlock1_time = {}
		if keys.unlock3 then
			self:GetAbility():SetActivated(false)
			self.unlock3 = true
		end
	end
end
function modifier_Advanced_borrowed_time_buff_hot_caster:OnDestroy()
	if IsServer() then
		if self.unlock3 then
			local ability = self:GetAbility()
			ability:SetActivated(true)
			ability:StartCooldown(4)
		end
		if self.talentKillRecord and self.talentKillRecord>=20 then
			local ability = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_abaddon_2")
			if ability then
				ability:Unlockachievement()
			end
		end
	end
end


function modifier_Advanced_borrowed_time_buff_hot_caster:Advanced_GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		-- Ability properties
		local target 	= self:GetParent()
		if kv.damage<=0 then
			return
		end
		if not self.hp_return then  --不知道为啥会变成nil
			return
		end
		-- Show borrowed time heal particle
		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local target_vector = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
		ParticleManager:ReleaseParticleIndex(heal_particle)


		target:Heal(kv.damage, target)

		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		for _, unit in pairs(units) do
			if unit:GetHealthPercent()<=97 then
				HealWithGain(kv.damage*self.hp_return,target,unit,self:GetAbility())
				local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				local unit_vector = unit:GetAbsOrigin()
				ParticleManager:SetParticleControl(heal_particle, 0, unit_vector)
				ParticleManager:SetParticleControl(heal_particle, 1, unit_vector)
				ParticleManager:ReleaseParticleIndex(heal_particle)
				break
			end
		end


		if self.mist_ability  and not self.mist_ability:IsNull()  then
			self.damage_count = self.damage_count  +kv.damage
			if  self.damage_count>=target:GetMaxHealth()*0.05 and GameRules:GetGameTime()>=self.timer then
				self.damage_count = 0
				self.timer =  GameRules:GetGameTime() +0.4
				target:SetCursorCastTarget(kv.attacker)
				self.mist_ability:OnSpellStart()
			end
		end

		
		return -1000
	end
end


function modifier_Advanced_borrowed_time_buff_hot_caster:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_Advanced_borrowed_time_buff_hot_caster:GetModifierBonusStats_Agility()	return self.bonus_agi end

function modifier_Advanced_borrowed_time_buff_hot_caster:OnTakeDamage(keys)

	if IsServer() then
		local caster = self:GetParent()

		local self_ability = self:GetAbility()
		if caster ~= keys.unit and not IsEnemy(caster,keys.unit) then
			if self_ability.unlock1 then
				if not self.borrowed_unlock1[keys.unit] then
					self.borrowed_unlock1[keys.unit] = 0
				end
				self.borrowed_unlock1[keys.unit] = self.borrowed_unlock1[keys.unit] + keys.damage
				if self.borrowed_unlock1[keys.unit]>=keys.unit:GetMaxHealth()*0.1 then
					if not self.borrowed_unlock1_time[keys.unit] then
						self.borrowed_unlock1_time[keys.unit] = GameRules:GetGameTime()
					end
					if self.borrowed_unlock1_time[keys.unit]>GameRules:GetGameTime() then
						return
					end
					self.borrowed_unlock1_time[keys.unit] = GameRules:GetGameTime()+0.2
					self.borrowed_unlock1[keys.unit]  = 0
					local ability = caster:FindAbilityByName("Advanced_mist_coil")
					if ability then
						ability:CastToASingleTarget(keys.unit)
					end
	
				end
			elseif self_ability.unlock2 and keys.unit:IsRealHero() then
				if not self.borrowed_unlock1[keys.unit] then
					self.borrowed_unlock1[keys.unit] = 0
				end
				self.borrowed_unlock1[keys.unit] = self.borrowed_unlock1[keys.unit] + keys.damage
				if self.borrowed_unlock1[keys.unit]>=keys.unit:GetMaxHealth()*0.1 then
					if not self.borrowed_unlock1_time[keys.unit] then
						self.borrowed_unlock1_time[keys.unit] = GameRules:GetGameTime()
					end
					if self.borrowed_unlock1_time[keys.unit]>GameRules:GetGameTime() then
						return
					end
					self.borrowed_unlock1_time[keys.unit] = GameRules:GetGameTime()+0.1
					self.borrowed_unlock1[keys.unit]  = 0
					local ability = caster:FindAbilityByName("Advanced_mist_coil")
					if ability then
						local units = FindUnitsInRadius(
							caster:GetTeamNumber(),	-- int, your team number
							keys.unit:GetOrigin(),	-- point, center point
							nil,	-- handle, cacheUnit. (not known)
							1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
							DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
							0,	-- int, flag filter
							FIND_CLOSEST ,	-- int, order filter
							false	-- bool, can grow cache
						)
						for i, unit in ipairs(units) do
							ability:CastToASingleTarget(unit)
							if i>=2 then
								break
							end
							
						end
					
					end
	
				end
			end
		
		end
	end

end




function modifier_Advanced_borrowed_time_buff_hot_caster:OnDeath(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
    if attacker and  attacker == self:GetParent() then
		if IsEnemy(attacker,keys.unit) then
			self.talentKillRecord = self.talentKillRecord + 1
		end
    end
end

function modifier_Advanced_borrowed_time_buff_hot_caster:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



modifier_Advanced_borrowed_time_debuff = class({})

function modifier_Advanced_borrowed_time_debuff:IsDebuff()				return true end
function modifier_Advanced_borrowed_time_debuff:IsHidden() 			return true end
function modifier_Advanced_borrowed_time_debuff:IsPurgable() 			return true end
-- function modifier_Advanced_borrowed_time_debuff:IsPurgeException() 	return true end

function modifier_Advanced_borrowed_time_debuff:OnCreated( kv )
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end
	
	self:StartIntervalThink(1)
end

function modifier_Advanced_borrowed_time_debuff:OnRemoved()
	if not IsServer() then
		return
	end
	self:GetParent():Stop()
end

function modifier_Advanced_borrowed_time_debuff:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():Stop()
end
function modifier_Advanced_borrowed_time_debuff:OnIntervalThink( kv )
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end
	 
end