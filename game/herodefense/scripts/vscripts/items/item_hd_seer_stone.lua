item_hd_seer_stone = class({})
-- LinkLuaModifier("modifier_item_hd_seer_stone_arua", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_seer_stone_arua_effect", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_seer_stone", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_seer_stone_active", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_seer_stone_effect", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_seer_stone_effect2", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_seer_stone_active_standby", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_seer_stone_debuff", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_seer_stone_thinker", "items/item_hd_seer_stone", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_seer_stone:GetIntrinsicModifierName()
	return "modifier_item_hd_seer_stone"
end




modifier_item_hd_seer_stone = advanced_modifier({})

function modifier_item_hd_seer_stone:IsDebuff() return false end
function modifier_item_hd_seer_stone:IsHidden() return true end
function modifier_item_hd_seer_stone:IsPurgable() return false end

function modifier_item_hd_seer_stone:CheckState()
	local state = {
		[MODIFIER_STATE_FORCED_FLYING_VISION]=true,
	}
	

	return state
end


function modifier_item_hd_seer_stone:OnCreated(keys)
    self.ability = self:GetAbility()

    if self.ability then
        self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
        self.bonus_spell_range = self.ability:GetSpecialValueFor("bonus_spell_range")
        self.bonus_vision_percentage = self.ability:GetSpecialValueFor("bonus_vision_percentage")
        self.duration = self.ability:GetSpecialValueFor("duration")
        --self.spell_damage_up = self.ability:GetSpecialValueFor("spell_damage_up")

        if IsServer() then
            self:StartIntervalThink(0.2)
        end
    end
end
function modifier_item_hd_seer_stone:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		if ability and ability:IsCooldownReady() then
			ability:StartCooldown(15)
			local parent =self:GetParent()

			if not parent:IsAlive() then
				return
			end
			self.particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger_sphere.vpcf", PATTACH_POINT_FOLLOW,parent)
			local pos = parent:GetAbsOrigin()
			pos.z = pos.z + 128
			ParticleManager:SetParticleControl(self.particle, 0, pos)
			ParticleManager:ReleaseParticleIndex(self.particle)
			local gain =  parent:GetModifierDurationGainIndex(1)
			parent:AddNewModifier(parent, ability, "modifier_item_hd_seer_stone_active", {duration = self.duration*gain})
		end
	end
end



function modifier_item_hd_seer_stone:DeclareFunctions()
	return {
		
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,        --施法距离
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
	
		

	}
end



function modifier_item_hd_seer_stone:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
function modifier_item_hd_seer_stone:GetBonusVisionPercentage()	return self.bonus_vision_percentage end


function modifier_item_hd_seer_stone:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_item_hd_seer_stone:Advanced_GetModifierCastRangeBonusStacking(keys)

	return self.bonus_spell_range 
end

--------------------------------------------------------------------------------------------------------
modifier_item_hd_seer_stone_active = advanced_modifier({})

function modifier_item_hd_seer_stone_active:IsDebuff() return false end
function modifier_item_hd_seer_stone_active:IsHidden() return false end
function modifier_item_hd_seer_stone_active:IsPurgable() return false end
function modifier_item_hd_seer_stone_active:GetTexture()return "item_seer_stone" end
function modifier_item_hd_seer_stone_active:GetStatusEffectName() return "particles/basic_extend/status_effect_god3.vpcf" end
function modifier_item_hd_seer_stone_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_item_hd_seer_stone_active:OnCreated(table)

	self.spell_damage_up = 0
	self:StartIntervalThink(1)
end

function modifier_item_hd_seer_stone_active:OnIntervalThink()
	local ability = self:GetAbility()
	if ability then
		self.spell_damage_up = ability:GetSpecialValueFor("spell_damage_up")
	end
end

function modifier_item_hd_seer_stone_active:Advanced_GetModifierSpellAmplifyBonus() return self.spell_damage_up end