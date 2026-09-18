
LinkLuaModifier("modifier_item_hd_revenants_brooch_player", "items/item_hd_revenants_brooch_player", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_revenants_brooch_player_passive", "items/item_hd_revenants_brooch_player", LUA_MODIFIER_MOTION_NONE)


item_hd_revenants_brooch_player = item_hd_revenants_brooch_player or class({})
function item_hd_revenants_brooch_player:Precache( context )
	PrecacheResource( "particle", "particles/items5_fx/revenant_brooch.vpcf", context )
	
end
function item_hd_revenants_brooch_player:GetIntrinsicModifierName()
	return "modifier_item_hd_revenants_brooch_player_passive"
end


function item_hd_revenants_brooch_player:OnToggle()
	if not IsServer() then return end
    local caster = self:GetCaster()
	
	if self:GetToggleState() then
		caster:AddNewModifier(caster, self, "modifier_item_hd_revenants_brooch_player", {})
	else
		caster:RemoveModifierByNameAndCaster("modifier_item_hd_revenants_brooch_player", caster)
	end
	
end
-------------------------------------------------------------------------------------------------------------

modifier_item_hd_revenants_brooch_player = advanced_modifier({})

function modifier_item_hd_revenants_brooch_player:IsDebuff() return false end
function modifier_item_hd_revenants_brooch_player:IsHidden() return false end
function modifier_item_hd_revenants_brooch_player:IsPurgable() return false end
function modifier_item_hd_revenants_brooch_player:GetTexture() return "item_revenants_brooch" end
function modifier_item_hd_revenants_brooch_player:GetEffectName() return "particles/items5_fx/revenant_brooch.vpcf" end
function modifier_item_hd_revenants_brooch_player:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_revenants_brooch_player:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_revenants_brooch_player:OnIntervalThink(keys)
	if IsServer() then
		if self:GetParent():GetMana() < self:GetAbility():GetSpecialValueFor("mana_cost") then
			self:SetStackCount(0)
		else
			self:SetStackCount(1)
		end

		if not self:GetParent():IsHero() then
			self:SetStackCount(1)
		end
	end
end
function modifier_item_hd_revenants_brooch_player:DeclareFunctions(keys)
	local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL, --允许攻击虚无
    MODIFIER_EVENT_ON_ATTACK
    }
	return funcs
end
function modifier_item_hd_revenants_brooch_player:OnAttack(keys)
    if keys.attacker ~= self:GetParent() then
        return
    end
    if self:GetStackCount() == 0 then
        return
    end

	if self:GetParent():IsHero() then
    	keys.attacker:Script_ReduceMana(self:GetAbility():GetSpecialValueFor("mana_cost"),self:GetAbility())
	end
end

function modifier_item_hd_revenants_brooch_player:GetOverrideAttackMagical( keys )
	return self:GetStackCount()
end

function modifier_item_hd_revenants_brooch_player:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
	return funcs
end

function modifier_item_hd_revenants_brooch_player:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_medusa_4") then return end
	if keys.inflictor then return 0 end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
	--if keys.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end
    if self:GetParent():HasModifier("modifier_Advanced_pierce_the_veil_buff") or self:GetParent():HasModifier("modifier_Middle_pierce_the_veil_buff") or self:GetParent():HasModifier("modifier_Primary_pierce_the_veil_buff")then
        return 0 
    end
    if self:GetStackCount() == 0 then
        return 0
    end
	if not keys.target:IsMagicImmune() then
		local damageTable = {
			victim = keys.target,
			attacker = self:GetParent(),
			damage = keys.original_damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
		ApplyDamage( damageTable )
	else
        local damageTable = {
			victim = keys.target,
			attacker = self:GetParent(),
			damage = keys.original_damage*0.5,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
		ApplyDamage( damageTable )
	end

	return -999
end


--------------------


modifier_item_hd_revenants_brooch_player_passive = advanced_modifier({})

function modifier_item_hd_revenants_brooch_player_passive:IsDebuff() return false end
function modifier_item_hd_revenants_brooch_player_passive:IsHidden() return true end
function modifier_item_hd_revenants_brooch_player_passive:IsPurgable() return false end

function modifier_item_hd_revenants_brooch_player_passive:OnCreated(keys)
	self.bonus_projectile_speed = self:GetAbility():GetSpecialValueFor("bonus_projectile_speed")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_hd_revenants_brooch_player_passive:DeclareFunctions(keys)
	return{
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    }

end

function modifier_item_hd_revenants_brooch_player_passive:GetModifierProjectileSpeedBonus()
	return self.bonus_projectile_speed
end

function modifier_item_hd_revenants_brooch_player_passive:Advanced_GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end



function modifier_item_hd_revenants_brooch_player_passive:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

	return funcs

end

function modifier_item_hd_revenants_brooch_player_passive:OnDestroy()
	if IsServer() then
		local modifier = self:GetParent():FindAllModifiersByName("modifier_item_hd_revenants_brooch_player")
		if #modifier>0 then
			modifier[1]:SafeDestroy()
			return
		end
	end
end