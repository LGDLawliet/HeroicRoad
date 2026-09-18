item_hd_vladmir_2 = class({})
LinkLuaModifier("modifier_item_hd_vladmir_2_arua", "items/item_hd_vladmir_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_vladmir_2", "items/item_hd_vladmir_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_vladmir_2_active", "items/item_hd_vladmir_2", LUA_MODIFIER_MOTION_NONE)
function item_hd_vladmir_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/life_drain/effect2/effect.vpcf", context )
end

function item_hd_vladmir_2:GetIntrinsicModifierName()
	return "modifier_item_hd_vladmir_2_arua"
end

modifier_item_hd_vladmir_2_arua = advanced_modifier({})

function modifier_item_hd_vladmir_2_arua:IsHidden() return true end
function modifier_item_hd_vladmir_2_arua:IsAura() return true end
function modifier_item_hd_vladmir_2_arua:RemoveOnDeath() return false end
function modifier_item_hd_vladmir_2_arua:GetModifierAura() return "modifier_item_hd_vladmir_2" end
function modifier_item_hd_vladmir_2_arua:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_item_hd_vladmir_2_arua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_hd_vladmir_2_arua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_vladmir_2_arua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_hd_vladmir_2_arua:GetTexture()return "item_wraith_pact" end

----------------------------------------------------------------------
modifier_item_hd_vladmir_2 = advanced_modifier({})

function modifier_item_hd_vladmir_2:IsDebuff() return false end
function modifier_item_hd_vladmir_2:IsHidden() return false end
function modifier_item_hd_vladmir_2:IsPurgable() return false end
function modifier_item_hd_vladmir_2:GetTexture()return "item_wraith_pact" end


function modifier_item_hd_vladmir_2:OnCreated(keys)
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
	self.steal = self.ability:GetSpecialValueFor("steal")  --在这里先计算就不用每次攻击都浪费一次计算了
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_hd_vladmir_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
    }
end

function modifier_item_hd_vladmir_2:Advanced_GetModifier_LifeSteal_AttackDamage()
	return self.steal
end

function modifier_item_hd_vladmir_2:Advanced_GetModifierDamageOutgoing_Percentage() 
	return self.bonus_attack 
end

function modifier_item_hd_vladmir_2:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_item_hd_vladmir_2:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if self:GetParent():IsAlive() then
		return
	end

	if not self:GetParent():IsRealHero() then
		return
	end

	if not self:GetAbility():IsCooldownReady() then
		return
	end

	self:GetParent():SetHealth(1)
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_vladmir_2_active", {duration = self.duration})
	self:GetAbility():UseResources(true, true, true, true)
end

----------------------------------------------------------------------
modifier_item_hd_vladmir_2_active = advanced_modifier({})

function modifier_item_hd_vladmir_2_active:IsDebuff() return false end
function modifier_item_hd_vladmir_2_active:IsHidden() return false end
function modifier_item_hd_vladmir_2_active:IsPurgable() return false end
function modifier_item_hd_vladmir_2_active:GetTexture()return "item_wraith_pact" end


function modifier_item_hd_vladmir_2_active:OnCreated(keys)
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.hp_regen_pct = 150/self.ability:GetSpecialValueFor("duration")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():EmitSound("Hero_Pugna.LifeDrain.Loop")
		self.pfx_name = "particles/rebuild/spell/life_drain/effect2/effect.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0,self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1,  self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_item_hd_vladmir_2_active:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
	end
end

function modifier_item_hd_vladmir_2_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end

function modifier_item_hd_vladmir_2_active:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.hp_regen_pct
end

function modifier_item_hd_vladmir_2_active:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end