

LinkLuaModifier("modifier_Primary_Rot", "skills/Primary_Rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Rot_slow", "skills/Primary_Rot", LUA_MODIFIER_MOTION_NONE)
Primary_Rot							= Primary_Rot or class({})



function Primary_Rot:ProcsMagicStick() return false end

function Primary_Rot:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Primary_Rot:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
	self:GetCaster():RemoveModifierByNameAndCaster("modifier_Primary_Rot", self:GetCaster())
end

function Primary_Rot:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		-- self:GetCaster():EmitSound("Hero_Pudge.Rot")
		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Primary_Rot", {})
	else
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")

		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Primary_Rot", self:GetCaster())
	end
	
end
function Primary_Rot:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("radius") - caster:GetCastRangeBonus()

end


--------------------------
-- MANA SHIELD MODIFIER -
--------------------------
modifier_Primary_Rot				=modifier_Primary_Rot or class({})

function modifier_Primary_Rot:IsDebuff() return false end
function modifier_Primary_Rot:IsHidden() return true end
function modifier_Primary_Rot:IsPurgable() 		return false end
function modifier_Primary_Rot:RemoveOnDeath()	return true end
function modifier_Primary_Rot:IsAura() return true end
function modifier_Primary_Rot:GetModifierAura()	return "modifier_Primary_Rot_slow" end
function modifier_Primary_Rot:GetAuraRadius()	return self.radius  end
function modifier_Primary_Rot:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Primary_Rot:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_Primary_Rot:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_Primary_Rot:OnCreated()

	if not IsServer() then return end

	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	local caster = self:GetCaster()
	caster:EmitSound("Hero_Pudge.Rot")
	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(self.radius,1,1) )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	self.damage_tick = 1
	self.damageTable = {
	
		attacker =caster,
		-- damage = caster:GetMaxHealth()*0.01* self:GetAbility():GetSpecialValueFor("bonus_damage") / (1.0 / damage_tick),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		}

	self.damageTableSelf = {
		victim = caster,
		attacker = caster,
		-- damage = caster:GetMaxHealth()*0.01* self:GetAbility():GetSpecialValueFor("bonus_damage") / (1.0 / damage_tick),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION +DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL +DOTA_DAMAGE_FLAG_NON_LETHAL  , --Optional.
		ability = self:GetAbility(), --Optional.
		}
	self:StartIntervalThink(self.damage_tick)
end


function modifier_Primary_Rot:OnIntervalThink()
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = caster:GetMaxHealth()*0.01* self:GetAbility():GetSpecialValueFor("bonus_damage") / (1.0 / self.damage_tick)
	self.damageTable.damage = damage

	for i, enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage(self.damageTable)
	end

	if not caster:HasModifier("modifier_heroTalent_npc_dota_hero_pudge_2") then
		self.damageTableSelf.damage = damage
		ApplyDamage(self.damageTableSelf)
	end

end
function modifier_Primary_Rot:OnDestroy()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Pudge.Rot")
	end
end









modifier_Primary_Rot_slow =modifier_Primary_Rot_slow or class({})
function modifier_Primary_Rot_slow:IsHidden()	return true end
function modifier_Primary_Rot_slow:IsDebuff()	return true end
function modifier_Primary_Rot_slow:IsPurgable()	return false end
-- function modifier_Primary_Rot_slow:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Primary_Rot_slow:OnCreated(keys)
	self.move_slow = -self:GetAbility():GetSpecialValueFor("move_slow")
end
function modifier_Primary_Rot_slow:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       


	}
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_pudge_2") then
		table.insert(funcs,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS)
	end
	return funcs
end

function modifier_Primary_Rot_slow:GetModifierMoveSpeedBonus_Constant()	return self.move_slow end
function modifier_Primary_Rot_slow:GetModifierMagicalResistanceBonus()	return -25 end



