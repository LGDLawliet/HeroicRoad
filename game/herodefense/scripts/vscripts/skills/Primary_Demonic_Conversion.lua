
Primary_Demonic_Conversion = class({})

LinkLuaModifier("modifier_Primary_Demonic_Conversion_attack_count", "skills/Primary_Demonic_Conversion", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Primary_Demonic_Conversion_debuff", "skills/Primary_Demonic_Conversion", LUA_MODIFIER_MOTION_NONE)
function Primary_Demonic_Conversion:Precache(context)
	PrecacheResource("model", "models/heroes/enigma/eidelon.vmdl", context)
end
function Primary_Demonic_Conversion:IsHiddenWhenStolen() 	return false end
function Primary_Demonic_Conversion:IsRefreshable() 		return false  end
function Primary_Demonic_Conversion:IsStealable() 			return true  end
function Primary_Demonic_Conversion:IsNetherWardStealable() return false end
function Primary_Demonic_Conversion:IsSummonSpell()return true end
	
function Primary_Demonic_Conversion:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not target:IsHero() then
		return
	end

	local life_duration = self:GetSpecialValueFor("duration")
	local heal = (self:GetSpecialValueFor("basic_heal") + self:GetSpecialValueFor("bonus_attribute_percentage")*0.01 * target:GetMaxHealth())
	local armor = (self:GetSpecialValueFor("bonus_attribute_percentage")*0.01 * target:GetPhysicalArmorValue(false))
	local damage = (self:GetSpecialValueFor("basic_damage") + self:GetSpecialValueFor("bonus_attribute_percentage")*0.01 * target:GetBaseDamageMax())
	local mana = (self:GetSpecialValueFor("bonus_attribute_percentage")*0.01 * target:GetMaxMana())
	target:EmitSound("Hero_Enigma.Demonic_Conversion")
	local str = self:GetSpecialValueFor("allied_attribute_loss") * target:GetStrength() *0.01
	local agi = self:GetSpecialValueFor("allied_attribute_loss") * target:GetAgility()*0.01
	local int = self:GetSpecialValueFor("allied_attribute_loss") * target:GetIntellect(false)*0.01

	target:AddNewModifier(caster, self, "modifier_Primary_Demonic_Conversion_debuff", 
	{duration = self:GetSpecialValueFor("allied_recovery_time"),str=str,agi=agi,int=int})
	for i=1,self:GetSpecialValueFor("summon_number") do
		local unit = caster:SummonUnit("npc_eidolon",life_duration, target:GetAbsOrigin(),nil,self,0,heal,mana,damage,armor,0.5,0.5)
		
		unit:AddNewModifier(caster, self, "modifier_Primary_Demonic_Conversion_attack_count",
		 {duration=life_duration*caster:GetSummonTimeAmpIndex(1),damage = damage,heal = heal, armor = armor, mana = mana})

	end

	-- local unit = CreateUnitByName("npc_monster_challenge_002", target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	-- unit:SetControllableByPlayer(caster:GetPlayerID(), false)
end

modifier_Primary_Demonic_Conversion_attack_count = class({})

function modifier_Primary_Demonic_Conversion_attack_count:IsDebuff()			return false end
function modifier_Primary_Demonic_Conversion_attack_count:IsHidden() 			return true end
function modifier_Primary_Demonic_Conversion_attack_count:IsPurgable() 		return false end
function modifier_Primary_Demonic_Conversion_attack_count:IsPurgeException() 	return false end

function modifier_Primary_Demonic_Conversion_attack_count:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK} end

function modifier_Primary_Demonic_Conversion_attack_count:OnCreated(keys)
	if IsServer() then
		self.damage = keys.damage
		self.armor = keys.armor
		self.mana = keys.mana
		self.heal = keys.heal
	end

end

function modifier_Primary_Demonic_Conversion_attack_count:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then
		return
	end
	self:IncrementStackCount()

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

	local caster = self:GetCaster()
	if self:GetStackCount() % ability:GetSpecialValueFor("attacks_to_split") == 0 then
		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		local time = ability:GetSpecialValueFor("child_duration") + self:GetRemainingTime()
		local unit = caster:SummonUnit("npc_eidolon",time,keys.attacker:GetAbsOrigin(),nil,self:GetAbility(),0,self.heal,self.mana,self.damage,self.armor,1,1)



		if self:GetStackCount() >= ability:GetSpecialValueFor("attacks_to_split")*ability:GetSpecialValueFor("split_chance")then
			self:SafeDestroy()
		end
	end
end




modifier_Primary_Demonic_Conversion_debuff = class({})

function modifier_Primary_Demonic_Conversion_debuff:IsDebuff()			    return true end
function modifier_Primary_Demonic_Conversion_debuff:IsHidden() 			return false end
function modifier_Primary_Demonic_Conversion_debuff:IsPurgable() 			return false end
function modifier_Primary_Demonic_Conversion_debuff:IsPurgeException() 	return false end
function modifier_Primary_Demonic_Conversion_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_Demonic_Conversion_debuff:OnCreated(keys)
	if IsServer() then
		self.agi = keys.agi
		self.str = keys.str
		self.int = keys.int
	end
end

function modifier_Primary_Demonic_Conversion_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

 

function modifier_Primary_Demonic_Conversion_debuff:GetModifierBonusStats_Agility() 
	if self.agi ~= 0 then
		return (-self.agi) 
	else
	return 0 end end
function modifier_Primary_Demonic_Conversion_debuff:GetModifierBonusStats_Intellect() 
	if self.int ~= 0 then
		return (-self.int)
	else
	return 0 end end
function modifier_Primary_Demonic_Conversion_debuff:GetModifierBonusStats_Strength() 
	if self.str ~= 0 then
		return (-self.str)
	else
	return 0 end end
	
