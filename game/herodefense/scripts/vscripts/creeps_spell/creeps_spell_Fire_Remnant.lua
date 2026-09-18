creeps_spell_Fire_Remnant=class({})

LinkLuaModifier("modifier_creeps_spell_Fire_Remnant_num", "creeps_spell/creeps_spell_Fire_Remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Fire_Remnant_esr", "creeps_spell/creeps_spell_Fire_Remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Fire_Remnant_hb", "creeps_spell/creeps_spell_Fire_Remnant", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_searing_chains_debuff", "heros/hero_ember_spirit/searing_chains.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Fire_Remnant_duration", "creeps_spell/creeps_spell_Fire_Remnant", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Fire_Remnant:IsHiddenWhenStolen() 	return false  end
function creeps_spell_Fire_Remnant:IsRefreshable() 		return true end
function creeps_spell_Fire_Remnant:IsStealable() 			return true end
function creeps_spell_Fire_Remnant:GetAssociatedSecondaryAbilities() return "creeps_spell_Activate_Fire_Remnant" end
function creeps_spell_Fire_Remnant:OnUpgrade() 
    local caster = self:GetCaster()			
    if caster:HasAbility("creeps_spell_Activate_Fire_Remnant") then
        local AB = caster:FindAbilityByName("creeps_spell_Activate_Fire_Remnant")
        if AB then    
            AB:SetLevel(self:GetLevel())
        end 
	end
end

function creeps_spell_Fire_Remnant:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local duration = self:GetSpecialValueFor("duration")
	local cur_pos = self:GetCursorPosition()
	local dis = (pos - cur_pos):Length2D()
    local dir = (cur_pos - pos)
	dir.z = 0
	if dir:Length2D() == 0 then dir = Vector(1, 0, 0) end
	local vVelocity = dir:Normalized() * 3000

    if caster.creeps_spell_Fire_RemnantTB==nil  then 
        caster.creeps_spell_Fire_RemnantTB={}
        caster:AddNewModifier(caster, self, "modifier_creeps_spell_Fire_Remnant_num", {})
    end 
    EmitSoundOn("Hero_EmberSpirit.FireRemnant.Cast", caster)
    local ESR=CreateUnitByName("npc_dummy_unit", pos, true, nil, nil,caster:GetTeamNumber())
    ESR:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
    ESR:AddNewModifier(caster, self, "modifier_creeps_spell_Fire_Remnant_hb", {})
	-- if caster.fire_remnantTB==nil then
	-- 	caster.fire_remnantTB = {}
	-- end
	-- caster.fire_remnantTB[#caster.fire_remnantTB+1] = ESR
    table.insert (caster.creeps_spell_Fire_RemnantTB, ESR)
    local mod = caster:FindModifierByName("modifier_creeps_spell_Fire_Remnant_num")
    if mod  then   
        mod:IncrementStackCount()
    end 
	local pp = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = dis,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_NONE,
		bDeleteOnHit = true,
		vVelocity = vVelocity,
        bProvidesVision = false,
        ExtraData = {ESR=ESR:entindex()}
	}
    ProjectileManager:CreateLinearProjectile(pp)
end

function creeps_spell_Fire_Remnant:OnProjectileThink_ExtraData(location, kv)
    local ESR=EntIndexToHScript(kv.ESR)
    if ESR~=nil then
        ESR:SetAbsOrigin(GetGroundPosition(location, nil))
    end
end

function creeps_spell_Fire_Remnant:OnProjectileHit_ExtraData(target, location, kv)
    local ESR=EntIndexToHScript(kv.ESR)
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local team=caster:GetTeamNumber()
    ESR:AddNewModifier(caster, self, "modifier_creeps_spell_Fire_Remnant_esr", {duration = duration})
    ESR:SetAbsOrigin(GetGroundPosition(location, nil))
    EmitSoundOn("Hero_EmberSpirit.Remnant.Appear", ESR)
    -- if caster:Has_Aghanims_Shard() then 
    --     AddFOWViewer(team, location, 1000, duration, false)
    -- end 
    -- if caster:HasScepter() then 
    --     local heroes = FindUnitsInRadius(team, location, nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    --     if #heroes>0 then  
    --         for a=1,#heroes do
    --             caster:PerformAttack(heroes[a], false, false, true, false, false, false, true)
    --         end
    --     end 
    -- end
end

modifier_creeps_spell_Fire_Remnant_num=class({})

function modifier_creeps_spell_Fire_Remnant_num:IsHidden() 			return true end
function modifier_creeps_spell_Fire_Remnant_num:IsPurgable() 			return false end
function modifier_creeps_spell_Fire_Remnant_num:IsPurgeException() 	return false end
function modifier_creeps_spell_Fire_Remnant_num:RemoveOnDeath() 	return false end

modifier_creeps_spell_Fire_Remnant_esr=class({})
function modifier_creeps_spell_Fire_Remnant_esr:IsHidden() 			return true end
function modifier_creeps_spell_Fire_Remnant_esr:IsPurgable() 			return false end
function modifier_creeps_spell_Fire_Remnant_esr:IsPurgeException() 	return false end
function modifier_creeps_spell_Fire_Remnant_esr:RemoveOnDeath() 	return true end

function modifier_creeps_spell_Fire_Remnant_esr:OnCreated() 	
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.pos=self.parent:GetAbsOrigin()
    self.act={40,66,64,12,70,81,82,74}
    self.radius=self.ability:GetSpecialValueFor("radius")
    self.duration=self.ability:GetSpecialValueFor("duration2")

    if IsServer() then  
        self.damage=self.ability:GetSpecialValueFor("damage")*self.caster:GetBaseDamageMax()
        self.caster:AddNewModifier(self.caster, self.ability, "modifier_creeps_spell_Fire_Remnant_duration", {duration=self:GetRemainingTime()})
            
            local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pf, 0, self.pos)
            ParticleManager:SetParticleControlEnt(pf, 1, self.caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.pos, false)
            ParticleManager:SetParticleControl(pf, 2, Vector(self.act[RandomInt(1, #self.act)], 0, 0))
            ParticleManager:SetParticleControl(pf, 60, Vector(RandomInt(0, 255),RandomInt(0, 255),RandomInt(0, 255)))
            ParticleManager:SetParticleControl(pf, 61, Vector(1,0,0))
            self:AddParticle(pf, false, false, -1, false, false)
    end  
end

function modifier_creeps_spell_Fire_Remnant_esr:OnDestroy() 	
    if IsServer() then 
        if not self.caster or self.caster:IsNull() then
            return
        end
        for i =#self.caster.creeps_spell_Fire_RemnantTB ,1, -1 do
            if self.caster.creeps_spell_Fire_RemnantTB[i] and self.caster.creeps_spell_Fire_RemnantTB[i] == self.parent then
                EmitSoundOn("Hero_EmberSpirit.FireRemnant.Explode", self.caster.creeps_spell_Fire_RemnantTB[i])
                table.remove(self.caster.creeps_spell_Fire_RemnantTB, i)
                local heroes = FindUnitsInRadius(self.caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
                if #heroes>0 then  
                    for a=1,#heroes do
                        if not heroes[a]:IsMagicImmune() then 
                            EmitSoundOn("Hero_EmberSpirit.SearingChains.Target", heroes[a])
                            local dam=
                            {
                                victim = heroes[a], 
                                attacker = self.caster,
                                ability = self.ability,
                                damage = self.damage,
                                damage_type = self.ability:GetAbilityDamageType(),
                            }
                            ApplyDamage(dam)
                            -- heroes[a]:AddNewModifier( self.caster, self.ability, "modifier_searing_chains_debuff", {duration=self.duration} )
                            
                        end
                    end
                end 
            end
        end
        self.caster:RemoveModifierByName("modifier_creeps_spell_Fire_Remnant_duration")
    end  
end

function modifier_creeps_spell_Fire_Remnant_esr:CheckState() 
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
        [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
        [MODIFIER_STATE_UNTARGETABLE] = true, 
    } 
end

modifier_creeps_spell_Fire_Remnant_hb=class({})

function modifier_creeps_spell_Fire_Remnant_hb:IsHidden() 			return true end
function modifier_creeps_spell_Fire_Remnant_hb:IsPurgable() 			return false end
function modifier_creeps_spell_Fire_Remnant_hb:IsPurgeException() 	return false end
function modifier_creeps_spell_Fire_Remnant_hb:RemoveOnDeath() 	return true end
function modifier_creeps_spell_Fire_Remnant_hb:CheckState() 
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
        [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
    } 
end


modifier_creeps_spell_Fire_Remnant_duration=class({})

function modifier_creeps_spell_Fire_Remnant_duration:IsHidden() 			return false end
function modifier_creeps_spell_Fire_Remnant_duration:IsPurgable() 			return false end
function modifier_creeps_spell_Fire_Remnant_duration:IsPurgeException() 	return false end
function modifier_creeps_spell_Fire_Remnant_duration:RemoveOnDeath() 	return false end
function modifier_creeps_spell_Fire_Remnant_duration:GetAttributes() 	
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end