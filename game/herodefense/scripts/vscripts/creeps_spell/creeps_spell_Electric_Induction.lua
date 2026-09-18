--感电  BOSS精英技能
LinkLuaModifier("modifier_creeps_spell_Electric_Induction_triger", "creeps_spell/creeps_spell_Electric_Induction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electric_Induction_motion", "creeps_spell/creeps_spell_Electric_Induction", LUA_MODIFIER_MOTION_NONE)
creeps_spell_Electric_Induction = class({})
function creeps_spell_Electric_Induction:IsHiddenWhenStolen() 		return false end
function creeps_spell_Electric_Induction:IsRefreshable() 			return true end
function creeps_spell_Electric_Induction:IsStealable() 				return true end
function creeps_spell_Electric_Induction:IsNetherWardStealable()		return true end
function creeps_spell_Electric_Induction:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function creeps_spell_Electric_Induction:OnSpellStart()
	local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_creeps_spell_Electric_Induction_triger", {duration= self:GetSpecialValueFor("duration")})
end


modifier_creeps_spell_Electric_Induction_triger = class({})
function modifier_creeps_spell_Electric_Induction_triger:IsHidden() return false end
function modifier_creeps_spell_Electric_Induction_triger:IsDebuff() return false end
function modifier_creeps_spell_Electric_Induction_triger:IsPurgable() return false end
function modifier_creeps_spell_Electric_Induction_triger:IsPurgeException() return false end
function modifier_creeps_spell_Electric_Induction_triger:IsStunDebuff() return false end
function modifier_creeps_spell_Electric_Induction_triger:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Electric_Induction_triger:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_SILENCED]   = true,
    }
    return state
end

function modifier_creeps_spell_Electric_Induction_triger:OnCreated()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local pos = caster:GetOrigin()
    self.damage = ability:GetSpecialValueFor("damage")*caster:GetBaseDamageMax()
    self.pull_radius = ability:GetSpecialValueFor("radius")
    self.damage_radius = ability:GetSpecialValueFor("radius_damage")
    self.end_health = caster:GetMaxHealth()*ability:GetSpecialValueFor("end_health")
    self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(self.nFXIndex, 0,  Vector(pos.x,pos.y,pos.z+300))
    ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(2000,2000,2000))
	
    self.damage_count = 0
    self:StartIntervalThink(0.5)
end

function modifier_creeps_spell_Electric_Induction_triger:OnIntervalThink()
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),
    nil, self.pull_radius,
     DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,
       FIND_ANY_ORDER, false)
       local damageTable = {
        attacker = caster,
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        ability = self, --Optional.
        }
   for _, enemy in pairs(enemies) do
       local dis= GetDistanceBetweenTwoUnit(caster,enemy)
       if dis>=200 then
            enemy:AddNewModifier(caster, ability, "modifier_creeps_spell_Electric_Induction_motion", {duration = 0.7})
       end
       if dis<=600 and self.damage_count%2== 0 then
            damageTable.victim = enemy
            ApplyDamage(damageTable)
       end
   end
   self.damage_count = self.damage_count + 1
   


end



function modifier_creeps_spell_Electric_Induction_triger:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_creeps_spell_Electric_Induction_triger:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
    end
    self:SetStackCount(self:GetStackCount()+keys.damage)
    if self:GetStackCount()>=self.end_health then
        self:SafeDestroy()
    end
end

function modifier_creeps_spell_Electric_Induction_triger:OnDestroy()
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    ParticleManager:DestroyParticle(self.nFXIndex, false)
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(nFXIndex, 0, caster:GetOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 1, Vector(1000,1000,1000))
    ParticleManager:ReleaseParticleIndex( nFXIndex )
end




modifier_creeps_spell_Electric_Induction_motion = class({})

function modifier_creeps_spell_Electric_Induction_motion:IsDebuff()			return false end
function modifier_creeps_spell_Electric_Induction_motion:IsHidden() 			return true end
function modifier_creeps_spell_Electric_Induction_motion:IsPurgable() 		return false end
function modifier_creeps_spell_Electric_Induction_motion:IsPurgeException() 	return false end
function modifier_creeps_spell_Electric_Induction_motion:IsMotionController() return true end
function modifier_creeps_spell_Electric_Induction_motion:OnCreated(keys)
    if IsServer() then
        self:GetParent():EmitSound("Ability.static.loop")
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = self:GetParent():GetIdealSpeed()*1.1
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_creeps_spell_Electric_Induction_motion:OnRefresh(keys)
    if IsServer() then
        local pos_caster = self:GetCaster():GetAbsOrigin()  --获取自己
        local pos_target = self:GetParent():GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = self:GetParent():GetIdealSpeed()*1.1
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_creeps_spell_Electric_Induction_motion:OnIntervalThink(keys)   
    if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + (-self.direction) * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    end
end



function modifier_creeps_spell_Electric_Induction_motion:OnDestroy(keys) 
    if  IsServer() then
        self:GetParent():StopSound("Ability.static.loop")
	    self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
    end
end
