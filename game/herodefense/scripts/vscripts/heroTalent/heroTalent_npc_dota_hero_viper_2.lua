--
heroTalent_npc_dota_hero_viper_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_viper_2", "heroTalent/heroTalent_npc_dota_hero_viper_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_viper_2_debuff", "heroTalent/heroTalent_npc_dota_hero_viper_2", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_viper_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_viper_2"
end

function heroTalent_npc_dota_hero_viper_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf" , context )
	PrecacheResource( "particle", "particles/econ/items/viper/viper_ti7_immortal/viper_poison_debuff_ti7.vpcf" , context )
end
function heroTalent_npc_dota_hero_viper_2:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end
	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
	-- 	return true
	-- end
	if target:IsMagicImmune() then
		return
	end
	target:EmitSound("hero_viper.PoisonAttack.Target.ti7")
	target:AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_viper_2_debuff", {duration = 5})
end

modifier_heroTalent_npc_dota_hero_viper_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_viper_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_viper_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_viper_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_viper_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_viper_2:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_viper_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_viper_2:OnAttack(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		if not caster:IsRangedAttacker() then
			return
		end
		if caster:PassivesDisabled() then
			return
		end
		if not caster:IsApplyModifier() then
			return
		end
		if keys.target:IsMagicImmune() then
			return
		end
		caster:EmitSound("hero_viper.poisonAttack.Cast")
		local info = 
		{
			Target = keys.target,
			Source = caster,
			Ability = self:GetAbility(),	
			EffectName = "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf",
			iMoveSpeed = caster:GetProjectileSpeed(),
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
		ProjectileManager:CreateTrackingProjectile(info)
		
		
		
		
	end
end
function modifier_heroTalent_npc_dota_hero_viper_2:OnCreated()
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			self:IncrementStackCount()
			if self:GetStackCount()<=50 then
				return FrameTime()
			end
		end)
	end
end

function modifier_heroTalent_npc_dota_hero_viper_2:GetVisualZDelta()
	return self:GetStackCount()
end



function modifier_heroTalent_npc_dota_hero_viper_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying,
		-- advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_heroTalent_npc_dota_hero_viper_2:Advanced_GetModifier_Flying()	
	return 1
end








modifier_heroTalent_npc_dota_hero_viper_2_debuff = class({})


function modifier_heroTalent_npc_dota_hero_viper_2_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_viper_2_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_viper_2_debuff:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_viper_2_debuff:IsPurgable()	return true end

function modifier_heroTalent_npc_dota_hero_viper_2_debuff:OnCreated( kv )
	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
	}
	self:IncrementStackCount()
	self:StartIntervalThink(1)

end

function modifier_heroTalent_npc_dota_hero_viper_2_debuff:OnRefresh( kv )

	if not IsServer() then return end
	-- update damage
	self:SetStackCount(math.min(self:GetStackCount()+1,10))

end

----------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_viper_2_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_viper_2_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetStackCount()*2
end
function modifier_heroTalent_npc_dota_hero_viper_2_debuff:GetModifierMagicalResistanceBonus()
	return -self:GetStackCount()*3
end

function modifier_heroTalent_npc_dota_hero_viper_2_debuff:OnIntervalThink()
	
	self.damageTable.damage =self:GetCaster():GetAgility()*0.35 * self:GetStackCount()
	ApplyDamage( self.damageTable )
end


function modifier_heroTalent_npc_dota_hero_viper_2_debuff:GetEffectName()	return "particles/econ/items/viper/viper_ti7_immortal/viper_poison_debuff_ti7.vpcf" end
function modifier_heroTalent_npc_dota_hero_viper_2_debuff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
