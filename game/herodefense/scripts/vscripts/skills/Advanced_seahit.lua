LinkLuaModifier( "modifier_Advanced_seahit_motion", "skills/Advanced_seahit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_seahit_fly", "skills/Advanced_seahit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_seahit_buff", "skills/Advanced_seahit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_seahit_immune", "skills/Advanced_seahit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_seahit_lv10", "skills/Advanced_seahit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_seahit_lv15", "skills/Advanced_seahit.lua", LUA_MODIFIER_MOTION_NONE )
Advanced_seahit = class({})

function Advanced_seahit:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Advanced_seahit:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", context )
    PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
end
function Advanced_seahit:GetCastRange(location , target)
	if IsServer() then return 30000 end	
	if IsClient() then
		if self:GetUnlock(1)==1 then
        	return 3000 + self:GetCaster():GetCastRangeBonus()	
		end
		return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()	
	end
end
function Advanced_seahit:CheckKV(key)
	local table = {
		freezing=0.1,
        damage = 10,
        bonus_damage = 0.1,
	}
	local value = table[key] or -1
	return value
end
function Advanced_seahit:UnlockFirstCore(key)
	return true
end
function Advanced_seahit:UnlockSecondCore(key)
	return true
end
function Advanced_seahit:UnlockThirdCore(key)
	return true
end
function Advanced_seahit:OnArrived(pos)
	if not IsServer() then return end
	local caster = self:GetCaster()
    local level = self:GetSpecialValueFor("advanced_level")
	if not caster:IsAlive() then return end
	if not pos then return end

	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage") + caster:GetAverageTrueAttackDamage(nil)*self:GetSpecialValueFor("bonus_damage")
    if caster:HasModifier("modifier_Primary_enchant_totem") or caster:HasModifier("modifier_Middle_enchant_totem") or caster:HasModifier("modifier_Advanced_enchant_totem") then
        damage = damage*0.27
    end
    -- 基于距离的伤害加成
    if self:GetUnlock(1) == 1 and self.start_pos then
        local distance = (pos - self.start_pos):Length2D()
        local distance_of_limit = math.min(distance / 4000, 1.0) --实际距离和4000的比例，范围0~1
        damage = damage * (1 + distance_of_limit*2) --实际比例*200%转化为增伤，范围0~200%
    end

    local lv15_check = nil
    local buffed = caster:FindModifierByName("modifier_Advanced_seahit_buff")
    if buffed then
        lv15_check = true
        damage = damage * (1+self:GetSpecialValueFor("kill_bonus")*0.01)
        buffed:Destroy()
    end

	local damageTable = {
		--victim = enemy,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	}
	-- 特效音效
	local particle_name = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
	local torrent_particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(torrent_particle, 0, pos)
	ParticleManager:ReleaseParticleIndex(torrent_particle)
	EmitSoundOnLocationWithCaster(pos, "Ability.Torrent", caster)

	-- 伤害效果
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in ipairs(enemies) do
		if enemy ~= nil and not enemy:IsMagicImmune() then
            -- lv15 物理护甲减少
            if level >= 15 then
                local armor_down = 15
                if lv15_check then
                    armor_down = 25
                end
                local debuff = enemy:FindModifierByName("modifier_Advanced_seahit_lv15")
                if debuff then
                    if debuff:GetStackCount() >= 25 then
                        debuff:SetDuration(3, true)
                    else
                        debuff:SetStackCount(armor_down)
                        debuff:SetDuration(3, true)
                    end
                else
                    local newdebuff = enemy:AddNewModifier(caster, self, "modifier_Advanced_seahit_lv15", {duration = 3})
                    newdebuff:SetStackCount(armor_down)
                end
            end

			damageTable.victim = enemy
			ApplyDamage(damageTable)

			if enemy:IsAlive() then
				enemy:AddNewModifier(caster, self, "modifier_Advanced_seahit_fly", {duration = 0.5})
            else
                -- 中阶：每个击杀回复cd，击杀buff添加
                if not self:IsCooldownReady() then
                    local newcooldown = self:GetCooldownTimeRemaining() - self:GetSpecialValueFor("cd")
                    self:EndCooldown()
                    self:StartCooldown(newcooldown)
                end

                local buff = caster:FindModifierByName("modifier_Advanced_seahit_buff")
                if not buff then
                    caster:AddNewModifier(caster, self, "modifier_Advanced_seahit_buff", {})
                end
            end
		end
	end

    if level >= 20 then
        caster:GameTimer(0.5, function()
            if IsValid(self) then
                -- 随机生成3个至少距离400码的地点
                local random_num = 3
                local min_radius = 380
                local max_radius = 220
                if self:GetUnlock(2)==2 then
                    random_num = 12
                    max_radius = 600
                end
                for i = 1, random_num do
                    local angle = math.random() * 2 * math.pi
                    local distance = min_radius + math.random() * max_radius  -- 距离在400-600之间
                    local offset = Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0)
                    local random_pos = pos + offset
                    
                    -- 确保位置在地面上
                    random_pos = GetGroundPosition(random_pos, nil)
                    
                    -- 延迟触发，让效果有层次感
                    caster:GameTimer(0.3 * i, function()
                        if IsValid(self) then
                            self:OnArrived_lv20(random_pos)
                        end
                    end)
                end
            end
        end)
    end
end

function Advanced_seahit:OnArrived_lv20(pos) --这是次级洪流，不使用浪打千击
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster:IsAlive() then return end
	if not pos then return end

	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage") + caster:HDGetPrimaryStatValue()*self:GetSpecialValueFor("bonus_damage")

	local damageTable = {
		--victim = enemy,
		attacker = caster,
		damage = damage*0.7,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	}
	-- 特效音效
    local particle_name2 = "particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf"
	local torrent_particle2 = ParticleManager:CreateParticle(particle_name2, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(torrent_particle2, 0, pos)
	ParticleManager:ReleaseParticleIndex(torrent_particle2)
	EmitSoundOnLocationWithCaster(pos, "Ability.Torrent", caster)
	-- 伤害效果
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in ipairs(enemies) do
		if enemy ~= nil and not enemy:IsMagicImmune() then
            -- lv15 物理护甲减少
            local debuff = enemy:FindModifierByName("modifier_Advanced_seahit_lv15")
            if debuff then
                if debuff:GetStackCount() >= 25 then
                    debuff:SetDuration(3, true)
                else
                    debuff:SetStackCount(15)
                    debuff:SetDuration(3, true)
                end
            else
                local newdebuff = enemy:AddNewModifier(caster, self, "modifier_Advanced_seahit_lv15", {duration = 3})
                newdebuff:SetStackCount(15)
            end

			damageTable.victim = enemy
			ApplyDamage(damageTable)

			if enemy:IsAlive() then
				enemy:AddNewModifier(caster, self, "modifier_Advanced_seahit_fly", {duration = 0.5})
            else
                -- 中阶：每个击杀回复cd，击杀buff添加
                if not self:IsCooldownReady() then
                    local newcooldown = self:GetCooldownTimeRemaining() - self:GetSpecialValueFor("cd")
                    self:EndCooldown()
                    self:StartCooldown(newcooldown)
                end

                local buff = caster:FindModifierByName("modifier_Advanced_seahit_buff")
                if not buff then
                    caster:AddNewModifier(caster, self, "modifier_Advanced_seahit_buff", {})
                end
            end
		end
	end
end

function Advanced_seahit:OnSpellStart()
	local caster = self:GetCaster()
    self.level  = self:GetSpecialValueFor("advanced_level")
    self.start_pos = caster:GetAbsOrigin()  -- 存储起始位置
	-- 冲锋的部分
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local direction = (target_pos - caster_pos):Normalized()
	direction.z = 0.0
	local range = self:GetUnlock(1)==1 and (3000 + self:GetCaster():GetCastRangeBonus()) or (self.BaseClass.GetCastRange(self,caster_pos,caster) + self:GetCaster():GetCastRangeBonus())
	local speed = 2250

	local pos = ((target_pos - caster_pos):Length2D() <= range) and target_pos or (caster_pos + direction * range)
	local duration = (caster_pos - pos):Length2D() / speed
	caster:AddNewModifier(caster, self, "modifier_Advanced_seahit_motion", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z, start_x = caster_pos.x, start_y = caster_pos.y, start_z = caster_pos.z})
    caster:AddNewModifier(caster, self, "modifier_Advanced_seahit_immune", {duration = duration + self:GetSpecialValueFor("delay")})
	caster:EmitSound("Hero_Morphling.Waveform")
	ProjectileManager:ProjectileDodge(caster)
end

---------------------------------------------------------------------
modifier_Advanced_seahit_buff = advanced_modifier({})

function modifier_Advanced_seahit_buff:IsDebuff()			return false end
function modifier_Advanced_seahit_buff:IsHidden() 			return false end
function modifier_Advanced_seahit_buff:IsPurgable() 		return false end
function modifier_Advanced_seahit_buff:IsPurgeException() 	return false end
---------------------------------------------------------------------
modifier_Advanced_seahit_immune = advanced_modifier({})

function modifier_Advanced_seahit_immune:IsDebuff()			return false end
function modifier_Advanced_seahit_immune:IsHidden() 			return true end
function modifier_Advanced_seahit_immune:IsPurgable() 		return false end
function modifier_Advanced_seahit_immune:IsPurgeException() 	return false end
function modifier_Advanced_seahit_immune:GetEffectName()	return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_Advanced_seahit_immune:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_seahit_immune:CheckState()
    return{
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end
---------------------------------------------------------------------
modifier_Advanced_seahit_lv10 = advanced_modifier({})

function modifier_Advanced_seahit_lv10:IsDebuff()			return false end
function modifier_Advanced_seahit_lv10:IsHidden() 			return false end
function modifier_Advanced_seahit_lv10:IsPurgable() 		return false end
function modifier_Advanced_seahit_lv10:IsPurgeException() 	return false end
function modifier_Advanced_seahit_lv10:ADDeclareFunctions() 
	return{
       advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_Advanced_seahit_lv10:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() end
    return 50
end
---------------------------------------------------------------------
modifier_Advanced_seahit_lv15 = advanced_modifier({})

function modifier_Advanced_seahit_lv15:IsDebuff()			return true end
function modifier_Advanced_seahit_lv15:IsHidden() 			return false end
function modifier_Advanced_seahit_lv15:IsPurgable() 		return false end
function modifier_Advanced_seahit_lv15:IsPurgeException() 	return false end
function modifier_Advanced_seahit_lv15:ADDeclareFunctions() 
	return{
       advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end
function modifier_Advanced_seahit_lv15:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()
end
---------------------------------------------------------------------
modifier_Advanced_seahit_motion = advanced_modifier({})

function modifier_Advanced_seahit_motion:IsDebuff()			return false end
function modifier_Advanced_seahit_motion:IsHidden() 			return true end
function modifier_Advanced_seahit_motion:IsPurgable() 		return false end
function modifier_Advanced_seahit_motion:IsPurgeException() 	return false end
function modifier_Advanced_seahit_motion:IsStunDebuff()		return true end
--状态
function modifier_Advanced_seahit_motion:CheckState() 
	return 
	{[MODIFIER_STATE_ROOTED] = true,
	 [MODIFIER_STATE_DISARMED] = true,
	 --[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	 [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	 [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true ,
	 --[MODIFIER_STATE_INVULNERABLE] = true ,
	 --[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end

function modifier_Advanced_seahit_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_Advanced_seahit_motion:GetModifierDisableTurning() return 1 end
function modifier_Advanced_seahit_motion:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_1 end
function modifier_Advanced_seahit_motion:IsMotionController() return true end
function modifier_Advanced_seahit_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Advanced_seahit_motion:OnCreated(keys)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	self.freezing = ability:GetSpecialValueFor("freezing")
	self.incoming = ability:GetSpecialValueFor("incoming")
    self.level = ability:GetSpecialValueFor("advanced_level")
    self.start_pos = Vector(keys.start_x, keys.start_y, keys.start_z)  -- 存储起始位置

    if self.level >= 5 then
        self.incoming = 95
    end
	if IsServer() then
		self.hitted = {}
		self.hitted_friendly = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.speed = 2250

		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())

			--特效
			local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, parent)
			local pfx_pos = parent:GetAbsOrigin() + parent:GetUpVector() * 50
			ParticleManager:SetParticleControl(self.pfx, 0, pfx_pos)
			ParticleManager:SetParticleControl(self.pfx, 1, (self.pos - parent:GetAbsOrigin()):Normalized() * self.speed)
			self:AddParticle(self.pfx, false, false, 15, false, false)
		else
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_seahit_motion:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local current_pos = parent:GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	local width = 300
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	parent:SetOrigin(next_pos)
	parent:SetForwardVector(direction)
	--沿途敌军效果
	local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			if not enemy:IsMagicImmune() then 
				local freezing = self.freezing*caster:HDGetPrimaryStatValue()
				enemy:Freezing(caster, ability, freezing)
				table.insert(self.hitted,enemy)
			end
		end
	end
	
	-- 沿途友军效果
    if self.level >= 10 then
        local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(),nil, width,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_INVULNERABLE,FIND_ANY_ORDER, false)
        caster:AddNewModifier(caster, ability, "modifier_Advanced_seahit_lv10", {duration = 2})
        table.insert(self.hitted_friendly, caster)

        for _, unit in pairs(units) do
            if not IsInTable(unit, self.hitted_friendly) then
                if unit ~= caster and ability:GetUnlock(3)==3 then
                    if #self.hitted_friendly <= 5 then --这里是因为里面已经有一个caster了，所以是小于等于5
                        ability:OnArrived_lv20(unit:GetAbsOrigin())
                    end
                end
                unit:AddNewModifier(caster, ability, "modifier_Advanced_seahit_immune", {duration = 2})
                unit:AddNewModifier(caster, ability, "modifier_Advanced_seahit_lv10", {duration = 2})
                table.insert(self.hitted_friendly,unit)
            end
        end
    end
end

function modifier_Advanced_seahit_motion:OnDestroy() 
	local parent = self:GetParent()

	if IsServer() then
		FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), true)
		self.hitted = nil
		self.pos = nil
		self.speed = nil
		parent:SetForwardVector(Vector(parent:GetForwardVector()[1], parent:GetForwardVector()[2], 0))
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		parent:StartGesture(ACT_WAVEFORM_END)
		if self:GetAbility() then
			self:GetAbility():OnArrived(parent:GetAbsOrigin())
		end
	end
end

function modifier_Advanced_seahit_motion:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_Advanced_seahit_motion:Advanced_GetModifierIncomingDamage_Percentage(params)
	if not self:GetAbility() then return end
	return -self.incoming
end
----------------------
modifier_Advanced_seahit_fly = advanced_modifier({})

function modifier_Advanced_seahit_fly:IsDebuff()				return true end
function modifier_Advanced_seahit_fly:IsHidden() 			return true end
function modifier_Advanced_seahit_fly:IsPurgable() 			return false end
function modifier_Advanced_seahit_fly:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Advanced_seahit_fly:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Advanced_seahit_fly:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_Advanced_seahit_fly:OnRefresh(keys) self:OnCreated(keys) end
function modifier_Advanced_seahit_fly:IsMotionController() return true end
function modifier_Advanced_seahit_fly:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_Advanced_seahit_fly:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_seahit_fly:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.distance = (self.pos - self.parent:GetAbsOrigin()):Length2D()
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self.parent:GetName() ~= "npc_dota_thinker" then
				self:SafeDestroy()
			end
		end
	end
end
function modifier_Advanced_seahit_fly:OnIntervalThink()
	if not self:GetAbility() then self:SafeDestroy() return end
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 180
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self.parent:SetOrigin(next_pos)
end

function modifier_Advanced_seahit_fly:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		self.pos = nil
		self.distance = nil 
	end
end