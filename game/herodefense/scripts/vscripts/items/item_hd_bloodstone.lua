item_hd_bloodstone = class({})

LinkLuaModifier("modifier_item_hd_bloodstone", "items/item_hd_bloodstone", LUA_MODIFIER_MOTION_NONE)

function item_hd_bloodstone:GetIntrinsicModifierName()
	return "modifier_item_hd_bloodstone"
end
---------------------------------------------------------------------------
modifier_item_hd_bloodstone = advanced_modifier({})

function modifier_item_hd_bloodstone:IsDebuff() return false end
function modifier_item_hd_bloodstone:IsHidden() return true end
function modifier_item_hd_bloodstone:IsPurgable() return false end



function modifier_item_hd_bloodstone:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()

	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了

	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_regeneration_amplification")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	self.bonus_Mana_regeneration_amplification = self.ability:GetSpecialValueFor("bonus_Mana_regeneration_amplification")

end



function modifier_item_hd_bloodstone:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		

	}
end



function modifier_item_hd_bloodstone:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_bloodstone:AdvancedGetModifierConstantHealthRegenAmpPercentage() 	return self.bonus_regeneration_amplification end
function modifier_item_hd_bloodstone:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
function modifier_item_hd_bloodstone:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_bloodstone:AdvancedGetModifierConstantManaRegenAmpPercentage() 	return self.bonus_Mana_regeneration_amplification end
function modifier_item_hd_bloodstone:AdvancedGetModifierConstantManaRegen()	return self.bonus_mana_regeneration end




function modifier_item_hd_bloodstone:OnTakeDamage(tg)
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
			if unit:GetHealthPercent()>=100 then
				unit:GiveMana(hp*0.01)
			else
           		unit:Heal(hp, self:GetAbility())
			end

        end 
    end 
end



function modifier_item_hd_bloodstone:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE
		

    }
end