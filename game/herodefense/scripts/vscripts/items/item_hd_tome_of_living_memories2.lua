item_hd_tome_of_living_memories2 = class({})

LinkLuaModifier("modifier_item_hd_tome_of_living_memories2", "items/item_hd_tome_of_living_memories2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tome_of_living_memories2_active", "items/item_hd_tome_of_living_memories2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tome_of_living_memories2_active_shell", "items/item_hd_tome_of_living_memories2", LUA_MODIFIER_MOTION_NONE)


function item_hd_tome_of_living_memories2:GetIntrinsicModifierName()
	return "modifier_item_hd_tome_of_living_memories2"
end



function item_hd_tome_of_living_memories2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_soul_assumption_bolt1.vpcf", context )

end






modifier_item_hd_tome_of_living_memories2 = advanced_modifier({})

function modifier_item_hd_tome_of_living_memories2:IsDebuff() return false end
function modifier_item_hd_tome_of_living_memories2:IsHidden() return true end
function modifier_item_hd_tome_of_living_memories2:IsPurgable() return false end
function modifier_item_hd_tome_of_living_memories2:IsPurgeException() return false end
function modifier_item_hd_tome_of_living_memories2:RemoveOnDeath() return false end


function modifier_item_hd_tome_of_living_memories2:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()

	self.bonus_health =ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor =ability:GetSpecialValueFor("bonus_armor")

	self.bonus_summon_intensity = ability:GetSpecialValueFor("summon_intensity")
	self.bonus_summon_time = ability:GetSpecialValueFor("summon_time_intensity")
	

    if IsServer() then

		self.damage_record = 0
		self:StartIntervalThink(15)
	end
end




function modifier_item_hd_tome_of_living_memories2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end


function modifier_item_hd_tome_of_living_memories2:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_tome_of_living_memories2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_tome_of_living_memories2_active", {})

	end
end

function modifier_item_hd_tome_of_living_memories2:GetModifierPhysical_ConstantBlock(keys)
	self.damage_record = self.damage_record + keys.damage
	return 0
end


function modifier_item_hd_tome_of_living_memories2:OnIntervalThink()
	if self.damage_record>0 then
		local parent = self:GetParent()
		parent:AddNewModifier(parent, self:GetParent(), "modifier_item_hd_tome_of_living_memories2_active_shell", {duration = 10,stack = self.damage_record*0.15})
		self.damage_record = 0
	end
end





-- advanced_modifier
function modifier_item_hd_tome_of_living_memories2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
		advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_tome_of_living_memories2:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity
end



function modifier_item_hd_tome_of_living_memories2:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.bonus_summon_time
end
function modifier_item_hd_tome_of_living_memories2:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end




modifier_item_hd_tome_of_living_memories2_active = advanced_modifier({})

function modifier_item_hd_tome_of_living_memories2_active:IsDebuff() return false end
function modifier_item_hd_tome_of_living_memories2_active:IsHidden() return true end
function modifier_item_hd_tome_of_living_memories2_active:IsPurgable() return false end
function modifier_item_hd_tome_of_living_memories2_active:RemoveOnDeath() return false end
function modifier_item_hd_tome_of_living_memories2_active:GetTexture() return "item_tome_of_living_memories1" end
function modifier_item_hd_tome_of_living_memories2_active:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL= {nil, self:GetParent()},
	}
end
function modifier_item_hd_tome_of_living_memories2_active:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return 0
	end
	if 15>=RandomInt(1, 100) then

		local health = keys.target:GetHealth()
		keys.target:Heal(keys.damage*1.2,self:GetAbility())
		local value = keys.target:GetHealth()-health
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.target, value, nil)
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_geomagentic_grip_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target )
		ParticleManager:SetParticleControl(nFXIndex, 10, keys.target:GetOrigin())
		DestroyParticleByDelay(nFXIndex,0.5)

		return keys.damage
	end
	return 0

end













modifier_item_hd_tome_of_living_memories2_active_shell = advanced_modifier({})

function modifier_item_hd_tome_of_living_memories2_active_shell:IsDebuff() return false end
function modifier_item_hd_tome_of_living_memories2_active_shell:IsHidden() return false end
function modifier_item_hd_tome_of_living_memories2_active_shell:IsPurgable() return false end
function modifier_item_hd_tome_of_living_memories2_active_shell:GetTexture() return "item_tome_of_living_memories2" end

function modifier_item_hd_tome_of_living_memories2_active_shell:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(math.min(keys.stack,self:GetParent():GetMaxHealth()*5))
	end

end


function modifier_item_hd_tome_of_living_memories2_active_shell:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(math.min(keys.stack+self:GetStackCount(),self:GetParent():GetMaxHealth()*5))
	end
end


function modifier_item_hd_tome_of_living_memories2_active_shell:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL = {nil, self:GetParent()},
	}
end


function modifier_item_hd_tome_of_living_memories2_active_shell:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return self:GetStackCount()
	end
	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	return stack
end