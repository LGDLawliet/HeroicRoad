LinkLuaModifier( "modifier_item_chaotic_class_spell", "items/item_chaotic_class_spell.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_chaotic_class_spell_active", "items/item_chaotic_class_spell.lua", LUA_MODIFIER_MOTION_NONE )

item_chaotic_class_spell = class({})

function item_chaotic_class_spell:OnSpellStart()
	if not IsServer() then
        return
    end
	local caster = self:GetCaster()
    local item = caster:FindItemInInventory("item_chaotic_class_spell")
    if item ~=nil then
        caster:AddNewModifier(caster, self, "modifier_item_chaotic_class_spell", {})
        UTIL_RemoveImmediate(item) --removeitem的暂时替代
    end
end

modifier_item_chaotic_class_spell = advanced_modifier({})

function modifier_item_chaotic_class_spell:IsDebuff()return false end
function modifier_item_chaotic_class_spell:IsHidden()return false end
function modifier_item_chaotic_class_spell:IsPurgable()return false end
function modifier_item_chaotic_class_spell:RemoveOnDeath()return false end
function modifier_item_chaotic_class_spell:DestroyOnExpire()	return false end
function modifier_item_chaotic_class_spell:GetTexture()	return "item_null_talisman" end

function modifier_item_chaotic_class_spell:OnCreated(params)
	self.duration = 3
	self.spell = 12
	self.bonus_spell = 0.9
	self.bonus_spell_amp = 0.5
end

function modifier_item_chaotic_class_spell:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
	}
end


function modifier_item_chaotic_class_spell:Advanced_GetModifierSpellAmplifyBonus()
	return self.bonus_spell_amp*self:GetParent():GetLevel()
end

function modifier_item_chaotic_class_spell:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.damage_category~= DOTA_DAMAGE_CATEGORY_SPELL then
		return
	end
	if keys.unit:GetTeamNumber() == keys.attacker:GetTeamNumber() then
		return
	end

	self.stack = self.spell+keys.attacker:GetLevel()*self.bonus_spell
	keys.unit:AddNewModifier(self:GetParent(),nil,"modifier_item_chaotic_class_spell_active",{duration = self.duration , stack = self.stack})
end

function modifier_item_chaotic_class_spell:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_chaotic_class_spell:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.bonus_spell_amp*self:GetParent():GetLevel()
	end
end
---------------------

modifier_item_chaotic_class_spell_active = advanced_modifier({})

function modifier_item_chaotic_class_spell_active:IsDebuff()return true end
function modifier_item_chaotic_class_spell_active:IsHidden()return false end
function modifier_item_chaotic_class_spell_active:IsPurgable()return false end
function modifier_item_chaotic_class_spell_active:RemoveOnDeath()return false end
function modifier_item_chaotic_class_spell_active:GetTexture()	return "item_null_talisman" end

function modifier_item_chaotic_class_spell_active:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_item_chaotic_class_spell_active:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end

function modifier_item_chaotic_class_spell_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_item_chaotic_class_spell_active:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker == self:GetCaster() then
		return self:GetStackCount()
	end
	return 0
end

