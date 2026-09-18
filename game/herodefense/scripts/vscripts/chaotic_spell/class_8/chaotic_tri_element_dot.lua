
chaotic_tri_element_dot = class({})
LinkLuaModifier("modifier_chaotic_tri_element_dot", "chaotic_spell/class_8/chaotic_tri_element_dot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_element_dot_buff", "chaotic_spell/class_8/chaotic_tri_element_dot", LUA_MODIFIER_MOTION_NONE)

function chaotic_tri_element_dot:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", context )
end

function chaotic_tri_element_dot:GetIntrinsicModifierName()
	return "modifier_chaotic_tri_element_dot"
end

-----------------------------------------------------------
modifier_chaotic_tri_element_dot = advanced_modifier({})

function modifier_chaotic_tri_element_dot:IsHidden() return true end
function modifier_chaotic_tri_element_dot:IsPurgable() return false end
function modifier_chaotic_tri_element_dot:IsDebuff() return false end

function modifier_chaotic_tri_element_dot:OnCreated(keys)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	
    self.burn_freeze = self.ability:GetSpecialValueFor("burn_freeze")
    self.elecshock = self.ability:GetSpecialValueFor("elecshock")
	self.cost = self.ability:GetSpecialValueFor("cost") 
	self.cost_get = self.ability:GetSpecialValueFor("cost_get") 
	self.duration = self.ability:GetSpecialValueFor("duration")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
    self.cd = self.ability:GetSpecialValueFor("cooldown")
    self.type = self.ability:GetRuneType()
    if self.type == 1 then
        self.rune_1_index = self.ability:GetSpecialValueFor("rune_1_index")*0.01
    end

	if IsServer() then
        self:StartIntervalThink(0.3)
        self.burning_counter = 0
        self.freezing_counter = 0
        self.elecshocking_counter = 0
	end
end

function modifier_chaotic_tri_element_dot:OnRefresh(keys)
	self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	
    self.burn_freeze = self.ability:GetSpecialValueFor("burn_freeze")
    self.elecshock = self.ability:GetSpecialValueFor("elecshock")
	self.cost = self.ability:GetSpecialValueFor("cost") 
	self.cost_get = self.ability:GetSpecialValueFor("cost_get") 
	self.duration = self.ability:GetSpecialValueFor("duration")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_chaotic_tri_element_dot:OnIntervalThink()
    local trigger = self.caster:FindModifierByName("modifier_hd_trigger")
	if trigger and trigger:GetStackCount() >= self.cost and self.ability:GetAutoCastState() then
        if self.ability:IsCooldownReady() then
		   	self:PlayEffect(self.caster)    
            trigger:SetStackCount(trigger:GetStackCount() - self.cost)
            local cd = self.cd
            self.ability:StartCooldown(cd)
        end
    end
end

function modifier_chaotic_tri_element_dot:PlayEffect(unit)
	if not IsServer() then return end
	local target = unit
	
	target:EmitSound("Hero_Antimage.ManaVoidCast")

	local gain = self.caster:GetModifierDurationGainIndex(0.7)
	target:AddNewModifier(self.caster,self.ability,"modifier_chaotic_tri_element_dot_buff",{duration = self.duration*gain})
end

function modifier_chaotic_tri_element_dot:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_BURNING = {nil, nil},
        MODIFIER_EVENT_ON_FREEZING = {nil,nil},
        MODIFIER_EVENT_ON_ELECSHOCKING = {nil,nil}
	}
end

function modifier_chaotic_tri_element_dot:AdvancedOnBurning(keys)
	if not IsServer() then return end
	local ability = keys.inflictor
    local attacker = keys.attacker
    local value = keys.value
    local target = keys.target

    if not attacker or attacker ~= self.caster then return end

    if self.type == 1 and target:HasModifier("modifier_hd_elecshocking") then
        value = value * self.rune_1_index
    end
    self.burning_counter = self.burning_counter + value
    local get_need = self.burn_freeze*attacker:HDGetPrimaryStatValue() * 1.7

	if self.burning_counter >= get_need then
        local give_num = math.floor(self.burning_counter/get_need)
        self.burning_counter = self.burning_counter - give_num*get_need

        local cost_get = self.cost_get * math.min(give_num,3)
		attacker:AddNewModifier(attacker , self.ability, "modifier_hd_trigger",{cost_get = cost_get})
	end
end

function modifier_chaotic_tri_element_dot:AdvancedOnFreezing(keys)
	if not IsServer() then return end
	local ability = keys.inflictor
    local attacker = keys.attacker
    local value = keys.value
    local target = keys.target

    if not attacker or attacker ~= self.caster then return end

    if self.type == 1 and target:HasModifier("modifier_hd_burning") then
        value = value * self.rune_1_index
    end
    self.freezing_counter = self.freezing_counter + value
    local get_need = self.burn_freeze*attacker:HDGetPrimaryStatValue() * 1.7

	if self.freezing_counter >= get_need then
        local give_num = math.floor(self.freezing_counter/get_need)
        self.freezing_counter = self.freezing_counter - give_num*get_need

        local cost_get = self.cost_get * math.min(give_num,3)
		attacker:AddNewModifier(attacker , self.ability, "modifier_hd_trigger",{cost_get = cost_get})
	end
end

function modifier_chaotic_tri_element_dot:AdvancedOnElecshocking(keys)
	if not IsServer() then return end
	local ability = keys.inflictor
    local attacker = keys.attacker
    local value = keys.value
    local target = keys.target

    if not attacker or attacker ~= self.caster then return end

    if self.type == 1 and target:HasModifier("modifier_hd_freezing") then
        value = value * self.rune_1_index
    end
    self.elecshocking_counter = self.elecshocking_counter + value
    local get_need = self.elecshock

	if self.elecshocking_counter >= get_need then
        local give_num = math.floor(self.elecshocking_counter/get_need) * 1.7
        self.elecshocking_counter = self.elecshocking_counter - give_num*get_need

        local cost_get = self.cost_get * math.min(give_num,3)
		attacker:AddNewModifier(attacker , self.ability, "modifier_hd_trigger",{cost_get = cost_get})
	end
end
--------------
modifier_chaotic_tri_element_dot_buff = advanced_modifier({})

function modifier_chaotic_tri_element_dot_buff:IsHidden() return false end
function modifier_chaotic_tri_element_dot_buff:IsPurgable() return false end
function modifier_chaotic_tri_element_dot_buff:IsDebuff() return false end
function modifier_chaotic_tri_element_dot_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_tri_element_dot_buff:OnCreated(keys)
	self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing")
end

function modifier_chaotic_tri_element_dot_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_chaotic_tri_element_dot_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return self.outgoing
	end
end
