Advanced_Hand_in_hand_together = class ({})

LinkLuaModifier("modifier_Advanced_Hand_in_hand_together_caster", "skills/Advanced_Hand_in_hand_together", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Hand_in_hand_together_target", "skills/Advanced_Hand_in_hand_together", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Hand_in_hand_together_defense", "skills/Advanced_Hand_in_hand_together", LUA_MODIFIER_MOTION_NONE)


function Advanced_Hand_in_hand_together:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()
	if target == caster then
		return "#Spells_CustomCastError_NOT_SELF"
	end
    if IsEnemy(caster,target) then
		return "#Spells_CustomCastError_NOT_Enemy"
	end
    if target:HasModifier("modifier_Advanced_Hand_in_hand_together_target") or caster:HasModifier("modifier_Advanced_Hand_in_hand_together_caster") or caster:HasModifier("modifier_Advanced_Hand_in_hand_together_target") or target:HasModifier("modifier_Advanced_Hand_in_hand_together_caster") then
        return "你不能保护该目标"
    end
	return ""
end



function Advanced_Hand_in_hand_together:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target == caster or target:GetTeamNumber()~=caster:GetTeamNumber() or target:HasModifier("modifier_Advanced_Hand_in_hand_together_target") or caster:HasModifier("modifier_Advanced_Hand_in_hand_together_caster") or caster:HasModifier("modifier_Advanced_Hand_in_hand_together_target") or target:HasModifier("modifier_Advanced_Hand_in_hand_together_caster") then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end

function Advanced_Hand_in_hand_together:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    caster:AddNewModifier(caster,self,"modifier_Advanced_Hand_in_hand_together_caster",{duration = self:GetSpecialValueFor("duration"),target_ent		= target:entindex()})
    target:AddNewModifier(caster,self,"modifier_Advanced_Hand_in_hand_together_target",{duration = self:GetSpecialValueFor("duration")})
 
end
modifier_Advanced_Hand_in_hand_together_caster = class({})
function modifier_Advanced_Hand_in_hand_together_caster:IsDebuff()          return false end
function modifier_Advanced_Hand_in_hand_together_caster:IsHidden()          return false end
function modifier_Advanced_Hand_in_hand_together_caster:IsPurgable()        return false end
function modifier_Advanced_Hand_in_hand_together_caster:IsPurgeException()  return false end

function modifier_Advanced_Hand_in_hand_together_caster:OnCreated(keys)
    if IsServer() then
        self.target	= EntIndexToHScript(keys.target_ent)
    end
end
function modifier_Advanced_Hand_in_hand_together_caster:OnDestroy()
    if IsServer() then
        if self.target and  not self.target:IsNull() then
            self.target:RemoveModifierByName("modifier_Advanced_Hand_in_hand_together_target")
			self.target:RemoveModifierByName("modifier_Advanced_Hand_in_hand_together_defense")
        end
    end
end
function modifier_Advanced_Hand_in_hand_together_caster:AddEffects()
    if not self.pfx then
        local Parent = self:GetParent()
        self.pfx = ParticleManager:CreateParticle("particles/rebuild/particle_effect/attach_92/effect_lv2_ally_tube.vpcf",PATTACH_POINT_FOLLOW,Parent)
        ParticleManager:SetParticleControlEnt(self.pfx, 0, Parent, PATTACH_POINT_FOLLOW, "", Parent:GetAbsOrigin(), true)
        self:AddParticle(self.pfx, false, false, 15, false, false)
		Parent:AddNewModifier(self.target,self:GetAbility(),"modifier_Advanced_Hand_in_hand_together_defense",{duration = -1})
    end
  
end
function modifier_Advanced_Hand_in_hand_together_caster:RemoveEffects()
    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx,false)
        ParticleManager:ReleaseParticleIndex(self.pfx)
        self.pfx = nil
		local Parent = self:GetParent()
		Parent:RemoveModifierByName("modifier_Advanced_Hand_in_hand_together_defense")
    end
end

modifier_Advanced_Hand_in_hand_together_target = advanced_modifier({})
function modifier_Advanced_Hand_in_hand_together_target:IsDebuff()          return false end
function modifier_Advanced_Hand_in_hand_together_target:IsHidden()          return false end
function modifier_Advanced_Hand_in_hand_together_target:IsPurgable()        return false end
function modifier_Advanced_Hand_in_hand_together_target:IsPurgeException()  return false end

function modifier_Advanced_Hand_in_hand_together_target:OnCreated(keys)
    if IsServer() then
        self.target	= self:GetCaster()
        self.target_modifier = self.target:FindModifierByName("modifier_Advanced_Hand_in_hand_together_caster")
        self:StartIntervalThink(1)
    end
end
function modifier_Advanced_Hand_in_hand_together_target:OnDestroy()
    if IsServer() then
        if self.target and  not self.target:IsNull() then
            self.target:RemoveModifierByName("modifier_Advanced_Hand_in_hand_together_caster")
			self.target:RemoveModifierByName("modifier_Advanced_Hand_in_hand_together_defense")
        end
    end
end
function modifier_Advanced_Hand_in_hand_together_target:OnIntervalThink()
    if not self.target or self.target:IsNull() then
        return
    end
    local parent = self:GetParent()
    local dis = CalculateDistance(parent,self.target)
    if dis>=self.target:FindAbilityByName("Advanced_Hand_in_hand_together"):GetSpecialValueFor("radius") then --超过1000距离
        self.target_modifier:RemoveEffects()
        self:RemoveEffects()
    else
        self.target_modifier:AddEffects()
        self:AddEffects()
    end
end

function modifier_Advanced_Hand_in_hand_together_target:AddEffects()
    if not self.pfx then
        local Parent = self:GetParent()
        self.pfx = ParticleManager:CreateParticle("particles/rebuild/particle_effect/attach_92/effect_lv2_ally_tube.vpcf",PATTACH_POINT_FOLLOW,Parent)
        ParticleManager:SetParticleControlEnt(self.pfx, 0, Parent, PATTACH_POINT_FOLLOW, "", Parent:GetAbsOrigin(), true)
        self:AddParticle(self.pfx, false, false, 15, false, false)
        Parent:AddNewModifier(self.target,self:GetAbility(),"modifier_Advanced_Hand_in_hand_together_defense",{duration = -1})
    end
  
end
function modifier_Advanced_Hand_in_hand_together_target:RemoveEffects()
    if self.pfx then
        ParticleManager:DestroyParticle(self.pfx,false)
        ParticleManager:ReleaseParticleIndex(self.pfx)
        self.pfx = nil
		local Parent = self:GetParent()
		Parent:RemoveModifierByName("modifier_Advanced_Hand_in_hand_together_defense")
    end
end



function modifier_Advanced_Hand_in_hand_together_target:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK}
    return funcs
end


function modifier_Advanced_Hand_in_hand_together_target:GetModifierTotal_ConstantBlock(keys)
    if IsServer then
        local Ability = self:GetAbility()
        local advanced_level = Ability:GetSpecialValueFor("advanced_level")
        if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
            return 0	
        end
        if advanced_level < 20 then
            if bit.band(keys.damage_category , DOTA_DAMAGE_CATEGORY_ATTACK) ~= DOTA_DAMAGE_CATEGORY_ATTACK then 
                return 0 
            end
        end
        local caster = self:GetCaster()
        local parent = self:GetParent()
        if CalculateDistance(parent,self.target)>=self.target:FindAbilityByName("Advanced_Hand_in_hand_together"):GetSpecialValueFor("radius") then
            return 0
        end
        local damage = 0
        local ability = self:GetAbility()
            if advanced_level >= 15 then
                damage = keys.damage * 0.75
            else
                damage = keys.damage * 0.5
            end
        local damage_two = 0
        if caster:GetHealth() <= caster:GetMaxHealth() * 0.25 then
            if advanced_level >= 5 then
                damage_two = damage * (1-(ability:GetSpecialValueFor("Damage_reduction_of_free") + ability:GetSpecialValueFor("Damage_reduction_of_free_two") + advanced_level * 0.5 + 10)*0.01)
            else
                damage_two = damage * (1-(ability:GetSpecialValueFor("Damage_reduction_of_free") + ability:GetSpecialValueFor("Damage_reduction_of_free_two") + advanced_level * 0.5)*0.01)
            end
        else
            damage_two = damage * (1-(ability:GetSpecialValueFor("Damage_reduction_of_free") + advanced_level * 0.5)*0.01)
        end
        local damagetable = {
            victim = caster ,
            attacker = keys.attacker ,
            damage = damage_two ,
            damage_type = keys.damage_type ,
            damage_flags = DOTA_DAMAGE_FLAG_NONE ,
            ability = ability
            }
        ApplyDamage(damagetable)
        return damage

    end
end

modifier_Advanced_Hand_in_hand_together_defense = advanced_modifier({})

function modifier_Advanced_Hand_in_hand_together_defense:IsDebuff()          return false end
function modifier_Advanced_Hand_in_hand_together_defense:IsHidden()          return true end
function modifier_Advanced_Hand_in_hand_together_defense:IsPurgable()        return false end
function modifier_Advanced_Hand_in_hand_together_defense:IsPurgeException()  return false end

function modifier_Advanced_Hand_in_hand_together_defense:DeclareFunctions()
    local funcs = {
      
    }
    if self:GetAbility():GetSpecialValueFor("advanced_level")>=10 then
        table.insert(funcs,MODIFIER_PROPERTY_HEALTH_BONUS)
    end
    return funcs
end



function modifier_Advanced_Hand_in_hand_together_defense:Advanced_GetModifierPhysicalArmorBonus()
	return 15
end
function modifier_Advanced_Hand_in_hand_together_defense:OnCreated()
    if IsServer() then
        self.bonus_health = (self:GetParent():GetMaxHealth()+self:GetCaster():GetMaxHealth())/10
    end
end
function modifier_Advanced_Hand_in_hand_together_defense:GetModifierHealthBonus()
    if IsClient() then
        return
    end
    return self.bonus_health 
end

function modifier_Advanced_Hand_in_hand_together_defense:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end