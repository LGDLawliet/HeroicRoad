-- 每次触发伤害后 减少10%层数
modifier_hd_poison = advanced_modifier({})
function modifier_hd_poison:GetTexture()
	return "venomancer_noxious_plague"
end
function modifier_hd_poison:IsHidden() return false end
function modifier_hd_poison:IsDebuff() return true end
function modifier_hd_poison:IsPurgable() return false end
function modifier_hd_poison:IsPurgeException() return false end
function modifier_hd_poison:IsStunDebuff() return false end
function modifier_hd_poison:AllowIllusionDuplicate() return false end
function modifier_hd_poison:OnCreated(keys)
	if IsServer() then
        local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
        self.poison_attacker_list = {}
		self:StartIntervalThink(GetPoisonTicktime(self:GetParent()))
	end
end

function modifier_hd_poison:ApplyPoisonStack(stack,caster,ability)
    self:SetStackCount(math.min(stack+self:GetStackCount(),1000000000))

    -- 在表里就移除 然后加到最前
    for i, data in ipairs(self.poison_attacker_list) do
        if data.unit==caster then
            table.remove(self.poison_attacker_list,i)
            break
        end
    end
    table.insert(self.poison_attacker_list,1,{unit=caster,ability=ability})
	return stack
end

function modifier_hd_poison:GetPoisonStackCount()
	return self:GetStackCount()
end

function modifier_hd_poison:OnDestroy(params)
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
function modifier_hd_poison:OnIntervalThink()
	if IsServer() then

		local hParent = self:GetParent()
		local iTotalDamge = 0
		local lastPoisoner = self:GetParent() --实在不行的情况下，只能自己打自己
        
		for k, data in pairs(self.poison_attacker_list) do
			if IsValid(data.unit) then
				local poison_damage = self:GetStackCount()
				
				local lokustra = hParent:FindModifierByName("modifier_item_hd_poison_lokustra_spell")
				if lokustra then
					local healing = HealWithGain(self:GetStackCount(),hParent,hParent,data.ability)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hParent, healing, nil)
					poison_damage = 0
				end

                iTotalDamge = ApplyPoisonDamage(data.unit,data.ability,hParent, poison_damage)
                break
            end

		end
		self:StartIntervalThink(GetPoisonTicktime(hParent))
		-- 头顶绿色数字

		if iTotalDamge > 0 then
			iTotalDamge = math.min(iTotalDamge,999999999)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, hParent, iTotalDamge, self:GetCaster())
		end
        self:SetStackCount(self:GetStackCount()*0.8)
	end
end
function modifier_hd_poison:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_hd_poison:OnTooltip()
	return self:GetStackCount()
end
