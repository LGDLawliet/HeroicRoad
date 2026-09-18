creeps_spell_Brain_worm_Brain_control = class({})

LinkLuaModifier("modifier_creeps_spell_Brain_worm_Brain_control", "creeps_spell/creeps_spell_Brain_worm_Brain_control", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Brain_worm_Brain_control:IsHiddenWhenStolen() 		return false end
function creeps_spell_Brain_worm_Brain_control:IsRefreshable() 			return true end
function creeps_spell_Brain_worm_Brain_control:IsStealable() 				return true end
function creeps_spell_Brain_worm_Brain_control:IsNetherWardStealable()		return true end
function creeps_spell_Brain_worm_Brain_control:GetIntrinsicModifierName() return "modifier_creeps_spell_Brain_worm_Brain_control" end



modifier_creeps_spell_Brain_worm_Brain_control = advanced_modifier({})

function modifier_creeps_spell_Brain_worm_Brain_control:IsDebuff()			return false end
function modifier_creeps_spell_Brain_worm_Brain_control:IsHidden() 			return true end
function modifier_creeps_spell_Brain_worm_Brain_control:IsPurgable() 		    return false end
function modifier_creeps_spell_Brain_worm_Brain_control:IsPurgeException() 	return false end
function modifier_creeps_spell_Brain_worm_Brain_control:RemoveOnDeath()       return false end
function modifier_creeps_spell_Brain_worm_Brain_control:GetEffectName() return "particles/npc_ambent/monster001/monster_drop.vpcf" end
function modifier_creeps_spell_Brain_worm_Brain_control:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



-- function modifier_creeps_spell_Brain_worm_Brain_control:OnIntervalThink()
--     if IsServer() then
-- 		local parent = self:GetParent()
-- 		if not parent:IsAlive() then
-- 			return
-- 		end
--         parent:SetSkin(2)

        
--     end
-- end




function modifier_creeps_spell_Brain_worm_Brain_control:Advanced_GetModifierIncomingDamage_Percentage()	
	if IsClient() then
		return 0
	end
	if _G.GAME_DIFFICULTY<4 then
		return
	end
	local chance = 20
	local parent = self:GetParent()
	chance = (100-parent:GetHealthPercent())*0.6+chance

	if parent:PassivesDisabled() then
		chance = chance*0.5
	end
	if chance>=RandomInt(1, 100) then
		return -1000
	end

	return 0
end




function modifier_creeps_spell_Brain_worm_Brain_control:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_creeps_spell_Brain_worm_Brain_control:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if _G.GAME_DIFFICULTY<4 then
		return
	end
	local chance = 20
	local parent = self:GetParent()
	chance = (100-parent:GetHealthPercent())*0.6+chance
	if parent:PassivesDisabled() then
		chance = chance*0.5
	end
	if chance>=RandomInt(1, 100) then
		return 50
	end

	return 0
end


