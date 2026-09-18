heroTalent_npc_dota_hero_zuus_3 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_zuus_3", "heroTalent/heroTalent_npc_dota_hero_zuus_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_zuus_3_effect", "heroTalent/heroTalent_npc_dota_hero_zuus_3", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect", "heroTalent/heroTalent_npc_dota_hero_zuus_3", LUA_MODIFIER_MOTION_NONE)




function heroTalent_npc_dota_hero_zuus_3:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_zuus_3:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_zuus_3:IsStealable() 				return true end
function heroTalent_npc_dota_hero_zuus_3:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_zuus_3:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_zuus_3" end



function heroTalent_npc_dota_hero_zuus_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", context )

end







function heroTalent_npc_dota_hero_zuus_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function heroTalent_npc_dota_hero_zuus_3:OnUpgrade()
    if IsServer() then
        self:SetCurrentAbilityCharges(0)
    end
end

function heroTalent_npc_dota_hero_zuus_3:OnSpellStart(unlock3) 

    local ability 				= self
    local caster 				= self:GetCaster()
    local pos = self:GetCursorPosition()
    local caster_pos = caster:GetOrigin()
    local dir = CalculateDirection(pos,caster_pos)
    local start_pos = pos - dir *3000 + Vector(0,0,1000)

    local modifier =  caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_zuus_3_effect", {duration = 10})
    if modifier then
        modifier:Init(start_pos,pos)
    end


    




    


    
    
end



modifier_heroTalent_npc_dota_hero_zuus_3 = class({})

function modifier_heroTalent_npc_dota_hero_zuus_3:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_zuus_3:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_zuus_3:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_zuus_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_zuus_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_zuus_3:OnCreated()
    if IsServer() then
        self.max = self:GetAbility():GetSpecialValueFor("max")
    end
end
function modifier_heroTalent_npc_dota_hero_zuus_3:OnRefresh(keys)
    self:OnCreated()
end



function modifier_heroTalent_npc_dota_hero_zuus_3:OnAbilityExecuted(keys)  
    if IsServer() then
        if keys.ability:GetCooldown(keys.ability:GetLevel()) < 2  then
            return
        end
        local parent = self:GetParent()
        if parent:PassivesDisabled() then
            return
        end
        local ability = self:GetAbility()
        if keys.unit == parent then
            if keys.ability==ability then
                return
            end
         
            ability:SetCurrentAbilityCharges(math.min(ability:GetCurrentAbilityCharges()+1,self.max))
        end


    end
end

function modifier_heroTalent_npc_dota_hero_zuus_3:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end





modifier_heroTalent_npc_dota_hero_zuus_3_effect = class({})

function modifier_heroTalent_npc_dota_hero_zuus_3_effect:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_zuus_3_effect:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_zuus_3_effect:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_zuus_3_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_zuus_3_effect:RemoveOnDeath() return false end


function modifier_heroTalent_npc_dota_hero_zuus_3_effect:Init(start_pos,pos)
    self.start_pos = start_pos
    self.pos = pos
    self.count = self:GetAbility():GetCurrentAbilityCharges()
    self:GetAbility():SetCurrentAbilityCharges(0)

    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.damage_index = self:GetAbility():GetSpecialValueFor("damage_index")
    self:StartIntervalThink(0.1)
end


function modifier_heroTalent_npc_dota_hero_zuus_3_effect:OnIntervalThink()
    if self.count<=0 then
        self:Destroy()
        return
    end
    self.count = self.count - 1
    

    local ability = self:GetAbility()
    local caster = self:GetCaster()

    local target_pos = self.pos+RandomVector(200)
    local particle_target = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle_target, 0, target_pos)
    ParticleManager:SetParticleControl(particle_target, 1,self.start_pos)
    ParticleManager:ReleaseParticleIndex(particle_target)
    caster:EmitSound("Hero_Zuus.GodsWrath.Target")

    local pos_table = {}
    table.insert(pos_table,target_pos)
    if self.count>=3 then
        self.count = self.count - 1
        local new_pos = self.pos+RandomVector(200)

        local particle_target = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock2/effect_group.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(particle_target, 0, new_pos)
        ParticleManager:SetParticleControl(particle_target, 1,self.start_pos+RandomVector(100))
        ParticleManager:ReleaseParticleIndex(particle_target)
        table.insert(pos_table,new_pos)
    end


    -- 伤害
    local damage = self.damage_index*caster:GetIntellect(false)
    for _, target_pos in ipairs(pos_table) do
        local nearby_enemy_units = FindUnitsInRadius(
            caster:GetTeamNumber(), 
            target_pos , 
            nil, 
            self.radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_CLOSEST, 
            false
        )
        if #nearby_enemy_units ~= 0 then
            
            for i, unit in pairs(nearby_enemy_units) do
                unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect", {duration = 1,stack = damage})
			

                -- damage_table.victim 		= unit
                -- ApplyDamage(damage_table)
    
            end

        end
    end

end










modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect = class({})

function modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(RandomFloat(0.03, 0.2))
	end
end

function modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.stack)

	end
end
function modifier_heroTalent_npc_dota_hero_zuus_3_damage_effect:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage =  self:GetStackCount(),
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
		ability = ability,
		}
	ApplyDamage(damageTable)

	self:SetStackCount(0)
	self:SafeDestroy()
end




