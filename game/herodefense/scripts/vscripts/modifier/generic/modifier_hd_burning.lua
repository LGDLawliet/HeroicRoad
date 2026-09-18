-- 每次触发伤害后 减少10%层数
modifier_hd_burning = advanced_modifier({})
function modifier_hd_burning:GetTexture()
	return "ogre_magi_ignite"
end
function modifier_hd_burning:IsHidden() return false end
function modifier_hd_burning:IsDebuff() return true end
function modifier_hd_burning:IsPurgable() return false end
function modifier_hd_burning:IsPurgeException() return false end
function modifier_hd_burning:IsStunDebuff() return false end
function modifier_hd_burning:AllowIllusionDuplicate() return false end
function modifier_hd_burning:OnCreated(keys)
	if IsServer() then
        local iParticleID = ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
        self.max_stack = self:GetStackCount()
        self.burning_attacker_list = {}
		self:StartIntervalThink(GetBurningTicktime(self:GetParent()))
	end
end

function modifier_hd_burning:ApplyBurningStack(stack,caster,ability)
    self:SetStackCount(math.min(stack+self:GetStackCount(),1000000000))
    self.max_stack = self:GetStackCount()
    
    -- 在表里就移除 然后加到最前
    for i, data in ipairs(self.burning_attacker_list) do
        if data.unit==caster then
            table.remove(self.burning_attacker_list,i)
            break
        end
    end
    table.insert(self.burning_attacker_list,1,{unit=caster,ability=ability})
	return stack
end

function modifier_hd_burning:GetBurningStackCount()
	return math.min(self.max_stack*0.2, self:GetStackCount())
end

function modifier_hd_burning:OnDestroy(params)
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
function modifier_hd_burning:OnIntervalThink()
	if IsServer() then

		local hParent = self:GetParent()
		local iTotalDamge = 0
		local lastBurninger = self:GetParent() --实在不行的情况下，只能自己打自己
        
		for k, data in pairs(self.burning_attacker_list) do
			if IsValid(data.unit) then
				local burning_damage = math.min(self.max_stack*0.2, self:GetStackCount())
                iTotalDamge = ApplyBurningDamage(data.unit,data.ability,hParent, burning_damage)
                break
            end

		end
		self:StartIntervalThink(GetBurningTicktime(hParent))
		-- 头顶数字

		if iTotalDamge > 0 then
			iTotalDamge = math.min(iTotalDamge,999999999)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, hParent, iTotalDamge, self:GetCaster())
		end
        self:SetStackCount(self:GetStackCount() - (math.min(self.max_stack*0.2, self:GetStackCount())))
	end
end

function modifier_hd_burning:Burning_Frozen()
	if IsServer() then
		local hParent = self:GetParent()
		local iTotalDamge = 0
		local lastBurninger = self:GetParent() --实在不行的情况下，只能自己打自己
		for k, data in pairs(self.burning_attacker_list) do
			if IsValid(data.unit) then
				local burning_frozen_damage = self:GetStackCount()
                iTotalDamge = ApplyBurningDamage(data.unit,data.ability,hParent, burning_frozen_damage*1.3)
                break
            end
		end
		-- 头顶数字
		if iTotalDamge > 0 then
			iTotalDamge = math.min(iTotalDamge,999999999)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, hParent, iTotalDamge, self:GetCaster())
		end
        self:Destroy()
	end
end

function modifier_hd_burning:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_hd_burning:OnTooltip()
	return self:GetStackCount()
end
