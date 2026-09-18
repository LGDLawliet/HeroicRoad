--
heroTalent_npc_dota_hero_obsidian_destroyer_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2", "heroTalent/heroTalent_npc_dota_hero_obsidian_destroyer_2", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_obsidian_destroyer_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2"
end
function heroTalent_npc_dota_hero_obsidian_destroyer_2:GetManaCost(iLevel)
	return self:GetCaster():GetMana()*0.015
end
function heroTalent_npc_dota_hero_obsidian_destroyer_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf" , context )
end

modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2 = class({})

function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:OnAttack(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		if not caster:IsRangedAttacker() then
			return
		end
		if not self:GetAbility():GetAutoCastState() then
			return
		end
		local info = 
		{
			Target = keys.target,
			Source = caster,
			Ability = self:GetAbility(),	
			EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
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


function modifier_heroTalent_npc_dota_hero_obsidian_destroyer_2:GetModifierProcAttack_BonusDamage_Magical(params) 
	local parent = self:GetParent()
	if not parent:IsRealHero() then
		return 0
	end
	if not self:GetAbility():GetAutoCastState() then
		return
	end
	local mana = parent:GetMana()*0.015
	local bonus_damage = parent:GetMana()*0.18
	if IsServer() then
		parent:SpendMana(mana, self:GetAbility() )
		local healing = HealWithGain(mana,parent,parent,self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
	end
	return bonus_damage
end



