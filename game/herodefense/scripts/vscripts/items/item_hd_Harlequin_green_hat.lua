item_hd_Harlequin_green_hat = class({})

LinkLuaModifier("modifier_item_hd_Harlequin_green_hat", "items/item_hd_Harlequin_green_hat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Harlequin_green_hat_active", "items/item_hd_Harlequin_green_hat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Harlequin_green_hat_active2", "items/item_hd_Harlequin_green_hat", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_Harlequin_green_hat:GetIntrinsicModifierName()
	return "modifier_item_hd_Harlequin_green_hat"
end


modifier_item_hd_Harlequin_green_hat = class({})

function modifier_item_hd_Harlequin_green_hat:IsDebuff() return false end
function modifier_item_hd_Harlequin_green_hat:IsHidden() return true end
function modifier_item_hd_Harlequin_green_hat:IsPurgable() return false end
function modifier_item_hd_Harlequin_green_hat:IsPurgeException()return false end
function modifier_item_hd_Harlequin_green_hat:RemoveOnDeath() return false end
function modifier_item_hd_Harlequin_green_hat:OnCreated(keys)
    local ability = self:GetAbility()


	self.bonus_str = ability:GetSpecialValueFor("bonus_str")

	self.bonus_health =ability:GetSpecialValueFor("bonus_health")
	

    if IsServer() then
		self.timer = GameRules:GetGameTime()
	end
end



function modifier_item_hd_Harlequin_green_hat:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	}
end


function modifier_item_hd_Harlequin_green_hat:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_Harlequin_green_hat:GetModifierHealthBonus()	return self.bonus_health end

function modifier_item_hd_Harlequin_green_hat:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit


		if unit~=self:GetParent() then	return end

		if keys.damage<=10 then return	end
		if unit:GetTeamNumber()~=attacker:GetTeamNumber() then
			return
		end
		if unit==attacker then
			return
		end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

		local damage = keys.damage *0.5
		unit:AddNewModifier(unit, self:GetAbility(), "modifier_item_hd_Harlequin_green_hat_active", {duration = 5.5,stack = damage})
		if GameRules:GetGameTime()>=self.timer then
			self.timer = GameRules:GetGameTime()+0.2
			unit:AddNewModifier(unit, self:GetAbility(), "modifier_item_hd_Harlequin_green_hat_active2", {duration = 20*unit:GetModifierDurationGainIndex(1),stack = 3})
		end

    end 
end









modifier_item_hd_Harlequin_green_hat_active = class({})

function modifier_item_hd_Harlequin_green_hat_active:IsHidden()	return false end
function modifier_item_hd_Harlequin_green_hat_active:IsDebuff()	return false end
function modifier_item_hd_Harlequin_green_hat_active:IsPurgable()	return false end
function modifier_item_hd_Harlequin_green_hat_active:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack = params.stack })
		self:SetStackCount( params.stack )
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_Harlequin_green_hat_active:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime ,stack = params.stack})
		self:SetStackCount(self:GetStackCount()+ params.stack )
	end
end

function modifier_item_hd_Harlequin_green_hat_active:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		local heal = 0
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()- self.tData[i].stack )
				heal = heal + self.tData[i].stack
				table.remove(self.tData, i)
				
			end
		end


		if heal>0 then
			local parent = self:GetParent()
			local healing = HealWithGain(heal,parent,parent,self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
		end

	end
end







modifier_item_hd_Harlequin_green_hat_active2 = class({})

function modifier_item_hd_Harlequin_green_hat_active2:IsHidden()	return false end
function modifier_item_hd_Harlequin_green_hat_active2:IsDebuff()	return false end
function modifier_item_hd_Harlequin_green_hat_active2:IsPurgable()	return false end
function modifier_item_hd_Harlequin_green_hat_active2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
	}
end
function modifier_item_hd_Harlequin_green_hat_active2:GetModifierBonusStats_Strength()	return math.min(self:GetStackCount(),100) end
function modifier_item_hd_Harlequin_green_hat_active2:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack = params.stack })
		self:SetStackCount( params.stack )
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_Harlequin_green_hat_active2:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime ,stack = params.stack})
		self:SetStackCount(self:GetStackCount()+ params.stack )
	end
end

function modifier_item_hd_Harlequin_green_hat_active2:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		local heal = 0
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()- self.tData[i].stack )
				heal = heal + self.tData[i].stack
				table.remove(self.tData, i)
				
			end
		end
	end
end

