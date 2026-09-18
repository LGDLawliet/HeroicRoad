Primary_Body_of_Effulgent_Beryl = class({})
LinkLuaModifier( "modifier_Primary_Body_of_Effulgent_Beryl", "skills/Primary_Body_of_Effulgent_Beryl", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function Primary_Body_of_Effulgent_Beryl:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_WitchDoctor.Voodoo_Restoration")
	-- caster:EmitSound("Hero_ShadowDemon.ShadowPoison.Impact")
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_ShadowDemon.ShadowPoison.Impact", caster)

	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/body_of_effulgent_beryl_cast/body_of_effulgent_beryl.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	--ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(100,0,0))
	ParticleManager:SetParticleControl(pfx, 2, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)

	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local gain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(caster, self, "modifier_Primary_Body_of_Effulgent_Beryl", {duration = self:GetSpecialValueFor("duration")*gain})

end


modifier_Primary_Body_of_Effulgent_Beryl = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Body_of_Effulgent_Beryl:IsHidden()	return false end
function modifier_Primary_Body_of_Effulgent_Beryl:IsDebuff()	return false end
function modifier_Primary_Body_of_Effulgent_Beryl:IsPurgable()	return false end
-- function modifier_Primary_Body_of_Effulgent_Beryl:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_PERMANENT 
-- end



function modifier_Primary_Body_of_Effulgent_Beryl:GetEffectName()
	return "particles/rebuild/spell/body_of_effulgent_beryl/body_of_effulgent_beryll.vpcf"
end

function modifier_Primary_Body_of_Effulgent_Beryl:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- function modifier_Primary_Body_of_Effulgent_Beryl:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
-- 	}
-- end
function modifier_Primary_Body_of_Effulgent_Beryl:OnCreated(keys)
	if IsServer() then
		self.ability=self:GetAbility()
		self.parent=self:GetParent()
	end
end

--物理伤害阻挡
-- function modifier_Primary_Body_of_Effulgent_Beryl:GetModifierPhysical_ConstantBlock(keys)  
-- 	if keys.damage_category ==DOTA_DAMAGE_CATEGORY_SPELL then

-- 		return
-- 	end

-- 	local block = self.parent:GetPhysicalArmorValue(false)*self.ability:GetSpecialValueFor("bonus_armor_shield")+self.ability:GetSpecialValueFor("bonus_shield")

-- 	return block 
-- end


function modifier_Primary_Body_of_Effulgent_Beryl:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_Primary_Body_of_Effulgent_Beryl:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_category ==DOTA_DAMAGE_CATEGORY_SPELL then

		return 0
	end

	local block = self.parent:GetPhysicalArmorValue(false)*self.ability:GetSpecialValueFor("bonus_armor_shield")+self.ability:GetSpecialValueFor("bonus_shield")

	return block 
end