Advanced_Windrun = class({})
LinkLuaModifier("modifier_Advanced_Windrun_buff", "skills/Advanced_Windrun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Windrun_walk_motion", "skills/Advanced_Windrun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Windrun_walk_unlock1", "skills/Advanced_Windrun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Windrun_walk_unlock2", "skills/Advanced_Windrun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Windrun_walk_unlock2_thinker", "skills/Advanced_Windrun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Windrun_walk_unlock3", "skills/Advanced_Windrun", LUA_MODIFIER_MOTION_NONE)

function Advanced_Windrun:CheckKV(key)
	local table = {
        duration=0.2,


	}
	local value = table[key] or -1
	return value

end

function Advanced_Windrun:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock1",{})
	return true
end
function Advanced_Windrun:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	return true
end
function Advanced_Windrun:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_mana_shield_unlock3",{})
	return true
end
function Advanced_Windrun:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_powershot_channel_endcap_model.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/winrun/unlock2/effect_spirit_static_remnant.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/windrun/unlock2/effect.vpcf", context )
end

function Advanced_Windrun:IsHiddenWhenStolen()         return false end
function Advanced_Windrun:IsStealable()                return true end
function Advanced_Windrun:IsNetherWardStealable()      return true end
function Advanced_Windrun:IsRefreshable() 			    return true end
function Advanced_Windrun:ProcsMagicStick() 			return true end
function Advanced_Windrun:OnSpellStart() 			
    local caster=self:GetCaster()
    EmitSoundOn("Ability.Windrun", caster)    
    local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.3)
    local duration = self:GetSpecialValueFor("duration")
    caster:AddNewModifier(caster, self, "modifier_Advanced_Windrun_buff", {duration= duration*ModifierStatusGain}) 
    if self.unlock2 then
        caster:AddNewModifier(caster, self, "modifier_Advanced_Windrun_walk_unlock2", {duration= duration*ModifierStatusGain}) 
    end
    if self.unlock3 then
        caster:AddNewModifier(caster, self, "modifier_Advanced_Windrun_walk_unlock3", {duration= duration*ModifierStatusGain}) 
    end
end
function Advanced_Windrun:Spawn()
	self.remnant = {}

end
function Advanced_Windrun:Addstack(modifier)
	table.insert(self.remnant,modifier)
end
function Advanced_Windrun:RemoveStack(modifier)

    for key, value in pairs(self.remnant) do
        if value==modifier then
            table.remove(self.remnant,key)
            break
        end
    end
end
function Advanced_Windrun:RemoveAll()
    for i = 1, #self.remnant, 1 do
        local modifier = self.remnant[1]
        table.remove(self.remnant,1)
        modifier:SafeDestroy()
    end

end
function Advanced_Windrun:FindFirstRemnant()
    for i = 1, #self.remnant, 1 do
        local modifier = self.remnant[1]
        if not modifier:IsNull() then
            return modifier
        end
    end
    return nil
end

function Advanced_Windrun:GetRemnantCount()
    local count = 0
    for i = 1, #self.remnant, 1 do
        local modifier = self.remnant[1]
        if not modifier:IsNull() then
            count = count + 1
        end
    end
    return count
end




modifier_Advanced_Windrun_buff = advanced_modifier({})

function modifier_Advanced_Windrun_buff:IsBuff()                return true end
function modifier_Advanced_Windrun_buff:IsPurgable() 			return false end
function modifier_Advanced_Windrun_buff:IsPurgeException() 		return true end
function modifier_Advanced_Windrun_buff:IsHidden()				return false end
function modifier_Advanced_Windrun_buff:RemoveOnDeath()      	return true end



function modifier_Advanced_Windrun_buff:GetEffectName()         return "particles/new_effect/coup_de_grace/new_windrun_big.vpcf" end
function modifier_Advanced_Windrun_buff:GetEffectAttachType()   return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Windrun_buff:OnCreated( )
    local ability = self:GetAbility()
	local caster = self:GetCaster()
	local advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

    self.bonus_move = 0
    --LV5解锁风之姿+
    if advanced_level>=5 then
        self.bonus_move = 300
    end
    self.Evasion = 90
    --LV15解锁风之姿++
    if advanced_level>=15 then
        self.Evasion = 95
        -- self.Evasion = 0
    end

    self.anyMove = fasle
    --LV20解锁凌云
    if advanced_level>=20 then
        self.anyMove = true
    end

    if not IsServer() then
      return
    end
    self.damage_index = ability:GetSpecialValueFor("agility_index")
    --LV10解锁风之领域+
    if advanced_level>=10 then
        self.damage_index = self.damage_index *2
    end
    self.timer = 0
    self:StartIntervalThink(0.3)
end


function modifier_Advanced_Windrun_buff:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	}
end
function modifier_Advanced_Windrun_buff:GetModifierEvasion_Constant() return self.Evasion end
function modifier_Advanced_Windrun_buff:GetModifierMoveSpeedBonus_Percentage() return   self:GetAbility():GetSpecialValueFor("bonus_move_speed") end
function modifier_Advanced_Windrun_buff:GetModifierIgnoreMovespeedLimit()             return   1  end
function modifier_Advanced_Windrun_buff:GetModifierMoveSpeedBonus_Constant()             return   self.bonus_move  end
----------------------------------------------------------------------------------------------------
function modifier_Advanced_Windrun_buff:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local uint_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

    for _, target in pairs( uint_enemies) do
        if not target:IsMagicImmune() then
        	local caster = self:GetCaster()

            local damage = self.damage_index * caster:GetAgility()
            local damageTable = {
                attacker = caster,
                victim = target,
                damage = damage,
                damage_type =ability:GetAbilityDamageType(),
                ability = self
            }
            ApplyDamage(damageTable) 
            target:AddNewModifier(caster, ability, "modifier_Advanced_Windrun_walk_motion", {duration = 0.4,})  
        end
    end	
    if ability.unlock1 then
        self.timer = self.timer  +0.3
        if self.timer>=1.2 then
            self.timer = 0
            caster:AddNewModifier(caster, ability, "modifier_Advanced_Windrun_walk_unlock1", {duration = 0.1,})  
        end
        -- modifier_Advanced_Windrun_walk_unlock1
    end
end



function modifier_Advanced_Windrun_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_Advanced_Windrun_buff:Advanced_GetModifier_FlyingPathing()	
    if self.anyMove then  
        return 1
    end
	return 0
end




----------------------------------------------------------------------------------------------------------------------------------
modifier_Advanced_Windrun_walk_motion = class({})

function modifier_Advanced_Windrun_walk_motion:IsDebuff()			return false end
function modifier_Advanced_Windrun_walk_motion:IsHidden() 			return true end
function modifier_Advanced_Windrun_walk_motion:IsPurgable() 		return false end
function modifier_Advanced_Windrun_walk_motion:IsPurgeException() 	return false end
function modifier_Advanced_Windrun_walk_motion:IsMotionController() return true end
function modifier_Advanced_Windrun_walk_motion:OnCreated(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 300
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_Advanced_Windrun_walk_motion:OnRefresh(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 300
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Advanced_Windrun_walk_motion:OnIntervalThink(keys)   
    if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    ResolveNPCPositions(new_pos, 70)
    end
end



modifier_Advanced_Windrun_walk_unlock1 = class({})

function modifier_Advanced_Windrun_walk_unlock1:IsBuff()                return true end
function modifier_Advanced_Windrun_walk_unlock1:IsPurgable() 			return false end
function modifier_Advanced_Windrun_walk_unlock1:IsPurgeException() 		return true end
function modifier_Advanced_Windrun_walk_unlock1:IsHidden()				return true end
function modifier_Advanced_Windrun_walk_unlock1:RemoveOnDeath()      	return true end
function modifier_Advanced_Windrun_walk_unlock1:OnCreated( )
    if IsServer() then
        local caster = self:GetCaster()
        if caster:IsMoving() then
            caster:EmitSound("wind_run_sonic_boom")
            local ability = self:GetAbility()
            local caster_loc = caster:GetOrigin()
            local dir = CalculateDirection(caster_loc+caster:GetForwardVector(), caster_loc)
            local pfx_min = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_powershot_channel_endcap_model.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx_min, 0, Vector(caster_loc.x-dir.x*200, caster_loc.y-dir.y*200, caster_loc.z + 128))
            ParticleManager:SetParticleControl(pfx_min, 1, Vector(caster_loc.x-dir.x*200, caster_loc.y-dir.y*200, caster_loc.z + 128))
            ParticleManager:SetParticleControlForward(pfx_min, 1, dir)  --方向
            ParticleManager:ReleaseParticleIndex(pfx_min)
            local uint_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, 600, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
        
	        local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	


	
            for _, target in pairs( uint_enemies) do
                if not target:IsMagicImmune() then
                    local caster = self:GetCaster()
        
                    local damage = caster:GetAgility()*5
                    local damageTable = {
                        attacker = caster,
                        victim = target,
                        damage = damage,
                        damage_type =ability:GetAbilityDamageType(),
                        ability = ability
                    }
                    ApplyDamage(damageTable) 
                    if target:IsAlive() then
                        local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
                        target:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.5*StatusResistance,})  
                    end

                end
            end	
        end
    
    end
end
function modifier_Advanced_Windrun_walk_unlock1:DeclareFunctions()
    return 
    {
        -- MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        -- MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, 
	}
end
function modifier_Advanced_Windrun_walk_unlock1:GetModifierMoveSpeed_AbsoluteMin()
    return   10000 
end
function modifier_Advanced_Windrun_walk_unlock1:GetModifierMoveSpeed_AbsoluteMax()
    return   10000 
end






modifier_Advanced_Windrun_walk_unlock2 = advanced_modifier({})

function modifier_Advanced_Windrun_walk_unlock2:IsDebuff()			return false end
function modifier_Advanced_Windrun_walk_unlock2:IsHidden() 			return true end
function modifier_Advanced_Windrun_walk_unlock2:IsPurgable() 		    return true end
function modifier_Advanced_Windrun_walk_unlock2:IsPurgeException() return true end
function modifier_Advanced_Windrun_walk_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Windrun_walk_unlock2:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.dis = 0
        self.currentPos = self.parent:GetAbsOrigin()
        self:StartIntervalThink(0.03)     

    end
end
function modifier_Advanced_Windrun_walk_unlock2:OnRefresh()
    if IsServer() then
        self:GetAbility():RemoveAll()
    end
end
function modifier_Advanced_Windrun_walk_unlock2:OnDestroy()
    if IsServer() then
        self:GetAbility():RemoveAll()
    end
end
function modifier_Advanced_Windrun_walk_unlock2:OnIntervalThink()
  
    local move_dis =  CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    if move_dis >=500 then
        self.currentPos = self.parent:GetAbsOrigin()
        return
    end
    self.dis =self.dis+ move_dis
    self.currentPos = self.parent:GetAbsOrigin()
    if self.dis>=700 and self:GetAbility():GetRemnantCount()<=20 then
        self.dis = 0
        
        local hRemnant = CreateUnitByName("npc_dota_thinker", self.parent:GetAbsOrigin(), false, self.parent, self.parent, self.parent:GetTeamNumber())
        -- hRemnant:ResistSpawneNeutral(false)
        hRemnant:AddNewModifier(self.parent, self:GetAbility(), "modifier_Advanced_Windrun_walk_unlock2_thinker", { duration = 20 })
        hRemnant:SetForwardVector(self.parent:GetForwardVector())
    end
end


function modifier_Advanced_Windrun_walk_unlock2:Advanced_GetModifierIncomingDamage_Percentage( keys )
	if not IsServer() then
		return
	end
	-- if keys.target~=self:GetParent() then return end
    local parent = keys.target
    if keys.damage >= parent:GetHealth()   then
        local ability = self:GetAbility()
        local modifier = ability:FindFirstRemnant()
        if modifier then
            local target = modifier:GetParent()
            local caster = self:GetParent()
            local target_pos = target:GetOrigin()
            local caster_loc = caster:GetOrigin()
            FindClearSpaceForUnit( caster,target_pos, true)
            modifier:SafeDestroy()
            self:SetDuration(self:GetRemainingTime()-0.1, true)
            caster:EmitSound("windrun_move")



            local pfx_min = ParticleManager:CreateParticle("particles/rebuild/spell/windrun/unlock2/effect.vpcf", PATTACH_CUSTOMORIGIN, caster)
            local dir = CalculateDirection(target_pos, caster_loc)
            ParticleManager:SetParticleControl(pfx_min, 0,caster_loc)
            -- ParticleManager:SetParticleControl(pfx_min, 1, Vector(caster_loc.x-dir.x*200, caster_loc.y-dir.y*200, caster_loc.z + 128))
            ParticleManager:SetParticleControlForward(pfx_min, 3, dir)  --方向
            -- ParticleManager:ReleaseParticleIndex(pfx_min)
            local uint_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, 600, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
            local damage = caster:GetAgility()*10
            local damageTable = {
                attacker = caster,
                -- victim = target,
                damage = damage,
                damage_type =DAMAGE_TYPE_PHYSICAL,
                ability = ability
            }
            for _, target in pairs( uint_enemies) do

                damageTable.victim = target
                ApplyDamage(damageTable) 


     
            end	

            return -1000
        end
    end
    -- local caster = self:GetCaster()


end

function modifier_Advanced_Windrun_walk_unlock2:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end



if modifier_Advanced_Windrun_walk_unlock2_thinker == nil then
    modifier_Advanced_Windrun_walk_unlock2_thinker = class({})
end
function modifier_Advanced_Windrun_walk_unlock2_thinker:IsHidden()return false end
function modifier_Advanced_Windrun_walk_unlock2_thinker:IsDebuff()return false end
function modifier_Advanced_Windrun_walk_unlock2_thinker:IsPurgable()return false end
function modifier_Advanced_Windrun_walk_unlock2_thinker:IsPurgeException()return false end
function modifier_Advanced_Windrun_walk_unlock2_thinker:IsStunDebuff()return false end
function modifier_Advanced_Windrun_walk_unlock2_thinker:AllowIllusionDuplicate()return false end
function modifier_Advanced_Windrun_walk_unlock2_thinker:OnCreated(params)

    if IsServer() then
      
        local hCaster = self:GetCaster()
        local hParent = self:GetParent()

        -- hParent:SetOriginalModel(hCaster:GetModelName())
        -- hParent:SetModelScale(2)
        -- hParent:SetShouldDoFlyHeightVisual(false)

        -- local vRBG = Vector(128, 128, 204)
        -- hParent:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)

        -- local hModel = hCaster:FirstMoveChild()
        -- while hModel ~= nil do
        --     if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
        --         local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = hParent:GetAbsOrigin() })
        --         -- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
        --         hWearable:FollowEntity(hParent, true)
        --     end
        --     hModel = hModel:NextMovePeer()
        -- end

        -- hParent:StartGesture(ACT_DOTA_CAST_ABILITY_1)

        local iParticleID = ParticleManager:CreateParticle("particles/rebuild/spell/winrun/unlock2/effect_spirit_static_remnant.vpcf", PATTACH_ABSORIGIN, hCaster)
        ParticleManager:SetParticleControl( iParticleID,0, hCaster:GetAbsOrigin() )
        ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hCaster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl( iParticleID, 2, Vector(RandomInt(1, 10),0,0) )



        self:AddParticle(iParticleID, false, false, -1, false, false)
        local ability = self:GetAbility()
        ability:Addstack(self)



        
        -- local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", PATTACH_ABSORIGIN, hParent)
        -- ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
        -- self:AddParticle(iParticleID, false, false, -1, false, false)

        
    end
end
function modifier_Advanced_Windrun_walk_unlock2_thinker:OnDestroy()
    if IsServer() then
        local hParent = self:GetParent()
        -- local hCaster = self:GetCaster()
        local hAbility = self:GetAbility()
        hAbility:RemoveStack(self)

        -- local vPosition = hParent:GetAbsOrigin()
        -- EmitSoundOnLocationWithCaster(vPosition, "Hero_StormSpirit.StaticRemnantExplode", hCaster)
        hParent:RemoveSelf()

    end
end
function modifier_Advanced_Windrun_walk_unlock2_thinker:CheckState()
    return {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        -- [MODIFIER_STATE_FROZEN] = true
    }
end














modifier_Advanced_Windrun_walk_unlock3 = class({})

function modifier_Advanced_Windrun_walk_unlock3:IsDebuff()			return false end
function modifier_Advanced_Windrun_walk_unlock3:IsHidden() 			return false end
function modifier_Advanced_Windrun_walk_unlock3:IsPurgable() 		    return true end
function modifier_Advanced_Windrun_walk_unlock3:IsPurgeException() return true end
function modifier_Advanced_Windrun_walk_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Windrun_walk_unlock3:OnCreated(keys)
    if IsServer() then
        if not self:GetParent():IsRealHero() then
            return false
        end
        self.parent = self:GetParent()
        self.dis = 0
        self.currentPos = self.parent:GetAbsOrigin()
        self:StartIntervalThink(0.03)     

    end
end

function modifier_Advanced_Windrun_walk_unlock3:OnRefresh()
    if IsServer() then
        -- self:GetAbility():RemoveAll()
        self:SetStackCount(0)
    end
end
function modifier_Advanced_Windrun_walk_unlock3:OnIntervalThink()
  
    local move_dis =  CalculateDistance(self.parent:GetAbsOrigin(),self.currentPos)
    self.dis =self.dis+ move_dis
    self.currentPos = self.parent:GetAbsOrigin()
    if self.dis>=100 then
        self.dis = 0
        self:SetStackCount(math.min(self:GetStackCount()+1,300))
    end
end

function modifier_Advanced_Windrun_walk_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   	
	}
	return funcs
end
function modifier_Advanced_Windrun_walk_unlock3:GetModifierPreAttack_BonusDamage( keys )
	return self:GetStackCount()*30


end

