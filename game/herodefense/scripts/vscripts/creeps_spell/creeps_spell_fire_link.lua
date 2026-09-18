creeps_spell_fire_link = class({})

LinkLuaModifier("modifier_creeps_spell_fire_link", "creeps_spell/creeps_spell_fire_link", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_fire_link_check", "creeps_spell/creeps_spell_fire_link", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_fire_link_fly", "creeps_spell/creeps_spell_fire_link", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_health_bar", "modifier/modifier_health_bar", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_fire_link:IsHiddenWhenStolen() 		return false end
function creeps_spell_fire_link:IsRefreshable() 			return true end
function creeps_spell_fire_link:IsStealable() 				return true end
function creeps_spell_fire_link:IsNetherWardStealable()		return true end
function creeps_spell_fire_link:GetIntrinsicModifierName() return "modifier_creeps_spell_fire_link" end

require('internal/timers')

modifier_creeps_spell_fire_link = class({})

function modifier_creeps_spell_fire_link:IsDebuff()			 return false end
function modifier_creeps_spell_fire_link:IsHidden() 		     return true end
function modifier_creeps_spell_fire_link:IsPurgable() 		 return false end
function modifier_creeps_spell_fire_link:IsPurgeException() 	 return false end
function modifier_creeps_spell_fire_link:RemoveOnDeath()       return false end
function modifier_creeps_spell_fire_link:SetLink(target) 
    if IsServer() then
        self:GetParent().fire_link_unit = target

    end
end
function modifier_creeps_spell_fire_link:OnCreated(table)    
    if not IsServer() then
        return
    end  
    local caster = self:GetParent()
    local ability = self:GetAbility()
    local modifier = self
    Timers:CreateTimer(0.1, function()
        local pos = caster:GetAbsOrigin()
        local unit = CreateUnitByName("npc_hd_lina", pos, true, caster, caster, caster:GetTeamNumber()) 
        unit:AddNewModifier(unit, nil, "modifier_creeps_gain_base_player_number", {duration = -1}):SetStackCount(GetPlayerCount()) --提供增益

        unit:AddNewModifier(unit, nil, "modifier_health_bar", {health_bar_type=1})
        unit:AddNewModifier(caster, ability, "modifier_creeps_spell_fire_link_check", {})
        local ability = unit:AddAbility("creeps_spell_Gain_Base_Difficulty")
        unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
        modifier:SetLink(unit)
        ability:SetLevel(_G.GAME_DIFFICULTY)
        if GetChallengeDifficulty()~=0 then
            local ability = unit:AddAbility("creeps_spell_Gain_Base_CHANLLENGE_DIFFICULTY")
            ability:SetLevel(GetChallengeDifficulty())
        end
        _G.GAME_MONSTER_TABLE[(#_G.GAME_MONSTER_TABLE )+ 1]= unit
        _G.GAME_MONSTER_TABLE_number = _G.GAME_MONSTER_TABLE_number + 1
        if GetChallengeDifficulty()>=1 then
            CreateSpecialGainForUnit(unit,1000,1000,1)  --为产生的单位添加词条
        end
        -- unit:FollowEntity(caster, false)
        -- local attachment = caster:ScriptLookupAttachment( "attach_hitloc" )
        -- local pos = caster:GetAttachmentOrigin(attachment)
      
        -- local vForward =caster:GetForwardVector()
        -- unit:SetForwardVector(Vector(0,0,0))
        -- pos.z = pos.z+64
        -- unit:SetAbsOrigin(pos)
     
        -- unit:SetParent(caster, "attach_hitloc")


    end)

    
end



modifier_creeps_spell_fire_link_check = class({})

function modifier_creeps_spell_fire_link_check:IsDebuff()			 return false end
function modifier_creeps_spell_fire_link_check:IsHidden() 		     return true end
function modifier_creeps_spell_fire_link_check:IsPurgable() 		 return false end
function modifier_creeps_spell_fire_link_check:IsPurgeException() 	 return false end
function modifier_creeps_spell_fire_link_check:RemoveOnDeath()       return false end
function modifier_creeps_spell_fire_link_check:OnCreated(keys)
    if IsServer() then
        
        self.parent = self:GetParent()
        self.caster = self:GetCaster()
        self.offset = 0
        self:GetParent().fire_link_unit = self:GetCaster()
        self:StartIntervalThink(FrameTime())    
    end
end

function modifier_creeps_spell_fire_link_check:OnIntervalThink()
    if not IsValid(self.caster) then
        self:Destroy()
        return
    end
	local attachment = self.caster:ScriptLookupAttachment( "attach_hitloc" )
    local pos = self.caster:GetAttachmentOrigin(attachment)
    if self.parent:HasModifier("modifier_fire_link_partten_2") then
        FindClearSpaceForUnit( self.parent, self.parent:GetAbsOrigin()+Vector(RandomInt(-400, 400),RandomInt(-400, 400),0), false )
        self.parent:AddNewModifier(self.parent, nil, "modifier_creeps_spell_fire_link_fly", {duration = 0.1})
        self:SafeDestroy()
        
        return
    end
  
    local vForward = self.caster:GetForwardVector()
    if self.caster:HasModifier("modifier_creeps_spell_dracarys") then
        self.offset = 550
    end
    if self.offset>=0 then
        self.offset = self.offset -1
    end
    self.parent:SetForwardVector(vForward)
    -- pos.z = pos.z+64
    self.parent:SetAbsOrigin(pos+Vector(0,0,self.offset))



 
end


function modifier_creeps_spell_fire_link_check:CheckState() return {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    -- [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
} end


function modifier_creeps_spell_fire_link_check:DeclareFunctions() return 
	{
	 MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	 MODIFIER_PROPERTY_DISABLE_TURNING
    } 
end

function modifier_creeps_spell_fire_link_check:GetModifierDisableTurning() 
    return 1
end
function modifier_creeps_spell_fire_link_check:GetModifierIgnoreCastAngle()
    return 1
end












modifier_creeps_spell_fire_link_fly = advanced_modifier({})

function modifier_creeps_spell_fire_link_fly:IsHidden()	return true end
function modifier_creeps_spell_fire_link_fly:IsPurgable()	return false end
function modifier_creeps_spell_fire_link_fly:GetVisualZDelta( params )
	return 600
end
function modifier_creeps_spell_fire_link_fly:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
	return funcs
end


function modifier_creeps_spell_fire_link_fly:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying,

    }
end

function modifier_creeps_spell_fire_link_fly:Advanced_GetModifier_Flying()	
	return 1
end
