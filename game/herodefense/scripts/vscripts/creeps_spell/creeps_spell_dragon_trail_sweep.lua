creeps_spell_dragon_trail_sweep = class({})

------------------------------------------------------------------

function creeps_spell_dragon_trail_sweep:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Winter_Wyvern.ArcticBurn.Cast", self:GetCaster() )

	end
end








