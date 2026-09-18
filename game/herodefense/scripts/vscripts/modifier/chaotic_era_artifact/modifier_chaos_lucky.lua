
modifier_chaos_lucky = advanced_modifier({})

function modifier_chaos_lucky:IsHidden()return true end
function modifier_chaos_lucky:IsDebuff()return false end
function modifier_chaos_lucky:IsPurgable()return false end
function modifier_chaos_lucky:IsPurgeException() 	return false end
function modifier_chaos_lucky:RemoveOnDeath() return false end
function modifier_chaos_lucky:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaos_lucky:DestroyOnExpire() return false end
function modifier_chaos_lucky:GetTexture() return "zuus_cloud" end

function modifier_chaos_lucky:OnCreated(keys)
    self.interval = GetChaticEra_Artifact_Special(self,"interval")
    self.outgoing_min = GetChaticEra_Artifact_Special(self,"outgoing_min") - 100
    self.outgoing_max = GetChaticEra_Artifact_Special(self,"outgoing_max") - 100
    self.duration = 0.6
    self.outgoing = 0
    if IsServer() then
        self:SetStackCount(0)
        self:StartIntervalThink(1)
    end
end

function modifier_chaos_lucky:OnIntervalThink()
    self:SetStackCount(math.max(self:GetStackCount()-1, 0))
end

function modifier_chaos_lucky:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end

function modifier_chaos_lucky:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	local attacker = self:GetCaster()
	local target = keys.target
    if not IsEnemy(attacker, target) then return end
    
    
    local random = math.random
	if self:GetRemainingTime() <= 0 and self:GetStackCount() <= 0 then
        self.outgoing = random(self.outgoing_min, self.outgoing_max)
        self:SetStackCount(self.interval)
        self:SetDuration(self.duration, true)

        print("随机结果为"..self.outgoing)
        if self.outgoing < 0 then
           self:SetStackCount(0) 
           self:SetDuration(0, true)
           print("减伤啦，立刻刷新")
        end
	end

    if self:GetRemainingTime() >= 0 then
        print("伤害生效")
        return self.outgoing
    end
end