creeps_spell_Activate_Fire_Remnant=class({})

LinkLuaModifier("modifier_creeps_spell_Activate_Fire_Remnant", "creeps_spell/creeps_spell_Activate_Fire_Remnant", LUA_MODIFIER_MOTION_HORIZONTAL)

function creeps_spell_Activate_Fire_Remnant:IsHiddenWhenStolen() 	return false end
function creeps_spell_Activate_Fire_Remnant:IsRefreshable() 		return true end
function creeps_spell_Activate_Fire_Remnant:IsStealable() 			return true end
function creeps_spell_Activate_Fire_Remnant:GetAssociatedPrimaryAbilities() return "creeps_spell_Fire_Remnant" end

function creeps_spell_Activate_Fire_Remnant:CastFilterResultLocation(tg) 
    if IsServer() then	
        local mod = self:GetCaster():FindModifierByName("modifier_creeps_spell_Fire_Remnant_num")		
        if  mod==nil or mod:GetStackCount()<1 then 
            return UF_FAIL_CUSTOM
        end 
    end
end

function creeps_spell_Activate_Fire_Remnant:GetCustomCastErrorLocation(tg) 			
    return "场上没魂"
end


function creeps_spell_Activate_Fire_Remnant:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
	local cur_pos = self:GetCursorPosition()
	local dis = TG_Distance(pos,cur_pos) 
    local dir = TG_Direction(cur_pos,pos)
    if caster:HasModifier("modifier_sleight_of_fist_buff") then 
        caster:RemoveModifierByName("modifier_sleight_of_fist_buff")
    end 

    -- print("on start 23")
    if caster.creeps_spell_Fire_RemnantTB and #caster.creeps_spell_Fire_RemnantTB>0 then
        for a=#caster.creeps_spell_Fire_RemnantTB,1,-1 do  
            local target =    caster.creeps_spell_Fire_RemnantTB[a]
            if target and not target:IsNull() and target:IsAlive() then
                caster:Purge(false, true, false, true, true)
                EmitSoundOn("Hero_EmberSpirit.FireRemnant.Activate", caster) 
                -- print("go")
                caster:AddNewModifier(caster, self, "modifier_creeps_spell_Activate_Fire_Remnant", {duration = 5,dir=dir,target=target:entindex()})
                return
            end 
        end
    end 
end


modifier_creeps_spell_Activate_Fire_Remnant=class({})

function modifier_creeps_spell_Activate_Fire_Remnant:IsHidden() 			return true end
function modifier_creeps_spell_Activate_Fire_Remnant:IsPurgable() 			return false end
function modifier_creeps_spell_Activate_Fire_Remnant:IsPurgeException() 	return false end
function modifier_creeps_spell_Activate_Fire_Remnant:RemoveOnDeath() 	return false end

function modifier_creeps_spell_Activate_Fire_Remnant:OnCreated(tg)
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
    -- self.caster=self:GetCaster()
    self.pos=self.parent:GetAbsOrigin()
    if not IsServer() then
        return
    end
    self.pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", PATTACH_CUSTOMORIGIN,self.parent)
    ParticleManager:SetParticleControlEnt(self.pf, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.pos, true)
    ParticleManager:SetParticleControlEnt(self.pf, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.pos, true)
    ParticleManager:SetParticleControl(self.pf, 61, Vector(1,0,0))
    self:AddParticle( self.pf, false, false, -1, false, false )    
    self.DIR=StringToVector(tg.dir)
    self.target=EntIndexToHScript(tg.target)
	if not self:ApplyHorizontalMotionController()then 
		self:SafeDestroy()
    end
end



function modifier_creeps_spell_Activate_Fire_Remnant:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end 
    if self.target==nil or not IsValidEntity(self.target) or  not self.target:IsAlive() then  
        self:SafeDestroy()
        return
    end 

    local tpos=self.target:GetAbsOrigin()
    local cpos=self.parent:GetAbsOrigin()
    local dir=TG_Direction2(tpos,cpos)
    local dis=TG_Distance(tpos,cpos)
    if dis<=50 then 
        self.target:Kill(self.ability, self.target)
        self.mod = self.parent:FindModifierByName("modifier_creeps_spell_Fire_Remnant_num")
        if self.mod  then   
            self.mod:DecrementStackCount()
        end 
        if self.pf then
            ParticleManager:SetParticleControl(self.pf, 60, Vector(RandomInt(0, 255),RandomInt(0, 255),RandomInt(0, 255)))
        end
        StopSoundOn("Hero_EmberSpirit.FireRemnant.Activate", self.parent)
        EmitSoundOn("Hero_EmberSpirit.FireRemnant.Stop", self.parent)
        self:SafeDestroy()
    end
    self.parent:SetAbsOrigin(self.parent:GetAbsOrigin()+dir* (3000 / (1.0 / g)))
end

function modifier_creeps_spell_Activate_Fire_Remnant:OnHorizontalMotionInterrupted()
    if  IsServer() then
        self:SafeDestroy()
    end 
end


function modifier_creeps_spell_Activate_Fire_Remnant:OnDestroy()
    if  IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
        local caster = self:GetCaster()
        local mod = caster:FindModifierByName("modifier_creeps_spell_Fire_Remnant_num")		
        if  mod~=nil and mod:GetStackCount()>=1 then 
            caster:SetCursorPosition(caster:GetAbsOrigin())
            self:GetAbility():OnSpellStart() 
        end 
    end 
end

function modifier_creeps_spell_Activate_Fire_Remnant:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        -- MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}
end


function modifier_creeps_spell_Activate_Fire_Remnant:GetModifierTurnRate_Percentage() 	return 100 end
-- function modifier_creeps_spell_Activate_Fire_Remnant:GetModifierModelChange() return "" end
function modifier_creeps_spell_Activate_Fire_Remnant:GetModifierIgnoreCastAngle()return 1 end
function modifier_creeps_spell_Activate_Fire_Remnant:CheckState()
    return
     {
           [MODIFIER_STATE_INVULNERABLE] = true,
           [MODIFIER_STATE_UNSLOWABLE] = true,
           [MODIFIER_STATE_NO_HEALTH_BAR] = true,
           [MODIFIER_STATE_SILENCED] = true,
    } 
end
