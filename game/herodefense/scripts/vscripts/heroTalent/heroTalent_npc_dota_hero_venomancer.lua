heroTalent_npc_dota_hero_venomancer = class({})
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer_arua", "skills/heroTalent_npc_dota_hero_venomancer", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer_arua_effect", "skills/heroTalent_npc_dota_hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer", "heroTalent/heroTalent_npc_dota_hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_venomancer_active", "heroTalent/heroTalent_npc_dota_hero_venomancer", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_venomancer:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_venomancer"
end

function heroTalent_npc_dota_hero_venomancer:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end

	if target:IsMagicImmune() then
		return
	end
	target:AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_venomancer_active", {duration=self:GetSpecialValueFor("duration")}) 
end

-----------------------------------------------------------------------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_venomancer = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_venomancer:IsHidden() 	return true end
function modifier_heroTalent_npc_dota_hero_venomancer:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_venomancer:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_venomancer:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_venomancer:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil}
	}
end

function modifier_heroTalent_npc_dota_hero_venomancer:OnAttack(keys)
    if not IsServer() then
        return
	end  
	
	if self:GetParent():IsIllusion() then
		return
    end
	if not self:GetParent():IsRealHero() then
		return false
	end

    if keys.attacker == self:GetParent() then 
		if keys.target:IsMagicImmune() then
			return
		end
		if not self:GetAbility():IsCooldownReady() then
			return
		end
		self:GetAbility():UseResources(true, true, true,true)
		local parent = self:GetParent()
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, parent:Script_GetAttackRange()+100, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER, false)
		if #units>=1 then
			local attach_point = {
				parent:ScriptLookupAttachment( "attach_attack1" ),
				parent:ScriptLookupAttachment( "attach_attack2" ),
				parent:ScriptLookupAttachment( "attach_mouth" ),
			}
			
			local info = 
			{
				Target = keys.target,
				-- Source = caster,
				Ability = self:GetAbility(),	
				EffectName = parent:GetRangedProjectileName(),
				iMoveSpeed = 900,
				-- sourceloc = pos,
				-- caster:GetProjectileSpeed()
				-- vSourceLoc = pos,
				bDrawsOnMinimap = false,  --？？
				bDodgeable = true,   --可躲闪
				bIsAttack = false,   --攻击效果
				bVisibleToEnemies = true,  --对敌人可视
				bReplaceExisting = false, --替换现有的
				flExpireTime = GameRules:GetGameTime() + 10, --存在时间
				bProvidesVision = false, --提供视野
				ExtraData = {}   --额外的数据
			}
			for i = 1, 3, 1 do
				info.Target=units[RandomInt(1, #units)]
				info.vSourceLoc = parent:GetAttachmentOrigin(attach_point[i])
				ProjectileManager:CreateTrackingProjectile(info)
			end
	
	
			
		end

	end 
end  





modifier_heroTalent_npc_dota_hero_venomancer_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_venomancer_active:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_venomancer_active:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_venomancer_active:IsPurgable()	return true end
function modifier_heroTalent_npc_dota_hero_venomancer_active:IsPurgeException() return true end
function modifier_heroTalent_npc_dota_hero_venomancer_active:RemoveOnDeath() return true end
-- function heroTalent_npc_dota_hero_bane:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end



function modifier_heroTalent_npc_dota_hero_venomancer_active:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_heroTalent_npc_dota_hero_venomancer_active:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= (self:GetAbility():GetSpecialValueFor("max_stack")) then
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

function modifier_heroTalent_npc_dota_hero_venomancer_active:OnIntervalThink()
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


function modifier_heroTalent_npc_dota_hero_venomancer_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance,

    }
end
function modifier_heroTalent_npc_dota_hero_venomancer_active:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		
    }
end
function modifier_heroTalent_npc_dota_hero_venomancer_active:GetModifierMoveSpeedBonus_Constant(keys)
	return -self:GetAbility():GetSpecialValueFor("move_down")
end

function modifier_heroTalent_npc_dota_hero_venomancer_active:Advanced_GetModifier_StatusResistance(keys)
	return -self:GetStackCount()*self:GetAbility():GetSpecialValueFor("status_down")
end


