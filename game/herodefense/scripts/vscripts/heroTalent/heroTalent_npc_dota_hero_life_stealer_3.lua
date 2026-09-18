LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_life_stealer_3_buff", "heroTalent/heroTalent_npc_dota_hero_life_stealer_3", LUA_MODIFIER_MOTION_NONE )



heroTalent_npc_dota_hero_life_stealer_3 = class({})


function heroTalent_npc_dota_hero_life_stealer_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/life_stealer_3/effect_main/effect.vpcf", context )
end


function heroTalent_npc_dota_hero_life_stealer_3:CastFilterResultTarget( target )
	if IsServer() then
		if target==self:GetCaster() then
			self._error = "#DOTA_HUB_CANT_CAST_TO_TARGET"
			return UF_FAIL_CUSTOM
		end
		
		return UF_SUCCESS
	end
	
end
function heroTalent_npc_dota_hero_life_stealer_3:GetCustomCastErrorTarget( target )
	if IsServer() then
	    return self._error
	end
end

function heroTalent_npc_dota_hero_life_stealer_3:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if IsValid(self.modifier) then
		self.modifier:Destroy()
	end


	self.modifier = caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_life_stealer_3_buff", {}) 
	if self.modifier then
		caster:EmitSound("Hero_LifeStealer.OpenWounds.Cast")
		self.modifier:Init(target)
	end

end

function heroTalent_npc_dota_hero_life_stealer_3:InitAbilityLink(target)
	local caster = self:GetCaster()
	local ability = target:FindAbilityByName("Advanced_Soul_Link")
	if ability then
		ability:SpecialEffect_Lifestealer(caster)
	end
	local ability2 = target:FindAbilityByName("Advanced_Eldwurm_soul_Slyrak")
	if ability2 then
		ability2:SpecialEffect_Lifestealer(caster)
	end
end

function heroTalent_npc_dota_hero_life_stealer_3:RemoveLink()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_Advanced_Soul_Link_summoned")
	caster:RemoveModifierByName("modifier_Advanced_Eldwurm_soul_Slyrak_effect")
	caster:RemoveModifierByName("modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15")
end


modifier_heroTalent_npc_dota_hero_life_stealer_3_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:OnCreated(keys)
	self.range = self:GetAbility():GetSpecialValueFor("range")
	self.damage_reduction = -self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.damage_inheritance = self:GetAbility():GetSpecialValueFor("damage_inheritance")*0.01
	self.bonus_damage = 0
end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:Init(target)
	self.target = target
	self.enable = true
	self:GetAbility():InitAbilityLink(target)
	self:StartIntervalThink(1)

	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/life_stealer_3/effect_main/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.target, PATTACH_POINT_FOLLOW, "attach_attack1", self.target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(self.range+100,0,0))
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		local caster = self:GetCaster()
		caster:RemoveModifierByName("modifier_Advanced_Soul_Link_summoned")
		caster:RemoveModifierByName("modifier_Advanced_Eldwurm_soul_Slyrak_effect")
		caster:RemoveModifierByName("modifier_Advanced_Eldwurm_soul_Slyrak_effect_over_LV15")
	end
end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:OnIntervalThink()
	if IsValid(self.target) then
		if CalculateDistance(self.target,self:GetParent())<=self.range then
			local damage = self.target:GetDamageMax() * self.damage_inheritance * self.target:GetSummonIntensityIndex(1)
			if damage>=1 then
				if not self.enable then
					self.enable = true
					self:GetAbility():InitAbilityLink(self.target)
				end
				self:SetStackCount(math.min(damage,10000))
			else
				if self.enable then
					self.enable = false
					self:GetAbility():RemoveLink()
				end
				self:SetStackCount(0)
			end
		else
			if self.enable then
				self.enable = false
				self:GetAbility():RemoveLink()
			end
			self:SetStackCount(0)
		end
	else
		self:Destroy()
	end
end







function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:ADDeclareFunctions()
	local funcs ={
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
    
end



function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:Advanced_GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:Advanced_GetModifierIncomingDamage_Percentage()
	if self:GetStackCount()==0 then
		return 0 
	end
	return self.damage_reduction
end
function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_heroTalent_npc_dota_hero_life_stealer_3_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierIncomingDamage_Percentage()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierPreAttack_BonusDamage()
	end
end