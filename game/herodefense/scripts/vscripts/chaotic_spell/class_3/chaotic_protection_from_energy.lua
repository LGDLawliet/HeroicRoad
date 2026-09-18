LinkLuaModifier("modifier_chaotic_protection_from_energy", "chaotic_spell/class_3/chaotic_protection_from_energy", LUA_MODIFIER_MOTION_NONE)

chaotic_protection_from_energy = class({})

function chaotic_protection_from_energy:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_protection_from_energy/effect_cast/chaotic_protection_from_energy.vpcf", context )
end


function chaotic_protection_from_energy:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetAutoCastState() then
		cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
	end
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_protection_from_energy:IsHiddenWhenStolen() 		return false end
function chaotic_protection_from_energy:IsRefreshable() 			return true end
function chaotic_protection_from_energy:IsStealable() 				return true end
function chaotic_protection_from_energy:IsNetherWardStealable()	return true end


function chaotic_protection_from_energy:OnSpellStart()
	local target = self:GetCursorTarget()
	target:RemoveModifierByName("modifier_chaotic_protection_from_energy")
	local caster = self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration") * gain
	self:ApplyModifier(target, duration)

end

function chaotic_protection_from_energy:ApplyModifier(target, duration)
	-- EmitSoundOn("Hero_Dazzle.BadJuJu.Target", target)    

	local shield =0
	local caster = self:GetCaster()
	if self:GetAutoCastState() then
		shield = self:GetSpecialValueFor("spell_sheild")*(1+self:GetSpecialValueFor("over_gain")*0.01) +self:GetSpecialValueFor("auto_main_index")  *caster:HDGetPrimaryStatValue()
	else
		if self:GetRuneType()==1 then
			local rune_1_bonus = self:GetSpecialValueFor("rune_1_bonus")*0.01
			shield = self:GetSpecialValueFor("spell_sheild")*(1+self:GetSpecialValueFor("over_gain")*0.01*rune_1_bonus) +rune_1_bonus*self:GetSpecialValueFor("auto_main_index")  *caster:HDGetPrimaryStatValue()
		else
			shield = self:GetSpecialValueFor("spell_sheild")
		end
		
	end
	shield = shield *self:GetEffectGain()

	target:AddNewModifier(caster, self, "modifier_chaotic_protection_from_energy", {duration = duration,shield=shield})
	target:Purge(false, true, false, true, false)

end
----------------------------------------------------
modifier_chaotic_protection_from_energy = advanced_modifier({})

function modifier_chaotic_protection_from_energy:IsDebuff()			return false end
function modifier_chaotic_protection_from_energy:IsHidden() 			return false end
function modifier_chaotic_protection_from_energy:IsPurgable() 			return true end
function modifier_chaotic_protection_from_energy:IsPurgeException() 	return true end

function modifier_chaotic_protection_from_energy:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		self:SetStackCount(keys.shield)
		EmitSoundOn("chaotic_protection_from_energy_target", parent)
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_protection_from_energy/effect_cast/chaotic_protection_from_energy.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		
	end
end




function modifier_chaotic_protection_from_energy:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_chaotic_protection_from_energy:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end
    if keys.block_disabled then
        return 0 
    end

    local stack = self:GetStackCount()
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack
end


