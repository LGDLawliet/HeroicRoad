
chaotic_foresigh = class({})
LinkLuaModifier("modifier_chaotic_foresigh", "chaotic_spell/class_9/chaotic_foresigh", LUA_MODIFIER_MOTION_NONE)



function chaotic_foresigh:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_foresigh/effect_target/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", context )

end




function chaotic_foresigh:Spawn()
	if IsServer() then
		self.singleCastList = {}
	end
end
function chaotic_foresigh:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end



function chaotic_foresigh:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_foresigh_target"    
	EmitSoundOn(sound_cast, caster)    

	self:CheckSingleCasting()
	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))
end

function chaotic_foresigh:ApplyModifier(target, duration)

	

	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_foresigh/effect_target/effect.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 1, target, PATTACH_POINT_FOLLOW, "", target:GetAbsOrigin(), true)
	DestroyParticleByDelay(particle_cast_fx,2.5)


	local caster = self:GetCaster()
	target:RemoveModifierByName("modifier_chaotic_foresigh")
	local gain = caster:GetModifierDurationGainIndex(1)
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_foresigh", {duration = duration*gain})
	if modifier then
		table.insert(self.singleCastList,modifier)
	end
end

function chaotic_foresigh:CheckSingleCasting()
	local i = 0 
	local count = self:GetSpecialValueFor("single_count")-1
	if self:GetRuneType()==2 then
		count = count + self:GetSpecialValueFor("rune_2_bonus")
	end
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



modifier_chaotic_foresigh = advanced_modifier({})



function modifier_chaotic_foresigh:IsHidden() return false end
function modifier_chaotic_foresigh:IsPurgable() return true end
function modifier_chaotic_foresigh:IsDebuff() return false end
function modifier_chaotic_foresigh:OnCreated(keys)

	local ability = self:GetAbility()
	self.bonus_evasion = ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_trigger = ability:GetSpecialValueFor("bonus_trigger")
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	self.rune_type = ability:GetRuneType()
	self.rune_1_chance = ability:GetSpecialValueFor("rune_1_chance")
	self.rune_1_count = ability:GetSpecialValueFor("rune_1_count")


	if IsServer() then
		local parent = self:GetParent()
		-- local pfx = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_foresigh/effect_buff/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		-- ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true)
		-- local ex = parent:GetModelScale() * 100
		-- ParticleManager:SetParticleControl(pfx, 1, Vector(ex,ex,ex))
		-- self:AddParticle(pfx, false, false, 15, false, false)

		local count = ability:GetSpecialValueFor("count")
		self:SetStackCount(count)
	end
end
function modifier_chaotic_foresigh:OnRefresh(keys)

	local ability = self:GetAbility()
	self.bonus_evasion = ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_trigger = ability:GetSpecialValueFor("bonus_trigger")
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	if IsServer() then
		local parent = self:GetParent()
		local count = ability:GetSpecialValueFor("count")
		self:SetStackCount(count)
	end
end


function modifier_chaotic_foresigh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
end

function modifier_chaotic_foresigh:GetModifierEvasion_Constant() return self.bonus_evasion end
function modifier_chaotic_foresigh:Advanced_GetModifier_RandomEffectGain() return self.bonus_trigger end




function modifier_chaotic_foresigh:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self:GetModifierEvasion_Constant()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifier_RandomEffectGain()
	elseif self._tooltip == 3 then
		return self:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	end
end
function modifier_chaotic_foresigh:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL, -- 最终全伤害提升
		advanced_MODIFIER_PROPERTY_RandomEffectGain
    }
end




function modifier_chaotic_foresigh:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	local stack  =  self:GetStackCount()
	if IsServer() then
		if self.rune_type==1 then
			if self.rune_1_chance>=RandomInt(1, 100) then
				self:SetStackCount(self:GetStackCount()+self.rune_1_count)
			end
		
		end
	end
	if stack<=0 then
		return 0 
	end
	if IsServer() then
		if not IsEnemy(keys.target,self:GetParent()) then
			return 0
		end
		self:DecrementStackCount()
		self:PlayEffect(keys.target)
		return self.bonus_damage 
	end
	return self.bonus_damage
end



function modifier_chaotic_foresigh:PlayEffect(target)
	local particle_cast = "particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	DestroyParticleByDelay(particle_cast_fx,2.5)
end

