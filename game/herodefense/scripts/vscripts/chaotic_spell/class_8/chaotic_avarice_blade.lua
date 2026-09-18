LinkLuaModifier("modifier_chaotic_avarice_blade", "chaotic_spell/class_8/chaotic_avarice_blade", LUA_MODIFIER_MOTION_NONE)

chaotic_avarice_blade = chaotic_avarice_blade or class({})

function chaotic_avarice_blade:GetIntrinsicModifierName()
	return "modifier_chaotic_avarice_blade" 
end

function chaotic_avarice_blade:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_avarice_blade/eff_attacker.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_avarice_blade/eff_unit/flopjaw_death_gold.vpcf", context )
end

modifier_chaotic_avarice_blade = advanced_modifier({})

function modifier_chaotic_avarice_blade:IsPurgable() 		return false end
function modifier_chaotic_avarice_blade:IsPurgeException() 	return false end
function modifier_chaotic_avarice_blade:IsHidden() return self:GetStackCount()<=0 end

function modifier_chaotic_avarice_blade:OnCreated()

	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.gold_cost = self.ability:GetSpecialValueFor("gold_cost")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_gold = self.ability:GetSpecialValueFor("bonus_gold")

	self.rune_1_bonus = self.ability:GetSpecialValueFor("rune_1_bonus")
	self.rune_1_line = self.ability:GetSpecialValueFor("rune_1_line")
	
	if IsServer() then
		self.record = {}

		self.grow_record = 0
		self.grow_require = self.ability:GetSpecialValueFor("require")
		self.grow_bonus = self.ability:GetSpecialValueFor("bonus")
	end
end


function modifier_chaotic_avarice_blade:AttackerEffect(unit)

	if not IsServer() then
		return
	end
	local pos = unit:GetAbsOrigin()
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_avarice_blade/eff_attacker.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControlEnt(effect_cast,0,unit,PATTACH_POINT_FOLLOW,nil,pos,true)
	ParticleManager:SetParticleControlEnt(effect_cast,1,unit,PATTACH_POINT_FOLLOW,nil,pos,true)
	ParticleManager:SetParticleControlEnt(effect_cast,2,unit,PATTACH_POINT_FOLLOW,nil,pos,true)
	ParticleManager:SetParticleControlEnt(effect_cast,4,unit,PATTACH_POINT_FOLLOW,nil,pos,true)
	ParticleManager:ReleaseParticleIndex(effect_cast)
	unit:EmitSound("Hero_Alchemist.BerserkPotion.Target")

end

function modifier_chaotic_avarice_blade:UnitEffect(unit)

	if not IsServer() then
		return
	end
	local pos = unit:GetAbsOrigin()
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_avarice_blade/eff_unit/flopjaw_death_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControlEnt(effect_cast,0,unit,PATTACH_POINT_FOLLOW,nil,pos,true)
	DestroyParticleByDelay(effect_cast,1)

end

function modifier_chaotic_avarice_blade:ADDeclareFunctions()
	local funcs =  {
		advanced_MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(), nil},
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end
    return funcs
   
end

function modifier_chaotic_avarice_blade:Advanced_GetModifierProcAttack_BonusDamage_Physical(keys)

	if not IsServer() then
		return 0
	end
	if self.parent:PassivesDisabled() then
		return 0
	end
	if not self.ability:GetAutoCastState() then
		return 0
	end
	local gold_cost =self.gold_cost
	if self.parent:GetGold() >= gold_cost then
		keys.attacker:ModifyGoldFiltered(-gold_cost,true,DOTA_ModifyGold_AbilityCost)
		if self.grow_record then
			self.grow_record = self.grow_record + gold_cost
			if self.grow_record>=self.grow_require then
				self.grow_record = self.grow_record - self.grow_require
				self:SetStackCount(self:GetStackCount()+self.grow_bonus)
			end
	
		end
		self.record[keys.record] = true
		self:AttackerEffect(keys.attacker)
		return  self.bonus_damage* self.parent:GetAverageTrueAttackDamage(nil)
	end


	return 0
end

function modifier_chaotic_avarice_blade:OnDeath(keys)
	if IsServer() then

		local unit = keys.unit
		local attacker = keys.attacker
		
		if IsEnemy(unit,attacker) then
			if attacker:PassivesDisabled() then
				return
			end
			if not self.ability:GetAutoCastState() then
				return
			end		
			if self.record[keys.record]  then
				local nPlayerID = attacker:GetPlayerOwnerID()
				local bonus = self.bonus_gold
				self:UnitEffect(unit)
				
				chaotic_era_spawner:PlayerGetGoldBounty(attacker,bonus,self.ability) 
				SendOverheadEventMessage( PlayerResource:GetPlayer(nPlayerID), OVERHEAD_ALERT_GOLD ,attacker, bonus, nil)
			end

		end
	end
end

function modifier_chaotic_avarice_blade:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if not IsServer() then return end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
	local gold = math.floor(self:GetParent():GetGold()/self.rune_1_line)
	return gold*self.rune_1_bonus
end

function modifier_chaotic_avarice_blade:OnAttackRecordDestroy(keys)
	if self.record[keys.record] then
        self.record[keys.record] = nil
    end
end

function modifier_chaotic_avarice_blade:Advanced_GetModifierPreAttack_BonusDamage(keys)
	return self:GetStackCount()
end



function modifier_chaotic_avarice_blade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_chaotic_avarice_blade:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPreAttack_BonusDamage()
	end
end
