
hd_ogre_tank_boss_jump_smash = class({})
LinkLuaModifier("modifier_hd_ogre_tank_melee_smash_thinker", "creeps_spell/hd_ogre_tank_boss_melee_smash", LUA_MODIFIER_MOTION_NONE)
-----------------------------------------------------------------------------

function hd_ogre_tank_boss_jump_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

-- function hd_ogre_tank_boss_jump_smash:GetPlaybackRateOverride()
-- 	return 0.9 -- keep this proportional to jump_speed
-- end
function hd_ogre_tank_boss_jump_smash:GetCooldown( iLevel )
	return self.BaseClass.GetCooldown( self, self:GetLevel() ) / self:GetCaster():GetHasteFactor() 
end

-----------------------------------------------------------------------------

function hd_ogre_tank_boss_jump_smash:GetPlaybackRateOverride()
	return math.min( 2.0, math.max( self:GetCaster():GetHasteFactor(), 1.0 ) )
end

-----------------------------------------------------------------------------

function hd_ogre_tank_boss_jump_smash:OnSpellStart()
	if IsServer() then
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_hd_ogre_tank_melee_smash_thinker", { duration = self:GetSpecialValueFor( "jump_speed") }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end


