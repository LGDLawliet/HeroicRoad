
LinkLuaModifier( "modifier_Primary_summon_Dave_Chisnall_debuff", "skills/Primary_summon_Dave_Chisnall", LUA_MODIFIER_MOTION_NONE )
Primary_summon_Dave_Chisnall						= Primary_summon_Dave_Chisnall or class({})

function Primary_summon_Dave_Chisnall:IsSummonSpell()return true end

function Primary_summon_Dave_Chisnall:OnSpellStart()

	
	local caster =self:GetCaster()

	if not self.summon_table then
		self.summon_table = {}
	end
	for _, unit in ipairs(self.summon_table) do
		if IsValidEntity(unit) then
			unit:ForceKill(false)	
		end
	end
	

	EmitSoundOn("Hero_ShadowDemon.Soul_Catcher.Cast", self:GetCaster())	
	

	
	local wolves_spawn_particle = nil
	self.summon_table = {}  --储存召唤物 用于在重复召唤时候移除它们

	local str = self:GetSpecialValueFor("allied_attribute_loss") * caster:GetStrength() *0.01
	local agi = self:GetSpecialValueFor("allied_attribute_loss") * caster:GetAgility()*0.01
	local int = self:GetSpecialValueFor("allied_attribute_loss") * caster:GetIntellect(false)*0.01




	--召唤强度

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	
	local unit = caster:SummonUnit("npc_hd_Dave_Chisnall",life_duration,
	self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) + (self:GetCaster():GetRightVector() * 120  ),
	self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)


	table.insert(self.summon_table,unit)
	
	-- Add spawn particles in spawn location
	wolves_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:ReleaseParticleIndex(wolves_spawn_particle)


	-- Add cast particles
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_soulchain_proc_rope.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	local pos = self:GetCaster():GetAbsOrigin()
	local pos2 = unit:GetAbsOrigin()
	pos.z = pos.z +64
	pos2.z = pos2.z +64
	
	ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, pos2)
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	caster:AddNewModifier(caster, self, "modifier_Primary_summon_Dave_Chisnall_debuff", 
	{duration = self:GetSpecialValueFor("debuff_duration"),str=str,agi=agi,int=int})

end





modifier_Primary_summon_Dave_Chisnall_debuff = class({})

function modifier_Primary_summon_Dave_Chisnall_debuff:IsDebuff()			    return true end
function modifier_Primary_summon_Dave_Chisnall_debuff:IsHidden() 			return false end
function modifier_Primary_summon_Dave_Chisnall_debuff:IsPurgable() 			return false end
function modifier_Primary_summon_Dave_Chisnall_debuff:IsPurgeException() 	return false end
function modifier_Primary_summon_Dave_Chisnall_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_summon_Dave_Chisnall_debuff:OnCreated(keys)
	if IsServer() then
		self.agi = keys.agi
		self.str = keys.str
		self.int = keys.int
	end
end

function modifier_Primary_summon_Dave_Chisnall_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

 

function modifier_Primary_summon_Dave_Chisnall_debuff:GetModifierBonusStats_Agility() 
	if self.agi ~= 0 then
		return (-self.agi) 
	else
	return 0 end end
function modifier_Primary_summon_Dave_Chisnall_debuff:GetModifierBonusStats_Intellect() 
	if self.int ~= 0 then
		return (-self.int)
	else
	return 0 end end
function modifier_Primary_summon_Dave_Chisnall_debuff:GetModifierBonusStats_Strength() 
	if self.str ~= 0 then
		return (-self.str)
	else
	return 0 end end
	
