item_hd_balnock_shield = class({})
-- LinkLuaModifier("modifier_item_hd_balnock_shield_arua", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_shield_arua_effect", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_balnock_shield", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_balnock_shield_active", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_shield_active", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_shield_effect", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_shield_effect2", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_shield_active_standby", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_shield_debuff", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_balnock_shield_thinker", "items/item_hd_balnock_shield", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_balnock_shield:GetIntrinsicModifierName()
	return "modifier_item_hd_balnock_shield"
end




modifier_item_hd_balnock_shield = advanced_modifier({})

function modifier_item_hd_balnock_shield:IsDebuff() return false end
function modifier_item_hd_balnock_shield:IsHidden() return true end
function modifier_item_hd_balnock_shield:IsPurgable() return false end



function modifier_item_hd_balnock_shield:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_magic_resistance = self.ability:GetSpecialValueFor("bonus_magic_resistance")
	self.bonus_Magical_ConstantBlock = self.ability:GetSpecialValueFor( "bonus_Magical_ConstantBlock" ) 
end

function modifier_item_hd_balnock_shield:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		-- MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
	}
end

function modifier_item_hd_balnock_shield:GetModifierMagicalResistanceBonus() return self.bonus_magic_resistance end
-- function modifier_item_hd_balnock_shield:GetModifierMagical_ConstantBlock() return self.bonus_Magical_ConstantBlock end



function modifier_item_hd_balnock_shield:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end

	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
    end
	if bit.band(keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then
		return
    end
    local ability = self:GetAbility()
    local caster = self:GetParent()
    self:SetStackCount(self:GetStackCount()+keys.damage)
    --判断累计伤害是否达到触发线
    if self:GetStackCount() > 750 and ability:IsCooldownReady() then
		ability:UseResources(true, true, true, true)
        caster:AddNewModifier(caster, ability, "modifier_item_hd_balnock_shield_active", {})
        self:SetStackCount(0)
    end
end



function modifier_item_hd_balnock_shield:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_MAGACIAL_BLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_item_hd_balnock_shield:Advanced_GetModifierMagicalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	return self.bonus_Magical_ConstantBlock 
end




modifier_item_hd_balnock_shield_active = class({})
function modifier_item_hd_balnock_shield_active:IsHidden() return true end
function modifier_item_hd_balnock_shield_active:IsDebuff() return false end
function modifier_item_hd_balnock_shield_active:IsPurgable() return false end
function modifier_item_hd_balnock_shield_active:IsPurgeException() return false end
function modifier_item_hd_balnock_shield_active:IsStunDebuff() return false end
function modifier_item_hd_balnock_shield_active:AllowIllusionDuplicate() return false end

function modifier_item_hd_balnock_shield_active:OnCreated(params)
    if not IsServer() then
        return
    end
    self.hCaster = self:GetCaster()
    local ability = self:GetAbility()

	self.iRadius = 500
	self.iSpeed = 1000
    self.iDamage = ability:GetCaster():GetStrength()*2


	--imba
	self.tEnemies = {}
	self.iDur = 1   --控制移动方向
	self.fCurDis = 0
	self.iEffectWidth = 200
	if IsServer() then
		self.hCaster:EmitSound("Ability.PlasmaField")
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_plasmafield.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self.hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, self.hCaster:GetAbsOrigin(), true)
		self:StartIntervalThink(FrameTime())
	end
end
--可以多重
function modifier_item_hd_balnock_shield_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_balnock_shield_active:OnIntervalThink()
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
					if not IsInTable(enemy,self.tEnemies) then
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
                self:Destroy()
            end
            self.fCurDis=math.min(self.fCurDis+self.iSpeed*FrameTime(),self.iRadius)
		end
	end
end


function modifier_item_hd_balnock_shield_active:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
end
