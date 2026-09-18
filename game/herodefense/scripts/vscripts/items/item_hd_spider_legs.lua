item_hd_spider_legs = class({})
-- LinkLuaModifier("modifier_item_hd_spider_legs_arua", "items/item_hd_spider_legs", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_spider_legs_arua_effect", "items/item_hd_spider_legs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spider_legs", "items/item_hd_spider_legs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_spider_legs_active", "items/item_hd_spider_legs", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_spider_legs:GetIntrinsicModifierName()
	return "modifier_item_hd_spider_legs"
end


function item_hd_spider_legs:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("DOTA_Item.SpiderLegs.Cast")
	local gain = caster:GetModifierDurationGainIndex(1)

	caster:AddNewModifier(caster, self, "modifier_item_hd_spider_legs_active", {duration = 3*gain})

end

modifier_item_hd_spider_legs = class({})

function modifier_item_hd_spider_legs:IsDebuff() return false end
function modifier_item_hd_spider_legs:IsHidden() return true end
function modifier_item_hd_spider_legs:IsPurgable() return false end



function modifier_item_hd_spider_legs:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.bonus_turn_rate_per = self.ability:GetSpecialValueFor("bonus_turn_rate_per")


end


function modifier_item_hd_spider_legs:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,             --转身速率
		

	}
end


function modifier_item_hd_spider_legs:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
function modifier_item_hd_spider_legs:GetModifierTurnRate_Percentage()   return self.bonus_turn_rate_per  end



modifier_item_hd_spider_legs_active = advanced_modifier({})

function modifier_item_hd_spider_legs_active:IsDebuff() return false end
function modifier_item_hd_spider_legs_active:IsHidden() return false end
function modifier_item_hd_spider_legs_active:IsPurgable() return false end
function modifier_item_hd_spider_legs_active:GetTexture()return "item_spider_legs" end
-- function modifier_item_hd_spider_legs_active:GetEffectName() return "particles/items5_fx/spider_legs_buff_legs.vpcf" end
-- function modifier_item_hd_spider_legs_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_hd_spider_legs_active:OnCreated(table)
	if IsServer() then

		self.pfx_min = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_spider_legs_buff_legs.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.pfx_min, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)

	end
end

function modifier_item_hd_spider_legs_active:OnDestroy(table)
	if IsServer() then
		self.pfx_min = ParticleManager:DestroyParticle(self.pfx_min, true)
	end
end


function modifier_item_hd_spider_legs_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end

function modifier_item_hd_spider_legs_active:GetModifierMoveSpeedBonus_Percentage()	return 30 end

-- advanced_modifier
function modifier_item_hd_spider_legs_active:ADDeclareFunctions()
    return 
    {
        -- advanced_MODIFIER_PROPERTY_Flying,
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_item_hd_spider_legs_active:Advanced_GetModifier_FlyingPathing()	
	return 1
end
