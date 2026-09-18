creep_special_gain_counterspell_reflect = class({})

LinkLuaModifier("modifier_creep_special_gain_counterspell_reflect", "special_gain/creep_special_gain_counterspell_reflect", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_counterspell_reflect:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_counterspell_reflect"
end



-- require('internal/timers')   --计时器功能
modifier_creep_special_gain_counterspell_reflect = class({})

function modifier_creep_special_gain_counterspell_reflect:IsDebuff() return false end
function modifier_creep_special_gain_counterspell_reflect:IsHidden()return false end
function modifier_creep_special_gain_counterspell_reflect:IsPurgable() return false end
function modifier_creep_special_gain_counterspell_reflect:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_ambient_armor.vpcf" end
function modifier_creep_special_gain_counterspell_reflect:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end


function modifier_creep_special_gain_counterspell_reflect:OnCreated(keys)
    self.ability = self:GetAbility()

 
    -- local parent = self:GetParent()

	-- self.crit_chance = self.ability:GetSpecialValueFor("blade_dance_crit_mult")
	-- self.blade_dance_crit_chance = self.ability:GetSpecialValueFor("blade_dance_crit_chance")

	
end



function modifier_creep_special_gain_counterspell_reflect:DeclareFunctions()
	return {
	

		MODIFIER_PROPERTY_ABSORB_SPELL,
	

	}
end




function modifier_creep_special_gain_counterspell_reflect:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	if  not self:GetAbility():IsCooldownReady() then
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

	if self:GetParent():GetHealthPercent()<=15 then


		local pfx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")

		return 1
	end
	return 0
end
