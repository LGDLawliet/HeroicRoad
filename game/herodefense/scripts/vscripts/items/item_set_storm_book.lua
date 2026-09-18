LinkLuaModifier( "modifier_item_set_storm_book", "items/item_set_storm_book.lua", LUA_MODIFIER_MOTION_NONE )


item_set_storm_book = class({})

function item_set_storm_book:GetIntrinsicModifierName()
    return "modifier_item_set_storm_book"
end
function item_set_storm_book:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", context )
end
---------------------------------------
modifier_item_set_storm_book = advanced_modifier({})

function modifier_item_set_storm_book:IsDebuff()return false end
function modifier_item_set_storm_book:IsHidden()return true end
function modifier_item_set_storm_book:IsPurgable()return false end
function modifier_item_set_storm_book:RemoveOnDeath()return false end
function modifier_item_set_storm_book:DestroyOnExpire()	return false end

function modifier_item_set_storm_book:OnCreated(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.lightning_incoming = self:GetAbility():GetSpecialValueFor("lightning_incoming")
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_set_storm_book:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_set_storm_book:AdvancedGetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_set_storm_book:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell_amp
end

function modifier_item_set_storm_book:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then
		return
	end
	if keys.unit:GetTeamNumber() == keys.attacker:GetTeamNumber() then
		return
	end
    if not self:GetAbility():IsCooldownReady() then
        return
    end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	self:GetAbility():UseResources(true, true, true, true)
	local pfx = ParticleManager:CreateParticle("particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(pfx, 1,keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlForward(pfx, 1, keys.unit:GetForwardVector())  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	keys.unit:EmitSound("Hero_Morphling.AdaptiveStrikeAgi.Target")

	local damage = self:GetCaster():HDGetPrimaryStatValue()*self:GetAbility():GetSpecialValueFor("damage")
	local damageTable = {
		victim      = keys.unit,
		attacker	= keys.attacker,
		damage		= damage,
		damage_type	= self:GetAbility():GetAbilityDamageType(),
		ability		= self:GetAbility(),
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
	}
	ApplyDamage(damageTable)
	keys.unit:AddNewModifier(self:GetParent(),nil,"modifier_item_set_storm_active",{duration = self.duration , stack = self.lightning_incoming})
	
end

---------------------