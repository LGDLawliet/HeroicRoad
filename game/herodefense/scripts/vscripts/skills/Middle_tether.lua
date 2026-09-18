Middle_tether = class({})
-- This modifier applies on Wisp and deals with giving the target heal and mana amp
LinkLuaModifier("modifier_Middle_tether", "skills/Middle_tether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_tether_buff", "skills/Middle_tether", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能


function Middle_tether:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()
	if target == caster then
		return "#Spells_CustomCastError_NOT_SELF"
	end
	return "#Spells_CustomCastError_NOT_Enemy"
end

function Middle_tether:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target == caster or target:GetTeamNumber()~=caster:GetTeamNumber() then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end

function Middle_tether:OnSpellStart()
	local ability 				= self
	local caster 				= self:GetCaster()




	self.tether_ally 			= self:GetCursorTarget()
	self.target 				= self:GetCursorTarget()

	self.range = math.max(caster:GetCastRangeBonus() +self:GetSpecialValueFor("radius"),100)+150

	local NetTable_key = self:GetCaster():GetEntityIndex().."_Middle_tether_cast_range"
	-- print(NetTable_key)
	CustomNetTables:SetTableValue( "spell_info", NetTable_key, {range =self.range-150 } )  --更新网表




	caster:AddNewModifier(self.target, self, "modifier_Middle_tether", {})


	caster:SwapAbilities("Middle_tether", "Middle_tether_break", false, true)
	local ability = caster:FindAbilityByName("Middle_tether_break")
	ability:SetLevel(1)
	ability:StartCooldown(0.25)
	-- ability.father_spell = self
end



---------------------
-- TETHER MODIFIER --
---------------------

modifier_Middle_tether = advanced_modifier({})

function modifier_Middle_tether:IsHidden() return false end
function modifier_Middle_tether:IsPurgable() return false end
function modifier_Middle_tether:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_Middle_tether:OnCreated(params)
	self.target 			= self:GetCaster()

	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	if IsServer() then 
		self.radius 			= self:GetAbility().range
		self.tether_heal_amp 	= self:GetAbility():GetSpecialValueFor("tether_heal_amp")


		self.update_timer 			= 0
		self.time_to_send 			= 1  --恢复提示信息间隔
		self:GetCaster():EmitSound("Hero_Wisp.Tether")

		self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/units/heroes/hero_wisp/wisp_tether_2.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx,60,Vector(self.radius,self.radius+150,0))
		EmitSoundOn("Hero_Wisp.Tether.Target", self:GetParent())

		local caster = self:GetAbility():GetCaster()
		if not caster.tether_overload_readly then
			caster.tether_overload_readly = 1
		end

		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") then
			self.talent_index = 0.5
			if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"gay_chain_1") then
				self.talent_index = 0.6
			else
				self.record_wave = 0
			end
		end




	end
	
	self:StartIntervalThink(FrameTime())
end
function modifier_Middle_tether:OnWaveEnd()
	if self.record_wave then
		self.record_wave = self.record_wave + 1
		if self.record_wave>=2 then
			local ability = self:GetParent():FindAbilityByName("heroTalent_npc_dota_hero_wisp_2")
			if ability then
				ability:Unlockachievement()
			end
			
		end
	end
end
function modifier_Middle_tether:OnIntervalThink()
	self.difference			= 0


	if not IsServer() then return end
	local caster = self:GetAbility():GetCaster()
	-- print(self:GetAbility():GetCastRangeBonus(caster))
	-- 技能丢失或目标丢失则移除状态
	if not self:GetAbility() or not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	
	self.update_timer = self.update_timer + FrameTime()

	local dis = (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

	
	-- 每过一秒给出一次恢复提升
	if self.update_timer > self.time_to_send then 
		local index = 1
		if dis> self.radius then
			if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") and not self:GetParent():PassivesDisabled() then
				index = self.talent_index
			else
				self:GetParent():RemoveModifierByName("modifier_Middle_tether")
				return
			end
		end
		local heal = caster:GetHealthRegen()*self.tether_heal_amp*index
		local mana_gain = caster:GetManaRegen()*self.tether_heal_amp*index
		-- print(caster:GetHealthRegen())
		-- print(mana_gain)
	
		local healing = HealWithGain(heal,caster,self.target,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, healing, nil)
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, self.total_gained_health, nil)	
	
		self.target:GiveMana(mana_gain)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.target, mana_gain, nil)

		self.update_timer 			= 0
	end


	if caster.tether_overload_readly==1 and self.target:GetHealthPercent()<=30  then
		caster.tether_overload_readly = 0
		--超负荷冷却
		Timers:CreateTimer(25, function()
			caster.tether_overload_readly = 1
		end)
		local gain = caster:GetModifierDurationGainIndex(1)
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_tether_buff", {duration = 7*gain})
		local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end


	
	if (self:GetParent():IsOutOfGame()) or not self.target:IsAlive() or not self:GetParent():IsAlive() then  --打断
		self:GetParent():RemoveModifierByName("modifier_Middle_tether")
		return
	end

	if dis <= self.radius then
		return
	end

	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_wisp_2") and not self:GetParent():PassivesDisabled() then
		return
	end
	self:GetParent():RemoveModifierByName("modifier_Middle_tether")
end

function modifier_Middle_tether:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}

	return decFuncs
end


function modifier_Middle_tether:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move_speed
end

-- function modifier_Middle_tether:GetModifierMoveSpeed_Limit()
-- 	return self.target_speed
-- end

function modifier_Middle_tether:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_Middle_tether:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx,false)
		self:GetCaster():EmitSound("Hero_Wisp.Tether.Stop")
		self:GetCaster():StopSound("Hero_Wisp.Tether")
		self:GetParent():SwapAbilities("Middle_tether_break", "Middle_tether", false, true)
	end
end
function modifier_Middle_tether:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end




Middle_tether_break = class({})

function Middle_tether_break:OnSpellStart()
	self:GetCaster():RemoveModifierByName("modifier_Middle_tether")
end


function Middle_tether_break:GetCastRange()
	
	--去拿施法时的施法距离
	local NetTable_key = self:GetCaster():GetEntityIndex().."_Middle_tether_cast_range"
	local range = CustomNetTables:GetTableValue( "spell_info", NetTable_key).range
	local caster =self:GetCaster()
	return range - caster:GetCastRangeBonus()

end

--用上面的写法比较好
-- function Middle_tether_break:GetCastRangeBonus(caster)
-- 	return 0
-- end






modifier_Middle_tether_buff = advanced_modifier({})

function modifier_Middle_tether_buff:IsDebuff() return false end
function modifier_Middle_tether_buff:IsHidden() return false end
function modifier_Middle_tether_buff:IsPurgable() return true end


function modifier_Middle_tether_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(self:GetCaster():GetStrength())
	end
end

function modifier_Middle_tether_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

    }
end

function modifier_Middle_tether_buff:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount() end
