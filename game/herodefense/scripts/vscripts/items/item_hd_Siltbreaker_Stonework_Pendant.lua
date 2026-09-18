item_hd_Siltbreaker_Stonework_Pendant = class({})
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Stonework_Pendant_arua", "items/item_hd_Siltbreaker_Stonework_Pendant", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Stonework_Pendant_arua_effect", "items/item_hd_Siltbreaker_Stonework_Pendant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Stonework_Pendant", "items/item_hd_Siltbreaker_Stonework_Pendant", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_Siltbreaker_Stonework_Pendant:GetIntrinsicModifierName()
	return "modifier_item_hd_Siltbreaker_Stonework_Pendant"
end






modifier_item_hd_Siltbreaker_Stonework_Pendant = advanced_modifier({})

function modifier_item_hd_Siltbreaker_Stonework_Pendant:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Stonework_Pendant:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Stonework_Pendant:IsPurgable() return false end


function modifier_item_hd_Siltbreaker_Stonework_Pendant:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = -self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_spell_damage_amplification = self.ability:GetSpecialValueFor("bonus_spell_damage_amplification")
	self.bonus_manacost_per = -self.ability:GetSpecialValueFor("bonus_manacost_per")
end


function modifier_item_hd_Siltbreaker_Stonework_Pendant:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,   --技能消耗（可增加）

	}
end


function modifier_item_hd_Siltbreaker_Stonework_Pendant:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_Siltbreaker_Stonework_Pendant:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_Siltbreaker_Stonework_Pendant:Advanced_GetModifierSpellAmplifyBonus()   return self.bonus_spell_damage_amplification end
function modifier_item_hd_Siltbreaker_Stonework_Pendant:GetModifierPercentageManacostStacking() return self.bonus_manacost_per end


function modifier_item_hd_Siltbreaker_Stonework_Pendant:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		--初始判断 满足以下:
		--造成伤害者是状态携带者
		--伤害者不是幻象
		--伤害类型是技能伤害
		--不带反甲伤害标签
		--不带不造成吸血标签
		-- print("tg.damage_category="..tg.damage_category)

		local unit = self:GetParent()
        if tg.attacker==unit 
		and not unit:IsIllusion() 
		and tg.damage_category==DOTA_DAMAGE_CATEGORY_SPELL
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 

			--该生命吸血受到吸血增强影响
            local life_steal_gain = unit:GetModifierLifeStealGain(1)
			local hp = 0
			hp=tg.damage*self.bonus_life_steal*life_steal_gain
            hp = hp-hp%1
			-- print("hp="..hp)
			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            unit:Heal(hp, self:GetAbility())

        end 
    end 
end

function modifier_item_hd_Siltbreaker_Stonework_Pendant:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end