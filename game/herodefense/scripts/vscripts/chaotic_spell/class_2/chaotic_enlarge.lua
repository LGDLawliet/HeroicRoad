
chaotic_enlarge = class({})
LinkLuaModifier("modifier_chaotic_enlarge", "chaotic_spell/class_2/chaotic_enlarge", LUA_MODIFIER_MOTION_NONE)



function chaotic_enlarge:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_enlarge/target_effect_hit.vpcf", context )

end

function chaotic_enlarge:Spawn()
	if IsServer() then
		self.singleCastList = {}
	end
end
function chaotic_enlarge:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_enlarge:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_enlarge_target"    
	EmitSoundOn(sound_cast, caster)    

	self:CheckSingleCasting()
	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))
end

function chaotic_enlarge:ApplyModifier(target, duration)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_enlarge/hit_effect/effect.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" , target:GetOrigin(), true )
	DestroyParticleByDelay(particle_cast_fx,3)
	local gain = caster:GetModifierDurationGainIndex(1)
	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_enlarge", {duration = duration*gain})
	if modifier then
		table.insert(self.singleCastList,modifier)
	end
end

function chaotic_enlarge:CheckSingleCasting()
	local i = 0 
	local count = self:GetSpecialValueFor("single_count")-1
	if self:GetRuneType()==1 then
		count = count + self:GetSpecialValueFor("rune_1_bonus_count")
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


modifier_chaotic_enlarge = advanced_modifier({})

function modifier_chaotic_enlarge:IsHidden() return false end
function modifier_chaotic_enlarge:IsPurgable() return true end
function modifier_chaotic_enlarge:IsDebuff() return false end

function modifier_chaotic_enlarge:OnCreated(keys)
	local gain = self:GetAbility():GetEffectGain()
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str") * gain
	self.bonus_model_scale = self:GetAbility():GetSpecialValueFor("bonus_model_scale")* gain
end


function modifier_chaotic_enlarge:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_enlarge:OnTooltip() return self:Advanced_GetModifierBonusStats_Strength() end
function modifier_chaotic_enlarge:GetModifierModelScale()	return self.bonus_model_scale end
function modifier_chaotic_enlarge:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,

	
    }
end
function modifier_chaotic_enlarge:Advanced_GetModifierBonusStats_Strength()
	return self.bonus_str
end