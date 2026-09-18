


item_hd_star_mace = class({})

--------------------------------------------------------------------------------

-- function item_hd_star_mace:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_star_mace:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		local caster = self:GetCaster()
		caster:EmitSoundParams( "Miniboss_Greevil.Attack", 0, 0.5, 0 )
		-- local target = self:GetCursorTarget()

		local heal = (500+caster:GetMaxHealth()*0.25)
		local healing =  HealWithGain(heal,caster,caster,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)

		self:SpendCharge(0)
	end
end



item_hd_star_mace_2 = class({})

--------------------------------------------------------------------------------

-- function item_hd_star_mace:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_star_mace_2:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		local caster = self:GetCaster()
		caster:EmitSoundParams( "Miniboss_Greevil.Attack", 0, 0.5, 0 )
		-- local target = self:GetCursorTarget()

		local heal = (500+caster:GetMaxHealth()*0.25)
		local healing =  HealWithGain(heal,caster,caster,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healing, nil)

		self:SpendCharge(0)
	end
end
