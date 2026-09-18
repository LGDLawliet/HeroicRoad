
Middle_Black_Hole = class({})



LinkLuaModifier("modifier_Middle_Black_Hole_singularity", "skills/Middle_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Black_Hole_thinker", "skills/Middle_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Black_Hole_out_pull", "skills/Middle_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Black_Hole_aura", "skills/Middle_Black_Hole", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_thinker", "modifier/modifier_dummy_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Black_Hole_out_pull_sp_self", "skills/Primary_Black_Hole", LUA_MODIFIER_MOTION_NONE)



function Middle_Black_Hole:IsHiddenWhenStolen() 	return false end
function Middle_Black_Hole:IsRefreshable() 		return false  end
function Middle_Black_Hole:IsStealable() 			return true  end
function Middle_Black_Hole:IsNetherWardStealable() return true end
--命石：黑洞，改形态
function Middle_Black_Hole:GetCastRange() 
	if IsServer() and self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff") then
		return 99999
	end
end

function Middle_Black_Hole:GetAOERadius() 
	local radius = self:GetSpecialValueFor("radius") + self:GetCaster():GetIntellect(false) * self:GetSpecialValueFor("bonua_radius_index") 
	radius= math.min(radius,1950)
	return  radius
	
end

function Middle_Black_Hole:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self.pos = pos
	if IsServer() then--命石：黑洞，改位置
		local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
		if equip_sp then
			pos = caster:GetAbsOrigin()
			self.pos = caster:GetAbsOrigin()
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Black_Hole_out_pull_sp_self", {duration = self:GetChannelTime()})
		end
	end

	self.thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetChannelTime() + FrameTime() * 2}, pos, caster:GetTeamNumber(), false)
	self.thinker:AddNewModifier(caster, self, "modifier_Middle_Black_Hole_thinker", {duration = self:GetChannelTime()})


	
end

function Middle_Black_Hole:OnChannelFinish(a)



	if self.thinker and not self.thinker:IsNull() then
		-- local buff = self.thinker:FindModifierByName("modifier_Middle_Black_Hole_thinker")
		-- Timers:CreateTimer(FrameTime(), function()
		-- 		buff:SetDuration( 0, true )
		-- 		return nil
		-- 	end
		-- )
		UTIL_Remove(self.thinker)
		self.thinker = nil
	end
end

modifier_Middle_Black_Hole_thinker = class({})

function modifier_Middle_Black_Hole_thinker:OnCreated()
	self.radius =  self:GetAbility():GetAOERadius()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole")
		

		local hole_pfx = "particles/units/heroes/hero_enigma/enigma_blackhole_rebuild.vpcf"
		local radius = self:GetAbility():GetAOERadius()
		--命石：黑洞，改范围1
		local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
		if equip_sp then
			radius = (self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():GetIntellect(false) * self:GetAbility():GetSpecialValueFor("bonua_radius_index")) * (1+equip_sp:GetAbility():GetSpecialValueFor("radius_up")*0.01)
			radius = math.min(radius,3510)
		end

		local pos = self:GetParent():GetAbsOrigin()
		pos.z = pos.z + 100
		local pfx = ParticleManager:CreateParticle(hole_pfx, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		local index =radius/450
		ParticleManager:SetParticleControl(pfx, 10, Vector(index,0,0))
		if self:GetCaster():GetIntellect(false) * self:GetAbility():GetSpecialValueFor("bonua_radius_index") >= 500 then
			ParticleManager:SetParticleControl(pfx, 60, Vector(30,30,30))
			ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
			self:GetParent():EmitSound("Imba.EnigmaBlackHoleTobi0"..math.random(1, 5))
		end
		self:AddParticle(pfx, false, false, 15, false, false)
		self:StartIntervalThink(0.3)
	end
end

function modifier_Middle_Black_Hole_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	local radius = self:GetAbility():GetSpecialValueFor("radius") + caster:GetIntellect(false) * self:GetAbility():GetSpecialValueFor("bonua_radius_index")
	--命石：黑洞，改范围2
	local equip_sp = caster:FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
	if equip_sp then
		radius = (self:GetAbility():GetSpecialValueFor("radius") + caster:GetIntellect(false) * self:GetAbility():GetSpecialValueFor("bonua_radius_index")) * (1+equip_sp:GetAbility():GetSpecialValueFor("radius_up")*0.01)
		radius = math.min(radius,3510)
	end


	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 
	radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local dmg = (self:GetAbility():GetSpecialValueFor("basic_damage") +self:GetAbility():GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / 0.3)

	for i=1, #enemy do
		local damageTable = {
							victim = enemy[i],
							attacker = caster,
							damage = dmg,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
	end


	local enemies2 = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i=1, #enemies2 do
		if not enemies2[i]:HasModifier("modifier_Middle_Black_Hole_aura") then
			enemies2[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Black_Hole_out_pull", {})
		end
	end
end

function modifier_Middle_Black_Hole_thinker:IsAura() return true end
function modifier_Middle_Black_Hole_thinker:GetAuraDuration() return 0.1 end
function modifier_Middle_Black_Hole_thinker:GetModifierAura() return "modifier_Middle_Black_Hole_aura" end
function modifier_Middle_Black_Hole_thinker:GetAuraRadius() return self.radius end
function modifier_Middle_Black_Hole_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_Middle_Black_Hole_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Middle_Black_Hole_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_Middle_Black_Hole_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
	end
end

modifier_Middle_Black_Hole_aura = class({})

function modifier_Middle_Black_Hole_aura:IsDebuff()			return true end
function modifier_Middle_Black_Hole_aura:IsHidden() 			return false end
function modifier_Middle_Black_Hole_aura:IsPurgable() 			return false end
function modifier_Middle_Black_Hole_aura:IsPurgeException() 	return false end
function modifier_Middle_Black_Hole_aura:IsStunDebuff()		return true end
function modifier_Middle_Black_Hole_aura:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_SILENCED] = true, [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_Middle_Black_Hole_aura:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Middle_Black_Hole_aura:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Middle_Black_Hole_aura:IsMotionController() return true end
function modifier_Middle_Black_Hole_aura:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Middle_Black_Hole_aura:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			if self:GetParent():IsHero() then
				local pfx = ParticleManager:CreateParticleForPlayer("particles/hero/enigma/screen_blackhole_indicator.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()))
			self:AddParticle(pfx, false, false, 15, false, false)
				PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), self:GetParent())
			end
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Middle_Black_Hole_aura:OnIntervalThink()
	local ability = self:GetAbility()
	local distance = (self:GetParent():GetAbsOrigin() - ability.pos):Length2D()
	local in_pull = 250
	local new_pos = GetGroundPosition(RotatePosition(ability.pos, QAngle(0,1.5,0), self:GetParent():GetAbsOrigin()), self:GetParent())
	if distance > 20 then
		local direction = (ability.pos - new_pos):Normalized()
		direction.z = 0.0
		new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())
	end
	self:GetParent():SetOrigin(new_pos)
end

function modifier_Middle_Black_Hole_aura:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		if self:GetParent():IsHero() then
		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerID(), nil)
	end
	end
end
--命石：黑洞，致死返还
function modifier_Middle_Black_Hole_aura:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end
function modifier_Middle_Black_Hole_aura:OnDeath()	
	if not IsServer() then
		return
	end
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
	if equip_sp then
		local ability_sp = equip_sp:GetAbility()
		if not self:GetAbility():IsCooldownReady() then
			local newCooldown = self:GetAbility():GetCooldownTimeRemaining() - ability_sp:GetSpecialValueFor("cd_reduce")
			self:GetAbility():EndCooldown()
			if newCooldown > 0 then
				self:GetAbility():StartCooldown(newCooldown)
			end
		end
	end
end
modifier_Middle_Black_Hole_out_pull = class({})

function modifier_Middle_Black_Hole_out_pull:IsDebuff()			return false end
function modifier_Middle_Black_Hole_out_pull:IsHidden() 			return true end
function modifier_Middle_Black_Hole_out_pull:IsPurgable() 			return false end
function modifier_Middle_Black_Hole_out_pull:IsPurgeException() 	return false end
function modifier_Middle_Black_Hole_out_pull:IsMotionController() return true end
function modifier_Middle_Black_Hole_out_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_Middle_Black_Hole_out_pull:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Middle_Black_Hole_out_pull:OnIntervalThink()
	if self:GetParent():HasModifier("modifier_Middle_Black_Hole_aura") then
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

	--命石：黑洞，拉扯加强
	local equip_sp = self:GetCaster():FindModifierByName("modifier_item_hd_starry_sky_dome_buff")
	if equip_sp then
		new_pos = self:GetCaster():GetAbsOrigin()
	end
	self:GetParent():SetOrigin(new_pos)
end

function modifier_Middle_Black_Hole_out_pull:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_Middle_Black_Hole_aura") then
		local pos = self:GetParent():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(), Vector(pos.x+RandomInt(10, 200),pos.y+RandomInt(10, 200),pos.z) ,true)
	end
end

 