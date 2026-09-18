item_hd_witch_crown = class({})

LinkLuaModifier("modifier_item_hd_witch_crown", "items/item_hd_witch_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_witch_crown_active", "items/item_hd_witch_crown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_witch_crown_debuff", "items/item_hd_witch_crown", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_witch_crown:GetIntrinsicModifierName()
	return "modifier_item_hd_witch_crown"
end
function item_hd_witch_crown:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/witch_crown/effect.vpcf", context )
end



function item_hd_witch_crown:OnSpellStart()

	
	local caster    =   self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_hd_witch_crown_active", {duration = 3})
	caster:Purge(false, true, false, false,true)
	caster:EmitSound("DOTA_Item.Swift_Blink.NailedIt")
	local particle = ParticleManager:CreateParticle("particles/rebuild/spell/witch_crown/effect.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)


end


modifier_item_hd_witch_crown = advanced_modifier({})

function modifier_item_hd_witch_crown:IsDebuff() return false end
function modifier_item_hd_witch_crown:IsHidden() return true end
function modifier_item_hd_witch_crown:IsPurgable() return false end
function modifier_item_hd_witch_crown:IsPurgeException() return false end
function modifier_item_hd_witch_crown:RemoveOnDeath() return false end

function modifier_item_hd_witch_crown:OnCreated(keys)
	self.bonus_status_resistance = self:GetAbility():GetSpecialValueFor("bonus_status_res")
	self.bonus_int =  self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_hd_witch_crown:OnDestroy(keys)

	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_witch_crown_debuff", {})
	end
end

function modifier_item_hd_witch_crown:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --智力加成


    }
end



function modifier_item_hd_witch_crown:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance
end


function modifier_item_hd_witch_crown:Advanced_GetModifierBonusStats_Intellect(keys)
	return self.bonus_int
end









modifier_item_hd_witch_crown_debuff = class({})

function modifier_item_hd_witch_crown_debuff:IsDebuff() return true end
function modifier_item_hd_witch_crown_debuff:IsHidden() return false end
function modifier_item_hd_witch_crown_debuff:IsPurgable() return false end
function modifier_item_hd_witch_crown_debuff:IsPurgeException() return false end
function modifier_item_hd_witch_crown_debuff:RemoveOnDeath() return false end

function modifier_item_hd_witch_crown_debuff:OnCreated(keys)

	if IsServer() then
		self:SetStackCount(5)
	end
end

function modifier_item_hd_witch_crown_debuff:OnRefresh(keys)

	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+5,100))
	end
end
function modifier_item_hd_witch_crown_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,         
	}
end
function modifier_item_hd_witch_crown_debuff:GetModifierBonusStats_Intellect()return -self:GetStackCount() end













modifier_item_hd_witch_crown_active = class({})

function modifier_item_hd_witch_crown_active:IsDebuff() return false end
function modifier_item_hd_witch_crown_active:IsHidden() return false end
function modifier_item_hd_witch_crown_active:IsPurgable() return false end
function modifier_item_hd_witch_crown_active:IsPurgeException() return false end
function modifier_item_hd_witch_crown_active:RemoveOnDeath() return false end

function modifier_item_hd_witch_crown_active:OnCreated(keys)

	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_item_hd_witch_crown_active:OnIntervalThink(keys)

	if IsServer() then
		local caster    =   self:GetCaster()
		caster:Purge(false, true, false, false,true)
	end
end
