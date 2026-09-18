
chaotic_awaken = class({})
LinkLuaModifier("modifier_chaotic_awaken", "chaotic_spell/class_5/chaotic_awaken", LUA_MODIFIER_MOTION_NONE)



function chaotic_awaken:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_awaken/effect_target/effect_cast_enemy.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", context )


	
end

function chaotic_awaken:CastFilterResultTarget( hTarget )
	if self:GetCaster()==hTarget then
		self.error = "DOTA_HUB_CANT_CAST_TO_TARGET"
		return UF_FAIL_CUSTOM
	end
	if not hTarget.GetIntellect then
		return
	end
	if hTarget:GetIntellect(false)>=self:GetCaster():GetIntellect(false) then
		self.error = "DOTA_HUB_CANT_CAST_TO_TARGET"
		return UF_FAIL_CUSTOM
	end

	local result = self.BaseClass.CastFilterResultTarget(self,hTarget)
	return result or UF_SUCCESS
end

function chaotic_awaken:GetCustomCastErrorTarget( hTarget )
	return self.error
end



function chaotic_awaken:Spawn()
	if IsServer() then
		self.singleCastList = {}
	end
end


function chaotic_awaken:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_awaken_target"    
	EmitSoundOn(sound_cast, caster)    

	self:CheckSingleCasting()
	local gain = self:GetEffectGain()
	self:ApplyModifier(target, self:GetSpecialValueFor("duration")*gain)
end

function chaotic_awaken:ApplyModifier(target, duration)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_awaken/effect_target/effect_cast_enemy.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin()+Vector(0,0,64))
	-- ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,3)
	target:RemoveModifierByName("modifier_chaotic_awaken")
	local gain = caster:GetModifierDurationGainIndex(1)
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_awaken", {duration = duration*gain})
	if modifier then
		table.insert(self.singleCastList,modifier)
	end
end

function chaotic_awaken:CheckSingleCasting()
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

modifier_chaotic_awaken = advanced_modifier({})

function modifier_chaotic_awaken:IsHidden() return false end
function modifier_chaotic_awaken:IsPurgable() return true end
function modifier_chaotic_awaken:IsDebuff() return false end

function modifier_chaotic_awaken:OnCreated(keys)
	if IsServer() then
		local casterInt = self:GetCaster():GetIntellect(false)
		local targetInt = self:GetParent():GetIntellect(false)
		-- self:SetStackCount((casterInt-targetInt)* self:GetAbility():GetSpecialValueFor("bonus_int")*0.01)

		self.bonus_int = (casterInt-targetInt)* self:GetAbility():GetSpecialValueFor("bonus_int")*0.01
		self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
		self.runeType = self:GetAbility():GetRuneType()
		if self.runeType==1 then
			self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
			self.rune_1_bonus_max = self:GetAbility():GetSpecialValueFor("rune_1_bonus_max")
			self.rune_1_require = self:GetAbility():GetSpecialValueFor("rune_1_require")
		end
		self:SetHasCustomTransmitterData( true )
	end

end
function modifier_chaotic_awaken:OnRefresh(keys)
	if IsServer() then
		local casterInt = self:GetCaster():GetIntellect(false)
		local targetInt = self:GetParent():GetIntellect(false)
		-- self:SetStackCount((casterInt-targetInt)* self:GetAbility():GetSpecialValueFor("bonus_int")*0.01)
		self.bonus_int = (casterInt-targetInt)* self:GetAbility():GetSpecialValueFor("bonus_int")*0.01
		self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
		self:SetStackCount(0)
	end

end
function modifier_chaotic_awaken:AddCustomTransmitterData( )
	return
	{
		bonus_int = self.bonus_int,
	}
end

function modifier_chaotic_awaken:HandleCustomTransmitterData( data )
	self.bonus_int = data.bonus_int
end

function modifier_chaotic_awaken:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_awaken:OnTooltip() return self:Advanced_GetModifierBonusStats_Intellect() end

function modifier_chaotic_awaken:ADDeclareFunctions()
	local funcs={
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,-- "Advanced_GetModifierBonusStats_Intellect", --智力加成
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { nil,nil },

	
    }
	if not self:GetAbility() then
		return funcs
	end
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS)
	end
    return funcs
    


	
end
function modifier_chaotic_awaken:Advanced_GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_chaotic_awaken:Advanced_GetModifierSpellAmplifyBonus()
	return self:GetStackCount()
end


function modifier_chaotic_awaken:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() then 
		local mana_cast = keys.ability:GetManaCost(keys.ability:GetLevel())
		if mana_cast < 1 then
			return
		end
		local caster = self:GetCaster()
		caster:GiveMana(mana_cast)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, mana_cast, nil)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, keys.unit)
		ParticleManager:SetParticleControlEnt(particle, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_attack1", keys.unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle) 
	elseif keys.unit==self:GetCaster() then
		if self.runeType==1 then
			if keys.ability:GetCooldown(keys.ability:GetLevel()) >= self.rune_1_require then
				self:SetStackCount(math.min(self.rune_1_bonus_max,self:GetStackCount()+self.rune_1_bonus))
			end
		end
	end
	
end
