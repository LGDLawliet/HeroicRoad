
--------------------------------------------------------------------------------
modifier_wolf_power = advanced_modifier({})
require('internal/timers')   --计时器功能
--------------------------------------------------------------------------------
-- Classifications
function modifier_wolf_power:IsHidden()return false end
function modifier_wolf_power:IsDebuff()return false end
function modifier_wolf_power:IsStunDebuff()return false end
function modifier_wolf_power:IsPurgable()return false end
function modifier_wolf_power:GetTexture() return "lycan/ti9_immortal_head/lycan_howl_immortal" end
function modifier_wolf_power:IsPurgeException() 	return false end
function modifier_wolf_power:RemoveOnDeath() return false end

function modifier_wolf_power:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
			--额外移速
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

	}
end

-- function modifier_wolf_power:GetModifierTotalDamageOutgoing_Percentage()	return (_G.GAME_DIFFICULTY+_G.GAME_CHANLLENGE_DIFFICULTY*1.5 )*4 end

function modifier_wolf_power:GetModifierBonusStats_Strength()	return 15 end
function modifier_wolf_power:GetModifierBonusStats_Intellect()	return 15 end
function modifier_wolf_power:GetModifierBonusStats_Agility()	return 15 end
function modifier_wolf_power:Advanced_GetModifierSpellAmplifyBonus()   return 20 end
function modifier_wolf_power:GetModifierMagicalResistanceBonus() return 15 end
function modifier_wolf_power:GetModifierMoveSpeedBonus_Constant() return 100 end



-- advanced_modifier
function modifier_wolf_power:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_SPECIAL_Reincarnate = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_wolf_power:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	local index = _G.GAME_DIFFICULTY or 0
	local index2 = GetChallengeDifficulty() or 0
    return (index+index2*1.5 )*4
end

function modifier_wolf_power:Advanced_GetModifierIncomingDamage_Percentage()
	if Game_State~=nil and Game_State:IsInChaoticEra() then
		return -20
	end
	return 0
end
function modifier_wolf_power:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
	if Game_State~=nil and Game_State:IsInChaoticEra() then
		return 20
	end
	return 0
end



function modifier_wolf_power:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(3)
		-- self.re_trigger = false
		self.triggerTime = 3
		self.count = 0
		self:StartIntervalThink(8)
	end
end
function modifier_wolf_power:OnWaveStart()
	if self:GetStackCount()<=0 and _G.GAME_CHANLLENGE_Contest_Type>=1 then
		self.count = self.count + 1
		if self.count>=2 then
			self.count = 0
			self:SetStackCount(1)
		end
		
	end
end

function modifier_wolf_power:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	parent:Purge(false, true, false, false,true) --强驱散
end




function modifier_wolf_power:AdvancedGetModifierReincarnate(keys)
	if self:GetStackCount()>=1 then
		local data = {
			modifier = self,
			time = 2,
			priority = 1,
			invulnerable_time = 2,
			
	
		}
		return data
	end

	return nil
	
end

function modifier_wolf_power:OnReincarnateTrigger(keys)
	self:DecrementStackCount()
	self.triggerTime = self.triggerTime - 1
	if self.triggerTime<0 then
		_G.GAME_pre_exDieTime = _G.GAME_pre_exDieTime + 1
		-- print("惩罚+1")
	end
end
