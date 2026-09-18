creep_special_gain_counterspell = class({})

LinkLuaModifier("modifier_creep_special_gain_counterspell", "special_gain/creep_special_gain_counterspell", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_counterspell:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_counterspell"
end
function creep_special_gain_counterspell:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_counterspell/effect_buff.vpcf", context )
end


modifier_creep_special_gain_counterspell = advanced_modifier({})

function modifier_creep_special_gain_counterspell:IsDebuff() return false end
function modifier_creep_special_gain_counterspell:IsHidden()return false end
function modifier_creep_special_gain_counterspell:IsPurgable() return false end
function modifier_creep_special_gain_counterspell:GetEffectName() return "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_ambient.vpcf" end
function modifier_creep_special_gain_counterspell:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_creep_special_gain_counterspell:OnCreated(keys)
    self.ability = self:GetAbility()
	self.ability_res = self.ability:GetSpecialValueFor("ability_res")
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_creep_special_gain_counterspell:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() and  not self.nFXIndex then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/creeps_counterspell/effect_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		local ex = self:GetCaster():GetModelScale() * 100
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(ex,1,1) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
	
end

function modifier_creep_special_gain_counterspell:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_creep_special_gain_counterspell:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSORB_SPELL,
	}
end
function modifier_creep_special_gain_counterspell:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() then
		return
	end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_SPELL then
		return 
	end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end
	return -self.ability_res
end

function modifier_creep_special_gain_counterspell:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end
	if not IsEnemy(keys.ability:GetCaster(), self:GetParent()) then
		return 0
	end
	--说明这次法术吸收是由法术反弹引起的
	if self:GetParent():HasModifier("modifier_item_lotus_orb_active") then
		return
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(200,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	self:GetParent():EmitSound("Hero_Antimage.Counterspell.Target")
	ability:UseResources(true, true, true, true)
	-- self:SetDuration(ability:GetCooldownReduction(), true)
	if self.nFXIndex then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		self.nFXIndex = nil
	end
	return 1
end
