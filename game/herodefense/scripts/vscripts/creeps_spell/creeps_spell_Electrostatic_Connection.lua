creeps_spell_Electrostatic_Connection = class({})



LinkLuaModifier("modifier_creeps_spell_Electrostatic_Connection_effect", "creeps_spell/creeps_spell_Electrostatic_Connection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Connection_motion", "creeps_spell/creeps_spell_Electrostatic_Connection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Connection_slow", "creeps_spell/creeps_spell_Electrostatic_Connection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_stun", "creeps_spell/creeps_spell_Electrostatic_Connection", LUA_MODIFIER_MOTION_NONE)
function creeps_spell_Electrostatic_Connection:IsHiddenWhenStolen() 		return false end
function creeps_spell_Electrostatic_Connection:IsRefreshable() 			return true end
function creeps_spell_Electrostatic_Connection:IsStealable() 				return true end
function creeps_spell_Electrostatic_Connection:IsNetherWardStealable()		return true end



function creeps_spell_Electrostatic_Connection:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if target:TriggerSpellAbsorb(self) then return end
    target:AddNewModifier(caster, self, "modifier_creeps_spell_Electrostatic_Connection_effect", {duration = self:GetSpecialValueFor("duration")})
end


modifier_creeps_spell_Electrostatic_Connection_effect = class({})

function modifier_creeps_spell_Electrostatic_Connection_effect:IsDebuff()			 return true end
function modifier_creeps_spell_Electrostatic_Connection_effect:IsHidden() 			 return false end
function modifier_creeps_spell_Electrostatic_Connection_effect:IsPurgable() 		 return false end
function modifier_creeps_spell_Electrostatic_Connection_effect:IsPurgeException() 	 return false end



function modifier_creeps_spell_Electrostatic_Connection_effect:OnCreated(table)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.03)
end


function modifier_creeps_spell_Electrostatic_Connection_effect:OnIntervalThink(table)
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		self:SafeDestroy()
		return
	end

    if  self.selectDone == nil then
        
        local caster = ability:GetCaster()
        local parent = self:GetParent()
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil,
         ability:GetSpecialValueFor("radius_select"), DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
           DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
           if #enemies > 1  then
            local parent_pos = parent:GetAbsOrigin()
            local enemies_pos = enemies[2]:GetAbsOrigin()
        
            parent:EmitSound("Hero_Razor.SeveringCrest.Loop")
            enemies[2]:EmitSound("Hero_Razor.SeveringCrest.Loop")
            self.pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/gs_fall20_immortal_soulbind_blue.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControlEnt(self.pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(parent_pos.x,parent_pos.y,parent_pos.z+100), true)
            ParticleManager:SetParticleControlEnt(self.pfx, 1, enemies[2], PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(enemies_pos.x,enemies_pos.y,enemies_pos.z+100), true)

            self.selectUnit = enemies[2]
            self.selectParent = parent
            self.distance = ability:GetSpecialValueFor("radius")
            self.TriggerDistance = ability:GetSpecialValueFor("radius_damage")
            self.selectDone = 1
            self.caster = caster
            self.ability = ability
            self.damage = ability:GetSpecialValueFor("damage") * caster:GetBaseDamageMax()
           end
    else
        --成功连接了，减缓移速且判断距离
        self.selectUnit:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Connection_slow", {duration =0.5,})  
        self.selectParent:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Connection_slow", {duration =0.5,})  
        local distance = ( self.selectParent:GetOrigin() - self.selectUnit:GetOrigin() ):Length2D()
        --如果距离大于拉扯距离
        if not self.selectUnit:IsAlive() then
            self:SetDuration(0,true)
        end
        if distance> self.distance then
            self.selectUnit:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Connection_motion", {target=self.selectParent:entindex(),duration =0.03,})  --添加冲刺修饰器 传入时间与一个点
        end
        --如果距离大于拉扯距离
        --造成伤害并眩晕，断开连接
        if distance> self.TriggerDistance then
            --主目标
            local damageTable = {
                victim = self.selectParent,
                attacker = self.caster,
                damage = self.damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                ability = self.ability, --Optional.
                }
            ApplyDamage(damageTable)
            --次目标
            local damageTable = {
                victim = self.selectUnit,
                attacker = self.caster,
                damage = self.damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                ability = self.ability, --Optional.
                }
            ApplyDamage(damageTable)
            local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
            local StatusResistance = self.selectUnit:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
            self.selectUnit:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_stun", {duration =3*StatusResistance,}) 
            StatusResistance = self.selectParent:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain 
            self.selectParent:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_stun", {duration =3*StatusResistance,})  

            self:SetDuration(0,true)
        end

    end

end

function modifier_creeps_spell_Electrostatic_Connection_effect:OnDestroy()
    if not IsServer() then
        return
    end
    if self.selectParent~=nil then
        self.selectParent:StopSound("Hero_Razor.SeveringCrest.Loop")
        self.selectUnit:StopSound("Hero_Razor.SeveringCrest.Loop")
        self.selectUnit:EmitSound("Ability.static.end")
        ParticleManager:DestroyParticle(self.pfx,false)
    end
     
    
end


--------------
modifier_creeps_spell_Electrostatic_Connection_motion = class({})

function modifier_creeps_spell_Electrostatic_Connection_motion:IsDebuff()			return false end
function modifier_creeps_spell_Electrostatic_Connection_motion:IsHidden() 			return true end
function modifier_creeps_spell_Electrostatic_Connection_motion:IsPurgable() 		return false end
function modifier_creeps_spell_Electrostatic_Connection_motion:IsPurgeException() 	return false end
function modifier_creeps_spell_Electrostatic_Connection_motion:IsMotionController() return true end
function modifier_creeps_spell_Electrostatic_Connection_motion:OnCreated(keys)
    if IsServer() then

        self.target			= EntIndexToHScript(keys.target)
        local pos_caster = self:GetParent():GetAbsOrigin()  --获取自己
        local pos_target = self.target:GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = self:GetParent():GetIdealSpeed()
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_creeps_spell_Electrostatic_Connection_motion:OnRefresh(keys)
    if IsServer() then
        self.target			= EntIndexToHScript(keys.target)
        local pos_caster = self:GetParent():GetAbsOrigin()  --获取自己
        local pos_target = self.target:GetAbsOrigin()  --获取敌人
        self.direction = (pos_target - pos_caster):Normalized()
        self.direction.z = 0  --初始化Z值
		--self.direction = StringToVector(keys.key_drection)
		self.speed = self:GetParent():GetIdealSpeed()
		self:StartIntervalThink(0)   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_creeps_spell_Electrostatic_Connection_motion:OnIntervalThink(keys)   
    if  IsServer() then
	local me = self:GetParent()
    local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
	new_pos = GetGroundPosition(new_pos, nil)   
    me:SetOrigin(new_pos)  
    ResolveNPCPositions(new_pos, 70)
    end
end


modifier_creeps_spell_Electrostatic_Connection_slow = class({})

function modifier_creeps_spell_Electrostatic_Connection_slow:IsDebuff()			    return false end
function modifier_creeps_spell_Electrostatic_Connection_slow:IsHidden() 			return true end
function modifier_creeps_spell_Electrostatic_Connection_slow:IsPurgable() 		    return false end
function modifier_creeps_spell_Electrostatic_Connection_slow:IsPurgeException() 	return false end

function modifier_creeps_spell_Electrostatic_Connection_slow:DeclareFunctions()   return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_creeps_spell_Electrostatic_Connection_slow:GetModifierMoveSpeedBonus_Percentage() 
        return -50
end





modifier_creeps_spell_Electrostatic_stun = class({})

function modifier_creeps_spell_Electrostatic_stun:IsDebuff()			return true end
function modifier_creeps_spell_Electrostatic_stun:IsHidden() 			return false end
function modifier_creeps_spell_Electrostatic_stun:IsPurgable() 		return true end
function modifier_creeps_spell_Electrostatic_stun:IsPurgeException() 	return true end
function modifier_creeps_spell_Electrostatic_stun:IsStunDebuff() return true end
function modifier_creeps_spell_Electrostatic_stun:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_creeps_spell_Electrostatic_stun:GetStatusEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_creeps_spell_Electrostatic_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_creeps_spell_Electrostatic_stun:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_creeps_spell_Electrostatic_stun:GetOverrideAnimation( params ) return ACT_DOTA_DISABLED end

function modifier_creeps_spell_Electrostatic_stun:OnCreated()
	if IsServer() then
		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
	end
end

function modifier_creeps_spell_Electrostatic_stun:OnRefresh(table)
	if IsServer() then
		local StatusResistance = 1 - self:GetParent():GetStatusResistance()
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
	end
end