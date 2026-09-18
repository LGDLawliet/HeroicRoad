item_hd_cantern_of_servitude = class({})

LinkLuaModifier("modifier_item_hd_cantern_of_servitude", "items/item_hd_cantern_of_servitude", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_cantern_of_servitude_disarm", "items/item_hd_cantern_of_servitude", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_cantern_of_servitude_active_lifesteal", "items/item_hd_cantern_of_servitude", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_cantern_of_servitude:GetIntrinsicModifierName()
	return "modifier_item_hd_cantern_of_servitude"
end
function item_hd_cantern_of_servitude:Spawn()
	self.soul_count = 0
end
function item_hd_cantern_of_servitude:GetSoulCount()
	return self.soul_count
end

function item_hd_cantern_of_servitude:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	caster:Purge(false, true, false, false, false)
	caster:AddNewModifier(caster, self, "modifier_item_hd_cantern_of_servitude_active_lifesteal", {duration = duration*ModifierStatusGain})
end

modifier_item_hd_cantern_of_servitude = class({})

function modifier_item_hd_cantern_of_servitude:IsDebuff() return false end
function modifier_item_hd_cantern_of_servitude:IsHidden() return false end
function modifier_item_hd_cantern_of_servitude:IsPurgable() return false end
-- function modifier_item_hd_cantern_of_servitude:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_cantern_of_servitude:OnCreated(keys)
    -- self.ability = self:GetAbility()
	self.bonus_damage =self:GetAbility():GetSpecialValueFor("bonus_damage")

	if IsServer() then
		if self:GetCaster():FindAbilityByName("Advanced_necromastery") then
			return
		end
		local ability = self:GetAbility()
		self:SetStackCount(ability:GetSoulCount() or 0)
	end
end

function modifier_item_hd_cantern_of_servitude:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability then
			ability.soul_count = self:GetStackCount()
		end
		
	end
end


function modifier_item_hd_cantern_of_servitude:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,            --攻击力
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE

	}
end


function modifier_item_hd_cantern_of_servitude:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_cantern_of_servitude:GetModifierBaseAttack_BonusDamage() return self:GetStackCount()*2 end





function modifier_item_hd_cantern_of_servitude:OnDeath(keys)
	if IsServer() then
		if self:GetCaster():FindAbilityByName("Advanced_necromastery") then
			self:SetStackCount(0)
			return
		else
			if keys.attacker and  keys.attacker.GetPlayerOwnerID and keys.attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() then
				self:SetStackCount(math.min(self:GetStackCount()+1,150))
			end
		end
	end
	
end
