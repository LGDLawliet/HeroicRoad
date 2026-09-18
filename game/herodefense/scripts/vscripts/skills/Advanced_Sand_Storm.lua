--特效优化 √
Advanced_Sand_Storm = class({})

LinkLuaModifier("modifier_Advanced_Sand_Storm_caster", "skills/Advanced_Sand_Storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Sand_Storm_motion", "skills/Advanced_Sand_Storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Sand_Storm", "skills/Advanced_Sand_Storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Sand_Storm_unlock1", "skills/Advanced_Sand_Storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Sand_Storm_unlock1_thinker", "skills/Advanced_Sand_Storm", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Sand_Storm_unlock3", "skills/Advanced_Sand_Storm", LUA_MODIFIER_MOTION_NONE)
function Advanced_Sand_Storm:CheckKV(key)
	local table = {
		damage=2,
		bonus_damage=0.02,



	}
	local value = table[key] or -1
	return value

end





function Advanced_Sand_Storm:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock1",{})
	return true
end
function Advanced_Sand_Storm:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Sand_Storm:UnlockThirdCore(key)
	local heroes = GetAllRealHeroes()
	local caster = self:GetCaster()
	for _, unit in ipairs(heroes) do
		if unit:HasModifier("modifier_Advanced_Sand_Storm_unlock3") then
			self.CoreUnlock = false
			self.unlock3 = false
			SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		end
	end


	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Sand_Storm_unlock3",{})
	return true

end







function Advanced_Sand_Storm:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/sand_storm/unlock1/effect_snow.vpcf", context )
end
function Advanced_Sand_Storm:IsHiddenWhenStolen() 		return false end
function Advanced_Sand_Storm:IsRefreshable() 			return true end
function Advanced_Sand_Storm:IsStealable() 			return true end
function Advanced_Sand_Storm:IsNetherWardStealable()	return true end
function Advanced_Sand_Storm:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function Advanced_Sand_Storm:OnSpellStart()
	local caster = self:GetCaster()
	local thinker = CreateModifierThinker(caster, self, "modifier_Advanced_Sand_Storm", {duration = self:GetSpecialValueFor("max_duration")}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	caster:EmitSound("Ability.SandKing_SandStorm.start")
	if self.advanced_level>=5 then
		local modifier = thinker:FindModifierByName("modifier_Advanced_Sand_Storm")
		if modifier then
			modifier:StartIntervalThink(self:GetSpecialValueFor("damage_tick"))
		end
	end
end

function Advanced_Sand_Storm:OnChannelFinish(bInterrupted)
	local buff = self:GetCaster():FindModifierByName("modifier_sand_storm_caster")
	if buff then
		buff:StartIntervalThink(-1)
		buff:SetDuration(self:GetSpecialValueFor("invis_duration"), true)
	end
end

modifier_Advanced_Sand_Storm = class({})

function modifier_Advanced_Sand_Storm:IsAura() return true end
function modifier_Advanced_Sand_Storm:GetAuraDuration() return self.invis_duration end
function modifier_Advanced_Sand_Storm:GetModifierAura() return "modifier_Advanced_Sand_Storm_caster" end
function modifier_Advanced_Sand_Storm:GetAuraRadius() return self.radius end
function modifier_Advanced_Sand_Storm:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Sand_Storm:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Sand_Storm:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_Advanced_Sand_Storm:GetAuraEntityReject(unit) return self:GetCaster() ~= unit end

function modifier_Advanced_Sand_Storm:OnCreated(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.invis_duration = self.ability:GetSpecialValueFor("invis_duration")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.interval = self.ability:GetSpecialValueFor("damage_tick")
	self.count = self.ability:GetSpecialValueFor("count")
	self.burning = self.ability:GetSpecialValueFor("burning")
	if self.ability:GetSpecialValueFor("advanced_level") >= 15 then
		self.radius = self.radius *1.2
	end
	if IsServer() then
		if keys.unlock3 then
			self.radius = 300
		end
		self.advanced_level =self:GetAbility().advanced_level
		self.parent:EmitSound("Ability.SandKing_SandStorm.loop")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius * 1.15, 1, 1))
		self:AddParticle(pfx, false, false, 15, false, false)
		if self:GetAbility().unlock2 then
			self.unlock2  = true
		end
	end
end

function modifier_Advanced_Sand_Storm:OnIntervalThink()
	local ability = self:GetAbility()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local tick =  self.interval
	local damage = self.damage + self.bonus_damage*self.caster:HDGetPrimaryStatValue()*self.interval
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil,self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		-- victim = enemy,
		attacker = caster,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = ability, --Optional.
	}
	local burning = self.burning*self.caster:GetStrength()
	local max = self.radius -100

	for i, enemy in pairs(enemies) do

		--这个以后作为额外效果
		if self.unlock2  then
			enemy:AddNewModifier(parent, ability, "modifier_Advanced_Sand_Storm_motion", {duration = tick+FrameTime()})

			local dis = CalculateDistance(parent,enemy)
			-- damageTable.damage = damage
			local damage_index = 1
			if dis>=max then
				damage_index = 3
			elseif dis<=75 then
				damage_index = 1
			else
				damage_index = 1+(dis-75)*0.0032
			end
			
		
			damageTable.damage = damage * damage_index			
		end
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		local burning = self.burning*self.caster:GetStrength()
		if self.advanced_level>=10 and (enemy:IsStunned() or enemy:IsRooted()) then
			burning = math.max(burning, self.burning*self.caster:GetAgility())
			burning = math.max(burning, self.burning*self.caster:GetIntellect(false))
		end

		enemy:Burning(self.caster, self.ability, burning)
		--LV15解锁巨型沙尘暴
		if self.advanced_level<15 and i>=self.count then
			break
		end
	end
end

function modifier_Advanced_Sand_Storm:OnDestroy()
	if IsServer() then
		-- self:GetParent():StopSound("Imba.SandKingSandStorm")
		self:GetParent():StopSound("Ability.SandKing_SandStorm.loop")
		UTIL_Remove(self:GetParent())
	end
end





modifier_Advanced_Sand_Storm_caster = advanced_modifier({})

function modifier_Advanced_Sand_Storm_caster:IsDebuff()			return false end
function modifier_Advanced_Sand_Storm_caster:IsHidden() 		return false end
function modifier_Advanced_Sand_Storm_caster:IsPurgable() 		return false end
function modifier_Advanced_Sand_Storm_caster:IsPurgeException() return false end
function modifier_Advanced_Sand_Storm_caster:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Sand_Storm_caster:OnCreated()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if IsServer() then
		local modifier= self:GetAuraOwner():FindModifierByName("modifier_Advanced_Sand_Storm")
		if modifier then
			modifier:StartIntervalThink(self:GetAbility():GetSpecialValueFor("damage_tick"))
		end
	end
end

function modifier_Advanced_Sand_Storm_caster:OnDestroy()
	if IsServer() and self:GetAuraOwner()~=nil then
		--LV5解锁生命的碎片+
		if self.advanced_level<5 then
			local modifier= self:GetAuraOwner():FindModifierByName("modifier_Advanced_Sand_Storm")
			if modifier then
				modifier:StartIntervalThink(-1)
			end
		end
	end
end

function modifier_Advanced_Sand_Storm_caster:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
    }
end
function modifier_Advanced_Sand_Storm_caster:GetModifierEvasion_Constant()
	if not self:GetAbility() then
		return 0
	end
    return 40
end


modifier_Advanced_Sand_Storm_motion = class({})

function modifier_Advanced_Sand_Storm_motion:IsDebuff()			return true end
function modifier_Advanced_Sand_Storm_motion:IsHidden() 		return true end
function modifier_Advanced_Sand_Storm_motion:IsPurgable() 		return true end
function modifier_Advanced_Sand_Storm_motion:IsPurgeException() return true end
-- function modifier_Advanced_Sand_Storm_motion:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Sand_Storm_motion:IsMotionController() return true end
function modifier_Advanced_Sand_Storm_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_Advanced_Sand_Storm_motion:OnCreated()
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_Sand_Storm_motion:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if not caster then
		self:SafeDestroy()
		return
	end
	local distance = 300
	if CalculateDistance(parent,caster)>=self.radius-150 then
		return
	end
	distance = distance / (self:GetDuration() / FrameTime())
	local next_pos =parent:GetAbsOrigin() - (caster:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized() * distance
	self:GetParent():SetOrigin(next_pos)
	FindClearSpaceForUnit(parent, next_pos, true)
end

function modifier_Advanced_Sand_Storm_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end

function modifier_Advanced_Sand_Storm_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,    
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end

function modifier_Advanced_Sand_Storm_motion:GetModifierMiss_Percentage()
	return 50
end

function modifier_Advanced_Sand_Storm_motion:GetModifierMoveSpeedBonus_Percentage() 	return -50 end






modifier_Advanced_Sand_Storm_unlock1 = class({})

function modifier_Advanced_Sand_Storm_unlock1:IsDebuff()			return false end
function modifier_Advanced_Sand_Storm_unlock1:IsHidden() 			return true end
function modifier_Advanced_Sand_Storm_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Sand_Storm_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Sand_Storm_unlock1:RemoveOnDeath() return false end

function modifier_Advanced_Sand_Storm_unlock1:OnCreated() 
	if IsServer() then

		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local thinker = CreateModifierThinker(caster, ability, "modifier_Advanced_Sand_Storm_unlock1_thinker", {}, Vector(-300,-1053,896), caster:GetTeamNumber(), false)
		caster:EmitSound("Ability.SandKing_SandStorm.start")
		local modifier = thinker:FindModifierByName("modifier_Advanced_Sand_Storm_unlock1_thinker")
		if modifier then
			modifier:StartIntervalThink(ability:GetSpecialValueFor("damage_tick"))
		end
		

		
	end

end






modifier_Advanced_Sand_Storm_unlock1_thinker = class({})

function modifier_Advanced_Sand_Storm_unlock1_thinker:IsAura() return true end
function modifier_Advanced_Sand_Storm_unlock1_thinker:GetAuraDuration() return self.invis_duration end
function modifier_Advanced_Sand_Storm_unlock1_thinker:GetModifierAura() return "modifier_Advanced_Sand_Storm_caster" end
function modifier_Advanced_Sand_Storm_unlock1_thinker:GetAuraRadius() return self.radius end
function modifier_Advanced_Sand_Storm_unlock1_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Advanced_Sand_Storm_unlock1_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Advanced_Sand_Storm_unlock1_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_Advanced_Sand_Storm_unlock1_thinker:GetAuraEntityReject(unit) return self:GetCaster() ~= unit end

function modifier_Advanced_Sand_Storm_unlock1_thinker:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.invis_duration = self.ability:GetSpecialValueFor("invis_duration")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.interval = self.ability:GetSpecialValueFor("damage_tick")
	self.count = self.ability:GetSpecialValueFor("count")
	self.burning = self.ability:GetSpecialValueFor("burning")
	if IsServer() then
		self.radius = 10000
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/sand_storm/unlock1/effect_snow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(5000,5000,5000) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end

function modifier_Advanced_Sand_Storm_unlock1_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	local damage = self.damage + self.bonus_damage * self.caster:HDGetPrimaryStatValue()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,10000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		-- victim = enemy,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
	}
	for i, enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		if i>=30 then
			break
		end
	end
end

function modifier_Advanced_Sand_Storm_unlock1_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Ability.SandKing_SandStorm.loop")
		UTIL_Remove(self:GetParent())
	end
end




modifier_Advanced_Sand_Storm_unlock3 = class({})

function modifier_Advanced_Sand_Storm_unlock3:IsDebuff()			return false end
function modifier_Advanced_Sand_Storm_unlock3:IsHidden() 			return true end
function modifier_Advanced_Sand_Storm_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Sand_Storm_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Sand_Storm_unlock3:RemoveOnDeath()  return false end
function modifier_Advanced_Sand_Storm_unlock3:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_Advanced_Sand_Storm_unlock3:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
		return
	end

	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local count = 1
	local name =  keys.ability:GetAbilityName()
	if name=="Advanced_Burrow_Strike" or name=="Advanced_Epicenter" or name=="Middle_Burrow_Strike" or name=="Middle_Epicenter"  or name=="Primary_Burrow_Strike" or name=="Primary_Epicenter" then
		count = 3
	end
	local pos = caster:GetOrigin()
	for i = 1, count, 1 do
		local new_pos = pos + Vector(RandomInt(-700, 700),RandomInt(-700, 700),0)
		local thinker = CreateModifierThinker(caster, ability, "modifier_Advanced_Sand_Storm", {duration = 10,unlock3=1}, new_pos, caster:GetTeamNumber(), false)
		caster:EmitSound("Ability.SandKing_SandStorm.start")
		local modifier = thinker:FindModifierByName("modifier_Advanced_Sand_Storm")
		if modifier then
			modifier:StartIntervalThink(ability:GetSpecialValueFor("damage_tick"))
		end
	end
	
end


