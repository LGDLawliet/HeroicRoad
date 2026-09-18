LinkLuaModifier("modifier_chaotic_eyes_in_the_back", "chaotic_spell/class_2/chaotic_eyes_in_the_back", LUA_MODIFIER_MOTION_NONE)

chaotic_eyes_in_the_back = chaotic_eyes_in_the_back or class({})

function chaotic_eyes_in_the_back:GetIntrinsicModifierName() return "modifier_chaotic_eyes_in_the_back" end

function chaotic_eyes_in_the_back:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_eyes_in_the_back/main/effectend.vpcf", context )
end

modifier_chaotic_eyes_in_the_back = advanced_modifier({})

function modifier_chaotic_eyes_in_the_back:IsPurgable() 		return false end
function modifier_chaotic_eyes_in_the_back:IsPurgeException() 	return false end
function modifier_chaotic_eyes_in_the_back:IsHidden() return true end
function modifier_chaotic_eyes_in_the_back:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.chance_max = self.ability:GetSpecialValueFor("chance_max")
	self.chance_min = self.ability:GetSpecialValueFor("chance_min")
	if self:GetAbility():GetRuneType()==3 then
		self.chance_min = self.chance_min *(1+self:GetAbility():GetSpecialValueFor("rune_3_index")*0.01)
	end
end

function modifier_chaotic_eyes_in_the_back:ADDeclareFunctions()
    local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_BONUS_VISION)
	end
	return funcs
end

function modifier_chaotic_eyes_in_the_back:Advanced_GetBonusVision()
	return self:GetAbility():GetSpecialValueFor("rune_2_vision")
end

function modifier_chaotic_eyes_in_the_back:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	if self.parent:PassivesDisabled() then
		return
	end
	if keys.attacker then
		local chance = self.chance_max
		if not self.parent:CanEntityBeSeenByMyTeam(keys.attacker) then
			chance = self.chance_min
		end
		if self:GetAbility():GetRuneType()==1 and self:GetAbility():IsCooldownReady() then
			chance = 100
			self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("rune_1_cd"))
		end
		if chance>= RandomFloat(1, 100)  then
			local pos = self.parent:GetOrigin()
			local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_eyes_in_the_back/main/effectend.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
			-- ParticleManager:SetParticleControl( pfx, 0, pos)
			ParticleManager:SetParticleControlEnt( pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , self.parent:GetOrigin(), true )
			DestroyParticleByDelay(pfx,1)
			-- local pfx_eye = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_apex_quas_eye_b.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
			-- ParticleManager:SetParticleControl( pfx_eye, 3, Vector(pos.x,pos.y,pos.z + 400))
			-- DestroyParticleByDelay(pfx_eye,1)
			self.parent:EmitSound("Hero_PhantomAssassin.Blur.Break")
			return -100
		end
	end

	return 0
end