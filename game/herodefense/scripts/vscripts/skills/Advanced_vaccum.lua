
Advanced_vaccum = class({})
LinkLuaModifier( "modifier_Advanced_vaccum", "skills/Advanced_vaccum", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_Advanced_vaccum_slow", "skills/Advanced_vaccum", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_vaccum_mana", "skills/Advanced_vaccum", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_vaccum_break", "skills/Advanced_vaccum", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_vaccum_vur", "skills/Advanced_vaccum", LUA_MODIFIER_MOTION_NONE )
function Advanced_vaccum:Precache( context )
	PrecacheResource( "particle","particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", context )
end

function Advanced_vaccum:CheckKV(key)
	local table = {
        damage = 5,
		bonus_damage = 0.1,
		radius = 10,
	}
	local value = table[key] or -1
	return value
end

function Advanced_vaccum:UnlockFirstCore(key)
	return false
end
function Advanced_vaccum:UnlockSecondCore(key)
	return false
end
function Advanced_vaccum:UnlockThirdCore(key)
	return false
end

function Advanced_vaccum:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function Advanced_vaccum:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor( "duration" )
	self.mana_duration = self:GetSpecialValueFor("mana_duration")
	self.mana_cost = self:GetSpecialValueFor("mana_cost")
	self.advanced_level = self:GetSpecialValueFor("advanced_level")
	if self.advanced_level >= 15 then
		self.mana_cost = 10
	end
	

	local enemies = FindUnitsInRadius(caster:GetTeamNumber() ,point ,nil ,radius ,DOTA_UNIT_TARGET_TEAM_ENEMY ,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,0 ,false)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster,self,"modifier_Advanced_vaccum",{duration = duration, x = point.x, y = point.y,})
	end

	self:PlayEffects( point, radius )
	caster:AddNewModifier(caster,self,"modifier_Advanced_vaccum_mana",{duration = self.mana_duration , stack = self.mana_cost})
end


function Advanced_vaccum:PlayEffects( point, radius )

	local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf"
	local sound_cast = "Hero_Dark_Seer.Vacuum"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

-------------------------------------------------------------------
modifier_Advanced_vaccum = advanced_modifier({})

function modifier_Advanced_vaccum:IsHidden()return false end
function modifier_Advanced_vaccum:IsDebuff()return true end
function modifier_Advanced_vaccum:IsStunDebuff()return true end
function modifier_Advanced_vaccum:IsPurgable()return false end


function modifier_Advanced_vaccum:OnCreated( kv )
    if not IsServer() then
        return
    end

	self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	local center = Vector( kv.x, kv.y, 0 )
	self.direction = center - self:GetParent():GetOrigin()
	self.speed = self.direction:Length2D()/self:GetDuration()
	self.direction.z = 0
	self.direction = self.direction:Normalized()

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

function modifier_Advanced_vaccum:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Advanced_vaccum:OnDestroy()
	if not IsServer() then
        return
    end
	self:GetParent():RemoveHorizontalMotionController( self )

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(), --Optional.
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        
	}
	ApplyDamage(damageTable)
    self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.05}) --提供相位，防止卡位
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_vaccum_slow", {duration=self:GetAbility():GetSpecialValueFor("slow_duration")})
	--LV10压缩破坏
	if self:GetAbility().advanced_level >= 10 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_vaccum_break", {duration=1.5})
	end
	--LV20空间崩落
	if self:GetAbility().advanced_level >= 20 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_vaccum_vur", {duration=10000})
	end
end

function modifier_Advanced_vaccum:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_Advanced_vaccum:UpdateHorizontalMotion( me, dt )
	local target = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( target )
end

function modifier_Advanced_vaccum:OnHorizontalMotionInterrupted()
	self:Destroy()
end

--------------------------------------------------------------------
modifier_Advanced_vaccum_slow = advanced_modifier({})

function modifier_Advanced_vaccum_slow:IsHidden()return true end
function modifier_Advanced_vaccum_slow:IsDebuff()return true end
function modifier_Advanced_vaccum_slow:IsPurgable()return false end

function modifier_Advanced_vaccum_slow:OnCreated()
	if IsServer() then
		self.slow = self:GetAbility():GetSpecialValueFor("move_down")
		--LV5区域重压+
		if self:GetAbility().advanced_level >= 5 then
			self.slow = 80
		end
		self:SetStackCount(self.slow)
		self:StartIntervalThink(0.05)
	end
end	

function modifier_Advanced_vaccum_slow:OnRefresh()
	if IsServer() then 
		self.slow = self:GetAbility():GetSpecialValueFor("move_down")
		--LV5区域重压+
		if self:GetAbility().advanced_level >= 5 then
			self.slow = 80
		end
		self:SetStackCount(self.slow)
	end
end	

function modifier_Advanced_vaccum_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetStackCount()
end

function modifier_Advanced_vaccum_slow:OnIntervalThink()
	self:SetStackCount(math.max(self:GetStackCount() - self.slow*0.05 , 0))
end

function modifier_Advanced_vaccum_slow:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end



--------------------------------------------------------------------
modifier_Advanced_vaccum_mana = advanced_modifier({})

function modifier_Advanced_vaccum_mana:IsHidden()return false end
function modifier_Advanced_vaccum_mana:IsDebuff()return true end
function modifier_Advanced_vaccum_mana:IsPurgable()return false end


function modifier_Advanced_vaccum_mana:OnCreated(keys)
	if not IsServer() then
		return
	end
	self.mana_cost = keys.stack
	self:SetStackCount(self.mana_cost)
end	

function modifier_Advanced_vaccum_mana:OnRefresh(keys)
	if not IsServer() then
		return
	end
	self.mana_cost = keys.stack
	self:SetStackCount(self:GetStackCount() + self.mana_cost)
end	

function modifier_Advanced_vaccum_mana:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_Advanced_vaccum_mana:GetModifierPercentageManacostStacking()
	return -self:GetStackCount()
end
function modifier_Advanced_vaccum_mana:OnTooltip()
	return self:GetStackCount()
end

--------------------------------------------------------------------
modifier_Advanced_vaccum_break = advanced_modifier({})

function modifier_Advanced_vaccum_break:IsHidden()return true end
function modifier_Advanced_vaccum_break:IsDebuff()return true end
function modifier_Advanced_vaccum_break:IsPurgable()return false end
function modifier_Advanced_vaccum_break:CheckState()
	return{
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
end
--------------------------------------------------------------------
modifier_Advanced_vaccum_vur = advanced_modifier({})

function modifier_Advanced_vaccum_vur:IsHidden()return true end
function modifier_Advanced_vaccum_vur:IsDebuff()return true end
function modifier_Advanced_vaccum_vur:IsPurgable()return false end
function modifier_Advanced_vaccum_vur:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_Advanced_vaccum_vur:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self:GetParent() then
		return
	end
	if keys.attacker == self:GetParent() then
		return
	end
	return 50
end
function modifier_Advanced_vaccum_vur:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	self:SafeDestroy()
end	