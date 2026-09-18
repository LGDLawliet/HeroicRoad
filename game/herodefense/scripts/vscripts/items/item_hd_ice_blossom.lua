item_hd_ice_blossom = class({})
-- LinkLuaModifier("modifier_item_hd_ice_blossom_arua", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ice_blossom_arua_effect", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_blossom", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_blossom_active", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ice_blossom_active", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ice_blossom_active2", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ice_blossom_active_standby", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ice_blossom_debuff", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ice_blossom_thinker", "items/item_hd_ice_blossom", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_ice_blossom:GetIntrinsicModifierName()
	return "modifier_item_hd_ice_blossom"
end





modifier_item_hd_ice_blossom = class({})

function modifier_item_hd_ice_blossom:IsDebuff() return false end
function modifier_item_hd_ice_blossom:IsHidden() return true end
function modifier_item_hd_ice_blossom:IsPurgable() return false end


function modifier_item_hd_ice_blossom:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")




    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_ice_blossom_active_standby", {duration = 20})
		self:StartIntervalThink(0.2)

	end
end
function modifier_item_hd_ice_blossom:OnIntervalThink()
	if IsServer() then

	   if self:GetAbility():IsCooldownReady() then
		if not self:GetParent():IsAlive() then
			return
		end
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

		   for _, unit in pairs(units) do
			   local buffs = unit:FindAllModifiersByName("modifier_item_hd_ice_blossom_active")
			   if  #buffs == 0 then
				self:GetAbility():UseResources(true, true, true,true)
				self:GetAbility():StartCooldown(5)
				local ModifierStatusGain = self:GetParent():GetModifierDurationGainIndex(1)
				unit:AddNewModifier(unit, self:GetAbility(), "modifier_item_hd_ice_blossom_active", {duration = 35*ModifierStatusGain})
				unit:EmitSound("Hero_Pangolier.TailThump.Shield")
				return
			   end
		   end
		   
	
		
	   end
		-- self:SetHasCustomTransmitterData(true)
	end
end



function modifier_item_hd_ice_blossom:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	
		

	}
end


function modifier_item_hd_ice_blossom:GetModifierBonusStats_Intellect()	return self.bonus_int end



modifier_item_hd_ice_blossom_active = advanced_modifier({})

function modifier_item_hd_ice_blossom_active:IsDebuff() return false end
function modifier_item_hd_ice_blossom_active:IsHidden() return false end
function modifier_item_hd_ice_blossom_active:IsPurgable() return true end
function modifier_item_hd_ice_blossom_active:GetTexture()return "item_ice_blossom" end
function modifier_item_hd_ice_blossom_active:Advanced_GetModifierSpellAmplifyBonus()return 25 end


function modifier_item_hd_ice_blossom_active:OnCreated(keys)
	if IsServer() then
	local caster = self:GetParent()
	local particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/new_hd_ice_blossom_hield_buff.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
	self:AddParticle(particle, true, false, -1, true, false)

	end
end



function modifier_item_hd_ice_blossom_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MAGACIAL_BLOCK_CONSTANT_MAXIMUM,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
	}
end
function modifier_item_hd_ice_blossom_active:Advanced_GetModifierMagicalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	return 400
end