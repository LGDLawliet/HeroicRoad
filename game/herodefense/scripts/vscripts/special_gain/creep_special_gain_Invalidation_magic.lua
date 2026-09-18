creep_special_gain_Invalidation_magic = class({})
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_magic_arua", "skills/creep_special_gain_Invalidation_magic", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creep_special_gain_Invalidation_magic_arua_effect", "skills/creep_special_gain_Invalidation_magic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_magic", "special_gain/creep_special_gain_Invalidation_magic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Invalidation_magic_active", "special_gain/creep_special_gain_Invalidation_magic", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function creep_special_gain_Invalidation_magic:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Invalidation_magic"
end


modifier_creep_special_gain_Invalidation_magic = class({})




function modifier_creep_special_gain_Invalidation_magic:IsHidden() 
	return false
end
function modifier_creep_special_gain_Invalidation_magic:IsPurgable() return false end
function modifier_creep_special_gain_Invalidation_magic:IsDebuff() return false end
function modifier_creep_special_gain_Invalidation_magic:GetEffectName() return "particles/new_effect/new_effect/invalidation_magic.vpcf" end
function modifier_creep_special_gain_Invalidation_magic:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_Invalidation_magic:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_creep_special_gain_Invalidation_magic:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit==self:GetParent() then
			if keys.damage_category==1 then
				return
			end
			if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
				return 0
			end
			if not keys.attacker then
				return
			end
			if not keys.attacker:IsMagicImmune() then
				local health = keys.unit:GetMaxHealth()*0.03
				local index = keys.damage/health
				-- print(index)
				if index>=1 then
					index = index -index%1
					local ModifierStatusNegativeGain = keys.unit:GetModifierStatusNegativeGainIndex(1)
					local StatusResistance = keys.attacker:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
					local duration = 10*StatusResistance
					keys.attacker:AddNewModifier(keys.unit, self:GetAbility(), "modifier_creep_special_gain_Invalidation_magic_active", {duration = duration,stack_time = duration,stack = index})
				end
		
			
			end
		end
		
	end
end





modifier_creep_special_gain_Invalidation_magic_active = advanced_modifier({})

function modifier_creep_special_gain_Invalidation_magic_active:IsDebuff() return true end
function modifier_creep_special_gain_Invalidation_magic_active:IsHidden() return false end
function modifier_creep_special_gain_Invalidation_magic_active:IsPurgable() return true end
function modifier_creep_special_gain_Invalidation_magic_active:IsPurgeException() return true end
function modifier_creep_special_gain_Invalidation_magic_active:GetTexture() return "queen_of_pain/arcana/queenofpain_scream_of_pain_alt2" end
function modifier_creep_special_gain_Invalidation_magic_active:Advanced_GetModifierSpellAmplifyBonus()   return -self:GetStackCount() end
function modifier_creep_special_gain_Invalidation_magic_active:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
	end
end
function modifier_creep_special_gain_Invalidation_magic_active:OnRefresh(keys)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+keys.stack_time

		
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_creep_special_gain_Invalidation_magic_active:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end


function modifier_creep_special_gain_Invalidation_magic_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end


