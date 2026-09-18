
modifier_hd_freezing = advanced_modifier({})
function modifier_hd_freezing:GetTexture()
	return "lich_chain_frost"
end
function modifier_hd_freezing:IsHidden() return false end
function modifier_hd_freezing:IsDebuff() return true end
function modifier_hd_freezing:IsPurgable() return false end
function modifier_hd_freezing:IsPurgeException() return false end
function modifier_hd_freezing:IsStunDebuff() return false end
function modifier_hd_freezing:AllowIllusionDuplicate() return false end
function modifier_hd_freezing:GetEffectName() return "particles/generic_gameplay/generic_frozen.vpcf" end
function modifier_hd_freezing:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_hd_freezing:OnCreated(keys)
	if IsServer() then
        -- local iParticleID = ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
        self.max_stack = self:GetStackCount()
        self.freezing_attacker_list = {}
        self.freezing_accumulated = 0
        self.freezing_threshold = 0.1
		self:StartIntervalThink(GetFreezingTicktime(self:GetParent()))
	end
end

function modifier_hd_freezing:ApplyFreezingStack(stack,caster,ability)
    self:SetStackCount(math.min(stack+self:GetStackCount(),1000000000))
    self.max_stack = self:GetStackCount()
    
    -- 在表里就移除 然后加到最前
    for i, data in ipairs(self.freezing_attacker_list) do
        if data.unit==caster then
            table.remove(self.freezing_attacker_list,i)
            break
        end
    end
    table.insert(self.freezing_attacker_list,1,{unit=caster,ability=ability})
	return stack
end

function modifier_hd_freezing:GetFreezingStackCount()
	return math.min(self.max_stack*0.1, self:GetStackCount())
end

function modifier_hd_freezing:OnDestroy(params)
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
function modifier_hd_freezing:OnIntervalThink()
	if IsServer() then

		local hParent = self:GetParent()
		local iTotalDamge = 0
		local lastFreezinger = self:GetParent() --实在不行的情况下，只能自己打自己
        
		for k, data in pairs(self.freezing_attacker_list) do
			if IsValid(data.unit) then
				local freezing_damage = math.min(self.max_stack*0.1, self:GetStackCount())
                iTotalDamge = ApplyFreezingDamage(data.unit,data.ability,hParent, freezing_damage)
                break
            end

		end
		self:StartIntervalThink(GetFreezingTicktime(hParent))
		-- 头顶数字

		if iTotalDamge > 0 then
			iTotalDamge = math.min(iTotalDamge,999999999)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, hParent, iTotalDamge, self:GetCaster())
		end
        self:SetStackCount(self:GetStackCount() - (math.min(self.max_stack*0.1, self:GetStackCount())))
	end
end
function modifier_hd_freezing:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_hd_freezing:OnTooltip()
	return self:GetStackCount()
end
function modifier_hd_freezing:ADDeclareFunctions()
    return{
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_hd_freezing:AdvancedGetModifierConstantHealthRegenAmpPercentage()
    return -40
end
function modifier_hd_freezing:Advanced_GetModifierHealReceiveAMP_Percentage()
    return -40
end
-------
modifier_hd_freezing_frozen = advanced_modifier({})
function modifier_hd_freezing_frozen:GetTexture()
	return "tusk_ice_shards"
end
function modifier_hd_freezing_frozen:IsHidden() return false end
function modifier_hd_freezing_frozen:IsDebuff() return true end
function modifier_hd_freezing_frozen:IsPurgable() return false end
function modifier_hd_freezing_frozen:IsPurgeException() return false end
function modifier_hd_freezing_frozen:IsStunDebuff() return false end
function modifier_hd_freezing_frozen:AllowIllusionDuplicate() return false end
function modifier_hd_freezing_frozen:GetPriority() return 1000 end
function modifier_hd_freezing_frozen:OnCreated(keys)
    local parent = self:GetParent()
    if IsServer() then
	    self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	    ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
	    self:AddParticle( self.nFXIndex, false, false, -1, true, false )

        local burning = parent:FindModifierByName("modifier_hd_burning")
        if burning then
            burning:Burning_Frozen()
            self:Destroy()
        end
    end
end
function modifier_hd_freezing_frozen:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.nFXIndex)
	end
end
function modifier_hd_freezing_frozen:CheckState()
    return{
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
    }
end
function modifier_hd_freezing_frozen:DeclareFunctions()
    return{
       MODIFIER_PROPERTY_DISABLE_HEALING
    }
end
function modifier_hd_freezing_frozen:GetDisableHealing()
    return 1
end