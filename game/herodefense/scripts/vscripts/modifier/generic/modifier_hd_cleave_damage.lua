-----------
modifier_hd_cleave_damage = advanced_modifier({})

function modifier_hd_cleave_damage:IsDebuff() return true end
function modifier_hd_cleave_damage:IsHidden() return false end
function modifier_hd_cleave_damage:IsPurgable() return false end
function modifier_hd_cleave_damage:IsPurgeException() return false end
function modifier_hd_cleave_damage:OnCreated(keys)
	if IsServer() then
        self.damage = keys.damage

		self:SetStackCount(self:GetStackCount() + self.damage)
		self:StartIntervalThink(0.25)
	end
end

function modifier_hd_cleave_damage:OnRefresh(keys)
	if IsServer() then
        self.damage = keys.damage
        
		self:SetStackCount(self:GetStackCount() + self.damage)
	end
end

function modifier_hd_cleave_damage:RefreshEnt(attacker, ability)
    if not IsServer() then return end
    
    self.attacker = attacker
    self.ability = ability
end

function modifier_hd_cleave_damage:OnIntervalThink()
	-- 确保attacker有效
	local attacker = self.attacker
	if not attacker or attacker:IsNull() then
		self:SetStackCount(0)
		self:SafeDestroy()
		return
	end

	local ability = self.ability

	-- 确保伤害值有效
	local damage = self:GetStackCount()
	if damage <= 0 then
		self:SafeDestroy()
		return
	end

	local damageTable = {
		victim = self:GetParent(),
		attacker = attacker,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT + DOTA_DAMAGE_FLAG_REFLECTION, 
		hd_flags = HD_DAMAGE_FLAG_NO_SPELL_CRIT
	}
	
	-- 只有当ability有效时才设置
	if ability and not ability:IsNull() then
		damageTable.ability = ability
	end
	
	ApplyDamage(damageTable)

	self:SetStackCount(0)
	self:SafeDestroy()
end