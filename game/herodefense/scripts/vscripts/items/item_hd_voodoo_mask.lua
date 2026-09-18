item_hd_voodoo_mask = class({})
-- LinkLuaModifier("modifier_item_hd_voodoo_mask_arua", "items/item_hd_voodoo_mask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_voodoo_mask", "items/item_hd_voodoo_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_voodoo_mask_disarm", "items/item_hd_voodoo_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_voodoo_mask_active_lifesteal", "items/item_hd_voodoo_mask", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_voodoo_mask:GetIntrinsicModifierName()
	return "modifier_item_hd_voodoo_mask"
end

modifier_item_hd_voodoo_mask = class({})

function modifier_item_hd_voodoo_mask:IsDebuff() return false end
function modifier_item_hd_voodoo_mask:IsHidden() return true end
function modifier_item_hd_voodoo_mask:IsPurgable() return false end
-- function modifier_item_hd_voodoo_mask:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_voodoo_mask:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_life_steal = self.ability:GetSpecialValueFor("bonus_life_steal")*0.01  --在这里先计算就不用每次攻击都浪费一次计算了
end




function modifier_item_hd_voodoo_mask:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                     --受到伤害事件

	}
end



function modifier_item_hd_voodoo_mask:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		--初始判断 满足以下:
		--造成伤害者是状态携带者
		--伤害者不是幻象
		--伤害类型是技能伤害
		--不带反甲伤害标签
		--不带不造成吸血标签
		-- print("tg.damage_category="..tg.damage_category)

		local parent = self:GetParent()
        if tg.attacker==parent 
		and not parent:IsIllusion() 
		and tg.damage_category==DOTA_DAMAGE_CATEGORY_SPELL
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 

			--该生命吸血受到吸血增强影响
            local life_steal_gain = parent:GetModifierLifeStealGain(1)
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
            parent:Heal(hp, self.ability)

        end 
    end 
end

