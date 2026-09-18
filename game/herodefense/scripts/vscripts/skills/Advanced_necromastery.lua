--特效优化 √

LinkLuaModifier("modifier_Advanced_necromastery", "skills/Advanced_necromastery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_necromastery_bonus", "skills/Advanced_necromastery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_necromastery_debuff", "skills/Advanced_necromastery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_necromastery_darkLordUnlock1", "skills/Advanced_necromastery", LUA_MODIFIER_MOTION_NONE)
Advanced_necromastery = Advanced_necromastery or  class({})
require('internal/timers')   --计时器功能


function Advanced_necromastery:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf", context )

	

end






function Advanced_necromastery:GetIntrinsicModifierName()
	return "modifier_Advanced_necromastery"
end
function Advanced_necromastery:CheckKVFixedOverride(key)
	if key=="max_soul" then
		if self:GetUnlock(1)==1 then
			return 120
		end
	end

	return -999999

end


function Advanced_necromastery:CheckKV(key)
	local table = {
		bonus_attack_damage = 0.05,
	}
	local value = table[key] or -1
	return value

end

function Advanced_necromastery:UnlockFirstCore(key)
	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_rubick" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock1 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true
end
function Advanced_necromastery:UnlockSecondCore(key)
	return true
end
function Advanced_necromastery:UnlockThirdCore(key)
	-- if not self:GetCaster():HasAbility("heroTalent_npc_dota_hero_riki") then
	-- 	self.CoreUnlock = false
	-- 	self.unlock3 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true
end

function Advanced_necromastery:GetMaxStack()
	local caster = self:GetCaster()
	local max_stack = self:GetSpecialValueFor("max_soul")
	if caster:HasModifier("modifier_item_hd_cantern_of_servitude") then
		max_stack = max_stack +40
	end
	if caster:HasAbility("heroTalent_npc_dota_hero_nevermore_2") then
		max_stack = math.floor(max_stack*1.6)
	end
	return max_stack
end




modifier_Advanced_necromastery = advanced_modifier({})


function modifier_Advanced_necromastery:IsHidden()	return false end
function modifier_Advanced_necromastery:IsDebuff()	return false end
function modifier_Advanced_necromastery:IsPurgable()	return false end
function modifier_Advanced_necromastery:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_Advanced_necromastery:OnCreated( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	self.white_damage_index = 0.5
	self.bonus_physical_damage_index = 0.3
	self:StartIntervalThink(1)
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			if self:GetParent().necromastery_stack then
				self:SetStackCount(self:GetParent().necromastery_stack )
			else
				self:SetStackCount(0)
			end
		end)
		
	end
end

function modifier_Advanced_necromastery:OnRefresh( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
end

function modifier_Advanced_necromastery:OnIntervalThink()
	local level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	if level>=5 then
		self.bonus_physical_damage_index = 0.5
		if level>=10 then
			self.white_damage_index = 0.75
		end
	end
end

function modifier_Advanced_necromastery:OnDestroy()
	if IsServer() then
		self:GetParent().necromastery_stack = self:GetStackCount()
	end
end
--------------------------------------------------------------------------------

function modifier_Advanced_necromastery:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}

	return funcs
end


function modifier_Advanced_necromastery:OnDeath( params )
	if IsServer() then

		
		local unit = params.unit
		local attacker = params.attacker
		if unit==self:GetParent() and params.reincarnate==false then
			if unit:HasModifier("modifier_item_hd_cantern_of_servitude") then
				return
			end
			local after_death = math.floor(self:GetStackCount() * (1-self:GetAbility():GetSpecialValueFor("soul_lost")*0.01))
			self:SetStackCount(math.max(after_death,1))
			return
		elseif unit~=self:GetParent() and attacker and attacker.GetPlayerOwnerID and  attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() and self:GetParent():IsAlive() then
			if self:GetParent():PassivesDisabled() then
				return 0 
			end
			self:AddStack(1)
			self:PlayEffects( unit )
		end

	end
end
function modifier_Advanced_necromastery:DarkLordInit()
	self.dark_lord_unlock1 = true
end


function modifier_Advanced_necromastery:GetModifierPreAttack_BonusDamage( params )
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage*(1-self.white_damage_index)
	end
end

function modifier_Advanced_necromastery:GetModifierBaseAttack_BonusDamage() 
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage*self.white_damage_index
	end
end


function modifier_Advanced_necromastery:AddStack( value )
	local max_stack = self:GetAbility():GetMaxStack()
	self:SetStackCount( math.min(self:GetStackCount()+value,max_stack) )
	if self.dark_lord_unlock1 and self:GetStackCount()>=30 then
		local modifier = self:GetParent():FindModifierByName("modifier_Advanced_necromastery_darkLordUnlock1")
		if modifier and modifier:GetStackCount()>=120 then
			return
		end
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_necromastery_darkLordUnlock1", {})
		self:SetStackCount(self:GetStackCount()-30)
		local iPtclID = ParticleManager:CreateParticle('particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf', PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iPtclID, 0, self:GetParent():GetOrigin())
		DestroyParticleByDelay(iPtclID,3)
		self:GetParent():EmitSound("Hero_Nevermore.Shadowraze")
	end
end

function modifier_Advanced_necromastery:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and keys.target and  not self:GetParent():PassivesDisabled() then	
		local ability = self:GetAbility()
		if ability.advanced_level>=15 then
			local chance = 15
			if ability.unlock2 then
				chance = 40
			end
			if chance>=RandomInt(1, 100) then
				local caster = self:GetCaster()
				local target = keys.target
				self:PlayEffects( target )
				local duration = 10
				local max_stack = ability:GetMaxStack()
				if self:GetParent():HasAbility("heroTalent_npc_dota_hero_nevermore_2") then
					duration = 18
				end
				if self:GetStackCount()>=max_stack then
					--临时灵魂
					caster:AddNewModifier(caster, ability, "modifier_Advanced_necromastery_bonus", {duration =duration})
				else
					self:IncrementStackCount()
				end
				if ability.advanced_level>=20 then
					target:AddNewModifier(caster, ability, "modifier_Advanced_necromastery_debuff", {duration =10})
				end
			end
			
		end
		

		
	end
end


function modifier_Advanced_necromastery:PlayEffects( target )
	-- Get Resources
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

	-- CreateProjectile
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 400,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end



-- function modifier_Advanced_necromastery:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if self:GetParent():PassivesDisabled() then
-- 		return 0 
-- 	end
-- 	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL  then
-- 		return self:GetStackCount()*self.bonus_physical_damage_index
-- 	end
-- end

-- advanced_modifier
function modifier_Advanced_necromastery:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_necromastery:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsClient() then
		return 0
	end
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL  then
		return self:GetStackCount()*self.bonus_physical_damage_index
	end
end




function modifier_Advanced_necromastery:GetModifierProcAttack_BonusDamage_Physical(keys)
	if IsClient() then
		return
	end
	local ability = self:GetAbility()
	if ability.unlock3  then
		local max_stack = ability:GetMaxStack()
		if self:GetStackCount()>=max_stack then
			self:DecrementStackCount()
			local caster = self:GetCaster()
			local bonus_damage = caster:GetBaseDamageMax()
			local info = 
			{
				Target = keys.target,
				Source = caster,
				Ability = nil,	
				EffectName = "particles/units/heroes/hero_nevermore/sf_necromastery_attack.vpcf",
				iMoveSpeed = caster:IsRangedAttacker() and caster:GetProjectileSpeed()+2000 or 5000,
				-- vSourceLoc = vPos,
				bDrawsOnMinimap = false,  --？？
				bDodgeable = true,   --可躲闪
				bIsAttack = false,   --攻击效果
				bVisibleToEnemies = true,  --对敌人可视
				bReplaceExisting = false, --替换现有的
				flExpireTime = GameRules:GetGameTime() + 10, --存在时间
				bProvidesVision = false, --提供视野
				-- ExtraData = {hit = i}   --额外的数据
			}
			ProjectileManager:CreateTrackingProjectile(info)
			return bonus_damage *10
		end

	end
end









modifier_Advanced_necromastery_bonus = class({})

function modifier_Advanced_necromastery_bonus:IsHidden()	return false end
function modifier_Advanced_necromastery_bonus:IsDebuff()	return false end
function modifier_Advanced_necromastery_bonus:IsPurgable()	return false end
function modifier_Advanced_necromastery_bonus:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,


	}

	return funcs
end


function modifier_Advanced_necromastery_bonus:GetModifierPreAttack_BonusDamage( params )
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage*0.25
	end
end

function modifier_Advanced_necromastery_bonus:GetModifierBaseAttack_BonusDamage() 
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage*0.75
	end
end
function modifier_Advanced_necromastery_bonus:GetModifierTotalDamageOutgoing_Percentage(keys)
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL  then
		return self:GetStackCount()*0.5
	end
end


function modifier_Advanced_necromastery_bonus:OnCreated(params)

	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_Advanced_necromastery_bonus:OnRefresh(params)
	local ability = self:GetAbility()
	self.soul_damage = ability:GetSpecialValueFor("bonus_attack_damage")
	if IsServer() then
		local dieTime = self:GetDieTime()

		if ability.unlock2 then
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
			return
		end

		local max_stack = ability:GetMaxStack()

		
		if self:GetStackCount()>= max_stack then
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
function modifier_Advanced_necromastery_bonus:OnIntervalThink()
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












modifier_Advanced_necromastery_debuff = class({})

function modifier_Advanced_necromastery_debuff:IsHidden()	return false end
function modifier_Advanced_necromastery_debuff:IsDebuff()	return true end
function modifier_Advanced_necromastery_debuff:IsPurgable()	return false end
function modifier_Advanced_necromastery_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE

	}
	return funcs
end


function modifier_Advanced_necromastery_debuff:GetModifierIncomingPhysicalDamage_Percentage( params )
	return self:GetStackCount()* 1.5
end



function modifier_Advanced_necromastery_debuff:OnCreated(params)

	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		

	end
end
function modifier_Advanced_necromastery_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end
function modifier_Advanced_necromastery_debuff:OnIntervalThink()
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
























modifier_Advanced_necromastery_darkLordUnlock1 = modifier_Advanced_necromastery_darkLordUnlock1 or advanced_modifier({})


function modifier_Advanced_necromastery_darkLordUnlock1:IsHidden()	return false end
function modifier_Advanced_necromastery_darkLordUnlock1:IsDebuff()	return false end
function modifier_Advanced_necromastery_darkLordUnlock1:IsPurgable()	return false end
function modifier_Advanced_necromastery_darkLordUnlock1:IsPurgeException() return false end
function modifier_Advanced_necromastery_darkLordUnlock1:RemoveOnDeath()	return false end

--------------------------------------------------------------------------------

function modifier_Advanced_necromastery_darkLordUnlock1:OnCreated( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	self.white_damage_index = 0.5
	self.bonus_physical_damage_index = 0.3
	self:StartIntervalThink(1)
	if IsServer() then
		self:IncrementStackCount()
		
	end
end

function modifier_Advanced_necromastery_darkLordUnlock1:OnRefresh( kv )
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,120))
	end
end

function modifier_Advanced_necromastery_darkLordUnlock1:OnIntervalThink()
	local level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
	if level>=5 then
		self.bonus_physical_damage_index = 0.5
		if level>=10 then
			self.white_damage_index = 0.75
			self:StartIntervalThink(-1)
		end
	end
end


function modifier_Advanced_necromastery_darkLordUnlock1:DeclareFunctions()
	local funcs = {
	
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end

function modifier_Advanced_necromastery_darkLordUnlock1:GetModifierPreAttack_BonusDamage( params )

	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if IsClient() then
		return self:GetStackCount()* self.soul_damage*(1-self.white_damage_index)
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage*(1-self.white_damage_index)
	end
end

function modifier_Advanced_necromastery_darkLordUnlock1:GetModifierBaseAttack_BonusDamage() 
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if IsClient() then
		return self:GetStackCount()* self.soul_damage*self.white_damage_index
	end
	if not self:GetParent():IsIllusion() then
		return self:GetStackCount()* self.soul_damage*self.white_damage_index
	end
end


-- function modifier_Advanced_necromastery_darkLordUnlock1:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	if self:GetParent():PassivesDisabled() then
-- 		return 0 
-- 	end
-- 	if IsClient() then
-- 		return self:GetStackCount()*self.bonus_physical_damage_index
-- 	end
-- 	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL  then
-- 		return self:GetStackCount()*self.bonus_physical_damage_index
-- 	end
-- end


-- advanced_modifier
function modifier_Advanced_necromastery_darkLordUnlock1:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Advanced_necromastery_darkLordUnlock1:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsClient() then
		return 0
	end
	if self:GetParent():PassivesDisabled() then
		return 0 
	end
	if IsClient() then
		return self:GetStackCount()*self.bonus_physical_damage_index
	end
	if keys.damage_type ==DAMAGE_TYPE_PHYSICAL  then
		return self:GetStackCount()*self.bonus_physical_damage_index
	end
end

