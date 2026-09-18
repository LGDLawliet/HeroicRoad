
Advanced_Soul_Link = class({})


LinkLuaModifier("modifier_Advanced_Soul_Link", "skills/Advanced_Soul_Link", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Soul_Link_effect", "skills/Advanced_Soul_Link", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Soul_Link_summoned", "skills/Advanced_Soul_Link", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Soul_Link_unlock3_buff", "skills/Advanced_Soul_Link", LUA_MODIFIER_MOTION_NONE)
function Advanced_Soul_Link:CheckKV(key)
	local table = {
		bonus_summon_intensity=0.8,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Soul_Link:UnlockFirstCore(key)
	return true
end
function Advanced_Soul_Link:UnlockSecondCore(key)
	return true
end
function Advanced_Soul_Link:UnlockThirdCore(key)
	return true
end
function Advanced_Soul_Link:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/soul_link/soul_buff/soul_move.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/soul_link/unlock1/link.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/soul_link/unlock2/ties_eclipse_area.vpcf", context )
	

	

end
function Advanced_Soul_Link:GetIntrinsicModifierName() return "modifier_Advanced_Soul_Link" end
function Advanced_Soul_Link:IsHiddenWhenStolen() 		return false end
function Advanced_Soul_Link:IsRefreshable() 			return true  end
function Advanced_Soul_Link:IsStealable() 			return true  end
function Advanced_Soul_Link:IsNetherWardStealable()	return true end
function Advanced_Soul_Link:SpecialEffect_Lifestealer(unit)
	unit:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Soul_Link_summoned", {count = 0})
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Soul_Link")
	if modifier then
		modifier:AddToList(unit)
	end
end





modifier_Advanced_Soul_Link= advanced_modifier({})

function modifier_Advanced_Soul_Link:IsDebuff()			return false end
function modifier_Advanced_Soul_Link:IsHidden() 			return self:GetStackCount()<1 end
function modifier_Advanced_Soul_Link:IsPurgable() 		return false end
function modifier_Advanced_Soul_Link:IsPurgeException() 	return false end
function modifier_Advanced_Soul_Link:IsAura() return true end
function modifier_Advanced_Soul_Link:GetAuraDuration() return 0.5 end
function modifier_Advanced_Soul_Link:GetModifierAura() return "modifier_Advanced_Soul_Link_effect" end
function modifier_Advanced_Soul_Link:GetAuraRadius() return self.advanced_level>=20 and 1500 or 0 end
function modifier_Advanced_Soul_Link:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Soul_Link:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Soul_Link:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO end
function modifier_Advanced_Soul_Link:GetAuraEntityReject(hEntity)

	if hEntity:GetPlayerOwner() ~= self:GetParent():GetPlayerOwner() then
		return true
	end
	if hEntity:IsRealHero() then
		if hEntity:HasModifier("modifier_heroTalent_npc_dota_hero_life_stealer_3_buff") and hEntity:HasModifier("modifier_Advanced_Soul_Link_summoned") then
		else
			return true
		end
	end
	return false
end


function modifier_Advanced_Soul_Link:OnCreated(keys)
    self.ability = self:GetAbility()
	self.summon_list = {}
	self.advanced_level = 1

	self.bonus_summon_int = self.ability:GetSpecialValueFor("bonus_summon_intensity")
    if IsServer() then
		self.summon_count = 0
		self.tData = {}
		self:StartIntervalThink(1)

	end
end
function modifier_Advanced_Soul_Link:OnIntervalThink()
	local ability = self:GetAbility()
	if ability.unlock1 then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end


		self:StartIntervalThink(0.1)
	else
		self.advanced_level = ability.advanced_level

	end
	
end


function modifier_Advanced_Soul_Link:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		
		local chance = 25
		--LV5解锁能量涌动
		if self.advanced_level>=5 then
			chance=40
		end

		if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100) then
			self.bonus_trigger = true
			local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_end.vpcf", PATTACH_ABSORIGIN, unit)
			local pos = unit:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 1, pos)
			ParticleManager:SetParticleControlForward(particle_cast_fx, 1,unit:GetForwardVector())  --方向
			ParticleManager:SetParticleControl(particle_cast_fx, 2, pos)
			ParticleManager:SetParticleControl(particle_cast_fx, 3, pos)
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		end
	end
end


--归置
function modifier_Advanced_Soul_Link:OnSummonUnitFinished(keys)
	if IsServer() then
		self.bonus_trigger = false
		self:AddToList(keys.target)
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Soul_Link_summoned", {count = self.summon_count})
		if self:GetAbility().unlock1 then
			local ability = keys.inflictor
			if ability and not ability:IsNull() then
				local time = ability:GetCooldown(ability:GetLevel())
				if time <= 1 then
					return
				end
				table.insert(self.tData, { dieTime = GameRules:GetGameTime()+time })
				self:IncrementStackCount()
				local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/soul_link/unlock1/link.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
				ParticleManager:SetParticleControlEnt( particle_cast_fx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex(particle_cast_fx)
			end
		end
	end
end


function modifier_Advanced_Soul_Link:DeclareFunctions() 
	return {MODIFIER_EVENT_ON_TAKEDAMAGE,} 
end
function modifier_Advanced_Soul_Link:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if not Target or Target ~= self:GetParent() then
			return 0
		end
		if Target:GetHealthPercent()>20 then
			return
		end
		local target

		for key, unit in pairs(self.summon_list) do
			if not unit:IsNull() and unit:IsAlive() and not unit:IsInvulnerable() then
				target = unit
			end
			
		end
		if target then
			local damage_index = 2.5
			--LV10解锁伤害迁移
			if self.advanced_level>=10 then
				damage_index = 1.7
			end
			local damageTable = {
				victim = target,
				attacker = Target,
				damage = flDamage*damage_index,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL +DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS  ,
				ability = Ability, --Optional.
			}
			ApplyDamage(damageTable)

			Target:SetHealth(Target:GetMaxHealth()*0.2+flDamage)
			local particle_cast = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
			local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  Target)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 0, Target, PATTACH_POINT_FOLLOW, "attach_hitloc", Target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_return_fx)
			--LV15解锁灵魂升华
			if self.advanced_level>=15 and not target:IsAlive() then
				local health = Target:GetMaxHealth()*0.1
				local healing = HealWithGain(health,Target,Target,self:GetAbility())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, Target, healing, nil)
				if self:GetAbility().unlock3 then
					local particle = ParticleManager:CreateParticle("particles/rebuild/spell/soul_link/soul_buff/soul_move.vpcf", PATTACH_POINT_FOLLOW, target)
					ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
					-- ParticleManager:SetParticleControl(particle, 1, Target:GetAbsOrigin())
					ParticleManager:SetParticleControlEnt(particle, 1, Target, PATTACH_POINT_FOLLOW, "attach_hitloc", Target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)

					local gain = Target:GetModifierDurationGainIndex(1)
					Target:AddNewModifier(
						Target,
						self:GetAbility(),
						"modifier_Advanced_Soul_Link_unlock3_buff",
						{	duration = 60*gain}
					)
				end
			end

		end

		

	end

	return 0.0

end


function modifier_Advanced_Soul_Link:AddToList(target)
	self.summon_list[target] = target
	self.summon_count = self.summon_count  +1 
	-- table.insert(self.summon_list,target)
end

function modifier_Advanced_Soul_Link:RemoveFromList(target)
	-- print("remove")
	self.summon_list[target] = nil
	self.summon_count = self.summon_count -1
	-- local a = IsInTableAndDel(target,self.summon_list)
	-- print("#list="..#self.summon_list)
	-- print(a)
end


-- advanced_modifier
function modifier_Advanced_Soul_Link:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_Advanced_Soul_Link:Advanced_GetModifier_Summon_Intensity(keys)
	if self.bonus_trigger then
		return self:GetAbility():GetSpecialValueFor("bonus_summon_intensity") *(1+self:GetStackCount()*0.01)*1.5
	end
	return self:GetAbility():GetSpecialValueFor("bonus_summon_intensity") *(1+self:GetStackCount()*0.01)
end







modifier_Advanced_Soul_Link_effect = advanced_modifier({})

function modifier_Advanced_Soul_Link_effect:IsDebuff() return false end
function modifier_Advanced_Soul_Link_effect:IsHidden() return false end
function modifier_Advanced_Soul_Link_effect:IsPurgable() return false end



function modifier_Advanced_Soul_Link_effect:Advanced_GetModifierIncomingDamage_Percentage()	return -20 end
-- function modifier_Advanced_Soul_Link_effect:GetModifierTotalDamageOutgoing_Percentage()	return 20 end


-- advanced_modifier
function modifier_Advanced_Soul_Link_effect:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

	return funcs

end
function modifier_Advanced_Soul_Link_effect:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 20
end





modifier_Advanced_Soul_Link_summoned = advanced_modifier ({})
function modifier_Advanced_Soul_Link_summoned:IsPurgable()	return false end
function modifier_Advanced_Soul_Link_summoned:IsHidden() return true end
function modifier_Advanced_Soul_Link_summoned:IsPurgeException() return false end
function modifier_Advanced_Soul_Link_summoned:IsDebuff() return false end
function modifier_Advanced_Soul_Link_summoned:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock2 then
			local parent = self:GetParent()
			local count = math.min(keys.count*300,13000)
			self:SetStackCount(count)
			self.reduce_per_second = count/20
			self.intervel = 0.2
			self:StartIntervalThink(self.intervel)
			local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/soul_link/unlock2/ties_eclipse_area.vpcf", PATTACH_ABSORIGIN, parent)
			local pos = parent:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
			ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(100,100,0))
			ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		end
		
	end
end
function modifier_Advanced_Soul_Link_summoned:OnIntervalThink()
	self:SetStackCount(self:GetStackCount()-self.reduce_per_second*self.intervel)
end


function modifier_Advanced_Soul_Link_summoned:Advanced_GetModifierIncomingDamage_Percentage()	return -self:GetStackCount()*0.01 end



function modifier_Advanced_Soul_Link_summoned:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_Advanced_Soul_Link")
		if modifier then
			modifier:RemoveFromList(self:GetParent())
		end
	end
end

function modifier_Advanced_Soul_Link_summoned:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end












modifier_Advanced_Soul_Link_unlock3_buff = class({})

function modifier_Advanced_Soul_Link_unlock3_buff:IsHidden()	return false end
function modifier_Advanced_Soul_Link_unlock3_buff:IsDebuff()	return false end
function modifier_Advanced_Soul_Link_unlock3_buff:IsPurgable()	return false end
function modifier_Advanced_Soul_Link_unlock3_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_Advanced_Soul_Link_unlock3_buff:GetModifierBonusStats_Strength()	return self:GetStackCount()*5 end
function modifier_Advanced_Soul_Link_unlock3_buff:GetModifierBonusStats_Agility()	return self:GetStackCount()*5 end
function modifier_Advanced_Soul_Link_unlock3_buff:GetModifierBonusStats_Intellect()	return self:GetStackCount()*5 end








function modifier_Advanced_Soul_Link_unlock3_buff:OnCreated(params)
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
function modifier_Advanced_Soul_Link_unlock3_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 50 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_Soul_Link_unlock3_buff:OnIntervalThink()
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


