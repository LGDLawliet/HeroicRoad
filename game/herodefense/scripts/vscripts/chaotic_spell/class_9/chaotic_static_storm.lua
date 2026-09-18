LinkLuaModifier("modifier_chaotic_static_storm_thinker", "chaotic_spell/class_9/chaotic_static_storm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_static_storm_debuff", "chaotic_spell/class_9/chaotic_static_storm", LUA_MODIFIER_MOTION_NONE)
chaotic_static_storm = class({})

function chaotic_static_storm:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_static_storm/effect.vpcf", context )
end
function chaotic_static_storm:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_static_storm:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local thinker = CreateUnitByName("npc_dota_thinker", pos, false, caster, caster, caster:GetTeam())
	if thinker then
		thinker:AddNewModifier(caster, self, "modifier_chaotic_static_storm_thinker", {duration =   self:GetSpecialValueFor("duration")})
	end
end


modifier_chaotic_static_storm_thinker = advanced_modifier({})

function modifier_chaotic_static_storm_thinker:IsAura()return true end
function modifier_chaotic_static_storm_thinker:OnCreated(keys)

	self:GetParent().chaotic_static_storm_thinker = self
	self.grow = self:GetAbility():GetSpecialValueFor("grow")*0.01
	self.index = 1
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		if not self:GetCaster():IsHero() then
			self.radius = self.radius *1.4
		end
		local parent = self:GetParent()
		parent:EmitSound("Hero_Zuus.Cloud.Cast")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_static_storm/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,0,0))
		ParticleManager:SetParticleControl(self.particle,2,Vector(self.duration+1,0,0))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_static_storm_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_static_storm_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	self.index = self.index + self.grow
	local parent = self:GetParent()
	local units = FindUnitsInRadius(
		parent:GetTeamNumber(),	
		parent:GetOrigin(),
		nil,	
		self.radius,	
		 DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		 DOTA_UNIT_TARGET_FLAG_NONE,	
		FIND_ANY_ORDER,	
		false	
	)
	for _,unit in pairs(units) do
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaotic_static_storm_debuff", {duration = 1, index = self.index})
	end
end

function modifier_chaotic_static_storm_thinker:CheckState()
	return{
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	}
end

modifier_chaotic_static_storm_debuff = advanced_modifier({})

function modifier_chaotic_static_storm_debuff:IsHidden() 			return true end
function modifier_chaotic_static_storm_debuff:IsPurgable() 			return false end
function modifier_chaotic_static_storm_debuff:IsPurgeException() 	return false end
function modifier_chaotic_static_storm_debuff:IsDebuff() return true end
function modifier_chaotic_static_storm_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	self.rune_type = ability:GetRuneType()
	self.rune_1_max = ability:GetSpecialValueFor("rune_1_max")*0.01
	if IsServer() then
		self.index = keys.index or 1
		self.timer = GameRules:GetGameTime()
		local caster = self:GetCaster()
		self.base_damage = ability:GetSpecialValueFor( "damage" )
		self.bonus_damage = ability:GetSpecialValueFor( "bonus_damage" )
		self.elecshocking = ability:GetSpecialValueFor("elecshocking")
		self.damageTable = {
			victim = self:GetParent(),
			attacker = caster,
			-- damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}

		self.interval = ability:GetSpecialValueFor("interval")
		self:StartIntervalThink(self.interval)
	end
end
function modifier_chaotic_static_storm_debuff:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	local caster = self:GetCaster()
	local damage = self.base_damage + self.bonus_damage*caster:HDGetPrimaryStatValue()
	damage = damage * (1+self.index)
	if not self:GetCaster():IsHero() then
		damage = damage *0.7
	end

	if self.rune_type == 1 then
		damage = math.random(1,self.rune_1_max*damage)
		if damage == 1 or damage == self.rune_1_max*damage then
			self:GetAbility():EndCooldown()
		end
	end
	self:GetParent():Elecshocking(caster, self:GetAbility(), self.elecshocking)
	self.damageTable.damage = damage
	ApplyDamage(self.damageTable)
end