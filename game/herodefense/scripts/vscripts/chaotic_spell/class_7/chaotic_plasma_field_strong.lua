LinkLuaModifier("modifier_chaotic_plasma_field_strong_auto", "chaotic_spell/class_7/chaotic_plasma_field_strong", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_plasma_field_strong_active", "chaotic_spell/class_7/chaotic_plasma_field_strong", LUA_MODIFIER_MOTION_NONE)
chaotic_plasma_field_strong = chaotic_plasma_field_strong or class({})

function chaotic_plasma_field_strong:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_arcana/razor_arcana_plasma_field.vpcf", context )
end
function chaotic_plasma_field_strong:GetIntrinsicModifierName()
	return "modifier_chaotic_plasma_field_strong_auto"
end

function chaotic_plasma_field_strong:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function chaotic_plasma_field_strong:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
function chaotic_plasma_field_strong:OnSpellStart()
	if not IsServer() then return end
    self.rune = self:GetRuneType()
    local caster = self:GetCaster()
    self:Plasma_Field(caster, 1)

	if self.rune == 2 then
		if self:GetSpecialValueFor("rune_2_chance") >= math.random(1,100) then
			caster:GameTimer(0.5, function()
				if IsValid(self) then
					self:Plasma_Field(caster, 1)
				end
			end)
		end
	end
end
function chaotic_plasma_field_strong:GetBehavior()
	if self:GetRuneType() == 2 then
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL
	end
	return self.BaseClass.GetBehavior(self)
end
function chaotic_plasma_field_strong:Plasma_Field(source, index)
	if not IsServer() then return end
    if not source then return end
    local index = index or 1
    local caster = self:GetCaster()
    local damage = (self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue())*index

    source:AddNewModifier(caster, self, "modifier_chaotic_plasma_field_strong_active", {damage = damage})
end
--------------------------------------
modifier_chaotic_plasma_field_strong_active = class({})
function modifier_chaotic_plasma_field_strong_active:IsHidden() return true end
function modifier_chaotic_plasma_field_strong_active:IsDebuff() return false end
function modifier_chaotic_plasma_field_strong_active:IsPurgable() return false end
function modifier_chaotic_plasma_field_strong_active:IsPurgeException() return false end
function modifier_chaotic_plasma_field_strong_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_plasma_field_strong_active:OnCreated(params)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.move = self.ability:GetSpecialValueFor("move")
	self.index = self.ability:GetSpecialValueFor("index")*0.01
	self.rune_1_cd = self.ability:GetSpecialValueFor("rune_1_cd")
	self.radius = self.ability:GetAOERadius()
	self.speed = self.radius*0.9
    if IsServer() then
		self.damage = params.damage
		self.tEnemies = {}
		self.effect_table = {}
		self.iDur = 1   --控制移动方向
		self.fCurDis = 0
		self.iEffectWidth = 80

		self.parent:EmitSound("Ability.PlasmaField")
		self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_plasma_field.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_chaotic_plasma_field_strong_active:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	if self.parent:IsNull() or not self.parent:IsAlive() then self:Destroy() return end
	if self.caster:IsNull() or not self.caster:IsAlive() then self:Destroy() return end
	if IsServer() then
        --先将搜寻到的敌人插入表中
        local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.fCurDis+self.iEffectWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
            for i, enemy in pairs(enemies) do
                --如果是正向
				if self.iDur == 1 then
					if not IsInTable(enemy,self.tEnemies) and CalculateDistance(enemy,self.parent)>=(self.fCurDis-self.iEffectWidth) then
						self.effect_table[enemy] =  false
						table.insert(self.tEnemies, enemy)
                    end
                --否则为反向
                else
                    --判断当前特效的距离，如果小于敌人与施法者的距离
					if self.fCurDis-self.iEffectWidth  <= CalculateDistance(enemy,self.parent) then
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
							
							local damage = self.damage
							local elecshocking = enemy:FindModifierByName("modifier_hd_elec_shocking")
							if elecshocking then
								damage = damage * (1+elecshocking:GetStackCount()*0.1*self.index)
							end

							local tDamage = {
								ability = self.ability,
								attacker = self.parent,
								victim = enemy,
								damage = damage,
								damage_type = self.ability:GetAbilityDamageType(),
								hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
							}
							local damage_actual = ApplyDamage(tDamage)

							if self.ability.type == 1 then
								if elecshocking and not enemy:IsAlive() then
									local newcooldown = math.max(self.ability:GetCooldownTimeRemaining() - self.rune_1_cd, 0)
									self.ability:EndCooldown()
									self.ability:StartCooldown(newcooldown)
								end
							end
						end

					end
				end
            end
            
            --移动特效
            ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self.speed,self.fCurDis+self.iEffectWidth, 1))
            --如果到达最大距离则反向移动
            if self.fCurDis == self.radius then
				self.iDur = -1
                self.speed=-self.speed
                --清空表
                self.tEnemies={}
				self.effect_table = {}
                --再搜寻一次
				local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.fCurDis+self.iEffectWidth, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _,enemy in pairs(enemies) do
					if not IsInTable(enemy,self.tEnemies) and ((enemy:GetAbsOrigin()-self.parent:GetAbsOrigin()):Length2D())>self.fCurDis+self.iEffectWidth then
						self.effect_table[enemy] =  false
						table.insert(self.tEnemies, enemy)
					end
				end
            end
            --结束反向操作
            self.fCurDis=math.min(self.fCurDis+self.speed*FrameTime(),self.radius)

            if self.fCurDis<=0 then
				self:SafeDestroy()
			end
		end
end


function modifier_chaotic_plasma_field_strong_active:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
	end
end
function modifier_chaotic_plasma_field_strong_active:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_chaotic_plasma_field_strong_active:GetModifierMoveSpeedBonus_Percentage()
	return self.move
end

--------------------------------------
modifier_chaotic_plasma_field_strong_auto = advanced_modifier({})

function modifier_chaotic_plasma_field_strong_auto:IsHidden()		return true end
function modifier_chaotic_plasma_field_strong_auto:IsPurgable()		return false end
function modifier_chaotic_plasma_field_strong_auto:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.6)
	end
end
function modifier_chaotic_plasma_field_strong_auto:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability and self:GetParent():IsAlive() then
		if ability:GetRuneType() ~= 2 and (self:GetParent():IsChanneling() or self:GetParent():GetCurrentActiveAbility()~=nil) then return end
		if HDCanAutoCast(caster, ability)==true then
			self:GetParent():CastAbilityNoTarget(ability, self:GetParent():GetPlayerOwnerID())
		end
	end
end