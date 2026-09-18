--特效优化 √
Advanced_Electrostatic_Armor = class({})
LinkLuaModifier("modifier_Advanced_Electrostatic_Armor_damage_count", "skills/Advanced_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Electrostatic_Armor_spell", "skills/Advanced_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Electrostatic_Armor_shield", "skills/Advanced_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Electrostatic_Armor_unlock2_buff", "skills/Advanced_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Electrostatic_Armor_unlock3", "skills/Advanced_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Electrostatic_Armor_unlock3_buff", "skills/Advanced_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)

function Advanced_Electrostatic_Armor:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_punctured_crest/razor_storm_lightning_strike_blade.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/electrostatic_armor/particle_17/effect.vpcf", context )
	



	
end

function Advanced_Electrostatic_Armor:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_Electrostatic_Armor:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_fear_arua_unlock2",{})
	
	return true
end
function Advanced_Electrostatic_Armor:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Electrostatic_Armor_unlock3",{})
	
	return true
end

function Advanced_Electrostatic_Armor:CheckKV(key)
	local table = {

		base_damage =7,
		bonus_damage_min = 0.05,
		bonus_magic_resistance = 0.4,



	}
	local value = table[key] or -1
	return value

end


--Abilities
function Advanced_Electrostatic_Armor:IsHiddenWhenStolen() 		return false end
function Advanced_Electrostatic_Armor:IsRefreshable() 			return true end
function Advanced_Electrostatic_Armor:IsStealable() 				return true end
function Advanced_Electrostatic_Armor:IsNetherWardStealable()		return true end
function Advanced_Electrostatic_Armor:GetIntrinsicModifierName() return "modifier_Advanced_Electrostatic_Armor_damage_count" end
function Advanced_Electrostatic_Armor:GetAOERadius()
	return self:GetSpecialValueFor("radius")- self:GetCaster():GetCastRangeBonus()
end


modifier_Advanced_Electrostatic_Armor_damage_count = advanced_modifier({})
function modifier_Advanced_Electrostatic_Armor_damage_count:IsHidden() return false end
function modifier_Advanced_Electrostatic_Armor_damage_count:IsDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_damage_count:IsPurgable() 		return false end
function modifier_Advanced_Electrostatic_Armor_damage_count:IsPurgeException() 	return false end
function modifier_Advanced_Electrostatic_Armor_damage_count:RemoveOnDeath()  return false end
function modifier_Advanced_Electrostatic_Armor_damage_count:IsStunDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_damage_count:AllowIllusionDuplicate() return false end

function modifier_Advanced_Electrostatic_Armor_damage_count:DeclareFunctions() return
    {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOC
	} 
end
function modifier_Advanced_Electrostatic_Armor_damage_count:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("bonus_magic_resistance") end


function modifier_Advanced_Electrostatic_Armor_damage_count:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
	if keys.unit ~= self:GetParent() then
		return
	end
	if keys.unit:PassivesDisabled() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if not keys.attacker then
		return
	end
	if keys.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then
		return
	end

    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	local require = ability:GetSpecialValueFor("damage_require")*0.01
	if ability.advanced_level>=5 then
		require = 0.08
	end
    --判断累计伤害是否达到触发线
    if self:GetStackCount() > caster:GetMaxHealth()*require then
        caster:AddNewModifier(caster, ability, "modifier_Advanced_Electrostatic_Armor_spell", {})
        self:SetStackCount(0)
		ability:UseResources(true, true, true, true)
    end
end


-- function modifier_Advanced_Electrostatic_Armor_damage_count:GetModifierMagical_ConstantBlock() 
-- 	local parent = self:GetParent()
-- 	if self:GetAbility():GetSpecialValueFor("advanced_level")<20 then
-- 		return
-- 	end

-- 	local block = parent:GetStrength()
-- 	if parent:HasModifier("modifier_Advanced_dragon_blood") or parent:HasModifier("modifier_Middle_dragon_blood") then
-- 		block = block * 7
-- 	else
-- 		block = block * 3
-- 	end
-- 	return block
-- end


function modifier_Advanced_Electrostatic_Armor_damage_count:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MAGACIAL_BLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_Electrostatic_Armor_damage_count:Advanced_GetModifierMagicalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	local parent = self:GetParent()
	if self:GetAbility():GetSpecialValueFor("advanced_level")<20 then
		return
	end

	local block = parent:GetStrength()
	if parent:HasModifier("modifier_Advanced_dragon_blood") or parent:HasModifier("modifier_Middle_dragon_blood") then
		block = block * 7
	else
		block = block * 3
	end
	return block
end




modifier_Advanced_Electrostatic_Armor_spell = class({})
function modifier_Advanced_Electrostatic_Armor_spell:IsHidden() return true end
function modifier_Advanced_Electrostatic_Armor_spell:IsDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_spell:IsPurgable() return false end
function modifier_Advanced_Electrostatic_Armor_spell:IsPurgeException() return false end
function modifier_Advanced_Electrostatic_Armor_spell:IsStunDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_spell:AllowIllusionDuplicate() return false end

function modifier_Advanced_Electrostatic_Armor_spell:OnCreated(params)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetCaster()
    local ability = self:GetAbility()

	self.parent = self:GetParent()
	self.iRadius = ability:GetSpecialValueFor("radius")+100
	self.iSpeed = 500
    self.iDamage = ability:GetSpecialValueFor("base_damage") + self.hCaster:GetStrength()*ability:GetSpecialValueFor("bonus_damage")
    self.Shield = self.hCaster:GetStrength()
	if ability.advanced_level>=10 then
		self.Shield = self.Shield*1.5
	end

	--imba
	self.tEnemies = {}
	self.effect_table = {}
	self.iDur = 1   --控制移动方向
	self.fCurDis = 0
	self.iEffectWidth = 50
	if IsServer() then
		if params.unlock3 then
			self.iRadius = self.iRadius * 0.6
			self.iDamage =  self.iDamage *2
			self.unlock3_unit = true
		end
		-- if not self.parent:IsRealHero() then
		-- 	self.iRadius = self.iRadius * 0.6
		-- end
		self.hCaster:EmitSound("Ability.PlasmaField")
		local particle = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
		local type = particleManager:GetSpellParticle(self:GetCaster():GetPlayerOwnerID(),self:GetAbility():GetAbilityName())
		if type=="ability_particle_17" then
			particle = "particles/rebuild/spell/electrostatic_armor/particle_17/effect.vpcf"
		end
		-- particles/rebuild/spell/electrostatic_armor/particle_17/effect.vpcf

		self.iParticleID = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
		self.effect_pos = self.parent:GetAbsOrigin()
		if ability.unlock1 then
			self.unlock1 = true
			ParticleManager:SetParticleControl(self.iParticleID, 0, self.effect_pos)
			self.iSpeed = self.iSpeed * 2
			self.iRadius = self.iRadius * 2
			self.iDamage =self.iDamage + self.hCaster:GetMaxHealth()*0.08
			-- ParticleManager:SetParticleControlEnt(self.iParticleID, 0,  self.parent, PATTACH_ABSORIGIN_FOLLOW, nil,  self.effect_pos, true)
		else
			ParticleManager:SetParticleControlEnt(self.iParticleID, 0,  self.parent, PATTACH_ABSORIGIN_FOLLOW, nil,  self.effect_pos, true)
		end
		if ability.unlock2 then
			self.unlock2 = true
		end
		
		self:StartIntervalThink(FrameTime())
	end
end
--可以多重
function modifier_Advanced_Electrostatic_Armor_spell:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Electrostatic_Armor_spell:OnIntervalThink()
	if IsServer() then
		if not self.unlock1 then
			self.effect_pos = self.parent:GetAbsOrigin()
		end
        if not self.hCaster:IsNull() and  self.hCaster:IsAlive() then
            --先将搜寻到的敌人插入表中
            local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(),self.effect_pos, nil,
            self.fCurDis+self.iEffectWidth,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for i, enemy in pairs(enemies) do
                --如果是正向
				if self.iDur == 1 then
					if not IsInTable(enemy,self.tEnemies) and CalculateDistance(enemy,self.effect_pos)>=(self.fCurDis-self.iEffectWidth) then

						self.effect_table[enemy] =  false
						table.insert(self.tEnemies, enemy)
                    end
                --否则为反向
                else
                    --判断当前特效的距离，如果小于敌人与施法者的距离
					if self.fCurDis-self.iEffectWidth  <= CalculateDistance(enemy,self.effect_pos) then
						if not IsInTable(enemy,self.tEnemies)then
							self.effect_table[enemy] =  false
							table.insert(self.tEnemies, enemy)
						end
					end
				end
            end
            --对敌人造成伤害
            if self.tEnemies then
                --取出单位造成伤害，并将已伤害标记为true
				for _, enemy in pairs(self.tEnemies) do
					if not self.effect_table[enemy] then
						if not enemy:IsNull() then
							enemy:EmitSound("Ability.PlasmaFieldImpact")
							local particle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest/razor_storm_lightning_strike_blade.vpcf", PATTACH_CUSTOMORIGIN, enemy)
							ParticleManager:SetParticleControlEnt(particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
							ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
							ParticleManager:ReleaseParticleIndex(particle)
							local iDamage = self.iDamage
		
							local tDamage = {
								ability = self:GetAbility(),
								attacker = self.hCaster,
								victim = enemy,
								damage = iDamage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
							}
							ApplyDamage(tDamage)
							self.effect_table[enemy] =  true
						end


					
					end
				end
            end
			if self.unlock2 then
				local units = FindUnitsInRadius(self.hCaster:GetTeamNumber(),self.effect_pos, nil,
				self.fCurDis+self.iEffectWidth,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				local effect_units = {}
				for _, unit in pairs(units) do
					--如果是正向
					if self.iDur == 1 then
						if not self.effect_table[unit] and CalculateDistance(unit,self.effect_pos)>=(self.fCurDis-self.iEffectWidth) then

							table.insert( effect_units , unit)
						end
					--否则为反向
					else
						--判断当前特效的距离，如果小于敌人与施法者的距离
						if self.fCurDis-self.iEffectWidth  <= CalculateDistance(unit,self.effect_pos) then
							if not self.effect_table[unit] then

								table.insert( effect_units , unit)
							end
						end
					end
				end
				for _, unit in pairs( effect_units ) do
					self.effect_table[unit] =  true
					unit:EmitSound("Ability.PlasmaFieldImpact")
					local particle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest/razor_storm_lightning_strike_blade.vpcf", PATTACH_CUSTOMORIGIN, unit)
					ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
		
					local ModifierStatusGain = self.hCaster:GetModifierDurationGainIndex(1)
					unit:AddNewModifier(self.hCaster, self:GetAbility(), "modifier_Advanced_Electrostatic_Armor_unlock2_buff",
					 {duration=15*ModifierStatusGain,index=self.hCaster:GetStrength()*0.5})
				end
			end
            
            --移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(5000,self.fCurDis, 1))
            --如果到达最大距离则反向移动
            if self.fCurDis == self.iRadius then
				if not self.unlock3_unit then
					local ModifierStatusGain = self.hCaster:GetModifierDurationGainIndex(1)
					self.parent:AddNewModifier(self.hCaster, self:GetAbility(), "modifier_Advanced_Electrostatic_Armor_shield",
					{duration=10*ModifierStatusGain,index=#self.tEnemies *self.Shield})
				end
				
				self.iDur = -1
                self.iSpeed=-self.iSpeed
                --清空表
                self.tEnemies={}
				self.effect_table = {}
                --再搜寻一次
				local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.effect_pos, nil, self.fCurDis+self.iEffectWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _,enemy in pairs(enemies) do
					if not IsInTable(enemy,self.tEnemies) and ((enemy:GetAbsOrigin()-self.effect_pos):Length2D())>self.fCurDis+self.iEffectWidth then
						self.effect_table[enemy] =  false
						table.insert(self.tEnemies, enemy)
					end
				end
				-- self:SafeDestroy()
            end
            --结束反向操作
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)

            if self.fCurDis<=0 then
				if not self.unlock3_unit then
					local ModifierStatusGain = self.hCaster:GetModifierDurationGainIndex(1)
					self.parent:AddNewModifier(self.hCaster, self:GetAbility(), "modifier_Advanced_Electrostatic_Armor_shield", 
					{duration=10*ModifierStatusGain,index=#self.tEnemies *self.Shield})
				end

				self:SafeDestroy()
			end
		end
	end
end


function modifier_Advanced_Electrostatic_Armor_spell:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
	end
end

modifier_Advanced_Electrostatic_Armor_shield = advanced_modifier({})
function modifier_Advanced_Electrostatic_Armor_shield:IsHidden() return false end
function modifier_Advanced_Electrostatic_Armor_shield:IsDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_shield:IsPurgable() return false end
function modifier_Advanced_Electrostatic_Armor_shield:IsPurgeException() return false end
function modifier_Advanced_Electrostatic_Armor_shield:IsStunDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_shield:AllowIllusionDuplicate() return false end

function modifier_Advanced_Electrostatic_Armor_shield:DeclareFunctions() 
	local func = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	} 

	return func
end
function modifier_Advanced_Electrostatic_Armor_shield:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

function modifier_Advanced_Electrostatic_Armor_shield:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end
function modifier_Advanced_Electrostatic_Armor_shield:Advanced_GetModifierPhysicalArmorBonus() return self.bonus_armor end


function modifier_Advanced_Electrostatic_Armor_shield:OnCreated(keys)
	if self:GetAbility():GetSpecialValueFor("advanced_level")<10 then
		self.only_magic = true
	end
    if not IsServer() then
        return
    end
    self.pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/electrostatic_armor_shield_edge.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    local ex = self:GetParent():GetModelScale() * 100
    ParticleManager:SetParticleControl(self.pfx, 1, Vector(ex,ex,ex))
    self:AddParticle(self.pfx, false, false, 15, false, false)
    self:SetStackCount(keys.index)
    self:StartIntervalThink(0.2)

	self.bonus_magic_resistance = 0
	self.bonus_armor = 0
	if self:GetAbility().advanced_level>=15 then
		self.bonus_magic_resistance = 20
		self.bonus_armor = 10
	end
end

function modifier_Advanced_Electrostatic_Armor_shield:OnRefresh(keys)
    if not IsServer() then
        return
    end
    self:SetStackCount(self:GetStackCount()+keys.index)
end

function modifier_Advanced_Electrostatic_Armor_shield:OnIntervalThink()
    if not IsServer() then
        return
    end
    if self:GetStackCount()<=0 then
        self:SafeDestroy()
        ParticleManager:DestroyParticle(self.pfx, true)
    end
end



function modifier_Advanced_Electrostatic_Armor_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end


function modifier_Advanced_Electrostatic_Armor_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		if not self.only_magic then
			return self:GetStackCount()
		else
			return 0
		end
		
	end
	if keys.block_disabled then
        return 0 
    end
	local parent = self:GetParent()
	if keys.attacker:GetTeamNumber()==parent:GetTeamNumber() then
		return 0
	end

	if self.only_magic and keys.damage_type~=DAMAGE_TYPE_MAGICAL then
		return 0
	end
	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage+1
	end
	if keys.damage>=100 and self:GetAbility().advanced_level>=15 then
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return stack
		end
		if  keys.attacker:IsMagicImmune() or  keys.attacker:IsInvulnerable() then
			return stack
		end

		local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/electrostatic_armor/lv15/effect_attack_light_ti_5.vpcf", PATTACH_POINT_FOLLOW,parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.attacker:EmitSound("Hero_Pugna.NetherWard.Attack.Wight")
		local tDamage = {
			ability = self:GetAbility(),
			attacker =self:GetCaster(),
			victim = keys.attacker,
			damage = self:GetCaster():GetStrength()*2,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			-- damage_flag = DOTA_DAMAGE_FLAG_REFLECTION,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION,
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}
		ApplyDamage(tDamage)
	end
	return stack
end




modifier_Advanced_Electrostatic_Armor_unlock2_buff = class({})

function modifier_Advanced_Electrostatic_Armor_unlock2_buff:IsHidden()	return false end
function modifier_Advanced_Electrostatic_Armor_unlock2_buff:IsDebuff()	return false end
function modifier_Advanced_Electrostatic_Armor_unlock2_buff:IsPurgable()	return false end
function modifier_Advanced_Electrostatic_Armor_unlock2_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_Advanced_Electrostatic_Armor_unlock2_buff:GetModifierPreAttack_BonusDamage()	return math.min(self:GetStackCount(),self.max) end


function modifier_Advanced_Electrostatic_Armor_unlock2_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.max = 6000
	if self:GetParent():IsRealHero() then
		self.max = 3000
	end
	if IsServer() then
		self.tData = {}
		local bonus = keys.index
		if self:GetParent():IsRealHero() then
			bonus = math.floor(bonus*0.5)
		end
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack =bonus })
		self:SetStackCount(bonus)
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Electrostatic_Armor_unlock2_buff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		local bonus = keys.index
		if self:GetParent():IsRealHero() then
			bonus = math.floor(bonus*0.5)
		end
		
		table.insert(self.tData, {dieTime = dieTime,stack = bonus })
		self:SetStackCount(self:GetStackCount()+bonus)
	end
end

function modifier_Advanced_Electrostatic_Armor_unlock2_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
	
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
			end
		end
	end
end


















modifier_Advanced_Electrostatic_Armor_unlock3= class({})

function modifier_Advanced_Electrostatic_Armor_unlock3:IsDebuff()			return false end
function modifier_Advanced_Electrostatic_Armor_unlock3:IsHidden() 			return true end
function modifier_Advanced_Electrostatic_Armor_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Electrostatic_Armor_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Electrostatic_Armor_unlock3:RemoveOnDeath() return false end

function modifier_Advanced_Electrostatic_Armor_unlock3:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		local ability = self:GetAbility()

		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_Advanced_Electrostatic_Armor_unlock3_buff", {})


	end
end

modifier_Advanced_Electrostatic_Armor_unlock3_buff = advanced_modifier({})
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:IsHidden() return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:IsDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:IsPurgable() 		return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:IsPurgeException() 	return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:RemoveOnDeath()  return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:IsStunDebuff() return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:AllowIllusionDuplicate() return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:DestroyOnExpire() return false end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:DeclareFunctions() return
    {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or self.magic_res end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:OnCreated(keys)
	self.magic_res = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance")
end	

function modifier_Advanced_Electrostatic_Armor_unlock3_buff:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if keys.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then
		return
	end
	if self:GetRemainingTime()>0 then
		return
	end

    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	if not ability:IsCooldownReady() then
		return
	end
	local require = ability:GetSpecialValueFor("damage_require")*0.01
	if ability.advanced_level>=5 then
		require = 0.08
	end
    --判断累计伤害是否达到触发线
    if self:GetStackCount() > caster:GetMaxHealth()*require then
        caster:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Electrostatic_Armor_spell", {unlock3 = 1})
        self:SetStackCount(0)
		-- :UseResources(true, true, true, true)
		self:SetDuration(2, true)
    end
end


-- function modifier_Advanced_Electrostatic_Armor_unlock3_buff:GetModifierMagical_ConstantBlock() 
-- 	local parent = self:GetCaster()
-- 	local ability = self:GetAbility()
-- 	if not ability then
-- 		self:SafeDestroy()
-- 		return
-- 	end
-- 	if ability:GetSpecialValueFor("advanced_level")<20 then
-- 		return
-- 	end

-- 	local block = parent:GetStrength()
-- 	if parent:HasModifier("modifier_Advanced_dragon_blood") or parent:HasModifier("modifier_Middle_dragon_blood") then
-- 		block = block * 7
-- 	else
-- 		block = block * 3
-- 	end
-- 	return block
-- end



function modifier_Advanced_Electrostatic_Armor_unlock3_buff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MAGACIAL_BLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Advanced_Electrostatic_Armor_unlock3_buff:Advanced_GetModifierMagicalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	local parent = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	if ability:GetSpecialValueFor("advanced_level")<20 then
		return
	end

	local block = parent:GetStrength()
	if parent:HasModifier("modifier_Advanced_dragon_blood") or parent:HasModifier("modifier_Middle_dragon_blood") then
		block = block * 7
	else
		block = block * 3
	end
	return block
end
