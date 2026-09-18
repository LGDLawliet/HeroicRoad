
Middle_Blood_Sacrifice = class({})

LinkLuaModifier("modifier_Middle_Blood_Sacrifice_buff", "skills/Middle_Blood_Sacrifice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Blood_Sacrifice_buff_b", "skills/Middle_Blood_Sacrifice", LUA_MODIFIER_MOTION_NONE) 



function Middle_Blood_Sacrifice:IsHiddenWhenStolen() 		return true end
function Middle_Blood_Sacrifice:IsRefreshable() 			return true end
function Middle_Blood_Sacrifice:IsStealable() 			return false end
function Middle_Blood_Sacrifice:IsNetherWardStealable()	return false end
function Middle_Blood_Sacrifice:OnSpellStart()
	local caster = self:GetCaster()	
	local hp_percent = 1 - self:GetSpecialValueFor("hp_percent") * 0.01
	if caster:GetHealth() ~= 1 then
		caster:SetHealth(caster:GetHealth() * hp_percent)
	end	
	local random_response = RandomInt(1, 4)
	caster:EmitSound("ogre_magi_ogmag_ability_bloodlust_0"..random_response)
	caster:EmitSound("Hero_OgreMagi.Bloodlust.Target")

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.7)
	local duration = self:GetSpecialValueFor("buff_duration")
	duration = math.min(duration*3,duration*ModifierStatusGain)

	caster:AddNewModifier(caster, self, "modifier_Middle_Blood_Sacrifice_buff", {duration = duration})


end





modifier_Middle_Blood_Sacrifice_buff = advanced_modifier({})

function modifier_Middle_Blood_Sacrifice_buff:IsDebuff()				return false end
function modifier_Middle_Blood_Sacrifice_buff:IsHidden() 			return false end
function modifier_Middle_Blood_Sacrifice_buff:IsPurgable() 			return true end
function modifier_Middle_Blood_Sacrifice_buff:IsPurgeException() 	return true end

--function modifier_Middle_Blood_Sacrifice_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_Blood_Sacrifice_buff:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,

	} 
end
-- function modifier_Middle_Blood_Sacrifice_buff:GetModifierCastRangeBonusStacking() return (self.cast_distance*self.gain_index) end
function modifier_Middle_Blood_Sacrifice_buff:GetModifierDamageOutgoing_Percentage() return (self.attack_damage_bonus*self.gain_index) end
function modifier_Middle_Blood_Sacrifice_buff:GetModifierAttackSpeedBonus_Constant() return (self.attack_speed_bonus*self.gain_index)  end 
function modifier_Middle_Blood_Sacrifice_buff:Advanced_GetModifierSpellAmplifyBonus() return (self.ability_damage_bonus*self.gain_index) end
function modifier_Middle_Blood_Sacrifice_buff:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_Middle_Blood_Sacrifice_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_Middle_Blood_Sacrifice_buff:OnCreated(params)
	self.cast_distance = self:GetAbility():GetSpecialValueFor("cast_distance")
	self.attack_damage_bonus = self:GetAbility():GetSpecialValueFor("attack_damage_bonus")
	self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.ability_damage_bonus = self:GetAbility():GetSpecialValueFor("ability_damage_bonus")
	self.gain_index = 1
	self.bonus_reduce_index=0.94

	self.tData = {}
	table.insert(self.tData, { dieTime = self:GetDieTime() })
	if IsServer() then

		self:IncrementStackCount()

		self:StartIntervalThink(0.1)
	end

end
function modifier_Middle_Blood_Sacrifice_buff:OnRefresh(params)
	self.cast_distance = self:GetAbility():GetSpecialValueFor("cast_distance")
	self.attack_damage_bonus = self:GetAbility():GetSpecialValueFor("attack_damage_bonus")
	self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.ability_damage_bonus = self:GetAbility():GetSpecialValueFor("ability_damage_bonus")
	table.insert(self.tData, {dieTime = self:GetDieTime() })
	if IsServer() then
		
		self:IncrementStackCount()
	end
	local stack = self:GetStackCount()
	local now_index = 1
	self.gain_index = 1
	for i = 2, stack, 1 do
		now_index = now_index *self.bonus_reduce_index
		self.gain_index = self.gain_index + now_index
	end
end


function modifier_Middle_Blood_Sacrifice_buff:OnIntervalThink()

	local fGameTime = GameRules:GetGameTime()
	local change = false
	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].dieTime then
			table.remove(self.tData, i)
			if IsServer() then
				self:DecrementStackCount()

			end
			change = true
			
		end
	end
	if change then
		local stack = self:GetStackCount()
		local now_index = 1
		self.gain_index = 1
		for i = 2, stack, 1 do
			now_index = now_index *self.bonus_reduce_index
			self.gain_index = self.gain_index + now_index
		end
	end

end


-- advanced_modifier
function modifier_Middle_Blood_Sacrifice_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end
function modifier_Middle_Blood_Sacrifice_buff:Advanced_GetModifierCastRangeBonusStacking(keys)
	return (self.cast_distance*self.gain_index)
end

