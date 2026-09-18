--特效优化 √
Advanced_Liquid_Fire = class({})

LinkLuaModifier("modifier_Advanced_Liquid_Fire", "skills/Advanced_Liquid_Fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Fire_sub", "skills/Advanced_Liquid_Fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Fire_orb", "skills/Advanced_Liquid_Fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Liquid_Fire_damage", "skills/Advanced_Liquid_Fire", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------
function Advanced_Liquid_Fire:IsHiddenWhenStolen() 		return false end
function Advanced_Liquid_Fire:IsRefreshable() 			return true end
function Advanced_Liquid_Fire:IsStealable() 				return false end
function Advanced_Liquid_Fire:IsNetherWardStealable() 	return false end

function Advanced_Liquid_Fire:CheckKV(key)
	local table = {
		attack_slow = 1,
		basic_damage = 5,
		intelligence_index_per_second = 0.04,
		duration = 0.1,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Liquid_Fire:GetCooldown(iLevel)
	if IsServer() then
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			if self:GetUnlock(2)==2 then
				return 4 - modifier:GetSpecialValueFor("fire_cd_reduce") - 1
			end
			return 4 - modifier:GetSpecialValueFor("fire_cd_reduce")
		end
		if self:GetUnlock(2)==2 then
			return 2
		end
		return 4
	end
	
end

function Advanced_Liquid_Fire:GetManaCost(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_jakiro")
		if modifier then
			return 0
		end
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end

function Advanced_Liquid_Fire:UnlockFirstCore(key)
	self.count = GameRules:GetGameTime()
	return true
end
function Advanced_Liquid_Fire:UnlockSecondCore(key)
	return true
end
function Advanced_Liquid_Fire:UnlockThirdCore(key)
	return true
end

--下为自动施法
function Advanced_Liquid_Fire:GetIntrinsicModifierName() 
	return "modifier_Advanced_Liquid_Fire_orb" 
end

function Advanced_Liquid_Fire:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange(  ) end

function Advanced_Liquid_Fire:GetAbilityTextureName() 
	return "jakiro_liquid_fire" 
end
--主动的施法
function Advanced_Liquid_Fire:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf",
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

function Advanced_Liquid_Fire:OnProjectileHit(target, location)
	if not target then
		return
	end
	--
	-- local level = self.advanced_level
	local caster = self:GetCaster()
	local effect_number = self:GetSpecialValueFor("effect_number")
	local effect_number_count = 0
	local radius = self:GetSpecialValueFor("radius")
	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 特效
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFire", target)

	for _, enemy in pairs(enemies) do
		local enemy_burning =  enemy:FindModifierByName("modifier_Advanced_Liquid_Fire") 
		if enemy_burning then
			local imm_index = self:GetSpecialValueFor("imm_index")*0.01
			if self.advanced_level >= 20 then
				imm_index = (self:GetSpecialValueFor("imm_index")+20)*0.01
			end

			local imm_damage = (self:GetSpecialValueFor("basic_damage") + self:GetCaster():GetIntellect(false)*self:GetSpecialValueFor("intelligence_index_per_second")) *enemy_burning:GetRemainingTime()*imm_index
			local damageTable = {
				victim = enemy,
				attacker = caster,
				damage = imm_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
				ability = self, --Optional.
				hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
			}	
			ApplyDamage(damageTable)
			enemy:RemoveModifierByNameAndCaster("modifier_Advanced_Liquid_Fire", caster)
		end
		self:AddDebuff(caster,enemy)
		effect_number_count = effect_number_count + 1
		if not self.unlock2 and effect_number_count >= effect_number then
			return
		end
    end
end

function Advanced_Liquid_Fire:AddDebuff(caster,target)
	local duration = self:GetSpecialValueFor("duration")
	--新lv5粘性火流
	local explosion_nega_index = self:GetSpecialValueFor("explosion_nega_index")*0.01
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(explosion_nega_index)
	if self.advanced_level>=5 and ModifierStatusNegativeGain>1 then
		duration = duration *ModifierStatusNegativeGain
	end
	if self.unlock3 then
		duration = 10*duration
	end
	target:AddNewModifier(caster, self, "modifier_Advanced_Liquid_Fire", {duration = duration})
	local modifier = target:AddNewModifier(caster, self, "modifier_Advanced_Liquid_Fire_damage", {duration = duration})
	return modifier
end
--------------------------------------------------------------------------------------------------------------------------

modifier_Advanced_Liquid_Fire = advanced_modifier({})

function modifier_Advanced_Liquid_Fire:IsDebuff()			return true end
function modifier_Advanced_Liquid_Fire:IsHidden() 			return false end
function modifier_Advanced_Liquid_Fire:IsPurgable()         return true end
function modifier_Advanced_Liquid_Fire:IsPurgeException() 	return true end
function modifier_Advanced_Liquid_Fire:GetEffectName() return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf" end
function modifier_Advanced_Liquid_Fire:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Liquid_Fire:OnCreated()
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.attack_slow = self:GetAbility():GetSpecialValueFor("attack_slow") 
	self.dmg = (self:GetAbility():GetSpecialValueFor("basic_damage") + ability:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("intelligence_index_per_second")) *self:GetAbility():GetSpecialValueFor("damage_interval")
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("damage_interval"))
	end
end

function modifier_Advanced_Liquid_Fire:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	local target = self:GetParent()
	
	local damage_type = ability:GetAbilityDamageType()
	local damageTable = {
		victim = target,
		attacker = caster,
		damage =self.dmg,
		damage_type = damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage(damageTable)
	
end

function modifier_Advanced_Liquid_Fire:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Advanced_Liquid_Fire:GetModifierAttackSpeedBonus_Constant() return (0 - self.attack_slow) end

-------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Liquid_Fire_orb = advanced_modifier({})

function modifier_Advanced_Liquid_Fire_orb:IsDebuff()			return false end
function modifier_Advanced_Liquid_Fire_orb:IsHidden() 			return true end
function modifier_Advanced_Liquid_Fire_orb:IsPurgable() 		return false end
function modifier_Advanced_Liquid_Fire_orb:IsPurgeException() 	return false end
function modifier_Advanced_Liquid_Fire_orb:OnCreated()
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			self.pfx = self:GetParent():GetRangedProjectileName()
		end
	end
end

function modifier_Advanced_Liquid_Fire_orb:OnDestroy()
	if IsServer() and self.pfx then
		self.pfx = nil
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)
			self.pfx2 = nil
		end
	end
end
function modifier_Advanced_Liquid_Fire_orb:ADDeclareFunctions()
	 return 
	 {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	  MODIFIER_EVENT_ON_ATTACK_LANDED= {self:GetParent(),nil},
	} 
end

function modifier_Advanced_Liquid_Fire_orb:OnAttack(keys)
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

function modifier_Advanced_Liquid_Fire_orb:OnAttackLanded(keys)
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

--------高阶效果：活体炸弹----------------------------
modifier_Advanced_Liquid_Fire_damage = advanced_modifier({})

function modifier_Advanced_Liquid_Fire_damage:IsDebuff()				return false end
function modifier_Advanced_Liquid_Fire_damage:IsHidden() 				return true end
function modifier_Advanced_Liquid_Fire_damage:IsPurgable() 		    	return true end
function modifier_Advanced_Liquid_Fire_damage:IsPurgeException() 		return true end
function modifier_Advanced_Liquid_Fire_damage:ADDeclareFunctions() 
	return {MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}} 
end
--设置血量阈值
function modifier_Advanced_Liquid_Fire_damage:OnCreated(table)
	local ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	local  explosion_threshold = ability:GetSpecialValueFor("explosion_threshold")*0.01
	--新lv15解锁【不稳定炸弹】
	if self.advanced_level>=15 then
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
function modifier_Advanced_Liquid_Fire_damage:OnRefresh(table)
	self:OnCreated(table)
end


function modifier_Advanced_Liquid_Fire_damage:OnTakeDamage(keys)
	if not IsServer()  or keys.unit ~= self:GetParent()  or self.triger == 0 then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end

	self:SetStackCount(self:GetStackCount()+keys.damage)
	local heal = self:GetStackCount()
	if heal > self.unitheal then
		self:Trigger()
	end
end

function modifier_Advanced_Liquid_Fire_damage:Trigger()
	if self.triger==0 then
		return
	end
	self:SetStackCount(0)
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
	 local explosion_damage_intelligence_index = ability:GetSpecialValueFor("explosion_damage_intelligence_index")

	--新lv10解锁活体炸弹+
	if self.advanced_level>=10 then
		explosion_damage_intelligence_index = explosion_damage_intelligence_index +2
	end
	local dmg = caster:GetIntellect(false)* explosion_damage_intelligence_index

	local damage_type = ability:GetAbilityDamageType()
	 if dmg < 10 then
		return
	 end
	local damageTable = {
		-- victim = enemy,
		attacker = caster,
		damage = dmg,
		damage_type = damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	local explosion_nega_index = self:GetAbility():GetSpecialValueFor("explosion_nega_index")*0.01
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(explosion_nega_index)

	local duration = ability:GetSpecialValueFor("duration")* ModifierStatusNegativeGain
	for _, enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		if enemy:IsAlive() and ability.unlock1 and GameRules:GetGameTime()+10>ability.count and  caster:GetRandomEffect(30,INT_TYPE,1) >=RandomInt(1, 100) then
			ability.count = math.max(GameRules:GetGameTime()+0.5,ability.count+0.5)
			Timers:CreateTimer(RandomFloat(0.0, 0.5), function()
				if not enemy:IsNull() and not ability:IsNull() then
					enemy:AddNewModifier(caster, ability, "modifier_Advanced_Liquid_Fire", {duration = duration})
					enemy:AddNewModifier(caster, ability, "modifier_Advanced_Liquid_Fire_damage", {duration = duration})
				end
			end)			
			-- print("trigger")
		end
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFire", target)
end
function modifier_Advanced_Liquid_Fire_damage:OnIntervalThink()
	self.triger = 1
end

