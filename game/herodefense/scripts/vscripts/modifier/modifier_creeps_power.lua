
LinkLuaModifier("modifier_creeps_spell_Wave33_rage", "modifier/modifier_creeps_power", LUA_MODIFIER_MOTION_NONE) --狂暴


--------------------------------------------------------------------------------
modifier_creeps_power = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_power:IsHidden()return false end
function modifier_creeps_power:IsDebuff()return false end
function modifier_creeps_power:IsStunDebuff()return false end
function modifier_creeps_power:IsPurgable()return false end
function modifier_creeps_power:GetTexture() return "black_dragon_dragonhide_aura" end
function modifier_creeps_power:IsPurgeException() 	return false end
function modifier_creeps_power:RemoveOnDeath() return false end
function modifier_creeps_power:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end
function modifier_creeps_power:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
		

	}
end
function modifier_creeps_power:OnCreated()
	if IsServer() then
		self:StartIntervalThink(5)
	end
end


function modifier_creeps_power:GetModifierAttackSpeedBonus_Constant()	return self:GetStackCount()>=50 and self:GetStackCount()*2-100 end
function modifier_creeps_power:GetModifierMoveSpeedBonus_Constant()	return self:GetStackCount()*5 end
function modifier_creeps_power:GetModifierIgnoreMovespeedLimit() return self:GetStackCount()>=50 and 1 or 0 end


function modifier_creeps_power:OnIntervalThink()

	self:IncrementStackCount()
	
	if self:GetStackCount()==15 and _G.GAME_ENDLESS_WAVE_COUNT>=1 then
		local parent = self:GetParent()
		local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", parent), PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx1, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx1, 3, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx1)
		parent:EmitSound("Hero_OgreMagi.Bloodlust.Cast")
		parent:EmitSound("Hero_OgreMagi.Bloodlust.Target")
		parent:AddNewModifier(parent, nil, "modifier_creeps_spell_Wave33_rage", {})  --野怪狂暴
	end
end














modifier_creeps_spell_Wave33_rage = advanced_modifier({})

function modifier_creeps_spell_Wave33_rage:IsDebuff() return false end
function modifier_creeps_spell_Wave33_rage:IsHidden() return true end
function modifier_creeps_spell_Wave33_rage:IsPurgable() return false end
function modifier_creeps_spell_Wave33_rage:IsPurgeException() return false end
function modifier_creeps_spell_Wave33_rage:RemoveOnDeath() return false end
function modifier_creeps_spell_Wave33_rage:GetStatusEffectName() return "particles/new_effect/status/new_status_effect_soul_18.vpcf" end
function modifier_creeps_spell_Wave33_rage:StatusEffectPriority() return 10000 end
function modifier_creeps_spell_Wave33_rage:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

function modifier_creeps_spell_Wave33_rage:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成

		

	}
end

function modifier_creeps_spell_Wave33_rage:GetModifierModelScale() 
    return 50
end

-- function modifier_creeps_spell_Wave33_rage:GetModifierTotalDamageOutgoing_Percentage() 
--     return 50
-- end

-- advanced_modifier
function modifier_creeps_spell_Wave33_rage:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_creeps_spell_Wave33_rage:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return 50
end


function modifier_creeps_spell_Wave33_rage:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FEARED] = false,
		[MODIFIER_STATE_TAUNTED] = false,
		[MODIFIER_STATE_DISARMED] = false,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}


	return state
end
