heroTalent_npc_dota_hero_keeper_of_the_light_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2", "heroTalent/heroTalent_npc_dota_hero_keeper_of_the_light_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd", "heroTalent/heroTalent_npc_dota_hero_keeper_of_the_light_2", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_keeper_of_the_light_2:IsRefreshable() return false end
function heroTalent_npc_dota_hero_keeper_of_the_light_2:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2"
end
function heroTalent_npc_dota_hero_keeper_of_the_light_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/keeper_of_the_light_2/effect.vpcf", context )
end
function heroTalent_npc_dota_hero_keeper_of_the_light_2:OnSpellStart()
    local target = self:GetCursorTarget()
    local auto_state = self:GetAutoCastState()
    self:BacktoMe(target, auto_state)    
end

function heroTalent_npc_dota_hero_keeper_of_the_light_2:BacktoMe(target, auto_state)
    if not IsServer() then return end
    if not target then return end

    local caster = self:GetCaster()
    if auto_state then
        target:Purge(false, true, false, true, true)--强驱散
        if caster ~= target then
            local pos = caster:GetAbsOrigin() + caster:GetForwardVector()*150
		    FindClearSpaceForUnit(target, pos, true )
        end
    end

    self.talentgain1 = self:GetTalentGain(1)
    self.talentgain2 = self:GetTalentGain(0.7)
    local mana = target:GetMaxMana()*self:GetSpecialValueFor("mana")*0.01
    local cd_reduce = self:GetSpecialValueFor("cd_reduce")
    local mana_t = mana*self.talentgain1
    local cd_reduce_t = cd_reduce*self.talentgain2

    target:GiveMana(mana_t)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, target, mana, nil)
    for i=0, target:GetAbilityCount() - 1 do
		local Ability = target:GetAbilityByIndex(i)
		if Ability ~= nil and Ability ~= self  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() and Ability:GetName() ~= "Default_Move" then
			local newCooldown = Ability:GetCooldownTimeRemaining() - cd_reduce_t
			Ability:EndCooldown()
			if newCooldown>0 then
				Ability:StartCooldown(newCooldown)
			end
			break
		end
	end

	local particle = ParticleManager:CreateParticle("particles/rebuild/talent/keeper_of_the_light_2/effect.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	target:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
end

--
modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:OnCreated()
	self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.cd = self.ability:GetSpecialValueFor("cd")
end

function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:OnTooltip()
    self.talentgain1 = self.ability:GetTalentGain(1)
    self.talentgain2 = self.ability:GetTalentGain(0.7)
    local mana = self.ability:GetSpecialValueFor("mana")
    local cd_reduce = self.ability:GetSpecialValueFor("cd_reduce")
    local mana_t = mana*self.talentgain1
    local cd_reduce_t = cd_reduce*self.talentgain2

    self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return mana_t
    end
    if self._tooltip == 2 then
        return cd_reduce_t
    end
end

function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2:OnOrder(keys)
	if not IsServer() then return end
    local unit = keys.unit
    local target = keys.target
    local order_type = keys.order_type

    if target ~= self.parent then return end--点的不是老头就不行
    if not unit:IsRealHero() then return end--非英雄单位不生效
    if not unit:IsAlive() or not target:IsAlive() then return end--老头和点击者有一个死了都不行
    if unit == self.parent or IsEnemy(unit, target) then return end--老头不准点自己，敌人之间不生效
    if unit:HasModifier("modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd") then return end--有cd不生效

	if order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		unit:AddNewModifier(self.parent, self.ability, "modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd", {duration = self.cd})
        self.ability:BacktoMe(unit, true)
	end
end

--
modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd:IsPurgable()	return false end    
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_keeper_of_the_light_2_cd:RemoveOnDeath() return false end
