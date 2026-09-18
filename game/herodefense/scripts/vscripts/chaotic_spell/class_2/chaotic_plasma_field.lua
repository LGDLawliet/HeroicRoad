LinkLuaModifier("modifier_chaotic_plasma_field_auto", "chaotic_spell/class_2/chaotic_plasma_field", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_plasma_field_active", "chaotic_spell/class_2/chaotic_plasma_field", LUA_MODIFIER_MOTION_NONE)
chaotic_plasma_field = chaotic_plasma_field or class({})

function chaotic_plasma_field:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf", context )
end
function chaotic_plasma_field:GetIntrinsicModifierName()
	return "modifier_chaotic_plasma_field_auto"
end

function chaotic_plasma_field:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function chaotic_plasma_field:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function chaotic_plasma_field:OnSpellStart()
	if not IsServer() then return end
    self.rune = self:GetRuneType()
    local caster = self:GetCaster()
    self:Plasma_Field(caster, 1)
end

function chaotic_plasma_field:Plasma_Field(source, index)
	if not IsServer() then return end
    if not source then return end
    local index = index or 1
    local caster = self:GetCaster()
    local damage = (self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())*index

    source:AddNewModifier(caster, self, "modifier_chaotic_plasma_field_active", {damage = damage})
end
--------------------------------------
modifier_chaotic_plasma_field_active = advanced_modifier({})
function modifier_chaotic_plasma_field_active:IsHidden() return true end
function modifier_chaotic_plasma_field_active:IsDebuff() return false end
function modifier_chaotic_plasma_field_active:IsPurgable() return false end
function modifier_chaotic_plasma_field_active:IsPurgeException() return false end
function modifier_chaotic_plasma_field_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_plasma_field_active:OnCreated(keys)
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    if IsServer() then
        self.rune_1_manasteal = self.ability:GetSpecialValueFor("rune_1_manasteal")*0.01
        self.rune_1_manamax = self.ability:GetSpecialValueFor("rune_1_manamax")*0.01
        self.elecshocking = self.ability:GetSpecialValueFor("elecshocking")
        self.max = self.ability:GetSpecialValueFor("max")
        self.radius = self.ability:GetAOERadius()
        self.speed = self.radius*1.5
        self.damage = keys.damage
        self.enemy_number = 0

        self.tEnemies = {}
        self.fCurDis = 0
        self.iEffectWidth = 80

		self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:StartIntervalThink(FrameTime())
        self.parent:EmitSound("Ability.PlasmaField")
	end
end

function modifier_chaotic_plasma_field_active:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsNull() or not self.parent:IsAlive() then self:Destroy() return end
	if self.caster:IsNull() or not self.caster:IsAlive() then self:Destroy() return end
	if IsServer() then
            --先将搜寻到的敌人插入表中
            local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.fCurDis+self.iEffectWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

            for _, enemy in ipairs(enemies) do
                if not IsInTable(enemy,self.tEnemies) and CalculateDistance(enemy,self.parent)>=(self.fCurDis-self.iEffectWidth) then
                    enemy.IsFlag = false
                    table.insert(self.tEnemies, enemy)
                    if #self.tEnemies >= self.max then
                        break
                    end
                end
            end
            --敌人入表结束
            if self.tEnemies then
                --取出单位造成伤害，并将已伤害标记为true
				for i, enemy in ipairs(self.tEnemies) do
					if not enemy.IsFlag then
                        self.enemy_number = self.enemy_number + 1
						local tDamage = {
							ability = self.ability,
							attacker = self.caster,
							victim = enemy,
							damage = self.damage,
							damage_type = self.ability:GetAbilityDamageType(),
                            hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE
						}
						local damage_actual = ApplyDamage(tDamage)
                        if self.ability.rune == 1 then
                           local mana_steal =  math.min(damage_actual*self.rune_1_manasteal, self.caster:GetMaxMana()*self.rune_1_manamax)
                           self.caster:GiveMana(mana_steal)
                        end

                        if enemy:IsAlive() then
                            enemy:Elecshocking(self.caster, self.ability, self.elecshocking)
                        end
                        enemy.IsFlag = true
                        if self.enemy_number >= self.max then
                            break
                        end
					end
				end
            end
            
            --伤害结束，移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.speed,self.fCurDis+self.iEffectWidth, 1))
            --如果到达最大距离则结束
            if self.fCurDis == self.radius then
                self:SafeDestroy()
            end
            self.fCurDis=math.min(self.fCurDis+self.speed*FrameTime(),self.radius)
	end
end
function modifier_chaotic_plasma_field_active:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
--------------------------------------
modifier_chaotic_plasma_field_auto = advanced_modifier({})

function modifier_chaotic_plasma_field_auto:IsHidden()		return true end
function modifier_chaotic_plasma_field_auto:IsPurgable()		return false end
function modifier_chaotic_plasma_field_auto:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.6)
	end
end
function modifier_chaotic_plasma_field_auto:OnIntervalThink()
    local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability and self:GetParent():IsAlive() and not self:GetParent():IsChanneling() and caster:GetCurrentActiveAbility()==nil then
		if HDCanAutoCast(caster, ability)==true then
			self:GetParent():CastAbilityNoTarget(ability, self:GetParent():GetPlayerOwnerID())
		end
	end
end