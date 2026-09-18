-- 每次触发伤害后 减少10%层数
modifier_hd_elecshocking = advanced_modifier({})
function modifier_hd_elecshocking:GetTexture()
	return "disruptor_electromagnetic_repulsion"
end
function modifier_hd_elecshocking:IsHidden() return false end
function modifier_hd_elecshocking:IsDebuff() return true end
function modifier_hd_elecshocking:IsPurgable() return false end
function modifier_hd_elecshocking:IsPurgeException() return false end
function modifier_hd_elecshocking:IsStunDebuff() return false end
function modifier_hd_elecshocking:AllowIllusionDuplicate() return false end
function modifier_hd_elecshocking:OnCreated(keys)
	if IsServer() then
        self.max_stack = self:GetStackCount()
        self.elecshocking_attacker_list = {}
		self:StartIntervalThink(GetElecshockingTicktime(self:GetParent()))
	end
end

function modifier_hd_elecshocking:ApplyElecshockingStack(stack,caster,ability)
    self:SetStackCount(math.min(stack*10+self:GetStackCount(),3000))
    self.max_stack = self:GetStackCount()
    
    -- 在表里就移除 然后加到最前
    for i, data in ipairs(self.elecshocking_attacker_list) do
        if data.unit==caster then
            table.remove(self.elecshocking_attacker_list,i)
            break
        end
    end
    table.insert(self.elecshocking_attacker_list,1,{unit=caster,ability=ability})
	return stack*10
end

function modifier_hd_elecshocking:OnDestroy(params)
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end

function modifier_hd_elecshocking:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
        if not hParent:IsAlive() then return end
        
		self:StartIntervalThink(GetElecshockingTicktime(hParent))

        local iParticleID = ParticleManager:CreateParticle("particles/rebuild/spell/static_field/effect_yellow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
        DestroyParticleByDelay(iParticleID,1)
	end
end

function modifier_hd_elecshocking:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_hd_elecshocking:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()}
	}
end
function modifier_hd_elecshocking:OnTooltip()
	return self:GetStackCount()*0.1
end
function modifier_hd_elecshocking:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    if not IsLightningDamage(keys) then return end
	print("是雷属性伤害")
	return self:GetStackCount()*0.1
end
