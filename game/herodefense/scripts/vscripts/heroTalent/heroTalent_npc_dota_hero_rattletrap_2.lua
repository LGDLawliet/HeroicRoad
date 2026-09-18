LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_rattletrap_2", "heroTalent/heroTalent_npc_dota_hero_rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE )

heroTalent_npc_dota_hero_rattletrap_2 = class({})


function heroTalent_npc_dota_hero_rattletrap_2:Unlockachievement()
	self.customAchievement = true
end
-- 发送数据包，解锁成就
function heroTalent_npc_dota_hero_rattletrap_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("legend_talent_3")
		end
	end
end

function heroTalent_npc_dota_hero_rattletrap_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_rattletrap_2"
end
function heroTalent_npc_dota_hero_rattletrap_2:GetCustomCastError()
	return "#DOTA_CUSTOM_NO_ARMOR"
end

function heroTalent_npc_dota_hero_rattletrap_2:CastFilterResult()
	if IsServer() then
		local caster = self:GetCaster()
		if caster.GetPlayerOwnerID then
			local first_item = caster:GetItemInSlot(0)
			if IsValid(first_item) then	
				local item_intrinsic_modifier = caster:FindModifierByName(first_item:GetIntrinsicModifierName())
				if IsValid(item_intrinsic_modifier) then
					if not item_intrinsic_modifier.Advanced_GetModifierPhysicalArmorBonus 
						or type(item_intrinsic_modifier.Advanced_GetModifierPhysicalArmorBonus) ~= "function" 
						or first_item:GetAbilityName() == "item_rattletrap_2" then
						return UF_FAIL_CUSTOM
					end
				else
					return UF_FAIL_CUSTOM
				end
			else
				return UF_FAIL_CUSTOM
			end
		end
		return UF_SUCCESS
	end
end

function heroTalent_npc_dota_hero_rattletrap_2:OnSpellStart()
	local caster = self:GetCaster()
	local chip_name = "item_rattletrap_2"

	local first_item = caster:GetItemInSlot(0)
	if IsValid(first_item) and first_item:GetAbilityName() ~= chip_name then		

		local item_intrinsic_modifier = caster:FindModifierByName(first_item:GetIntrinsicModifierName())
		local have_chip = false
		if IsValid(item_intrinsic_modifier) then
			local transfer_num = 0
			local armor_save = self:GetSpecialValueFor("armor_save")*0.01
			local min_save = self:GetSpecialValueFor("min_save")
			if item_intrinsic_modifier.Advanced_GetModifierPhysicalArmorBonus and type(item_intrinsic_modifier.Advanced_GetModifierPhysicalArmorBonus) == "function" then
				local item_armor = item_intrinsic_modifier:Advanced_GetModifierPhysicalArmorBonus() or min_save
				transfer_num =  math.floor(math.max(item_armor*armor_save,min_save))
			end

			--这玩意放前面的目的是必须腾出一个空来，不然你会看到满地碎片或者直接失效
			caster:EmitSound("DOTA_Item.HavocHammer.Cast")
			UTIL_RemoveImmediate(first_item)
			-- 如果已经有了就直接加充能
			for i=0, 10 do
				local Item = caster:GetItemInSlot(i)
				if Item ~= nil then
					if Item:GetAbilityName() == chip_name then
						have_chip = true
						self:AddChip(transfer_num)
					end
				end
			end
			--没有就先给一个，然后再加充能
			if not have_chip then
				caster:AddItemByName(chip_name)
				self:AddChip(transfer_num-1)
			end
		end
	end
end

function heroTalent_npc_dota_hero_rattletrap_2:AddChip(num)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local chip_name = "item_rattletrap_2"

	for i=0, 10 do
		local Item = caster:GetItemInSlot(i)
		if Item ~= nil then
			if Item:GetAbilityName() == chip_name then
				Item:SetCurrentCharges(math.min(Item:GetCurrentCharges() + num, 600))
			end
		end
	end
end

modifier_heroTalent_npc_dota_hero_rattletrap_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_rattletrap_2:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.profic = self.ability:GetSpecialValueFor("profic")*0.01

	self.damage_atk_index = 0.5
    self.damage_atb_index = 1.5
	self.talentgain = self.ability:GetTalentGain(self.profic)
	if IsServer() then
		self:GetAbility():Unlockachievement()
	end
end
function modifier_heroTalent_npc_dota_hero_rattletrap_2:OnRefresh()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.profic = self.ability:GetSpecialValueFor("profic")*0.01

	self.damage_atk_index = 0.5
    self.damage_atb_index = 1.5
	self.talentgain = self.ability:GetTalentGain(self.profic)
	if IsServer() then

	end
end
function modifier_heroTalent_npc_dota_hero_rattletrap_2:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE
	}
end
function modifier_heroTalent_npc_dota_hero_rattletrap_2:Advanced_GetModifierPhysicalArmorBonusPercentage()
	self.talentgain = self.ability:GetTalentGain(self.profic)
	local armor_pct = (self.talentgain-1)*100
	return armor_pct
end
function modifier_heroTalent_npc_dota_hero_rattletrap_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_heroTalent_npc_dota_hero_rattletrap_2:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self:Advanced_GetModifierPhysicalArmorBonusPercentage()
    elseif self._tooltip == 2 then
        return 
    elseif self._tooltip == 3 then
        return 
	end
end