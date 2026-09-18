LinkLuaModifier("modifier_creeps_spell_Magnetize", "creeps_spell/creeps_spell_Magnetize", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Magnetize_stone_explosion", "creeps_spell/creeps_spell_Magnetize", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creeps_spell_Magnetize_force_field", "creeps_spell/creeps_spell_Magnetize", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_creeps_spell_Magnetize_force", "creeps_spell/creeps_spell_Magnetize", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if creeps_spell_Magnetize == nil then
    creeps_spell_Magnetize = class({})
end
function creeps_spell_Magnetize:SearchStoneInRadius(vPoint, fRadius)
    local tUnits = FindUnitsInRadius(
    self:GetCaster():GetTeamNumber(),
    vPoint,
    nil,
    fRadius,
    DOTA_UNIT_TARGET_TEAM_BOTH,
    DOTA_UNIT_TARGET_ALL,
    DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    FIND_CLOSEST,
    false
    )
    local tStone = {}

    for _, hUnit in pairs(tUnits) do
        if hUnit:HasModifier("modifier_creeps_spell_Stone_Remnant") then
            table.insert(tStone,hUnit)
        end
    end
    if #tStone>0  then
        return tStone
    end
    return nil
end
function creeps_spell_Magnetize:OnSpellStart()

    local hCaster = self:GetCaster()

    local fRadius = self:GetSpecialValueFor("radius")
    local fDuration = self:GetSpecialValueFor("duration")
    

    local tEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetOrigin(),nil,fRadius,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    0,false)


    for _, hEnemy in pairs(tEnemies) do
         hEnemy:AddNewModifier(hCaster,self,"modifier_creeps_spell_Magnetize",{duration = fDuration}) 
    end



    local sParticleName = "particles/units/heroes/hero_earth_spirit/espirit_magnetize_pulse.vpcf"
    local iParticle = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN_FOLLOW, hCaster)
    ParticleManager:SetParticleControl(iParticle, 2, Vector(fRadius, 0, 0))
    ParticleManager:ReleaseParticleIndex(iParticle)
    hCaster:EmitSound("Hero_EarthSpirit.Magnetize.Cast")
------------------------------------------
    local hUnit = self:SearchStoneInRadius(self:GetCaster():GetOrigin(), 3000)
    if hUnit==nil then
        return
    end
    for _, hStone in pairs(hUnit) do
        if hStone and (not hStone:HasModifier("modifier_creeps_spell_Magnetize_stone_explosion")) then
            hStone:AddNewModifier(self:GetCaster(),self,"modifier_creeps_spell_Magnetize_stone_explosion",
            {duration = 0.3})
            local tEnemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            hStone:GetOrigin(),
            nil,
            400,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            0,
            false
            )
            for _, hEnemy in pairs(tEnemies) do
                hEnemy:AddNewModifier(self:GetCaster(),self,"modifier_creeps_spell_Magnetize",
                { duration = fDuration})
                if hEnemy.Creeps_Magnetize==nil then
                    hEnemy.Creeps_Magnetize = 0.5
                else
                  hEnemy.Creeps_Magnetize = hEnemy.Creeps_Magnetize*1.5
                end

                local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_magnet_arclightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, hStone)
                ParticleManager:SetParticleControlEnt(iParticle, 1, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
                ParticleManager:ReleaseParticleIndex(iParticle)

                hStone:EmitSound("Hero_EarthSpirit.Magnetize.StoneBolt")
            end
        end
    end
        
-----------------------------------

    
end
creeps_spell_Magnetize.tDebuffTracker = {}
function creeps_spell_Magnetize:AddDebuff(hModifier)
    table.insert(self.tDebuffTracker, hModifier)
end
function creeps_spell_Magnetize:RemoveDebuff(hModifier)
    for i, mod in pairs(self.tDebuffTracker) do
        if mod == hModifier then
            table.remove(self.tDebuffTracker, i)
        end
    end
end

function creeps_spell_Magnetize:ApplyDebuff(hAbility, sModifierName, fDuration)
    for _, hModifier in pairs(self.tDebuffTracker) do
        local hParent = hModifier:GetParent()
        if hParent:IsAlive() and (not hParent:IsMagicImmune()) and (not hParent:IsInvulnerable()) then
            hParent:AddNewModifier(self:GetCaster(), hAbility, sModifierName, { duration = fDuration })
        end
    end
end

---------------------------------------------------------------------
-- Modifiers
if modifier_creeps_spell_Magnetize == nil then
    modifier_creeps_spell_Magnetize = class({})
end
function modifier_creeps_spell_Magnetize:IsHidden()return false end
function modifier_creeps_spell_Magnetize:IsDebuff()return true end
function modifier_creeps_spell_Magnetize:IsStunDebuff()return false end
function modifier_creeps_spell_Magnetize:IsPurgable()return true end
function modifier_creeps_spell_Magnetize:OnCreated(params)
    if not IsServer() then
        return
    end
    self.hAbility = self:GetAbility()
    self.count = 0
    self.iDamage = self.hAbility:GetSpecialValueFor("damage")*self:GetCaster():GetBaseDamageMax()
    if self:GetParent().Creeps_Magnetize ~=nil then
        self.iDamage = self.iDamage*(1+self:GetParent().Creeps_Magnetize)
    end
    self.fDuration = self.hAbility:GetSpecialValueFor("duration")
    self.fRockSearchRadius = self.hAbility:GetSpecialValueFor("detect_radius")
    self.fRockExplosionRadius = self.hAbility:GetSpecialValueFor("rock_explosion_radius")
    self.fRockExplosionDelay = self.hAbility:GetSpecialValueFor("rock_explosion_delay")
    self.fInterval = 0.5

    local sPtclName = 'particles/units/heroes/hero_earth_spirit/espirit_magnetic_ring.vpcf'



        -- if self:GetParent():IsHero() then
        --     self:GetParent():AddNewModifier(self:GetCaster(), self.hAbility, 'modifier_creeps_spell_Magnetize_force_field', {
        --         duration = self:GetDuration(),
        --     })
            -- if 0 == self.iNOrS then
            --     sPtclName = "particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf"
            -- else
            --     sPtclName = "particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf"
        --     -- end
        -- end
    local iParticle = ParticleManager:CreateParticle(sPtclName, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(iParticle, 1, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(iParticle, 2, Vector(self.fRockSearchRadius, 0, 0))
    ParticleManager:ReleaseParticleIndex(iParticle)

    self.tDamage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.iDamage * self.fInterval,
        damage_type = self.hAbility:GetAbilityDamageType(),
        ability = self.hAbility,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
    }
    self.fReaming = self.fDuration * 2

    self:StartIntervalThink(self.fInterval)

    self.hAbility:AddDebuff(self)
end
    function modifier_creeps_spell_Magnetize:OnRefresh(params)
        if not IsServer() then
            return
        end
        self.hAbility = self:GetAbility()
        self.iDamage = self.hAbility:GetSpecialValueFor("damage")*self:GetCaster():GetBaseDamageMax()
        if self:GetParent().Creeps_Magnetize ~=nil then
            self.iDamage = self.iDamage*(1+self:GetParent().Creeps_Magnetize)
        end
        self.fDuration = self.hAbility:GetSpecialValueFor("duration")
        self.fRockSearchRadius = self.hAbility:GetSpecialValueFor("detect_radius")
        self.fRockExplosionRadius = self.hAbility:GetSpecialValueFor("rock_explosion_radius")
        self.fRockExplosionDelay = self.hAbility:GetSpecialValueFor("rock_explosion_delay")
        self.tDamage.damage = self.iDamage * self.fInterval
        self.tDamage.attacker =self:GetCaster()
        self.fReaming = self.fDuration * 2

        self:StartIntervalThink(self.fInterval)
    end
    function modifier_creeps_spell_Magnetize:OnRemoved(params)
        if not IsServer() then
            return
        end
        if self.hAbility and not self.hAbility:IsNull() then
            self.hAbility:RemoveDebuff(self)
            self:GetParent():EmitSound("Hero_EarthSpirit.Magnetize.End")
            self:GetParent().Creeps_Magnetize = 0
        end
 
    end
    -- function modifier_creeps_spell_Magnetize:OnDestroy(params)
    --     if IsValid(self:GetParent()) then
    --         self:GetParent():RemoveModifierByName('modifier_creeps_spell_Magnetize_force_field')
    --     end
    -- end
    function modifier_creeps_spell_Magnetize:OnIntervalThink()
        if self:GetCaster()==nil then  --施法者死亡了
            return
        end
        self.count = self.count + 1
        if self.count == 16 and self:GetCaster().pattern_2 then
            local ability = self:GetCaster():FindAbilityByName("creeps_spell_Stone_Remnant")
			self:GetCaster():SetCursorPosition(self:GetParent():GetAbsOrigin())
			ability:OnSpellStart()
        end
        ApplyDamage(self.tDamage)
        self.fReaming = self.fReaming - 1
        if self.fReaming % 2 == 0 then
            --头顶倒计时
            local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_replicate_overhead_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(iParticle, 1, Vector(0, self.fReaming / 2, 0))
            ParticleManager:SetParticleControl(iParticle, 2, Vector(1, 0, 0))
            ParticleManager:ReleaseParticleIndex(iParticle)
        end

        local hStone = self:SearchUnitInRadius(self:GetParent():GetOrigin(), self.fRockSearchRadius)
        -- local tUnits = FindUnitsInRadius(
        --     self:GetCaster():GetTeamNumber(),
        --     self:GetParent():GetOrigin(),
        --     nil,
        --     self.fRockSearchRadius,
        --     DOTA_UNIT_TARGET_TEAM_ENEMY,
        --     DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
        --     DOTA_UNIT_TARGET_FLAG_NONE,
        --     FIND_CLOSEST,
        --     false
        --     )
        if hStone  then
            -- self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_creeps_spell_Magnetize",
            --     { duration = self.fDuration})
            self:ForceRefresh()
        end
        -- if hStone and (not hStone:HasModifier("modifier_creeps_spell_Magnetize_stone_explosion")) then

        --     hStone:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_creeps_spell_Magnetize_stone_explosion",
        --     {duration = self.fRockExplosionDelay})

        --     local tEnemies = FindUnitsInRadius(
        --     self:GetCaster():GetTeamNumber(),
        --     hStone:GetOrigin(),
        --     nil,
        --     self.fRockExplosionRadius,
        --     DOTA_UNIT_TARGET_TEAM_ENEMY,
        --     DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        --     DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        --     0,
        --     false
        --     )

        --     for _, hEnemy in pairs(tEnemies) do
        --         hEnemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_creeps_spell_Magnetize",
        --         { duration = self.fDuration})

        --         local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_magnet_arclightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, hStone)
        --         ParticleManager:SetParticleControlEnt(iParticle, 1, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
        --         ParticleManager:ReleaseParticleIndex(iParticle)

        --         hStone:EmitSound("Hero_EarthSpirit.Magnetize.StoneBolt")
        --     end
        -- end



        local sPtclName = 'particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf'
        -- if self:GetParent():IsHero() then
        --     if 0 == self.iNOrS then
        --         sPtclName = "particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf"
        --     else
        --         sPtclName = "particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf"
        --     end
        -- end
        local iParticle = ParticleManager:CreateParticle(sPtclName, PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(iParticle, 1, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(iParticle, 2, Vector(self.fRockSearchRadius, 0, 0))
        ParticleManager:ReleaseParticleIndex(iParticle)

        self:GetParent():EmitSound("Hero_EarthSpirit.Magnetize.Target.Tick")
    end

function modifier_creeps_spell_Magnetize:SearchUnitInRadius(vPoint, fRadius)
    local tUnits = FindUnitsInRadius(
    self:GetCaster():GetTeamNumber(),
    vPoint,
    nil,
    fRadius,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_CLOSEST,
    false
    )

    for _, hUnit in pairs(tUnits) do
        if hUnit:HasModifier("modifier_creeps_spell_Magnetize") and hUnit~=self:GetParent() then
            return hUnit
        end
    end
    return nil
end


function modifier_creeps_spell_Magnetize:ApplyDebuff(hAbility, sModifierName, fDuration)
    self:GetAbility():ApplyDebuff(hAbility, sModifierName, fDuration)
end

-- ---------------------------------------------------------------------
if modifier_creeps_spell_Magnetize_stone_explosion == nil then
    modifier_creeps_spell_Magnetize_stone_explosion = class({})
end
function modifier_creeps_spell_Magnetize_stone_explosion:IsHidden()return true end
function modifier_creeps_spell_Magnetize_stone_explosion:IsPurgable()return false end
if IsServer() then
    function modifier_creeps_spell_Magnetize_stone_explosion:OnCreated(params)
        local iParticle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_earth_spirit/espirit_stoneismagnetized_xpld.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self:GetParent()
        )
        ParticleManager:SetParticleControl(iParticle, 2, Vector(self:GetDuration(), 0, 0))
        self:AddParticle(iParticle, false, false, -1, false, false)
    end
    function modifier_creeps_spell_Magnetize_stone_explosion:OnRemoved(params)
        local hModifier = self:GetParent():FindModifierByName("modifier_creeps_spell_Stone_Remnant")
        if hModifier then
            hModifier:SafeDestroy()
        end
    end
end
