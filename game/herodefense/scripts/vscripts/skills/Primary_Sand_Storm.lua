
Primary_Sand_Storm = class({})

LinkLuaModifier("modifier_Primary_Sand_Storm_caster", "skills/Primary_Sand_Storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Sand_Storm_motion", "skills/Primary_Sand_Storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Sand_Storm", "skills/Primary_Sand_Storm", LUA_MODIFIER_MOTION_NONE)

function Primary_Sand_Storm:IsHiddenWhenStolen() 		return false end
function Primary_Sand_Storm:IsRefreshable() 			return true end
function Primary_Sand_Storm:IsStealable() 			return true end
function Primary_Sand_Storm:IsNetherWardStealable()	return true end
function Primary_Sand_Storm:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Primary_Sand_Storm:OnSpellStart()
	local caster = self:GetCaster()
	CreateModifierThinker(caster, self, "modifier_Primary_Sand_Storm", {duration = self:GetSpecialValueFor("max_duration")}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	caster:EmitSound("Ability.SandKing_SandStorm.start")
end

function Primary_Sand_Storm:OnChannelFinish(bInterrupted)
	local buff = self:GetCaster():FindModifierByName("modifier_sand_storm_caster")
	if buff then
		buff:StartIntervalThink(-1)
		buff:SetDuration(self:GetSpecialValueFor("invis_duration"), true)
	end
end
--
modifier_Primary_Sand_Storm = class({})

function modifier_Primary_Sand_Storm:IsAura() return true end
function modifier_Primary_Sand_Storm:GetAuraDuration() return self.invis_duration end
function modifier_Primary_Sand_Storm:GetModifierAura() return "modifier_Primary_Sand_Storm_caster" end
function modifier_Primary_Sand_Storm:GetAuraRadius() return self.radius end
function modifier_Primary_Sand_Storm:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Primary_Sand_Storm:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Primary_Sand_Storm:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_Primary_Sand_Storm:GetAuraEntityReject(unit) return self:GetCaster() ~= unit end

function modifier_Primary_Sand_Storm:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.invis_duration = self.ability:GetSpecialValueFor("invis_duration")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.interval = self.ability:GetSpecialValueFor("damage_tick")
	self.count = self.ability:GetSpecialValueFor("count")
	if IsServer() then
		self.parent:EmitSound("Ability.SandKing_SandStorm.loop")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius * 1.15, 1, 1))
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_Primary_Sand_Storm:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	local damage = self.damage + self.bonus_damage*self.caster:HDGetPrimaryStatValue()*self.interval
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do
		local damageTable = {
							victim = enemy,
							attacker = self.caster,
							damage = damage,
							damage_type = self.ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self.ability, --Optional.
							}
		ApplyDamage(damageTable)
		if i >= self.count then
			break
		end
	end
end

function modifier_Primary_Sand_Storm:OnDestroy()
	if IsServer() then
		-- self:GetParent():StopSound("Imba.SandKingSandStorm")
		self:GetParent():StopSound("Ability.SandKing_SandStorm.loop")
		UTIL_Remove(self:GetParent())
		

	end
end

modifier_Primary_Sand_Storm_caster = class({})

function modifier_Primary_Sand_Storm_caster:IsDebuff()			return false end
function modifier_Primary_Sand_Storm_caster:IsHidden() 		return false end
function modifier_Primary_Sand_Storm_caster:IsPurgable() 		return false end
function modifier_Primary_Sand_Storm_caster:IsPurgeException() return false end
function modifier_Primary_Sand_Storm_caster:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_Primary_Sand_Storm_caster:GetModifierInvisibilityLevel() return 1 end
-- function modifier_Primary_Sand_Storm_caster:CheckState() return {[MODIFIER_STATE_INVISIBLE] = true} end

function modifier_Primary_Sand_Storm_caster:OnCreated()
	if IsServer() then
		self:GetAuraOwner():FindModifierByName("modifier_Primary_Sand_Storm"):StartIntervalThink(self:GetAbility():GetSpecialValueFor("damage_tick"))
	end
end

function modifier_Primary_Sand_Storm_caster:OnDestroy()
	if IsServer() and self:GetAuraOwner()~=nil then
		self:GetAuraOwner():Destroy()
	end
end


modifier_Primary_Sand_Storm_motion = class({})

function modifier_Primary_Sand_Storm_motion:IsDebuff()			return false end
function modifier_Primary_Sand_Storm_motion:IsHidden() 		return true end
function modifier_Primary_Sand_Storm_motion:IsPurgable() 		return false end
function modifier_Primary_Sand_Storm_motion:IsPurgeException() return false end
function modifier_Primary_Sand_Storm_motion:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Primary_Sand_Storm_motion:IsMotionController() return true end
function modifier_Primary_Sand_Storm_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_Primary_Sand_Storm_motion:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Primary_Sand_Storm_motion:OnIntervalThink()
	local distance = self:GetAbility():GetSpecialValueFor("wind_force_tooltip")
	distance = distance / (self:GetDuration() / FrameTime())
	local next_pos = self:GetParent():GetAbsOrigin() + (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized() * distance
	self:GetParent():SetOrigin(next_pos)
end

function modifier_Primary_Sand_Storm_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end

