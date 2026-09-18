
Middle_Burning_Spear = class({})

LinkLuaModifier("modifier_Middle_Burning_Spear", "skills/Middle_Burning_Spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Burning_Spear_orb", "skills/Middle_Burning_Spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Burning_Spear_debuff", "skills/Middle_Burning_Spear", LUA_MODIFIER_MOTION_NONE)
--修正总思路：火矛回归输出技能，提供具有容错率生命保底手段：火矛可以和其他技能组合来发挥总体效果强调BD化，但是重点是一定要有明显的配合手段
--待办事项1：火矛生命值消耗最大生命值→固定值+当前生命值，且不再成长
--待办事项2：新增：击杀后提供生命恢复增强（这个也是可以给狂血的修正）
--待办事项3：对远程修正：扣血效果将在到达时且敌人存活时生效
--待办事项4：火矛消耗生命值伤害→固定值+主属性
--待办事项5：提高dot跳速，降低伤害
function Middle_Burning_Spear:GetIntrinsicModifierName() return "modifier_Middle_Burning_Spear_orb" end

function Middle_Burning_Spear:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear.vpcf", context )
end

function Middle_Burning_Spear:GetHealthCost(iLevel)
	return  self:GetCaster():GetHealth()*self:GetSpecialValueFor("hp_cost_pct")*0.01 --待办事项1：火矛生命值消耗最大生命值→固定值+当前生命值，且不再成长
end

function Middle_Burning_Spear:GetCastRange(vLocation, hTarget) 
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange() 
end

function Middle_Burning_Spear:OnSpellStart(orbTarget)

	local limit = self:GetSpecialValueFor("limit")
	local caster = self:GetCaster()
	local target = orbTarget or  self:GetCursorTarget()
    if caster:GetHealthPercent()<=limit then
        return
    end
	if not target then --待办事项3：对远程修正：扣血效果将在到达时且敌人存活时生效
		return
	end
    
	local damage = self:GetCaster():HDGetPrimaryStatValue()*self:GetSpecialValueFor("atb_damage") + self:GetSpecialValueFor("damage")--待办事项4：火矛消耗生命值伤害→固定值+主属性
	local info = 
	{
		Target = target,
		Source = caster,
		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		Ability = self,	
		EffectName = "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear.vpcf",
		iMoveSpeed = 1500,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,	
		ExtraData = {
			damage = damage,
		}  
	}
	ProjectileManager:CreateTrackingProjectile(info)
end


function Middle_Burning_Spear:GetCustomCastErrorTarget(target)
	return "#Spells_CustomCastError_NO_hp"
end

function Middle_Burning_Spear:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
        if caster:GetHealthPercent()<=self:GetSpecialValueFor("limit") then
            return UF_FAIL_CUSTOM
        end
		return UF_SUCCESS
	end
end

function Middle_Burning_Spear:OnProjectileHit_ExtraData(target, location, kv)
	if not target or not target:IsAlive() then
		return
	end
	local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

	self:UseResources(true, true, true, true)
    target:AddNewModifier(caster, self, "modifier_Middle_Burning_Spear_debuff", {duration = duration,buff_duration = duration,damage=kv.damage})--待办事项4：火矛消耗生命值伤害→固定值+主属性
end
------------------------------------------------------------------------------------------------------------------------------------
modifier_Middle_Burning_Spear_debuff = advanced_modifier({})

function modifier_Middle_Burning_Spear_debuff:IsDebuff()			return true end
function modifier_Middle_Burning_Spear_debuff:IsHidden() 			return false end
function modifier_Middle_Burning_Spear_debuff:IsPurgable() 		return false end
function modifier_Middle_Burning_Spear_debuff:IsPurgeException() 	return false end
function modifier_Middle_Burning_Spear_debuff:GetEffectName() return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff_odl.vpcf"  end
function modifier_Middle_Burning_Spear_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.interval = 0.5
		self.tData = {}
		self.damage = keys.damage
		table.insert(self.tData, { 
			dieTime = GameRules:GetGameTime()+keys.buff_duration,
			damage = keys.damage
		})
		self:IncrementStackCount()
		self:StartIntervalThink(self.interval)
    end
end
function modifier_Middle_Burning_Spear_debuff:OnRefresh(keys)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, { 
			dieTime = GameRules:GetGameTime()+keys.buff_duration,
			damage = keys.damage
		})
		self.damage = self.damage + keys.damage
		self:IncrementStackCount()
	end
end

function modifier_Middle_Burning_Spear_debuff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self.damage = self.damage - self.tData[i].damage
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
		self:PlayEffect()
	end
end


function modifier_Middle_Burning_Spear_debuff:PlayEffect()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local dmg = self.damage
	if dmg<=0 then
		return
	end
	local damage = ApplyDamage({
		victim = self:GetParent(), 
		attacker = self:GetCaster(), 
		damage = dmg*self.interval, 
		damage_type = self:GetAbility():GetAbilityDamageType(), 
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, 
		hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_FIRE_DAMAGE,
		ability = self:GetAbility()
	})
	
end

function modifier_Middle_Burning_Spear_debuff:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end
function modifier_Middle_Burning_Spear_debuff:OnDeath(keys)
	local caster = self:GetCaster()
	local heal = (caster:GetMaxHealth()-caster:GetHealth())*self:GetAbility():GetSpecialValueFor("hplose_heal")*0.01
	if keys.attacker == caster then
        keys.attacker:Heal(heal, self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, heal, nil)
    end
end

modifier_Middle_Burning_Spear_orb = advanced_modifier({})

function modifier_Middle_Burning_Spear_orb:IsDebuff()			return false end
function modifier_Middle_Burning_Spear_orb:IsHidden() 			return true end
function modifier_Middle_Burning_Spear_orb:IsPurgable() 		return false end
function modifier_Middle_Burning_Spear_orb:IsPurgeException() 	return false end

function modifier_Middle_Burning_Spear_orb:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
    }
end

function modifier_Middle_Burning_Spear_orb:OnAttack(keys)
	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if keys.attacker ~= parent or parent:IsSilenced() or parent:IsIllusion() or not ability:GetAutoCastState() then
		return
	end
	if not keys.target:IsAlive() then
		return
	end
	if not ability:IsFullyCastable() then
		return
	end
	if not parent:IsApplyModifier() then
		return
	end
	if not IsEnemy(keys.target,parent) then
		return
	end
    ability:OnSpellStart(keys.target)
end
