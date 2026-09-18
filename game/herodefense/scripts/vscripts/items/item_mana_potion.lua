
item_mana_potion = class({})

--------------------------------------------------------------------------------

function item_mana_potion:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end


--------------------------------------------------------------------------------

function item_mana_potion:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )

		local nTeamNumber = self:GetCaster():GetTeamNumber()
		self:GetCaster():GiveMana( 50 )
		for i=0, self:GetCaster():GetAbilityCount() - 1 do
			local Ability = self:GetCaster():GetAbilityByIndex(i)
			if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self  and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
				local newCooldown = Ability:GetCooldownTimeRemaining() - 1
				Ability:EndCooldown()
				Ability:StartCooldown(newCooldown)
			end
		end
				
		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		
		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------
