LinkLuaModifier( "modifier_chaotic_chilling_touch_attack", "chaotic_spell/class_6/chaotic_chilling_touch.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_chilling_touch_damage_delay", "chaotic_spell/class_6/chaotic_chilling_touch.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_chilling_touch_slow", "chaotic_spell/class_6/chaotic_chilling_touch.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_chilling_touch_rune1", "chaotic_spell/class_6/chaotic_chilling_touch.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_chilling_touch = class({})

function chaotic_chilling_touch:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/ice_blast/effect.vpcf", context )
end

function chaotic_chilling_touch:GetIntrinsicModifierName()   return "modifier_chaotic_chilling_touch_attack" end

function chaotic_chilling_touch:OnProjectileHit_ExtraData(target, location, keys)
	if not target then return end
	if not self then return end
	local damage = keys.damage
	if not damage or damage <= 0 then return end
    local caster = self:GetCaster()

    
    local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
    local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
    local slow_duration = math.max(0.3*StatusResistance, 0.05)
    target:AddNewModifier(caster, self, "modifier_chaotic_chilling_touch_slow", {duration = slow_duration})
    target:AddNewModifier(caster, self, "modifier_chaotic_chilling_touch_damage_delay", {stack = damage})
end

modifier_chaotic_chilling_touch_attack = advanced_modifier({})

function modifier_chaotic_chilling_touch_attack:IsPassive()          return true end
function modifier_chaotic_chilling_touch_attack:IsBuff()				return true end
function modifier_chaotic_chilling_touch_attack:IsPurgable()     	return false end
function modifier_chaotic_chilling_touch_attack:IsPurgeException() 	return false end
function modifier_chaotic_chilling_touch_attack:IsHidden()			return true end
function modifier_chaotic_chilling_touch_attack:OnCreated()
	self.ability = self:GetAbility()
	self.base_damage = self.ability:GetSpecialValueFor("base_damage")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.bonus_range = self.ability:GetSpecialValueFor("bonus_range")
    self.type = self.ability:GetRuneType()

    self.rune_1_radius = self.ability:GetSpecialValueFor("rune_1_radius")
    self.rune_1_max = self.ability:GetSpecialValueFor("rune_1_max")
    self.rune_1_damage = self.ability:GetSpecialValueFor("rune_1_damage")
    self.rune_1_duration = self.ability:GetSpecialValueFor("rune_1_duration")

end

function modifier_chaotic_chilling_touch_attack:ADDeclareFunctions()
	local funcs = {
    	MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
	}

    return funcs
end

function modifier_chaotic_chilling_touch_attack:Advanced_GetModifierAttackRangeBonus()
    local parent = self:GetParent()
    if self.ability:GetAutoCastState() and parent:IsRangedAttacker() then
        return self.bonus_range
    end
    return 0
end

function modifier_chaotic_chilling_touch_attack:OnAttack(keys)
    if not IsServer() then return end  
	if not self.ability:GetAutoCastState() then return end
	local attacker = keys.attacker
	local target = keys.target
	local caster = self:GetCaster()
    if not self.ability:IsOwnersManaEnough() then return end

	if not self:GetAbility() then return end
	if attacker ~= caster then return end
	if not attacker:IsAlive() then return end
	if attacker:IsInSpecialAttack() then return end
	if not target:IsAlive() then return end
	

	local damage = self.base_damage + attacker:HDGetPrimaryStatValue()*self.damage
	self:OrbShoot(target, damage)
	self.ability:UseResources(true, true, true, true)
end  

function modifier_chaotic_chilling_touch_attack:OrbShoot(target, damage)
	if not IsServer() then return end
	if not target or not damage or damage <= 0 then return end

	local caster = self:GetCaster()
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self.ability,	
		EffectName = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf",
		iMoveSpeed = 1500,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = false,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = true, --提供视野
		ExtraData = {
			damage = damage,
		}--额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function modifier_chaotic_chilling_touch_attack:OnDeath(keys)
    if not IsServer() then return end  
    if not self:GetAbility() then return end
	if not self.ability:GetAutoCastState() then return end
	local attacker = keys.attacker
	local unit = keys.unit
	local caster = self:GetCaster()
	if attacker ~= caster then return end
    if self.type ~= 1 then return end
    
	local slow = unit:HasModifier("modifier_chaotic_chilling_touch_slow") or unit:HasModifier("modifier_chaotic_chilling_touch_rune1")
    if slow then
       local pos = unit:GetAbsOrigin()
       self:Rune1_Icekill(pos)
    end
end  

function modifier_chaotic_chilling_touch_attack:Rune1_Icekill(pos)
    if not pos then return end
    local caster = self:GetParent()

    local damageTable = {
        --victim = unit,
        attacker = caster,
        damage =  caster:HDGetPrimaryStatValue()*self.rune_1_damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
        ability = self.ability,
        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
    }

	local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/items/ice_blast/effect.vpcf", PATTACH_WORLDORIGIN , caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(self.rune_1_radius,0,0))
	DestroyParticleByDelay(particle_cast_fx,4)
    caster:EmitSoundParams("Hero_Crystal.CrystalNova", 0, 0.3, 0)

    local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self.rune_1_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _, unit in ipairs(units) do
        
        local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
        local StatusResistance = unit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
        unit:AddNewModifier(caster, self.ability, "modifier_chaotic_chilling_touch_rune1", {duration =  self.rune_1_duration*StatusResistance})
        
        damageTable.victim = unit
        ApplyDamage(damageTable)
    end
end
-----------
modifier_chaotic_chilling_touch_rune1 = advanced_modifier({})

function modifier_chaotic_chilling_touch_rune1:IsDebuff() return true end
function modifier_chaotic_chilling_touch_rune1:IsHidden() return true end
function modifier_chaotic_chilling_touch_rune1:IsPurgable() return false end
function modifier_chaotic_chilling_touch_rune1:IsPurgeException() return false end
function modifier_chaotic_chilling_touch_rune1:CheckState()
    return{
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
    }
end
-----------
modifier_chaotic_chilling_touch_damage_delay = advanced_modifier({})

function modifier_chaotic_chilling_touch_damage_delay:IsDebuff() return true end
function modifier_chaotic_chilling_touch_damage_delay:IsHidden() return false end
function modifier_chaotic_chilling_touch_damage_delay:IsPurgable() return false end
function modifier_chaotic_chilling_touch_damage_delay:IsPurgeException() return false end
function modifier_chaotic_chilling_touch_damage_delay:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.29)
	end
end

function modifier_chaotic_chilling_touch_damage_delay:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end
function modifier_chaotic_chilling_touch_damage_delay:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if not ability then
		self:SafeDestroy()
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = caster,
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
        hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
		}
	ApplyDamage(damageTable)

	self:SetStackCount(0)
	self:SafeDestroy()
end
----
modifier_chaotic_chilling_touch_slow = advanced_modifier({})

function modifier_chaotic_chilling_touch_slow:IsDebuff()        return true end
function modifier_chaotic_chilling_touch_slow:IsPurgable()     	return false end
function modifier_chaotic_chilling_touch_slow:IsPurgeException() 	return false end
function modifier_chaotic_chilling_touch_slow:IsHidden()			return true end
function modifier_chaotic_chilling_touch_slow:OnCreated()
	self.ability = self:GetAbility()
	self.slow = self.ability:GetSpecialValueFor("slow")
end

function modifier_chaotic_chilling_touch_slow:DeclareFunctions()
	return {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_chaotic_chilling_touch_slow:GetModifierMoveSpeedBonus_Constant()
    if not self:GetAbility() then self:Destroy() return end
    return -self.slow
end
