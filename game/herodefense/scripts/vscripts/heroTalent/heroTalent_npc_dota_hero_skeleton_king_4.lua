heroTalent_npc_dota_hero_skeleton_king_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skeleton_king_4", "heroTalent/heroTalent_npc_dota_hero_skeleton_king_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff", "heroTalent/heroTalent_npc_dota_hero_skeleton_king_4", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_skeleton_king_4:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf", context )
end

function heroTalent_npc_dota_hero_skeleton_king_4:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_skeleton_king_4"
end
function heroTalent_npc_dota_hero_skeleton_king_4:Spawn()
	local caster = self:GetCaster()
    caster:GameTimer(0.1,function()
        caster:AddItemByName("item_hd_holy_cross_amulet")
    end)
end
modifier_heroTalent_npc_dota_hero_skeleton_king_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_skeleton_king_4:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:OnCreated(kv)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	self.limit = self.ability:GetSpecialValueFor("limit")*0.01
	self.dmg_limit = self.ability:GetSpecialValueFor("dmg_limit")*0.01
    self.duration  = self.ability:GetSpecialValueFor("duration")
	self.talentgain = self.ability:GetTalentGain(0.7)
	self.limit_t = self.limit * self.talentgain
	self.dmg_limit_t = self.dmg_limit / self.talentgain
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_EVENT_ON_RESPAWN, 
    }
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:OnRespawn(keys)
    if not IsServer() then return end
    local unit = keys.unit

    if unit == self.parent then
        self.limit = self.ability:GetSpecialValueFor("limit")*0.01
        self.dmg_limit = self.ability:GetSpecialValueFor("dmg_limit")*0.01
        self.duration  = self.ability:GetSpecialValueFor("duration")
        self.talentgain = self.ability:GetTalentGain(0.7)
        self.limit_t = self.limit * self.talentgain
        self.dmg_limit_t = self.dmg_limit / self.talentgain
        self.parent:AddNewModifier(self.caster, self.ability, "modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff", {duration = 10, limit = self.limit_t, dmg_limit = self.dmg_limit_t})
    end
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
    }
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:OnDeath(keys)
	if not IsServer() then return end
    if keys.unit ~= self.parent then return end
    self.limit = self.ability:GetSpecialValueFor("limit")*0.01
	self.dmg_limit = self.ability:GetSpecialValueFor("dmg_limit")*0.01
    self.duration  = self.ability:GetSpecialValueFor("duration")
	self.talentgain = self.ability:GetTalentGain(0.7)
	self.limit_t = self.limit * self.talentgain
	self.dmg_limit_t = self.dmg_limit / self.talentgain

    local heroes = GetAllRealHeroes()
    for _, hero in ipairs(heroes) do
        if hero:IsAlive() and hero ~= self.parent then
            hero:AddNewModifier(self.caster, self.ability, "modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff", {duration = self.duration, limit = self.limit_t, dmg_limit = self.dmg_limit_t})
        end
    end
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4:OnTooltip()
	self.limit = self.ability:GetSpecialValueFor("limit")*0.01
	self.dmg_limit = self.ability:GetSpecialValueFor("dmg_limit")*0.01
    self.duration  = self.ability:GetSpecialValueFor("duration")
	self.talentgain = self.ability:GetTalentGain(0.7)
	self.limit_t = self.limit * self.talentgain
	self.dmg_limit_t = self.dmg_limit / self.talentgain

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.limit_t*100
    elseif self._tooltip == 2 then
        return self.dmg_limit_t*100
    end
end
modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:GetEffectName() return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:OnCreated(keys)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	
    if IsServer() then
        self.limit = keys.limit
        self.dmg_limit = keys.dmg_limit
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:AddCustomTransmitterData( )
	return
	{
		limit = self.limit,
		dmg_limit = self.dmg_limit,
	}
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:HandleCustomTransmitterData( data )
	self.limit = data.limit
	self.dmg_limit = data.dmg_limit
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_4_buff:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	local parent = self:GetParent()
	local health = parent:GetMaxHealth()*self.dmg_limit
	if keys.damage>=health then
		return keys.damage - health
	end
	return 0 
end



