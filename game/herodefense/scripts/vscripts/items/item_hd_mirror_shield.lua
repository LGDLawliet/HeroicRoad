item_hd_mirror_shield = class({})
-- LinkLuaModifier("modifier_item_hd_mirror_shield_arua", "items/item_hd_mirror_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_mirror_shield_arua_effect", "items/item_hd_mirror_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_mirror_shield", "items/item_hd_mirror_shield", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_mirror_shield:GetIntrinsicModifierName()
	return "modifier_item_hd_mirror_shield"
end





modifier_item_hd_mirror_shield = class({})

function modifier_item_hd_mirror_shield:IsDebuff() return false end
function modifier_item_hd_mirror_shield:IsHidden() return true end
function modifier_item_hd_mirror_shield:IsPurgable() return false end


function modifier_item_hd_mirror_shield:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")


end



function modifier_item_hd_mirror_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	
		-- MODIFIER_PROPERTY_ABSORB_SPELL,
		-- MODIFIER_PROPERTY_REFLECT_SPELL, 
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
		

	}
end


function modifier_item_hd_mirror_shield:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_mirror_shield:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_mirror_shield:GetModifierBonusStats_Agility()	return self.bonus_agi end


--当触发法术反弹时 添加一个莲花的buff 并由此再触发一次 
--备注 所有法术反弹都是由莲花触发的 所以当有莲花BUFF时说明有别的道具或技能触发了这个even  直接返回即可
-- function modifier_item_hd_mirror_shield:GetAbsorbSpell(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	if  not self:GetAbility():IsCooldownReady() then
-- 		return
-- 	end
-- 	if not IsEnemy(keys.ability:GetCaster(), self:GetParent()) then
-- 		return 0
-- 	end
-- 	--说明这次法术吸收是由法术反弹引起的
-- 	if self:GetParent():HasModifier("modifier_item_lotus_orb_active") then
-- 		return
-- 	end
-- 	if not self.trigger then
-- 		local modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_lotus_orb_active", {duration = 5})
-- 		self.trigger = true
-- 		self:GetParent():TriggerSpellAbsorb(keys.ability) --二次触发
-- 		modifier:Destroy()
-- 		local pfx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
-- 		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
-- 		ParticleManager:ReleaseParticleIndex(pfx)
-- 		self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
-- 		self:GetAbility():StartCooldown(10)

-- 		--防止出现某些BUG
-- 		Timers:CreateTimer(0.1, function()
-- 			self.trigger = false
-- 		end)
-- 		return 1
-- 	end
-- 	return 0
-- end

function modifier_item_hd_mirror_shield:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=1 and cooldown<=40 then
		if keys.target and keys.target==self:GetParent() and keys.ability:GetCooldownTimeRemaining()>=1 then
			local pfx = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
			self:GetAbility():StartCooldown(10)
			local time = keys.ability:GetCooldownTimeRemaining()
			keys.ability:EndCooldown()
			keys.ability:StartCooldown(time*0.5)
			
        end
    end

  
    
end


-- function modifier_item_hd_mirror_shield:GetReflectSpell(keys,trigger)
-- 	if not IsServer() then
-- 		return
-- 	end
-- 	-- if  not self:GetAbility():IsCooldownReady() then
-- 	-- 	return
-- 	-- end
-- 	if not IsEnemy(keys.ability:GetCaster(), self:GetParent()) then
-- 		return 0
-- 	end
-- 	if not trigger then
-- 		 return
-- 	end



-- 	return 1
-- end

