LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_clinkz_2", "heroTalent/heroTalent_npc_dota_hero_clinkz_2.lua", LUA_MODIFIER_MOTION_NONE )
--预加载"particles/econ/itemswindrunner/windranger_arcana/windranger_arcana_base_attack.vpcf"


-- Abilities
if heroTalent_npc_dota_hero_clinkz_2 == nil then
	heroTalent_npc_dota_hero_clinkz_2 = class({})
end

function heroTalent_npc_dota_hero_clinkz_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_clinkz_2"
end

if modifier_heroTalent_npc_dota_hero_clinkz_2 == nil then
	modifier_heroTalent_npc_dota_hero_clinkz_2 = advanced_modifier({})
end

function modifier_heroTalent_npc_dota_hero_clinkz_2:IsHidden() return true end

function modifier_heroTalent_npc_dota_hero_clinkz_2:IsDebuff() return false end

function modifier_heroTalent_npc_dota_hero_clinkz_2:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_clinkz_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_clinkz_2:OnRefresh(table) if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_clinkz_2:OnCreated(params)
	if IsServer() then
	end
	
end
--agi/int/str
function modifier_heroTalent_npc_dota_hero_clinkz_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		--on attack
		MODIFIER_EVENT_ON_ATTACK,
	}
end
--on attack
function modifier_heroTalent_npc_dota_hero_clinkz_2:OnAttack(params)
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	local caster = self:GetParent()
	local target = params.target
	local ability = self:GetAbility()
	if IsValid(caster) and IsValid(params.target) and params.target:IsAlive() then
		local pos = caster:GetAbsOrigin()
		local info = 
					{
						Target = target,
						-- Source = unit,
						Ability = ability,	
						EffectName = "particles/rebuild/clinkz_1/clinkz_maraxiform_searing_arrow_deso.vpcf",
						iMoveSpeed =1500,
						-- caster:GetProjectileSpeed()
						vSourceLoc = pos,
						bDrawsOnMinimap = false,  --？？
						bDodgeable = true,   --可躲闪
						bIsAttack = true,   --攻击效果
						bVisibleToEnemies = true,  --对敌人可视
						bReplaceExisting = true, --替换现有的
						flExpireTime = GameRules:GetGameTime() + 10, --存在时间
						bProvidesVision = false, --提供视野
						ExtraData = {vengeAttack = true}   --额外的数据
					}
					ProjectileManager:CreateTrackingProjectile(info)
	end
end



function modifier_heroTalent_npc_dota_hero_clinkz_2:GetModifierBonusStats_Agility()
	return (self.int or 0) + (self.str or 0)
end
function modifier_heroTalent_npc_dota_hero_clinkz_2:GetModifierBonusStats_Intellect()
	if self.flag then
		return 0
	else
		self.flag = true
		self.int = self:GetParent():GetIntellect(false)
		self.flag = false
		return -self.int
	end
	
	
end
function modifier_heroTalent_npc_dota_hero_clinkz_2:GetModifierBonusStats_Strength()
	if self.flag then
		return 0
	else	
		self.flag = true
		self.str = self:GetParent():GetStrength()
		self.flag = false
		return -self.str
	end
end
