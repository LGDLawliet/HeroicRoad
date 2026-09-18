
LinkLuaModifier("modifier_item_hd_chrono_casket_buff", "items/item_hd_chrono_casket.lua", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
item_hd_chrono_casket=class({})
function item_hd_chrono_casket:GetIntrinsicModifierName() 
    return "modifier_item_hd_chrono_casket_buff" 
end
function item_hd_chrono_casket:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", context )

    
end
function item_hd_chrono_casket:Spawn()
    if IsServer() then
        if not self.spawn then
            self.spawn = true
            self:SetCurrentCharges(3)
        end

    end
end


function item_hd_chrono_casket:OnSpellStart()
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName("modifier_item_hd_chrono_casket_buff")
    if modifier then
        local pos = modifier:GetFirstPos()
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(nFXIndex, 0,caster:GetOrigin()+Vector(0,0,64))
		ParticleManager:SetParticleControl(nFXIndex, 2,pos+Vector(0,0,64))
		DestroyParticleByDelay(nFXIndex,2)
		FindClearSpaceForUnit( caster, pos, true )
        caster:EmitSound("Hero_Weaver.TimeLapse")
    end
end
function item_hd_chrono_casket:CheckBuyBack()
    local charge = self:GetCurrentCharges()
    if charge>=1 then
        self:SetCurrentCharges(charge-1) 
        local caster = self:GetCaster()
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(nFXIndex, 0,caster:GetOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1,Vector(200,0,0))
		DestroyParticleByDelay(nFXIndex,3)
        caster:EmitSound("Hero_FacelessVoid.TimeDilation.Cast.ti7")
        return true
    end
    return false
end



modifier_item_hd_chrono_casket_buff=advanced_modifier({})

-- function modifier_item_hd_chrono_casket_buff:IsPassive()			return true end
function modifier_item_hd_chrono_casket_buff:IsDebuff() return false end
function modifier_item_hd_chrono_casket_buff:IsHidden() 		return true end
function modifier_item_hd_chrono_casket_buff:IsPurgable() 		return false end
function modifier_item_hd_chrono_casket_buff:IsPurgeException() return false end
function modifier_item_hd_chrono_casket_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_chrono_casket_buff:DestroyOnExpire() return false end
function modifier_item_hd_chrono_casket_buff:OnCreated()
    self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
    if IsServer() then

        self.posList = {}
        self:StartIntervalThink(0.1)
    end
end
-- 回合开始时与结束时重置坐标列表
function modifier_item_hd_chrono_casket_buff:OnWaveEnd()

    self.posList = {}
    local ability = self:GetAbility()
    ability:SetCurrentCharges(math.min(ability:GetCurrentCharges()+1,6))
end
function modifier_item_hd_chrono_casket_buff:OnWaveStart()
    self.posList = {}
end



function modifier_item_hd_chrono_casket_buff:OnIntervalThink()
    local pos = self:GetParent():GetOrigin()
    table.insert(self.posList,pos)
    if #self.posList>=51 then
        table.remove(self.posList,1)
    end
end
function modifier_item_hd_chrono_casket_buff:GetFirstPos()
    if #self.posList>=1 then
        return self.posList[1]
    end
    return self:GetParent():GetOrigin()
end

function modifier_item_hd_chrono_casket_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        MODIFIER_EVENT_ON_Wave_End = {},
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end
function modifier_item_hd_chrono_casket_buff:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end

