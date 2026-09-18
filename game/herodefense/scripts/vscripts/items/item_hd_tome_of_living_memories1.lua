item_hd_tome_of_living_memories1 = class({})

LinkLuaModifier("modifier_item_hd_tome_of_living_memories1", "items/item_hd_tome_of_living_memories1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_tome_of_living_memories1_active", "items/item_hd_tome_of_living_memories1", LUA_MODIFIER_MOTION_NONE)


function item_hd_tome_of_living_memories1:GetIntrinsicModifierName()
	return "modifier_item_hd_tome_of_living_memories1"
end



function item_hd_tome_of_living_memories1:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_soul_assumption_bolt1.vpcf", context )

end






-- function item_hd_tome_of_living_memories1:InsertSummon(unit)
-- 	if not self.summon_table then
-- 		self.summon_table = {}
-- 	end
-- 	self.summon_table[unit] = true
-- end

-- function item_hd_tome_of_living_memories1:RemoveSummon(unit)
-- 	self.summon_table[unit] = nil
-- end
-- function item_hd_tome_of_living_memories1:GetSummonList()
-- 	if not self.summon_table then
-- 		self.summon_table = {}
-- 	end
-- 	return self.summon_table
-- end

-- function item_hd_tome_of_living_memories1:OnProjectileHit(target, location)
-- 	if not target then
-- 		return
-- 	end
-- 	-- if keys.hit == 1 and target:TriggerStandardTargetSpell(self) then
-- 	-- 	return true
-- 	-- end
-- 	target:EmitSound("Hero_Visage.SoulAssumption.Target")
-- 	local modifier = target:FindModifierByName("modifier_item_hd_tome_of_living_memories1_active")
-- 	if modifier then
-- 		modifier:AddStack()
-- 	end

-- end







modifier_item_hd_tome_of_living_memories1 = advanced_modifier({})

function modifier_item_hd_tome_of_living_memories1:IsDebuff() return false end
function modifier_item_hd_tome_of_living_memories1:IsHidden() return true end
function modifier_item_hd_tome_of_living_memories1:IsPurgable() return false end
function modifier_item_hd_tome_of_living_memories1:IsPurgeException() return false end
function modifier_item_hd_tome_of_living_memories1:RemoveOnDeath() return false end


function modifier_item_hd_tome_of_living_memories1:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()

	self.bonus_health =ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor =ability:GetSpecialValueFor("bonus_armor")

	self.bonus_summon_intensity = ability:GetSpecialValueFor("summon_intensity")
	self.bonus_summon_time = ability:GetSpecialValueFor("summon_time_intensity")
	

    if IsServer() then
		self:StartIntervalThink(1)
	end

end
function modifier_item_hd_tome_of_living_memories1:OnIntervalThink()
	self:StartIntervalThink(-1)
	self:CheckIteam()
end
function modifier_item_hd_tome_of_living_memories1:CheckIteam()
	local caster    =   self:GetParent()
	local kraken_shell
	local book
	for i = 0, 8, 1 do
		local current_item = caster:GetItemInSlot(i)
		if current_item then
			local name = current_item:GetAbilityName()
			if name=="item_hd_kraken_shell_armor" then
				kraken_shell = current_item
		
			end
			if name=="item_hd_tome_of_living_memories1" then
				book = current_item
		
			end
		end
		
	end

	if kraken_shell and book then
		UTIL_RemoveImmediate(kraken_shell) --removeitem的暂时替代
		UTIL_RemoveImmediate(book) --removeitem的暂时替代
		self:GetCaster():AddItemByName("item_hd_tome_of_living_memories2")
	end
end




function modifier_item_hd_tome_of_living_memories1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
	}
end

function modifier_item_hd_tome_of_living_memories1:GetModifierHealthBonus()	return self.bonus_health end

function modifier_item_hd_tome_of_living_memories1:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_tome_of_living_memories1_active", {})

	end
end



-- advanced_modifier
function modifier_item_hd_tome_of_living_memories1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
		advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_item_hd_tome_of_living_memories1:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity
end




function modifier_item_hd_tome_of_living_memories1:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.bonus_summon_time
end

function modifier_item_hd_tome_of_living_memories1:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end




modifier_item_hd_tome_of_living_memories1_active = advanced_modifier({})

function modifier_item_hd_tome_of_living_memories1_active:IsDebuff() return false end
function modifier_item_hd_tome_of_living_memories1_active:IsHidden() return true end
function modifier_item_hd_tome_of_living_memories1_active:IsPurgable() return false end
function modifier_item_hd_tome_of_living_memories1_active:RemoveOnDeath() return false end
function modifier_item_hd_tome_of_living_memories1_active:GetTexture() return "item_tome_of_living_memories1" end
function modifier_item_hd_tome_of_living_memories1_active:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL= {nil, self:GetParent()},
	}
end
function modifier_item_hd_tome_of_living_memories1_active:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
	if IsClient() then
		return 0
	end
	if 15>=RandomInt(1, 100) then
		-- if keys.block_disabled then
		-- 	return 0 
		-- end
		local health = keys.target:GetHealth()
		keys.target:Heal(keys.damage*1.2,self:GetAbility())
		local value = keys.target:GetHealth()-health
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.target, value, nil)
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_geomagentic_grip_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target )
		ParticleManager:SetParticleControl(nFXIndex, 10, keys.target:GetOrigin())
		DestroyParticleByDelay(nFXIndex,0.5)
	end
	return 0

end