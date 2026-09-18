item_hd_helm_of_the_undying = class({})
-- LinkLuaModifier("modifier_item_hd_helm_of_the_undying_arua", "items/item_hd_helm_of_the_undying", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_helm_of_the_undying_arua_effect", "items/item_hd_helm_of_the_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helm_of_the_undying", "items/item_hd_helm_of_the_undying", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helm_of_the_undying_active", "items/item_hd_helm_of_the_undying", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_helm_of_the_undying:GetIntrinsicModifierName()
	return "modifier_item_hd_helm_of_the_undying"
end





modifier_item_hd_helm_of_the_undying = advanced_modifier({})

function modifier_item_hd_helm_of_the_undying:IsDebuff() return false end
function modifier_item_hd_helm_of_the_undying:IsHidden() return true end
function modifier_item_hd_helm_of_the_undying:IsPurgable() return false end


function modifier_item_hd_helm_of_the_undying:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end



function modifier_item_hd_helm_of_the_undying:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	}
end

function modifier_item_hd_helm_of_the_undying:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_helm_of_the_undying:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit

		if unit~=self:GetParent() then	return end
		-- if keys.damage>=unit:GetHealth() and self:GetAbility():IsCooldownReady() then
		if unit:GetHealth()<=0 and self:GetAbility():IsCooldownReady() then
			unit:SetHealth(1)
			unit:AddNewModifier(unit, nil, "modifier_item_hd_helm_of_the_undying_active", {duration = 5})
			-- unit:SetHealth(1+keys.damage)
			
			unit:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
			self:GetAbility():UseResources(true, true, true,true)
		end
		
    end 
end


function modifier_item_hd_helm_of_the_undying:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_helm_of_the_undying:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_item_hd_helm_of_the_undying_active = class({})

function modifier_item_hd_helm_of_the_undying_active:IsDebuff() return false end
function modifier_item_hd_helm_of_the_undying_active:IsHidden() return false end
function modifier_item_hd_helm_of_the_undying_active:IsPurgable() return false end
function modifier_item_hd_helm_of_the_undying_active:GetTexture()return "item_helm_of_the_undying" end
function modifier_item_hd_helm_of_the_undying_active:GetEffectName() return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf" end
function modifier_item_hd_helm_of_the_undying_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_helm_of_the_undying_active:KillPre() self:Destroy() end  

function modifier_item_hd_helm_of_the_undying_active:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		
	}
end

function modifier_item_hd_helm_of_the_undying_active:OnTakeDamage(keys)
    if IsServer() then  
		if keys.unit == self:GetParent() then
			if keys.damage<=0  then	return	end
			-- if keys.damage >= keys.unit:GetHealth()   then
			if keys.unit:GetHealth()<=0   then
				keys.unit:SetHealth(1)

			end	
		end
    end 
end

function modifier_item_hd_helm_of_the_undying_active:OnDestroy(keys)
    if IsServer() then  
		self:GetParent():ModifyHealth(0,self:GetAbility(),false, 0)
		self:GetParent():Kill(nil,self:GetParent())
		-- TrueKill(self:GetParent(), self:GetParent(), nil)
		-- self:GetParent():ForceKill(true)
		-- TrueKill(self:GetParent(), self:GetParent(), self:GetAbility())
    end 
end