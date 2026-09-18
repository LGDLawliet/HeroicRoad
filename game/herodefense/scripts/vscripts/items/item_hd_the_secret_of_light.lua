item_hd_the_secret_of_light = class({})
-- LinkLuaModifier("modifier_item_hd_the_secret_of_light_arua", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_the_secret_of_light_arua_effect", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_the_secret_of_light", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_the_secret_of_light_active", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_the_secret_of_light_effect", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_the_secret_of_light_effect2", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_the_secret_of_light_active_standby", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_the_secret_of_light_debuff", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_the_secret_of_light_thinker", "items/item_hd_the_secret_of_light", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_the_secret_of_light:GetIntrinsicModifierName()
	return "modifier_item_hd_the_secret_of_light"
end






modifier_item_hd_the_secret_of_light = class({})

function modifier_item_hd_the_secret_of_light:IsDebuff() return false end
function modifier_item_hd_the_secret_of_light:IsHidden() return true end
function modifier_item_hd_the_secret_of_light:IsPurgable() return false end



function modifier_item_hd_the_secret_of_light:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")
	
end



function modifier_item_hd_the_secret_of_light:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法

		

	}
end



function modifier_item_hd_the_secret_of_light:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_the_secret_of_light:GetModifierManaBonus()	return self.bonus_mana end
function modifier_item_hd_the_secret_of_light:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end




function modifier_item_hd_the_secret_of_light:OnAbilityFullyCast(keys)

	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		local ability =keys.ability
		local manacost = ability:GetManaCost(ability:GetLevel())
		if manacost < 20 or ability:GetCooldown(ability:GetLevel())<5 or ability:GetCooldownTimeRemaining()<1 then
			return
		end

		if self:GetCaster():GetRandomEffect(20,INT_TYPE,0.5) >=RandomInt(1, 100) then
			local caster = self:GetCaster()
			caster:GiveMana(manacost)

			Timers:CreateTimer(0.1, function()
				local cooldown = ability:GetCooldownTimeRemaining()*0.5
				ability:EndCooldown()
				ability:StartCooldown(cooldown)
			end)
			caster:EmitSound("Hero_Antimage.ManaVoidCast")
			self.particle = ParticleManager:CreateParticle("particles/econ/items/keeper_of_the_light/kotl_ti10_immortal/kotl_ti10_blinding_light.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle)
			local ModifierStatusGain =caster:GetModifierDurationGainIndex(1)
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_the_secret_of_light_active", {duration = 30*ModifierStatusGain})
		end
	end
end



modifier_item_hd_the_secret_of_light_active = class({})

function modifier_item_hd_the_secret_of_light_active:IsDebuff() return false end
function modifier_item_hd_the_secret_of_light_active:IsHidden() return false end
function modifier_item_hd_the_secret_of_light_active:IsPurgable() return false end
function modifier_item_hd_the_secret_of_light_active:GetTexture()return "item_the_secret_of_light" end
function modifier_item_hd_the_secret_of_light_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	

	}
end
function modifier_item_hd_the_secret_of_light_active:GetModifierBonusStats_Intellect()	return 10*self:GetStackCount() end




function modifier_item_hd_the_secret_of_light_active:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_the_secret_of_light_active:OnRefresh(params)
	if IsServer() then
		-- table.insert(self.tData, {dieTime = self:GetDieTime() })
		-- self:IncrementStackCount()
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 20 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_item_hd_the_secret_of_light_active:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end
