LinkLuaModifier("modifier_chaotic_era_chaotic_executive_debuff", "modifier/chaotic_era_creep_buff/modifier_chaotic_era_chaotic_executive", LUA_MODIFIER_MOTION_NONE)



modifier_chaotic_era_chaotic_executive = advanced_modifier({})

function modifier_chaotic_era_chaotic_executive:IsHidden()return false end
function modifier_chaotic_era_chaotic_executive:IsDebuff()return false end
function modifier_chaotic_era_chaotic_executive:IsPurgable()return true end
function modifier_chaotic_era_chaotic_executive:IsPurgeException() 	return true end
function modifier_chaotic_era_chaotic_executive:RemoveOnDeath() return true end
function modifier_chaotic_era_chaotic_executive:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_chaotic_executive:GetTexture() return self.texture end
function modifier_chaotic_era_chaotic_executive:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_pulse_flame.vpcf", context )

end
function modifier_chaotic_era_chaotic_executive:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus1 = GetChaticEraCreep_BuffSpecial(self,"value1")
	self.bonus2 = GetChaticEraCreep_BuffSpecial(self,"value2")
    if IsServer() then

    end
end
function modifier_chaotic_era_chaotic_executive:CheckState()
	return{
		[MODIFIER_STATE_CANNOT_MISS] = true

	}
end


function modifier_chaotic_era_chaotic_executive:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_chaotic_era_chaotic_executive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.damage>0 and not keys.target:IsMagicImmune() then

		

		local effect_cast1 = ParticleManager:CreateParticle( "particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_pulse_flame.vpcf", PATTACH_CUSTOMORIGIN, keys.target )
		ParticleManager:SetParticleControlEnt( effect_cast1, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( effect_cast1, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1" ,Vector(0,0,0), true )
		DestroyParticleByDelay(effect_cast1,1)

		local StatusResistance = keys.target:GetHDStatusResistanceIndex(0.8)
		local fury_swipes_debuff_handler = keys.target:AddNewModifier(self:GetParent(), nil, "modifier_chaotic_era_chaotic_executive_debuff", {duration = self.bonus2*StatusResistance})
	end
	
end


function modifier_chaotic_era_chaotic_executive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_chaotic_executive:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus1
	elseif self._tooltip == 2 then
		return  self.bonus2
	end
end




modifier_chaotic_era_chaotic_executive_debuff = advanced_modifier({})

function modifier_chaotic_era_chaotic_executive_debuff:IsDebuff()			return true end
function modifier_chaotic_era_chaotic_executive_debuff:IsHidden() 			return false end
function modifier_chaotic_era_chaotic_executive_debuff:IsPurgable() 			return true end
-- function modifier_chaotic_era_chaotic_executive_debuff:IsPurgeException() 	return false end
function modifier_chaotic_era_chaotic_executive_debuff:GetTexture() return self.texture end
-- function modifier_chaotic_era_chaotic_executive_debuff:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", context )

-- end
function modifier_chaotic_era_chaotic_executive_debuff:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture("modifier_chaotic_era_chaotic_executive")
    self.bonus1 = GetChaticEraCreep_BuffSpecial("modifier_chaotic_era_chaotic_executive","value1")
	-- self.bonus2 = -GetChaticEraCreep_BuffSpecial("modifier_chaotic_era_chaotic_executive","value2")
    if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
    end
end


function modifier_chaotic_era_chaotic_executive_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_chaotic_era_chaotic_executive_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end








function modifier_chaotic_era_chaotic_executive_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -math.min(self.bonus1*self:GetStackCount(),80)
end


function modifier_chaotic_era_chaotic_executive_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL}
	return funcs
end



function modifier_chaotic_era_chaotic_executive_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_chaotic_executive_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	end
end

