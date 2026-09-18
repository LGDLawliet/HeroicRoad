--特效优化 √
Advanced_Ice_Vortex = class({})

LinkLuaModifier("modifier_Advanced_Ice_Vortex_1", "skills/Advanced_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ice_Vortex_2", "skills/Advanced_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ice_Vortex_debuff", "skills/Advanced_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Ice_Vortex_buff", "skills/Advanced_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_normal_stun", "skills/skills_effect/modifier_normal_stun", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Ice_Vortex_unlock3", "skills/Advanced_Ice_Vortex", LUA_MODIFIER_MOTION_NONE)
function Advanced_Ice_Vortex:IsHiddenWhenStolen()       return false end
function Advanced_Ice_Vortex:IsStealable() 	            return true end
function Advanced_Ice_Vortex:IsNetherWardStealable()    return true end
function Advanced_Ice_Vortex:IsRefreshable() 			return true end
function Advanced_Ice_Vortex:ProcsMagicStick() 			return true end


function Advanced_Ice_Vortex:CheckKV(key)
	local table = {

	
		radius =15,
		speed_slow =4,
		life_duration = 0.1,


	}
	local value = table[key] or -1
	return value

end


function Advanced_Ice_Vortex:UnlockFirstCore(key)
	return true
end
function Advanced_Ice_Vortex:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end
function Advanced_Ice_Vortex:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Ice_Vortex_unlock3",{})
	return true
end


function Advanced_Ice_Vortex:GetAOERadius() 			
    return  self:GetSpecialValueFor("radius")
end

function Advanced_Ice_Vortex:OnSpellStart()
	local curpos = self:GetCursorPosition()
    local caster = self:GetCaster() 
    local radius = self:GetSpecialValueFor("radius")
    if self.unlock2 then
        radius = radius*2
    end
    local duration = self:GetSpecialValueFor("life_duration") 
    EmitSoundOn("Hero_Ancient_Apparition.IceVortexCast", caster)

    local particle = ParticleManager:CreateParticle("particles/new_effect/coup_de_grace/ice_windrun.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle, 0, curpos+caster:GetUpVector()*90)
	ParticleManager:SetParticleControl( particle, 3, Vector(radius,0,0))
    ParticleManager:SetParticleControl( particle, 60, Vector(radius*1.2,0,0))
	local particle3 = ParticleManager:CreateParticle("particles/new_effect/coup_de_grace/ice_windrun.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle3, 0, curpos+caster:GetUpVector()*180)
    ParticleManager:SetParticleControl( particle3, 60, Vector(radius*1.2,0,0))
	local particle2 = ParticleManager:CreateParticle("particles/new_effect/coup_de_grace/new_ice_wind_dust.vpcf", PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particle2, 0, curpos+caster:GetUpVector()*100)


    CreateModifierThinker(caster, self, "modifier_Advanced_Ice_Vortex_1", {duration =duration}, curpos, caster:GetTeamNumber(), false) 
    --LV15解锁冷却
    if self.advanced_level>=15 then
        CreateModifierThinker(caster, self, "modifier_Advanced_Ice_Vortex_2", {duration =duration}, curpos, caster:GetTeamNumber(), false) 
    end


    Timers:CreateTimer(duration, function()
	ParticleManager:DestroyParticle( particle, false )
	ParticleManager:DestroyParticle( particle2, false )
	ParticleManager:DestroyParticle( particle3, false )
    return nil  end)

    -- local particle4 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf",   PATTACH_WORLDORIGIN, caster) 
    -- ParticleManager:SetParticleControl( particle4, 0,curpos)
    -- local particle5 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf",   PATTACH_WORLDORIGIN, caster) 
    -- ParticleManager:SetParticleControl( particle5, 0,curpos)
    -- local dis=100
    -- local dis_min=500
    -- local pos2=curpos.z+1000
    -- local pos3=curpos.z+1000
    -- local delay = 4
    --气旋造形+
    -- local ability = self
    if self.advanced_level>=5  then
        -- delay = 2
        -- damage = damage*0.7
        self:CreateCycloneShape(curpos,2)
    end

    self:CreateCycloneShape(curpos,4)
end
function Advanced_Ice_Vortex:CreateCycloneShape(pos,delay)
    local ZPos=pos.z+1000
    local stun = self:GetSpecialValueFor("stun_duration")
    local caster = self:GetCaster()
    local damage = self:GetSpecialValueFor("basic_damage")+ caster:GetIntellect(false) * self:GetSpecialValueFor("intelligence_index")
    if self.advanced_level>=5  then
        -- delay = 2
        damage = damage*0.7
        -- self:CreateCycloneShape(curpos,2)
    end
    local radius = self:GetSpecialValueFor("radius")
    local particleIndex = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf",   PATTACH_WORLDORIGIN, caster) 
    ParticleManager:SetParticleControl( particleIndex, 0,pos)
    Timers:CreateTimer(delay, function()
        ZPos=ZPos-50
        ParticleManager:SetParticleControl( particleIndex, 3,Vector(pos.x,pos.y,ZPos))
        if ZPos<=pos.z then
            
            ParticleManager:DestroyParticle( particleIndex, false )
            ParticleManager:ReleaseParticleIndex( particleIndex )
            local particle = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_WORLDORIGIN, caster) 
            ParticleManager:SetParticleControl( particle, 0,pos)
            ParticleManager:SetParticleControl( particle, 3,pos)
            Timers:CreateTimer(1, function()
                ParticleManager:ReleaseParticleIndex( particle )
                ParticleManager:DestroyParticle( particle, false )
               
            end)

            if not self or self:IsNull() then
                return
            end
            EmitSoundOnLocationWithCaster(pos, "Hero_Ancient_Apparition.IceBlast.Target", caster)
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
                    for _,target in pairs(enemies) do
                            if not target:IsMagicImmune() then         
                                local damageTable = {
                                    attacker = caster,
                                    victim = target,
                                    damage = damage,
                                    damage_type = self:GetAbilityDamageType(),
                                    ability = self,
                                    hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE
                                }
                                local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
                                local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
                                target:AddNewModifier(caster, self, "modifier_normal_stun", {duration =stun*StatusResistance})
                                ApplyDamage(damageTable) 
                            end
                    end
            return nil
        else
            return FrameTime()
        end
    end
    )
end
modifier_Advanced_Ice_Vortex_1 = class({})
function modifier_Advanced_Ice_Vortex_1:IsDebuff()				return true  end
function modifier_Advanced_Ice_Vortex_1:IsPurgable() 			return false end
function modifier_Advanced_Ice_Vortex_1:IsPurgeException()   	return false end
function modifier_Advanced_Ice_Vortex_1:IsHidden()				return true  end
function modifier_Advanced_Ice_Vortex_1:IsAura()                return true  end
function modifier_Advanced_Ice_Vortex_1:GetAuraDuration()       return 0.1   end
function modifier_Advanced_Ice_Vortex_1:GetModifierAura()       return "modifier_Advanced_Ice_Vortex_debuff" end
function modifier_Advanced_Ice_Vortex_1:GetAuraRadius()        
    return  self.radius end
function modifier_Advanced_Ice_Vortex_1:GetAuraSearchFlags()    return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Advanced_Ice_Vortex_1:GetAuraSearchTeam()     return DOTA_UNIT_TARGET_TEAM_ENEMY  end
function modifier_Advanced_Ice_Vortex_1:GetAuraSearchType()     return  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Ice_Vortex_1:OnCreated()
    if IsServer() then
        self.radius = self:GetAbility():GetSpecialValueFor("radius")
        if self:GetAbility().unlock2 then
            self.radius = self.radius*2
        end 
    end
end
function modifier_Advanced_Ice_Vortex_1:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end


---------------------------------------------------------------------------------------------------------------
modifier_Advanced_Ice_Vortex_debuff = advanced_modifier({})
function modifier_Advanced_Ice_Vortex_debuff:IsDebuff()				return true  end
function modifier_Advanced_Ice_Vortex_debuff:IsPurgable() 			return false end
function modifier_Advanced_Ice_Vortex_debuff:IsPurgeException() 	return true end
function modifier_Advanced_Ice_Vortex_debuff:IsHidden()				return false end
function modifier_Advanced_Ice_Vortex_debuff:GetStatusEffectName()  return "particles/status_fx/status_effect_frost_lich.vpcf" end
function modifier_Advanced_Ice_Vortex_debuff:StatusEffectPriority() return 20 end
function modifier_Advanced_Ice_Vortex_debuff:GetAttributes()
    if IsServer() and self:GetAbility() and self:GetAbility().unlock1 then
        return MODIFIER_ATTRIBUTE_MULTIPLE
    end
end
function modifier_Advanced_Ice_Vortex_debuff:OnCreated( table )
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

    self.speed_slow=self:GetAbility():GetSpecialValueFor("speed_slow") 
    self.damage_bonus=self:GetAbility():GetSpecialValueFor("damage_bonus")
    --LV10解锁脆弱化+
    if self.advanced_level>=10 then
        self.damage_bonus = 25
    end
    self.spell_damage_reduce = 0
    --LV20解锁魔力吸收
    if self.advanced_level>=20 then
        self.spell_damage_reduce = -20
    end
    if self:GetAbility():GetUnlock(1)==1 then
        self.spell_damage_reduce = -11
        self.damage_bonus = 15
    end
    self.unlock2Table = {}
end
function modifier_Advanced_Ice_Vortex_debuff:OnDestroy(  )
    self.speed_slow=nil
    self.damage_bonus_in=nil
    self.spell_damage_reduce = nil
end
function modifier_Advanced_Ice_Vortex_debuff:DeclareFunctions() return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

    } 
end
function modifier_Advanced_Ice_Vortex_debuff:GetModifierMoveSpeedBonus_Constant() return (0- self.speed_slow) end
function modifier_Advanced_Ice_Vortex_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys) 
    if IsServer() then
        local ability = self:GetAbility()
        if ability and ability.unlock2 then
            if keys.inflictor then
                if not self.unlock2Table[keys.inflictor] then
                    self.unlock2Table[keys.inflictor] = 0
                end
                self.unlock2Table[keys.inflictor] = (self.unlock2Table[keys.inflictor]+1) 
                return  self.damage_bonus +math.min( self.unlock2Table[keys.inflictor]*5,200)
            end
            return  self.damage_bonus
        end
    end
    return  self.damage_bonus 
end
function modifier_Advanced_Ice_Vortex_debuff:Advanced_GetModifierSpellAmplifyBonus() return  self.spell_damage_reduce end




function modifier_Advanced_Ice_Vortex_debuff:ADDeclareFunctions()

	local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
	return funcs
end


modifier_Advanced_Ice_Vortex_2 = class({})
function modifier_Advanced_Ice_Vortex_2:IsDebuff()				return true  end
function modifier_Advanced_Ice_Vortex_2:IsPurgable() 			return false end
function modifier_Advanced_Ice_Vortex_2:IsPurgeException()   	return false end
function modifier_Advanced_Ice_Vortex_2:IsHidden()				return true  end
function modifier_Advanced_Ice_Vortex_2:IsAura()                return true  end
function modifier_Advanced_Ice_Vortex_2:GetAuraDuration()       return 0.1   end
function modifier_Advanced_Ice_Vortex_2:GetModifierAura()       return "modifier_Advanced_Ice_Vortex_buff" end
function modifier_Advanced_Ice_Vortex_2:GetAuraRadius()        
    return self.radius
end
function modifier_Advanced_Ice_Vortex_2:GetAuraSearchFlags()    return DOTA_UNIT_TARGET_FLAG_NONE  end
function modifier_Advanced_Ice_Vortex_2:GetAuraSearchTeam()     return DOTA_UNIT_TARGET_TEAM_FRIENDLY  end
function modifier_Advanced_Ice_Vortex_2:GetAuraSearchType()     return  DOTA_UNIT_TARGET_HERO  end
function modifier_Advanced_Ice_Vortex_2:OnCreated()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_Advanced_Ice_Vortex_2:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

---------------------------------------------------------------------------------------------------------------
modifier_Advanced_Ice_Vortex_buff = class({})
function modifier_Advanced_Ice_Vortex_buff:IsDebuff()				return false  end
function modifier_Advanced_Ice_Vortex_buff:IsPurgable() 			return false end
function modifier_Advanced_Ice_Vortex_buff:IsPurgeException() 	return true end
function modifier_Advanced_Ice_Vortex_buff:IsHidden()				return false end
function modifier_Advanced_Ice_Vortex_buff:GetStatusEffectName()  return "particles/status_fx/status_effect_frost_lich.vpcf" end
function modifier_Advanced_Ice_Vortex_buff:StatusEffectPriority() return 20 end

function modifier_Advanced_Ice_Vortex_buff:OnCreated( table )
    local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self.speed_slow = 0
        return
	end
    if IsServer() then
        self:StartIntervalThink(0.3)
    end
end
function modifier_Advanced_Ice_Vortex_buff:OnIntervalThink( table )
    local ability = self:GetAbility()
	if not ability or ability:IsNull() then
        self:SafeDestroy()
        return
	end
    if IsServer() then
        local parent = self:GetParent()
        for i=1, parent:GetAbilityCount() - 1 do
            local Ability = parent:GetAbilityByIndex(i)
            if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self  and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
                local newCooldown = Ability:GetCooldownTimeRemaining() - 0.09
                Ability:EndCooldown()
                Ability:StartCooldown(newCooldown)

                break
            end
        end
        
    end
end



modifier_Advanced_Ice_Vortex_unlock3 = class({})

function modifier_Advanced_Ice_Vortex_unlock3:IsDebuff()			return false end
function modifier_Advanced_Ice_Vortex_unlock3:IsHidden() 			return true end
function modifier_Advanced_Ice_Vortex_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Ice_Vortex_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Ice_Vortex_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Ice_Vortex_unlock3:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_Advanced_Ice_Vortex_unlock3:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 3 then
		return
	end


	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end

	if self:GetParent():PassivesDisabled()  then
		return
	end
    if keys.ability:IsRefreshable() then
        Timers:CreateTimer(3, function()
            local cooldown = keys.ability:GetCooldownTimeRemaining()
            if cooldown>=0.1 then
                local new = cooldown * RandomFloat(0.6, 1.1)
                keys.ability:EndCooldown()
                keys.ability:StartCooldown(new)
            end
    
            return nil  
        end)
    end


end
