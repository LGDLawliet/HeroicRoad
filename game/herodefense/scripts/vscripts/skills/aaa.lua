
Primary_hex = class({})
LinkLuaModifier("modifier_Primary_hex", "skills/Primary_hex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_hex_chain_cooldown", "skills/Primary_hex", LUA_MODIFIER_MOTION_NONE)

function Primary_hex:GetAbilityTextureName()
   return "lion_voodoo"
end

function Primary_hex:IsHiddenWhenStolen()
	return false
end

function Primary_hex:GetBehavior()
	if self:GetCaster():HasTalent("special_bonus_imba_lion_10") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

function Primary_hex:GetAOERadius()
	if self:GetCaster():HasTalent("special_bonus_imba_lion_10") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_lion_10")
	else
		return 0
	end
end

function Primary_hex:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = {"lion_lion_ability_voodoo_03", "lion_lion_ability_voodoo_04", "lion_lion_ability_voodoo_05", "lion_lion_ability_voodoo_06", "lion_lion_ability_voodoo_07", "lion_lion_ability_voodoo_08", "lion_lion_ability_voodoo_09", "lion_lion_ability_voodoo_10"}
	local sound_cast = "Hero_Lion.Voodoo"
	local particle_hex = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"
	local modifier_hex = "modifier_Primary_hex"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")    

	-- Roll for a cast response
	if RollPercentage(75) then
		EmitSoundOn(cast_response[math.random(1,7)], caster)
	end

	if not caster:HasTalent("special_bonus_imba_lion_10") then
		-- Play cast sound
		EmitSoundOn(sound_cast, target)

		-- If target has Linken's Sphere off cooldown, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		-- I don't really have an idea as to why this can reflect onto magic-immune enemies, but I guess I'll just put a guard here
		if not target:IsMagicImmune() then
			-- Add particle effect
			local particle_hex_fx = ParticleManager:CreateParticle(particle_hex, PATTACH_CUSTOMORIGIN, target)     
			ParticleManager:SetParticleControl(particle_hex_fx, 0, target:GetAbsOrigin())      
			ParticleManager:ReleaseParticleIndex(particle_hex_fx)
			
			-- Transform your enemy into a frog
			target:AddNewModifier(caster, ability, modifier_hex, {duration = duration * (1 - target:GetStatusResistance())})
		end
	else
		target = self:GetCursorPosition()
	
	-- AoE Hex talent
		EmitSoundOnLocationWithCaster(target, sound_cast, caster)
	
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
								  target,
								  nil,
								  self:GetCaster():FindTalentValue("special_bonus_imba_lion_10"),
								  DOTA_UNIT_TARGET_TEAM_ENEMY,
								  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
								  DOTA_UNIT_TARGET_FLAG_NONE,
								  FIND_ANY_ORDER,
								  false)
								  
		for _, enemy in pairs(enemies) do
			local particle_hex_fx = ParticleManager:CreateParticle(particle_hex, PATTACH_CUSTOMORIGIN, enemy)     
			ParticleManager:SetParticleControl(particle_hex_fx, 0, enemy:GetAbsOrigin())      
			ParticleManager:ReleaseParticleIndex(particle_hex_fx)
			
			enemy:AddNewModifier(caster, ability, modifier_hex, {duration = duration * (1 - enemy:GetStatusResistance())})
		end
	end
end

-- Hex modifier
modifier_Primary_hex = class({})

function modifier_Primary_hex:OnCreated()    
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_cast = "Hero_Lion.Voodoo"
	self.sound_meme_firetoad = "Imba.LionHexREEE"
	self.particle_hex = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"
	self.particle_flaming_frog = "particles/hero/lion/firetoad.vpcf"
	self.modifier_hex = "modifier_Primary_hex"
	self.caster_team = self.caster:GetTeamNumber() -- Pugna ward problems
	self.firetoad_chance = 10

	-- Ability specials
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.move_speed = self.ability:GetSpecialValueFor("move_speed")
	self.hex_bounce_radius = self.ability:GetSpecialValueFor("hex_bounce_radius")
	self.maximum_hex_enemies = self.ability:GetSpecialValueFor("maximum_hex_enemies")
	
	-- #6 Talent: Hex bounces to a second enemy
	self.maximum_hex_enemies = self.maximum_hex_enemies + self.caster:FindTalentValue("special_bonus_imba_lion_6")

	-- If the parent is an illusion, pop it and exit
	if self.parent:IsIllusion() and not Custom_bIsStrongIllusion(self.parent) then
		self.parent:Kill(self.ability, self.caster)
		return nil
	end

	if IsServer() then

		-- Roll for a Firetoad
		if RollPercentage(self.firetoad_chance) then

			-- REEEEEEEEEEEEE
			EmitSoundOn(self.sound_meme_firetoad, self.parent)    

			-- Set render color of the frog
			self.parent:SetRenderColor(255, 86, 1)

			-- Add flaming frog particle 
			self.particle_flaming_frog_fx = ParticleManager:CreateParticle(self.particle_flaming_frog, PATTACH_POINT_FOLLOW, self.parent)
			ParticleManager:SetParticleControlEnt(self.particle_flaming_frog_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)    
			self:AddParticle(self.particle_flaming_frog_fx, false, false, -1, false, false)
		end        

		-- Slight modification to wait a frame before applying bounces to respect frantic status resistance (while still applying Chain Hex if duration is less than the standard requirements)
		Timers:CreateTimer(FrameTime(), function()
			self.bounce_interval = math.min(self.ability:GetSpecialValueFor("bounce_interval"), (self:GetRemainingTime() - FrameTime()))
				
			-- Start interval think
			self:StartIntervalThink(self.bounce_interval)
		end)
	end
end

function modifier_Primary_hex:OnIntervalThink()
	if IsServer() then
		local hexed_enemies = 0        

		-- Find nearby enemies
		local enemies = FindUnitsInRadius(self.caster_team,
										  self.parent:GetAbsOrigin(),
										  nil,
										  self.hex_bounce_radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
										  FIND_ANY_ORDER,
										  false)

		-- Get the first enemy that is not the parent, or an hexed target
		for _,enemy in pairs(enemies) do
			if self.parent ~= enemy and not enemy:HasModifier(self.modifier_hex) and not enemy:HasModifier("modifier_Primary_hex_chain_cooldown") then

				-- Play hex sound
				EmitSoundOn(self.sound_cast, enemy)

				-- If target has Linken's Sphere off cooldown, do nothing
				if enemy:GetTeam() ~= self.caster_team then
					if enemy:TriggerSpellAbsorb(self.ability) then                        
						return nil
					end
				end     

				-- Add hex particle
				self.particle_hex_fx = ParticleManager:CreateParticle(self.particle_hex, PATTACH_CUSTOMORIGIN, enemy)     
				ParticleManager:SetParticleControl(self.particle_hex_fx, 0, enemy:GetAbsOrigin())      
				ParticleManager:ReleaseParticleIndex(self.particle_hex_fx)

				-- Give it the hex modifier
				enemy:AddNewModifier(self.caster, self.ability, self.modifier_hex, {duration = self.duration * (1 - enemy:GetStatusResistance())})

				-- Increment count
				hexed_enemies = hexed_enemies + 1

				-- Stop when enough valid enemies were hexed
				if hexed_enemies >= self.maximum_hex_enemies then
					break
				end
			end
		end
	end
end

function modifier_Primary_hex:IsHidden() return false end
function modifier_Primary_hex:IsPurgable() return true end
function modifier_Primary_hex:IsDebuff() return true end

function modifier_Primary_hex:CheckState()
	local state
	-- #2 Talent: Hexed targets have break applied to them
	if self:GetCaster():HasTalent("special_bonus_imba_lion_2") then
		state = {[MODIFIER_STATE_HEXED] = true,
				 [MODIFIER_STATE_DISARMED] = true,
				 [MODIFIER_STATE_SILENCED] = true,
				 [MODIFIER_STATE_MUTED] = true,
				 [MODIFIER_STATE_PASSIVES_DISABLED] = true}
	else
		state = {[MODIFIER_STATE_HEXED] = true,
				 [MODIFIER_STATE_DISARMED] = true,
				 [MODIFIER_STATE_SILENCED] = true,
				 [MODIFIER_STATE_MUTED] = true}
	end
				   
	return state
end

function modifier_Primary_hex:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE,
					  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}

	return decFuncs
end

function modifier_Primary_hex:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end

function modifier_Primary_hex:GetModifierMoveSpeed_Absolute()
	return self.move_speed
end

function modifier_Primary_hex:OnDestroy()
	if IsServer() then
		-- Prevent conflict with Lina's Talent. REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE !
		if self.parent:HasModifier("modifier_imba_fiery_soul_blaze_burn") then
		else
		self.parent:SetRenderColor(255,255,255)        
		end
		
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_Primary_hex_chain_cooldown", {duration = self.ability:GetSpecialValueFor("chain_hex_cooldown")})
	end
end

-- Eh, might as well make it somewhat not chain infinitely
modifier_Primary_hex_chain_cooldown = class({})

function modifier_Primary_hex_chain_cooldown:IgnoreTenacity() 	return true end
function modifier_Primary_hex_chain_cooldown:IsDebuff() 			return true end
function modifier_Primary_hex_chain_cooldown:IsHidden() 			return false end
function modifier_Primary_hex_chain_cooldown:IsPurgable() 		return false end