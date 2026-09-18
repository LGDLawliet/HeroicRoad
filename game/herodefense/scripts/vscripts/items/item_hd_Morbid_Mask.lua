item_hd_Morbid_Mask = class({})

LinkLuaModifier("modifier_item_hd_Morbid_Mask", "items/item_hd_Morbid_Mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Morbid_Mask_disarm", "items/item_hd_Morbid_Mask", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
function item_hd_Morbid_Mask:GetIntrinsicModifierName()
	return "modifier_item_hd_Morbid_Mask"
end


-- function item_hd_Morbid_Mask:OnSpellStart()
-- 	local duration = self:GetSpecialValueFor("duration")
-- 	local target = self:GetCursorTarget()
-- 	local caster = self:GetCaster()
-- 	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
-- 	local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
-- 	target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
-- 	target:AddNewModifier(caster, self, "modifier_item_hd_Morbid_Mask_disarm", {duration = duration*StatusResistance})
-- end

modifier_item_hd_Morbid_Mask = class({})

function modifier_item_hd_Morbid_Mask:IsDebuff() return false end
function modifier_item_hd_Morbid_Mask:IsHidden() return true end
function modifier_item_hd_Morbid_Mask:IsPurgable() return false end
-- function modifier_item_hd_Morbid_Mask:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_Morbid_Mask:OnCreated(keys)
    self.ability = self:GetAbility()
    -- self.caster = self:GetCaster()
    -- local parent = self:GetParent()
	-- self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	-- self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	-- self.bonus_status_resistance = self.ability:GetSpecialValueFor("bonus_status_resistance")
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了

	-- end

end



function modifier_item_hd_Morbid_Mask:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                        --受到伤害事件
	}
end




-- function modifier_item_hd_Morbid_Mask:GetModifierEvasion_Constant() return self.bonus_evasion end

function modifier_item_hd_Morbid_Mask:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		--初始判断 满足以下:
		--造成伤害者是状态携带者
		--伤害者不是幻象
		--伤害类型是攻击伤害
		--不带反甲伤害标签
		--不带不造成吸血标签

		local parent = self:GetParent()
        if tg.attacker==parent 
		and not parent:IsIllusion() 
		and tg.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK 
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 

			--该生命吸血受到吸血增强影响
            local life_steal_gain = parent:GetModifierLifeStealGain(1)
            local hp=tg.damage*self.bonus_life_steal*life_steal_gain
            hp = hp-hp%1


			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            parent:Heal(hp, self.ability)

        end 
    end 
end



-- modifier_item_hd_Morbid_Mask_disarm=class({})

-- function modifier_item_hd_Morbid_Mask_disarm:GetTexture()return "item_heavens_halberd" end
-- function modifier_item_hd_Morbid_Mask_disarm:IsDebuff() 			return true  end
-- function modifier_item_hd_Morbid_Mask_disarm:IsHidden() 			return false  end
-- function modifier_item_hd_Morbid_Mask_disarm:IsPurgable() 			 return false end
-- function modifier_item_hd_Morbid_Mask_disarm:IsPurgeException() 	    return false end
-- function modifier_item_hd_Morbid_Mask_disarm:GetEffectAttachType() 	    return PATTACH_OVERHEAD_FOLLOW end
-- function modifier_item_hd_Morbid_Mask_disarm:GetEffectName() 	  return "particles/generic_gameplay/generic_disarm.vpcf" end
-- function modifier_item_hd_Morbid_Mask_disarm:RemoveOnDeath()    return true end
-- function modifier_item_hd_Morbid_Mask_disarm:CheckState()
--     return 
--     {
--         [MODIFIER_STATE_DISARMED] = true,
--     }
-- end