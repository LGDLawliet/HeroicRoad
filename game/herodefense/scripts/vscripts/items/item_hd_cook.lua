
LinkLuaModifier("modifier_cook_health", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_health_regen", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_mana_regen", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_mana", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_damage", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_magical_resistance", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_spell_damage", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_cast_speed", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_armor", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_ModifierStatusGain", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_int", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_str", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_agi", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_ModifierStatusResistance", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_IncomingDamageResist", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_damage_totalup", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_NagativeGain", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_cook_ModifierRandomEffectGain", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cook_allAttackDamage", "items/item_hd_cook", LUA_MODIFIER_MOTION_NONE)


--生命料理
item_hd_cook_tango_single = item_hd_cook_tango_single or class({})
function item_hd_cook_tango_single:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_health", {stack = 100})--80→100


		self:SpendCharge(0)
	end
end

item_hd_cook_tango =item_hd_cook_tango or class({})
function item_hd_cook_tango:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_health", {stack = 240})--200→240


		self:SpendCharge(0)
	end
end
item_hd_cook_cheese = item_hd_cook_cheese or class({})
function item_hd_cook_cheese:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_health", {stack = 480})--400→480


		self:SpendCharge(0)
	end
end

item_hd_cook_tango_clone = item_hd_cook_tango_clone or class({})
function item_hd_cook_tango_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_health", {stack = 480})--400→480


		self:SpendCharge(0)
	end
end

item_hd_cook_cheese_clone = item_hd_cook_cheese_clone or class({})
function item_hd_cook_cheese_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_health", {stack = 960})--800→960


		self:SpendCharge(0)
	end
end



modifier_cook_health = modifier_cook_health or class({})

function modifier_cook_health:IsDebuff() return false end
function modifier_cook_health:IsHidden() return true end
function modifier_cook_health:IsPurgable() return false end
function modifier_cook_health:IsPurgeException() return false end
function modifier_cook_health:GetTexture()return "item_tango_single" end
function modifier_cook_health:RemoveOnDeath() return false end
function modifier_cook_health:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_health:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_health:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值

	}
end

function modifier_cook_health:GetModifierHealthBonus()return self:GetStackCount() end







--魔法料理

item_hd_cook_Mango = item_hd_cook_Mango or class({})
function item_hd_cook_Mango:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_mana", {stack = 60})--50→60


		self:SpendCharge(0)
	end
end




item_hd_cook_greater_mango = item_hd_cook_greater_mango or class({})
function item_hd_cook_greater_mango:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_mana", {stack = 240})


		self:SpendCharge(0)
	end
end


item_hd_cook_greater_mango_clone = item_hd_cook_greater_mango_clone or class({})
function item_hd_cook_greater_mango_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_mana", {stack = 480})


		self:SpendCharge(0)
	end
end

modifier_cook_mana = modifier_cook_mana or class({})

function modifier_cook_mana:IsDebuff() return false end
function modifier_cook_mana:IsHidden() return true end
function modifier_cook_mana:IsPurgable() return false end
function modifier_cook_mana:IsPurgeException() return false end
function modifier_cook_mana:GetTexture()return "item_enchanted_mango" end
function modifier_cook_mana:RemoveOnDeath() return false end
function modifier_cook_mana:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_mana:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_mana:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,              

	}
end

function modifier_cook_mana:GetModifierManaBonus()return self:GetStackCount() end






--攻击力料理

item_hd_cook_faerie_fire = item_hd_cook_faerie_fire or class({})
function item_hd_cook_faerie_fire:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_damage", {stack = 10})--维持原数值

		self:SpendCharge(0)
	end
end





item_hd_cook_Roasted_tuna = item_hd_cook_Roasted_tuna or class({})
function item_hd_cook_Roasted_tuna:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_damage", {stack = 20})--18→20


		self:SpendCharge(0)
	end
end



item_hd_cook_greater_faerie_fire = item_hd_cook_greater_faerie_fire or class({})
function item_hd_cook_greater_faerie_fire:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_damage", {stack = 30})--26→30


		self:SpendCharge(0)
	end
end




item_hd_cook_Roasted_tuna_clone = item_hd_cook_Roasted_tuna_clone or class({})
function item_hd_cook_Roasted_tuna_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_damage", {stack = 40})--36→40


		self:SpendCharge(0)
	end
end



item_hd_cook_greater_faerie_fire_clone = item_hd_cook_greater_faerie_fire_clone or class({})
function item_hd_cook_greater_faerie_fire_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_damage", {stack = 60})--52→60


		self:SpendCharge(0)
	end
end

modifier_cook_damage = modifier_cook_damage or class({})

function modifier_cook_damage:IsDebuff() return false end
function modifier_cook_damage:IsHidden() return true end
function modifier_cook_damage:IsPurgable() return false end
function modifier_cook_damage:IsPurgeException() return false end
function modifier_cook_damage:GetTexture()return "item_faerie_fire" end
function modifier_cook_damage:RemoveOnDeath() return false end
function modifier_cook_damage:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_damage:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,                   

	}
end

function modifier_cook_damage:GetModifierPreAttack_BonusDamage()return self:GetStackCount() end






--技能增强料理

item_hd_cook_Chocolates = item_hd_cook_Chocolates or class({})
function item_hd_cook_Chocolates:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_spell_damage", {stack = 2})--维持原设
--

		self:SpendCharge(0)
	end
end


item_hd_cook_steak = item_hd_cook_steak or class({})
function item_hd_cook_steak:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_spell_damage", {stack = 3})


		self:SpendCharge(0)
	end
end

item_hd_cook_Meat_of_sea_dragon = item_hd_cook_Meat_of_sea_dragon or class({})
function item_hd_cook_Meat_of_sea_dragon:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_spell_damage", {stack = 4})


		self:SpendCharge(0)
	end
end



item_hd_cook_steak_clone = item_hd_cook_steak_clone or class({})
function item_hd_cook_steak_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_spell_damage", {stack = 6})


		self:SpendCharge(0)
	end
end

item_hd_cook_Meat_of_sea_dragon_clone = item_hd_cook_Meat_of_sea_dragon_clone or class({})
function item_hd_cook_Meat_of_sea_dragon_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_spell_damage", {stack = 8})


		self:SpendCharge(0)
	end
end

item_hd_cook_Mashed_Potato = item_hd_cook_Mashed_Potato or class({})
function item_hd_cook_Mashed_Potato:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_spell_damage", {stack = 1})
		caster:AddNewModifier(caster, self, "modifier_cook_magical_resistance", {stack = 1})--新增：1魔抗1技伤


		self:SpendCharge(0)
	end
end





modifier_cook_spell_damage = modifier_cook_spell_damage or advanced_modifier({})

function modifier_cook_spell_damage:IsDebuff() return false end
function modifier_cook_spell_damage:IsHidden() return true end
function modifier_cook_spell_damage:IsPurgable() return false end
function modifier_cook_spell_damage:IsPurgeException() return false end
function modifier_cook_spell_damage:GetTexture()return "item_cook_5" end
function modifier_cook_spell_damage:RemoveOnDeath() return false end
function modifier_cook_spell_damage:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_spell_damage:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_spell_damage:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_cook_spell_damage:Advanced_GetModifierSpellAmplifyBonus()return self:GetStackCount() end


----------------------------------------目前已无相关魔法抗性料理---------------------------------------------------------------------------------------------------
modifier_cook_magical_resistance = modifier_cook_magical_resistance or class({})

function modifier_cook_magical_resistance:IsDebuff() return false end
function modifier_cook_magical_resistance:IsHidden() return true end
function modifier_cook_magical_resistance:IsPurgable() return false end
function modifier_cook_magical_resistance:IsPurgeException() return false end
function modifier_cook_magical_resistance:GetTexture()return "item_cook_1" end
function modifier_cook_magical_resistance:RemoveOnDeath() return false end
function modifier_cook_magical_resistance:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_magical_resistance:OnRefresh(keys)
	if IsServer() then
		local max =60
		self:SetStackCount(math.min(self:GetStackCount()+ keys.stack,max))
	end
end

function modifier_cook_magical_resistance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性,                 

	}
end

function modifier_cook_magical_resistance:GetModifierMagicalResistanceBonus()return self:GetStackCount() end
----------------------------------------目前已无相关魔法抗性料理--------------------------------------------------------------------------------------------------


--复合料理：魔法恢复与施法速度提升料理
item_hd_cook_green = item_hd_cook_green or class({})
function item_hd_cook_green:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_mana_regen", {stack = 20})--1.5→2.0
		caster:AddNewModifier(caster, self, "modifier_cook_cast_speed", {stack = 2})--2%施法速度


		self:SpendCharge(0)
	end
end


item_hd_cook_green_2 = item_hd_cook_green_2 or class({})
function item_hd_cook_green_2:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_mana_regen", {stack = 40})--4.5→6.0
		caster:AddNewModifier(caster, self, "modifier_cook_cast_speed", {stack = 3})--3%施法速度

		self:SpendCharge(0)
	end
end





item_hd_cook_green_2_clone = item_hd_cook_green_2_clone or class({})
function item_hd_cook_green_2_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_mana_regen", {stack = 80})--9.0→12.0
		caster:AddNewModifier(caster, self, "modifier_cook_cast_speed", {stack = 6})--6%施法速度

		self:SpendCharge(0)
	end
end










modifier_cook_mana_regen = modifier_cook_mana_regen or class({})

function modifier_cook_mana_regen:IsDebuff() return false end
function modifier_cook_mana_regen:IsHidden() return true end
function modifier_cook_mana_regen:IsPurgable() return false end
function modifier_cook_mana_regen:IsPurgeException() return false end
function modifier_cook_mana_regen:GetTexture()return "item_cook_7" end
function modifier_cook_mana_regen:RemoveOnDeath() return false end
function modifier_cook_mana_regen:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_mana_regen:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_mana_regen:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,                   

	}
end

function modifier_cook_mana_regen:GetModifierConstantManaRegen()return self:GetStackCount()*0.1 end



--施法速度

modifier_cook_cast_speed = advanced_modifier({})

function modifier_cook_cast_speed:IsDebuff() return false end
function modifier_cook_cast_speed:IsHidden() return true end
function modifier_cook_cast_speed:IsPurgable() return false end
function modifier_cook_cast_speed:IsPurgeException() return false end
function modifier_cook_cast_speed:GetTexture()return "item_cook_7" end
function modifier_cook_cast_speed:RemoveOnDeath() return false end
function modifier_cook_cast_speed:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_cast_speed:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_cast_speed:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_CastPoint,                   

	}
end

function modifier_cook_cast_speed:Advanced_GetModifier_CastPoint()return self:GetStackCount()	end


--复合料理：护甲与生命恢复料理


item_hd_cook_Baked_sweet_potato = item_hd_cook_Baked_sweet_potato or class({})
function item_hd_cook_Baked_sweet_potato:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_armor", {stack =3})--2→3
		caster:AddNewModifier(caster, self, "modifier_cook_health_regen", {stack =2})--2点生命恢复


		self:SpendCharge(0)
	end
end


item_hd_cook_Baked_sweet_potato_clone = item_hd_cook_Baked_sweet_potato_clone or class({})
function item_hd_cook_Baked_sweet_potato_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_armor", {stack =6})
		caster:AddNewModifier(caster, self, "modifier_cook_health_regen", {stack =4})


		self:SpendCharge(0)
	end
end



modifier_cook_armor = modifier_cook_armor or advanced_modifier({})

function modifier_cook_armor:IsDebuff() return false end
function modifier_cook_armor:IsHidden() return true end
function modifier_cook_armor:IsPurgable() return false end
function modifier_cook_armor:IsPurgeException() return false end
function modifier_cook_armor:GetTexture()return "item_cook_12" end
function modifier_cook_armor:RemoveOnDeath() return false end
function modifier_cook_armor:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_armor:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_cook_armor:Advanced_GetModifierPhysicalArmorBonus()
    return self:GetStackCount()
end


--正面状态增强料理
item_hd_cook_Unknown_cuisine = item_hd_cook_Unknown_cuisine or class({})
function item_hd_cook_Unknown_cuisine:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusGain", {stack =6})


		self:SpendCharge(0)
	end
end


item_hd_cook_lobster = item_hd_cook_lobster or class({})
function item_hd_cook_lobster:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusGain", {stack =8})--9→12


		self:SpendCharge(0)
	end
end


item_hd_cook_Unknown_cuisine_clone = item_hd_cook_Unknown_cuisine_clone or class({})
function item_hd_cook_Unknown_cuisine_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusGain", {stack =12})


		self:SpendCharge(0)
	end
end


item_hd_cook_lobster_clone = item_hd_cook_lobster_clone or class({})
function item_hd_cook_lobster_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusGain", {stack =16})


		self:SpendCharge(0)
	end
end




modifier_cook_ModifierStatusGain = modifier_cook_ModifierStatusGain or advanced_modifier({})

function modifier_cook_ModifierStatusGain:IsDebuff() return false end
function modifier_cook_ModifierStatusGain:IsHidden() return true end
function modifier_cook_ModifierStatusGain:IsPurgable() return false end
function modifier_cook_ModifierStatusGain:IsPurgeException() return false end
function modifier_cook_ModifierStatusGain:GetTexture()return "item_cook_3" end
function modifier_cook_ModifierStatusGain:RemoveOnDeath() return false end
function modifier_cook_ModifierStatusGain:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_ModifierStatusGain:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

-- advanced_modifier
function modifier_cook_ModifierStatusGain:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_DurationGain,
    }
end
function modifier_cook_ModifierStatusGain:Advanced_GetModifier_DurationGain(keys)
	return self:GetStackCount()
end


--复合料理：状态抗性与伤害减免料理

item_hd_cook_Delicious_meat = item_hd_cook_Delicious_meat or class({})
function item_hd_cook_Delicious_meat:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusResistance", {stack =6})--4→8
		caster:AddNewModifier(caster, self, "modifier_cook_IncomingDamageResist", {stack =3})--新增：0.3%伤害减免


		self:SpendCharge(0)
	end
end



item_hd_cook_Delicious_meat_2 = item_hd_cook_Delicious_meat_2 or class({})
function item_hd_cook_Delicious_meat_2:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusResistance", {stack =10})--7→14
		caster:AddNewModifier(caster, self, "modifier_cook_IncomingDamageResist", {stack =6})--新增：0.6%伤害减免


		self:SpendCharge(0)
	end
end



item_hd_cook_Delicious_meat_clone = item_hd_cook_Delicious_meat_clone or class({})
function item_hd_cook_Delicious_meat_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusResistance", {stack =12})
		caster:AddNewModifier(caster, self, "modifier_cook_IncomingDamageResist", {stack =6})--新增：0.6%伤害减免


		self:SpendCharge(0)
	end
end

item_hd_cook_Delicious_meat_2_clone = item_hd_cook_Delicious_meat_2_clone or class({})
function item_hd_cook_Delicious_meat_2_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierStatusResistance", {stack =20})
		caster:AddNewModifier(caster, self, "modifier_cook_IncomingDamageResist", {stack =12})--新增：1.2%伤害减免


		self:SpendCharge(0)
	end
end

--状态抗性
modifier_cook_ModifierStatusResistance = modifier_cook_ModifierStatusResistance or advanced_modifier({})

function modifier_cook_ModifierStatusResistance:IsDebuff() return false end
function modifier_cook_ModifierStatusResistance:IsHidden() return true end
function modifier_cook_ModifierStatusResistance:IsPurgable() return false end
function modifier_cook_ModifierStatusResistance:IsPurgeException() return false end
function modifier_cook_ModifierStatusResistance:GetTexture()return "item_cook_20" end
function modifier_cook_ModifierStatusResistance:RemoveOnDeath() return false end
function modifier_cook_ModifierStatusResistance:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_ModifierStatusResistance:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end


function modifier_cook_ModifierStatusResistance:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_cook_ModifierStatusResistance:Advanced_GetModifier_StatusResistance(keys)
	return self:GetStackCount()
end


--伤害减免
modifier_cook_IncomingDamageResist = modifier_cook_IncomingDamageResist or advanced_modifier({})

function modifier_cook_IncomingDamageResist:IsDebuff() return false end
function modifier_cook_IncomingDamageResist:IsHidden() return true end
function modifier_cook_IncomingDamageResist:IsPurgable() return false end
function modifier_cook_IncomingDamageResist:IsPurgeException() return false end
function modifier_cook_IncomingDamageResist:GetTexture()return "item_cook_20" end
function modifier_cook_IncomingDamageResist:RemoveOnDeath() return false end
function modifier_cook_IncomingDamageResist:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_IncomingDamageResist:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end


function modifier_cook_IncomingDamageResist:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end



function modifier_cook_IncomingDamageResist:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -self:GetStackCount()*0.1
end






--复合料理：伤害增加与负面状态强化料理


item_hd_cook_egg = item_hd_cook_egg or class({})
function item_hd_cook_egg:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_NagativeGain", {stack =4})
		caster:AddNewModifier(caster, self, "modifier_cook_damage_totalup", {stack =3})--新增：0.3%伤害增加

		self:SpendCharge(0)
	end
end

item_hd_cook_egg_2 = item_hd_cook_egg_2 or class({})
function item_hd_cook_egg_2:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_NagativeGain", {stack =5})
		caster:AddNewModifier(caster, self, "modifier_cook_damage_totalup", {stack =4})--新增：0.4%伤害增加


		self:SpendCharge(0)
	end
end
item_hd_cook_egg_clone = item_hd_cook_egg_clone or class({})
function item_hd_cook_egg_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_NagativeGain", {stack =8})
		caster:AddNewModifier(caster, self, "modifier_cook_damage_totalup", {stack =6})--新增：0.6%伤害增加


		self:SpendCharge(0)
	end
end

item_hd_cook_egg_2_clone = item_hd_cook_egg_2_clone or class({})
function item_hd_cook_egg_2_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_NagativeGain", {stack =10})
		caster:AddNewModifier(caster, self, "modifier_cook_damage_totalup", {stack =8})--新增：0.8%伤害增加


		self:SpendCharge(0)
	end
end

--负面效果增强
modifier_cook_NagativeGain = modifier_cook_NagativeGain or advanced_modifier({})

function modifier_cook_NagativeGain:IsDebuff() return false end
function modifier_cook_NagativeGain:IsHidden() return true end
function modifier_cook_NagativeGain:IsPurgable() return false end
function modifier_cook_NagativeGain:IsPurgeException() return false end
function modifier_cook_NagativeGain:GetTexture()return "item_cook_9" end
function modifier_cook_NagativeGain:RemoveOnDeath() return false end
function modifier_cook_NagativeGain:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_NagativeGain:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_NagativeGain:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_NegativeDurationGain,


    }
end
function modifier_cook_NagativeGain:Advanced_GetModifier_NegativeDurationGain(keys)return self:GetStackCount() end

--伤害增加
modifier_cook_damage_totalup = modifier_cook_damage_totalup or advanced_modifier({})

function modifier_cook_damage_totalup:IsDebuff() return false end
function modifier_cook_damage_totalup:IsHidden() return true end
function modifier_cook_damage_totalup:IsPurgable() return false end
function modifier_cook_damage_totalup:IsPurgeException() return false end
function modifier_cook_damage_totalup:GetTexture()return "item_cook_9" end
function modifier_cook_damage_totalup:RemoveOnDeath() return false end
function modifier_cook_damage_totalup:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_damage_totalup:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_damage_totalup:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,


    }
end
function modifier_cook_damage_totalup:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)return self:GetStackCount()*0.1 end
---------------------------------------------------------------------------------------------------------------------------------
--生命恢复
modifier_cook_health_regen = modifier_cook_health_regen or advanced_modifier({})

function modifier_cook_health_regen:IsDebuff() return false end
function modifier_cook_health_regen:IsHidden() return true end
function modifier_cook_health_regen:IsPurgable() return false end
function modifier_cook_health_regen:IsPurgeException() return false end
function modifier_cook_health_regen:GetTexture()return "item_cook_9" end
function modifier_cook_health_regen:RemoveOnDeath() return false end
function modifier_cook_health_regen:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_health_regen:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_health_regen:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,


    }
end
function modifier_cook_health_regen:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount() end
---------------------------------------------------------------------------------------------------------------------------------


item_hd_cook_apex = item_hd_cook_apex or class({})
function item_hd_cook_apex:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_agi", {stack =15})
		caster:AddNewModifier(caster, self, "modifier_cook_str", {stack =15})
		caster:AddNewModifier(caster, self, "modifier_cook_int", {stack =15})


		self:SpendCharge(0)
	end
end





--智力料理


item_hd_cook_green_3 = item_hd_cook_green_3 or class({})
function item_hd_cook_green_3:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_int", {stack =10})--7→10


		self:SpendCharge(0)
	end
end

item_hd_cook_green_3_clone = item_hd_cook_green_3_clone or class({})
function item_hd_cook_green_3_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_int", {stack =20})


		self:SpendCharge(0)
	end
end

modifier_cook_int = modifier_cook_int or class({})

function modifier_cook_int:IsDebuff() return false end
function modifier_cook_int:IsHidden() return true end
function modifier_cook_int:IsPurgable() return false end
function modifier_cook_int:IsPurgeException() return false end
function modifier_cook_int:GetTexture()return "item_cook_22" end
function modifier_cook_int:RemoveOnDeath() return false end
function modifier_cook_int:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_int:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_int:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷                  

	}
end

function modifier_cook_int:GetModifierBonusStats_Intellect()return self:GetStackCount() end

















--敏捷


item_hd_cook_bard_meat_3 = item_hd_cook_bard_meat_3 or class({})
function item_hd_cook_bard_meat_3:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_agi", {stack =10})


		self:SpendCharge(0)
	end
end

item_hd_cook_bard_meat_3_clone = item_hd_cook_bard_meat_3_clone or class({})
function item_hd_cook_bard_meat_3_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_agi", {stack =20})


		self:SpendCharge(0)
	end
end

modifier_cook_agi = modifier_cook_agi or class({})

function modifier_cook_agi:IsDebuff() return false end
function modifier_cook_agi:IsHidden() return true end
function modifier_cook_agi:IsPurgable() return false end
function modifier_cook_agi:IsPurgeException() return false end
function modifier_cook_agi:GetTexture()return "item_cook_18" end
function modifier_cook_agi:RemoveOnDeath() return false end
function modifier_cook_agi:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_agi:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_agi:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷                  

	}
end

function modifier_cook_agi:GetModifierBonusStats_Agility()return self:GetStackCount() end











--力量


item_hd_cook_meat_3 = item_hd_cook_meat_3 or class({})
function item_hd_cook_meat_3:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_str", {stack =10})


		self:SpendCharge(0)
	end
end

item_hd_cook_meat_3_clone = item_hd_cook_meat_3_clone or class({})
function item_hd_cook_meat_3_clone:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_str", {stack =20})


		self:SpendCharge(0)
	end
end


modifier_cook_str = modifier_cook_str or class({})

function modifier_cook_str:IsDebuff() return false end
function modifier_cook_str:IsHidden() return true end
function modifier_cook_str:IsPurgable() return false end
function modifier_cook_str:IsPurgeException() return false end
function modifier_cook_str:GetTexture()return "item_cook_23" end
function modifier_cook_str:RemoveOnDeath() return false end
function modifier_cook_str:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_str:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_str:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷                  

	}
end

function modifier_cook_str:GetModifierBonusStats_Strength()return self:GetStackCount() end






















































LinkLuaModifier("modifier_item_hd_royal_jelly2", "items/item_hd_royal_jelly2", LUA_MODIFIER_MOTION_NONE)

item_hd_cook_royal_jelly = class({})


function item_hd_cook_royal_jelly:OnSpellStart()
	if IsServer() then

		self:GetCaster():EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )

		local nTeamNumber = self:GetCaster():GetTeamNumber()

		local Heroes = GetAllRealHeroes()

		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == nTeamNumber then
				Hero:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_royal_jelly2", {})
			
			end
		end

		self:SpendCharge(0)
	end
end









item_hd_gifte_of_fate = item_hd_gifte_of_fate or class({})
function item_hd_gifte_of_fate:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_cook_ModifierRandomEffectGain")
		if modifier and modifier:GetStackCount()>=20 then
			return
		end
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_ModifierRandomEffectGain", {stack =1})
		self:SpendCharge(0)
	end
end




modifier_cook_ModifierRandomEffectGain = modifier_cook_ModifierRandomEffectGain or advanced_modifier({})

function modifier_cook_ModifierRandomEffectGain:IsDebuff() return false end
function modifier_cook_ModifierRandomEffectGain:IsHidden() return true end
function modifier_cook_ModifierRandomEffectGain:IsPurgable() return false end
function modifier_cook_ModifierRandomEffectGain:IsPurgeException() return false end
function modifier_cook_ModifierRandomEffectGain:GetTexture()return "item_gift_of_fate" end
function modifier_cook_ModifierRandomEffectGain:RemoveOnDeath() return false end
function modifier_cook_ModifierRandomEffectGain:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_ModifierRandomEffectGain:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end


-- advanced_modifier
function modifier_cook_ModifierRandomEffectGain:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RandomEffectGain,
    }
end
function modifier_cook_ModifierRandomEffectGain:Advanced_GetModifier_RandomEffectGain(keys)
	return self:GetStackCount()
end






item_hd_gifte_of_power = item_hd_gifte_of_power or class({})
function item_hd_gifte_of_power:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_cook_allAttackDamage")
		if modifier and modifier:GetStackCount()>=90 then
			return
		end
		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, self, "modifier_cook_allAttackDamage", {stack =2})
		self:SpendCharge(0)
	end
end




modifier_cook_allAttackDamage = modifier_cook_allAttackDamage or class({})

function modifier_cook_allAttackDamage:IsDebuff() return false end
function modifier_cook_allAttackDamage:IsHidden() return true end
function modifier_cook_allAttackDamage:IsPurgable() return false end
function modifier_cook_allAttackDamage:IsPurgeException() return false end
function modifier_cook_allAttackDamage:GetTexture()return "item_gift_of_fate" end
function modifier_cook_allAttackDamage:RemoveOnDeath() return false end
function modifier_cook_allAttackDamage:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
	end
end
function modifier_cook_allAttackDamage:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end

function modifier_cook_allAttackDamage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,             --力量
	}
end

function modifier_cook_allAttackDamage:GetModifierDamageOutgoing_Percentage()return self:GetStackCount() end






