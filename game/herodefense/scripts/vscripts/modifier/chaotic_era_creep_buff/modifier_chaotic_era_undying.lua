
modifier_chaotic_era_undying = advanced_modifier({})

function modifier_chaotic_era_undying:IsHidden()return false end
function modifier_chaotic_era_undying:IsDebuff()return false end
function modifier_chaotic_era_undying:IsPurgable()return false end
function modifier_chaotic_era_undying:IsPurgeException() 	return false end
function modifier_chaotic_era_undying:RemoveOnDeath() return true end
function modifier_chaotic_era_undying:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_undying:GetTexture() return self.texture end
function modifier_chaotic_era_undying:Precache( context )
	PrecacheResource( "particle", "particles/ui/tips/muerta_death_reckoning_flames_green.vpcf", context )
end
function modifier_chaotic_era_undying:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus = GetChaticEraCreep_BuffSpecial(self,"value2")
    if IsServer() then
		local stack = GetChaticEraCreep_BuffSpecial(self,"value1") *( 1+GetGloabal_ChaoticEra__Undeath_StackGain()*0.01)
		self:SetStackCount(math.floor(stack))
    end
end



function modifier_chaotic_era_undying:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},
	}

	return funcs
end

function modifier_chaotic_era_undying:OnTakeDamage( params )

	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit

		if Target ~= self:GetParent() then
			return 0
		end
	
		if Target:GetHealth()<=0 then
		
			Target:SetHealth(1)
			-- Target:ModifyHealth(1,nil,false,0)
			local healing = HealWithGain(Target:GetMaxHealth()*self.bonus*0.01,Target,Target,nil)

			local effect_cast1 = ParticleManager:CreateParticle( "particles/ui/tips/muerta_death_reckoning_flames_green.vpcf", PATTACH_CUSTOMORIGIN, Target )
			ParticleManager:SetParticleControlEnt( effect_cast1, 0, Target, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
			DestroyParticleByDelay(effect_cast1,2)
			self:DecrementStackCount()
			if self:GetStackCount()<=0 then
				self:SafeDestroy()
			end
		end



	end

	return 0.0

end


function modifier_chaotic_era_undying:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_undying:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus
	end
end

