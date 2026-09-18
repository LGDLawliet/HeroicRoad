item_hd_holy_cross_amulet = class({})
LinkLuaModifier("modifier_item_hd_holy_cross_amulet", "items/item_hd_holy_cross_amulet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_holy_cross_amulet_debuff", "items/item_hd_holy_cross_amulet", LUA_MODIFIER_MOTION_NONE)


function item_hd_holy_cross_amulet:GetIntrinsicModifierName()
	return "modifier_item_hd_holy_cross_amulet"
end
----------------------------------------------
modifier_item_hd_holy_cross_amulet = modifier_item_hd_holy_cross_amulet or advanced_modifier({})

function modifier_item_hd_holy_cross_amulet:OnCreated()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()    
	self.caster.now_reincarnation = "modifier_item_hd_holy_cross_amulet"  --设置当前的重生名
	self.particle_death = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	self.reincarnate_delay = self.ability:GetSpecialValueFor("delay")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	if IsServer() then

	end
end

function modifier_item_hd_holy_cross_amulet:OnRefresh()
	self:OnCreated()
end

function modifier_item_hd_holy_cross_amulet:IsHidden() return true end
function modifier_item_hd_holy_cross_amulet:IsPurgable() 		return false end
function modifier_item_hd_holy_cross_amulet:IsPurgeException() 	return false end
function modifier_item_hd_holy_cross_amulet:RemoveOnDeath()  return false end
function modifier_item_hd_holy_cross_amulet:IsDebuff() return false end

function modifier_item_hd_holy_cross_amulet:ADDeclareFunctions()
    return 
    {
		MODIFIER_SPECIAL_Reincarnate = {nil,self:GetParent()},
		MODIFIER_EVENT_ON_Wave_End = {},
		MODIFIER_EVENT_ON_Wave_Start = {},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    }
end
function modifier_item_hd_holy_cross_amulet:OnWaveEnd()
	if not IsServer() then
		return
	end
	self:GetAbility():SetCurrentCharges(1)
end
function modifier_item_hd_holy_cross_amulet:OnWaveStart()
	if not IsServer() then
		return
	end
	self:GetAbility():SetCurrentCharges(1)
end

function modifier_item_hd_holy_cross_amulet:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self.incoming
end

function modifier_item_hd_holy_cross_amulet:AdvancedGetModifierReincarnate(keys)
	if not IsServer() then
		return
	end
	if self:GetAbility():GetCurrentCharges() >= 1 then
		local rein = self:GetParent():FindAbilityByName("Primary_reincarnation") or self:GetParent():FindAbilityByName("Middle_reincarnation") or self:GetParent():FindAbilityByName("Advanced_reincarnation")
		local chaotic_rein = self:GetParent():FindModifierByName("modifier_chaotic_returning_to_the_mortal_world")
		if rein and rein:IsCooldownReady() then
			return
		end
		if chaotic_rein and chaotic_rein:GetStackCount() >= 1 then
			return
		end
		--self.reincarnation_weak = false
		local data = {
			modifier = self,
			time = self.reincarnate_delay,
			priority = 10,
			invulnerable_time = self.duration,
		}
		self:GetAbility():SetCurrentCharges(0)
		return data
	end
	return nil
end

function modifier_item_hd_holy_cross_amulet:OnReincarnateTrigger(keys)
	local unit = keys.unit
	self.ability:UseResources(false, false, true,true)
	local particle_death_fx = ParticleManager:CreateParticle(self.particle_death, PATTACH_CUSTOMORIGIN, unit)
	ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
	ParticleManager:SetParticleControl(particle_death_fx, 0, unit:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(self.reincarnate_delay, 0, 0))
	ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_death_fx)
	-- unit:AddNewModifier(unit, self.ability, "modifier_item_hd_holy_cross_amulet_debuff", {duration = self.ability:GetSpecialValueFor("duration")})
	--self.reincarnation_weak = true


	local table = {
		mulEffect = true,
		multiTrigger = true,
		unit = self:GetParent(),
		modifier = self,
		ability = self:GetAbility()
	}
	FireDeathAgainEvent(table)

end