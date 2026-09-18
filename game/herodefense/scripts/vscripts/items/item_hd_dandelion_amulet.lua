LinkLuaModifier("modifier_item_hd_dandelion_amulet", "items/item_hd_dandelion_amulet", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_dandelion_amulet_buff", "items/item_hd_dandelion_amulet", LUA_MODIFIER_MOTION_NONE)
item_hd_dandelion_amulet = class({})

function item_hd_dandelion_amulet:GetIntrinsicModifierName()
    return "modifier_item_hd_dandelion_amulet"
end

---------------------------------------------------------------------
modifier_item_hd_dandelion_amulet = advanced_modifier({})

function modifier_item_hd_dandelion_amulet:IsHidden()return true end
function modifier_item_hd_dandelion_amulet:IsPurgable()return false end

function modifier_item_hd_dandelion_amulet:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.profic = self.ability:GetSpecialValueFor("profic")
	self.positive_amp = self.ability:GetSpecialValueFor("positive_amp")
	self.remove  = self.ability:GetSpecialValueFor("remove")*0.01

	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end
function modifier_item_hd_dandelion_amulet:OnIntervalThink()
	if self.parent:IsAlive() and self.ability:IsCooldownReady() and Game_State:IsInBattle() then
		self.ability:UseResources(true, true, true, true)
		self.parent:Purge(false, true, false, false, false)

		local poison = self.parent:FindModifierByName("modifier_hd_poison")
		local burning = self.parent:FindModifierByName("modifier_hd_burning")
		local freezing = self.parent:FindModifierByName("modifier_hd_freezing")
		local elecshocking = self.parent:FindModifierByName("modifier_hd_elecshocking")

		if poison then
			poison:SetStackCount(math.max(poison:GetStackCount()*(1-self.remove), 0))
		end
		if burning then
			burning:SetStackCount(math.max(burning:GetStackCount()*(1-self.remove), 0))
		end
		if freezing then
			freezing:SetStackCount(math.max(freezing:GetStackCount()*(1-self.remove), 0))
		end
		if elecshocking then
			elecshocking:SetStackCount(math.max(elecshocking:GetStackCount()*(1-self.remove), 0))
		end

		local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
		local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle_cast_fx, 1, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	end
end
-- function modifier_item_hd_dandelion_amulet:DeclareFunctions()
--     return{
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
-- 		MODIFIER_PROPERTY_EVASION_CONSTANT,
--     }
-- end

function modifier_item_hd_dandelion_amulet:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		advanced_MODIFIER_PROPERTY_DurationGain
    }
end

function modifier_item_hd_dandelion_amulet:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end
function modifier_item_hd_dandelion_amulet:Advanced_GetModifier_DurationGain(keys)
	return self.positive_amp
end
--
-- modifier_item_hd_dandelion_amulet_buff = advanced_modifier({})

-- function modifier_item_hd_dandelion_amulet_buff:IsHidden()return false end
-- function modifier_item_hd_dandelion_amulet_buff:IsPurgable()return false end

-- function modifier_item_hd_dandelion_amulet_buff:OnCreated()
--     self.parent = self:GetParent()
--     self.ability = self:GetAbility()
--     self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
-- end

-- -- function modifier_item_hd_dandelion_amulet:DeclareFunctions()
-- --     return{
-- --         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
-- --     }
-- -- end

-- function modifier_item_hd_dandelion_amulet_buff:ADDeclareFunctions()
--     return {
--         advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
--     }
-- end

-- function modifier_item_hd_dandelion_amulet_buff:Advanced_GetModifier_TalentEffectGain()
-- 	if not self:GetAbility() then self:Destroy() return end
--     return self.bonus_profic
-- end


