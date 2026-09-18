LinkLuaModifier("modifier_chaotic_true_resurrection_rune_1_buff", "chaotic_spell/class_9/chaotic_true_resurrection", LUA_MODIFIER_MOTION_NONE)
chaotic_true_resurrection = class({})


function chaotic_true_resurrection:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_true_resurrection/effect_main/effect_reincarn_style2.vpcf", context )

end

function chaotic_true_resurrection:IsRefreshable()
	return false
end
function chaotic_true_resurrection:CheckEnable(keys)
	local currentCooldown  = self:GetCooldownTimeRemaining()
	-- print()
	if currentCooldown>=self:GetSpecialValueFor("max_cooldown_index") then
		return false
	end
	local cooldown_rate = self:GetSpecialValueFor("cooldown_rate")*0.01
	local cooldown_fixed = self:GetSpecialValueFor("cooldown_fixed")

	self:StartCooldown(currentCooldown + keys.delay*cooldown_rate + cooldown_fixed)


	local target = keys.target
	target:EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")

	local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_true_resurrection/effect_main/effect_reincarn_style2.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(1,0,0))
	ParticleManager:SetParticleControl(pfx, 11, Vector(200,200,200))
	ParticleManager:ReleaseParticleIndex(pfx)


	
	return true
end




function chaotic_true_resurrection:Rune1CallBack(target)
	target:AddNewModifier(target, self, "modifier_chaotic_true_resurrection_rune_1_buff", {duration = self:GetSpecialValueFor("rune_1_duration")})
end






modifier_chaotic_true_resurrection_rune_1_buff = advanced_modifier({})

function modifier_chaotic_true_resurrection_rune_1_buff:IsDebuff()			return false end
function modifier_chaotic_true_resurrection_rune_1_buff:IsHidden() 		return false end
function modifier_chaotic_true_resurrection_rune_1_buff:IsPurgable() 		return false end
function modifier_chaotic_true_resurrection_rune_1_buff:IsPurgeException() return false end
function modifier_chaotic_true_resurrection_rune_1_buff:OnCreated(keys)
	local ability = self:GetAbility()
	self.rune_1_bonus = -ability:GetSpecialValueFor("rune_1_bonus")

end

function modifier_chaotic_true_resurrection_rune_1_buff:OnRefresh(keys)
	local ability = self:GetAbility()
	self.rune_1_bonus = -ability:GetSpecialValueFor("rune_1_bonus")

end



function modifier_chaotic_true_resurrection_rune_1_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE

    }
end


function modifier_chaotic_true_resurrection_rune_1_buff:Advanced_GetModifierIncomingDamage_Percentage()
	return self.rune_1_bonus
end


function modifier_chaotic_true_resurrection_rune_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  

	}
end


function modifier_chaotic_true_resurrection_rune_1_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierIncomingDamage_Percentage()
	end
end