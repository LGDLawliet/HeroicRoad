modifier_item_set_tree_active = advanced_modifier({})

function modifier_item_set_tree_active:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/items/set_tree/time.vpcf", context )
end
function modifier_item_set_tree_active:IsDebuff()return true end
function modifier_item_set_tree_active:IsHidden()return false end
function modifier_item_set_tree_active:IsPurgable()return false end
function modifier_item_set_tree_active:RemoveOnDeath()return false end
function modifier_item_set_tree_active:GetTexture() return "sven/fiend_cleaver_icons/sven_gods_strength" end

function modifier_item_set_tree_active:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
        self:StartIntervalThink(1)
        self.time = 3
        self.particle = ParticleManager:CreateParticle("particles/rebuild/items/set_tree/time.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl( self.particle, 1, Vector(0,self.time,0) )
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end

function modifier_item_set_tree_active:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
        self.time = 3
        self.particle = ParticleManager:CreateParticle("particles/rebuild/items/set_tree/time.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl( self.particle, 1, Vector(0,self.time,0) )
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end

function modifier_item_set_tree_active:OnIntervalThink()
    ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = nil, damage = self:GetStackCount(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_REFLECTION})
    
    self.time = self.time - 1
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self.time,0))
	if self.time <= 0 then
		ParticleManager:DestroyParticle(self.particle,true)
	end
end


function modifier_item_set_tree_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_set_tree_active:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:GetStackCount()
	end
end