chaotic_Bloodrage = class({})
LinkLuaModifier("modifier_chaotic_Bloodrage", "chaotic_spell/class_8/chaotic_Bloodrage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Bloodrage_buff", "chaotic_spell/class_8/chaotic_Bloodrage", LUA_MODIFIER_MOTION_NONE)

function chaotic_Bloodrage:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", context )
end

function chaotic_Bloodrage:GetBehavior()
	if self:GetRuneType() == 1 then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
	if self:GetRuneType() == 3 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return self.BaseClass.GetBehavior( self )
end

function chaotic_Bloodrage:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chaotic_Bloodrage_buff", {stack = self:GetSpecialValueFor("outgoing_phy")})
		self:EndCooldown()
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_chaotic_Bloodrage_buff", self:GetCaster())
	end
end


function chaotic_Bloodrage:OnSpellStart()
	local caster = self:GetCaster()
	local target = caster
	local duration = self:GetSpecialValueFor("duration")
    self.outgoing_phy = self:GetSpecialValueFor("outgoing_phy")

	self:PlayEffects(target, duration, self.outgoing_phy)
end

function chaotic_Bloodrage:PlayEffects(target,duration,stack)
    local caster = self:GetCaster()
    local duration = duration or 10
    local stack = stack or 0

    target:AddNewModifier(caster, self, "modifier_chaotic_Bloodrage_buff", {duration = duration, stack = stack})
	caster:EmitSound("hero_bloodseeker.bloodRage")
end

function chaotic_Bloodrage:GetIntrinsicModifierName()
	return	"modifier_chaotic_Bloodrage"
end
----------------------------------------------------------------------------
modifier_chaotic_Bloodrage = advanced_modifier({})

function modifier_chaotic_Bloodrage:IsDebuff() return false end
function modifier_chaotic_Bloodrage:IsHidden() return true end
function modifier_chaotic_Bloodrage:IsPurgable() return false end
function modifier_chaotic_Bloodrage:IsPurgeException() return false end

function modifier_chaotic_Bloodrage:OnCreated(keys)
	local ability = self:GetAbility()
	self.outgoing_phy_pass = ability:GetSpecialValueFor("outgoing_phy_pass")
	if ability:GetRuneType() == 3 then
		self.outgoing_phy_pass = self.outgoing_phy_pass*(1+ability:GetSpecialValueFor("rune_3_index")*0.01)
	end
end

function modifier_chaotic_Bloodrage:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_chaotic_Bloodrage:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys) 
    if not self:GetAbility() then self:Destory() return end
	if keys.damage_type == DAMAGE_TYPE_PHYSICAL   then
		return self.outgoing_phy_pass
	end
	return 0
end
-------------------------------------------------------------------------
modifier_chaotic_Bloodrage_buff = advanced_modifier({})

function modifier_chaotic_Bloodrage_buff:IsDebuff() return false end
function modifier_chaotic_Bloodrage_buff:IsHidden() return false end
function modifier_chaotic_Bloodrage_buff:IsPurgable() return false end
function modifier_chaotic_Bloodrage_buff:IsPurgeException() return false end
function modifier_chaotic_Bloodrage_buff:GetEffectName() return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf" end
function modifier_chaotic_Bloodrage_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_chaotic_Bloodrage_buff:OnCreated(keys)
    if not self:GetAbility() then self:Destory() return end
    
	local ability = self:GetAbility()
	self.hp_cost = ability:GetSpecialValueFor("hp_cost")*0.01
	self.armor_down = ability:GetSpecialValueFor("armor_down")
	

	if IsServer() then
        self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_Bloodrage_buff:OnRefresh(keys)
    if not self:GetAbility() then self:Destory() return end
    
	local ability = self:GetAbility()
	self.hp_cost = ability:GetSpecialValueFor("hp_cost")*0.01
	self.armor_down = ability:GetSpecialValueFor("armor_down")
	self.rune_2_crit = ability:GetSpecialValueFor("rune_2_crit")
	self.rune_2_hp = ability:GetSpecialValueFor("rune_2_hp")

	if IsServer() then
        self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
	end
end

function modifier_chaotic_Bloodrage_buff:OnDestroy()
	if not IsServer() then
		return
	end
	if not self:GetAbility() or self:GetAbility():GetRuneType() ~= 1 then
		return 
	end

	self:GetAbility():UseResources(false, false, false, true)
	if self:GetAbility():GetToggleState() then
		self:GetAbility():ToggleAbility()
	end
end

function modifier_chaotic_Bloodrage_buff:ADDeclareFunctions()
	local funcs = 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
    }
	if self:GetAbility():GetRuneType() == 2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp)
	end
	return funcs
end

function modifier_chaotic_Bloodrage_buff:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_chaotic_Bloodrage_buff:OnTooltip()
    return self:GetStackCount()
end

function modifier_chaotic_Bloodrage_buff:OnIntervalThink()
    if not self:GetAbility() then self:Destory() return end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local health = parent:GetHealth() -parent:GetMaxHealth()*self.hp_cost
	parent:ModifyHealth(health,ability,false,0)
	if ability:GetRuneType() == 1 then
		self:SetStackCount(math.max(self:GetStackCount()*0.7, ability:GetSpecialValueFor("rune_1_outgoing_min")))
	else
    	self:SetStackCount(self:GetStackCount()*0.7)
	end
end

function modifier_chaotic_Bloodrage_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys) 
    if not self:GetAbility() then self:Destory() return end
	if keys.damage_type == DAMAGE_TYPE_PHYSICAL   then
		return self:GetStackCount()
	end
	return 0
end

function modifier_chaotic_Bloodrage_buff:Advanced_GetModifierPhysicalArmorBonusPercentage(keys) 
    if not self:GetAbility() then self:Destory() return end
	return -self.armor_down
end

function modifier_chaotic_Bloodrage_buff:Advanced_GetModifier_PhysicalCriticalAmp()
	if not self:GetAbility() then self:Destory() return end
	return self.rune_2_crit* 100* (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()) / (self.rune_2_hp*self:GetParent():GetMaxHealth())
end