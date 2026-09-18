item_hd_radiance = class({})
-- LinkLuaModifier("modifier_item_hd_radiance_arua", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_radiance_arua_effect", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_radiance", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_radiance_active", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_radiance_effect", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_radiance_effect2", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_radiance_active_standby", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_radiance_debuff", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_radiance_thinker", "items/item_hd_radiance", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_radiance:GetIntrinsicModifierName()
	return "modifier_item_hd_radiance"
end





modifier_item_hd_radiance = class({})

function modifier_item_hd_radiance:IsDebuff() return false end
function modifier_item_hd_radiance:IsHidden() return true end
function modifier_item_hd_radiance:IsPurgable() return false end
-- function modifier_item_hd_radiance:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_radiance:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_radiance:IsAura() return true end
function modifier_item_hd_radiance:GetAuraDuration() return 0.5 end
function modifier_item_hd_radiance:GetModifierAura() return "modifier_item_hd_radiance_active" end
function modifier_item_hd_radiance:GetAuraRadius() return 900 end
function modifier_item_hd_radiance:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_radiance:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_radiance:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_radiance:OnCreated(keys)
    self.ability = self:GetAbility()

 

	self.bonus_str = 4
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	


    if IsServer() then

		self:StartIntervalThink(1)
	end
end
function modifier_item_hd_radiance:OnIntervalThink()
	if IsServer() then

		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  900,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
	   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
	   local damage =  self:GetCaster():GetStrength()*2.5
	   local caster = self:GetCaster()
	   local damagetype = self:GetAbility():GetAbilityDamageType()
	   for i, enemy in pairs(units) do
		   local damageTable = {
			   victim = enemy,
			   attacker = caster,
			   damage = damage,
			   damage_type = damagetype,
			   damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
			   ability = self, --Optional.
			   }
		   ApplyDamage(damageTable)	
		   if i>=10 then
			   break
		   end
	   end
		-- self:SetHasCustomTransmitterData(true)
	end
end


function modifier_item_hd_radiance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
	

	}
end


function modifier_item_hd_radiance:GetModifierBonusStats_Strength()	return self.bonus_str end

function modifier_item_hd_radiance:GetModifierPreAttack_BonusDamage() return self.bonus_damage end






modifier_item_hd_radiance_active = class({})

function modifier_item_hd_radiance_active:IsDebuff() return true end
function modifier_item_hd_radiance_active:IsHidden() return false end
function modifier_item_hd_radiance_active:IsPurgable() return false end
function modifier_item_hd_radiance_active:GetTexture()return "item_radiance" end

function modifier_item_hd_radiance_active:OnCreated(table)
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_item_hd_radiance_active:OnDestroy(table)
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, true)
	end
end