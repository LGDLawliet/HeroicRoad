

Advanced_summon_Slime						= Advanced_summon_Slime or class({})


LinkLuaModifier("modifier_Slime_arua", "skills/Middle_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_arua_effect", "skills/Middle_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_buff", "skills/Advanced_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_buff_unlock1", "skills/Advanced_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_buff_unlock1_count", "skills/Advanced_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_buff_unlock2", "skills/Advanced_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_buff_unlock2_debuff", "skills/Advanced_summon_Slime", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Slime_buff_unlock3", "skills/Advanced_summon_Slime", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Slime_buff_unlock3_unity_process", "skills/Advanced_summon_Slime", LUA_MODIFIER_MOTION_NONE)
function Advanced_summon_Slime:IsSummonSpell()return true end

function Advanced_summon_Slime:CheckKV(key)
	local table = {

		bonus_health=2.5,



	}
	local value = table[key] or -1
	return value

end

function Advanced_summon_Slime:UnlockFirstCore(key)
	self.unlock1_value = 0
	local caster = self:GetCaster()
	self.unlock1_modifier = caster:AddNewModifier(caster,self,"modifier_Slime_buff_unlock1_count",{})
	return true
end
function Advanced_summon_Slime:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_summon_Slime:UnlockThirdCore(key)
	
	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_earth_spirit" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true

end
function Advanced_summon_Slime:ModifyUnlock1Value(value)
	self.unlock1_value = math.min(self.unlock1_value+value,20000)
	if self.unlock1_modifier and not self.unlock1_modifier:IsNull() then
		self.unlock1_modifier:SetStackCount(self.unlock1_value)
	end
end
function Advanced_summon_Slime:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_slime/summon_slime.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/ice_rain/ice_rain.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", context )

end

function Advanced_summon_Slime:OnSpellStart()

	
	local caster =self:GetCaster()




	EmitSoundOn("Hero_Slardar.Slithereen_Crush", self:GetCaster())	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	if self.unlock1 then
		local bonus_index = math.floor(self.unlock1_value/2500)*0.1
		heal = (self:GetSpecialValueFor("bonus_health")*0.01+bonus_index) * caster:GetMaxHealth() +self.unlock1_value
	end
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()

	for i = 1, 1 do		
		local pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120 * (i - ((self:GetSpecialValueFor("wolves_count") - 1) / 2)))
		local unit = caster:SummonUnit("npc_hd_Slime",life_duration,
		pos,
		self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)

		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_slime/summon_slime.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)


		unit:AddNewModifier(caster, self, "modifier_Slime_arua", {})
		
		unit:AddNewModifier(caster, self, "modifier_Slime_buff", {})

		if self.unlock1 then
			unit:AddNewModifier(caster, self, "modifier_Slime_buff_unlock1", {})

		elseif self.unlock2 then
			unit:AddNewModifier(caster, self, "modifier_Slime_buff_unlock2", {})
		elseif self.unlock3 then
			unit:AddNewModifier(caster, self, "modifier_Slime_buff_unlock3", {})
		end
	end	

end

function Advanced_summon_Slime:UnitySlime(unit1,unit2)
	unit1:AddEffects(EF_NODRAW )
	unit2:AddEffects(EF_NODRAW )

	local pos = unit1:GetAbsOrigin()
	local modifier = unit2:FindModifierByName("modifier_kill")
	local duration = 60
	if modifier then
		duration = modifier:GetRemainingTime()+10
	end
	local caster = self:GetCaster()
	local unit = caster:SummonUnit("npc_hd_Slime",duration,
	pos,
	self:GetCaster():GetForwardVector(),self,0,unit1:GetMaxHealth()+unit2:GetMaxHealth(),0,unit1:GetDamageMax()+unit2:GetDamageMax(),unit1:GetPhysicalArmorValue(false)+unit2:GetPhysicalArmorValue(false),0,0)

	local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/summon_slime/summon_slime.vpcf", PATTACH_ABSORIGIN, unit)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	unit:AddNewModifier(caster, self, "modifier_Slime_arua", {})
	unit:AddNewModifier(caster, self, "modifier_Slime_buff", {})
	
	unit.slime_unlock3 = 1
	if unit1.slime_unlock3 then
		unit.slime_unlock3 = unit.slime_unlock3 + unit1.slime_unlock3
	end
	if unit2.slime_unlock3 then
		unit.slime_unlock3 = unit.slime_unlock3 + unit2.slime_unlock3
	end
	if unit.slime_unlock3<10 then
		unit:AddNewModifier(caster, self, "modifier_Slime_buff_unlock3", {})
	end

	unit1:EmitSound("Hero_LifeStealer.Infest")
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(infest_particle, 0, unit1:GetAbsOrigin()+Vector(0,0,64))
	ParticleManager:SetParticleControlEnt(infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)

	unit2:EmitSound("Hero_LifeStealer.Infest")
	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(infest_particle, 0, unit2:GetAbsOrigin()+Vector(0,0,64))
	ParticleManager:SetParticleControlEnt(infest_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)
	TrueKill(unit2, unit2, self)

end


modifier_Slime_buff = advanced_modifier({})

function modifier_Slime_buff:IsDebuff()			return false end
function modifier_Slime_buff:IsHidden() 			return true end
function modifier_Slime_buff:IsPurgable() 		return false end
function modifier_Slime_buff:IsPurgeException() 	return false end
function modifier_Slime_buff:OnCreated()
	if IsServer() then
		local advanced_level = self:GetAbility().advanced_level
		self.index = 1
		if advanced_level >=10 then
			self.index = 1.5
		end
	end
end
function modifier_Slime_buff:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	if IsClient() then
		return 0
	end
	local attacker = keys.attacker
	local parent = self:GetParent()
	if not attacker or attacker:IsNull() or not parent or parent:IsNull()   then
		return 0
	end


	local reduce = -math.min(40,CalculateDistance(attacker,parent)/10*self.index)
	-- print(reduce)


	return reduce


end



-- advanced_modifier
function modifier_Slime_buff:ADDeclareFunctions()

	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end





modifier_Slime_buff_unlock1 = class({})

function modifier_Slime_buff_unlock1:IsDebuff()			return false end
function modifier_Slime_buff_unlock1:IsHidden() 			return true end
function modifier_Slime_buff_unlock1:IsPurgable() 		return false end
function modifier_Slime_buff_unlock1:IsPurgeException() 	return false end
function modifier_Slime_buff_unlock1:DeclareFunctions() return {
	MODIFIER_EVENT_ON_DEATH, 

} 
end

function modifier_Slime_buff_unlock1:OnDeath(keys)
    if not IsServer() then
        return
    end

    if IsEnemy(keys.unit,self:GetParent()) and CalculateDistance(keys.unit,self:GetParent())<=400 then
		self:GetAbility():ModifyUnlock1Value(20)
		self:GetParent():EmitSound("Hero_Pudge.Dismember")
    end


end




modifier_Slime_buff_unlock1_count = class({})

function modifier_Slime_buff_unlock1_count:IsDebuff()			return false end
function modifier_Slime_buff_unlock1_count:IsHidden() 			return false end
function modifier_Slime_buff_unlock1_count:IsPurgable() 		return false end
function modifier_Slime_buff_unlock1_count:IsPurgeException() 	return false end






modifier_Slime_buff_unlock2 = class({})

function modifier_Slime_buff_unlock2:IsDebuff()			return false end
function modifier_Slime_buff_unlock2:IsHidden() 			return true end
function modifier_Slime_buff_unlock2:IsPurgable() 		return false end
function modifier_Slime_buff_unlock2:IsPurgeException() 	return false end
function modifier_Slime_buff_unlock2:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_Slime_buff_unlock2:OnIntervalThink() 
	local parent = self:GetParent()
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, unit in ipairs(units) do
		unit:AddNewModifier(parent, self:GetAbility(), "modifier_Slime_buff_unlock2_debuff", {})
	end
end



modifier_Slime_buff_unlock2_debuff = advanced_modifier({})

function modifier_Slime_buff_unlock2_debuff:IsDebuff()			return true end
function modifier_Slime_buff_unlock2_debuff:IsHidden() 			return false end
function modifier_Slime_buff_unlock2_debuff:IsPurgable() 		return false end
function modifier_Slime_buff_unlock2_debuff:IsPurgeException() 	return false end
function modifier_Slime_buff_unlock2_debuff:OnCreated()
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_Slime_buff_unlock2_debuff:OnRefresh()
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,500))
	end
end

function modifier_Slime_buff_unlock2_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_Slime_buff_unlock2_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Slime_buff_unlock2_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Slime_buff_unlock2_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()*0.2 
end




modifier_Slime_buff_unlock3 = class({})

function modifier_Slime_buff_unlock3:IsDebuff()			return false end
function modifier_Slime_buff_unlock3:IsHidden() 			return true end
function modifier_Slime_buff_unlock3:IsPurgable() 		return false end
function modifier_Slime_buff_unlock3:IsPurgeException() 	return false end
function modifier_Slime_buff_unlock3:OnDestroy(keys)
    if not IsServer() then
        return
    end


	local parent = self:GetParent()
	if parent.slime_unlock3 and  parent.slime_unlock3>=10 then
		return
	end
	if parent:HasModifier("modifier_Slime_buff_unlock3_unity_process") then
		return
	end
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if unit:HasModifier("modifier_Slime_buff_unlock3") and not unit:HasModifier("modifier_Slime_buff_unlock3_unity_process") then
			unit:AddNewModifier(parent, self:GetAbility(), "modifier_Slime_buff_unlock3_unity_process", {})
			break
		end
	end
end
modifier_Slime_buff_unlock3_unity_process = class({})

function modifier_Slime_buff_unlock3_unity_process:IsDebuff()			return false end
function modifier_Slime_buff_unlock3_unity_process:IsHidden() 			return true end
function modifier_Slime_buff_unlock3_unity_process:IsPurgable() 		return false end
function modifier_Slime_buff_unlock3_unity_process:IsPurgeException() 	return false end
function modifier_Slime_buff_unlock3_unity_process:RemoveOnDeath() return false end
function modifier_Slime_buff_unlock3_unity_process:OnCreated(keys)
	if IsServer() then
		self.target = self:GetCaster()
		-- self.parent = self:GetParent()
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_Slime_buff_unlock3_unity_process:OnDestroy()   --当时间漫游结束时
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)  --Place a unit somewhere not already occupied.
	end
end

function modifier_Slime_buff_unlock3_unity_process:OnIntervalThink()   --对沿途敌人造成眩晕与窃取速度效果
	if not self.target or self.target:IsNull() then
		self:SafeDestroy()
		return
	end
	local me = self:GetParent()
	local dt = FrameTime()
	local direction = (self.target:GetAbsOrigin() - me:GetAbsOrigin()):Normalized()    --GetAbsOrigin()应该是施法点  	Normalized()返回单位矢量
	direction.z = 0
	local new_pos = me:GetAbsOrigin() + direction * (1000 / (1.0 / dt))  --需要debug确认作用
	new_pos = GetGroundPosition(new_pos, nil)   --返回移动到提供的position的地面位置。第二个参数是一个NPC，用于测量碰撞体积
	me:SetOrigin(new_pos)  --Sets the location of this entity
	
	if CalculateDistance(self.target,me)<=100 then
		self:StartIntervalThink(-1)
		self:GetAbility():UnitySlime(self.target,me)
	end

end

function modifier_Slime_buff_unlock3_unity_process:CheckState()
	local state = {[MODIFIER_STATE_INVULNERABLE] = true}

	return state
end