heroTalent_npc_dota_hero_warlock = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_warlock", "heroTalent/heroTalent_npc_dota_hero_warlock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_warlock_effect", "heroTalent/heroTalent_npc_dota_hero_warlock", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_warlock_health", "heroTalent/heroTalent_npc_dota_hero_warlock", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_warlock:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_warlock:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_warlock:IsStealable() 				return true end
function heroTalent_npc_dota_hero_warlock:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_warlock:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_warlock" end
function heroTalent_npc_dota_hero_warlock:OnSpellStart()
	local target = self:GetCursorTarget()
    local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_warlock")
    if modifier then
        modifier.target = target
    end
end

modifier_heroTalent_npc_dota_hero_warlock = class({})

function modifier_heroTalent_npc_dota_hero_warlock:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_warlock:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_warlock:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_warlock:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_warlock:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_warlock:GetEffectName() return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf" end

function modifier_heroTalent_npc_dota_hero_warlock:OnCreated()
    if IsServer() then
        
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.target = self:GetParent()
        self:StartIntervalThink(1)
    end
end


function modifier_heroTalent_npc_dota_hero_warlock:OnIntervalThink()
    if not self.target:IsAlive() then
        self.target = self:GetParent()
        if not self:GetParent():IsAlive() then
            return
        end
    end
    local modifier = self.target:FindModifierByName("modifier_heroTalent_npc_dota_hero_warlock_effect")
    if modifier then
        modifier:SetDuration(1.5, true)
    else
        self.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_warlock_effect", {duration = 1.5})
    end
end





modifier_heroTalent_npc_dota_hero_warlock_effect = class({})

function modifier_heroTalent_npc_dota_hero_warlock_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_warlock_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_warlock_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_warlock_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_warlock_effect:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_warlock_effect:GetEffectName() return "particles/econ/items/warlock/warlock_ti9/warlock_ti9_shadow_word_debuff.vpcf" end



function modifier_heroTalent_npc_dota_hero_warlock_effect:OnCreated(keys)
	if IsServer() then
        local parent = self:GetParent()
        local interval = self:GetAbility():GetSpecialValueFor("interval")
        self.double_line = self:GetAbility():GetSpecialValueFor("double_line")
        parent:EmitSound("Hero_Warlock.ShadowWordCastGood")
		self:StartIntervalThink(interval)	
	end
end


function modifier_heroTalent_npc_dota_hero_warlock_effect:OnIntervalThink()

	if self:GetAbility():IsCooldownReady() then
		local caster = self:GetCaster()
        local parent = self:GetParent()
        local int_index = self:GetAbility():GetSpecialValueFor("int_index")

        if parent:GetHealthPercent() <= self.double_line then
           int_index = int_index * 2
        else
            int_index = self:GetAbility():GetSpecialValueFor("int_index")
        end

		local healing = HealWithGain(caster:GetIntellect(false)*int_index,caster,parent,self:GetAbility())
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
	end

end
