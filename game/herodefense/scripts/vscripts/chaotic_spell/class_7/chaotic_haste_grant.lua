
chaotic_haste_grant = class({})


-- LinkLuaModifier("modifier_chaotic_haste_grant", "chaotic_spell/class_7/chaotic_haste_grant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_haste_grant_thinker", "chaotic_spell/class_7/chaotic_haste_grant", LUA_MODIFIER_MOTION_NONE)



-- function chaotic_haste_grant:GetIntrinsicModifierName() return "modifier_chaotic_haste_grant" end
-- function chaotic_haste_grant:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_haste_grant/effect.vpcf", context )
-- 	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_haste_grant/effect_buff.vpcf", context )
-- end
function chaotic_haste_grant:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end


function chaotic_haste_grant:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		local pos = caster:GetAbsOrigin()
		CreateModifierThinker(caster, self, "modifier_chaotic_haste_grant_thinker", {}, pos, caster:GetTeamNumber(), false)
	end
end




-- modifier_chaotic_haste_grant= advanced_modifier({})

-- function modifier_chaotic_haste_grant:IsDebuff()			return false end
-- function modifier_chaotic_haste_grant:IsHidden() 			return true end
-- function modifier_chaotic_haste_grant:IsPurgable() 		return false end
-- function modifier_chaotic_haste_grant:IsPurgeException() 	return false end

-- function modifier_chaotic_haste_grant:OnCreated(keys)
-- 	if IsServer() then
-- 		local caster = self:GetCaster()
-- 		local pos = caster:GetAbsOrigin()
-- 		CreateModifierThinker(caster, self, "modifier_chaotic_haste_grant_thinker", {}, pos, caster:GetTeamNumber(), false)
-- 	end

-- end



modifier_chaotic_haste_grant_thinker= advanced_modifier({})

function modifier_chaotic_haste_grant_thinker:IsDebuff()			return false end
function modifier_chaotic_haste_grant_thinker:IsHidden() 			return true end
function modifier_chaotic_haste_grant_thinker:IsPurgable() 		return false end
function modifier_chaotic_haste_grant_thinker:IsPurgeException() 	return false end

function modifier_chaotic_haste_grant_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

function modifier_chaotic_haste_grant_thinker:OnCreated(keys)
	if IsServer() then
		self.ability = self:GetParent():AddAbility("chaotic_haste")
		if self.ability then
			self.ability:SetLevel(1)
		end
		self:GetParent():SetMaxMana(10000)
		self:GetParent():SetBaseManaRegen(500)
		self:StartIntervalThink(1)
	end

end
function modifier_chaotic_haste_grant_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
end

function modifier_chaotic_haste_grant_thinker:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_SUMMON = {self:GetCaster(), nil},  --生命汲取
		advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_CastPoint,
		advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN_MUL,  --法术效用乘法叠加


    }
end
function modifier_chaotic_haste_grant_thinker:Advanced_GetModifier_CastPoint() 
	return 100
end

function modifier_chaotic_haste_grant_thinker:Advanced_GetModifier_ChaoticSpellEffectGain_Mul() 
	-- print("aaaaaaaaaaaaa",self:GetAbility():GetSpecialValueFor("bonus_gain"))
	if self.rune_1_bonus then
		local bonus = self.rune_1_bonus
		self.rune_1_bonus = nil
		return self:GetAbility():GetSpecialValueFor("bonus_gain") + bonus
	end
	return self:GetAbility():GetSpecialValueFor("bonus_gain")
end




function modifier_chaotic_haste_grant_thinker:AdvancedOnSummon(keys)
	if IsServer() then
		local ability =  self:GetAbility()
		if not ability then
			self:Destroy()
		end
		local unit = keys.target
		if IsValid(self.ability) then
			if self:GetParent():GetCurrentActiveAbility() then
				return
			end
			if ability:GetCurrentAbilityCharges()<=0 then
				return
			end
			if ability:GetAutoCastState() then
				local charge = ability:GetCurrentAbilityCharges()-1
				if charge>=1 then
					self.rune_1_bonus = ability:GetSpecialValueFor("rune_1_bonus")*charge
				end

				ability:SetCurrentAbilityCharges(0)
			else
				ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()-1)
			end
			
			EmitSoundOn("chaotic_haste_target", unit)    
			self.ability:ApplyModifier(unit, self.ability:GetSpecialValueFor("duration"))
		end

	end
end




function modifier_chaotic_haste_grant_thinker:Advanced_GetModifierCastRangeBonusStacking()
    return 50000
end


function modifier_chaotic_haste_grant_thinker:DeclareFunctions() return 
	{
	 MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	 MODIFIER_PROPERTY_DISABLE_TURNING
    } 
end

function modifier_chaotic_haste_grant_thinker:GetModifierDisableTurning() 
    return 1
end
function modifier_chaotic_haste_grant_thinker:GetModifierIgnoreCastAngle()
    return 1
end
