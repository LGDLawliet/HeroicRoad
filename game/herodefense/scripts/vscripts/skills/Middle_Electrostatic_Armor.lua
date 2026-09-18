Middle_Electrostatic_Armor = class({})
LinkLuaModifier("modifier_Middle_Electrostatic_Armor_damage_count", "skills/Middle_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Electrostatic_Armor_spell", "skills/Middle_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Middle_Electrostatic_Armor_shield", "skills/Middle_Electrostatic_Armor", LUA_MODIFIER_MOTION_NONE)

function Middle_Electrostatic_Armor:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_punctured_crest/razor_storm_lightning_strike_blade.vpcf", context )
	
end
--Abilities
function Middle_Electrostatic_Armor:IsHiddenWhenStolen() 		return false end
function Middle_Electrostatic_Armor:IsRefreshable() 			return true end
function Middle_Electrostatic_Armor:IsStealable() 				return true end
function Middle_Electrostatic_Armor:IsNetherWardStealable()		return true end
function Middle_Electrostatic_Armor:GetIntrinsicModifierName() return "modifier_Middle_Electrostatic_Armor_damage_count" end
function Middle_Electrostatic_Armor:GetAOERadius()
	return self:GetSpecialValueFor("radius")- self:GetCaster():GetCastRangeBonus()
end


modifier_Middle_Electrostatic_Armor_damage_count = class({})
function modifier_Middle_Electrostatic_Armor_damage_count:IsHidden() return false end
function modifier_Middle_Electrostatic_Armor_damage_count:IsDebuff() return false end
function modifier_Middle_Electrostatic_Armor_damage_count:IsPurgable() 		return false end
function modifier_Middle_Electrostatic_Armor_damage_count:IsPurgeException() 	return false end
function modifier_Middle_Electrostatic_Armor_damage_count:RemoveOnDeath()  return false end
function modifier_Middle_Electrostatic_Armor_damage_count:IsStunDebuff() return false end
function modifier_Middle_Electrostatic_Armor_damage_count:AllowIllusionDuplicate() return false end

function modifier_Middle_Electrostatic_Armor_damage_count:DeclareFunctions() return
    {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_Middle_Electrostatic_Armor_damage_count:GetModifierMagicalResistanceBonus() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("bonus_magic_resistance") end


function modifier_Middle_Electrostatic_Armor_damage_count:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
	if keys.unit:PassivesDisabled() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if not keys.attacker then
		return
	end
	if keys.attacker:GetTeamNumber()==self:GetParent():GetTeamNumber() then
		return
	end
    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
    --判断累计伤害是否达到触发线
    if self:GetStackCount() > caster:GetMaxHealth()*ability:GetSpecialValueFor("damage_require")*0.01 then
        caster:AddNewModifier(caster, ability, "modifier_Middle_Electrostatic_Armor_spell", {})
        self:SetStackCount(0)
		ability:UseResources(true, true, true, true)
    end
end




modifier_Middle_Electrostatic_Armor_spell = class({})
function modifier_Middle_Electrostatic_Armor_spell:IsHidden() return true end
function modifier_Middle_Electrostatic_Armor_spell:IsDebuff() return false end
function modifier_Middle_Electrostatic_Armor_spell:IsPurgable() return false end
function modifier_Middle_Electrostatic_Armor_spell:IsPurgeException() return false end
function modifier_Middle_Electrostatic_Armor_spell:IsStunDebuff() return false end
function modifier_Middle_Electrostatic_Armor_spell:AllowIllusionDuplicate() return false end

function modifier_Middle_Electrostatic_Armor_spell:OnCreated(params)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetCaster()
    local ability = self:GetAbility()

	self.iRadius = ability:GetSpecialValueFor("radius")+100
	self.iSpeed = 500
    self.iDamage = ability:GetSpecialValueFor("base_damage") + ability:GetCaster():GetStrength()*ability:GetSpecialValueFor("bonus_damage")
    --self.Shield = ability:GetSpecialValueFor("Shield") * ability:GetCaster():GetBaseDamageMax()

	--imba
	self.tEnemies = {}
	self.effect_table = {}
	self.iDur = 1   --控制移动方向
	self.fCurDis = 0
	self.iEffectWidth = 50
	if IsServer() then
		self.hCaster:EmitSound("Ability.PlasmaField")
		
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self.hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, self.hCaster:GetAbsOrigin(), true)
		self:StartIntervalThink(FrameTime())
	end
end
--可以多重
function modifier_Middle_Electrostatic_Armor_spell:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_Electrostatic_Armor_spell:OnIntervalThink()
	if IsServer() then
        if not self.hCaster:IsNull() and  self.hCaster:IsAlive() then
            --先将搜寻到的敌人插入表中
            local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil,
             self.fCurDis+self.iEffectWidth,
              DOTA_UNIT_TARGET_TEAM_ENEMY,
               DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for i, enemy in pairs(enemies) do
                --如果是正向
				if self.iDur == 1 then
					if not IsInTable(enemy,self.tEnemies) and CalculateDistance(enemy,self.hCaster)>=(self.fCurDis-self.iEffectWidth) then

						self.effect_table[enemy] =  false
						table.insert(self.tEnemies, enemy)
                    end
                --否则为反向
                else
                    --判断当前特效的距离，如果小于敌人与施法者的距离
					if self.fCurDis-self.iEffectWidth  <= CalculateDistance(enemy,self.hCaster) then
						if not IsInTable(enemy,self.tEnemies)then
							self.effect_table[enemy] =  false
							table.insert(self.tEnemies, enemy)
						end
					end
				end
            end
            --对敌人造成伤害
            if self.tEnemies then
                --取出单位造成伤害，并将已伤害标记为true
				for _, enemy in pairs(self.tEnemies) do
					if not self.effect_table[enemy] then
						if not enemy:IsNull() then
							

							self.effect_table[enemy] =  true

							enemy:EmitSound("Ability.PlasmaFieldImpact")
							local particle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest/razor_storm_lightning_strike_blade.vpcf", PATTACH_CUSTOMORIGIN, enemy)
							ParticleManager:SetParticleControlEnt(particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
							ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
							ParticleManager:ReleaseParticleIndex(particle)
							local iDamage = self.iDamage
		
							local tDamage = {
								ability = self:GetAbility(),
								attacker = self.hCaster,
								victim = enemy,
								damage = iDamage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
							}
							ApplyDamage(tDamage)
						end

					end
				end
            end
            
            --移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.iSpeed,self.fCurDis+self.iEffectWidth, 1))
            --如果到达最大距离则反向移动
            if self.fCurDis == self.iRadius then
                -- self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Middle_Electrostatic_Armor_shield",
                --  {duration=self:GetAbility():GetSpecialValueFor("duration"),index=#self.tEnemies *self.Shield})
				self.iDur = -1
                self.iSpeed=-self.iSpeed
                --清空表
                self.tEnemies={}
				self.effect_table = {}
                --再搜寻一次
				local enemies = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil, self.fCurDis+self.iEffectWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _,enemy in pairs(enemies) do
					if not IsInTable(enemy,self.tEnemies) and ((enemy:GetAbsOrigin()-self.hCaster:GetAbsOrigin()):Length2D())>self.fCurDis+self.iEffectWidth then
						self.effect_table[enemy] =  false
						table.insert(self.tEnemies, enemy)
					end
				end
				-- self:SafeDestroy()
            end
            --结束反向操作
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)

            if self.fCurDis<=0 then
                -- local ModifierStatusGain = self:GetParent():GetModifierDurationGainIndex(1)
                -- self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_Middle_Electrostatic_Armor_shield", 
                -- {duration=self:GetAbility():GetSpecialValueFor("duration")*ModifierStatusGain,index=#self.tEnemies *self.Shield})
				self:SafeDestroy()
			end
		end
	end
end


function modifier_Middle_Electrostatic_Armor_spell:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
	end
end

