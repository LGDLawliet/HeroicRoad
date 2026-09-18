Primary_Arcane_Aura = class({})
LinkLuaModifier( "modifier_Primary_Arcane_Aura", "skills/Primary_Arcane_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Arcane_Aura_effect", "skills/Primary_Arcane_Aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function Primary_Arcane_Aura:GetIntrinsicModifierName()
	return "modifier_Primary_Arcane_Aura"
end


modifier_Primary_Arcane_Aura = class({})


-- Classifications
function modifier_Primary_Arcane_Aura:IsHidden()	return true end
function modifier_Primary_Arcane_Aura:IsDebuff()	return false end
function modifier_Primary_Arcane_Aura:IsPurgable() 		return false end
function modifier_Primary_Arcane_Aura:IsPurgeException() 	return false end
function modifier_Primary_Arcane_Aura:RemoveOnDeath()  return false end
function modifier_Primary_Arcane_Aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_Arcane_Aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Primary_Arcane_Aura:GetModifierAura()	return "modifier_Primary_Arcane_Aura_effect" end
function modifier_Primary_Arcane_Aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Primary_Arcane_Aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Primary_Arcane_Aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_Primary_Arcane_Aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_Primary_Arcane_Aura_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_Arcane_Aura_effect:IsHidden()	return false end
function modifier_Primary_Arcane_Aura_effect:IsDebuff()	return false end
function modifier_Primary_Arcane_Aura_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_Arcane_Aura_effect:IsPurgable()	return false end
function modifier_Primary_Arcane_Aura_effect:OnCreated( kv )
	-- references
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "bonus_re" )
	self.regen_self = self.regen_ally*self:GetAbility():GetSpecialValueFor( "self_mul" )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster~=target then
			local pfx_name ="particles/new_effect/arcane_aura/arcane_aura.vpcf"
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_CENTER_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end
		self:StartIntervalThink(0.5)
	end
end

function modifier_Primary_Arcane_Aura_effect:OnRefresh( kv )
	-- references
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "bonus_re" )
	self.regen_self = self.regen_ally*self:GetAbility():GetSpecialValueFor( "self_mul" )
end

function modifier_Primary_Arcane_Aura_effect:OnDestroy( kv )
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end

	end
end

function modifier_Primary_Arcane_Aura_effect:OnIntervalThink()
	local eqiup_sp = self:GetCaster():FindModifierByName("modifier_item_hd_argo_paw_buff") 
	if eqiup_sp then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_Arcane_Aura_effect:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
	return funcs
end

function modifier_Primary_Arcane_Aura_effect:AdvancedGetModifierConstantManaRegen()
	if self:GetParent()==self:GetCaster() then return self.regen_self*self:GetStackCount() end
	return self.regen_ally*self:GetStackCount()
end

function modifier_Primary_Arcane_Aura_effect:OnAttackLanded(keys)
	if self:GetStackCount() ~= 0 then--有命石才会生效
		return
	end
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	local eqiup_sp = self:GetCaster():FindModifierByName("modifier_item_hd_argo_paw_buff") 
	if eqiup_sp then
		if self:GetParent() == self:GetCaster() then 
			keys.attacker:GiveMana(self.regen_self*eqiup_sp:GetAbility():GetSpecialValueFor("arcane_mp_index")*0.01)
		else
			keys.attacker:GiveMana(self.regen_ally*eqiup_sp:GetAbility():GetSpecialValueFor("arcane_mp_index")*0.01)
		end
	end
	
	
end