
chaotic_eurythmics = chaotic_eurythmics or class({})



LinkLuaModifier("modifier_chaotic_eurythmics", "chaotic_spell/class_7/chaotic_eurythmics", LUA_MODIFIER_MOTION_NONE)





function chaotic_eurythmics:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_eurythmics/effect_target/effect_music_notes.vpcf", context )

	
end


function chaotic_eurythmics:GetCustomCastErrorTarget(target)
	return self.error
end

function chaotic_eurythmics:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target.GetPlayerOwnerID and caster.GetPlayerOwnerID  then
			if PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(),caster:GetPlayerOwnerID()) then
				self.error = "#DOTA_CUSTOM_CAST_DENY_DISABLE_HELP"
				return UF_FAIL_CUSTOM
			end
			
		end
		local result = self.BaseClass.CastFilterResultTarget(self,target)
		return result or UF_SUCCESS
	end
end





function chaotic_eurythmics:GetCooldown(iLevel)
	return self:GetSpecialValueFor("cooldown_time")
end


function chaotic_eurythmics:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()	
	self:ApplyModifier(target)
	caster:EmitSound("chaotic_eurythmics_target")
end





function chaotic_eurythmics:ApplyModifier(target)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_eurythmics/effect_target/effect_music_notes.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	DestroyParticleByDelay(particle_cast_fx,3)

	local gain = caster:GetModifierDurationGainIndex(1)
	target:AddNewModifier(caster, self, "modifier_chaotic_eurythmics", {duration =  self:GetSpecialValueFor("duration")*gain})


end



modifier_chaotic_eurythmics = advanced_modifier({})

function modifier_chaotic_eurythmics:IsHidden() return false end
function modifier_chaotic_eurythmics:IsPurgable() return false end
function modifier_chaotic_eurythmics:IsDebuff() return false end
function modifier_chaotic_eurythmics:OnCreated(keys)

	local ability = self:GetAbility()
	self.bonus_effect = ability:GetSpecialValueFor("bonus_effect")
	self.bonus_mana_cost = ability:GetSpecialValueFor("bonus_mana_cost")
	self.level_require = 3
	if ability:GetRuneType()==1 then
		self.level_require = 4
	end
	self.abilityList = {}
	if IsServer() then
		self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )

		

	end

end


function modifier_chaotic_eurythmics:OnRemoved()
	if not IsServer() then return end
	FilterManager:RemoveExecuteOrderFilter( self.filter )
end

function modifier_chaotic_eurythmics:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,  
	}
end


function modifier_chaotic_eurythmics:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifier_ChaoticSpellEffectGain()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifier_ChaoticSpellManaCostGain()
	end
end



function modifier_chaotic_eurythmics:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_EFFECT_GAIN,  
		advanced_MODIFIER_PROPERTY_CHAOTIC_SPELL_MANA_COST_GAIN,  
	
    }
end

function modifier_chaotic_eurythmics:Advanced_GetModifier_ChaoticSpellEffectGain(keys)
	if not keys then
		return self.bonus_effect
	end
	if keys.ability then
		local level = self:GetAbilityClassLevel(keys.ability)
		if level<=self.level_require and level>=1 then
			return self.bonus_effect
		end
	end
	return 0
end

function modifier_chaotic_eurythmics:Advanced_GetModifier_ChaoticSpellManaCostGain(keys)
	if not keys then
		return self.bonus_mana_cost
	end
	if keys.ability then
		local level = self:GetAbilityClassLevel(keys.ability)
		if level<=self.level_require and level>=1 then
			return self.bonus_mana_cost
		end
	end
	return 0
end




function modifier_chaotic_eurythmics:OrderFilter( data )
	local parent = self:GetParent()
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==parent then
			found = true
		end
	end
	if not found then return true end
	
	if data.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
		data.order_type==DOTA_UNIT_ORDER_CAST_TARGET  or
		data.order_type==DOTA_UNIT_ORDER_CAST_NO_TARGET
	then
		if data.entindex_ability then
			local ability =EntIndexToHScript( data.entindex_ability)
			if ability and not ability:IsItem() then
				local level =  self:GetAbilityClassLevel(ability)
				if level>self.level_require then
					SendCustomErrorToPlayer(data.issuer_player_id_const,"HUD_ClassLevel_not_match","General.Cancel")
					return false
				end
	
			end
		end
		-- dota_hud_silence_cast
		
	end
	
	return true
end


function modifier_chaotic_eurythmics:GetAbilityClassLevel(ability)
	local abilityName = ability:GetAbilityName()
	if not self.abilityList[abilityName] then
		self.abilityList[abilityName] = -1
		-- 此技能增益只对环技能生效 且只对三环以内技能生效
		-- TODO 对武技无效
		local kv = KeyValues.ability_bonus_info[abilityName]
		if kv and kv.ChaoticSpell_ClassLevel then
			self.abilityList[abilityName] = kv.ChaoticSpell_ClassLevel
		end
	end
	return self.abilityList[abilityName]
end