item_hd_rumusque_vestments = class({})

LinkLuaModifier("modifier_item_hd_rumusque_vestments", "items/item_hd_rumusque_vestments", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rumusque_vestments_buff", "items/item_hd_rumusque_vestments", LUA_MODIFIER_MOTION_NONE)



function item_hd_rumusque_vestments:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )

end










-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_rumusque_vestments:GetIntrinsicModifierName()
	return "modifier_item_hd_rumusque_vestments"
end


modifier_item_hd_rumusque_vestments = advanced_modifier({})

function modifier_item_hd_rumusque_vestments:IsDebuff() return false end
function modifier_item_hd_rumusque_vestments:IsHidden() return true end
function modifier_item_hd_rumusque_vestments:IsPurgable() return false end
function modifier_item_hd_rumusque_vestments:IsPurgeException() return false end
function modifier_item_hd_rumusque_vestments:RemoveOnDeath() return false end
function modifier_item_hd_rumusque_vestments:DestroyOnExpire() return false end
function modifier_item_hd_rumusque_vestments:OnCreated(keys)
	self.bonus_int =  self:GetAbility():GetSpecialValueFor("bonus_int")
	self.bonus_heal_amplification  = self:GetAbility():GetSpecialValueFor("bonus_heal_amp")
	if IsServer() then

		self.heal_table ={}
	end
end

function modifier_item_hd_rumusque_vestments:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,        
	}
end
function modifier_item_hd_rumusque_vestments:GetModifierBonusStats_Intellect()return self.bonus_int end


function modifier_item_hd_rumusque_vestments:OnCustomModifierFunction_Heal(keys)
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
		if keys.heal<5 then
			return
		end
		local caster = self:GetCaster()
		if not keys.target:IsRealHero() then
			return
		end
		if not self.heal_table[keys.target] then
			self.heal_table[keys.target] = 0
		end
		self.heal_table[keys.target] = self.heal_table[keys.target] + keys.heal
		if self.heal_table[keys.target]>=keys.target:GetMaxHealth() then
			self.heal_table[keys.target] = self.heal_table[keys.target] - keys.target:GetMaxHealth()
		end

		keys.target:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_rumusque_vestments_buff",{	duration = 30*caster:GetModifierDurationGainIndex(1)})
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN, keys.target)
		ParticleManager:SetParticleControl(pfx, 0, keys.target:GetOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		--keys.target:EmitSound("Hero_Oracle.FalsePromise.Healed")
	end
end



-- advanced_modifier
function modifier_item_hd_rumusque_vestments:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_rumusque_vestments:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification 
end








modifier_item_hd_rumusque_vestments_buff = advanced_modifier({})

function modifier_item_hd_rumusque_vestments_buff:IsHidden()	return false end
function modifier_item_hd_rumusque_vestments_buff:IsDebuff()	return false end
function modifier_item_hd_rumusque_vestments_buff:IsPurgable()	return false end
-- function modifier_item_hd_rumusque_vestments_buff:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
-- 	}

-- 	return funcs
-- end

-- function modifier_item_hd_rumusque_vestments_buff:GetModifierTotalDamageOutgoing_Percentage()	return 5*self:GetStackCount() end


-- advanced_modifier
function modifier_item_hd_rumusque_vestments_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_item_hd_rumusque_vestments_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self:GetStackCount()*5
end

function modifier_item_hd_rumusque_vestments_buff:DeclareFunctions()
    return 
    {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
		MODIFIER_PROPERTY_TOOLTIP
}
end

-- function modifier_item_hd_skeletology:GetModifierTotalDamageOutgoing_Percentage()	return self:GetStackCount()*2 end
function modifier_item_hd_rumusque_vestments_buff:OnTooltip()
	return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
end



function modifier_item_hd_rumusque_vestments_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_item_hd_rumusque_vestments_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= (8) then
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

function modifier_item_hd_rumusque_vestments_buff:OnIntervalThink()
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


