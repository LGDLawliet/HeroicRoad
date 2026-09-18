Advanced_hunter_in_the_night = class({})
require('internal/timers')   --计时器功能

LinkLuaModifier("modifier_Advanced_hunter_in_the_night", "skills/Advanced_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hunter_in_the_night_active", "skills/Advanced_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hunter_in_the_night_debuff", "skills/Advanced_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hunter_in_the_night_already", "skills/Advanced_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_hunter_in_the_night_lv20", "skills/Advanced_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)

function Advanced_hunter_in_the_night:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/hunter_in_the_night/spattack.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/hunter_in_the_night/debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", context )
end

function Advanced_hunter_in_the_night:CheckKV(key)
	local table = {
		bonus_attack_speed = 8,
		spattack = 1,
	}
	local value = table[key] or -1
	return value
end

function Advanced_hunter_in_the_night:GetIntrinsicModifierName() return "modifier_Advanced_hunter_in_the_night" end


modifier_Advanced_hunter_in_the_night= advanced_modifier({})

function modifier_Advanced_hunter_in_the_night:IsDebuff()			return false end
function modifier_Advanced_hunter_in_the_night:IsHidden() 			return true end
function modifier_Advanced_hunter_in_the_night:IsPurgable() 		return false end
function modifier_Advanced_hunter_in_the_night:IsPurgeException() 	return false end

function modifier_Advanced_hunter_in_the_night:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.line = self:GetAbility():GetSpecialValueFor("line")
	self.spattack = (self:GetAbility():GetSpecialValueFor("spattack") - 100)
	
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	

	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_Advanced_hunter_in_the_night:OnDestroy()
	if not IsServer() then
		return
	end
	-- 清除重击标记
	local caster = self:GetParent()
	local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        100000,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByNameAndCaster("modifier_Advanced_hunter_in_the_night_debuff",caster)
        if modifier then
			modifier:SafeDestroy()
		end
		local modifier2= enemy:FindModifierByNameAndCaster("modifier_Advanced_hunter_in_the_night_already",caster)
        if modifier2 then
			modifier2:SafeDestroy()
		end
    end
end

function modifier_Advanced_hunter_in_the_night:OnIntervalThink()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self.spattack = (self:GetAbility():GetSpecialValueFor("spattack") - 100)
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	-- LV5
	if self.advanced_level >= 5 then
		self.line = 75
	end
	local caster = self:GetParent()

	-- 重击标记
	local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false
    )
    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_hunter_in_the_night_debuff", {duration = self.interval})
        break
    end

	-- 黑夜白天判断
	if not self:GetParent():IsInNightTime() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_night_stalker_2") then
		self:SetStackCount(1)
	end
end

function modifier_Advanced_hunter_in_the_night:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ORDER,
	} 
end

function modifier_Advanced_hunter_in_the_night:ADDeclareFunctions() 
	return {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil}
	} 
end

function modifier_Advanced_hunter_in_the_night:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount()==1 and self:GetAbility():GetSpecialValueFor("bonus_move_speed") or 0 end
function modifier_Advanced_hunter_in_the_night:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()==1 and self:GetAbility():GetSpecialValueFor("bonus_attack_speed") or 0 end

function modifier_Advanced_hunter_in_the_night:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return
	end
	local attacker = keys.attacker
	local target = keys.target
	local modifier = target:FindModifierByName("modifier_Advanced_hunter_in_the_night_debuff")
	if not modifier then
		return
	end
	if attacker ~= self:GetParent() then
		return
	end
	local night = self:GetParent():IsInNightTime()
	if not night and target:GetHealthPercent() > self.line then
		return
	end
	if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then
        return
    end
	
	local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/spell/hunter_in_the_night/spattack.vpcf", PATTACH_ABSORIGIN, keys.target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, keys.target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	return self.spattack
end

function modifier_Advanced_hunter_in_the_night:NightOrder(attacker,target,pos)
	if not IsServer() then
		return
	end
	local attacker = attacker
	local target = target
	local pos = pos
	-- LV20
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 20 then
		local endpos = pos + (target:GetForwardVector() * -1) * 100
		pos = endpos
	end
	-- 判定夜晚和首次攻击
	local modifier = target:FindModifierByNameAndCaster("modifier_Advanced_hunter_in_the_night_already",attacker)
	if modifier then
		return
	end
	--print("未持有already")
	if attacker ~= self:GetParent() then
		return
	end
	local night = self:GetParent():IsInNightTime()
	if not night then
		return
	end
	--print("处于夜晚")
	local distance = (attacker:GetOrigin() - target:GetOrigin()):Length2D()
	if distance > self:GetAbility():GetSpecialValueFor("ad_radius") then
		return 
	end
	target:AddNewModifier(attacker,self:GetAbility(),"modifier_Advanced_hunter_in_the_night_already",{})
	--print("施加already成功")

	-- 判定通过，首次攻击执行，瞬移位置
	if pos then
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		self:SpellToTarget( pos )
		target:AddNewModifier(attacker,self:GetAbility(),"modifier_Advanced_hunter_in_the_night_debuff",{duration = duration})
		if self:GetAbility():GetSpecialValueFor("advanced_level") >= 20 then
			target:AddNewModifier(attacker,self:GetAbility(),"modifier_Advanced_hunter_in_the_night_lv20",{duration = 1})
		end
		--print("施加狩猎之影")
	end
end

function modifier_Advanced_hunter_in_the_night:OnAttack(keys)
	if not IsServer() then
		return
	end
	local attacker = keys.attacker
	local target = keys.target
	local pos = target:GetAbsOrigin()

	self:NightOrder(attacker,target,pos)
end

function modifier_Advanced_hunter_in_the_night:OnOrder( params )
	if not IsServer() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return
	end
	if params.unit~=self:GetParent() then
		return
	end
	
	if params.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		local attacker = self:GetParent()
		local target = params.target
		local pos = params.target:GetAbsOrigin()
		if pos then
			--self:SpellToTarget( pos )
			self:NightOrder(attacker,target,pos)
		end
	end
end

function modifier_Advanced_hunter_in_the_night:SpellToTarget(pos)
	if IsServer() then
		local caster = self:GetCaster()
		local point = pos
		local origin = caster:GetOrigin()
		local min_dist = 1
		local max_dist = 100000 --不能用-1
		local direction = (point-origin)
		local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
		direction.z = 0
		direction = direction:Normalized()
	
		local target = GetGroundPosition( origin + direction*dist, nil )
		FindClearSpaceForUnit( caster, target, true )
		
		ProjectileManager:ProjectileDodge(self:GetParent()) --弹道躲闪
		self:PlayEffects1( origin, target ,direction)
	end
end

function modifier_Advanced_hunter_in_the_night:PlayEffects1( origin, target ,direction)
	
	local particle_cast = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
	local particle_end = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
	local sound_start = "Hero_Antimage.Blink_in"
	local sound_end = "Hero_Antimage.Blink_out"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward(effect_cast, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex( effect_cast )


	local effect_cast = ParticleManager:CreateParticle( particle_end, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end
-------------------------------------

modifier_Advanced_hunter_in_the_night_debuff = advanced_modifier({})

function modifier_Advanced_hunter_in_the_night_debuff:IsDebuff()			return true end
function modifier_Advanced_hunter_in_the_night_debuff:IsHidden() 			return false end
function modifier_Advanced_hunter_in_the_night_debuff:IsPurgable() 		return false end
function modifier_Advanced_hunter_in_the_night_debuff:IsPurgeException() 	return false end
function modifier_Advanced_hunter_in_the_night_debuff:GetEffectName()	return "particles/rebuild/spell/hunter_in_the_night/debuff.vpcf" end
function modifier_Advanced_hunter_in_the_night_debuff:GetEffectAttachType()  return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_hunter_in_the_night_debuff:OnCreated(table)
	if not IsServer() then
		return
	end
	self.advanced_level = self:GetAbility().advanced_level
end

function modifier_Advanced_hunter_in_the_night_debuff:CheckState()
	if not IsServer() then
		return{}
	end
	
	-- LV15
	if self.advanced_level < 15 then
		return{}
	end
	if self:GetParent():GetHealthPercent() <= 10 then
		return{
			[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		}
	end
	return
end

function modifier_Advanced_hunter_in_the_night_debuff:ADDeclareFunctions()
	return{
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()}
	}
end

function modifier_Advanced_hunter_in_the_night_debuff:OnDeath(keys)
	if not IsServer() then
		return
	end
	-- LV10疯狂
	if self:GetAbility():GetSpecialValueFor("advanced_level") < 10 then
		return
	end
	local ability = self:GetAbility()
	if ability then
		local caster = self:GetCaster()
		caster:Heal((caster:GetMaxHealth() - caster:GetHealth())*0.05,ability)
	end
end
-------------------------------------

modifier_Advanced_hunter_in_the_night_already= advanced_modifier({})

function modifier_Advanced_hunter_in_the_night_already:IsDebuff()			return true end
function modifier_Advanced_hunter_in_the_night_already:IsHidden() 			return true end
function modifier_Advanced_hunter_in_the_night_already:IsPurgable() 		return false end
function modifier_Advanced_hunter_in_the_night_already:IsPurgeException() 	return false end
function modifier_Advanced_hunter_in_the_night_already:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-------------------------------------

modifier_Advanced_hunter_in_the_night_lv20= advanced_modifier({})

function modifier_Advanced_hunter_in_the_night_lv20:IsDebuff()			return true end
function modifier_Advanced_hunter_in_the_night_lv20:IsHidden() 			return true end
function modifier_Advanced_hunter_in_the_night_lv20:IsPurgable() 		return false end
function modifier_Advanced_hunter_in_the_night_lv20:IsPurgeException() 	return false end
function modifier_Advanced_hunter_in_the_night_lv20:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_hunter_in_the_night_lv20:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
end
function modifier_Advanced_hunter_in_the_night_lv20:GetModifierDisableTurning()
	return 1
end




