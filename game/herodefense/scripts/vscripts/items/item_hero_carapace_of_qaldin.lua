item_hero_carapace_of_qaldin = class({})

LinkLuaModifier("modifier_item_hero_carapace_of_qaldin", "items/item_hero_carapace_of_qaldin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hero_carapace_of_qaldin_unique_passive", "items/item_hero_carapace_of_qaldin", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hero_carapace_of_qaldin:GetIntrinsicModifierName()
	return "modifier_item_hero_carapace_of_qaldin"
end




modifier_item_hero_carapace_of_qaldin = advanced_modifier({})

function modifier_item_hero_carapace_of_qaldin:IsDebuff() return false end
function modifier_item_hero_carapace_of_qaldin:IsHidden() return true end
function modifier_item_hero_carapace_of_qaldin:IsPurgable() return false end
function modifier_item_hero_carapace_of_qaldin:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

-- function modifier_item_hero_carapace_of_qaldin:GetEffectName()
-- 	return "particles/items/luminance_passive.vpcf"
-- end

-- function modifier_item_hero_carapace_of_qaldin:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function modifier_item_hero_carapace_of_qaldin:OnCreated(keys)
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()

    if IsServer() then
		self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hero_carapace_of_qaldin_unique_passive", {
		passive_damage_return_pct = ability:GetSpecialValueFor("damage_return_pct"),
		})
    end
    
	self.bonus_hp = ability:GetSpecialValueFor("bonus_hp")
	self.bonus_mp = ability:GetSpecialValueFor("bonus_mp")



	self.hp_regen_amp = ability:GetSpecialValueFor("bonus_restore_pct")
	self.mp_regen_amp = ability:GetSpecialValueFor("bonus_restore_pct")
end
function modifier_item_hero_carapace_of_qaldin:OnDestroy(keys)
	if IsServer() then
		self.modifier:SafeDestroy()
    end
	
end


function modifier_item_hero_carapace_of_qaldin:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		
	}
end

function modifier_item_hero_carapace_of_qaldin:GetModifierHealthBonus()
	return self.bonus_hp
end

function modifier_item_hero_carapace_of_qaldin:GetModifierManaBonus()
	return self.bonus_mp
end


function modifier_item_hero_carapace_of_qaldin:AdvancedGetModifierConstantManaRegenAmpPercentage()
	return self.mp_regen_amp
end

function modifier_item_hero_carapace_of_qaldin:AdvancedGetModifierConstantHealthRegenAmpPercentage()
	return self.hp_regen_amp
end


function modifier_item_hero_carapace_of_qaldin:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_AMP_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_AMP_PERCENTAGE,
	}
	return funcs
end


-- Unique passive
modifier_item_hero_carapace_of_qaldin_unique_passive = class({})

function modifier_item_hero_carapace_of_qaldin_unique_passive:IsDebuff() return false end
function modifier_item_hero_carapace_of_qaldin_unique_passive:IsHidden() return true end
function modifier_item_hero_carapace_of_qaldin_unique_passive:IsPurgable() return false end
function modifier_item_hero_carapace_of_qaldin_unique_passive:RemoveOnDeath() return false end
function modifier_item_hero_carapace_of_qaldin_unique_passive:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_item_hero_carapace_of_qaldin_unique_passive:OnCreated(keys)
	if not IsServer() then return end

	if self:GetParent():IsIllusion() then
		self:SafeDestroy()
	end
	self.passive_damage_return_pct = keys.passive_damage_return_pct*0.01
end

function modifier_item_hero_carapace_of_qaldin_unique_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_item_hero_carapace_of_qaldin_unique_passive:OnTakeDamage(params)

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Target  ~= self:GetParent() or Attacker == nil then
			return 0
		end
		if Target:GetTeamNumber()==Attacker:GetTeamNumber() then
			return
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then --防止无限反弹
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT ) == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then --防止无限反弹
			return 0
		end
		local damage = math.min(flDamage*self.passive_damage_return_pct,Target:GetMaxHealth()*0.5)

		local damage_table = {
			victim = Attacker,
			attacker = Target,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		}
		ApplyDamage(damage_table)
	end
	return 0.0
end



