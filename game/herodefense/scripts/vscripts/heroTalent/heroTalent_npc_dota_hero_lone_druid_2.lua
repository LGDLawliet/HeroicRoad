heroTalent_npc_dota_hero_lone_druid_2 = class({})



function heroTalent_npc_dota_hero_lone_druid_2:CastFilterResultTarget( target )
	if IsServer() then
		-- if not target:IsRealHero() then
		-- 	return UF_FAIL_CUSTOM
		-- end
		if target==self:GetCaster() then
			if self:GetCaster():GetGold()<self:GetSpecialValueFor("gold_cost") then
				self._error = "#dota_hud_greevils_not_enough_gold"
				return UF_FAIL_CUSTOM
			end
		else
			if self:GetCaster():GetGold()<self:GetSpecialValueFor("gold_cost_other") then
				self._error = "#dota_hud_greevils_not_enough_gold"
				return UF_FAIL_CUSTOM
			end
		end
		
		return UF_SUCCESS
	end
	
end
function heroTalent_npc_dota_hero_lone_druid_2:GetCustomCastErrorTarget( target )
	-- check nohammer
	if IsServer() then
	    return self._error
	end

end

function heroTalent_npc_dota_hero_lone_druid_2:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local cost = self:GetSpecialValueFor("gold_cost_other")
	if caster==target then
		cost = self:GetSpecialValueFor("gold_cost")
	end
	caster:ModifyGoldFiltered(-cost,true,DOTA_ModifyGold_PurchaseItem  )
	target:HeroLevelUp(true)

end

