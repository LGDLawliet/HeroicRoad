
Advanced_Liquid_Frost = class({})

LinkLuaModifier("modifier_Advanced_Liquid_Frost", "skills/Advanced_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Frost_effect", "skills/Advanced_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Frost_sub", "skills/Advanced_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Frost_orb", "skills/Advanced_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Frost_damage_counter", "skills/Advanced_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Frost_damage", "skills/Advanced_Liquid_Frost", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------
function Advanced_Liquid_Frost:CheckKV(key)
	local table = {

	


		move_slow = 2,
		bonus_damage = 0.5,

		radius = 4,
		duration = 0.1,



	}
	local value = table[key] or -1
	return value

end


function Advanced_Liquid_Frost:UnlockFirstCore(key)
	self.count = GameRules:GetGameTime()
	return true
end
function Advanced_Liquid_Frost:UnlockSecondCore(key)
	return true
end
function Advanced_Liquid_Frost:UnlockThirdCore(key)
	return true
end

function Advanced_Liquid_Frost:IsHiddenWhenStolen() 		return false end
function Advanced_Liquid_Frost:IsRefreshable() 			return true end
function Advanced_Liquid_Frost:IsStealable() 				return false end
function Advanced_Liquid_Frost:IsNetherWardStealable() 	return false end
--下为自动施法
function Advanced_Liquid_Frost:GetIntrinsicModifierName() return "modifier_Advanced_Liquid_Frost_orb" end
function Advanced_Liquid_Frost:GetCooldown(iLevel)
	if IsServer() then
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			if self:GetUnlock(2)==2 then
				return 7 - modifier:GetSpecialValueFor("ice_cd_reduce") - 1
			end
			return 7 - modifier:GetSpecialValueFor("ice_cd_reduce")
		end
		if self:GetUnlock(2)==2 then
			return 5
		end
		return 7
	end
	
end
function Advanced_Liquid_Frost:GetManaCost(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			return 0
		end
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end

function Advanced_Liquid_Frost:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) end
function Advanced_Liquid_Frost:GetAbilityTextureName() return "jakiro_Liquid_Ice" end
--主动的施法
function Advanced_Liquid_Frost:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf",
		iMoveSpeed = 1200,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function Advanced_Liquid_Frost:OnProjectileHit(target, location)
	if not target then
		return
	end
	local level = self.advanced_level
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local effect_number = self:GetSpecialValueFor("effect_number")
	local effect_number_count = 0
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	local radius = self:GetSpecialValueFor("radius")
	--LV15解锁增幅化
	if level>=15 and ModifierStatusNegativeGain>1 then
		duration = duration *ModifierStatusNegativeGain
	end
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 特效
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
	ParticleManager:SetParticleControl(pfx, 2, Vector(radius*2, radius*2, radius*2))
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFrost", target)
	if self.unlock3 then
		duration = -1
	end
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_Advanced_Liquid_Frost", {duration = duration})
		enemy:AddNewModifier(caster, self, "modifier_Advanced_Liquid_Frost_damage", {duration = duration})
		effect_number_count = effect_number_count + 1
		if  not self.unlock2 and effect_number_count >= effect_number then
			return
		end
    end
end


function Advanced_Liquid_Frost:AddDebuff(caster,target)
	local duration = self:GetSpecialValueFor("duration")
	--LV15解锁增幅化
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	if self.advanced_level>=15 and ModifierStatusNegativeGain>1 then
		duration = duration *ModifierStatusNegativeGain
	end
	if self.unlock3 then
		duration = -1
	end
	target:AddNewModifier(caster, self, "modifier_Advanced_Liquid_Frost", {duration = duration})
	target:AddNewModifier(caster, self, "modifier_Advanced_Liquid_Frost_damage", {duration = duration})
end



modifier_Advanced_Liquid_Frost = advanced_modifier({})

function modifier_Advanced_Liquid_Frost:IsDebuff()			return true end
function modifier_Advanced_Liquid_Frost:IsHidden() 			return false end
function modifier_Advanced_Liquid_Frost:IsPurgable()         return true end
function modifier_Advanced_Liquid_Frost:IsPurgeException() 	return true end
function modifier_Advanced_Liquid_Frost:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Advanced_Liquid_Frost:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Liquid_Frost:OnCreated()
	local ability = self:GetAbility()
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage") 
	self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow") 
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("split_interval"))
	end
end

function modifier_Advanced_Liquid_Frost:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability:GetSpecialValueFor("split_radius"),
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if ability.unlock3  then
		return
	end
	for _, enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_Advanced_Liquid_Frost_sub")  and enemy ~= target then
			local pfx_wave = "particles/new_effect/new_effect/new_liquid_ice_split.vpcf"
			local pfx = ParticleManager:CreateParticle(pfx_wave, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			enemy:AddNewModifier(caster, ability, "modifier_Advanced_Liquid_Frost_sub", {duration = ability:GetSpecialValueFor("duration") * 2})
			return
		end
	end
end

function modifier_Advanced_Liquid_Frost:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Advanced_Liquid_Frost:GetModifierMoveSpeedBonus_Constant() return self.move_slow end
function modifier_Advanced_Liquid_Frost:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_damage 
end


function modifier_Advanced_Liquid_Frost:ADDeclareFunctions()

	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end









modifier_Advanced_Liquid_Frost_orb = class({})

function modifier_Advanced_Liquid_Frost_orb:IsDebuff()			return false end
function modifier_Advanced_Liquid_Frost_orb:IsHidden() 			return true end
function modifier_Advanced_Liquid_Frost_orb:IsPurgable() 		return false end
function modifier_Advanced_Liquid_Frost_orb:IsPurgeException() 	return false end
function modifier_Advanced_Liquid_Frost_orb:OnCreated()
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_Advanced_Liquid_Frost_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)
			self.pfx2 = nil
		end
	end
end
function modifier_Advanced_Liquid_Frost_orb:DeclareFunctions()
	 return 
	 {MODIFIER_EVENT_ON_ATTACK,
	  MODIFIER_EVENT_ON_ATTACK_LANDED,} end
function modifier_Advanced_Liquid_Frost_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsSilenced() or self:GetParent():IsIllusion()
	 or not self:GetAbility():IsCooldownReady() or not self:GetAbility():GetAutoCastState() then
		return
	end
	self:SetStackCount(1)
	self:GetParent():StartGesture(ACT_DOTA_ATTACK2)
	self:GetAbility():UseResources(true, true, true,true)
end
function modifier_Advanced_Liquid_Frost_orb:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() then
		return
	end
	if self:GetStackCount() ~= 1 then
		return
	end
	self:SetStackCount(0)
	self:GetAbility():OnProjectileHit(keys.target, keys.target:GetAbsOrigin())
end

--------------------------------------------------------------------------------

modifier_Advanced_Liquid_Frost_damage_counter = class({})

function modifier_Advanced_Liquid_Frost_damage_counter:IsDebuff()				return false end
function modifier_Advanced_Liquid_Frost_damage_counter:IsHidden() 				return true end
function modifier_Advanced_Liquid_Frost_damage_counter:IsPurgable() 			    return true end
function modifier_Advanced_Liquid_Frost_damage_counter:IsPurgeException() 		return true end
function modifier_Advanced_Liquid_Frost_damage_counter:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end

modifier_Advanced_Liquid_Frost_damage = class({})

function modifier_Advanced_Liquid_Frost_damage:IsDebuff()				return false end
function modifier_Advanced_Liquid_Frost_damage:IsHidden() 				return true end
function modifier_Advanced_Liquid_Frost_damage:IsPurgable() 		    	return true end
function modifier_Advanced_Liquid_Frost_damage:IsPurgeException() 		return true end
function modifier_Advanced_Liquid_Frost_damage:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
--设置血量阈值
function modifier_Advanced_Liquid_Frost_damage:OnCreated(table)
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local  explosion_threshold = ability:GetSpecialValueFor("explosion_threshold")
	self.duration = ability:GetSpecialValueFor("explosion_effect_duration")
	--LV10解锁寒气加剧+
	if self.advanced_level>=10 then
		explosion_threshold = 0.07
		self.duration = self.duration+0.5
	end
	--LV20解锁触碰即爆
	if self.advanced_level>=10 then
		explosion_threshold = 0
	end
	self.unitheal = self:GetParent():GetMaxHealth()*explosion_threshold
	self.triger = 1
	if IsServer() then
		if ability.unlock3 then
			self:StartIntervalThink(10)
		end
	end
end
function modifier_Advanced_Liquid_Frost_damage:OnRefresh(table)
	self:OnCreated(table)
end

function modifier_Advanced_Liquid_Frost_damage:OnIntervalThink()
	self.triger = 1
end
-- function modifier_Advanced_Liquid_Frost_damage:Destroy()
-- 	local buffs = self:GetParent():FindAllModifiersByName("modifier_Advanced_Liquid_Frost_damage_counter")
-- 	self.triger = 0
-- 	for _, buff in pairs(buffs) do
-- 		buff:Destroy()
-- 	end
-- end
function modifier_Advanced_Liquid_Frost_damage:OnTakeDamage(keys)
	if not IsServer()  or keys.unit ~= self:GetParent()  or self.triger == 0 then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end
	-- local buff = self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_Advanced_Liquid_Frost_damage_counter", {duration = 10})
	-- if buff ~= nil then 
	-- 	buff:SetStackCount(keys.damage)
	-- end
	-- local buffs = self:GetParent():FindAllModifiersByName("modifier_Advanced_Liquid_Frost_damage_counter")
	self:SetStackCount(self:GetStackCount()+keys.damage)
	local heal = self:GetStackCount()

	-- for _, buff in pairs(buffs) do
	-- 	heal = heal + buff:GetStackCount()
	-- end
	if heal > self.unitheal then
		-- for _, buff in pairs(buffs) do
		-- 	buff:Destroy()
		-- end
		self.triger = 0
		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()
		local ability = self:GetAbility()
		local radius = ability:GetSpecialValueFor("explosion_radius")
		if  ability.unlock1  then
			radius = radius +100
		end
		local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius,
		 DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		 local duration = ability:GetSpecialValueFor("duration")* caster:GetModifierStatusNegativeGainIndex(1)
		for _, enemy in pairs(enemies) do
			local StatusResistance = enemy:GetHDStatusResistanceIndex(0.5)
			enemy:AddNewModifier(caster, ability, "modifier_Advanced_Liquid_Frost_effect", {duration = self.duration*StatusResistance})
			if enemy:IsAlive() and ability.unlock1 and GameRules:GetGameTime()+10>ability.count and  caster:GetRandomEffect(30,INT_TYPE,1) >=RandomInt(1, 100) then
				ability.count = math.max(GameRules:GetGameTime()+0.5,ability.count+0.5)
				enemy:AddNewModifier(caster, ability, "modifier_Advanced_Liquid_Frost", {duration = duration})
				enemy:AddNewModifier(caster, ability, "modifier_Advanced_Liquid_Frost_damage", {duration = duration})
				-- print("trigger")
			end
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_ice_e.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFrost", target)
	end
end
---------------------------------------------------------------------
--冻结
modifier_Advanced_Liquid_Frost_effect = class({})

function modifier_Advanced_Liquid_Frost_effect:IsDebuff()	return true end
function modifier_Advanced_Liquid_Frost_effect:IsHidden()	return false end
function modifier_Advanced_Liquid_Frost_effect:IsPurgable()	return false end
function modifier_Advanced_Liquid_Frost_effect:IsPurgeException()	return true end
function modifier_Advanced_Liquid_Frost_effect:IsStunDebuff() return true end
function modifier_Advanced_Liquid_Frost_effect:GetStatusEffectName()	return "particles/status_fx/status_effect_frost_lich.vpcf"	end
function modifier_Advanced_Liquid_Frost_effect:StatusEffectPriority() return 100	end
function modifier_Advanced_Liquid_Frost_effect:GetEffectName()	return "particles/generic_gameplay/generic_frozen.vpcf"	end
function modifier_Advanced_Liquid_Frost_effect:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW	end
function modifier_Advanced_Liquid_Frost_effect:CheckState()	
	return	{
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true}
end

function modifier_Advanced_Liquid_Frost_effect:OnCreated(table)
	if IsServer() then
		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
	end
end

function modifier_Advanced_Liquid_Frost_effect:OnRefresh(table)
	if IsServer() then
		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
	end
end

--------------------------------------------------------------------
--次级特效
modifier_Advanced_Liquid_Frost_sub = advanced_modifier({})
function modifier_Advanced_Liquid_Frost_sub:IsDebuff()			return true end
function modifier_Advanced_Liquid_Frost_sub:IsHidden() 			return false end
function modifier_Advanced_Liquid_Frost_sub:IsPurgable()         return true end
function modifier_Advanced_Liquid_Frost_sub:IsPurgeException() 	return true end
function modifier_Advanced_Liquid_Frost_sub:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_Advanced_Liquid_Frost_sub:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Liquid_Frost_sub:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Advanced_Liquid_Frost_sub:OnCreated(keys)
	local ability = self:GetAbility()
	self.advanced_level = ability:GetSpecialValueFor("advanced_level")
	local reduce_index = 0.5
	--LV5解锁流动+
	if self.advanced_level>=5 then
		reduce_index = 0.75
	end
	self.bonus_damage = (self:GetAbility():GetSpecialValueFor("bonus_damage") )*reduce_index
	self.move_slow = (-self:GetAbility():GetSpecialValueFor("move_slow") )*reduce_index
end
function modifier_Advanced_Liquid_Frost_sub:GetModifierMoveSpeedBonus_Constant() return self.move_slow end
function modifier_Advanced_Liquid_Frost_sub:Advanced_GetModifierIncomingDamage_Percentage()
	return self.bonus_damage
end



function modifier_Advanced_Liquid_Frost_sub:ADDeclareFunctions()

	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end


