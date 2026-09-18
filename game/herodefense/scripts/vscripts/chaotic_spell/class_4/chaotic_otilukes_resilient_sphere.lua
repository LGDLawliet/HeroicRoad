
chaotic_otilukes_resilient_sphere = class({})
LinkLuaModifier("modifier_chaotic_otilukes_resilient_sphere", "chaotic_spell/class_4/chaotic_otilukes_resilient_sphere", LUA_MODIFIER_MOTION_NONE)

function chaotic_otilukes_resilient_sphere:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_otilukes_resilient_sphere/effect_buff/effect.vpcf", context )

end

function chaotic_otilukes_resilient_sphere:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end

function chaotic_otilukes_resilient_sphere:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)* self:GetManaCostGain()
	return cost
end

function chaotic_otilukes_resilient_sphere:CastFilterResultTarget( hTarget )

	if hTarget:IsGiant() then
		self.error = "DOTA_HUB_CANT_CAST_Giant"
		return UF_FAIL_CUSTOM
	end

	local result = self.BaseClass.CastFilterResultTarget(self,hTarget)
	return result or UF_SUCCESS
end

function chaotic_otilukes_resilient_sphere:GetCustomCastErrorTarget( hTarget )
	return self.error
end





function chaotic_otilukes_resilient_sphere:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "Hero_Antimage.Counterspell.Cast"    
	EmitSoundOn(sound_cast, caster)    
	self:ApplyModifier(target)
end

function chaotic_otilukes_resilient_sphere:ApplyModifier(target, duration)
	-- local particle_cast = "particles/rebuild/chaotic_spell/chaotic_otilukes_resilient_sphere/effect_buff/effect.vpcf"
	local caster = self:GetCaster()

	-- local gain = caster:GetModifierDurationGainIndex(1)
	local effect_gain= self:GetEffectGain()
	target:AddNewModifier(caster, self, "modifier_chaotic_otilukes_resilient_sphere", {duration =  self:GetSpecialValueFor("duration")*effect_gain})


end



modifier_chaotic_otilukes_resilient_sphere = advanced_modifier({})

function modifier_chaotic_otilukes_resilient_sphere:IsHidden() return false end
function modifier_chaotic_otilukes_resilient_sphere:IsPurgable() return false end
function modifier_chaotic_otilukes_resilient_sphere:IsDebuff() return false end
function modifier_chaotic_otilukes_resilient_sphere:OnCreated(keys)

	local ability = self:GetAbility()
	self.move_slow = -ability:GetSpecialValueFor("move_slow")
	self.damage_reduction = -ability:GetSpecialValueFor("damage_reduction")
	self.out_damage_reduction = -ability:GetSpecialValueFor("damage_reduction")
	if ability:GetRuneType()==1 and self:GetParent():GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		self.move_slow = 0
	end

	if IsServer() then
		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_otilukes_resilient_sphere/effect_buff/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		local ex = parent:GetModelScale() * 100
		ParticleManager:SetParticleControl(pfx, 1, Vector(ex,ex,ex))
		self:AddParticle(pfx, false, false, 15, false, false)
	
	end
end



function modifier_chaotic_otilukes_resilient_sphere:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE = {self:GetParent(), nil},

    }
end


function modifier_chaotic_otilukes_resilient_sphere:Advanced_GetModifierIncomingDamage_Percentage()
	return self.damage_reduction
end


function modifier_chaotic_otilukes_resilient_sphere:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return self.out_damage_reduction
end


function modifier_chaotic_otilukes_resilient_sphere:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}
	if self:GetAbility():GetRuneType()~=1 and self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
		table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT)
	end
    return funcs 
    
end
function modifier_chaotic_otilukes_resilient_sphere:GetModifierMoveSpeedBonus_Constant() return   self.move_slow end
function modifier_chaotic_otilukes_resilient_sphere:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self:GetModifierMoveSpeedBonus_Constant()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierIncomingDamage_Percentage()
	elseif self._tooltip == 3 then
		return self:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	end
end



function modifier_chaotic_otilukes_resilient_sphere:OnCastDefaultMove(keys)

	local parent = self:GetParent()
	if keys.caster == parent then
		self:Destroy()
	end

end