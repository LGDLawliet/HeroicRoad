creeps_spell_Tether = class({})



LinkLuaModifier("modifier_creeps_spell_Tether_effect", "creeps_spell/creeps_spell_Tether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Tether_spell", "creeps_spell/creeps_spell_Tether", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_creeps_spell_Tether_passive", "creeps_spell/creeps_spell_Tether", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Tether:IsHiddenWhenStolen() 		return false end
function creeps_spell_Tether:IsRefreshable() 			return true end
function creeps_spell_Tether:IsStealable() 				return true end
function creeps_spell_Tether:IsNetherWardStealable()		return true end

function creeps_spell_Tether:GetIntrinsicModifierName() return "modifier_creeps_spell_Tether_passive" end



function creeps_spell_Tether:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    local buffs1 = caster:FindAllModifiersByName("modifier_kill")
	if #buffs1 > 0 then
        if buffs1[1]:GetRemainingTime() < 2  then
            return
        end
	end
    target:AddNewModifier(caster, self, "modifier_creeps_spell_Tether_effect", {duration = 60})
    if self.trigger == nil then
        self.trigger = 1
        caster:AddNewModifier(caster, self, "modifier_kill", {duration = 62})
    end
end


modifier_creeps_spell_Tether_effect = class({})

function modifier_creeps_spell_Tether_effect:IsDebuff()			 return false end
function modifier_creeps_spell_Tether_effect:IsHidden() 			 return false end
function modifier_creeps_spell_Tether_effect:IsPurgable() 		 return false end
function modifier_creeps_spell_Tether_effect:IsPurgeException() 	 return false end



function modifier_creeps_spell_Tether_effect:OnCreated(keys)
    if not IsServer() then
        return
    end
    self.target			= self:GetParent()
    self.caster = self:GetAbility():GetCaster()
    self.buff = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_creeps_spell_Tether_spell", {duration = 60})
    local parent_pos = self.caster:GetAbsOrigin()
    local enemies_pos = self.target:GetAbsOrigin()
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(self.pfx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(parent_pos.x,parent_pos.y,parent_pos.z+100), true)
    ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(enemies_pos.x,enemies_pos.y,enemies_pos.z+100), true)
    self:StartIntervalThink(0.5)
    self.caster:EmitSound("Hero_Wisp.Tether")
    self.caster:EmitSound("Hero_Wisp.Tether.Target")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")*0.5
    self.damage_per = self:GetAbility():GetSpecialValueFor("damage_per")*0.5
    self.gold = self:GetAbility():GetSpecialValueFor("gold")*0.5
    self.gold_per = self:GetAbility():GetSpecialValueFor("gold_per")*0.5
end


function modifier_creeps_spell_Tether_effect:OnIntervalThink(table)
    if not IsServer() then
        return
    end
    if not self.caster or self.caster:IsNull() then
        self:SetDuration(0,true)
        return
    end
	local modifier = self.caster:FindModifierByName("modifier_kill")
	if modifier and modifier:GetRemainingTime() < 2 then
        self:SetDuration(0,true)
	end



    local distance = ( self.caster:GetOrigin() - self.target:GetOrigin() ):Length2D()
    
    if not self.target:IsAlive() then
        self:SetDuration(0,true)
    end
    if distance> 600 then
        self:SetDuration(0,true)
    end
    -- if self.target:IsInvulnerable() then
    --     self:SetDuration(0,true)
    -- end
    local modifier1 = self.target:FindModifierByName("modifier_Primary_infest")
    local modifier2= self.target:FindModifierByName("modifier_Middle_infest")
    local modifier3= self.target:FindModifierByName("modifier_Advanced_infest")
    if modifier1 or modifier2 or modifier3 then
        self:SetDuration(0,true)
    end
    local damageTable_enemy = {
        victim 			= self.target,
        attacker 		= self.caster,
        damage 			= self.damage,
        damage_type 	= self:GetAbility():GetAbilityDamageType(),
        ability 		= self:GetAbility(),
        damage_flags	= DOTA_DAMAGE_FLAG_NONE
    }
    ApplyDamage(damageTable_enemy)
    local heroes = GetAllRealHeroes()
   for  _, hero in pairs(heroes) do
    --    hero:SetGold(hero:GetGold() + self.gold, true)
       hero:ModifyGoldFiltered(self.gold,true,DOTA_ModifyGold_CreepKill )
       SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,hero, self.gold, nil)
   end

    self.damage = self.damage + self.damage_per
    self.gold = self.gold +self.gold_per


end

function modifier_creeps_spell_Tether_effect:OnDestroy()
    if not IsServer() then
        return
    end
    ParticleManager:DestroyParticle(self.pfx,false)
    self.caster:StopSound("Hero_Wisp.Tether")

    if self.buff and not self.buff:IsNull() then
        self.buff:SetDuration(0,true)
    end
    
     
    
end


modifier_creeps_spell_Tether_spell= class({})

function modifier_creeps_spell_Tether_spell:IsDebuff()			 return false end
function modifier_creeps_spell_Tether_spell:IsHidden() 			 return false end
function modifier_creeps_spell_Tether_spell:IsPurgable() 		 return false end
function modifier_creeps_spell_Tether_spell:IsPurgeException() 	 return false end




modifier_creeps_spell_Tether_passive = modifier_creeps_spell_Tether_passive or advanced_modifier({})
function modifier_creeps_spell_Tether_passive:IsHidden()	return false end
function modifier_creeps_spell_Tether_passive:IsDebuff()	return false end
function modifier_creeps_spell_Tether_passive:IsPurgable()	return false end
function modifier_creeps_spell_Tether_passive:IsPurgeException()	return false end
function modifier_creeps_spell_Tether_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -100
end
function modifier_creeps_spell_Tether_passive:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

