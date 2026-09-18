item_hd_book_of_death = class({})

LinkLuaModifier("modifier_item_hd_book_of_death", "items/item_hd_book_of_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_book_of_death_active", "items/item_hd_book_of_death", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_book_of_death:GetIntrinsicModifierName()
	return "modifier_item_hd_book_of_death"
end
function item_hd_book_of_death:IsSummonSpell()return true end


function item_hd_book_of_death:OnSpellStart()

	
	local caster =self:GetCaster()

	if not self.summon_table then
		self.summon_table = {}
	end
	for _, unit in ipairs(self.summon_table) do
		if IsValidEntity(unit) then
			-- unit:ForceKill(false)	
			unit:Kill(nil,nil)
		end
	end
	

	EmitSoundOn("Hero_ShadowDemon.Soul_Catcher.Cast", self:GetCaster())	
	

	
	local wolves_spawn_particle = nil
	self.summon_table = {}  --储存召唤物 用于在重复召唤时候移除它们


	local attribute = math.min(caster:GetHealth(),100000)+ math.min(caster:GetMana(),100000)
	-- caster:SetHealth(1)
	caster:ModifyHealth(1, self, false, 0)
	caster:SetMana(1)

	--召唤强度

	local life_duration = 100
	local heal = attribute
	local armor =attribute*0.003
	local damage = attribute*0.1
	
	local unit = caster:SummonUnit("npc_hd_embodiment_of_the_terror_blade",life_duration,
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


end


modifier_item_hd_book_of_death = advanced_modifier({})

function modifier_item_hd_book_of_death:IsDebuff() return false end
function modifier_item_hd_book_of_death:IsHidden() return true end
function modifier_item_hd_book_of_death:IsPurgable() return false end
function modifier_item_hd_book_of_death:IsPurgeException() return false end
function modifier_item_hd_book_of_death:RemoveOnDeath() return false end


function modifier_item_hd_book_of_death:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_summon_intensity =ability:GetSpecialValueFor("bonus_summon_intensity")
	self.bonus_int =ability:GetSpecialValueFor("bonus_int")
	self.bonus_str =ability:GetSpecialValueFor("bonus_str")
end




function modifier_item_hd_book_of_death:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,               --完整施法
		

	}
end


function modifier_item_hd_book_of_death:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_book_of_death:GetModifierBonusStats_Intellect()	return self.bonus_int end



function modifier_item_hd_book_of_death:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if unit:IsDemon() or unit:IsUndead() then
			
			unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_book_of_death_active", {})

		end
	end
end
-- advanced_modifier
function modifier_item_hd_book_of_death:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_book_of_death:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity 
end




modifier_item_hd_book_of_death_active = advanced_modifier({})

function modifier_item_hd_book_of_death_active:IsDebuff() return false end
function modifier_item_hd_book_of_death_active:IsHidden() return false end
function modifier_item_hd_book_of_death_active:IsPurgable() return false end
function modifier_item_hd_book_of_death_active:GetTexture() return "item_book_of_death" end
-- function modifier_item_hd_book_of_death_active:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   


-- 	}
-- end


-- function modifier_item_hd_book_of_death_active:GetModifierTotalDamageOutgoing_Percentage()	return 35 end


function modifier_item_hd_book_of_death_active:DeclareFunctions()
    return 
    {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
		MODIFIER_PROPERTY_TOOLTIP
}
end

-- function modifier_item_hd_skeletology:GetModifierTotalDamageOutgoing_Percentage()	return self:GetStackCount()*2 end
function modifier_item_hd_book_of_death_active:OnTooltip()
	return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
end

-- advanced_modifier
function modifier_item_hd_book_of_death_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_item_hd_book_of_death_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 35
end
