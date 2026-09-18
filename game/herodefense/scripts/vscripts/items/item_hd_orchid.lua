item_hd_orchid = class({})


LinkLuaModifier("modifier_item_hd_orchid_self", "items/item_hd_orchid", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_orchid_already", "items/item_hd_orchid", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_orchid", "items/item_hd_orchid", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_orchid_active", "items/item_hd_orchid", LUA_MODIFIER_MOTION_NONE)

function item_hd_orchid:GetIntrinsicModifierName()
	return "modifier_item_hd_orchid"
end



modifier_item_hd_orchid = advanced_modifier({})

function modifier_item_hd_orchid:IsDebuff() return false end
function modifier_item_hd_orchid:IsHidden() return true end
function modifier_item_hd_orchid:IsPurgable() return false end


function modifier_item_hd_orchid:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
end



function modifier_item_hd_orchid:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,     --攻击速度
	}
end
function modifier_item_hd_orchid:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,          --智力
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,            --魔法基础恢复
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
	}
end

function modifier_item_hd_orchid:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_orchid:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
function modifier_item_hd_orchid:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end

function modifier_item_hd_orchid:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit:GetTeamNumber() == keys.attacker:GetTeamNumber() then
		return
	end
	local modifier = keys.unit:FindModifierByNameAndCaster("modifier_item_hd_orchid_already", keys.attacker)
	if modifier then
		return
	end
	if keys.damage <= 0 then
		return
	end
	if not keys.unit:IsAlive() then--首次击杀保底
		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_hd_orchid_self",{})
	end

	keys.unit:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_orchid_already", {})
	keys.unit:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_orchid_active", {duration = self:GetAbility():GetSpecialValueFor("duration")})
end
------------------------------

modifier_item_hd_orchid_active = advanced_modifier({})

function modifier_item_hd_orchid_active:IsDebuff() return true end
function modifier_item_hd_orchid_active:IsHidden() return false end
function modifier_item_hd_orchid_active:IsPurgable() return false end
function modifier_item_hd_orchid_active:IsPurgeException() return false end
function modifier_item_hd_orchid_active:GetTexture()return "item_orchid" end
function modifier_item_hd_orchid_active:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_item_hd_orchid_active:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end


function modifier_item_hd_orchid_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("incoming_up")
	end
end


function modifier_item_hd_orchid_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
	return funcs
end

function modifier_item_hd_orchid_active:OnDeath(keys)
	if not IsServer() then
		return
	end
	local modifier_ori = self:GetCaster():FindModifierByName("modifier_item_hd_orchid")
	if not modifier_ori then
		return
	end
	self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_item_hd_orchid_self",{})
end
--------------------------------
modifier_item_hd_orchid_already = advanced_modifier({})

function modifier_item_hd_orchid_already:IsDebuff() return true end
function modifier_item_hd_orchid_already:IsHidden() return true end
function modifier_item_hd_orchid_already:IsPurgable() return false end
function modifier_item_hd_orchid_already:IsPurgeException() return false end
function modifier_item_hd_orchid_already:RemoveOnDeath() return false end
--------------------------------
modifier_item_hd_orchid_self = advanced_modifier({})

function modifier_item_hd_orchid_self:IsDebuff() return false end
function modifier_item_hd_orchid_self:IsHidden() return false end
function modifier_item_hd_orchid_self:IsPurgable() return false end
function modifier_item_hd_orchid_self:IsPurgeException() return false end
function modifier_item_hd_orchid_self:RemoveOnDeath() return false end
function modifier_item_hd_orchid_self:GetTexture()return "item_orchid" end

function modifier_item_hd_orchid_self:OnCreated()
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
end
function modifier_item_hd_orchid_self:OnRefresh()
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
	self:SetStackCount(math.min((self:GetStackCount() + 1),self.max_stack))
end
function modifier_item_hd_orchid_self:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
end
function modifier_item_hd_orchid_self:Advanced_GetModifierSpellAmplifyBonus()
	return	self.spell_amp*(self:GetStackCount()-1)+self.spell_amp
end