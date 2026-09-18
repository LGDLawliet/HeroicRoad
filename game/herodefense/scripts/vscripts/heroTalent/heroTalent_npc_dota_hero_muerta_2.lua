heroTalent_npc_dota_hero_muerta_2 = heroTalent_npc_dota_hero_muerta_2 or class ({})



function heroTalent_npc_dota_hero_muerta_2:GetCustomCastError()
	return "#DOTA_HUB_CANT_CAST_NO_pierce_the_veil"
end

function heroTalent_npc_dota_hero_muerta_2:CastFilterResult()
	if IsServer() then
		-- local caster = self:GetCaster()
		if not self:Getpierce_the_veil() then
			return UF_FAIL_CUSTOM 
		end
		return UF_SUCCESS
	end
end

function heroTalent_npc_dota_hero_muerta_2:Getpierce_the_veil()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_pierce_the_veil")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_pierce_the_veil")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_pierce_the_veil")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_pierce_the_veil")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_pierce_the_veil")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_pierce_the_veil")
				end
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end



function heroTalent_npc_dota_hero_muerta_2:OnSpellStart()
	local ability = self:Getpierce_the_veil()
	if ability then
		ability:OnSpellStart(true)
	end
end

function heroTalent_npc_dota_hero_muerta_2:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 750,
					to_level2_cost = 1500,
					to_level3_cost = 2200,
					upgrade_cost = 750,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"pierce_the_veil",costKeys)
			end
		end)
	
	end

end


