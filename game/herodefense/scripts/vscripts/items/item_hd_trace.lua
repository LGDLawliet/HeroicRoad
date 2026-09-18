LinkLuaModifier("modifier_item_hd_trace_speed1", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_speed2", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_speed3", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_power1", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_power2", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_power3", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_spell1", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_spell2", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_spell3", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_defense1", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_defense2", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_defense3", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_sword", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_stone", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trace_crown", "items/item_hd_trace", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
item_hd_trace_speed1 = advanced_modifier({})
function item_hd_trace_speed1:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_speed1", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_speed2 = advanced_modifier({})
function item_hd_trace_speed2:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_speed2", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_speed3 = advanced_modifier({})
function item_hd_trace_speed3:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_speed3", {duration = 30})
		self:SpendCharge(0)
	end
end
--------------------------------------------------------------------------------
item_hd_trace_power1 = advanced_modifier({})
function item_hd_trace_power1:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_power1", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_power2 = advanced_modifier({})
function item_hd_trace_power2:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_power2", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_power3 = advanced_modifier({})
function item_hd_trace_power3:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_power3", {duration = 30})
		self:SpendCharge(0)
	end
end
--------------------------------------------------------------------------------
item_hd_trace_defense1 = advanced_modifier({})
function item_hd_trace_defense1:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_defense1", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_defense2 = advanced_modifier({})
function item_hd_trace_defense2:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_defense2", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_defense3 = advanced_modifier({})
function item_hd_trace_defense3:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_defense3", {duration = 30})
		self:SpendCharge(0)
	end
end
--------------------------------------------------------------------------------
item_hd_trace_spell1 = advanced_modifier({})
function item_hd_trace_spell1:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_spell1", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_spell2 = advanced_modifier({})
function item_hd_trace_spell2:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_spell2", {duration = 30})
		self:SpendCharge(0)
	end
end
item_hd_trace_spell3 = advanced_modifier({})
function item_hd_trace_spell3:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_spell3", {duration = 30})
		self:SpendCharge(0)
	end
end
--------------------------------------------------------------------------------
item_hd_trace_sword = advanced_modifier({})
function item_hd_trace_sword:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_sword", {duration = 30})
		self:SpendCharge(0)
        
	end
end
item_hd_trace_stone = advanced_modifier({})
function item_hd_trace_stone:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_stone", {duration = 30})
		self:SpendCharge(0)
        for i=0, caster:GetAbilityCount() - 1 do
            local Ability = caster:GetAbilityByIndex(i)
            if Ability ~= nil and Ability ~= self  and  Ability:IsRefreshable() and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
                Ability:EndCooldown()
            end
        end
	end
end
item_hd_trace_crown = advanced_modifier({})
function item_hd_trace_crown:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_item_hd_trace_crown", {duration = 20})
        caster:AddNewModifier(caster, self, "modifier_invulnerable", {duration = 5})
		self:SpendCharge(0)
        
	end
end
----//////////////////////////////////////////////////////////////////////------
modifier_item_hd_trace_speed1 = advanced_modifier({})
function modifier_item_hd_trace_speed1:IsPurgable()return false end
function modifier_item_hd_trace_speed1:IsDebuff()return false end
function modifier_item_hd_trace_speed1:IsHidden()return false end
function modifier_item_hd_trace_speed1:GetTexture()return "rune_haste" end
function modifier_item_hd_trace_speed1:OnCreated()
    self:SetStackCount(1)
end
function modifier_item_hd_trace_speed1:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end
function modifier_item_hd_trace_speed1:GetModifierAttackSpeedBonus_Constant()
    return 60
end
function modifier_item_hd_trace_speed1:GetModifierMoveSpeedBonus_Constant()
    return 60
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_speed2 = advanced_modifier({})
function modifier_item_hd_trace_speed2:IsPurgable()return false end
function modifier_item_hd_trace_speed2:IsDebuff()return false end
function modifier_item_hd_trace_speed2:IsHidden()return false end
function modifier_item_hd_trace_speed2:GetTexture()return "rune_haste" end
function modifier_item_hd_trace_speed2:OnCreated()
    self:SetStackCount(2)
end
function modifier_item_hd_trace_speed2:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end
function modifier_item_hd_trace_speed2:GetModifierAttackSpeedBonus_Constant()
    return 130
end
function modifier_item_hd_trace_speed2:GetModifierMoveSpeedBonus_Constant()
    return 130
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_speed3 = advanced_modifier({})
function modifier_item_hd_trace_speed3:IsPurgable()return false end
function modifier_item_hd_trace_speed3:IsDebuff()return false end
function modifier_item_hd_trace_speed3:IsHidden()return false end
function modifier_item_hd_trace_speed3:GetTexture()return "rune_haste" end
function modifier_item_hd_trace_speed3:OnCreated()
    self:SetStackCount(3)
end
function modifier_item_hd_trace_speed3:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }
end
function modifier_item_hd_trace_speed3:GetModifierAttackSpeedBonus_Constant()
    return 200
end
function modifier_item_hd_trace_speed3:GetModifierMoveSpeedBonus_Constant()
    return 200
end
function modifier_item_hd_trace_speed3:GetModifierIgnoreMovespeedLimit()
    return 1
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
modifier_item_hd_trace_power1 = advanced_modifier({})
function modifier_item_hd_trace_power1:IsPurgable()return false end
function modifier_item_hd_trace_power1:IsDebuff()return false end
function modifier_item_hd_trace_power1:IsHidden()return false end
function modifier_item_hd_trace_power1:GetTexture()return "rune_doubledamage" end
function modifier_item_hd_trace_power1:OnCreated()
    self:SetStackCount(1)
end
function modifier_item_hd_trace_power1:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_trace_power1:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return 20
end
function modifier_item_hd_trace_power1:Advanced_GetModifierSpellAmplifyBonus()
    return 10
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_power2 = advanced_modifier({})
function modifier_item_hd_trace_power2:IsPurgable()return false end
function modifier_item_hd_trace_power2:IsDebuff()return false end
function modifier_item_hd_trace_power2:IsHidden()return false end
function modifier_item_hd_trace_power2:GetTexture()return "rune_doubledamage" end
function modifier_item_hd_trace_power2:OnCreated()
    self:SetStackCount(2)
end
function modifier_item_hd_trace_power2:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_trace_power2:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return 40
end
function modifier_item_hd_trace_power2:Advanced_GetModifierSpellAmplifyBonus()
    return 30
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_power3 = advanced_modifier({})
function modifier_item_hd_trace_power3:IsPurgable()return false end
function modifier_item_hd_trace_power3:IsDebuff()return false end
function modifier_item_hd_trace_power3:IsHidden()return false end
function modifier_item_hd_trace_power3:GetTexture()return "rune_doubledamage" end
function modifier_item_hd_trace_power3:OnCreated()
    self:SetStackCount(3)
end
function modifier_item_hd_trace_power3:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,

    }
end
function modifier_item_hd_trace_power3:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return 60
end
function modifier_item_hd_trace_power3:Advanced_GetModifierSpellAmplifyBonus()
    return 50
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
modifier_item_hd_trace_defense1 = advanced_modifier({})
function modifier_item_hd_trace_defense1:IsPurgable()return false end
function modifier_item_hd_trace_defense1:IsDebuff()return false end
function modifier_item_hd_trace_defense1:IsHidden()return false end
function modifier_item_hd_trace_defense1:GetTexture()return "rune_regen" end
function modifier_item_hd_trace_defense1:OnCreated()
    self:SetStackCount(1)
end
function modifier_item_hd_trace_defense1:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_trace_defense1:AdvancedGetModifierConstantHealthRegenPercentage()
    return 1.5
end
function modifier_item_hd_trace_defense1:Advanced_GetModifierIncomingDamage_Percentage()
    return -10
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_defense2 = advanced_modifier({})
function modifier_item_hd_trace_defense2:IsPurgable()return false end
function modifier_item_hd_trace_defense2:IsDebuff()return false end
function modifier_item_hd_trace_defense2:IsHidden()return false end
function modifier_item_hd_trace_defense2:GetTexture()return "rune_regen" end
function modifier_item_hd_trace_defense2:OnCreated()
    self:SetStackCount(2)
end
function modifier_item_hd_trace_defense2:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_trace_defense2:AdvancedGetModifierConstantHealthRegenPercentage()
    return 3
end
function modifier_item_hd_trace_defense2:Advanced_GetModifierIncomingDamage_Percentage()
    return -20
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_defense3 = advanced_modifier({})
function modifier_item_hd_trace_defense3:IsPurgable()return false end
function modifier_item_hd_trace_defense3:IsDebuff()return false end
function modifier_item_hd_trace_defense3:IsHidden()return false end
function modifier_item_hd_trace_defense3:GetTexture()return "rune_regen" end
function modifier_item_hd_trace_defense3:OnCreated()
    self:SetStackCount(3)
end
function modifier_item_hd_trace_defense3:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

    }
end
function modifier_item_hd_trace_defense3:AdvancedGetModifierConstantHealthRegenPercentage()
    return 5
end
function modifier_item_hd_trace_defense3:Advanced_GetModifierIncomingDamage_Percentage()
    return -40
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
modifier_item_hd_trace_spell1 = advanced_modifier({})
function modifier_item_hd_trace_spell1:IsPurgable()return false end
function modifier_item_hd_trace_spell1:IsDebuff()return false end
function modifier_item_hd_trace_spell1:IsHidden()return false end
function modifier_item_hd_trace_spell1:GetTexture()return "rune_arcane" end
function modifier_item_hd_trace_spell1:OnCreated()
    self:SetStackCount(1)
end
function modifier_item_hd_trace_spell1:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_item_hd_trace_spell1:AdvancedGetModifierConstantManaRegen()
    return 20
end
function modifier_item_hd_trace_spell1:Advanced_GetModifierCooldownReduction()
    return 8
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_spell2 = advanced_modifier({})
function modifier_item_hd_trace_spell2:IsPurgable()return false end
function modifier_item_hd_trace_spell2:IsDebuff()return false end
function modifier_item_hd_trace_spell2:IsHidden()return false end
function modifier_item_hd_trace_spell2:GetTexture()return "rune_arcane" end
function modifier_item_hd_trace_spell2:OnCreated()
    self:SetStackCount(2)
end
function modifier_item_hd_trace_spell2:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_item_hd_trace_spell2:AdvancedGetModifierConstantManaRegen()
    return 40
end
function modifier_item_hd_trace_spell2:Advanced_GetModifierCooldownReduction()
    return 15
end
--------------------------------------------------------------------------------
modifier_item_hd_trace_spell3 = advanced_modifier({})
function modifier_item_hd_trace_spell3:IsPurgable()return false end
function modifier_item_hd_trace_spell3:IsDebuff()return false end
function modifier_item_hd_trace_spell3:IsHidden()return false end
function modifier_item_hd_trace_spell3:GetTexture()return "rune_arcane" end
function modifier_item_hd_trace_spell3:OnCreated()
    self:SetStackCount(3)
end
function modifier_item_hd_trace_spell3:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,

    }
end
function modifier_item_hd_trace_spell3:AdvancedGetModifierConstantManaRegen()
    return 80
end
function modifier_item_hd_trace_spell3:Advanced_GetModifierCooldownReduction()
    return 25
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
modifier_item_hd_trace_sword = advanced_modifier({})
function modifier_item_hd_trace_sword:IsPurgable()return false end
function modifier_item_hd_trace_sword:IsDebuff()return false end
function modifier_item_hd_trace_sword:IsHidden()return false end
function modifier_item_hd_trace_sword:GetTexture()return "item_rapier" end
function modifier_item_hd_trace_sword:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
    }
end
function modifier_item_hd_trace_sword:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return 50
end
function modifier_item_hd_trace_sword:AdvancedGetModifierExtraHealthPercentage()
    return 25
end
function modifier_item_hd_trace_sword:OnTakeDamage(keys)
    if IsServer() then
        if self:GetParent():GetHealth() <= 0 then
            self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
            self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_invulnerable",{duration = 5})
            self:GetParent():RemoveModifierByName("modifier_item_hd_trace_sword")
        end
    end
end
    
modifier_item_hd_trace_stone = advanced_modifier({})
function modifier_item_hd_trace_stone:IsPurgable()return false end
function modifier_item_hd_trace_stone:IsDebuff()return false end
function modifier_item_hd_trace_stone:IsHidden()return false end
function modifier_item_hd_trace_stone:GetTexture()return "item_fusion_rune" end
function modifier_item_hd_trace_stone:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        
    }
end

function modifier_item_hd_trace_stone:Advanced_GetModifierCooldownReduction()
    return 35
end
function modifier_item_hd_trace_stone:Advanced_GetModifierBonusStats_Strength()
    return 150
end
function modifier_item_hd_trace_stone:Advanced_GetModifierBonusStats_Agility()
    return 150
end
function modifier_item_hd_trace_stone:Advanced_GetModifierBonusStats_Intellect()
    return 150
end
-------------------------------------------------------
modifier_item_hd_trace_crown = advanced_modifier({})
function modifier_item_hd_trace_crown:IsPurgable()return false end
function modifier_item_hd_trace_crown:IsDebuff()return false end
function modifier_item_hd_trace_crown:IsHidden()return false end
function modifier_item_hd_trace_crown:GetTexture()return "item_aegis_heart" end
function modifier_item_hd_trace_crown:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        
    }
end
function modifier_item_hd_trace_crown:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return 40
end
function modifier_item_hd_trace_crown:AdvancedGetModifierExtraHealthPercentage()
    return 20
end
function modifier_item_hd_trace_crown:Advanced_GetModifierCooldownReduction()
    return 28
end
function modifier_item_hd_trace_crown:Advanced_GetModifierBonusStats_Strength()
    return 120
end
function modifier_item_hd_trace_crown:Advanced_GetModifierBonusStats_Agility()
    return 120
end
function modifier_item_hd_trace_crown:Advanced_GetModifierBonusStats_Intellect()
    return 120
end