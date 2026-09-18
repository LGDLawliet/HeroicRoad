creeps_spell_Electrostatic_Armor = class({})
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_damage_count", "creeps_spell/creeps_spell_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_triger", "creeps_spell/creeps_spell_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_spell", "creeps_spell/creeps_spell_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_shield", "creeps_spell/creeps_spell_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)

--Abilities
function creeps_spell_Electrostatic_Armor:IsHiddenWhenStolen() 		return false end
function creeps_spell_Electrostatic_Armor:IsRefreshable() 			return true end
function creeps_spell_Electrostatic_Armor:IsStealable() 				return true end
function creeps_spell_Electrostatic_Armor:IsNetherWardStealable()		return true end
function creeps_spell_Electrostatic_Armor:GetIntrinsicModifierName() return "modifier_creeps_spell_Electrostatic_Armor_damage_count" end
function creeps_spell_Electrostatic_Armor:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


modifier_creeps_spell_Electrostatic_Armor_damage_count = class({})
function modifier_creeps_spell_Electrostatic_Armor_damage_count:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_damage_count:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_damage_count:IsPurgable() 		return false end
function modifier_creeps_spell_Electrostatic_Armor_damage_count:IsPurgeException() 	return false end
function modifier_creeps_spell_Electrostatic_Armor_damage_count:RemoveOnDeath()  return false end
function modifier_creeps_spell_Electrostatic_Armor_damage_count:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_damage_count:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Electrostatic_Armor_damage_count:DeclareFunctions() return
    {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_creeps_spell_Electrostatic_Armor_damage_count:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("bonus_magic_resistance") end


function modifier_creeps_spell_Electrostatic_Armor_damage_count:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
    --判定是否进入了第二状态，如果进入了则以下效果均取消，不再触发电场
    if self:GetParent().pattern_2 then
        return
    end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
    local ability = self:GetAbility()
    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
    --判断累计伤害是否达到触发线
    if self:GetStackCount() > caster:GetMaxHealth()*ability:GetSpecialValueFor("health")*0.01 then
        caster:AddNewModifier(caster, ability, "modifier_creeps_spell_Electrostatic_Armor_triger", {duration= ability:GetSpecialValueFor("delay")})
        self:SetStackCount(0)
    end
end

modifier_creeps_spell_Electrostatic_Armor_triger = class({})
function modifier_creeps_spell_Electrostatic_Armor_triger:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_triger:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_triger:IsPurgable() return false end
function modifier_creeps_spell_Electrostatic_Armor_triger:IsPurgeException() return false end
function modifier_creeps_spell_Electrostatic_Armor_triger:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_triger:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_Electrostatic_Armor_triger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
--无法移动，无法攻击，沉默
function modifier_creeps_spell_Electrostatic_Armor_triger:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_SILENCED]   = true,
    }
    return state
end



function modifier_creeps_spell_Electrostatic_Armor_triger:OnCreated(table)
    if IsServer() then
        local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_rebuild.vpcf"
        local caster = self:GetCaster()
        local radius = self:GetAbility():GetSpecialValueFor("radius")+100
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
        ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            3,
            caster,
            PATTACH_ABSORIGIN_FOLLOW,
            "attach_hitloc",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        ParticleManager:SetParticleControlForward( effect_cast, 3, caster:GetForwardVector() )
        self.effect_cast = effect_cast
    end
end


function modifier_creeps_spell_Electrostatic_Armor_triger:OnDestroy()
    if not IsServer() then
        return
    end
    ParticleManager:DestroyParticle( self.effect_cast, false )
    ParticleManager:ReleaseParticleIndex( self.effect_cast )
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_spell", {})
end

function modifier_creeps_spell_Electrostatic_Armor_triger:OnRefresh(table)
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_spell", {})
end



modifier_creeps_spell_Electrostatic_Armor_spell = class({})
function modifier_creeps_spell_Electrostatic_Armor_spell:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_spell:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_spell:IsPurgable() return false end
function modifier_creeps_spell_Electrostatic_Armor_spell:IsPurgeException() return false end
function modifier_creeps_spell_Electrostatic_Armor_spell:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_spell:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Electrostatic_Armor_spell:OnCreated(params)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetCaster()
    local ability = self:GetAbility()

	self.iRadius = ability:GetSpecialValueFor("radius")+100
	self.iSpeed = ability:GetSpecialValueFor("speed")
    self.iDamage = ability:GetSpecialValueFor("damage") * ability:GetCaster():GetBaseDamageMax()
    self.Shield = ability:GetSpecialValueFor("Shield") * ability:GetCaster():GetBaseDamageMax()

	--imba
	self.tEnemies = {}
	self.iDur = 1   --控制移动方向
	self.fCurDis = 0
	self.iEffectWidth = 100
	if IsServer() then
		self.hCaster:EmitSound("Ability.PlasmaField")
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self.hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, self.hCaster:GetAbsOrigin(), true)
		self:StartIntervalThink(FrameTime())
	end
end
--可以多重
function modifier_creeps_spell_Electrostatic_Armor_spell:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_Electrostatic_Armor_spell:OnIntervalThink()
	if IsServer() then
        if self.hCaster:IsAlive() then
            --先将搜寻到的敌人插入表中
            local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil,
             self.fCurDis+self.iEffectWidth,
              DOTA_UNIT_TARGET_TEAM_ENEMY,
               DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for _, enemy in pairs(enemies) do
                --如果是正向
				if self.iDur == 1 then
					if not IsInTable(enemy,self.tEnemies) and CalculateDistance(enemy,self.hCaster)>=(self.fCurDis-self.iEffectWidth) then
						enemy.IsFlag = false
						table.insert(self.tEnemies, enemy)
                    end
                --否则为反向
                else
                    --判断当前特效的距离，如果小于敌人与施法者的距离
					if self.fCurDis  <= CalculateDistance(enemy,self.hCaster) then
						if not IsInTable(enemy,self.tEnemies)then
							enemy.IsFlag = false
							table.insert(self.tEnemies, enemy)
						end
					end
				end
            end
            --敌人入表结束
            if self.tEnemies then
                --取出单位造成伤害，并将已伤害标记为true
				for _, enemy in pairs(self.tEnemies) do
					if not enemy.IsFlag then

						local iDamage = self.iDamage
	
						local tDamage = {
							ability = self:GetAbility(),
							attacker = self.hCaster,
							victim = enemy,
							damage = iDamage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
						}
						ApplyDamage(tDamage)
						enemy.IsFlag = true
					end
				end
            end
            
            --伤害结束，移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.iSpeed,self.fCurDis+self.iEffectWidth, 1))
            --如果到达最大距离则反向移动
            if self.fCurDis == self.iRadius then
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_shield",
                 {duration=self:GetAbility():GetSpecialValueFor("duration"),index=#self.tEnemies *self.Shield})
				self.iDur = -1
                self.iSpeed=-self.iSpeed
                --清空表
                self.tEnemies={}
                --再搜寻一次
				local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil, self.fCurDis+self.iEffectWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _,enemy in pairs(enemies) do
					if not IsInTable(enemy,self.tEnemies) and ((enemy:GetAbsOrigin()-self.hCaster:GetAbsOrigin()):Length2D())>self.fCurDis+self.iEffectWidth then
						enemy.IsFlag = false
						table.insert(self.tEnemies, enemy)
					end
				end
            end
            --结束反向操作
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)

            if self.fCurDis<=0 then
                local ModifierStatusGain = self:GetParent():GetModifierDurationGainIndex(1)
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_shield", 
                {duration=self:GetAbility():GetSpecialValueFor("duration")*ModifierStatusGain,index=#self.tEnemies *self.Shield})
				self:SafeDestroy()
			end
		end
	end
end


function modifier_creeps_spell_Electrostatic_Armor_spell:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end

modifier_creeps_spell_Electrostatic_Armor_shield = advanced_modifier({})
function modifier_creeps_spell_Electrostatic_Armor_shield:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_shield:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_shield:IsPurgable() return false end
function modifier_creeps_spell_Electrostatic_Armor_shield:IsPurgeException() return false end
function modifier_creeps_spell_Electrostatic_Armor_shield:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_shield:AllowIllusionDuplicate() return false end

-- function modifier_creeps_spell_Electrostatic_Armor_shield:DeclareFunctions() return {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK} end
function modifier_creeps_spell_Electrostatic_Armor_shield:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end


BALNOCK_SHIELD_SOUND = {
    "abaddon_abad_aphoticshield_01",
    "abaddon_abad_aphoticshield_02",
    "abaddon_abad_aphoticshield_03",
    "abaddon_abad_aphoticshield_06",
    "abaddon_abad_aphoticshield_07",
}
require("internal/timers")
function modifier_creeps_spell_Electrostatic_Armor_shield:OnCreated(keys)
    if not IsServer() then
        return
    end
    self.pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/electrostatic_armor_shield_edge.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    local ex = self:GetParent():GetModelScale() * 100
    ParticleManager:SetParticleControl(self.pfx, 1, Vector(ex,ex,ex))
    self:AddParticle(self.pfx, false, false, 15, false, false)
    self:SetStackCount(keys.index)
    print(self:GetParent().balnock_shield_sound_intervel)
    -- print(keys.index)
    if keys.index>300 and not self:GetParent().balnock_shield_sound_intervel then
        self:GetParent().balnock_shield_sound_intervel = true
        -- print("emit sound")
        EmitGlobalSound(BALNOCK_SHIELD_SOUND[RandomInt(1, 5)])
        local parent = self:GetParent()
        Timers:CreateTimer(5, function()
            if parent and not parent:IsNull() and parent:IsAlive() then
                parent.balnock_shield_sound_intervel = false
            end
            
        end)
    end
    self:StartIntervalThink(0.2)
end

function modifier_creeps_spell_Electrostatic_Armor_shield:OnRefresh(keys)
    if not IsServer() then
        return
    end
    self:SetStackCount(self:GetStackCount()+keys.index)
    if keys.index>300 and not self:GetParent().balnock_shield_sound_intervel then
        self:GetParent().balnock_shield_sound_intervel = true
        -- print("emit sound")
        EmitGlobalSound(BALNOCK_SHIELD_SOUND[RandomInt(1, 5)])
        local parent = self:GetParent()
        Timers:CreateTimer(5, function()
            if not parent or parent:IsNull() or not parent:IsAlive() then
                return
            end
            parent.balnock_shield_sound_intervel = false
        end)
    end
end
-- function modifier_creeps_spell_Electrostatic_Armor_shield:GetModifierTotal_ConstantBlock(keys)
-- 	if not IsServer() then
-- 		return
-- 	end
--     if self:GetParent():IsBlockDisabled() then
--         return
--     end
-- 	local stack = self:GetStackCount()
--     --计算护盾值
-- 	if keys.damage >  self:GetStackCount()then
-- 		self:SetStackCount(0)
-- 	else
--         self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
--         stack=keys.damage+1
-- 	end
-- 	return stack
-- end




function modifier_creeps_spell_Electrostatic_Armor_shield:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_creeps_spell_Electrostatic_Armor_shield:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return self:GetStackCount()
		-- return 0 
	end
    if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage+1
	end
	return stack

end


function modifier_creeps_spell_Electrostatic_Armor_shield:OnIntervalThink()
    if not IsServer() then
        return
    end
    if self:GetStackCount()<=0 then
        self:SafeDestroy()
        ParticleManager:DestroyParticle(self.pfx, true)
    end
end