item_hd_ultimate_orb = class({})
LinkLuaModifier("modifier_item_hd_ultimate_orb_active", "items/item_hd_ultimate_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ultimate_orb", "items/item_hd_ultimate_orb", LUA_MODIFIER_MOTION_NONE)

function item_hd_ultimate_orb:GetIntrinsicModifierName()
	return "modifier_item_hd_ultimate_orb"
end
--------------------------------------------------
modifier_item_hd_ultimate_orb = advanced_modifier({})

function modifier_item_hd_ultimate_orb:IsDebuff() return false end
function modifier_item_hd_ultimate_orb:IsHidden() return true end
function modifier_item_hd_ultimate_orb:IsPurgable() return false end

function modifier_item_hd_ultimate_orb:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_atb = self.ability:GetSpecialValueFor("bonus_atb")
	self.line = self.ability:GetSpecialValueFor("line")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_hd_ultimate_orb:OnWaveStart()
	if IsServer() then
		--[[ 特效cy：回血回蓝的特效
	   if self:GetAbility():IsCooldownReady() then
		local caster = self:GetParent()
		if caster:GetHealthPercent()<=10 then
			self:GetAbility():StartCooldown(50)
			caster:Heal(caster:GetMaxHealth()*0.4, self:GetAbility())
			caster:EmitSound("Hero_Warlock.ShadowWordCastGood")
			self.particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward_death.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle)
		end
		if caster:GetManaPercent()<=10 then
			self:GetAbility():StartCooldown(50)
			caster:GiveMana(caster:GetMaxMana()*0.4)
			caster:EmitSound("Hero_Antimage.ManaVoidCast")
			self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle)
		end
	   end
	   ]]
	  	self:GetParent():GameTimer(0.3,function ()
		  	local random_response = RandomInt(1, 4)
		  	self:GetParent():EmitSound("ogre_magi_ogmag_ability_bloodlust_0"..random_response)
		  	self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_ultimate_orb_active", {duration = self.duration})
		end)
		
	end
end

function modifier_item_hd_ultimate_orb:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end

function modifier_item_hd_ultimate_orb:GetModifierBonusStats_Strength()	return self.bonus_atb end
function modifier_item_hd_ultimate_orb:GetModifierBonusStats_Intellect()	return self.bonus_atb end
function modifier_item_hd_ultimate_orb:GetModifierBonusStats_Agility()	return self.bonus_atb end

function modifier_item_hd_ultimate_orb:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_EVENT_ON_RESPAWN,
	}
end
function modifier_item_hd_ultimate_orb:OnRespawn(keys)
	if IsServer() then
		if keys.unit==self:GetParent() then
			self:OnWaveStart()
		end
	end
end

--------
-----------------------------------------------------
modifier_item_hd_ultimate_orb_active = advanced_modifier({})

function modifier_item_hd_ultimate_orb_active:IsDebuff() return false end
function modifier_item_hd_ultimate_orb_active:IsHidden() return false end
function modifier_item_hd_ultimate_orb_active:IsPurgable() return false end
function modifier_item_hd_ultimate_orb_active:GetTexture() return "item_ultimate_orb" end
function modifier_item_hd_ultimate_orb_active:GetEffectName() return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf" end
function modifier_item_hd_ultimate_orb_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_ultimate_orb_active:OnCreated(keys)
    self.ability = self:GetAbility()
	self.line = self.ability:GetSpecialValueFor("line")
	self.outgoing = self.ability:GetSpecialValueFor("outgoing")
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_ultimate_orb_active:OnIntervalThink()
	self.hp = self:GetParent():GetMaxHealth() * self.line*0.01
	if self:GetParent():GetHealth() >= self.hp then
	 	self:GetParent():SetHealth(self.hp)
	end
end
function modifier_item_hd_ultimate_orb_active:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	}
end
function modifier_item_hd_ultimate_orb_active:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not self:GetAbility() then self:Destroy() return end
	return self.outgoing
end