--特效优化 √
Advanced_Plague_Ward = class({})
require('internal/timers')
LinkLuaModifier("modifier_Advanced_Plague_Ward_think", "skills/Advanced_Plague_Ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Plague_Ward_armor", "skills/Advanced_Plague_Ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Plague_Long_Range", "skills/Advanced_Plague_Ward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Plague_unlock3", "skills/Advanced_Plague_Ward", LUA_MODIFIER_MOTION_NONE)


function Advanced_Plague_Ward:Precache( context )
	PrecacheResource( "model", "models/items/venomancer/ward/venomancer_hydra_snakeward/venomancer_hydra_snakeward.vmdl", context )
	PrecacheResource( "model", "models/items/venomancer/ward/veno_2022_immortal_ward/veno_2022_immortal_ward.vmdl", context )
	PrecacheResource( "particle", "particles/econ/items/venomancer/veno_2022_immortal_ward/veno_2022_immortal_ward_ambient.vpcf", context )




	
end



function Advanced_Plague_Ward:UnlockFirstCore(key)
	return true
end
function Advanced_Plague_Ward:UnlockSecondCore(key)
	return true
end
function Advanced_Plague_Ward:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Plague_unlock3",{})
	return true
end
function Advanced_Plague_Ward:IsSummonSpell()return true end




function Advanced_Plague_Ward:Spawn()
	self.unlock3_count = 0
end


function Advanced_Plague_Ward:CheckKV(key)
	local table = {
		bonus_damage = 1,
	}
	if self:GetUnlock(1)==1 then
		table.bonus_damage = 3
	end
	local value = table[key] or -1
	return value

end
-- require("internal.timers")
function Advanced_Plague_Ward:IsHiddenWhenStolen() 	return false end
function Advanced_Plague_Ward:IsRefreshable() 		return false end
function Advanced_Plague_Ward:IsStealable() 			return true end
function Advanced_Plague_Ward:IsNetherWardStealable()return false end

function Advanced_Plague_Ward:OnSpellStart(bNomain)
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	-- local ability = caster:FindAbilityByName("imba_venomancer_poison_sting")
	local theward = {}
	local life_duration = self:GetSpecialValueFor("duration")
	local heal = self:GetSpecialValueFor("bonus_creep_health")*0.01 * caster:GetMaxHealth()
	local armor = 0
	local damage = (self:GetSpecialValueFor("bonus_damage"))*0.01 * caster:GetBaseDamageMax()
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_venomancer_2") then
		damage = damage * 2
	end
	local wards = self:GetSpecialValueFor("plague_amount")
	local bonus_index = 0.4
	local long_range_min = 400
	--LV5解锁增殖体+
	if self.advanced_level>=5 then
		bonus_index = 0.7
	end
	if self.unlock3_count>=50 then
		bonus_index = 0.9
		if self.unlock3_count>=150 then
			armor = 0.4 * caster:GetPhysicalArmorValue(false)
			if self.unlock3_count>=200 then
				long_range_min = 750
			end
		end
	end
	if self.unlock1 then
		bonus_index = 1
	end

	if self.unlock2 then
		wards = 0
		heal = heal * 2
		damage = damage * 2
	end
	if not bNomain then
		local unit = caster:SummonUnit("npc_Advanced_Plague_Ward",life_duration,pos,nil,self,0,heal,0,damage,armor,1,1)

		table.insert(theward, unit)
		unit:EmitSound("Hero_Venomancer.Plague_Ward")
	end



	heal = 1
	damage = damage *bonus_index
	for i=1, wards do
		local spawn_point = RotatePosition(pos, QAngle(0, i * 360 / wards, 0), pos + caster:GetForwardVector() * 125 )
		local unit = caster:SummonUnit("npc_Advanced_Plague_Ward_2",life_duration,spawn_point,nil,self,0,heal,0,damage,armor,1,1)
		unit:EmitSound("Hero_Venomancer.Plague_Ward")
		table.insert(theward, unit)
	end
	local pfx_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	for i=0, 1 do
		ParticleManager:SetParticleControlEnt(pfx_cast, i, caster, PATTACH_POINT_FOLLOW, "attach_attack"..(i + 1), caster:GetAbsOrigin(), true)
	end
	ParticleManager:ReleaseParticleIndex(pfx_cast)
	local radius =math.max(caster:Script_GetAttackRange( ),long_range_min)
	for _, ward in pairs(theward) do
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, ward)
		ParticleManager:ReleaseParticleIndex(pfx)
		ward:AddNewModifier(caster, self, "modifier_Advanced_Plague_Ward_think", {})
		--LV15解锁魔法免疫
		if self.advanced_level>=15 then
			ward:AddNewModifier(caster, self, "modifier_magic_immune", {})
			if self.advanced_level>=20 then
				ward:AddNewModifier(caster, self, "modifier_Advanced_Plague_Long_Range", {index = radius})
			end
		end
		-- ward:AddNewModifier(caster, self, "modifier_kill", {duration = life_duration})
	end




end


function Advanced_Plague_Ward:GetCastRange()
	local caster = self:GetCaster()
	return 1000 - caster:GetCastRangeBonus()

end

modifier_Advanced_Plague_Ward_think = class({})

function modifier_Advanced_Plague_Ward_think:IsDebuff()			return false end
function modifier_Advanced_Plague_Ward_think:IsHidden() 		return true end
function modifier_Advanced_Plague_Ward_think:IsPurgable() 		return false end
function modifier_Advanced_Plague_Ward_think:IsPurgeException() return false end
function modifier_Advanced_Plague_Ward_think:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED} end
-- function modifier_Advanced_Plague_Ward_think:GetModifierIncomingDamage_Percentage() return -100000 end
-- function modifier_Advanced_Plague_Ward_think:CheckState()
-- 	if self:GetParent():GetUnitName() == "npc_Advanced_Plague_Ward" then
-- 		return {[MODIFIER_STATE_DISARMED] = true}
-- 	else
-- 		return nil
-- 	end
-- end

function modifier_Advanced_Plague_Ward_think:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() then
		if not self:GetAbility() then
			return
		end
		keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_Plague_Ward_armor", {duration = 5})
	end
end

function modifier_Advanced_Plague_Ward_think:OnCreated()
	if IsServer()then
		
		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_12" then
			self:GetParent():SetOriginalModel("models/items/venomancer/ward/venomancer_hydra_snakeward/venomancer_hydra_snakeward.vmdl")
		elseif type=="ability_particle_13" then
			local parent = self:GetParent()
			parent:SetOriginalModel("models/items/venomancer/ward/veno_2022_immortal_ward/veno_2022_immortal_ward.vmdl")
			Timers:CreateTimer(0.1, function()
				if parent and not parent:IsNull() and parent:IsAlive() then
					local pfx = ParticleManager:CreateParticle("particles/econ/items/venomancer/veno_2022_immortal_ward/veno_2022_immortal_ward_ambient.vpcf", PATTACH_CUSTOMORIGIN, parent)
					ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_eye_l", parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 2, parent, PATTACH_POINT_FOLLOW, "attach_eye_r", parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 3, parent, PATTACH_POINT_FOLLOW, "attach_eye_l", parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 4, parent, PATTACH_POINT_FOLLOW, "attach_eye_r", parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 5, parent, PATTACH_POINT_FOLLOW, "attach_eye_l_b", parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 6, parent, PATTACH_POINT_FOLLOW, "attach_eye_r_b", parent:GetAbsOrigin(), true)
					self:AddParticle(pfx, false, false, 15, false, false)
				end
			end)
			

		end
	end
end


modifier_Advanced_Plague_Ward_armor = modifier_Advanced_Plague_Ward_armor or advanced_modifier({})


function modifier_Advanced_Plague_Ward_armor:OnCreated(params)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	-- local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonud_index = 1
	--LV10解锁毒液腐蚀+
	if self.advanced_level>=10 then
		self.bonud_index = 1.5
	end
	--技能的caster是英雄
	-- self.armor = 2
	if IsServer() then
		if self:GetAbility().unlock3_count>=150 then
			self.bonud_index = 2
		end
		self.tData = {}
		local hCaster = self:GetCaster()--buff的caster是蛇棒
		table.insert(self.tData, { caster = hCaster, dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Plague_Ward_armor:OnRefresh(params)
	if IsServer() then
		local hCaster = self:GetCaster()--buff的caster是蛇棒
		local bFind = false
		for k, v in pairs(self.tData) do
			if v.caster == hCaster then
				self.tData[k].dieTime = self:GetDieTime() -- 刷新这个蛇棒施加的buff的持续时间
				bFind = true
				break
			end
		end
		if not bFind then
			table.insert(self.tData, { caster = hCaster, dieTime = self:GetDieTime() })
			self:IncrementStackCount()
		end
	end
end
function modifier_Advanced_Plague_Ward_armor:OnDestroy(params)
	if IsServer() then
		for i = #self.tData, 1, -1 do
			table.remove(self.tData, i)
			self:DecrementStackCount()
		end
	end
end
function modifier_Advanced_Plague_Ward_armor:OnIntervalThink()
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
function modifier_Advanced_Plague_Ward_armor:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_Advanced_Plague_Ward_armor:Advanced_GetModifierPhysicalArmorBonus(params)
	return -1 * self:GetStackCount()*self.bonud_index
end
function modifier_Advanced_Plague_Ward_armor:GetModifierMagicalResistanceBonus(params)
	return -3 * self:GetStackCount()*self.bonud_index
end

function modifier_Advanced_Plague_Ward_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end



modifier_Advanced_Plague_Long_Range = advanced_modifier({})

function modifier_Advanced_Plague_Long_Range:IsDebuff() return false end
function modifier_Advanced_Plague_Long_Range:IsHidden() return true end
function modifier_Advanced_Plague_Long_Range:IsPurgable() return false end
function modifier_Advanced_Plague_Long_Range:IsPurgeException() return false end
function modifier_Advanced_Plague_Long_Range:RemoveOnDeath() return false end
--
function modifier_Advanced_Plague_Long_Range:OnCreated(keys)
	
    if IsServer() then
		self:SetStackCount(keys.index) 
	end
end

function modifier_Advanced_Plague_Long_Range:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end


function modifier_Advanced_Plague_Long_Range:Advanced_GetModifierAttackRangeBonus()	return self:GetStackCount() end











modifier_Advanced_Plague_unlock3 = class({})

function modifier_Advanced_Plague_unlock3:IsDebuff()			return false end
function modifier_Advanced_Plague_unlock3:IsHidden() 			return self:GetStackCount()>=200 end
function modifier_Advanced_Plague_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Plague_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Plague_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Plague_unlock3:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_Advanced_Plague_unlock3:OnDeath(keys)
    if not IsServer() then
        return
    end
	local unit = keys.unit
	if not keys.attacker then
		return
	end

    if IsEnemy(unit, keys.attacker) then
		local name =unit:GetUnitName()
		if name=="npc_Advanced_Plague_Ward" or name=="npc_Advanced_Plague_Ward_2" then
			local modifier = unit:FindModifierByNameAndCaster("modifier_Advanced_Plague_Long_Range", self:GetCaster())
			if modifier then
				self:IncrementStackCount()
				self:GetAbility().unlock3_count = self:GetAbility().unlock3_count + 1
			end
		end
    end
   
end

