

modifier_chaotic_era_attribute = advanced_modifier({})

function modifier_chaotic_era_attribute:IsDebuff() return false end
function modifier_chaotic_era_attribute:IsHidden() return false end
function modifier_chaotic_era_attribute:IsPurgable() return false end
-- function modifier_chaotic_era_attribute:RemoveOnDeath() return false end
function modifier_chaotic_era_attribute:GetTexture() return "alchemist_goblins_greed" end
function modifier_chaotic_era_attribute:OnCreated(keys)
    if IsServer() then
		-- print("keys.bounty",keys.bounty)
		self:SetStackCount(math.floor(keys.bounty))
        self.bonus_damage = keys.attackDamage
       
        IncreaseHealth(self:GetParent(),keys.health)
        self:SetHasCustomTransmitterData( true )
    end

end
function modifier_chaotic_era_attribute:OnDestroy()
	if IsServer() then
		local gold_index = {
			1.5,1.5,1.5,1.5,1.5
		}
		local heroes = GetAllRealHeroes()
        for  _, hero in pairs(heroes) do
            if hero:IsRealHero() and hero:IsOwnedByAnyPlayer() then
				local bonus = self:GetStackCount()
				if #heroes then
					bonus = math.floor(self:GetStackCount()*gold_index[#heroes])
				end
				
	
				chaotic_era_spawner:PlayerGetGoldBounty(hero,bonus,nil)
				-- SendOverheadEventMessage(hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD  ,hero, bonus, nil)
            end
        end
	end

end
function modifier_chaotic_era_attribute:AddCustomTransmitterData( )
	return
	{
		bonus_damage = self.bonus_damage
	}
end

function modifier_chaotic_era_attribute:HandleCustomTransmitterData( data )
	self.bonus_damage = data.bonus_damage
end
function modifier_chaotic_era_attribute:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,           --攻击力


	}
end



function modifier_chaotic_era_attribute:GetModifierBaseAttack_BonusDamage()	
    return self.bonus_damage
end