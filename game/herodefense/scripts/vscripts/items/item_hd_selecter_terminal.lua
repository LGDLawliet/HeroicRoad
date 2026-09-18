item_hd_selecter_terminal = class({})

LinkLuaModifier("modifier_item_hd_selecter_terminal", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_selecter_terminal_active", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hd_selecter_terminal_str", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_selecter_terminal_agi", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_selecter_terminal_int", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_item_hd_selecter_terminal_str_all", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_selecter_terminal_agi_all", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_selecter_terminal_int_all", "items/item_hd_selecter_terminal", LUA_MODIFIER_MOTION_NONE)


function item_hd_selecter_terminal:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", context )

end



function item_hd_selecter_terminal:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	if self.modifier and not self.modifier:IsNull() then
		return
	end
	
	target:EmitSound("DOTA_Item.HavocHammer.Cast")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_walruspunch_start.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	DestroyParticleByDelay(particle,4)
	self.modifier = target:AddNewModifier(caster, self, "modifier_item_hd_selecter_terminal_active", {})
	

end




modifier_item_hd_selecter_terminal_active = class({})

function modifier_item_hd_selecter_terminal_active:IsDebuff() return false end
function modifier_item_hd_selecter_terminal_active:IsHidden() return false end
function modifier_item_hd_selecter_terminal_active:IsPurgable() return false end
function modifier_item_hd_selecter_terminal_active:GetTexture()return "item_selecter_terminal" end
function modifier_item_hd_selecter_terminal_active:IsPurgeException() return false end
function modifier_item_hd_selecter_terminal_active:RemoveOnDeath() return false end
function modifier_item_hd_selecter_terminal_active:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_DEATH,                          --单位死亡

	}
end

function modifier_item_hd_selecter_terminal_active:OnDeath(keys)
	-- First check: Is the unit within capture range and an enemy and not reincarnating?
	if keys.attacker and  keys.attacker.GetPlayerOwnerID and keys.attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() then
		self:IncrementStackCount()
		if self:GetStackCount()>=100 then
			local parent = self:GetParent()
			if parent:GetPrimaryAttribute()==DOTA_ATTRIBUTE_STRENGTH  then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_selecter_terminal_str", {})
			elseif parent:GetPrimaryAttribute()==DOTA_ATTRIBUTE_AGILITY  then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_selecter_terminal_agi", {})
			elseif  parent:GetPrimaryAttribute()==DOTA_ATTRIBUTE_INTELLECT then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_selecter_terminal_int", {})
			elseif parent:GetPrimaryAttribute()== DOTA_ATTRIBUTE_ALL then

				parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_selecter_terminal_str_all", {})
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_selecter_terminal_agi_all", {})
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_selecter_terminal_int_all", {})
			end
			self:SafeDestroy()
		end
	end
end




modifier_item_hd_selecter_terminal_str = class({})

function modifier_item_hd_selecter_terminal_str:IsDebuff() return false end
function modifier_item_hd_selecter_terminal_str:IsHidden() return false end
function modifier_item_hd_selecter_terminal_str:IsPurgable() return false end
function modifier_item_hd_selecter_terminal_str:IsPurgeException() return false end
function modifier_item_hd_selecter_terminal_str:GetTexture()return "item_selecter_terminal" end
function modifier_item_hd_selecter_terminal_str:RemoveOnDeath() return false end
function modifier_item_hd_selecter_terminal_str:OnCreated(table)
	if IsServer() then
		self:SetStackCount(1)
		
	end
	self.index = math.min(self:GetStackCount()*3,10)
end
function modifier_item_hd_selecter_terminal_str:OnRefresh(table)
	if IsServer() then
		self:IncrementStackCount()

	end
	self.index = math.min(self:GetStackCount()*3,10)
end

function modifier_item_hd_selecter_terminal_str:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_item_hd_selecter_terminal_str:GetModifierHealthBonus()
	return math.min(self:GetParent():GetStrength()*self.index,20000)
end


modifier_item_hd_selecter_terminal_str_all = class({})

function modifier_item_hd_selecter_terminal_str_all:IsDebuff() return false end
function modifier_item_hd_selecter_terminal_str_all:IsHidden() return false end
function modifier_item_hd_selecter_terminal_str_all:IsPurgable() return false end
function modifier_item_hd_selecter_terminal_str_all:IsPurgeException() return false end
function modifier_item_hd_selecter_terminal_str_all:GetTexture()return "item_selecter_terminal" end
function modifier_item_hd_selecter_terminal_str_all:RemoveOnDeath() return false end
function modifier_item_hd_selecter_terminal_str_all:OnCreated(table)
	if IsServer() then
		self:SetStackCount(1)
		
	end
	self.index = math.min(self:GetStackCount()*1.5,10)
end
function modifier_item_hd_selecter_terminal_str_all:OnRefresh(table)
	if IsServer() then
		self:IncrementStackCount()

	end
	self.index = math.min(self:GetStackCount()*1.5,10)
end

function modifier_item_hd_selecter_terminal_str_all:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_item_hd_selecter_terminal_str_all:GetModifierHealthBonus()
	return math.min(self:GetParent():GetStrength()*self.index,20000)
end


modifier_item_hd_selecter_terminal_agi = class({})

function modifier_item_hd_selecter_terminal_agi:IsDebuff() return false end
function modifier_item_hd_selecter_terminal_agi:IsHidden() return false end
function modifier_item_hd_selecter_terminal_agi:IsPurgable() return false end
function modifier_item_hd_selecter_terminal_agi:IsPurgeException() return false end
function modifier_item_hd_selecter_terminal_agi:GetTexture()return "item_selecter_terminal" end
function modifier_item_hd_selecter_terminal_agi:RemoveOnDeath() return false end
function modifier_item_hd_selecter_terminal_agi:OnCreated(table)
	if IsServer() then
		self:SetStackCount(1)
		
	end
	self.index = math.min(self:GetStackCount()*0.12,0.4)
end
function modifier_item_hd_selecter_terminal_agi:OnRefresh(table)
	if IsServer() then
		self:IncrementStackCount()
		
	end
	self.index = math.min(self:GetStackCount()*0.12,0.4)
end

function modifier_item_hd_selecter_terminal_agi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_item_hd_selecter_terminal_agi:GetModifierBaseAttack_BonusDamage()
	return math.min(self:GetParent():GetAgility()*self.index,600)
end
modifier_item_hd_selecter_terminal_agi_all = class({})

function modifier_item_hd_selecter_terminal_agi_all:IsDebuff() return false end
function modifier_item_hd_selecter_terminal_agi_all:IsHidden() return false end
function modifier_item_hd_selecter_terminal_agi_all:IsPurgable() return false end
function modifier_item_hd_selecter_terminal_agi_all:IsPurgeException() return false end
function modifier_item_hd_selecter_terminal_agi_all:GetTexture()return "item_selecter_terminal" end
function modifier_item_hd_selecter_terminal_agi_all:RemoveOnDeath() return false end
function modifier_item_hd_selecter_terminal_agi_all:OnCreated(table)
	if IsServer() then
		self:SetStackCount(1)
		
	end
	self.index = math.min(self:GetStackCount()*0.06,0.4)
end
function modifier_item_hd_selecter_terminal_agi_all:OnRefresh(table)
	if IsServer() then
		self:IncrementStackCount()
		
	end
	self.index = math.min(self:GetStackCount()*0.06,0.4)
end

function modifier_item_hd_selecter_terminal_agi_all:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_item_hd_selecter_terminal_agi_all:GetModifierBaseAttack_BonusDamage()
	return math.min(self:GetParent():GetAgility()*self.index,600)
end



modifier_item_hd_selecter_terminal_int = advanced_modifier({})

function modifier_item_hd_selecter_terminal_int:IsDebuff() return false end
function modifier_item_hd_selecter_terminal_int:IsHidden() return false end
function modifier_item_hd_selecter_terminal_int:IsPurgable() return false end
function modifier_item_hd_selecter_terminal_int:IsPurgeException() return false end
function modifier_item_hd_selecter_terminal_int:GetTexture()return "item_selecter_terminal" end
function modifier_item_hd_selecter_terminal_int:RemoveOnDeath() return false end
function modifier_item_hd_selecter_terminal_int:OnCreated(table)
	if IsServer() then
		self:SetStackCount(1)
		
	end
	self.index = math.min(self:GetStackCount()*0.04,0.13)
end
function modifier_item_hd_selecter_terminal_int:OnRefresh(table)
	if IsServer() then
		self:IncrementStackCount()

	end
	self.index = math.min(self:GetStackCount()*0.04,0.13)
end


function modifier_item_hd_selecter_terminal_int:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_selecter_terminal_int:Advanced_GetModifierSpellAmplifyBonus()
	return math.min(self:GetParent():GetIntellect(false)*self.index,200)
end


modifier_item_hd_selecter_terminal_int_all = advanced_modifier({})

function modifier_item_hd_selecter_terminal_int_all:IsDebuff() return false end
function modifier_item_hd_selecter_terminal_int_all:IsHidden() return false end
function modifier_item_hd_selecter_terminal_int_all:IsPurgable() return false end
function modifier_item_hd_selecter_terminal_int_all:IsPurgeException() return false end
function modifier_item_hd_selecter_terminal_int_all:GetTexture()return "item_selecter_terminal" end
function modifier_item_hd_selecter_terminal_int_all:RemoveOnDeath() return false end
function modifier_item_hd_selecter_terminal_int_all:OnCreated(table)
	if IsServer() then
		self:SetStackCount(1)
		
	end
	self.index = math.min(self:GetStackCount()*0.02,0.13)
end
function modifier_item_hd_selecter_terminal_int_all:OnRefresh(table)
	if IsServer() then
		self:IncrementStackCount()

	end
	self.index = math.min(self:GetStackCount()*0.02,0.13)
end

function modifier_item_hd_selecter_terminal_int_all:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_selecter_terminal_int_all:Advanced_GetModifierSpellAmplifyBonus()
	return math.min(self:GetParent():GetIntellect(false)*self.index,200)
end