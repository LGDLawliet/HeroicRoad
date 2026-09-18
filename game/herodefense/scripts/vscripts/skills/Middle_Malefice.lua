
Middle_Malefice = class({})

LinkLuaModifier("modifier_Middle_Malefice", "skills/Middle_Malefice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)



function Middle_Malefice:IsHiddenWhenStolen() 		return false end
function Middle_Malefice:IsRefreshable() 			return true  end
function Middle_Malefice:IsStealable() 			return true  end
function Middle_Malefice:IsNetherWardStealable() 	return true end
function Middle_Malefice:SetPos(pos) 	
	self.pos = pos
end
function Middle_Malefice:GetPos() 	
	return self.pos
end
function Middle_Malefice:GetCooldown(iLevel)
	if IsServer() then 
		local modifier = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_enigma")
		if modifier then
			return 20 - modifier:GetSpecialValueFor("cd_reduce")
		end
		return 20
	end
end
function Middle_Malefice:GetAOERadius() 
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_enigma") then
		return  self:GetSpecialValueFor("effect_radius")+200
	end
	return self:GetSpecialValueFor("effect_radius") 
end

function Middle_Malefice:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(caster, self, "modifier_Middle_Malefice", {duration = self:GetSpecialValueFor("total_duration")})
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Enigma.Malefice", target)
end

modifier_Middle_Malefice = advanced_modifier({})

function modifier_Middle_Malefice:IsDebuff()			return true end
function modifier_Middle_Malefice:IsHidden() 			return false end
function modifier_Middle_Malefice:IsPurgable() 		return true end
function modifier_Middle_Malefice:IsPurgeException() 	return true end
function modifier_Middle_Malefice:GetStatusEffectName() return "particles/status_fx/status_effect_enigma_malefice.vpcf" end
function modifier_Middle_Malefice:StatusEffectPriority() return 15 end
function modifier_Middle_Malefice:GetEffectName() return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf" end
function modifier_Middle_Malefice:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Middle_Malefice:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("effect_interval"))
		self:OnIntervalThink()
	end
end

function modifier_Middle_Malefice:OnIntervalThink()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local ability_talent = caster:FindAbilityByName("heroTalent_npc_dota_hero_enigma")
	local radius = ability:GetSpecialValueFor("effect_radius")
	if ability_talent then
		radius = ability:GetSpecialValueFor("effect_radius") + ability_talent:GetSpecialValueFor("radius")
	end

	local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = ability:GetSpecialValueFor( "basic_damage" ) + caster:GetIntellect(false) * ability:GetSpecialValueFor( "intelligence_index" )
	local damage_type = ability:GetAbilityDamageType()
	if ability_talent then
		damage = (ability:GetSpecialValueFor( "basic_damage" ) + caster:GetIntellect(false) * ability:GetSpecialValueFor( "intelligence_index" ))*(1+ability_talent:GetSpecialValueFor("damage")*0.01)
	end
	self.thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = ability:GetSpecialValueFor("black_hole_duration")}, self:GetParent():GetAbsOrigin(), caster:GetTeamNumber(), false)
	self.thinker:AddNewModifier(caster, ability, "modifier_Middle_Malefice_black_hole_thinker", {duration = ability:GetSpecialValueFor("black_hole_duration")})
	target:EmitSound("Hero_Terrorblade.Reflection")


	for i=1, #enemy do
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance =  enemy[i]:GetHDStatusResistanceIndex(0.6)*ModifierStatusNegativeGain
		enemy[i]:AddNewModifier(caster, ability, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")*StatusResistance})
		local damageTable = {
							victim = enemy[i],
							attacker = caster,
							damage = damage,
							damage_type = damage_type,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		ApplyDamage(damageTable)
		if not target:IsAlive() and not self:GetAbility():IsCooldownReady() then
			local time = self:GetAbility():GetSpecialValueFor("cd_reduce")
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - time
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
		enemy[i]:EmitSound("Hero_Enigma.MaleficeTick")	

	end
	local hole_pfx = "particles/rebuild/spell/malefice/active.vpcf"
	local pos = self:GetParent():GetAbsOrigin()
	self.pos = pos
	self:GetAbility():SetPos(pos)
	pos.z = pos.z + 100
	local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	self:AddParticle(pfx, false, false, 15, false, false)
end

function modifier_Middle_Malefice:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_Middle_Malefice:OnDeath(keys)
	if IsServer() then
		if not self:GetAbility():IsCooldownReady() then
			local time = self:GetAbility():GetSpecialValueFor("cd_reduce")
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - time
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
	end
end


LinkLuaModifier("modifier_Middle_Malefice_black_hole_thinker", "skills/Middle_Malefice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Malefice_black_hole_out_pull", "skills/Middle_Malefice", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Malefice_black_hole_aura", "skills/Middle_Malefice", LUA_MODIFIER_MOTION_NONE)


modifier_Middle_Malefice_black_hole_thinker = class({})
function modifier_Middle_Malefice_black_hole_thinker:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole")
		local hole_pfx = "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf"
		self:GetParent():EmitSound("Imba.EnigmaBlackHoleTobi0"..math.random(1, 5))
		self:SetStackCount(1)
		local pos = self:GetParent():GetAbsOrigin()
		self.pos = pos
		self:GetAbility():SetPos(pos)
		pos.z = pos.z + 100
		local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		self:AddParticle(pfx, false, false, 15, false, false)
		self:StartIntervalThink(0.5)
	end
end

function modifier_Middle_Malefice_black_hole_thinker:OnIntervalThink()

	local out_distance = self:GetAbility():GetSpecialValueFor("base_pull_distance") 
	local enemies2 = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, out_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i=1, #enemies2 do
		if not enemies2[i]:HasModifier("modifier_Middle_Malefice_black_hole_aura") then
			enemies2[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Malefice_black_hole_out_pull", {})
		end
	end
end




function modifier_Middle_Malefice_black_hole_thinker:IsAura() return true end
function modifier_Middle_Malefice_black_hole_thinker:GetAuraDuration() return 0.1 end
function modifier_Middle_Malefice_black_hole_thinker:GetModifierAura() return "modifier_Middle_Malefice_black_hole_aura" end
function modifier_Middle_Malefice_black_hole_thinker:GetAuraRadius() return self:GetAbility():GetAOERadius() end
function modifier_Middle_Malefice_black_hole_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Middle_Malefice_black_hole_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Middle_Malefice_black_hole_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Middle_Malefice_black_hole_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
		UTIL_Remove(self:GetParent())
	end
end

modifier_Middle_Malefice_black_hole_aura = class({})

function modifier_Middle_Malefice_black_hole_aura:IsDebuff()			return true end
function modifier_Middle_Malefice_black_hole_aura:IsHidden() 			return false end
function modifier_Middle_Malefice_black_hole_aura:IsPurgable() 			return false end
function modifier_Middle_Malefice_black_hole_aura:IsPurgeException() 	return false end
function modifier_Middle_Malefice_black_hole_aura:IsStunDebuff()		return true end

function modifier_Middle_Malefice_black_hole_aura:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Middle_Malefice_black_hole_aura:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Middle_Malefice_black_hole_aura:IsMotionController() return true end
function modifier_Middle_Malefice_black_hole_aura:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Middle_Malefice_black_hole_aura:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self.pos = self:GetAbility():GetPos()
	end
end

function modifier_Middle_Malefice_black_hole_aura:OnDestroy()
	if IsServer()then
		-- if IsServer() and not self:GetParent():HasModifier("modifier_Middle_Malefice_black_hole_aura") then
		local pos = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
	end
end

function modifier_Middle_Malefice_black_hole_aura:OnIntervalThink()
	local caster = self:GetAbility():GetCaster()
	if self.pos == nil then
		return
	end
	local pos = self.pos
	-- local pos = self:GetParent():GetAbsOrigin()
	local distance = (self:GetParent():GetAbsOrigin() - pos):Length2D()
	local in_pull = 25
	local new_pos = GetGroundPosition(RotatePosition(pos, QAngle(0,1.5,0), self:GetParent():GetAbsOrigin()), self:GetParent())
	if true then
		local direction = (pos - new_pos):Normalized()
		direction.z = 0.0
		new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())
	end
	self:GetParent():SetOrigin(new_pos)
end



modifier_Middle_Malefice_black_hole_out_pull = class({})

function modifier_Middle_Malefice_black_hole_out_pull:IsDebuff()			return false end
function modifier_Middle_Malefice_black_hole_out_pull:IsHidden() 			return true end
function modifier_Middle_Malefice_black_hole_out_pull:IsPurgable() 			return false end
function modifier_Middle_Malefice_black_hole_out_pull:IsPurgeException() 	return false end
function modifier_Middle_Malefice_black_hole_out_pull:IsMotionController() return true end
function modifier_Middle_Malefice_black_hole_out_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_Middle_Malefice_black_hole_out_pull:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Middle_Malefice_black_hole_out_pull:OnIntervalThink()
	if self:GetParent():HasModifier("modifier_Middle_Malefice_black_hole_aura") then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	local out_distance = self:GetAbility():GetSpecialValueFor("pull_distance") 
	if not ability:IsChanneling() or (self:GetParent():GetAbsOrigin() - ability.pos):Length2D() > out_distance or self:GetParent():IsBoss() then
		self:SafeDestroy()
	end
	local out_pull = ability:GetSpecialValueFor("pull_speed")


	local direction = (ability.pos - self:GetParent():GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local new_pos = self:GetParent():GetAbsOrigin() + direction * (out_pull / (1.0 / FrameTime()))
	self:GetParent():SetOrigin(new_pos)
end

function modifier_Middle_Malefice_black_hole_out_pull:OnDestroy()
	if IsServer()then
		-- if IsServer() and not self:GetParent():HasModifier("modifier_Middle_Malefice_black_hole_aura") then
		local pos = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
	end
end

