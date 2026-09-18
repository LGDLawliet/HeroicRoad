LinkLuaModifier("modifier_chaotic_control_winds_thinker", "chaotic_spell/class_5/chaotic_control_winds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_control_winds_buff", "chaotic_spell/class_5/chaotic_control_winds", LUA_MODIFIER_MOTION_NONE)





chaotic_control_winds = class({})


function chaotic_control_winds:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_control_winds/wind_aura/effect.vpcf", context )
end
function chaotic_control_winds:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	if self:GetRuneType() == 2 then
		radius = radius *(1+self:GetSpecialValueFor("rune_2_radius")*0.01)
	end
	return radius
end
function chaotic_control_winds:GetCooldown()
	local cd = self:GetSpecialValueFor("cd")
	if self:GetRuneType() == 3 then
		cd = self:GetSpecialValueFor("rune_3_cd")
	end
	return cd
end
function chaotic_control_winds:IsRefreshable()
	return self:GetRuneType() ~= 3
end

function chaotic_control_winds:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	if self:GetRuneType() == 2 then
		duration = duration + self:GetSpecialValueFor("rune_2_duration")
	end
	if self:GetRuneType() == 3 then
		duration = duration - self:GetSpecialValueFor("rune_3_duration")
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("rune_3_cd"))
	end
	CreateModifierThinker(caster, self, "modifier_chaotic_control_winds_thinker", {duration = duration}, pos, caster:GetTeamNumber(), false)
	if self:GetRuneType() == 3 then
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("rune_3_cd"))
	end
end
---------------


modifier_chaotic_control_winds_thinker = advanced_modifier({})

function modifier_chaotic_control_winds_thinker:IsAura()return self:GetAbility() end

function modifier_chaotic_control_winds_thinker:OnCreated(keys)
	self.team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	if self:GetAbility():GetRuneType()==1 then
		self.team = DOTA_UNIT_TARGET_TEAM_BOTH
	end
	self:GetParent().ability_gain = 	self:GetAbility():GetEffectGain()
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		if self:GetAbility():GetRuneType()==2 then
			self.radius = self.radius*(1+self:GetAbility():GetSpecialValueFor("rune_2_radius")*0.01)
		end
		local parent = self:GetParent()
		parent:EmitSound("Hero_Windrunner.GaleForce")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_control_winds/wind_aura/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl( self.particle, 1, Vector(self.radius,self.radius,self.radius))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_control_winds_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end

function modifier_chaotic_control_winds_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end


function modifier_chaotic_control_winds_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_control_winds_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_control_winds_thinker:GetAuraSearchTeam() return self.team end
function modifier_chaotic_control_winds_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC  end
function modifier_chaotic_control_winds_thinker:GetAuraDuration() return 1.05 end
function modifier_chaotic_control_winds_thinker:GetModifierAura()return "modifier_chaotic_control_winds_buff" end
function modifier_chaotic_control_winds_thinker:GetAuraEntityReject(hEntity)
	if not hEntity:IsRealHero() and not IsEnemy(self:GetParent(),hEntity) then
		return true
	end
	return false
end


-- ---------



modifier_chaotic_control_winds_buff = advanced_modifier({})

function modifier_chaotic_control_winds_buff:IsHidden() 			return false end
function modifier_chaotic_control_winds_buff:IsPurgable() 			return false end
function modifier_chaotic_control_winds_buff:IsPurgeException() 	return false end
function modifier_chaotic_control_winds_buff:IsDebuff() return self.debuff end
function modifier_chaotic_control_winds_buff:OnCreated(keys)
	self.debuff = IsEnemy(self:GetParent(),self:GetCaster())
	local gain = 1
	if self:GetAuraOwner() then
		gain = self:GetAuraOwner().ability_gain or 1
	end
	local rune_2 = 1
	if self:GetAbility():GetRuneType() == 2 then
		rune_2 = rune_2 + self:GetAbility():GetSpecialValueFor("rune_2_index")*0.01
	end
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move")*gain*rune_2
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")*gain*rune_2
	self.bonus_projectile_speed = self:GetAbility():GetSpecialValueFor("bonus_projectile_speed")*gain*rune_2
	self.rune_3_incoming = self:GetAbility():GetSpecialValueFor("rune_3_incoming")

	self.bonus_default_move = self:GetAbility():GetSpecialValueFor("bonus_default_move")
	if self.debuff and self:GetAbility():GetRuneType()==1 then
		self.bonus_move_speed = -self.bonus_move_speed * self:GetAbility():GetSpecialValueFor("rune_1_bonus")*0.01
		self.bonus_attack_speed = -self.bonus_attack_speed * self:GetAbility():GetSpecialValueFor("rune_1_bonus")*0.01
		self.bonus_projectile_speed = -self.bonus_projectile_speed * self:GetAbility():GetSpecialValueFor("rune_1_bonus")*0.01
	end
end




function modifier_chaotic_control_winds_buff:DeclareFunctions()

    local funcs = 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
	if self:GetAbility():GetRuneType()== 3 then
		table.insert(funcs,MODIFIER_PROPERTY_INVISIBILITY_LEVEL)
	end
	return funcs
end
function modifier_chaotic_control_winds_buff:GetModifierInvisibilityLevel() 
	return self:GetAbility():GetRuneType()== 3
end
function modifier_chaotic_control_winds_buff:GetModifierMoveSpeedBonus_Constant() return   self.bonus_move_speed end
function modifier_chaotic_control_winds_buff:GetModifierAttackSpeedBonus_Constant() return self.bonus_attack_speed end
function modifier_chaotic_control_winds_buff:GetModifierProjectileSpeedBonus() return self.bonus_projectile_speed end
function modifier_chaotic_control_winds_buff:CheckState()
	if self:GetAbility():GetRuneType() == 3 then
		return{
			[MODIFIER_STATE_INVISIBLE] = true,
		}
	end
end
function modifier_chaotic_control_winds_buff:ADDeclareFunctions()
    local funcs =  
    {
		advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE,
    }
	if self:GetAbility():GetRuneType() == 3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
	return funcs
end
function modifier_chaotic_control_winds_buff:Advanced_GetModifier_DefaultMoveCastRange()
	return self.bonus_default_move
end
function modifier_chaotic_control_winds_buff:Advanced_GetModifierIncomingDamage_Percentage()
	return -self.rune_3_incoming
end


