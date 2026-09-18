--特效优化 √
Advanced_Holy_Light_Shield = class({})

LinkLuaModifier("modifier_Advanced_Holy_Light_Shield", "skills/Advanced_Holy_Light_Shield", LUA_MODIFIER_MOTION_NONE)

function Advanced_Holy_Light_Shield:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/holy_light_shield/effect.vpcf", context )
    PrecacheResource( "particle", "particles/econ/events/fall_2022/mjollnir/mjollnir_shield_fall2022.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/holy_light_shield/unlock2/effect.vpcf", context )



    
end

function Advanced_Holy_Light_Shield:UnlockFirstCore(key)
	return true
end
function Advanced_Holy_Light_Shield:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end
function Advanced_Holy_Light_Shield:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end
function Advanced_Holy_Light_Shield:CheckKV(key)
	local table = {


		damage_hp = 0.015,


	}
	local value = table[key] or -1
	return value

end



function Advanced_Holy_Light_Shield:OnSpellStart()
    local target = self:GetCaster()
    -- local buff = target:FindModifierByName("modifier_Advanced_Holy_Light_Shield")
    if self.advanced_level>=15 then
        target:RemoveModifierByName("modifier_Advanced_Holy_Light_Shield")
   
    end
    local modifierStatusgain = self:GetCaster():GetModifierDurationGainIndex(1)
    local duration = self:GetSpecialValueFor("duration")
    if self.unlock2 then
        duration = 30
    end
    target:AddNewModifier(self:GetCaster(),self,"modifier_Advanced_Holy_Light_Shield",{duration = duration*modifierStatusgain})
    target:Purge(false, true, false, true, false)
end

function Advanced_Holy_Light_Shield:GetCooldown(iLevel)
    local advanced_level = self:GetSpecialValueFor("advanced_level")
    local base_cooldown = self.BaseClass.GetCooldown(self, iLevel)
    base_cooldown = base_cooldown - advanced_level * 0.1
    return math.max(0,base_cooldown)
end

modifier_Advanced_Holy_Light_Shield = advanced_modifier({})
function modifier_Advanced_Holy_Light_Shield:IsDebuff()          return false end
function modifier_Advanced_Holy_Light_Shield:IsHidden()          return false end
function modifier_Advanced_Holy_Light_Shield:IsPurgable()        return false end
function modifier_Advanced_Holy_Light_Shield:IsPurgeException()  return false end

function modifier_Advanced_Holy_Light_Shield:OnCreated()
    if IsServer() then
        local parent = self:GetParent()
        -- local shield = ability:GetSpecialValueFor("hp_shield")*caster:GetMaxHealth()
        -- self:SetStackCount(shield)
        -- EmitSoundOn("Hero_Sven.WarCry.Shield",parent)
        local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_2022/mjollnir/mjollnir_shield_fall2022.vpcf",PATTACH_POINT_FOLLOW,parent)
        ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true)
        self:AddParticle(pfx, false, false, 15, false, false)

        self.pfx = ParticleManager:CreateParticle("particles/rebuild/spell/holy_light_shield/effect.vpcf",PATTACH_POINT_FOLLOW,parent)
        ParticleManager:SetParticleControlEnt(self.pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
        local ex = parent:GetModelScale() * 100
        ParticleManager:SetParticleControl(self.pfx, 1, Vector(ex,ex,ex))
        self:AddParticle(self.pfx, false, false, 15, false, false)
        self:ApplyShield()

        self.unlock2_timer = GameRules:GetGameTime()
        -- self.unlock2_effect = {}
    end
end
function modifier_Advanced_Holy_Light_Shield:OnRefresh(keys)
    if IsServer() then
        self:ApplyShield()
    end
end


function modifier_Advanced_Holy_Light_Shield:ApplyShield()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local shield = ability:GetSpecialValueFor("hp_shield")*caster:GetMaxHealth()
    local health = caster:GetHealth()
    caster:ModifyHealth(health-shield, ability, false, 0)
    local dif = (health-caster:GetHealth())
    -- self.shield = shield+dif
    self.health_change = dif
    self:SetStackCount(shield+dif)
    EmitSoundOn("Hero_Sven.WarCry.Shield",parent)
    if ability.advanced_level>=20 then
        if ability.unlock1 then
            self:StartIntervalThink(0.1)
        else
            self:StartIntervalThink(0.5)
        end

        if ability.unlock3 then
            self.unlock3 = true
        end
       
    end
end
function modifier_Advanced_Holy_Light_Shield:OnDestroy()
    if IsServer() then
        local Ability = self:GetAbility()
        local advanced_level = Ability:GetSpecialValueFor("advanced_level")

        if self:GetStackCount() <= 0 then
            local Ability = self:GetAbility()
            local Cooldown = Ability:GetSpecialValueFor("cooldown_reduction")
            if advanced_level>=5 then
                Cooldown = 12
            end  
            local newCooldown = Ability:GetCooldownTimeRemaining() - Cooldown
            Ability:EndCooldown()
            if newCooldown > 0 then
                Ability:StartCooldown(newCooldown)
            end            
        end
 
       
        self:HealingEffect()
        self:DamageEffect()
    end
end

function modifier_Advanced_Holy_Light_Shield:HealingEffect()
    if IsServer() then
        local Ability = self:GetAbility()
        local advanced_level = Ability:GetSpecialValueFor("advanced_level")
        local heal = self.health_change
        if advanced_level>=10 then
            heal = heal*1.5
        end
        local parent = self:GetParent()
        local healing = HealWithGain(heal,parent,parent,Ability)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, healing, nil)
    end
end

function modifier_Advanced_Holy_Light_Shield:DamageEffect()
    if  IsServer() then
        -- local Ability = self:GetAbility()
        -- local advanced_level = Ability:GetSpecialValueFor("advanced_level")
        if self.lv20_count then
            ParticleManager:DestroyParticle(self.pfx,false)
            ParticleManager:ReleaseParticleIndex(self.pfx)
            local ability = self:GetAbility()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local damage = ability:GetSpecialValueFor("damage_hp")*self:GetStackCount()+self.lv20_count
            -- StopSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
            EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", parent)
            print("damage="..damage)
            local enemies = FindUnitsInRadius(
                caster:GetTeamNumber(), 
                parent:GetAbsOrigin(), 
                nil, 
                ability:GetSpecialValueFor("radius"), 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_ANY_ORDER, 
                false
            )
            local damagetable = {
                attacker = caster,
                damage = damage,
                damage_type = ability:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = ability,
                hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
            }

            for i, enemy in pairs(enemies)do

                damagetable.victim = enemy

                ApplyDamage(damagetable)
                if i > 10 then
                    break
                end
            end
        else
            if self:GetStackCount() > 0 then
                ParticleManager:DestroyParticle(self.pfx,false)
                ParticleManager:ReleaseParticleIndex(self.pfx)
                local ability = self:GetAbility()
                local caster = self:GetCaster()
                local parent = self:GetParent()
                local damage = ability:GetSpecialValueFor("damage_hp")*self:GetStackCount()
                StopSoundOn("Hero_Abaddon.AphoticShield.Loop", parent)
                EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy", parent)
    
                local enemies = FindUnitsInRadius(
                                                  caster:GetTeamNumber(), 
                                                  parent:GetAbsOrigin(), 
                                                  nil, 
                                                  ability:GetSpecialValueFor("radius"), 
                                                  DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                                  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
                                                  DOTA_UNIT_TARGET_FLAG_NONE, 
                                                  FIND_ANY_ORDER, 
                                                  false
                                                )
                local damagetable = {
                    attacker = caster,
                    damage = damage,
                    damage_type = ability:GetAbilityDamageType(),
                    damage_flags = DOTA_DAMAGE_FLAG_NONE,
                    ability = ability,
                    hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
                }
    
                for i, enemy in pairs(enemies)do
    
                   damagetable.victim = enemy
    
                    ApplyDamage(damagetable)
                    if i > 10 then
                        break
                    end
                end
    
            end   
        end
        
    end
end



function modifier_Advanced_Holy_Light_Shield:OnIntervalThink()

    local parent = self:GetParent()
    local ability = self:GetAbility()
    if ability.unlock1 then
        if parent:GetHealthPercent()>=50 then
            local health = parent:GetMaxHealth()*0.5
            local reduce = (parent:GetHealth()-health)*0.5
            parent:ModifyHealth(health, self:GetAbility(), false, 0)
            local count = self.lv20_count or 0
            self.lv20_count = count + reduce
            self:SetStackCount(self:GetStackCount()+reduce)
        end
        self:CheckAphoticShieldModifier()
    else
        if parent:GetHealthPercent()>=50 then
            local health = parent:GetMaxHealth()*0.5
            local reduce = (parent:GetHealth()-health)*0.25
            parent:ModifyHealth(health, self:GetAbility(), false, 0)
            local count = self.lv20_count or 0
            self.lv20_count = count + reduce
            self:SetStackCount(self:GetStackCount()+reduce)
        end
    end
   
 
    if ability.unlock2 then
        if  GameRules:GetGameTime()>=self.unlock2_timer then
            self.unlock2_timer = GameRules:GetGameTime()+1
            local caster = self:GetCaster()
            local units = FindUnitsInRadius(
                caster:GetTeamNumber(), 
                parent:GetAbsOrigin(), 
                nil, 
                1000, 
                DOTA_UNIT_TARGET_TEAM_BOTH, 
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_ANY_ORDER, 
                false
            )
            local count = 0
            for _, unit in ipairs(units) do
                if unit~=parent then
                    if unit:GetTeamNumber()==caster:GetTeamNumber() then
                        if unit:GetHealthPercent()>=70 then
                            local current_health = unit:GetHealth()
                            local health = unit:GetMaxHealth()*0.05
                            unit:ModifyHealth(unit:GetHealth()-health, ability, false, 0)
                            local reduce = current_health-unit:GetHealth()
                            if reduce>=1 then
                                self:SetStackCount(self:GetStackCount()+reduce)
                            end
                            local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/holy_light_shield/unlock2/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
                            ParticleManager:SetParticleControlEnt(nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                            ParticleManager:SetParticleControlEnt(nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
                            ParticleManager:ReleaseParticleIndex(nFXIndex)
                            count = count + 1
                        end
                    else
                        local current_health = unit:GetHealth()
                        unit:ModifyHealth(unit:GetHealth()-parent:GetMaxHealth()*0.05, ability, false, 0)
                        local reduce = current_health-unit:GetHealth()
                        if reduce>=1 then
                            self:SetStackCount(self:GetStackCount()+reduce)
                        end
                        local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/holy_light_shield/unlock2/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
                        ParticleManager:SetParticleControlEnt(nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                        ParticleManager:SetParticleControlEnt(nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
                        ParticleManager:ReleaseParticleIndex(nFXIndex)
                        count = count + 1
                    end
                end
                if count>=6 then
                    break
                end
                
            end
        end
        
    end
   
end
function modifier_Advanced_Holy_Light_Shield:CheckAphoticShieldModifier()
    local parent = self:GetParent()
    local modifier = parent:FindModifierByName("modifier_Advanced_aphotic_shield")
    if modifier then
        local stack = modifier:GetStackCount()
        self:SetStackCount(self:GetStackCount()+stack)
        modifier:SafeDestroy()
    end
    modifier = parent:FindModifierByName("modifier_Middle_aphotic_shield")
    if modifier then
        local stack = modifier:GetStackCount()
        self:SetStackCount(self:GetStackCount()+stack)
        modifier:SafeDestroy()
    end
    modifier = parent:FindModifierByName("modifier_Primary_aphotic_shield")
    if modifier then
        local stack = modifier:GetStackCount()
        self:SetStackCount(self:GetStackCount()+stack)
        modifier:SafeDestroy()
    end
end


function modifier_Advanced_Holy_Light_Shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_Advanced_Holy_Light_Shield:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then
        return self:GetStackCount()
    end

    if  self.unlock3 then
        local stack = self:GetStackCount()
        if stack<=0 then
            self:SafeDestroy()
            return 0
        end
        local parent = self:GetParent()
        local limit = parent:GetMaxHealth()*0.04
        if keys.damage>=limit then
            self:SetStackCount(math.max(stack - limit,0))
        end
        return keys.damage
    end
    if keys.block_disabled then
        return 0 
    end

    local stack = self:GetStackCount()
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage + 1
    end
    return stack
end