
-- "When Batrider dies during Firefly, the already existing fire on the ground still stays for the remaining duration."
--   "The buffs remain visible in the HUD, and are now only responsible for keeping the already existing fire up."
--   "This means when respawning before they expire, they do not make Batrider fly again or make him leave fire behind again."

-- Okay, to somewhat explain what's going on in this block:
--   When Batrider dies, check for any existing Firefly modifiers
--   Because the modifier is only supposed to persist to keep lingering flames alive, if Batrider was using the Quiet Flight IMBAfication, there are no flames to preserve so we can safely destroy it
--   Otherwise, make the thinker that followed Batrider to produce the flames STOP following so it'll just continue producing on the spot where Batrider died
--   Then set the modifier stack count to -1, which has logic set to not do flight or create new damage spots in that scenario
--   Then, remove the ember_particle which dealt with flame drops and sparks around Batrider
--   (Also remove any true sight modifiers as a result of the talent)
--   Finally, if any firefly modifiers existed, destroy the firefly loop sound early

LinkLuaModifier("modifier_creeps_spell_The_Road_Of_Dark_Thunder", "creeps_spell/creeps_spell_The_Road_Of_Dark_Thunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker", "creeps_spell/creeps_spell_The_Road_Of_Dark_Thunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive", "creeps_spell/creeps_spell_The_Road_Of_Dark_Thunder", LUA_MODIFIER_MOTION_NONE)
creeps_spell_The_Road_Of_Dark_Thunder = class({})
function creeps_spell_The_Road_Of_Dark_Thunder:GetIntrinsicModifierName() return "modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive" end
function creeps_spell_The_Road_Of_Dark_Thunder:OnOwnerDied()
	local firefly_modifiers = self:GetCaster():FindAllModifiersByName("modifier_creeps_spell_The_Road_Of_Dark_Thunder")
	
	for _, mod in pairs(firefly_modifiers) do
		if not mod.firefly_thinker or mod.firefly_thinker:IsNull() then
			mod:SafeDestroy()
		else
			mod.firefly_thinker:FollowEntity(nil, false)
			mod:SetStackCount(-1)
			ParticleManager:DestroyParticle(mod.ember_particle, false)
			ParticleManager:ReleaseParticleIndex(mod.ember_particle)
		end
		

	end
	
	if #firefly_modifiers >= 1 then
		self:GetCaster():StopSound("Hero_Batrider.Firefly.loop")
	end
end

modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive = class({})
function modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive:IsHidden()	return true end
function modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive:IsPurgable() 		return false end
function modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive:RemoveOnDeath()  return false end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive:OnCreated()

	if not IsServer() then return end
    if _G.GAME_DIFFICULTY<=3 then
        return
    end
	 self:StartIntervalThink(3)
end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder_passive:OnIntervalThink()

	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then
		return
	end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_The_Road_Of_Dark_Thunder", {duration= 10})
  
end

------------------------------------
-- MODIFIER_creeps_spell_The_Road_Of_Dark_Thunder --
------------------------------------
modifier_creeps_spell_The_Road_Of_Dark_Thunder = class({})
function modifier_creeps_spell_The_Road_Of_Dark_Thunder:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_The_Road_Of_Dark_Thunder:IsPurgable()	return false end
function modifier_creeps_spell_The_Road_Of_Dark_Thunder:IsHidden()	return true end
function modifier_creeps_spell_The_Road_Of_Dark_Thunder:RemoveOnDeath()	return true end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder:OnCreated()

	if not IsServer() then return end
	
	self.damage_per_second	= self:GetAbility():GetSpecialValueFor("damage")*self:GetParent():GetBaseDamageMax()
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.tick_interval		= 1
	
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	self.damage_table		= {
		victim 			= nil,
		damage 			= self.damage_per_second * self.tick_interval,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	-- Use these to track where and which enemies to be damaged
	self.damage_spots		= {}
	self.damaged_enemies	= {}
	
	self.think_interval		= 0.2
	self.counter			= 0
	-- Keep IntervalThink at 0.1 seconds (for damage spot drops + tree destruction), but change time_to_tick based on when it should do damage
	self.time_to_tick		= 0.1

	self.firefly_debuff_particle	= nil
	self:GetParent():EmitSound("Hero_Batrider.Firefly.loop")
		
	self.ember_particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/dark_role/new_effect_dark_path.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.ember_particle, 11, Vector(1, 0, 0))
	self:AddParticle(self.ember_particle, false, false, -1, false, false)
		
	self.firefly_thinker = CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker", {duration = self:GetRemainingTime()}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	self:SetStackCount(1)
	self:StartIntervalThink(self.think_interval)
end

-- IntervalThink only starts once self.firefly_thinker exists (which handles flame drops)
function modifier_creeps_spell_The_Road_Of_Dark_Thunder:OnIntervalThink()
	self.counter	= self.counter + self.think_interval

	-- Stack count goes to -1 if Batrider dies, otherwise just do things normally
	if self:GetStackCount() >= 0 then
		table.insert(self.damage_spots, self:GetParent():GetAbsOrigin())
		
	end

	if self.counter >= self.time_to_tick then
		for damage_spot = 1, #self.damage_spots do
			self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.damage_spots[damage_spot], nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			
			for _, enemy in pairs(self.enemies) do
				if not self.damaged_enemies[enemy] then
					self.damage_table.victim = enemy

					ApplyDamage(self.damage_table)
					self.damaged_enemies[enemy] = true

				end
			end
		end
		
		self.counter = 0
		-- Clear out damaged enemies table for next interval
		self.damaged_enemies = {}
	end

	-- "Deals 5/15/25/35 damage in 0.4 or 0.5 seconds intervals, starting 0.1 seconds after cast, the first interval is 0.4 seconds, the rest are 0.5 seconds, resulting in 31 (Talent 47) damage instances."
	if self:GetElapsedTime() < self.tick_interval then
		self.time_to_tick = 0.4
	else
		self.time_to_tick = 1
	end
end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder:OnDestroy()
	if not IsServer() then return end
	
	if self:GetStackCount() >= 0 then
		self:GetParent():StopSound("Hero_Batrider.Firefly.loop")
	end
	

end





--------------------------------------------
-- MODIFIER_creeps_spell_The_Road_Of_Dark_Thunder_THINKER --
--------------------------------------------
modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker = class({})
function modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker:IsPurgable() return false end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker:CheckState() return {
	-- keep thinker visible by everyone, so the firefly ground pfx don't disappear when batrider is no longer visible
	[MODIFIER_STATE_PROVIDES_VISION] = true,
} end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker:OnCreated()
	if not IsServer() then return end
	
	self.firefly_particle = ParticleManager:CreateParticle("particles/new_effect/new_effect/dark_role/new_effect_dark_batrider_firefly.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- The immortal particle effect doesn't have CP11 set to (1, 0, 0) which basically ends up making the flames invisible, so I have to force it here
	ParticleManager:SetParticleControl(self.firefly_particle, 11, Vector(1, 0, 0))
	self:AddParticle(self.firefly_particle, false, false, -1, false, false)
	
	self:StartIntervalThink(0.1)
end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if not caster or not caster:IsAlive() or  caster:IsNull() or not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end
	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
end

function modifier_creeps_spell_The_Road_Of_Dark_Thunder_thinker:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveSelf()
end
