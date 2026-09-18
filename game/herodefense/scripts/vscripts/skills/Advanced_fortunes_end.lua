--特效优化 √
Advanced_fortunes_end = class({})

LinkLuaModifier("modifier_Advanced_fortunes_end_cast_timer", "skills/Advanced_fortunes_end", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fortunes_end_debuff", "skills/Advanced_fortunes_end", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fortunes_end_buff", "skills/Advanced_fortunes_end", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fortunes_end_unlock1_effect", "skills/Advanced_fortunes_end", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fortunes_end_unlock2", "skills/Advanced_fortunes_end", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_fortunes_end_unlock3", "skills/Advanced_fortunes_end", LUA_MODIFIER_MOTION_NONE)



require('internal/timers')   --计时器功能
function Advanced_fortunes_end:IsHiddenWhenStolen() 		return false end
function Advanced_fortunes_end:IsRefreshable() 			return true end
function Advanced_fortunes_end:IsStealable() 			return true end
function Advanced_fortunes_end:IsNetherWardStealable()	return true end
function Advanced_fortunes_end:GetAOERadius() return self:GetSpecialValueFor("radius") end

function Advanced_fortunes_end:CheckKV(key)
	local table = {


		basic_damage = 15,
		bonus_damage =0.1,


	}
	local value = table[key] or -1
	return value

end



function Advanced_fortunes_end:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_fortunes_end:UnlockSecondCore(key)
	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	if #heroes<=1 then
		self.CoreUnlock = false
		self.unlock2 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	
	caster:AddNewModifier(caster,self,"modifier_Advanced_fortunes_end_unlock2",{})
	return true
end
function Advanced_fortunes_end:UnlockThirdCore(key)
	local caster = self:GetCaster()
	
	if _G.Fortunes_end_unlock3 or caster:GetUnitName()~="npc_dota_hero_oracle" then
		self.CoreUnlock = false
		self.unlock3 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	self.totalcost = 0
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fortunes_end_unlock3",{})
	_G.Fortunes_end_unlock3 = true
	return true

end



function Advanced_fortunes_end:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+ DOTA_ABILITY_BEHAVIOR_AOE+ DOTA_ABILITY_BEHAVIOR_CHANNELLED+DOTA_ABILITY_BEHAVIOR_AUTOCAST
	
		elseif coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end

	return self.BaseClass.GetBehavior(self)
end









function Advanced_fortunes_end:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:EmitSound("Hero_Oracle.FortunesEnd.Channel")
	caster:RemoveModifierByName("modifier_Advanced_fortunes_end_cast_timer")
	caster:AddNewModifier(caster, self, "modifier_Advanced_fortunes_end_cast_timer", {})
	self.channeltime = self:GetChannelTime()
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_cast_tgt.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN, nil, target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
end
function Advanced_fortunes_end:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end
function Advanced_fortunes_end:OnChannelFinish(bInterrupted)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster:StopSound("Hero_Oracle.FortunesEnd.Channel")
	local buff = caster:FindModifierByName("modifier_Advanced_fortunes_end_cast_timer")
	if not buff then
		return
	end
	local time = buff:GetElapsedTime() / self.channeltime
	caster:RemoveModifierByName("modifier_Advanced_fortunes_end_cast_timer")
	local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	sound:EmitSound("Hero_Oracle.FortunesEnd.Attack")
	sound = sound:entindex()
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",
		iMoveSpeed = 1000,
		iSourceAttach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {time = time, sound = sound},	
	}
	ProjectileManager:CreateTrackingProjectile(info)

	--LV10解锁快速施法+
	if self.advanced_level>=10 and self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
			Timers:CreateTimer(0.5, function()
				ProjectileManager:CreateTrackingProjectile(info)
		end)
	end
end

function Advanced_fortunes_end:OnProjectileThink_ExtraData(pos, keys)
	local sound = EntIndexToHScript(keys.sound)
	if IsValid(sound) then
		EntIndexToHScript(keys.sound):SetOrigin(pos)
	end
	
end

function Advanced_fortunes_end:OnProjectileHit_ExtraData(target, pos, keys)
	local caster = self:GetCaster()
	if keys.index then --unlock2 effect
		local heroes = GetAllRealHeroes()
		local index = keys.index+1
		if index>#heroes then
			index = 1
		end
		local delay = 2
		if target then
			local dis = CalculateDistance(heroes[index],target)
			delay = math.max(delay - dis/10000,0.1)
		end
		Timers:CreateTimer(delay, function()
			local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
			sound:EmitSound("Hero_Oracle.FortunesEnd.Attack")
			sound = sound:entindex()
			local info = 
			{
				Target = heroes[index],
				Source = target or caster,
				Ability = self,	
				EffectName = "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",
				iMoveSpeed = math.max(heroes[index]:GetMoveSpeedModifier(heroes[index]:GetBaseMoveSpeed(), true),1500),
				iSourceAttach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 10,
				bProvidesVision = false,
				ExtraData = {time = 2.5, sound = sound,index =index},	
			}
			ProjectileManager:CreateTrackingProjectile(info)
		end)
		
		
	end


	if not target or (target and target:TriggerStandardTargetSpell(self)) then
		UTIL_Remove(EntIndexToHScript(keys.sound))
		return
	end
	target:EmitSound("Hero_Oracle.FortunesEnd.Target")
	local duration = 2.5
	local radius = self:GetSpecialValueFor("radius")
	local pfx_aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_aoe, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_aoe, 2, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(pfx_aoe)
	local unit = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damagetable = {
		attacker = caster,
		ability = self,
		damage = self:GetSpecialValueFor("basic_damage")+caster:GetIntellect(false)*(self:GetSpecialValueFor("bonus_damage")),
		damage_type = self:GetAbilityDamageType()
	}

	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	
	local gain = caster:GetModifierDurationGainIndex(0.5)

	for i=1, #unit do
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, unit[i]:GetAttachmentOrigin(unit[i]:ScriptLookupAttachment("attach_hitloc")))
		ParticleManager:SetParticleControl(pfx, 1, target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc")))
		ParticleManager:SetParticleControl(pfx, 3, unit[i]:GetAttachmentOrigin(unit[i]:ScriptLookupAttachment("attach_hitloc")))
		ParticleManager:ReleaseParticleIndex(pfx)
		if IsEnemy(caster, unit[i]) then
			local StatusResistance = unit[i]:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			unit[i]:AddNewModifier(caster, self, "modifier_Advanced_fortunes_end_debuff", {duration = duration*StatusResistance})
			unit[i]:Purge(true, false, false, false, false)
			damagetable.victim = unit[i]
			ApplyDamage(damagetable)
		else
			
			unit[i]:Purge(false, true, false, false, false)
			if self.unlock1 and self:GetAutoCastState() then
				self:Unlock1Effect(target)
			end
			unit[i]:AddNewModifier(caster, self, "modifier_Advanced_fortunes_end_buff", {duration = duration*2*gain})
		end
	end

	
	UTIL_Remove(EntIndexToHScript(keys.sound))
end
function Advanced_fortunes_end:Unlock1Effect(target)
	if not target:IsRealHero() then
		return
	end
	local caster = self:GetCaster()
	local modifiers1 = target:FindAllModifiers()
	target:Purge(true, false, false, false, false)
	local modifiers = target:FindAllModifiers()
	local stack = #modifiers1 - #modifiers --得出被驱散的正面状态数量
	if stack>0 then
		for i = 1, stack, 1 do
		
			target:AddNewModifier(caster, self, "modifier_Advanced_fortunes_end_unlock1_effect", {duration = 20})
		end
	end

end
modifier_Advanced_fortunes_end_cast_timer = class({})

function modifier_Advanced_fortunes_end_cast_timer:IsDebuff()			return false end
function modifier_Advanced_fortunes_end_cast_timer:IsHidden() 			return not IsInToolsMode() end
function modifier_Advanced_fortunes_end_cast_timer:IsPurgable() 			return false end
function modifier_Advanced_fortunes_end_cast_timer:IsPurgeException() 	return false end
function modifier_Advanced_fortunes_end_cast_timer:RemoveOnDeath() 		return false end
function modifier_Advanced_fortunes_end_cast_timer:AllowIllusionDuplicate() return false end

function modifier_Advanced_fortunes_end_cast_timer:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_channel.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

modifier_Advanced_fortunes_end_debuff = advanced_modifier({})

function modifier_Advanced_fortunes_end_debuff:IsDebuff()			return true end
function modifier_Advanced_fortunes_end_debuff:IsHidden() 			return false end
function modifier_Advanced_fortunes_end_debuff:IsPurgable() 			return true end
function modifier_Advanced_fortunes_end_debuff:IsPurgeException() 	return true end
function modifier_Advanced_fortunes_end_debuff:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf" end
function modifier_Advanced_fortunes_end_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_fortunes_end_debuff:OnCreated(keys)

end
function modifier_Advanced_fortunes_end_debuff:CheckState()
	if IsClient() then
		return
	end
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	--LV15解锁高阶破坏
	if self:GetAbility() and  self:GetAbility().advanced_level>=15 then
		state = {
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_EVADE_DISABLED] = true,
			-- [MODIFIER_STATE_BLOCK_DISABLED] = true,
		}
	end
	 return state
end


function modifier_Advanced_fortunes_end_debuff:ADDeclareFunctions()
	if self:GetAbility() and self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		return {
			advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE,
		}
	end
	return {
		
	}
end


function modifier_Advanced_fortunes_end_debuff:Advanced_GetModifierTotalBlockConstantDisable(keys)
    return 1
end



modifier_Advanced_fortunes_end_buff = class({})

function modifier_Advanced_fortunes_end_buff:IsDebuff()			return false end
function modifier_Advanced_fortunes_end_buff:IsHidden() 			return false end
function modifier_Advanced_fortunes_end_buff:IsPurgable() 		return true end
function modifier_Advanced_fortunes_end_buff:IsPurgeException() 	return true end
function modifier_Advanced_fortunes_end_buff:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_fortune_channel.vpcf" end
function modifier_Advanced_fortunes_end_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Advanced_fortunes_end_buff:ShouldUseOverheadOffset() return true end

function modifier_Advanced_fortunes_end_buff:OnCreated()
	if IsServer() then
		self.advanced_level = self:GetAbility().advanced_level
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_fortunes_end_buff:OnIntervalThink()
	--LV5解锁协调+
	if self.advanced_level>=5 then
		self:GetParent():Purge(false, true, false, false, true)
	else
		self:GetParent():Purge(false, true, false, false, false)
	end
	
end

function modifier_Advanced_fortunes_end_buff:CheckState()
	local state = {
		
	}
	--LV15解锁高阶破坏
	if self.advanced_level>=20 then
		state = {
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,


		}
	end
	 return state
end









modifier_Advanced_fortunes_end_unlock1_effect = class({})

function modifier_Advanced_fortunes_end_unlock1_effect:IsHidden()	return false end
function modifier_Advanced_fortunes_end_unlock1_effect:IsDebuff()	return false end
function modifier_Advanced_fortunes_end_unlock1_effect:IsPurgable()	return false end
function modifier_Advanced_fortunes_end_unlock1_effect:IsPurgeException() return false end


function modifier_Advanced_fortunes_end_unlock1_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	
		

	}
end


function modifier_Advanced_fortunes_end_unlock1_effect:GetModifierBonusStats_Strength()	return self:GetStackCount()==0 and 15*self.stack or 0 end
function modifier_Advanced_fortunes_end_unlock1_effect:GetModifierBonusStats_Intellect()	return self:GetStackCount()==2 and 15*self.stack or 0 end
function modifier_Advanced_fortunes_end_unlock1_effect:GetModifierBonusStats_Agility()	return self:GetStackCount()==1 and 15*self.stack or 0 end

function modifier_Advanced_fortunes_end_unlock1_effect:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()


	self.tData = {}
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	self.stack = 1
	self:StartIntervalThink(0.1)

    if IsServer() then

		self:SetStackCount(parent:GetPrimaryAttribute())

	end
end

function modifier_Advanced_fortunes_end_unlock1_effect:OnRefresh(params)
	-- if IsServer() then
		local dieTime = self:GetDieTime()
		
		
		if self:GetStackCount()>= (30) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			-- self:IncrementStackCount()
			self.stack = self.stack +1
		end
	-- end
end

function modifier_Advanced_fortunes_end_unlock1_effect:OnIntervalThink()
	-- if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				-- self:DecrementStackCount()
				self.stack = self.stack - 1
			end
		end
	-- end
end








modifier_Advanced_fortunes_end_unlock2 = class({})

function modifier_Advanced_fortunes_end_unlock2:IsHidden()	return true end
function modifier_Advanced_fortunes_end_unlock2:IsDebuff()	return false end
function modifier_Advanced_fortunes_end_unlock2:IsPurgable()	return false end
function modifier_Advanced_fortunes_end_unlock2:IsPurgeException() return false end
function modifier_Advanced_fortunes_end_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_fortunes_end_unlock2:OnCreated(keys)
	if IsServer() then
		local heroes = GetAllRealHeroes()
		local caster = self:GetCaster()
	
		local sound = CreateModifierThinker(caster, self:GetAbility(), "modifier_dummy_thinker", {duration = 2.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
		sound:EmitSound("Hero_Oracle.FortunesEnd.Attack")
		sound = sound:entindex()
		local info = 
		{
			Target = heroes[1],
			Source = caster,
			Ability = self:GetAbility(),	
			EffectName = "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",
			iMoveSpeed = math.max(heroes[1]:GetMoveSpeedModifier(heroes[1]:GetBaseMoveSpeed(), true),1500),
			iSourceAttach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false,
			ExtraData = {time = 2.5, sound = sound,index =1},	
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
end




