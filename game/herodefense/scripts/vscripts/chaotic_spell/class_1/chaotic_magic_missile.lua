LinkLuaModifier("modifier_chaotic_magic_missile_rune_2", "chaotic_spell/class_1/chaotic_magic_missile", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_magic_missile_rune_3", "chaotic_spell/class_1/chaotic_magic_missile", LUA_MODIFIER_MOTION_NONE)
chaotic_magic_missile = class({})
function chaotic_magic_missile:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_magic_missile/effect_projectile/effect.vpcf", context )

end
function chaotic_magic_missile:GetIntrinsicModifierName()
	if self:GetRuneType()==3 then
		return	"modifier_chaotic_magic_missile_rune_3"
	end
end

function chaotic_magic_missile:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_magic_missile:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetAutoCastState() then
		local bonus_cost = self:GetSpecialValueFor("extra_mana_cost")*0.01
		if self:GetRuneType()==1 then
			bonus_cost = bonus_cost * (100-self:GetSpecialValueFor("rune_1_cost_reduce"))*0.01
		end
		cost = cost * (1+bonus_cost)
	end
	cost = cost * self:GetManaCostGain()
	return cost
end

function chaotic_magic_missile:GetCooldown(iLevel)

	return self:GetSpecialValueFor("cooldown_time")
end



function chaotic_magic_missile:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

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
	if self:GetAutoCastState() then
		count = count +  self:GetSpecialValueFor("count")
		if self:GetRuneType()==1 then
			count = count +  self:GetSpecialValueFor("rune_1_bonus_count")
		end
		if self:GetRuneType()==3 then
			count = count -  self:GetSpecialValueFor("rune_3_count_down")
		end
	end

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
				count = count - 1
				info.Target = target
				ProjectileManager:CreateTrackingProjectile(info)
				-- caster:EmitSound("chaotic_magic_missile_cast")  
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "chaotic_magic_missile_hit", caster)
				if count>=1 then
					return 0.06
				end
			end

		end
	end)


	
end




function chaotic_magic_missile:OnProjectileHit_ExtraData(target, location, keys)
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
	
	if self:GetRuneType()==2 then
		target:AddNewModifier(caster,self,"modifier_chaotic_magic_missile_rune_2",{stack = self:GetSpecialValueFor("rune_2_stack")})
		local modifier = target:FindModifierByName("modifier_chaotic_magic_missile_rune_2")
		if modifier then
			damageTable.damage = damageTable.damage * (1 + modifier:GetStackCount()*self:GetSpecialValueFor("rune_2_each_bonus")*0.01)
		end
		
	end
	ApplyDamage(damageTable)
end


function chaotic_magic_missile:ApplyModifier(target)
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


------

modifier_chaotic_magic_missile_rune_2 = modifier_chaotic_magic_missile_rune_2 or advanced_modifier({})


function modifier_chaotic_magic_missile_rune_2:IsHidden()	return false end
function modifier_chaotic_magic_missile_rune_2:IsDebuff()	return true end
function modifier_chaotic_magic_missile_rune_2:IsStunDebuff()	return false end
function modifier_chaotic_magic_missile_rune_2:IsPurgable()	return false end

function modifier_chaotic_magic_missile_rune_2:OnCreated( keys )
	if not IsServer() then
		return
	end
	self.stack = keys.stack
	self:SetStackCount(self:GetStackCount()+self.stack)
end

function modifier_chaotic_magic_missile_rune_2:OnRefresh( keys )
	if not IsServer() then
		return
	end
	self.stack = keys.stack
	self:SetStackCount(self:GetStackCount()+self.stack)
end


------

modifier_chaotic_magic_missile_rune_3 = modifier_chaotic_magic_missile_rune_3 or advanced_modifier({})


function modifier_chaotic_magic_missile_rune_3:IsHidden()	return true end
function modifier_chaotic_magic_missile_rune_3:IsDebuff()	return false end
function modifier_chaotic_magic_missile_rune_3:IsStunDebuff()	return false end
function modifier_chaotic_magic_missile_rune_3:IsPurgable()	return false end

function modifier_chaotic_magic_missile_rune_3:OnCreated( keys )
	if not IsServer() then
		return
	end
	self.chance = self:GetAbility():GetSpecialValueFor("rune_3_chance")
end

function modifier_chaotic_magic_missile_rune_3:OnRefresh( keys )
	if not IsServer() then
		return
	end
	self.chance = self:GetAbility():GetSpecialValueFor("rune_3_chance")
end

function modifier_chaotic_magic_missile_rune_3:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil}
	}
end

function modifier_chaotic_magic_missile_rune_3:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.attacker:IsInSpecialAttack() then
		return
	end
	local random = math.random
	if keys.target:IsAlive() and self.chance > random(0,100) then

		local caster = keys.attacker
		local target = keys.target
		local ability = self:GetAbility()
	
		caster:EmitSound("chaotic_magic_missile_cast")  
		local info = 
		{
			Target = target,
			Source = caster,
			Ability = ability,	
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
	
		local count = ability:GetSpecialValueFor("base_count") - ability:GetSpecialValueFor("rune_3_count_down") - 1

			count = count 


	
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		ProjectileManager:CreateTrackingProjectile(info)
	
		
		keys.attacker:GameTimer(0.06, function()
			if IsValid(ability) then
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
					count = count - 1
					info.Target = target
					ProjectileManager:CreateTrackingProjectile(info)
					-- caster:EmitSound("chaotic_magic_missile_cast")  
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "chaotic_magic_missile_hit", caster)
					if count>=1 then
						return 0.06
					end
				end
	
			end
		end)
	end
end