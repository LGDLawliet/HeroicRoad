LinkLuaModifier("modifier_jim_magic_missile_buff", "skills/Primary_jim_magic_missile", LUA_MODIFIER_MOTION_NONE)
Primary_jim_magic_missile = class({})
function Primary_jim_magic_missile:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_magic_missile_hit/effect_projectile/effect.vpcf", context )

end

function Primary_jim_magic_missile:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end	
-- function Primary_jim_magic_missile:GetManaCost(iLevel)
-- 	local cost = self.BaseClass.GetManaCost(self,iLevel)
-- 	if self:GetAutoCastState() then
-- 		local bonus_cost = self:GetSpecialValueFor("extra_mana_cost")*0.01
-- 		if self:GetRuneType()==1 then
-- 			bonus_cost = bonus_cost * (100-self:GetSpecialValueFor("rune_1_cost_reduce"))*0.01
-- 		end
-- 		cost = cost * (1+bonus_cost)
-- 	end
-- 	cost = cost * self:GetManaCostGain()
-- 	return cost
-- end

function Primary_jim_magic_missile:GetCooldown(iLevel)

	return self:GetSpecialValueFor("cooldown_time")
end



function Primary_jim_magic_missile:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local gold_cost = self:GetSpecialValueFor("gold_cost")
	print("kv"..gold_cost)
	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_magic_missile_cast")  
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/rebuild/chaotic_spell/chaotic_magic_missile/effect_projectile/effect.vpcf",
		iMoveSpeed = 3000,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {}   --额外的数据
	}

	local count = self:GetSpecialValueFor("base_count")-1
	-- if self:GetAutoCastState() then
	-- 	count = count +  self:GetSpecialValueFor("count")
	-- end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	ProjectileManager:CreateTrackingProjectile(info)

	
	self:GetCaster():GameTimer(0.06, function()
		if IsValid(self) then
			local target = enemies[RandomInt(1, #enemies)]
			if not (IsValid(target)  and target:IsAlive() )  then
				for index, unit in ipairs(enemies) do
		
					if IsValid(unit) and  unit:IsAlive() then
						target = unit
						break
					end
				end
			end
			if IsValid(target) and target:IsAlive() then
				if not caster:HasModifier("modifier_jim_magic_missile_buff") then
					self.modifier_origin = caster:AddNewModifier(caster, nil, "modifier_jim_magic_missile_buff", {duration = -1})
					self.modifier_origin:SetStackCount(gold_cost)
				else
					self.modifier_origin:SetStackCount(self.modifier_origin:GetStackCount() + gold_cost)
				end
			end
			if IsValid(target) and target:IsAlive() then
				count = count - 1
				info.Target = target
				ProjectileManager:CreateTrackingProjectile(info)
				-- caster:EmitSound("Primary_jim_magic_missile_cast")  
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "chaotic_magic_missile_hit", caster)
				if count>=1 then
					return 0.06
				end
			end

		end
	end)


	
end




function Primary_jim_magic_missile:OnProjectileHit_ExtraData(target, location, keys)
	local caster = self:GetCaster()
	if not target then
		EmitSoundOnLocationWithCaster(location, "chaotic_magic_missile_hit", caster)
		return
	end
	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
	-- 	return true
	-- end


	target:EmitSound("chaotic_magic_missile_hit")
	self:ApplyModifier(target)
	local damageTable = {
		attacker	= caster,
		victim = target,
		damage		= (self:GetSpecialValueFor("base_damage") +  self:GetSpecialValueFor("bonus_damage_index")*caster:HDGetPrimaryStatValue())*self:GetEffectGain(),
		damage_type	= self:GetAbilityDamageType(),
		ability		= self,
	}
	ApplyDamage(damageTable)
	

end


function Primary_jim_magic_missile:ApplyModifier(target)
	local caster = self:GetCaster()


	local caster_pos = caster:GetAbsOrigin()

	local knockback =
	{
		knockback_duration = 0.2,
		duration = 0.2,
		knockback_distance = self:GetSpecialValueFor("knockback_distance"),
		knockback_height = 50,
		center_x = caster_pos.x,
		center_y = caster_pos.y,
		center_z = caster_pos.z,
	}
	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, self, "modifier_knockback", knockback)		
end

------------------------------------------------------------------------------负债以及扣钱部分


modifier_jim_magic_missile_buff = advanced_modifier({})

function modifier_jim_magic_missile_buff:IsDebuff()			return false end
function modifier_jim_magic_missile_buff:IsHidden() 			return false end
function modifier_jim_magic_missile_buff:IsPurgable() 		return false end

function modifier_jim_magic_missile_buff:OnCreated()
	if not self.countlevel then
		self.countlevel = 50
	end
	if not self.count then
		self.count = 0
	end
	if not self.totalcount  then
		self.totalcount = 0
	end
	if not self.count then
		self.count = 0
	end
end

function modifier_jim_magic_missile_buff:OnWaveEnd()
	Timers:CreateTimer(6, function()
		if self:GetParent():GetGold() >= self:GetStackCount() then
			print("大于")
			self:GetParent():ModifyGoldFiltered(-self:GetStackCount(),true,DOTA_ModifyGold_AbilityCost)
			self:Destroy()
		else
			print("小于")
			self:GetParent():ModifyGoldFiltered(-self:GetParent():GetGold(),true,DOTA_ModifyGold_AbilityCost)
			self:SetStackCount(self:GetStackCount() - self:GetParent():GetGold())
		end

		if self:GetParent():HasAbility("Middle_jim_magic_missile") then
			local ratio = self:GetParent():FindAbilityByName("Middle_jim_magic_missile"):GetSpecialValueFor("loan_ratio")
			self:GetParent():ModifyGoldFiltered(self:GetStackCount()*ratio,true,DOTA_ModifyGold_AbilityCost)
		end

		if self:GetParent():HasAbility("Advanced_jim_magic_missile") then
			local ratio = self:GetParent():FindAbilityByName("Advanced_jim_magic_missile"):GetSpecialValueFor("loan_ratio")
			--高阶5
			if self:GetParent():FindAbilityByName("Advanced_jim_magic_missile"):GetSpecialValueFor("advanced_level")>=5 then
				ratio = ratio + 0.05
			end
			self:GetParent():ModifyGoldFiltered(self:GetStackCount()*ratio,true,DOTA_ModifyGold_AbilityCost)
		end
		
	end)
end

function modifier_jim_magic_missile_buff:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end
