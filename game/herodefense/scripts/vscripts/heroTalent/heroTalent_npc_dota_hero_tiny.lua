heroTalent_npc_dota_hero_tiny = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tiny", "heroTalent/heroTalent_npc_dota_hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tiny_awaken", "heroTalent/heroTalent_npc_dota_hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_tiny_awaken_effect", "heroTalent/heroTalent_npc_dota_hero_tiny", LUA_MODIFIER_MOTION_NONE)
function heroTalent_npc_dota_hero_tiny:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_tiny:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_tiny:IsStealable() 				return true end
function heroTalent_npc_dota_hero_tiny:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_tiny:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_tiny" end

modifier_heroTalent_npc_dota_hero_tiny_awaken_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tiny_awaken_effect:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken_effect:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_tiny_awaken_effect:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken_effect:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken_effect:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end
function modifier_heroTalent_npc_dota_hero_tiny_awaken_effect:Advanced_GetModifierIncomingDamage_Percentage()
    return -100
end

modifier_heroTalent_npc_dota_hero_tiny_awaken = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tiny_awaken:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:OnCreated(table)
    self.line = self:GetAbility():GetSpecialValueFor("line")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MIN_HEALTH
    }
end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:GetMinHealth()
    if self:GetParent():GetHealthPercent() >= self.line then
       return 1 
    end
    return 
end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
    }
end
function modifier_heroTalent_npc_dota_hero_tiny_awaken:OnTakeDamage(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    
    if self:GetParent():GetHealth() == 1 and not self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_tiny_awaken_effect") then
        self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_tiny_awaken_effect",{duration = self.duration})
        --print("减伤已施加100%")
    end
end
        
modifier_heroTalent_npc_dota_hero_tiny = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tiny:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_tiny:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_tiny:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_tiny:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tiny:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_tiny:OnCreated(table)
    if not IsServer()  then
        return
    end
    if not self:GetParent():IsRealHero() then
		return false
	end
    self.grow_need = self:GetAbility():GetSpecialValueFor("grow_need")
	self.mode ="models/items/tiny/tiny_prestige/tiny_prestige_lvl_01.vmdl"
    self.effect_name = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf"
    self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetCaster():GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetCaster():GetAbsOrigin(), true )
    self:AddParticle( self.nFXIndex, false, false, -1, true, false )

    self.count = 0
    self.effect_state = true
    self:StartIntervalThink(1)
    self.awaken = false
end

function modifier_heroTalent_npc_dota_hero_tiny:OnWaveEnd()
    
    self.count = self.count +1
    return 1
end

function modifier_heroTalent_npc_dota_hero_tiny:OnIntervalThink()

    if not IsServer()  then
        return
    end
    local unit = self:GetParent()
    local ability = self:GetAbility()

	local stack =  self.count
	if stack>= 3*self.grow_need  then
        if self.mode ~= "models/items/tiny/tiny_prestige/tiny_prestige_lvl_04.vmdl" then
            self.mode =  "models/items/tiny/tiny_prestige/tiny_prestige_lvl_04.vmdl"
            self.effect_name = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl4_ambient.vpcf"
            unit:AddNewModifier(unit, ability, "modifier_stunned", {duration = 0.1})
            local pfx = ParticleManager:CreateParticle("particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_death_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(pfx)
            unit:EmitSound("Tiny.Grow")
            self:IncrementStackCount()
            -- self:StartIntervalThink(-1)
    
            ParticleManager:DestroyParticle(self.nFXIndex, true)
            self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl4_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetCaster():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetCaster():GetAbsOrigin(), true )
            self:AddParticle( self.nFXIndex, false, false, -1, true, false )
            self.effect_state = true

            self.awaken = true
            local modifier = self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_tiny_awaken")
            if not modifier then
               self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_heroTalent_npc_dota_hero_tiny_awaken",{}) 
            end
        end
		
    elseif stack>= 2*self.grow_need  then
        if self.mode ~= "models/items/tiny/tiny_prestige/tiny_prestige_lvl_03.vmdl" then
            self.mode =  "models/items/tiny/tiny_prestige/tiny_prestige_lvl_03.vmdl"
            self.effect_name = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_ambient.vpcf"
            unit:AddNewModifier(unit, ability, "modifier_stunned", {duration = 0.1})
            local pfx = ParticleManager:CreateParticle("particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_death_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(pfx)
            unit:EmitSound("Tiny.Grow")
            self:IncrementStackCount()
    
            ParticleManager:DestroyParticle(self.nFXIndex, true)
            self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetCaster():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetCaster():GetAbsOrigin(), true )
            self:AddParticle( self.nFXIndex, false, false, -1, true, false )
            self.effect_state = true
        end

	elseif stack>= self.grow_need then
        if self.mode ~= "models/items/tiny/tiny_prestige/tiny_prestige_lvl_02.vmdl" then
            self.mode =  "models/items/tiny/tiny_prestige/tiny_prestige_lvl_02.vmdl"
            self.effect_name = "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl2_ambient.vpcf"
    
            unit:AddNewModifier(unit, ability, "modifier_stunned", {duration = 0.1})
            local pfx = ParticleManager:CreateParticle("particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl3_death_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, unit:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(pfx)
            unit:EmitSound("Tiny.Grow")
            self:IncrementStackCount()
    
            ParticleManager:DestroyParticle(self.nFXIndex, true)
            self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl2_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetCaster():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetCaster():GetAbsOrigin(), true )
            self:AddParticle( self.nFXIndex, false, false, -1, true, false )
            self.effect_state = true
        end

	end
    -- 单位变形后会导致特效错误，所以变身时暂时把特效移除
    -- print(self:GetParent():GetModelName())
    if self:GetParent():GetModelName()~=self.mode then
        ParticleManager:DestroyParticle(self.nFXIndex, true)
        self.effect_state = false
    elseif not self.effect_state then
        self.effect_state = true
        self.nFXIndex = ParticleManager:CreateParticle( self.effect_name, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetCaster():GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetCaster():GetAbsOrigin(), true )
        self:AddParticle( self.nFXIndex, false, false, -1, true, false )
    end

end
function modifier_heroTalent_npc_dota_hero_tiny:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,           --攻击力
	}
end
function modifier_heroTalent_npc_dota_hero_tiny:GetModifierModelChange()
	if self.mode ~= nil then
		return self.mode
	else
	    return "models/items/tiny/tiny_prestige/tiny_prestige_lvl_01.vmdl"
	end
    -- return "models/heroes/axe/axe.vmdl"
end


function modifier_heroTalent_npc_dota_hero_tiny:GetModifierBaseAttack_BonusDamage() 
    self.bonus_base_damage = self:GetAbility():GetSpecialValueFor("bonus_base_damage")
    return self:GetStackCount()*self.bonus_base_damage 
end
function modifier_heroTalent_npc_dota_hero_tiny:Advanced_GetModifierAttackRangeBonus() 
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    return self:GetStackCount()*self.bonus_attack_range 
end



function modifier_heroTalent_npc_dota_hero_tiny:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
        advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
end

function modifier_heroTalent_npc_dota_hero_tiny:OnSummonUnit(keys)
	if IsServer() then
		if self.awaken == true then
            local unit = keys.target
		    unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_tiny_awaken", {})
        end
	end
end

