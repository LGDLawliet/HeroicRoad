--特效优化 √

Advanced_Haunt = class({})


LinkLuaModifier("modifier_Advanced_Haunt_illusion", "skills/Advanced_Haunt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Haunt_shield", "skills/Advanced_Haunt", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Haunt_unlock2", "skills/Advanced_Haunt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Haunt_unlock3", "skills/Advanced_Haunt", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Haunt_damage", "skills/Advanced_Haunt", LUA_MODIFIER_MOTION_NONE)
function Advanced_Haunt:IsHiddenWhenStolen() 		return false end
function Advanced_Haunt:IsRefreshable() 			return true end
function Advanced_Haunt:IsStealable() 				return true end
function Advanced_Haunt:IsNetherWardStealable()		return false end
function Advanced_Haunt:CheckKV(key)
	local table = {

	
		damage =0.02,


	}
	local value = table[key] or -1
	return value

end



-- function Advanced_Haunt:UnlockFirstCore(key)
-- 	self.unlock1_timer = GameRules:GetGameTime()
-- 	-- local caster = self:GetCaster()
-- 	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Battle_Hunger_unlock3",{})
-- 	return true
-- end
function Advanced_Haunt:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Haunt_unlock2",{})
	return true
end
function Advanced_Haunt:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Haunt_unlock3",{})
	return true
end
function Advanced_Haunt:Unlock1Effect(source,target)
	if GameRules:GetGameTime()>=self.unlock1_timer then
		local caster = self:GetCaster()
		if caster:GetRandomEffect(5,INT_TYPE,1)  > RandomInt(1, 100) then
			local ability = caster:FindAbilityByName("Advanced_Spectral_Dagger")
			if ability then
				ability:CreateDagger(source,target)
			end
			self.unlock1_timer = GameRules:GetGameTime() + 1
		end
	end
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Berserkers_Call_unlock3",{})
	return true
end




function Advanced_Haunt:OnSpellStart()
	local caster = self:GetCaster()
	--spe 音效
	caster:EmitSound("Hero_Spectre.HauntCast")
	--获取全地图敌人位置和视野
	local heroes = GetAllRealHeroes()
	local modifierKeys = {}
	modifierKeys.outgoing_damage = -100
	modifierKeys.incoming_damage = 0
	modifierKeys.duration = 100  --提高初始时间以自由控制存在时间
	for _, hero in pairs(heroes) do
		-- local illusion = CreateIllusions( caster, caster, modifierKeys, 1, 100, true, true)

		local illusion = caster:MakeCustomIllusion()
		-- illusion[1]:SetControllableByPlayer(-1, true)	
		illusion:AddNewModifier(hero, self, "modifier_Advanced_Haunt_illusion", {duration = self:GetSpecialValueFor("duration")})
	end

end


modifier_Advanced_Haunt_illusion = class({})

function modifier_Advanced_Haunt_illusion:IsDebuff()			return false end
function modifier_Advanced_Haunt_illusion:IsHidden() 			return false end
function modifier_Advanced_Haunt_illusion:IsPurgable() 		return false end
function modifier_Advanced_Haunt_illusion:IsPurgeException() 	return false end
function modifier_Advanced_Haunt_illusion:CheckState() return 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_UNSELECTABLE] = true, 
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	} 
end

function modifier_Advanced_Haunt_illusion:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,

} end
function modifier_Advanced_Haunt_illusion:GetModifierMoveSpeedBonus_Percentage() return 1000 end
function modifier_Advanced_Haunt_illusion:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_Advanced_Haunt_illusion:GetModifierAttackSpeedBonus_Constant() return math.min(self:GetStackCount()*4,250) end
function modifier_Advanced_Haunt_illusion:GetModifierAttackSpeedBaseOverride(keys)
	return self:GetCaster():GetAttackSpeed(false)
end

function modifier_Advanced_Haunt_illusion:OnCreated(keys)
	if IsServer() then
		self.level = self:GetAbility().advanced_level
		self:StartIntervalThink(1)
		self.bonus_life = 0
		if keys.unlock2 then
			self.unlock2 = true
		end

	end
end

function modifier_Advanced_Haunt_illusion:OnDestroy(keys)
	if IsServer() then
		-- self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_kill", {duration = 0})
		local parent = self:GetParent()
		UTIL_Remove( parent )
	end
end





function modifier_Advanced_Haunt_illusion:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		-- local parent = self:GetParent()
		self:SafeDestroy()
		-- parent:ForceKill(false)
		
		return
	end
	local caster = self:GetAbility():GetCaster()  --技能的拥有者
	local parent = self:GetCaster()               --幻象跟随者
	local parent_pos = parent:GetAbsOrigin()      --幻象跟随者位置
	local self_pos = self:GetParent():GetAbsOrigin()--幻象位置
	local distance = (parent_pos - self_pos):Length2D()
	--距离太远就走进跟随者
	if distance >1500 then 
		self:GetParent():SetForceAttackTarget(nil) 
		self:GetParent():MoveToPosition(parent_pos)
		return
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	 if #enemy>0 and enemy[1]:IsAlive() then
		  self:GetParent():SetForceAttackTarget(enemy[1])
	 else
		self:GetParent():SetForceAttackTarget(nil)
	 end
end



function modifier_Advanced_Haunt_illusion:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local target = keys.target
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local caster = ability:GetCaster()  --这里获取到的是技能拥有者
	
	local damage = (ability:GetSpecialValueFor( "damage" )) * caster:HDGetPrimaryStatValue()
	local shield_duration = ability:GetSpecialValueFor( "shield_duration" )
	local shield = ability:GetSpecialValueFor( "shield" )*0.01
	--LV15解锁能量汲取
	if self.level>=15 then
		damage = damage + self:GetCaster():GetAgility()*0.5
	end
	-- local damage_type = ability:GetAbilityDamageType()
	target:EmitSound("Hero_Terrorblade.Reflection")

	-- local damageTable = {
	-- 	victim = target,
	-- 	attacker = caster,
	-- 	damage = damage,
	-- 	damage_type = damage_type,
	-- 	damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	-- 	ability = ability, --Optional.
	-- 	}

	target:AddNewModifier(caster, ability, "modifier_Advanced_Haunt_damage", {stack = damage})
			

	local damage_absorb = shield
	if self.level>=10 then
		damage_absorb = 0.25
	end
	local damage2 = damage*damage_absorb
	damage2 = damage2 - damage2%1
	local ModifierStatusGain =caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, ability, "modifier_Advanced_Haunt_shield",
	{duration=shield_duration*ModifierStatusGain,index=damage2})


	--LV5解锁无尽能量+
	if self.level>=5 then
		self:IncrementStackCount()
	end

	--LV20解锁无尽能量++
	if self.level>=20 and self.bonus_life<10 and not self.unlock2 then
		self.bonus_life = self.bonus_life +0.2
		self:SetDuration(self:GetRemainingTime()+0.2, true)
	end


	if ability.unlock1 then
		ability:Unlock1Effect(self:GetParent(),target)
	end
end





modifier_Advanced_Haunt_shield = advanced_modifier({})
function modifier_Advanced_Haunt_shield:IsHidden() return false end
function modifier_Advanced_Haunt_shield:IsDebuff() return false end
function modifier_Advanced_Haunt_shield:IsPurgable() return false end
function modifier_Advanced_Haunt_shield:IsPurgeException() return false end
function modifier_Advanced_Haunt_shield:IsStunDebuff() return false end
function modifier_Advanced_Haunt_shield:AllowIllusionDuplicate() return false end
function modifier_Advanced_Haunt_shield:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

function modifier_Advanced_Haunt_shield:OnCreated(keys)
    if not IsServer() then
        return
    end
    self:SetStackCount(keys.index)
    self:StartIntervalThink(0.2)
end

function modifier_Advanced_Haunt_shield:OnRefresh(keys)
    if not IsServer() then
        return
    end
    self:SetStackCount(self:GetStackCount()+keys.index)
end


function modifier_Advanced_Haunt_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_Advanced_Haunt_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return self:GetStackCount()
	end
	if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack
end





function modifier_Advanced_Haunt_shield:OnIntervalThink()
    if not IsServer() then
        return
    end
    if self:GetStackCount()<=0 then
        self:SafeDestroy()
    end
end



modifier_Advanced_Haunt_unlock2 = class({})


function modifier_Advanced_Haunt_unlock2:IsHidden()	return false end
function modifier_Advanced_Haunt_unlock2:IsDebuff()	return false end
function modifier_Advanced_Haunt_unlock2:IsStunDebuff()	return false end
function modifier_Advanced_Haunt_unlock2:RemoveOnDeath()	return false end
function modifier_Advanced_Haunt_unlock2:DestroyOnExpire()	return false end
function modifier_Advanced_Haunt_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Haunt_unlock2:IsPurgeException() 	return false end

function modifier_Advanced_Haunt_unlock2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_Advanced_Haunt_unlock2:OnCreated()
	if IsServer() then
		self.tData = {}
		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Haunt_unlock2:CreatePhantom()
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+3
	
		
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		local caster = self:GetCaster()
		caster:EmitSound("Hero_Spectre.HauntCast")
		-- local modifierKeys = {}
		-- modifierKeys.outgoing_damage = -100
		-- modifierKeys.incoming_damage = 0
		-- modifierKeys.duration = 100  --提高初始时间以自由控制存在时间
		-- local illusion = CreateIllusions( caster, caster, modifierKeys, 1, 100, true, false)
		-- illusion[1]:SetControllableByPlayer(-1, true)	
		local illusion = caster:MakeCustomIllusion()
		illusion:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Haunt_illusion", {duration = 3,unlock2= 1})

	end
end

function modifier_Advanced_Haunt_unlock2:OnIntervalThink()
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




function modifier_Advanced_Haunt_unlock2:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	-- local ability = self:GetAbility()
	local caster = self:GetParent()
	if self:GetCaster():GetRandomEffect(5,INT_TYPE,1)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
			return
		end
		if self:GetStackCount()<6 then
			self:CreatePhantom()
		end



				
		
	end

	
end




modifier_Advanced_Haunt_unlock3 = class({})


function modifier_Advanced_Haunt_unlock3:IsHidden()	return true end
function modifier_Advanced_Haunt_unlock3:IsDebuff()	return false end
function modifier_Advanced_Haunt_unlock3:IsStunDebuff()	return false end
function modifier_Advanced_Haunt_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_Haunt_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_Haunt_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Haunt_unlock3:IsPurgeException() 	return false end

function modifier_Advanced_Haunt_unlock3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_Advanced_Haunt_unlock3:OnCreated()
	if IsServer() then
		self:StartIntervalThink(10)
	end
end
function modifier_Advanced_Haunt_unlock3:CreatePhantom()
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+3
	
		
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
		local caster = self:GetCaster()
		caster:EmitSound("Hero_Spectre.HauntCast")
		-- local modifierKeys = {}
		-- modifierKeys.outgoing_damage = -100
		-- modifierKeys.incoming_damage = 0
		-- modifierKeys.duration = 100  --提高初始时间以自由控制存在时间
		-- local illusion = CreateIllusions( caster, caster, modifierKeys, 1, 100, true, false)
		-- illusion[1]:SetControllableByPlayer(-1, true)	
		local illusion = caster:MakeCustomIllusion()
		illusion:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Haunt_illusion", {duration = 3,unlock2= 1})

	end
end

function modifier_Advanced_Haunt_unlock3:OnIntervalThink()

	if self.phantom1 and not self.phantom1:IsNull() then
		self.phantom1:SetDuration(0,false)
	end
	if self.phantom2 and not self.phantom2:IsNull() then
		self.phantom2:SetDuration(0,false)
	end
	if self.phantom3 and not self.phantom3:IsNull() then
		self.phantom3:SetDuration(0,false)
	end
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Spectre.HauntCast")
	-- local modifierKeys = {}
	-- modifierKeys.outgoing_damage = -100
	-- modifierKeys.incoming_damage = 0
	-- modifierKeys.duration = 100  --提高初始时间以自由控制存在时间
	-- local illusion = CreateIllusions( caster, caster, modifierKeys, 3, 100, true, false)
	-- illusion[1]:SetControllableByPlayer(-1, true)	
	local illusion = {}
	illusion[1] =  caster:MakeCustomIllusion()
	illusion[2] =  caster:MakeCustomIllusion()
	illusion[3] =  caster:MakeCustomIllusion()
	self.phantom1 = illusion[1]:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Haunt_illusion", {duration = 10,unlock2= 1})
	self.phantom2 = illusion[2]:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Haunt_illusion", {duration = 10,unlock2= 1})
	self.phantom3 = illusion[3]:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Haunt_illusion", {duration = 10,unlock2= 1})
	illusion[1]:SetOrigin(caster:GetOrigin()+Vector(RandomInt(-200, 200),RandomInt(-200, 200),0))
	illusion[2]:SetOrigin(caster:GetOrigin()+Vector(RandomInt(-200, 200),RandomInt(-200, 200),0))
	illusion[3]:SetOrigin(caster:GetOrigin()+Vector(RandomInt(-200, 200),RandomInt(-200, 200),0))
end




modifier_Advanced_Haunt_damage = class({})

function modifier_Advanced_Haunt_damage:IsDebuff() return true end
function modifier_Advanced_Haunt_damage:IsHidden() return false end
function modifier_Advanced_Haunt_damage:IsPurgable() return false end
function modifier_Advanced_Haunt_damage:IsPurgeException() return false end
function modifier_Advanced_Haunt_damage:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_Haunt_damage:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)

	end
end
function modifier_Advanced_Haunt_damage:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end

	self:GetParent():EmitSound("Hero_Terrorblade.Reflection")
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
		}
	ApplyDamage(damageTable)

	self:SetStackCount(0)
	self:SafeDestroy()
end
