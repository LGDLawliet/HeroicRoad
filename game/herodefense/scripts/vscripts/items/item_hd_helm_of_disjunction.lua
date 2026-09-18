item_hd_helm_of_disjunction = item_hd_helm_of_disjunction or class({})

LinkLuaModifier("modifier_item_hd_helm_of_disjunction", "items/item_hd_helm_of_disjunction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helm_of_disjunction_debuff", "items/item_hd_helm_of_disjunction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helm_of_disjunction_debuff2", "items/item_hd_helm_of_disjunction", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_helm_of_disjunction:GetIntrinsicModifierName()
	return "modifier_item_hd_helm_of_disjunction"
end


function item_hd_helm_of_disjunction:OnSpellStart()

	local caster    =   self:GetCaster()
	caster:EmitSound("Hero_Dawnbreaker.Solar_Guardian.Stun")


	-- local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_crawler.vpcf", PATTACH_CUSTOMORIGIN, caster)
	local pfx = ParticleManager:CreateParticle("particles/rebuild/items/helm_of_disjunction/effect_blink_arrival.vpcf", PATTACH_ABSORIGIN, caster)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	DestroyParticleByDelay(pfx,4)



	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
	DOTA_UNIT_TARGET_TEAM_BOTH,
	DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  

	for _, unit in ipairs(units) do
		unit:AddNewModifier(caster, self, "modifier_item_hd_helm_of_disjunction_debuff", {duration = 10})
		if unit:GetTeamNumber()~=caster:GetTeamNumber() then
			unit:AddNewModifier(caster, self, "modifier_item_hd_helm_of_disjunction_debuff2", {duration = 5})
		end

	end




end


modifier_item_hd_helm_of_disjunction = class({})

function modifier_item_hd_helm_of_disjunction:IsDebuff() return false end
function modifier_item_hd_helm_of_disjunction:IsHidden() return true end
function modifier_item_hd_helm_of_disjunction:IsPurgable() return false end



function modifier_item_hd_helm_of_disjunction:OnCreated(keys)
    self.ability = self:GetAbility()

 
    -- local parent = self:GetParent()
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resist")
end


function modifier_item_hd_helm_of_disjunction:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	
		

	}
end


function modifier_item_hd_helm_of_disjunction:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_helm_of_disjunction:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end




modifier_item_hd_helm_of_disjunction_debuff =modifier_item_hd_helm_of_disjunction_debuff or  class({})

function modifier_item_hd_helm_of_disjunction_debuff:IsDebuff() return true end
function modifier_item_hd_helm_of_disjunction_debuff:IsHidden() return false end
function modifier_item_hd_helm_of_disjunction_debuff:IsPurgable() return false end
function modifier_item_hd_helm_of_disjunction_debuff:GetTexture()return "item_helm_of_disjunction" end
function modifier_item_hd_helm_of_disjunction_debuff:OnCreated(keys)
	if IsServer() then
		self.mana = self:GetParent():GetMana()
		self:StartIntervalThink(0.03)
	end
end
function modifier_item_hd_helm_of_disjunction_debuff:OnIntervalThink()
	local mana = self:GetParent():GetMana()
	if mana>=self.mana then
		self:GetParent():SetMana(self.mana)
	else
		self.mana = mana
	end
end
modifier_item_hd_helm_of_disjunction_debuff2 =modifier_item_hd_helm_of_disjunction_debuff2 or  advanced_modifier({})

function modifier_item_hd_helm_of_disjunction_debuff2:IsDebuff() return true end
function modifier_item_hd_helm_of_disjunction_debuff2:IsHidden() return false end
function modifier_item_hd_helm_of_disjunction_debuff2:IsPurgable() return false end
function modifier_item_hd_helm_of_disjunction_debuff2:GetTexture()return "item_helm_of_disjunction" end

function modifier_item_hd_helm_of_disjunction_debuff2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_helm_of_disjunction_debuff2:Advanced_GetModifierSpellAmplifyBonus()	return -1000 end
function modifier_item_hd_helm_of_disjunction_debuff2:CheckState()
	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true}

	return state
end