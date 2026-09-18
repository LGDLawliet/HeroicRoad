
LinkLuaModifier("modifier_item_hd_ritual_spear", "items/item_hd_ritual_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ritual_spear_active", "items/item_hd_ritual_spear", LUA_MODIFIER_MOTION_NONE)


item_hd_ritual_spear =item_hd_ritual_spear or class({})
function item_hd_ritual_spear:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/ritual_spear/effect/lightning_bolt.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/ritual_spear/attach_effect/effect/energy.vpcf", context )



	
end
function item_hd_ritual_spear:GetIntrinsicModifierName()
	return "modifier_item_hd_ritual_spear"
end


function item_hd_ritual_spear:OnSpellStart()

	local caster = self:GetCaster()
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")

	local particle = ParticleManager:CreateParticle("particles/rebuild/items/ritual_spear/effect/lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin()+Vector(0,0,64))
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()+Vector(0,0,1500))
	DestroyParticleByDelay(particle,2)
	caster:AddNewModifier(caster, self, "modifier_item_hd_ritual_spear_active", {duration = self:GetSpecialValueFor("duration")})
	

end


modifier_item_hd_ritual_spear = advanced_modifier({})

function modifier_item_hd_ritual_spear:IsDebuff() return false end
function modifier_item_hd_ritual_spear:IsHidden() return true end
function modifier_item_hd_ritual_spear:IsPurgable() return false end
function modifier_item_hd_ritual_spear:OnCreated(keys)


	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_atb = self:GetAbility():GetSpecialValueFor("bonus_atb")

end



function modifier_item_hd_ritual_spear:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力

	}
end

function modifier_item_hd_ritual_spear:Advanced_GetModifierBonusStats_Strength()	return self.bonus_atb end
function modifier_item_hd_ritual_spear:Advanced_GetModifierBonusStats_Agility()	return self.bonus_atb end
function modifier_item_hd_ritual_spear:Advanced_GetModifierBonusStats_Intellect()	return self.bonus_atb end
function modifier_item_hd_ritual_spear:Advanced_GetModifierPreAttack_BonusDamage()	return self.bonus_damage end






modifier_item_hd_ritual_spear_active = modifier_item_hd_ritual_spear_active or class({})

function modifier_item_hd_ritual_spear_active:IsDebuff() return false end
function modifier_item_hd_ritual_spear_active:IsHidden() return false end
function modifier_item_hd_ritual_spear_active:IsPurgable() return false end
function modifier_item_hd_ritual_spear_active:IsPurgeException() return false end
-- function modifier_item_hd_ritual_spear_active:RemoveOnDeath() return false end


function modifier_item_hd_ritual_spear_active:OnCreated(keys)
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.random_radius = self:GetAbility():GetSpecialValueFor("random_radius")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.limit = self:GetAbility():GetSpecialValueFor("limit")
	if IsServer() then
		local parent = self:GetParent()
		self.attach_particle = ParticleManager:CreateParticle( "particles/rebuild/items/ritual_spear/attach_effect/effect/energy.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
		ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		self:AddParticle( self.attach_particle, false, false, -1, true, false )
	end
end

function modifier_item_hd_ritual_spear_active:OnDestroy()

end



function modifier_item_hd_ritual_spear_active:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_item_hd_ritual_spear_active:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end


function modifier_item_hd_ritual_spear_active:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	local parent = self:GetParent()
	if parent:RollRandom(self.chance,0.5) then
		local pos = keys.target:GetAbsOrigin() +RandomVector(self.random_radius)
		local radius = self.radius

		local particle = ParticleManager:CreateParticle("particles/rebuild/items/ritual_spear/effect/lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z+64))
		ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
		ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
		-- ParticleManager:DestroyParticle(effect_cast, false)
		ParticleManager:ReleaseParticleIndex( particle )
		DestroyParticleByDelay(particle,2)

		EmitSoundOnLocationWithCaster(pos, "Hero_Zuus.LightningBolt", parent)


		local units = FindUnitsInRadius(parent:GetTeamNumber(), pos, nil,  radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST , false)  
		local damage_table 			= {
			attacker 		= parent,
			ability 		= self:GetAbility(),
			damage_type 	= DAMAGE_TYPE_PURE ,
			damage			= parent:GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor("damage_index"),
			damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			hd_flags 		= HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_NO_SPELL_CRIT
		}
		for i, unit in ipairs(units) do
			damage_table.victim = unit
			ApplyDamage(damage_table)
			unit:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_stunned",{duration = 0.01})
			if i>=self.limit then
				break
			end
		end

		

	end

	
end



