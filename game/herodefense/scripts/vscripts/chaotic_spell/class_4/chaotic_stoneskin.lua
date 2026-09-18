
chaotic_stoneskin = class({})
LinkLuaModifier("modifier_chaotic_stoneskin", "chaotic_spell/class_4/chaotic_stoneskin", LUA_MODIFIER_MOTION_NONE)



function chaotic_stoneskin:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_stoneskin/skin_effect/effect_b.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf", context )

end
function chaotic_stoneskin:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end



function chaotic_stoneskin:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)* self:GetManaCostGain()
	return cost
end



function chaotic_stoneskin:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end







function chaotic_stoneskin:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "Hero_AbyssalUnderlord.DarkRift.Aftershock"    
	EmitSoundOn(sound_cast, caster)    
	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))

	local arti = caster:FindModifierByName("modifier_item_hd_holy_staff_effects")
	if not arti then
		return
	end
	local arti_ability = arti:GetAbility()
	local level = GetArtifactLevel(caster:GetPlayerOwnerID(),"item_hd_holy_staff_effects")
	if arti and level and level >= 30 then
		local heroes = GetAllRealHeroes()
		for _,hero in pairs(heroes) do
			if hero ~= target then
				self:ApplyModifier(hero, self:GetSpecialValueFor("duration")* arti_ability:GetArtifactSpecialValueFor("duration_3")*0.01)
			end
		end
	end
end

function chaotic_stoneskin:ApplyModifier(target, duration)
	local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,200,200))
	DestroyParticleByDelay(particle_cast_fx,1.5)
	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_chaotic_stoneskin", {duration = duration*gain*self:GetEffectGain()})

end


modifier_chaotic_stoneskin = advanced_modifier({})

function modifier_chaotic_stoneskin:IsHidden() return false end
function modifier_chaotic_stoneskin:IsPurgable() return true end
function modifier_chaotic_stoneskin:IsDebuff() return false end

function modifier_chaotic_stoneskin:GetEffectName() return "particles/rebuild/chaotic_spell/chaotic_stoneskin/skin_effect/effect_b.vpcf" end


function modifier_chaotic_stoneskin:OnCreated(keys)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_PhysicalDamageRediction= self:GetAbility():GetSpecialValueFor("bonus_PhysicalDamageRediction")
	if self:GetAbility():GetRuneType()==1 and self:GetAbility():GetAutoCastState() then
		self.rune_1_slow = -self:GetAbility():GetSpecialValueFor("rune_1_slow")
		self.bonus_armor = self.bonus_armor * (1+self:GetAbility():GetSpecialValueFor("rune_1_gain"))
	end
end


function modifier_chaotic_stoneskin:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	if self:GetAbility():GetRuneType()==1 and self:GetAbility():GetAutoCastState() then
		table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT)
	end
	return funcs
end
function modifier_chaotic_stoneskin:GetModifierMoveSpeedBonus_Constant() return   self.rune_1_slow end
-- function modifier_chaotic_stoneskin:OnTooltip() return self:Advanced_GetModifierPhysicalArmorBonus() end

function modifier_chaotic_stoneskin:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return   self:Advanced_GetModifierPhysicalArmorBonus()
	elseif self._tooltip == 2 then
		return self.bonus_PhysicalDamageRediction
	end
end




function modifier_chaotic_stoneskin:Advanced_GetModifierPhysicalArmorBonus()	return self.bonus_armor end
function modifier_chaotic_stoneskin:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE

    }
end


function modifier_chaotic_stoneskin:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
	-- local parent = self:GetParent()
	if keys.damage_type==DAMAGE_TYPE_PHYSICAL and not keys.inflictor then
		return -self.bonus_PhysicalDamageRediction
	end
	return 0

end

