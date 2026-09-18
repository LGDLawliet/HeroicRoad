creep_special_gain_Painful_last_wish = class({})
-- LinkLuaModifier("modifier_creep_special_gain_Painful_last_wish_arua", "skills/creep_special_gain_Painful_last_wish", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_Painful_last_wish_arua_effect", "skills/creep_special_gain_Painful_last_wish", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Painful_last_wish", "special_gain/creep_special_gain_Painful_last_wish", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Painful_last_wish_active", "special_gain/creep_special_gain_Painful_last_wish", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_Painful_last_wish:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Painful_last_wish"
end


modifier_creep_special_gain_Painful_last_wish = class({})




function modifier_creep_special_gain_Painful_last_wish:IsHidden() 
	return false
end
function modifier_creep_special_gain_Painful_last_wish:IsPurgable() return false end
function modifier_creep_special_gain_Painful_last_wish:IsDebuff() return false end
function modifier_creep_special_gain_Painful_last_wish:GetEffectName() return "particles/rebuild/painful_last_wish/debuff.vpcf" end
function modifier_creep_special_gain_Painful_last_wish:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_Painful_last_wish:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_creep_special_gain_Painful_last_wish:OnDeath(keys)
    if not IsServer() then
        return
    end

    if keys.unit == self:GetParent() then
		if not keys.attacker then
			return
		end
		if keys.attacker:IsMagicImmune() then
			return
		end
		local parent = self:GetParent()
		local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = keys.attacker:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		keys.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_creep_special_gain_Painful_last_wish_active", {duration = 60*StatusResistance})
		-- keys.attacker:EmitSound("Hero_Silencer.LastWord.Target")


    end
   
end




modifier_creep_special_gain_Painful_last_wish_active = advanced_modifier({})

function modifier_creep_special_gain_Painful_last_wish_active:IsDebuff() return true end
function modifier_creep_special_gain_Painful_last_wish_active:IsHidden() return false end
function modifier_creep_special_gain_Painful_last_wish_active:IsPurgable() return false end
function modifier_creep_special_gain_Painful_last_wish_active:IsPurgeException() return true end


function modifier_creep_special_gain_Painful_last_wish_active:OnCreated(params)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_creep_special_gain_Painful_last_wish_active:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime() })
		self:IncrementStackCount()
	end
end

function modifier_creep_special_gain_Painful_last_wish_active:OnIntervalThink()
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


function modifier_creep_special_gain_Painful_last_wish_active:Advanced_GetModifierIncomingDamage_Percentage() return self:GetStackCount()*5 end


function modifier_creep_special_gain_Painful_last_wish_active:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



