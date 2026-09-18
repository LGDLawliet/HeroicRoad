
LinkLuaModifier("modifier_item_hd_soul", "items/item_hd_fate_ring", LUA_MODIFIER_MOTION_NONE)


item_hd_fate_ring = class({})
function item_hd_fate_ring:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/fate_ring/effect_end_lvl2.vpcf", context )


end


function item_hd_fate_ring:OnSpellStart()

	local caster = self:GetCaster()
	caster:EmitSound("ui.set_preview")

	local modifier = caster:FindModifierByName("modifier_item_hd_risk_dice_active_2")
	if modifier then
		local stack = modifier:GetStackCount()
		if stack<=0 then
			return
		end
		if stack<=20 then
			modifier:SafeDestroy()
		else
			modifier:SetStackCount(stack-20)
		end
		local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/fate_ring/effect_end_lvl2.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
		
	
		self:SpendCharge(0)
	end

end

