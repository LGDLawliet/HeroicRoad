heroTalent_npc_dota_hero_broodmother = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_broodmother", "heroTalent/heroTalent_npc_dota_hero_broodmother", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_broodmother_effect", "heroTalent/heroTalent_npc_dota_hero_broodmother", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_broodmother:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_broodmother"
end



modifier_heroTalent_npc_dota_hero_broodmother = class({})

function modifier_heroTalent_npc_dota_hero_broodmother:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_broodmother:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_broodmother:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_broodmother:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_broodmother:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_broodmother:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_broodmother:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self:StartIntervalThink(0.3)
	end
end


function modifier_heroTalent_npc_dota_hero_broodmother:OnIntervalThink()
	if not self:GetParent():IsAlive() then
		return
	end

	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(true, true, true,true)
		local caster = self:GetCaster()
		local unit = caster:SummonUnit("npc_hd_spider",30,
		caster:GetAbsOrigin()-caster:GetForwardVector()*100,
		caster:GetForwardVector(),self:GetAbility(),0,caster:GetMaxHealth()*0.8,nil,caster:GetAverageTrueAttackDamage(nil)*0.5,0,1,1)
		unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_broodmother_effect", {})
		caster:EmitSound("Hero_Broodmother.StickySnare")
	end
end







modifier_heroTalent_npc_dota_hero_broodmother_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_broodmother_effect:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_broodmother_effect:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_broodmother_effect:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_broodmother_effect:IsPurgeException() 	return false end
function modifier_heroTalent_npc_dota_hero_broodmother_effect:CheckState() return 
	{
	-- [MODIFIER_STATE_INVULNERABLE] = true,
	 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 [MODIFIER_STATE_UNSELECTABLE] = true, 
	 [MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	 [MODIFIER_STATE_ATTACK_IMMUNE] = true,
	 [MODIFIER_STATE_MAGIC_IMMUNE] = true,

	
	} 
end

function modifier_heroTalent_npc_dota_hero_broodmother_effect:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	} 
end


function modifier_heroTalent_npc_dota_hero_broodmother_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

	end
end


function modifier_heroTalent_npc_dota_hero_broodmother_effect:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetAbility():GetCaster()  --技能的拥有者
	local parent = self:GetCaster()               --幻象跟随者
	local parent_pos = parent:GetAbsOrigin()      --幻象跟随者位置
	local self_pos = self:GetParent():GetAbsOrigin()--幻象位置
	local distance = (parent_pos - self_pos):Length2D()
	--距离太远就走进跟随者
	if distance >1500 then 
		self:GetParent():SetForceAttackTarget(nil) 
		self:GetParent():MoveToPosition(parent_pos)
		return
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, 1500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	 if #enemy>0 and enemy[1]:IsAlive() then
		  self:GetParent():SetForceAttackTarget(enemy[1])
	 else
		self:GetParent():SetForceAttackTarget(nil)
	 end
end


function modifier_heroTalent_npc_dota_hero_broodmother_effect:ADDeclareFunctions()
    return 
    {
        -- advanced_MODIFIER_PROPERTY_Flying,
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_heroTalent_npc_dota_hero_broodmother_effect:Advanced_GetModifier_FlyingPathing()	
	return 1
end


-- Advanced_GetModifier_FlyingPathing



