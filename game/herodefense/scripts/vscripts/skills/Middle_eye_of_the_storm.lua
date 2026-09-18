
Middle_eye_of_the_storm = class({})
LinkLuaModifier( "modifier_Middle_eye_of_the_storm", "skills/Middle_eye_of_the_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_eye_of_the_storm_debuff", "skills/Middle_eye_of_the_storm", LUA_MODIFIER_MOTION_NONE )

function Middle_eye_of_the_storm:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
	PrecacheResource( "particle", "particles/rebuild/spell/eye_of_the_storm/main_effect.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", context )
end

function Middle_eye_of_the_storm:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )

    local already = caster:FindModifierByName("modifier_Middle_eye_of_the_storm")
	if already then
		already:Destroy()
	end
	caster:AddNewModifier(caster, self, "modifier_Middle_eye_of_the_storm", {duration = duration})
end

modifier_Middle_eye_of_the_storm = advanced_modifier({})

function modifier_Middle_eye_of_the_storm:IsHidden() return false end
function modifier_Middle_eye_of_the_storm:IsDebuff() return false end
function modifier_Middle_eye_of_the_storm:IsPurgable() return false end
function modifier_Middle_eye_of_the_storm:OnCreated()
	self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.interval = self.ability:GetSpecialValueFor("interval")
    self.elecshocking = self.ability:GetSpecialValueFor("elecshocking")
	self.damage = self.ability:GetSpecialValueFor("damage")
    self.armor = self.ability:GetSpecialValueFor("armor")
    self.armor_duration = self.ability:GetSpecialValueFor("armor_duration")
    self.armor_max = self.ability:GetSpecialValueFor("armor_max")

    if IsServer() then
        self.strikes = 1 + self.ability:GetSpecialValueFor("count")
        self.targets = {}

        self.damageTable = {
            -- victim = target,
            attacker = self.parent,
            -- damage = self.damage,
            damage_type = self.ability:GetAbilityDamageType(),
            ability = self.ability,
            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
        }
        self:StartIntervalThink(self.interval)
        self:OnIntervalThink()
        self:PlayEffects1()
    end
end

function modifier_Middle_eye_of_the_storm:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Razor.Storm.Loop"
	local sound_end = "Hero_Razor.StormEnd"
	StopSoundOn( sound_loop, self.parent )
	EmitSoundOn( sound_end, self.parent )
end

function modifier_Middle_eye_of_the_storm:OnIntervalThink()
	local targets = {}
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetOrigin() ,nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	if #enemies<1 then return end
    -- 排序，找到最弱的那个
	table.sort( enemies, function( left, right )
		return left:GetHealth() < right:GetHealth()
	end)
    
    -- 选择最多strikes个不同目标
    local targetCount = 0
	for _,enemy in pairs(enemies) do
		if targetCount < self.strikes then
			targets[enemy] = true
            targetCount = targetCount + 1
		else
            break
        end
	end

    if targetCount >= 1 then
        local baseDamage = self.damage * self.parent:GetAverageTrueAttackDamage(nil)
        if self.parent:HasModifier("modifier_Primary_enchant_totem") or self.parent:HasModifier("modifier_Middle_enchant_totem") or self.parent:HasModifier("modifier_Advanced_enchant_totem") then
            baseDamage = baseDamage * 0.27
        end

        for enemy,_ in pairs(targets) do
            enemy:Elecshocking(self.parent, self.ability, self.elecshocking)

            self.damageTable.victim = enemy
            self.damageTable.damage = baseDamage
            ApplyDamage(self.damageTable)
            
            self:PlayEffects2(enemy)

            if enemy:IsAlive() then
                local debuff = enemy:FindModifierByName("modifier_Middle_eye_of_the_storm_debuff")
                if debuff then
                    if debuff:GetStackCount() >= self.armor_max then
                        debuff:SetDuration(self.armor_duration, true)
                    else
                        debuff:SetStackCount(math.min(debuff:GetStackCount() + self.armor, self.armor_max))
                        debuff:SetDuration(self.armor_duration, true)
                    end
                else
                    local newdebuff = enemy:AddNewModifier(self.parent, self, "modifier_Middle_eye_of_the_storm_debuff", {duration = self.armor_duration})
                    newdebuff:SetStackCount(self.armor)
                end
            end
        end
    end
end

function modifier_Middle_eye_of_the_storm:PlayEffects1()
    local caster = self.parent
	local particle_cast = "particles/rebuild/spell/eye_of_the_storm/main_effect.vpcf"
	local sound_cast = "Hero_Razor.Storm.Cast"
	local sound_loop = "Hero_Razor.Storm.Loop"

	self.particle = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,0,0))
	self:AddParticle( self.particle, false, false, -1, true, false )
	EmitSoundOn( sound_cast, self.parent )
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_Middle_eye_of_the_storm:PlayEffects2( enemy )
	local particle_cast = "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf"
	local sound_cast = "Hero_razor.lightning"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() + Vector(0,0,1000) )
	ParticleManager:SetParticleControlEnt(effect_cast,1,enemy,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, enemy )
end

---
modifier_Middle_eye_of_the_storm_debuff = advanced_modifier({})

function modifier_Middle_eye_of_the_storm_debuff:IsHidden() return false end
function modifier_Middle_eye_of_the_storm_debuff:IsDebuff() return true end
function modifier_Middle_eye_of_the_storm_debuff:IsPurgable() return false end
function modifier_Middle_eye_of_the_storm_debuff:GetTexture() return "razor_eye_of_the_storm" end
function modifier_Middle_eye_of_the_storm_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP} end
function modifier_Middle_eye_of_the_storm_debuff:ADDeclareFunctions() return {advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_Middle_eye_of_the_storm_debuff:Advanced_GetModifierPhysicalArmorBonus() return -self:GetStackCount() end
function modifier_Middle_eye_of_the_storm_debuff:OnTooltip() return self:GetStackCount() end
