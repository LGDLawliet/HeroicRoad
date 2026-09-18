LinkLuaModifier("modifier_chaotic_physkill_master_debuff", "chaotic_spell/class_4/chaotic_physkill_master", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_physkill_master_buff", "chaotic_spell/class_4/chaotic_physkill_master", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_physkill_master", "chaotic_spell/class_4/chaotic_physkill_master", LUA_MODIFIER_MOTION_NONE)
chaotic_physkill_master = class({})
function chaotic_physkill_master:GetIntrinsicModifierName()
	return	"modifier_chaotic_physkill_master"
end

-------------------------------------






modifier_chaotic_physkill_master = advanced_modifier({})

function modifier_chaotic_physkill_master:IsHidden()return true end
function modifier_chaotic_physkill_master:IsDebuff()return false end
function modifier_chaotic_physkill_master:IsPurgable()return false end
function modifier_chaotic_physkill_master:IsPurgeException() 	return false end

function modifier_chaotic_physkill_master:OnCreated(keys)
	self.bonus_outgoing = self:GetAbility():GetSpecialValueFor("bonus_outgoing")
	self.armor_down = self:GetAbility():GetSpecialValueFor("armor_down")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if IsServer() and self:GetAbility():GetRuneType()==3 then
		self:StartIntervalThink(0.5)
		self.cd_reduce = self:GetAbility():GetSpecialValueFor("rune_3_cd")*0.01*0.5
	end
end
function modifier_chaotic_physkill_master:OnIntervalThink()
	for i=0, 11 do
		local Ability = self:GetParent():GetAbilityByIndex(i)
		if Ability ~= nil and (not Ability:IsCooldownReady()) and Ability:GetChaoticSpellType()=="EraListSubdivision_checking_Skill" then
			if Ability:IsRefreshable() then
				if Ability ~= self:GetAbility()	then
					local new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - self.cd_reduce,0)
					Ability:EndCooldown()
					Ability:StartCooldown(new_cooldown)
				end
			end
		end
	end
end
function modifier_chaotic_physkill_master:ADDeclareFunctions()
    return 
    {
	  advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end
function modifier_chaotic_physkill_master:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return
	end
	if keys.attacker~=self:GetParent() then
		return
	end
	if not IsPhysicalSkillDamage(keys) then
		--print("这不是武技伤害，不触发")
		return
	end
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK  then
		--print("这是攻击伤害，不触发")
		return
	end
	self.bonus_outgoing = self:GetAbility():GetSpecialValueFor("bonus_outgoing")
	keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_chaotic_physkill_master_debuff", {duration = self.duration,stack = self.armor_down})
	keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_chaotic_physkill_master_buff", {duration = self.duration})

	if self:GetAbility():GetRuneType()==2 then
		local random = math.random
		if self:GetAbility():GetSpecialValueFor("rune_2_chance") >= random(1,100) then
			--print("触发了")
			self.bonus_outgoing = self.bonus_outgoing*(1+self:GetAbility():GetSpecialValueFor("rune_2_crit")*0.01)
		end
	end
	--print("增伤现在是"..self.bonus_outgoing)
	return self.bonus_outgoing
end





-------------------------------------


modifier_chaotic_physkill_master_debuff = advanced_modifier({})

function modifier_chaotic_physkill_master_debuff:IsHidden()return false end
function modifier_chaotic_physkill_master_debuff:IsDebuff()return true end
function modifier_chaotic_physkill_master_debuff:IsPurgable()return false end
function modifier_chaotic_physkill_master_debuff:IsPurgeException() 	return false end
function modifier_chaotic_physkill_master_debuff:OnCreated(keys)
	if IsServer() then
    	self:SetStackCount(keys.stack)
	end
end
function modifier_chaotic_physkill_master_debuff:OnRefresh(keys)
	if IsServer() then
    	self:SetStackCount(keys.stack)
	end
end
function modifier_chaotic_physkill_master_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_physkill_master_debuff:Advanced_GetModifierPhysicalArmorBonus()	
	return -self:GetStackCount()
end
function modifier_chaotic_physkill_master_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_chaotic_physkill_master_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:GetStackCount()
	end
end

-------------------------------------


modifier_chaotic_physkill_master_buff = advanced_modifier({})

function modifier_chaotic_physkill_master_buff:IsHidden()return false end
function modifier_chaotic_physkill_master_buff:IsDebuff()return false end
function modifier_chaotic_physkill_master_buff:IsPurgable()return false end
function modifier_chaotic_physkill_master_buff:IsPurgeException() 	return false end

function modifier_chaotic_physkill_master_buff:ADDeclareFunctions()
	local funcs =  {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE)
	end
	return funcs
end
function modifier_chaotic_physkill_master_buff:Advanced_GetModifierIncomingDamage_Percentage()
	if not self:GetAbility() then return end
	return -self:GetAbility():GetSpecialValueFor("incoming")

end
function modifier_chaotic_physkill_master_buff:AdvancedGetModifierConstantHealthRegenPercentage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("rune_1_hp_regen") 
end