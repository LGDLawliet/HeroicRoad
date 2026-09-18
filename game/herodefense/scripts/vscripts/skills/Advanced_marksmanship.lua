--特效优化 √
Advanced_marksmanship = class({})
LinkLuaModifier( "modifier_Advanced_marksmanship", "skills/Advanced_marksmanship", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_marksmanship_debuff", "skills/Advanced_marksmanship", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_Advanced_marksmanship_ice_debuff", "skills/Advanced_marksmanship", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_Advanced_marksmanship_ice_buff", "skills/Advanced_marksmanship", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_Advanced_marksmanship_ice_buff2", "skills/Advanced_marksmanship", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_marksmanship_unlock1", "skills/Advanced_marksmanship", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_marksmanship_unlock2", "skills/Advanced_marksmanship", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function Advanced_marksmanship:GetIntrinsicModifierName()
	return "modifier_Advanced_marksmanship"
end
function Advanced_marksmanship:CheckKV(key)
	local table = {

		bonus_damage = 10,


	}
	local value = table[key] or -1
	return value

end

function Advanced_marksmanship:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
	return true
end
function Advanced_marksmanship:UnlockSecondCore(key)
		local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock2",{})
	return true
end
function Advanced_marksmanship:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_marksmanship_unlock1",{})
	return true
end
--------------------------------------------------------------------------------
-- Projectile
function Advanced_marksmanship:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end
	-- if fakeAttack then
	-- 	return
	-- end
	local caster = self:GetCaster()
	if data.vengeAttack then
		local index = 0.2
		if self.unlock2 then
			index = 0.7
		end
		
		local damagetable= {
			victim = target,
			attacker = caster,
			damage = (caster:GetAgility()*1.5+caster:GetAverageTrueAttackDamage(nil)*index),
			damage_type = self:GetAbilityDamageType(),
			ability = self,
			}
		ApplyDamage(damagetable)
		target:EmitSound("Hero_DrowRanger.Marksmanship.Target")
		return
	end
	if data.fakeAttack then
		local damagetable= {
			victim = target,
			attacker = caster,
			damage = self:GetSpecialValueFor( "bonus_damage" ),
			damage_type = self:GetAbilityDamageType(),
			ability = self,
			}
		ApplyDamage(damagetable)
		if self.advanced_level>=15 then
			local chance = 20
			-- if self.unlock3 then
			-- 	if CalculateDistance(caster,target)>=500 then
			-- 		chance = 35
			-- 	end
			-- end
			if chance>=RandomInt(1, 100) then
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =1,
					iDisableSplit = 1,
			
				}
				local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
				caster:PerformAttack( target, true, true, true, true, false, false, true )
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
			
			end
		end
	
	end


end


modifier_Advanced_marksmanship = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_marksmanship:IsHidden()	return true end
function modifier_Advanced_marksmanship:IsDebuff()	return false end
function modifier_Advanced_marksmanship:IsPurgable() 		return false end
function modifier_Advanced_marksmanship:IsPurgeException() 	return false end
function modifier_Advanced_marksmanship:RemoveOnDeath()  return false end
function modifier_Advanced_marksmanship:OnCreated(keys)
	self:StartIntervalThink(1)
	self.bonus_agi = 0
end

function modifier_Advanced_marksmanship:OnIntervalThink()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if advanced_level>=20 then
		self.bonus_agi = self:GetCaster():GetLevel()*2
	end
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_marksmanship:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,

		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                --伤害结算
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

	}

	return funcs
end
function modifier_Advanced_marksmanship:GetModifierBonusStats_Agility()	return self.bonus_agi end

function modifier_Advanced_marksmanship:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
    if not self:GetParent():IsRangedAttacker() or self:GetParent():PassivesDisabled() then
        return
    end
	if not self:GetParent():IsApplyModifier() then
		return
	end


	
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	
	local level = ability.advanced_level

	local chance = 10
	--LV10解锁银影天仇+
	if level>=10 then
		chance = 14
	end
	if self:GetParent():IsInSpecialAttack() then
		if level>=10 then
			chance = chance*0.4
		else
			chance = 0
		end
	end
	--银影天仇
	if chance>=RandomInt(1, 100) then
		local delay = 0.1
		--癫狂
		-- if level>=20 then
		-- 	caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_marksmanship_ice_buff2", {duration=1.5}) 
		-- end
		-- if level>=15 then
		-- 	caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_marksmanship_ice_buff", {duration=10}) 
		-- end
		
		if self:GetParent():IsDisableSplit() then  --分裂箭无效化
			return    
		end
		for i = 1, 2, 1 do
			Timers:CreateTimer(delay*i, function()
				if IsValid(caster) and IsValid(params.target) and params.target:IsAlive() then
					local pos = caster:GetAbsOrigin()
					pos.z = pos.z +RandomInt(200, 400)
					pos.x = pos.x + RandomInt(-300, 300)
					pos.y = pos.y + RandomInt(-300, 300)
					-- local unit = CreateUnitByName("npc_attack_unit", pos, true, caster, caster, caster:GetTeamNumber())
					-- unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.5})
					-- unit:SetOrigin(pos)
					-- unit:AddNoDraw()
					local info = 
					{
						Target = params.target,
						-- Source = unit,
						Ability = ability,	
						EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_arrow.vpcf",
						iMoveSpeed =1500,
						-- caster:GetProjectileSpeed()
						vSourceLoc = pos,
						bDrawsOnMinimap = false,  --？？
						bDodgeable = true,   --可躲闪
						bIsAttack = false,   --攻击效果
						bVisibleToEnemies = true,  --对敌人可视
						bReplaceExisting = false, --替换现有的
						flExpireTime = GameRules:GetGameTime() + 10, --存在时间
						bProvidesVision = false, --提供视野
						ExtraData = {vengeAttack = true}   --额外的数据
					}
					ProjectileManager:CreateTrackingProjectile(info)
				end
				
			

				
				-- Timers:CreateTimer(0.5, function()
				-- 	unit:ForceKill(false)
			
				-- end)
		
			end)
		end
		


	end

	local chance =  ability:GetSpecialValueFor( "chance" )
	if ability.unlock3 then
		if CalculateDistance(caster,params.target)>=500 then
			chance = 100
		end
	end

	if chance>RandomInt( 0, 100 ) then 


		local info = 
		{
			Target = params.target,
			Source = caster,
			Ability = ability,	
			EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_arrow.vpcf",
			iMoveSpeed =1500,
			-- caster:GetProjectileSpeed()
			vSourceLoc = caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,  --？？
			bDodgeable = true,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			bProvidesVision = false, --提供视野
			ExtraData = {fakeAttack = true}   --额外的数据
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

end


function modifier_Advanced_marksmanship:OnAttackLanded( params )

	if params.attacker~=self:GetParent() or self:GetParent():PassivesDisabled() then
		return
	end
	if not self:GetParent():IsRangedAttacker() then
        return
    end
	local caster = params.attacker
	local target = params.target

	target:AddNewModifier(
		caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_Advanced_marksmanship_debuff", -- modifier name
		{ duration = 0.5 } -- kv
	)


	
end

function modifier_Advanced_marksmanship:OnDamageCalculated(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local modifier = params.target:FindModifierByName("modifier_Advanced_marksmanship_debuff")
			if modifier then
				-- print("destroy ")
				modifier:SafeDestroy()
			end
		end
	end
end


modifier_Advanced_marksmanship_debuff = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_marksmanship_debuff:IsHidden()	return true end
function modifier_Advanced_marksmanship_debuff:IsDebuff()	return true end
function modifier_Advanced_marksmanship_debuff:IsStunDebuff()	return false end
function modifier_Advanced_marksmanship_debuff:IsPurgable()	return false end

function modifier_Advanced_marksmanship_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_marksmanship_debuff:OnCreated( kv )
	if IsClient() then
		return
	end
    local ability = self:GetAbility()
    self.armor_reduce = ability:GetSpecialValueFor("armor")*self:GetParent():GetPhysicalArmorValue(false)*0.01
	local chance = 30
	--LV5触发精准一击+
	if ability.advanced_level>=5 then
		chance = 45
	end
	if chance>=RandomInt(1, 100) then
		self.armor_reduce = self.armor_reduce*2
		local pfx = ParticleManager:CreateParticle("particles/econ/events/ti7/hero_levelup_ti7_flash_hit_magic.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
    self.armor_reduce = -math.max(self.armor_reduce,ability:GetSpecialValueFor("armor_min"))
end

function modifier_Advanced_marksmanship_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end








modifier_Advanced_marksmanship_ice_debuff = class({})

function modifier_Advanced_marksmanship_ice_debuff:IsDebuff() return true end
function modifier_Advanced_marksmanship_ice_debuff:IsHidden() return false end
function modifier_Advanced_marksmanship_ice_debuff:IsPurgable() return false end
function modifier_Advanced_marksmanship_ice_debuff:GetEffectName() return "particles/new_effect/new_drow_arcana/drow_arcana_arm_ambient.vpcf" end
function modifier_Advanced_marksmanship_ice_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_marksmanship_ice_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,          

	

	}
end
function modifier_Advanced_marksmanship_ice_debuff:GetModifierMoveSpeedBonus_Percentage()	return -5*self:GetStackCount() end


function modifier_Advanced_marksmanship_ice_debuff:OnCreated(params)

	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
	end
end
function modifier_Advanced_marksmanship_ice_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 7 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_marksmanship_ice_debuff:OnIntervalThink()
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









-- modifier_Advanced_marksmanship_ice_buff2 = class({})

-- function modifier_Advanced_marksmanship_ice_buff2:IsDebuff() return false end
-- function modifier_Advanced_marksmanship_ice_buff2:IsHidden() return true end
-- function modifier_Advanced_marksmanship_ice_buff2:IsPurgable() return false end
-- function modifier_Advanced_marksmanship_ice_buff2:GetEffectName() return "particles/new_effect/status/new_status_effect_soul_04.vpcf" end
-- function modifier_Advanced_marksmanship_ice_buff2:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
-- function modifier_Advanced_marksmanship_ice_buff2:DeclareFunctions()
-- 	return {
-- 			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
-- 			MODIFIER_EVENT_ON_ATTACK,                    --攻击降临
	

-- 	}
-- end
-- function modifier_Advanced_marksmanship_ice_buff2:CheckState()
-- 	local state = {[MODIFIER_STATE_CANNOT_MISS] = true}

-- 	return state
-- end

-- function modifier_Advanced_marksmanship_ice_buff2:GetModifierAttackSpeedBonus_Constant()return 1000 end

-- function modifier_Advanced_marksmanship_ice_buff2:OnCreated(table)
-- 	if IsServer() then
-- 		self:SetStackCount(2)
		
-- 	end
-- end

-- function modifier_Advanced_marksmanship_ice_buff2:OnAttack(keys)
-- 	if IsServer() then

-- 		if keys.attacker == self:GetParent() then
-- 			self:DecrementStackCount()
-- 			if self:GetStackCount()==0 then
-- 				self:SafeDestroy()
-- 			end

-- 		end
-- 	end
-- end



modifier_Advanced_marksmanship_unlock1 = advanced_modifier({})

function modifier_Advanced_marksmanship_unlock1:IsDebuff()			return false end
function modifier_Advanced_marksmanship_unlock1:IsHidden() 			return false end
function modifier_Advanced_marksmanship_unlock1:IsPurgable() 		    return false end
function modifier_Advanced_marksmanship_unlock1:IsPurgeException() return false end
function modifier_Advanced_marksmanship_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_marksmanship_unlock1:OnCreated()
	if IsServer() then
		self.nowtarget = self:GetParent()
	end
end
function modifier_Advanced_marksmanship_unlock1:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临

		

	}
end
function modifier_Advanced_marksmanship_unlock1:OnAttackLanded(keys)


	if IsServer() then

		if keys.attacker == self:GetParent()then

			if keys.target==self.nowtarget and self:GetParent():IsRangedAttacker()  then
				if self:GetStackCount()<250 then
					self:IncrementStackCount()
				end
			else
				self.nowtarget=keys.target
				self:SetStackCount(0)

			end

		end
	end
end
-- function modifier_Advanced_marksmanship_unlock1:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if IsServer() then
-- 		if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  and keys.target==self.nowtarget then
-- 			return self:GetStackCount()*2
-- 		end
-- 	end

-- end

-- advanced_modifier
function modifier_Advanced_marksmanship_unlock1:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_marksmanship_unlock1:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if keys.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  and keys.target==self.nowtarget then
			return self:GetStackCount()*2
		end
	end
end








modifier_Advanced_marksmanship_unlock2 = class({})

function modifier_Advanced_marksmanship_unlock2:IsDebuff()			return false end
function modifier_Advanced_marksmanship_unlock2:IsHidden() 			return false end
function modifier_Advanced_marksmanship_unlock2:IsPurgable() 		    return false end
function modifier_Advanced_marksmanship_unlock2:IsPurgeException() return false end
function modifier_Advanced_marksmanship_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_marksmanship_unlock2:OnCreated()
	if IsServer() then
		-- self.nowtarget = self:GetParent()
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_marksmanship_unlock2:OnIntervalThink()

	if self.nowtarget and not self.nowtarget:IsNull() and self.nowtarget:IsAlive() then
		local parent = self:GetParent()
		if parent:PassivesDisabled() then
			return
		end

		if not parent:CanEntityBeSeenByMyTeam(self.nowtarget) then
			return
		end
		if self.nowtarget:IsAttackImmune() then
			return
		end
		local info = 
		{
			Target = self.nowtarget,
			-- Source = unit,
			Ability = self:GetAbility(),	
			EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_arrow.vpcf",
			iMoveSpeed =1500,
			-- caster:GetProjectileSpeed()
			-- vSourceLoc = pos,
			bDrawsOnMinimap = false,  --？？
			bDodgeable = true,   --可躲闪
			bIsAttack = false,   --攻击效果
			bVisibleToEnemies = true,  --对敌人可视
			bReplaceExisting = false, --替换现有的
			flExpireTime = GameRules:GetGameTime() + 10, --存在时间
			bProvidesVision = false, --提供视野
			ExtraData = {vengeAttack = true}   --额外的数据
		}
		for i = 1, 5, 1 do

			Timers:CreateTimer(RandomFloat(0.05, 0.5), function()
			
					local pos = parent:GetAbsOrigin()
					pos.z = pos.z +RandomInt(200, 400)
					pos.x = pos.x + RandomInt(-300, 300)
					pos.y = pos.y + RandomInt(-300, 300)
					info.vSourceLoc = pos
					-- local unit = CreateUnitByName("npc_attack_unit", pos, true, caster, caster, caster:GetTeamNumber())
					-- unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration = 0.5})
					-- unit:SetOrigin(pos)
					-- unit:AddNoDraw()
				
					ProjectileManager:CreateTrackingProjectile(info)
		
				
			

		
			end)
		end
	end

end
function modifier_Advanced_marksmanship_unlock2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临

		

	}
end
function modifier_Advanced_marksmanship_unlock2:OnAttackLanded(keys)


	if IsServer() then

		if keys.attacker == self:GetParent()then

			if not self.nowtarget then
				self.nowtarget = keys.target
				return
			end
			if keys.target==self.nowtarget then
				return
			end
			if self.nowtarget:IsNull() or not self.nowtarget:IsAlive() then
				self.nowtarget = keys.target
			end

		end
	end
end
