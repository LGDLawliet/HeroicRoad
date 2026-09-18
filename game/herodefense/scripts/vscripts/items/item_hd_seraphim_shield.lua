
LinkLuaModifier("modifier_item_hd_seraphim_shield_buff", "items/item_hd_seraphim_shield.lua", LUA_MODIFIER_MOTION_NONE)
-- require("internal/timers")
item_hd_seraphim_shield=class({})
function item_hd_seraphim_shield:GetIntrinsicModifierName() 
    return "modifier_item_hd_seraphim_shield_buff" 
end
function item_hd_seraphim_shield:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/seraphim_shield/effect/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf", context )
end





modifier_item_hd_seraphim_shield_buff=advanced_modifier({})

-- function modifier_item_hd_seraphim_shield_buff:IsPassive()			return true end
function modifier_item_hd_seraphim_shield_buff:IsDebuff() return false end
function modifier_item_hd_seraphim_shield_buff:IsHidden() 		return false end
function modifier_item_hd_seraphim_shield_buff:IsPurgable() 		return false end
function modifier_item_hd_seraphim_shield_buff:IsPurgeException() return false end
function modifier_item_hd_seraphim_shield_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_seraphim_shield_buff:DestroyOnExpire() return false end
function modifier_item_hd_seraphim_shield_buff:OnCreated()
    
    if self:GetAbility() == nil then
		return
    end
    local ability=self:GetAbility()
    self.bonus_health_regen= ability:GetSpecialValueFor("bonus_health_regen") 
    self.bonus_armor= ability:GetSpecialValueFor("bonus_armor") 

    if IsServer() then
        self:StartIntervalThink(1)
    end
end


function modifier_item_hd_seraphim_shield_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
    } 
end


function modifier_item_hd_seraphim_shield_buff:GetModifierPhysical_ConstantBlock( params )

	if params.inflictor then return 0 end

	-- get data
	local parent = params.target
	local attacker = params.attacker
    if params.damage<=10 then
        return
    end

	-- Check target position
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))


	if angle_diff < 50 then
        self:SetStackCount(self:GetStackCount()+math.min(params.damage*0.2,parent:GetMaxHealth()*0.2))

	end

	return 0
end

function modifier_item_hd_seraphim_shield_buff:AdvancedGetModifierConstantHealthRegen()
    return self.bonus_health_regen
end


function modifier_item_hd_seraphim_shield_buff:OnIntervalThink()
    local parnet = self:GetParent()
    local release = parnet:GetMaxHealth()*0.1+50
	if self:GetStackCount()>=release  then
        self:SpellToTarget(self:GetStackCount())
		self:SetStackCount(0)
	
	end
end


function modifier_item_hd_seraphim_shield_buff:SpellToTarget(damage)

    
    local caster = self:GetCaster()
    local point = caster:GetOrigin()+caster:GetForwardVector()*100
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
    local angle = 45
	-- 角度计算
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y


    local damageTable = {
        -- victim = enemy,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        ability = self:GetAbility(), --Optional.
    }
    local count = 0
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()

		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

		if angle_diff<=angle then
            damageTable.victim = enemy
            ApplyDamage(damageTable)
            count = count + 1
            if count>=7 then
                break
            end

		end
	end
	




    local particle_cast = "particles/rebuild/spell/seraphim_shield/effect/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf"	--"particles/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf"
    local sound_cast = "Hero_Mars.Shield.Cast"


    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(500,500,500) )
    --ParticleManager:SetParticleControl( effect_cast, 60, Vector(0,0,205) )CP60调整颜色
    --ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )CP61X轴颜色开关
    ParticleManager:SetParticleControlForward( effect_cast, 0, cast_direction )
    DestroyParticleByDelay(effect_cast,5)

    -- Create Sound
    EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )

end


function modifier_item_hd_seraphim_shield_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end
function modifier_item_hd_seraphim_shield_buff:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

