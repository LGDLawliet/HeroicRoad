
LinkLuaModifier("modifier_item_hd_starry_sky_dome_buff", "items/item_hd_starry_sky_dome.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_starry_sky_dome_thinker", "items/item_hd_starry_sky_dome.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_starry_sky_dome_aura_buff", "items/item_hd_starry_sky_dome.lua", LUA_MODIFIER_MOTION_NONE)


require("internal/timers")
item_hd_starry_sky_dome= item_hd_starry_sky_dome or class({})
function item_hd_starry_sky_dome:GetIntrinsicModifierName() 
    return "modifier_item_hd_starry_sky_dome_buff" 
end
function item_hd_starry_sky_dome:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/starry_sky_dome/effect.vpcf", context )

end
function item_hd_starry_sky_dome:Spawn()
    if IsServer() then
        if not self.spawn then
            self.spawn = true
            self:SetCurrentCharges(2)
        end
    end
end

function item_hd_starry_sky_dome:GetCustomCastError()
	return "#DOTA_HUB_CANT_CAST_NO_CHARGE"
end

function item_hd_starry_sky_dome:CastFilterResult()
	if IsServer() then
        if self:GetCurrentCharges()<=0 then
            return UF_FAIL_CUSTOM
        end
		return UF_SUCCESS
	end
end
function item_hd_starry_sky_dome:OnSpellStart()


    self:SetCurrentCharges(self:GetCurrentCharges()-1)
    local caster = self:GetCaster()
	CreateModifierThinker(caster, self, "modifier_item_hd_starry_sky_dome_thinker", {duration = 6}, caster:GetOrigin(), caster:GetTeamNumber(), false)
    caster:EmitSound("Ability.Starfall")
end




modifier_item_hd_starry_sky_dome_buff=advanced_modifier({})

-- function modifier_item_hd_starry_sky_dome_buff:IsPassive()			return true end
function modifier_item_hd_starry_sky_dome_buff:IsDebuff() return false end
function modifier_item_hd_starry_sky_dome_buff:IsHidden() 		return false end
function modifier_item_hd_starry_sky_dome_buff:IsPurgable() 		return false end
function modifier_item_hd_starry_sky_dome_buff:IsPurgeException() return false end
function modifier_item_hd_starry_sky_dome_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_starry_sky_dome_buff:DestroyOnExpire() return false end
function modifier_item_hd_starry_sky_dome_buff:OnCreated()

    local ability = self:GetAbility()
	self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
    self.bonus_int = ability:GetSpecialValueFor("bonus_int")
    if IsServer() then
        self.timer = GameRules:GetGameTime()
        self:StartIntervalThink(1)
    end

end

function modifier_item_hd_starry_sky_dome_buff:OnWaveStart()
    local ability = self:GetAbility()
    ability:SetCurrentCharges(2)
end



function modifier_item_hd_starry_sky_dome_buff:OnIntervalThink()
    if _G.GAME_ENDLESS_WAVE_COUNT>=1 then
        local ability = self:GetAbility()
        if ability:GetCurrentCharges()<2 then
            local time = GameRules:GetGameTime()
            if time>=self.timer then
                ability:SetCurrentCharges(ability:GetCurrentCharges()+1)
                self.timer = self.timer +120
            end
        end
    end

end


function modifier_item_hd_starry_sky_dome_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_Wave_Start = {},
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_item_hd_starry_sky_dome_buff:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end
function modifier_item_hd_starry_sky_dome_buff:Advanced_GetModifierBonusStats_Intellect()
    return self.bonus_int
end



modifier_item_hd_starry_sky_dome_thinker = class({})

function modifier_item_hd_starry_sky_dome_thinker:IsAura()return true end
function modifier_item_hd_starry_sky_dome_thinker:OnCreated(keys)
	if IsServer() then
		self.particle = ParticleManager:CreateParticle("particles/rebuild/items/starry_sky_dome/effect.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle, 0, (Vector(0, 0, 0)))
		ParticleManager:SetParticleControl(self.particle, 1, (Vector(500, 1, 1)))

	end
end

function modifier_item_hd_starry_sky_dome_thinker:GetAuraRadius()return 500 end
function modifier_item_hd_starry_sky_dome_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_starry_sky_dome_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_starry_sky_dome_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_item_hd_starry_sky_dome_thinker:GetModifierAura()return "modifier_item_hd_starry_sky_dome_aura_buff" end


function modifier_item_hd_starry_sky_dome_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		UTIL_Remove(self:GetParent())
	end
end


modifier_item_hd_starry_sky_dome_aura_buff = class({})

function modifier_item_hd_starry_sky_dome_aura_buff:IsDebuff() return false end
function modifier_item_hd_starry_sky_dome_aura_buff:IsHidden() return true end
function modifier_item_hd_starry_sky_dome_aura_buff:IsPurgable() return false end
function modifier_item_hd_starry_sky_dome_aura_buff:CheckState()		return {[MODIFIER_STATE_INVISIBLE] = true} end
