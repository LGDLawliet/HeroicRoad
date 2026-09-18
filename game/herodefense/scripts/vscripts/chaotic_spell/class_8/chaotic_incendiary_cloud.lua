LinkLuaModifier("modifier_chaotic_incendiary_cloud_thinker", "chaotic_spell/class_8/chaotic_incendiary_cloud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_incendiary_cloud_debuff", "chaotic_spell/class_8/chaotic_incendiary_cloud", LUA_MODIFIER_MOTION_NONE)

chaotic_incendiary_cloud = class({})



function chaotic_incendiary_cloud:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_incendiary_cloud/main_effect/effect.vpcf", context )
end
function chaotic_incendiary_cloud:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_incendiary_cloud:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local thinker = CreateUnitByName("npc_dota_thinker", pos, false, caster, caster, caster:GetTeam())
	if thinker then
		thinker:AddNewModifier(caster, self, "modifier_chaotic_incendiary_cloud_thinker", {duration =   self:GetSpecialValueFor("duration")})
	end
end

----
modifier_chaotic_incendiary_cloud_thinker = advanced_modifier({})

function modifier_chaotic_incendiary_cloud_thinker:IsAura()return true end
function modifier_chaotic_incendiary_cloud_thinker:OnCreated(keys)

	self:GetParent().chaotic_incendiary_cloud_thinker = self
	self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
	if IsServer() then
		self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.distance = self:GetAbility():GetSpecialValueFor("distance")
		local parent = self:GetParent()
		parent:EmitSound("Hero_Zuus.Cloud.Cast")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_incendiary_cloud/main_effect/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( self.particle,1, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,60,Vector(self.radius,1,1))
		-- ParticleManager:SetParticleControl(self.particle,10,Vector(self:GetRemainingTime(),1,1))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_incendiary_cloud_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_incendiary_cloud_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
	if self:GetAbility():GetRuneType()==1 then
		if self:GetParent():IsMoving() then
			self:SetStackCount(0)
		else
			
			self:IncrementStackCount()
		end
	end
	if CalculateDistance(self:GetParent(),self:GetCaster())>=self.distance then
		self:GetParent():MoveToPosition(self:GetCaster():GetOrigin())
	end
	
end
function modifier_chaotic_incendiary_cloud_thinker:GetRune1Bonus()
	return 1+self:GetStackCount()*self.rune_1_bonus*0.01
end

function modifier_chaotic_incendiary_cloud_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_incendiary_cloud_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_incendiary_cloud_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chaotic_incendiary_cloud_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_incendiary_cloud_thinker:GetAuraDuration() return 0.05 end
function modifier_chaotic_incendiary_cloud_thinker:GetModifierAura()return "modifier_chaotic_incendiary_cloud_debuff" end
function modifier_chaotic_incendiary_cloud_thinker:GetAuraEntityReject(hEntity)
	return false
end
function modifier_chaotic_incendiary_cloud_thinker:DeclareFunctions() 
		return {

		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX


	}
end

function modifier_chaotic_incendiary_cloud_thinker:GetModifierMoveSpeed_AbsoluteMin(keys)
	if IsServer() then
		return self.move_speed 
	end
end
function modifier_chaotic_incendiary_cloud_thinker:GetModifierMoveSpeed_AbsoluteMax(keys)
	if IsServer() then
		return self.move_speed 
	end
end
function modifier_chaotic_incendiary_cloud_thinker:CheckState()
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



modifier_chaotic_incendiary_cloud_debuff = advanced_modifier({})

function modifier_chaotic_incendiary_cloud_debuff:IsHidden() 			return false end
function modifier_chaotic_incendiary_cloud_debuff:IsPurgable() 			return false end
function modifier_chaotic_incendiary_cloud_debuff:IsPurgeException() 	return false end
function modifier_chaotic_incendiary_cloud_debuff:IsDebuff() return true end
function modifier_chaotic_incendiary_cloud_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.move_speed_reduction = -ability:GetSpecialValueFor("move_slow")
	self.rune_type = ability:GetRuneType()
	self.rune_2_bonus = ability:GetSpecialValueFor("rune_2_bonus")
	self.rune_3_poison = ability:GetSpecialValueFor("rune_3_poison")*0.01
	if IsServer() then
		self.timer = GameRules:GetGameTime()
		self.base_damage = ability:GetSpecialValueFor( "base_damage" )
		self.bonus_damage = ability:GetSpecialValueFor( "bonus_damage" )

		self.gain_per_tick = ability:GetSpecialValueFor( "gain_per_tick" )*0.01
		self.max_gain_per_tick = ability:GetSpecialValueFor( "max_gain_per_tick" )*0.01

		self.interval = ability:GetSpecialValueFor("interval")
		self:StartIntervalThink(self.interval)
	end
end
function modifier_chaotic_incendiary_cloud_debuff:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	self:StartIntervalThink(self.interval)
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local damage = self.base_damage + self.bonus_damage*caster:HDGetPrimaryStatValue()
	damage = damage * (1+math.min((GameRules:GetGameTime()-self.timer)*self.gain_per_tick,self.max_gain_per_tick))

	parent:Burning(self.caster, self.ability, damage)
	if self.rune_type == 3 then
		parent:Poison(self.caster, self.ability, damage*self.rune_3_poison)
	end
end



function modifier_chaotic_incendiary_cloud_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_incendiary_cloud_debuff:GetModifierMoveSpeedBonus_Constant() 
	if self.rune_type==1 then
		local gain = 1
		if self:GetAuraOwner() and IsValid(self:GetAuraOwner().chaotic_incendiary_cloud_thinker) then
			gain = self:GetAuraOwner().chaotic_incendiary_cloud_thinker:GetRune1Bonus()
		end
		return self.move_speed_reduction * gain
	end
	return   self.move_speed_reduction 
end
function modifier_chaotic_incendiary_cloud_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end

function modifier_chaotic_incendiary_cloud_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	if IsFireDamage(keys) then
		return self.rune_2_bonus
	end
end

function modifier_chaotic_incendiary_cloud_debuff:ADDeclareFunctions()
	local funcs = {}
	if self:GetAbility():GetRuneType()==2 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
    return funcs
end