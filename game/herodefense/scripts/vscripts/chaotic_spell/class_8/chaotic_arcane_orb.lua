LinkLuaModifier( "modifier_chaotic_arcane_orb_attack", "chaotic_spell/class_8/chaotic_arcane_orb.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_arcane_orb_damage_delay", "chaotic_spell/class_8/chaotic_arcane_orb.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_arcane_orb = class({})
function chaotic_arcane_orb:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf", context )
end
function chaotic_arcane_orb:GetCooldown(iLevel)
	if self:GetRuneType() == 1 then
		return self:GetSpecialValueFor("rune_1_cd")
	end
	return 0
end
function chaotic_arcane_orb:GetBehavior()
	if self:GetRuneType() == 1 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior( self )
end
function chaotic_arcane_orb:OnSpellStart()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_chaotic_arcane_orb_attack")
	if not modifier then return end
	local rune_1_radius = self:GetSpecialValueFor("rune_1_radius")
	local rune_1_max = self:GetSpecialValueFor("rune_1_max")

	local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(rune_1_radius,rune_1_radius,rune_1_radius))
	DestroyParticleByDelay(particle_cast_fx,1.5)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, rune_1_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local count = 0
	
	for _, enemy in ipairs(enemies) do
		if enemy:IsAlive() then
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("rune_1_stun")})

			for enemy_i = 0, 4, 1 do
				caster:GameTimer(0.03+enemy_i*0.12,function ()
					modifier:OrbShoot_Rune1(enemy)
				end)
			end

			count = count + 1
			if count >= rune_1_max then
				break
			end
		end
	end
end

function chaotic_arcane_orb:GetIntrinsicModifierName()   return "modifier_chaotic_arcane_orb_attack" end

function chaotic_arcane_orb:OnProjectileHit_ExtraData(target, location, keys)
	if not target then return end
	if not self then return end
	local damage = keys.damage
	if not damage or damage <= 0 then return end
    local caster = self:GetCaster()

    target:AddNewModifier(caster, self, "modifier_chaotic_arcane_orb_damage_delay", {stack = damage})
end

modifier_chaotic_arcane_orb_attack = advanced_modifier({})

function modifier_chaotic_arcane_orb_attack:IsPassive()          return true end
function modifier_chaotic_arcane_orb_attack:IsBuff()				return true end
function modifier_chaotic_arcane_orb_attack:IsPurgable()     	return false end
function modifier_chaotic_arcane_orb_attack:IsPurgeException() 	return false end
function modifier_chaotic_arcane_orb_attack:IsHidden()			return true end
function modifier_chaotic_arcane_orb_attack:OnCreated()
	self.ability = self:GetAbility()
	self.base_damage = self.ability:GetSpecialValueFor("base_damage")
	self.damage = self.ability:GetSpecialValueFor("damage")*0.01
	self.mp_cost = self.ability:GetSpecialValueFor("mp_cost")*0.01
end

function modifier_chaotic_arcane_orb_attack:ADDeclareFunctions()
	return {
    	MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
	}
end

function modifier_chaotic_arcane_orb_attack:OnAttack(keys)
    if not IsServer() then return end  
	if not self.ability:GetAutoCastState() then return end
	local attacker = keys.attacker
	local target = keys.target
	local caster = self:GetCaster()

	if not self:GetAbility() then return end
	if attacker ~= caster then return end
	if not attacker:IsAlive() then return end
	if attacker:IsInSpecialAttack() then return end
	if not target:IsAlive() then return end
	
	local mana_cost = caster:GetMana()*self.mp_cost
	local damage = self.base_damage + mana_cost*self.damage
	self:OrbShoot(target, damage)
	attacker:Script_ReduceMana(mana_cost, self.ability)
end  

function modifier_chaotic_arcane_orb_attack:OrbShoot(target, damage)
	if not IsServer() then return end
	if not target or not damage or damage <= 0 then return end

	local caster = self:GetCaster()
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self.ability,	
		EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
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

function modifier_chaotic_arcane_orb_attack:OrbShoot_Rune1(target)
	if not IsServer() then return end
	if not target then return end

    local caster = self:GetCaster()
	local caster_pos_x = caster:GetAbsOrigin().x
	local caster_pos_y = caster:GetAbsOrigin().y
    local pos_source = Vector(caster_pos_x+RandomInt(-1000, 1000), caster_pos_y+RandomInt(-1000, 1000), 3500)
	local pos = target:GetAbsOrigin()
	local vec = pos-pos_source
	local travel_time = 1
	local speed= vec:Length()/travel_time
		
	local unit = CreateUnitByName("npc_attack_unit", pos_source, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(unit, nil, "modifier_thinker_INVULNERABLE", {duration = 0.5})
	unit:SetOrigin(pos_source)

	local mana_cost = caster:GetMaxMana()*self.mp_cost
	local damage = self.base_damage + mana_cost*self.damage
	local info = {
		Target = target,
		Source = unit,
		Ability = self.ability,	
		EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
		iMoveSpeed = speed,
		-- vSourceLoc = caster:GetAbsOrigin(),
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
	ProjectileManager:CreateTrackingProjectile( info )
end
-----------
modifier_chaotic_arcane_orb_damage_delay = advanced_modifier({})

function modifier_chaotic_arcane_orb_damage_delay:IsDebuff() return true end
function modifier_chaotic_arcane_orb_damage_delay:IsHidden() return false end
function modifier_chaotic_arcane_orb_damage_delay:IsPurgable() return false end
function modifier_chaotic_arcane_orb_damage_delay:IsPurgeException() return false end
function modifier_chaotic_arcane_orb_damage_delay:OnCreated(keys)
	self.mp_kill = self:GetAbility():GetSpecialValueFor("mp_kill")*0.01
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.3)
	end
end

function modifier_chaotic_arcane_orb_damage_delay:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)
	end
end
function modifier_chaotic_arcane_orb_damage_delay:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if not ability then
		self:SafeDestroy()
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
        hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
		}
	ApplyDamage(damageTable)
	if not self:GetParent():IsAlive() and caster:IsAlive() then
		caster:GiveMana(self.mp_kill*(caster:GetMaxMana()-caster:GetMana()))
	end

	self:SetStackCount(0)
	self:SafeDestroy()
end


