
LinkLuaModifier("modifier_item_hd_claszureme_hourglass_buff", "items/item_hd_claszureme_hourglass.lua", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
item_hd_claszureme_hourglass=class({})
function item_hd_claszureme_hourglass:GetIntrinsicModifierName() 
    return "modifier_item_hd_claszureme_hourglass_buff" 
end
function item_hd_claszureme_hourglass:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/claszureme_hourglass/effect.vpcf", context )
end





modifier_item_hd_claszureme_hourglass_buff=advanced_modifier({})

-- function modifier_item_hd_claszureme_hourglass_buff:IsPassive()			return true end
function modifier_item_hd_claszureme_hourglass_buff:IsDebuff() return false end
function modifier_item_hd_claszureme_hourglass_buff:IsHidden() 		return false end
function modifier_item_hd_claszureme_hourglass_buff:IsPurgable() 		return false end
function modifier_item_hd_claszureme_hourglass_buff:IsPurgeException() return false end
function modifier_item_hd_claszureme_hourglass_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_claszureme_hourglass_buff:DestroyOnExpire() return false end
function modifier_item_hd_claszureme_hourglass_buff:OnCreated()
    
    if self:GetAbility() == nil then
		return
    end

    local ability=self:GetAbility()
    self.bonus_health= ability:GetSpecialValueFor("bonus_health") 
    self.bonus_cooldown = ability:GetSpecialValueFor("bonus_cooldown")
    if IsServer() then

        self:StartIntervalThink(5)
    end
end
function modifier_item_hd_claszureme_hourglass_buff:OnIntervalThink()
    self:SetStackCount(math.min(self:GetStackCount()+1,10))
end

function modifier_item_hd_claszureme_hourglass_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    } 
end


function modifier_item_hd_claszureme_hourglass_buff:Advanced_GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if params.target~=self:GetParent() then return end
	local ability = self:GetAbility()
	if self:GetStackCount()>=1 and  params.damage>=params.target:GetMaxHealth()*0.03 then
        self:DecrementStackCount()
		self:SpellToTarget()
		return -100
	end

end

function modifier_item_hd_claszureme_hourglass_buff:GetModifierHealthBonus()
    return self.bonus_health
end


function modifier_item_hd_claszureme_hourglass_buff:SpellToTarget()
	if IsServer() then
		local caster = self:GetCaster()
        caster:EmitSound("DOTA_Item.Swift_Blink.NailedIt")
        local particle = ParticleManager:CreateParticle("particles/rebuild/spell/claszureme_hourglass/effect.vpcf", PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)
    
	end

end


function modifier_item_hd_claszureme_hourglass_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_item_hd_claszureme_hourglass_buff:Advanced_GetModifierCooldownReduction(keys)
    return self.bonus_cooldown or 0
end

