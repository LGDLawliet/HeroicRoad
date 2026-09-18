creeps_spell_Electrostatic_Armor_Unstable_chaotic = class({})
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count", "creeps_spell/creeps_spell_Electrostatic_Armor_Unstable_chaotic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger", "creeps_spell/creeps_spell_Electrostatic_Armor_Unstable_chaotic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell", "creeps_spell/creeps_spell_Electrostatic_Armor_Unstable_chaotic", LUA_MODIFIER_MOTION_NONE)

--Abilities
function creeps_spell_Electrostatic_Armor_Unstable_chaotic:IsHiddenWhenStolen() 		return false end
function creeps_spell_Electrostatic_Armor_Unstable_chaotic:IsRefreshable() 			return true end
function creeps_spell_Electrostatic_Armor_Unstable_chaotic:IsStealable() 				return true end
function creeps_spell_Electrostatic_Armor_Unstable_chaotic:IsNetherWardStealable()		return true end
function creeps_spell_Electrostatic_Armor_Unstable_chaotic:GetIntrinsicModifierName() return "modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count" end
function creeps_spell_Electrostatic_Armor_Unstable_chaotic:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count = class({})
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:IsPurgable() 		return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:IsPurgeException() 	return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:RemoveOnDeath()  return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:DeclareFunctions() return
    {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("bonus_magic_resistance") end


function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_damage_count:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
    --self.off 是判定是否进入了第二状态，如果进入了则以下效果均取消，不再触发电场
    if  self.off~=nil then
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
        caster:AddNewModifier(caster, ability, "modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger", {duration= ability:GetSpecialValueFor("delay")})
        self:SetStackCount(0)
    end
end

modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger = advanced_modifier({})
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:IsPurgable() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:IsPurgeException() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
--无法移动，无法攻击，沉默
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_SILENCED]   = true,
    }
    return state
end



function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:OnCreated(table)
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


function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell", {})
    ParticleManager:DestroyParticle( self.effect_cast, false )
    ParticleManager:ReleaseParticleIndex( self.effect_cast )
 
end

function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:OnRefresh(table)
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell", {})
end

function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_triger:Advanced_GetModifierIncomingDamage_Percentage()
    return -self:GetAbility():GetSpecialValueFor("incoming")
end

modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell = class({})
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:IsPurgable() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:IsPurgeException() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:OnCreated(params)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetCaster()
    local ability = self:GetAbility()

	self.iRadius = ability:GetSpecialValueFor("radius")+100
	self.iSpeed = ability:GetSpecialValueFor("speed")
    self.iDamage = ability:GetSpecialValueFor("damage") * ability:GetCaster():GetBaseDamageMax()
    self.enemy_number = 0

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
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:OnIntervalThink()
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
					if self.fCurDis <= CalculateDistance(enemy,self.hCaster) then
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
                        self.enemy_number = self.enemy_number + 1
						local iDamage = self.iDamage
	
						local tDamage = {
							ability = self:GetAbility(),
							attacker = self.hCaster,
							victim = enemy,
							damage = iDamage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
                            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
						}
						ApplyDamage(tDamage)
						enemy.IsFlag = true
					end
				end
            end
            
            --伤害结束，移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.iSpeed,self.fCurDis+self.iEffectWidth, 1))
            --如果到达最大距离则结束
            if self.fCurDis == self.iRadius then
                self:SafeDestroy()
            end
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)
		end
	end
end


function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
        if self.enemy_number <= 0 then
            local lost = (self:GetParent():GetMaxHealth()-self:GetParent():GetHealth())*0.04
            self:GetParent():Heal(lost,nil)
        end
	end
end

function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_creeps_spell_Electrostatic_Armor_Unstable_chaotic_spell:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("move")
end