item_hd_trickster_cloak = class({})
-- LinkLuaModifier("modifier_item_hd_trickster_cloak_arua", "items/item_hd_trickster_cloak", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_trickster_cloak_arua_effect", "items/item_hd_trickster_cloak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trickster_cloak", "items/item_hd_trickster_cloak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_trickster_cloak_active", "items/item_hd_trickster_cloak", LUA_MODIFIER_MOTION_NONE)



function item_hd_trickster_cloak:GetIntrinsicModifierName()
	return "modifier_item_hd_trickster_cloak"
end

function item_hd_trickster_cloak:OnSpellStart()

	local caster    =   self:GetCaster()

	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", caster)
	self:StartCooldown(25)

	local particle_invis_start_fx = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)

	caster:AddNewModifier(caster, self, "modifier_item_hd_trickster_cloak_active", {duration = 4})
end


modifier_item_hd_trickster_cloak = class({})

function modifier_item_hd_trickster_cloak:IsDebuff() return false end
function modifier_item_hd_trickster_cloak:IsHidden() return true end
function modifier_item_hd_trickster_cloak:IsPurgable() return false end


function modifier_item_hd_trickster_cloak:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_evasion = self.ability:GetSpecialValueFor("bonus_evasion")
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	
end

function modifier_item_hd_trickster_cloak:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_EVASION_CONSTANT,                 --闪避
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		

	}
end



function modifier_item_hd_trickster_cloak:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end
function modifier_item_hd_trickster_cloak:GetModifierEvasion_Constant() return self.bonus_evasion end





modifier_item_hd_trickster_cloak_active = class({})

function modifier_item_hd_trickster_cloak_active:IsDebuff() return false end
function modifier_item_hd_trickster_cloak_active:IsHidden() return false end
function modifier_item_hd_trickster_cloak_active:IsPurgable() return false end
function modifier_item_hd_trickster_cloak_active:GetTexture()return "item_trickster_cloak" end



function modifier_item_hd_trickster_cloak_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,

	}
end


function modifier_item_hd_trickster_cloak_active:GetModifierInvisibilityLevel()return 1 end

function modifier_item_hd_trickster_cloak_active:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end




function modifier_item_hd_trickster_cloak_active:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:SafeDestroy()
		end
	end
end

function modifier_item_hd_trickster_cloak_active:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		if keys.unit == parent then
			self:SafeDestroy()
		end
	end
end



