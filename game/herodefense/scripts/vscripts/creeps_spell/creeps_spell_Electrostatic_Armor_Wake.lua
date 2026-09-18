creeps_spell_Electrostatic_Armor_Wake = class({})
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count", "creeps_spell/creeps_spell_Electrostatic_Armor_Wake", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_Wake_triger", "creeps_spell/creeps_spell_Electrostatic_Armor_Wake", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Electrostatic_Armor_Wake_spell", "creeps_spell/creeps_spell_Electrostatic_Armor_Wake", LUA_MODIFIER_MOTION_NONE)

--Abilities
function creeps_spell_Electrostatic_Armor_Wake:IsHiddenWhenStolen() 		return false end
function creeps_spell_Electrostatic_Armor_Wake:IsRefreshable() 			return true end
function creeps_spell_Electrostatic_Armor_Wake:IsStealable() 				return true end
function creeps_spell_Electrostatic_Armor_Wake:IsNetherWardStealable()		return true end
function creeps_spell_Electrostatic_Armor_Wake:GetIntrinsicModifierName() return "modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count" end
function creeps_spell_Electrostatic_Armor_Wake:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function creeps_spell_Electrostatic_Armor_Wake:OnSpellStart()
	local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_creeps_spell_Electrostatic_Armor_Wake_triger", {duration= self:GetSpecialValueFor("delay")})
end


modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count = class({})
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:IsPurgable() 		return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:IsPurgeException() 	return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:RemoveOnDeath()  return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:DeclareFunctions() return
    {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_creeps_spell_Electrostatic_Armor_Wake_damage_count:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("bonus_magic_resistance") end


modifier_creeps_spell_Electrostatic_Armor_Wake_triger = class({})
function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:IsPurgable() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:IsPurgeException() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:AllowIllusionDuplicate() return false end
--无法移动，无法攻击，沉默
function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_SILENCED]   = true,
    }
    return state
end

function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_Wake_spell", {})
end

function modifier_creeps_spell_Electrostatic_Armor_Wake_triger:OnRefresh(table)
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_Electrostatic_Armor_Wake_spell", {})
end



modifier_creeps_spell_Electrostatic_Armor_Wake_spell = class({})
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:IsHidden() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:IsDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:IsPurgable() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:IsPurgeException() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:IsStunDebuff() return false end
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:OnCreated(params)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetCaster()
    local ability = self:GetAbility()

	self.iRadius = ability:GetSpecialValueFor("radius")+100
	self.iSpeed = ability:GetSpecialValueFor("speed")
    self.iDamage = ability:GetSpecialValueFor("damage") * ability:GetCaster():GetBaseDamageMax()


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
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:OnIntervalThink()
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
					if self.fCurDis <= (enemy:GetAbsOrigin() - self.hCaster:GetAbsOrigin()):Length2D() then
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
            --如果到达最大距离则结束
            if self.fCurDis == self.iRadius then
                self:SafeDestroy()
            end
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)
		end
	end
end


function modifier_creeps_spell_Electrostatic_Armor_Wake_spell:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
