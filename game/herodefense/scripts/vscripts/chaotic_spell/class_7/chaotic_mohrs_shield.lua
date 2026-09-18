
chaotic_mohrs_shield = class({})
LinkLuaModifier("modifier_chaotic_mohrs_shield", "chaotic_spell/class_7/chaotic_mohrs_shield", LUA_MODIFIER_MOTION_NONE)



function chaotic_mohrs_shield:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_mohrs_shield/effect_buff/effect.vpcf", context )

end

-- function chaotic_mohrs_shield:CastFilterResultTarget( hTarget )
-- 	if self:GetCaster()==hTarget then
-- 		self.error = "DOTA_HUB_CANT_CAST_TO_TARGET"
-- 		return UF_FAIL_CUSTOM
-- 	end
-- 	if not hTarget.GetIntellect then
-- 		return
-- 	end
-- 	if hTarget:GetIntellect(false)>=self:GetCaster():GetIntellect(false) then
-- 		self.error = "DOTA_HUB_CANT_CAST_TO_TARGET"
-- 		return UF_FAIL_CUSTOM
-- 	end

-- 	local result = self.BaseClass.CastFilterResultTarget(self,hTarget)
-- 	return result or UF_SUCCESS
-- end

-- function chaotic_mohrs_shield:GetCustomCastErrorTarget( hTarget )
-- 	return self.error
-- end



function chaotic_mohrs_shield:Spawn()
	if IsServer() then
		self.singleCastList = {}
	end
end
function chaotic_mohrs_shield:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end



function chaotic_mohrs_shield:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end
function chaotic_mohrs_shield:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_mohrs_shield_target"    
	EmitSoundOn(sound_cast, caster)    

	self:CheckSingleCasting()
	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))
end

function chaotic_mohrs_shield:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	target:RemoveModifierByName("modifier_chaotic_mohrs_shield")
	local gain = caster:GetModifierDurationGainIndex(1)
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_mohrs_shield", {duration = duration*gain})
	if modifier then
		table.insert(self.singleCastList,modifier)
	end
end

function chaotic_mohrs_shield:CheckSingleCasting()
	local i = 0 
	local count = self:GetSpecialValueFor("single_count")-1
    while #self.singleCastList > count and #self.singleCastList>=1 do
		if IsValid(self.singleCastList[1]) then
			self.singleCastList[1]:Destroy()
		end
        table.remove(self.singleCastList, 1)
		-- 防止疏忽
		i = i +1
		if i>=50 then
			break
		end
    end
end


modifier_chaotic_mohrs_shield = advanced_modifier({})

function modifier_chaotic_mohrs_shield:IsHidden() return false end
function modifier_chaotic_mohrs_shield:IsPurgable() return true end
function modifier_chaotic_mohrs_shield:IsDebuff() return false end
function modifier_chaotic_mohrs_shield:OnCreated(keys)

	local ability = self:GetAbility()
	self.damage_reduction = -ability:GetSpecialValueFor("damage_reduction")
	


	if IsServer() then
		local parent = self:GetParent()
		local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_mohrs_shield/effect_buff/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true)
		-- local ex = parent:GetModelScale() * 100
		-- ParticleManager:SetParticleControl(pfx, 1, Vector(ex,ex,ex))
		self:AddParticle(pfx, false, false, 15, false, false)

		self.damage_require = ability:GetSpecialValueFor("damage_require")
		self.damage_reduction_index = 1


	
	end
end


function modifier_chaotic_mohrs_shield:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_mohrs_shield:OnTooltip() return self:Advanced_GetModifierIncomingDamage_Percentage() end


function modifier_chaotic_mohrs_shield:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
	if self:GetAbility():GetRuneType()==1 then
		self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")*0.01
		self.rune_1_bonus_max = self:GetAbility():GetSpecialValueFor("rune_1_bonus_max")*0.01+1
		funcs["MODIFIER_EVENT_ON_TAKEDAMAGE"]= {nil, self:GetParent()}
	end
    return funcs
   
end


function modifier_chaotic_mohrs_shield:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		if keys.damage<=(self.damage_reduction_index*self.damage_require*self:GetCaster():HDGetPrimaryStatValue()) then
			return -100
		end
	end
	return self.damage_reduction
end


function modifier_chaotic_mohrs_shield:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	return self.out_damage_reduction
end



function modifier_chaotic_mohrs_shield:OnTakeDamage(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local target = keys.unit
    if target == self:GetParent() then
		if keys.damage>0 then
			self.damage_reduction_index = math.min(self.damage_reduction_index+self.rune_1_bonus,self.rune_1_bonus_max)
		end

    end
end

