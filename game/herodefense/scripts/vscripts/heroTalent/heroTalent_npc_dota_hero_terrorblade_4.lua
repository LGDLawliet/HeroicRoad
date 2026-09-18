LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade_4", "heroTalent/heroTalent_npc_dota_hero_terrorblade_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade_4_buff", "heroTalent/heroTalent_npc_dota_hero_terrorblade_4.lua", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_terrorblade_4 = class({})

function heroTalent_npc_dota_hero_terrorblade_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_terrorblade_4"
end

function heroTalent_npc_dota_hero_terrorblade_4:Precache( context )
	PrecacheResource( "model", "models/items/terrorblade/marauders_demon/marauders_demon.vmdl", context )
end
---------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_terrorblade_4 = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_terrorblade_4:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_4:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_4:DestroyOnExpire() return false end

function modifier_heroTalent_npc_dota_hero_terrorblade_4:OnCreated(params)
	self.ability = self:GetAbility()
	
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.index = self.ability:GetSpecialValueFor("index")
	self.bonus_index = self.ability:GetSpecialValueFor("bonus_index")

    self.talentgain = self.ability:GetTalentGain(0.8)
    self.index_t = (self.index + self.bonus_index*self:GetParent():GetLevel())*self.talentgain*0.01
end


function modifier_heroTalent_npc_dota_hero_terrorblade_4:OnSummonUnitFinished(keys)
    if not IsServer() then return end
    local caster = self:GetCaster()
    local target = keys.target
    
    -- 检查目标是否有效
    if not target or not IsValid(target) then return end
    -- 检查目标是否已经有这个buff
    if target:HasModifier("modifier_heroTalent_npc_dota_hero_terrorblade_4_buff") then return end
    -- 检查玩家所有权
    if target:GetPlayerOwnerID() ~= caster:GetPlayerOwnerID() then return end
    
    self.talentgain = self.ability:GetTalentGain(0.8)
    self.index_t = (self.index + self.bonus_index*caster:GetLevel())*self.talentgain*0.01
    self.attack = self.index_t*caster:GetAverageTrueAttackDamage(nil)
    target:AddNewModifier(caster, self.ability, "modifier_heroTalent_npc_dota_hero_terrorblade_4_buff", {incoming = self.incoming, attack = self.attack})
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP, -- 处理输出伤害
	}
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4:OnTooltip()
    self.talentgain = self.ability:GetTalentGain(0.8)
    self.index_t = (self.index + self.bonus_index*self:GetParent():GetLevel())*self.talentgain
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.index_t
	end
end

---------------------------------------------------------------------
modifier_heroTalent_npc_dota_hero_terrorblade_4_buff = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:OnCreated(params)
	if not self:GetAbility() then return end
    if IsServer() then
       self.incoming = params.incoming
       self.attack = params.attack
       self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:DeclareFunctions()
	local funcs =  {
		--MODIFIER_PROPERTY_MODEL_CHANGE
	}
    if not self:GetAbility():GetAutoCastState() then
       table.insert(funcs, MODIFIER_PROPERTY_MODEL_CHANGE) 
    end
	return funcs
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:GetModifierModelChange()
    return "models/items/terrorblade/marauders_demon/marauders_demon.vmdl"
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:ADDeclareFunctions()
	local funcs =  {
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:Advanced_GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self.attack
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:Advanced_GetModifierIncomingDamage_Percentage()
	if not self:GetAbility() then return end
	return -self.incoming
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:AddCustomTransmitterData( )
	return
	{
		incoming = self.incoming,
		attack = self.attack
	}
end

function modifier_heroTalent_npc_dota_hero_terrorblade_4_buff:HandleCustomTransmitterData( data )
	self.incoming = data.incoming
	self.attack = data.attack
end