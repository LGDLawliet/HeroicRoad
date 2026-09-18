LinkLuaModifier("modifier_item_set_chaos_food", "items/item_set_chaos_food", LUA_MODIFIER_MOTION_NONE)
item_set_chaos_food = item_set_chaos_food or class({})
function item_set_chaos_food:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
        local random = math.random
        local attack = random(-70,150)
        local spell = random(-10,20)
        local hp = random(-6,10)
        self.gold = nil
        self.lvl = nil
        self.rune = nil

        local gold = 0
        if 25>=random(1,100)then
            self.gold = true
            gold = random(2,5)
        end

        local lvl = 0
        if 3>=random(1,100)then
            self.lvl = true
            lvl = 1
        end

        local rune = 0
        if 8>=random(1,100)then
            self.rune = true
            rune = random(2,6)
        end
        
        if self.gold or self.lvl or self.rune then
           if self.gold then
                local gameEvent={}
                gameEvent["message"] = "#DOTA_HUD_chaos_food_gold_info"
                gameEvent["locstring_value"] = caster:GetUnitName()
                gameEvent["locstring_value2"] = gold
                gameEvent["teamnumber"] = -1
                FireGameEvent( "dota_combat_event_message", gameEvent )
           end
           if self.lvl then
                local gameEvent={}
                gameEvent["message"] = "#DOTA_HUD_chaos_food_lvl_info"
                gameEvent["locstring_value"] = caster:GetUnitName()
                gameEvent["locstring_value2"] = lvl
                gameEvent["teamnumber"] = -1
                FireGameEvent( "dota_combat_event_message", gameEvent )
           end
           if self.rune then
            local gameEvent={}
            gameEvent["message"] = "#DOTA_HUD_chaos_food_rune_info"
            gameEvent["locstring_value"] = caster:GetUnitName()
            gameEvent["locstring_value2"] = rune
            gameEvent["teamnumber"] = -1
            FireGameEvent( "dota_combat_event_message", gameEvent )
            end    
        end

		caster:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		caster:AddNewModifier(caster, nil, "modifier_item_set_chaos_food", {attack=attack ,spell=spell ,hp=hp ,gold=gold ,shop_lvl=lvl ,rune=rune})
		self:SpendCharge(0)
	end
end

---------
modifier_item_set_chaos_food = advanced_modifier({})
function modifier_item_set_chaos_food:IsHidden() return false end
function modifier_item_set_chaos_food:IsDebuff() return false end
function modifier_item_set_chaos_food:RemoveOnDeath() return false end
function modifier_item_set_chaos_food:IsPurgable() return false end
function modifier_item_set_chaos_food:GetTexture() return "item_gift_of_fate" end
function modifier_item_set_chaos_food:OnCreated(keys)
    if not IsServer() then
        return
    end
    self.attack = 0+keys.attack
    self.spell = 0+keys.spell
    self.hp = 0+keys.hp

    self.gold = 0+keys.gold
    self.shop_lvl = 0+keys.shop_lvl
    self.rune = 0+keys.rune
    self:SetHasCustomTransmitterData( true )
end
function modifier_item_set_chaos_food:OnRefresh(keys)
    if not IsServer() then
        return
    end
    self.attack = self.attack + keys.attack
    self.spell = self.spell+keys.spell
    self.hp = self.hp+keys.hp

    self.gold = self.gold+keys.gold
    self.shop_lvl = self.shop_lvl+keys.shop_lvl
    self.rune = self.rune+keys.rune
    self:SendBuffRefreshToClients()
end
function modifier_item_set_chaos_food:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,--攻击力
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,--法强
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,--线性HP

        advanced_MODIFIER_PROPERTY_Chaotic_Era_BountyBonus,--金币加成
        advanced_MODIFIER_PROPERTY_Chaotic_Era_SHOP_LEVEL_BONUS,--商店等级
        advanced_MODIFIER_PROPERTY_Chaotic_Era_RunePorgressBonus,--符石加成
    }
end
function modifier_item_set_chaos_food:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_set_chaos_food:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 6 + 1
	if self._tooltip == 1 then
		return  self.attack
	elseif self._tooltip == 2 then
		return self.spell
	elseif self._tooltip == 3 then
		return self.hp
    elseif self._tooltip == 4 then
		return self.gold
    elseif self._tooltip == 5 then
		return self.shop_lvl
    elseif self._tooltip == 6 then
		return self.rune
	end
end
function modifier_item_set_chaos_food:Advanced_GetModifierPreAttack_BonusDamage()
    return self.attack
end
function modifier_item_set_chaos_food:Advanced_GetModifierSpellAmplifyBonus()
    return self.spell
end
function modifier_item_set_chaos_food:AdvancedGetModifierExtraHealthPercentage()
    return self.hp
end


function modifier_item_set_chaos_food:Advanced_GetChaotic_Era_BountyBonus()
    return self.gold
end
function modifier_item_set_chaos_food:Advanced_Chaotic_Era_ShopLevelBonus()
    return self.shop_lvl
end
function modifier_item_set_chaos_food:Advanced_GetChaotic_Era_RunePorgressBonus()
    return self.rune
end

function modifier_item_set_chaos_food:AddCustomTransmitterData( )
	return
	{
		attack = self.attack,
		spell = self.spell,
        hp = self.hp,
        shop_lvl = self.shop_lvl,
        rune = self.rune,
        gold = self.gold,
	}
end

function modifier_item_set_chaos_food:HandleCustomTransmitterData( data )
	self.attack = data.attack
    self.spell = data.spell
    self.hp = data.hp
    self.shop_lvl = data.shop_lvl
    self.rune = data.rune
    self.gold = data.gold
end