-- 重写完成
item_hd_dingzhi_luna_2_effects = class({})
LinkLuaModifier("modifier_item_hd_dingzhi_luna_2_effects", "player_artifact/item_hd_dingzhi_luna_2_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_2_effects_magic_res", "player_artifact/item_hd_dingzhi_luna_2_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_dingzhi_luna_2_effects_weapon", "player_artifact/item_hd_dingzhi_luna_2_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_dingzhi_luna_2_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_dingzhi_luna_2_effects"
end

function item_hd_dingzhi_luna_2_effects:Precache(context)
    PrecacheResource("particle", "particles/rebuild/artifact/dingzhi_luna_2/project_notarget.vpcf", context)
end
function item_hd_dingzhi_luna_2_effects:GetArtifactSpecialList()
    local list = {}
    list["76561198200656253"] = true
    return list
end
function item_hd_dingzhi_luna_2_effects:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_dingzhi_luna_2_effects:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end
modifier_item_hd_dingzhi_luna_2_effects = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_2_effects:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_2_effects:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_2_effects:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_2_effects:RemoveOnDeath() return false end
function modifier_item_hd_dingzhi_luna_2_effects:GetTexture() return "item_artifact_67" end
function modifier_item_hd_dingzhi_luna_2_effects:DestroyOnExpire() return false end

function modifier_item_hd_dingzhi_luna_2_effects:OnCreated()
    self.ability = self:GetAbility()
    self.spell_lifesteal = self.ability:GetArtifactSpecialValueFor("spell_lifesteal")
    self.need = self.ability:GetArtifactSpecialValueFor("need")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.outgoing_max = self.ability:GetArtifactSpecialValueFor("outgoing_max")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_luna_2_effects")
    
    -- 小纵
    self.need_1 = self.ability:GetArtifactSpecialValueFor("need_1")
    self.speed_1 = self.ability:GetArtifactSpecialValueFor("speed_1")
    
    -- 神清杵
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")
    self.mp_lost_2 = self.ability:GetArtifactSpecialValueFor("mp_lost_2")*0.01
    self.attack_count = 0
    
    -- 元素修习
    self.magic_res_3 = self.ability:GetArtifactSpecialValueFor("magic_res_3")
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
    self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.damage_3 = self.ability:GetArtifactSpecialValueFor("damage_3")
    
    -- 大威德金刚杵
    self.line_4 = self.ability:GetArtifactSpecialValueFor("line_4")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.damage_4 = self.ability:GetArtifactSpecialValueFor("damage_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.outgoing_max_7 = self.ability:GetArtifactSpecialValueFor("outgoing_max_7")
    self.need_7 = self.ability:GetArtifactSpecialValueFor("need_7")
    self.duration_10  = self.ability:GetArtifactSpecialValueFor("duration_10")
    
    if self.level >= 70 then
        self.outgoing_max = self.outgoing_max_7
        self.need = self.need_7
    end
    if self.level >= 100 then
        self.duration_4 = self.duration_4 + self.duration_10
    end
    if IsServer() then
        self:StartIntervalThink(1)
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end

function modifier_item_hd_dingzhi_luna_2_effects:OnRefresh()
    self.ability = self:GetAbility()
    self.spell_lifesteal = self.ability:GetArtifactSpecialValueFor("spell_lifesteal")
    self.need = self.ability:GetArtifactSpecialValueFor("need")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.outgoing_max = self.ability:GetArtifactSpecialValueFor("outgoing_max")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_luna_2_effects")
    
    -- 小纵
    self.need_1 = self.ability:GetArtifactSpecialValueFor("need_1")
    self.speed_1 = self.ability:GetArtifactSpecialValueFor("speed_1")
    
    -- 神清杵
    self.line_2 = self.ability:GetArtifactSpecialValueFor("line_2")
    self.mp_lost_2 = self.ability:GetArtifactSpecialValueFor("mp_lost_2")*0.01
    self.attack_count = 0
    
    -- 元素修习
    self.magic_res_3 = self.ability:GetArtifactSpecialValueFor("magic_res_3")
    self.duration_3 = self.ability:GetArtifactSpecialValueFor("duration_3")
    self.line_3 = self.ability:GetArtifactSpecialValueFor("line_3")
    self.damage_3 = self.ability:GetArtifactSpecialValueFor("damage_3")
    
    -- 大威德金刚杵
    self.line_4 = self.ability:GetArtifactSpecialValueFor("line_4")
    self.duration_4 = self.ability:GetArtifactSpecialValueFor("duration_4")
    self.damage_4 = self.ability:GetArtifactSpecialValueFor("damage_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.outgoing_max_7 = self.ability:GetArtifactSpecialValueFor("outgoing_max_7")
    self.need_7 = self.ability:GetArtifactSpecialValueFor("need_7")
    self.duration_10  = self.ability:GetArtifactSpecialValueFor("duration_10")
    
    if self.level >= 100 then
        self.duration_4 = self.duration_4 + self.duration_10
    end
    if self.level >= 70 then
        self.outgoing_max = self.outgoing_max_7
        self.need = self.need_7
    end
end

function modifier_item_hd_dingzhi_luna_2_effects:OnIntervalThink()
    local parent = self:GetParent()
    local strength = parent:GetStrength()
    self:SetStackCount(math.floor(strength/self.need))

    if self.level >= 10 then
        self.speed_1_f = math.floor(parent:GetAgility()/self.need_1)*self.speed_1
    else
        self.speed_1_f = 0
    end
end
function modifier_item_hd_dingzhi_luna_2_effects:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_dingzhi_luna_2_effects:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return math.min(self:GetStackCount()*self.outgoing, self.outgoing_max)
    elseif self._tooltip == 2 then
        return self.speed_1_f
    -- elseif self._tooltip == 3 then
    --     return self.lightning_outgoing
    end
end
function modifier_item_hd_dingzhi_luna_2_effects:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_PhysicalCriticalAmp
    }
end
function modifier_item_hd_dingzhi_luna_2_effects:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		local parent = self:GetParent()
        if tg.attacker==parent 
		and not parent:IsIllusion() 
		and tg.damage_category==DOTA_DAMAGE_CATEGORY_SPELL
		and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION 
		and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then 

			--该生命吸血受到吸血增强影响
            local life_steal_gain = parent:GetModifierLifeStealGain(1)
			local hp = 0
			hp=tg.damage*self.spell_lifesteal*life_steal_gain
            hp = hp-hp%1
			if hp<=0 then return end   --没有吸血效果了就不执行了

			if Ability then
				local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            parent:Heal(hp, self.ability)
        end 
    end 
end
function modifier_item_hd_dingzhi_luna_2_effects:Advanced_GetModifier_PhysicalCriticalAmp()
    return -100000
end
function modifier_item_hd_dingzhi_luna_2_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    if not self:GetParent():IsAttacking() then return end
    if IsElementDamage(keys) or keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
        -- 元素修习
        if self.level >= 30 then
           if IsElementDamage(keys) then
                local target = keys.target
                if target and target:IsAlive() then
                    target:AddNewModifier(self:GetParent(), self.ability, "modifier_item_hd_dingzhi_luna_2_effects_magic_res", {duration = self.duration_3+1})
                end
           end
        end

        return math.min(self:GetStackCount()*self.outgoing, self.outgoing_max)
    end
    return 0
end

function modifier_item_hd_dingzhi_luna_2_effects:Advanced_GetModifierAttackSpeedPercentage()
    return self.speed_1_f
end

function modifier_item_hd_dingzhi_luna_2_effects:Advanced_GetModifier_CastPoint()
    return self.speed_1_f
end

function modifier_item_hd_dingzhi_luna_2_effects:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local caster = self:GetCaster()
    if self.level < 20 then return end
    if attacker ~= caster then return end
    if attacker:IsInSpecialAttack() then return end
    if not self:GetAbility() then return end
    
    self.attack_count = self.attack_count + 1
    
    -- 神清杵
    if self.attack_count >= self.line_2 then
        self.attack_count = 0
        local max_mana = caster:GetMaxMana()
        local current_mana = caster:GetMana()
        local mana_lost = max_mana - current_mana
        local mana_restore = mana_lost * self.mp_lost_2
        caster:GiveMana(mana_restore)
    end
    
    -- 大威德金刚杵
    if self.level >= 40 then
        if not self.attack_count_4 then
            self.attack_count_4 = 0
        end
        self.attack_count_4 = self.attack_count_4 + 1
        if self.attack_count_4 >= self.line_4 then
            self.attack_count_4 = 0
            caster:AddNewModifier(caster, self.ability, "modifier_item_hd_dingzhi_luna_2_effects_weapon", {duration = self.duration_4+1})
        end
    end
end

function modifier_item_hd_dingzhi_luna_2_effects:GetModifierPreAttack_CriticalStrike()
    return 0
end

function modifier_item_hd_dingzhi_luna_2_effects:AddCustomTransmitterData( )
	return
	{
		speed_1_f = self.speed_1_f,
	}
end
function modifier_item_hd_dingzhi_luna_2_effects:HandleCustomTransmitterData( data )
	self.speed_1_f = data.speed_1_f
end
-- 魔法抗性降低修饰器
modifier_item_hd_dingzhi_luna_2_effects_magic_res = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_2_effects_magic_res:IsDebuff() return true end
function modifier_item_hd_dingzhi_luna_2_effects_magic_res:IsHidden() return false end
function modifier_item_hd_dingzhi_luna_2_effects_magic_res:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_2_effects_magic_res:GetTexture() return "item_artifact_67" end

function modifier_item_hd_dingzhi_luna_2_effects_magic_res:OnCreated(keys)
    self.ability = self:GetAbility()
    self.magic_res_3 = self.ability:GetArtifactSpecialValueFor("magic_res_3")
end

function modifier_item_hd_dingzhi_luna_2_effects_magic_res:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_item_hd_dingzhi_luna_2_effects_magic_res:GetModifierMagicalResistanceBonu()
    if not self:GetAbility() then self:Destroy() return end
    return -self.magic_res_3
end

-- 武器附魔修饰器
modifier_item_hd_dingzhi_luna_2_effects_weapon = advanced_modifier({})

function modifier_item_hd_dingzhi_luna_2_effects_weapon:IsDebuff() return false end
function modifier_item_hd_dingzhi_luna_2_effects_weapon:IsHidden() return true end
function modifier_item_hd_dingzhi_luna_2_effects_weapon:IsPurgable() return false end
function modifier_item_hd_dingzhi_luna_2_effects_weapon:GetTexture() return "item_artifact_67" end

function modifier_item_hd_dingzhi_luna_2_effects_weapon:OnCreated(keys)
    self.ability = self:GetAbility()
    self.damage_4 = self.ability:GetArtifactSpecialValueFor("damage_4")
    self.cd_4 = self.ability:GetArtifactSpecialValueFor("cd_4")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_dingzhi_luna_2_effects")
    self.last_trigger_time = 0

    if IsServer() then
        self.damage_table = {
        attacker = self:GetParent(),
        --victim = target,
        ability = self.ability,
        --damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
    }
        if self.level >= 100 then
            self.damage_table.hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE + HD_DAMAGE_FLAG_DARK_DAMAGE
        end
    end
end

function modifier_item_hd_dingzhi_luna_2_effects_weapon:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil}
    }
end

function modifier_item_hd_dingzhi_luna_2_effects_weapon:CheckState()
    if self.level >= 100 then
        return {
            [MODIFIER_STATE_CANNOT_MISS] = true,
        }
    end
end

function modifier_item_hd_dingzhi_luna_2_effects_weapon:OnAttack(keys)
    if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    
    local attacker = keys.attacker
    local parent = self:GetParent()
    local target = keys.target
    if attacker ~= parent then return end
    if attacker:IsInSpecialAttack() then return end
    if self:GetRemainingTime() <= 1 then return end
    
    local current_time = GameRules:GetGameTime()
    if current_time - self.last_trigger_time < self.cd_4 then return end
    if self:GetRemainingTime() <= 1 then return end
    
    self:FireShoot(target)
    self.last_trigger_time = current_time
end

function modifier_item_hd_dingzhi_luna_2_effects_weapon:FireShoot(target)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if not target then return end

	local caster = self:GetCaster()
	local point = target:GetAbsOrigin() 

	local projectile_name = "particles/rebuild/artifact/dingzhi_luna_2/project_notarget.vpcf"
	local distance = math.min(500 + 1.2*caster:HDGetPrimaryStatValue(), 2999)
	local start_radius = 300
	local end_radius = 300
	local speed = 3000

	local spawnPos = caster:GetAbsOrigin()
    if point==spawnPos then
		point = point +caster:GetForwardVector()
	end
	local direction = point-spawnPos
	direction.z = 0
	direction = direction:Normalized()
    local target_pos = spawnPos + direction* distance


	local info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = spawnPos,
		
	    bDeleteOnHit = false,

	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = distance,
	    fStartRadius = start_radius,
	    fEndRadius =end_radius,
		vVelocity = direction * speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
		bProvidesVision = true,

		EffectSound = "Hero_Magnataur.ShockWave.Cast",
		ProjectileSound = "Hero_Magnataur.ShockWave.Particle",
		SoundName = "Hero_Magnataur.ShockWave.Particle",
		Sound = "Hero_Magnataur.ShockWave.Particle",
		SoundEvent = "Hero_Magnataur.ShockWave.Particle",
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

    local enemies = FindUnitsInLine(caster:GetTeamNumber(), spawnPos, target_pos,nil, start_radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
    for _,enemy in pairs(enemies)do
        local distance = CalculateDistance(enemy,caster)
        local delay = distance/speed
        caster:GameTimer(delay,function()
            if enemy:IsAlive() and self then
                self:PlayEffects2( enemy )
            end
        end)
    end
end

function modifier_item_hd_dingzhi_luna_2_effects_weapon:PlayEffects2(target)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    
    self.damage_table.victim = target
    self.damage_table.damage = self:GetParent():HDGetPrimaryStatValue()*self.damage_4
    local damage = ApplyDamage(self.damage_table)
    EmitSoundOnLocationWithCaster(target:GetOrigin(), "Hero_Magnataur.ShockWave.Target", self:GetParent())
end
