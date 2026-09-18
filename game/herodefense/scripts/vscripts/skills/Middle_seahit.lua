LinkLuaModifier( "modifier_Middle_seahit_motion", "skills/Middle_seahit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_seahit_fly", "skills/Middle_seahit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_seahit_buff", "skills/Middle_seahit.lua", LUA_MODIFIER_MOTION_NONE )

Middle_seahit = class({})

function Middle_seahit:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Middle_seahit:GetCastRange(location , target)
	if IsServer() then return 30000 end	
	if IsClient() then
		return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()	
	end
end

function Middle_seahit:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", context )
end

function Middle_seahit:OnArrived(pos)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster:IsAlive() then return end
	if not pos then return end

	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage") + caster:GetAverageTrueAttackDamage(nil)*self:GetSpecialValueFor("bonus_damage")
	if caster:HasModifier("modifier_Primary_enchant_totem") or caster:HasModifier("modifier_Middle_enchant_totem") or caster:HasModifier("modifier_Advanced_enchant_totem") then
        damage = damage*0.27
    end
    local buffed = caster:FindModifierByName("modifier_Middle_seahit_buff")
    if buffed then
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
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			if enemy:IsAlive() then
				enemy:AddNewModifier(caster, self, "modifier_Middle_seahit_fly", {duration = 0.5})
            else
                -- 中阶：每个击杀回复cd，击杀buff添加
                if not self:IsCooldownReady() then
					local newcooldown = self:GetCooldownTimeRemaining() - self:GetSpecialValueFor("cd")
                    self:EndCooldown()
                    self:StartCooldown(newcooldown)
                end

                local buff = caster:FindModifierByName("modifier_Middle_seahit_buff")
                if not buff then
                    caster:AddNewModifier(caster, self, "modifier_Middle_seahit_buff", {})
                end
            end
		end
	end
end

function Middle_seahit:OnSpellStart()
	local caster = self:GetCaster()
	-- 冲锋的部分
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local direction = (target_pos - caster_pos):Normalized()
	direction.z = 0.0
	local range = self.BaseClass.GetCastRange(self,caster_pos,caster) + self:GetCaster():GetCastRangeBonus()
	local speed = 2250

	local pos = ((target_pos - caster_pos):Length2D() <= range) and target_pos or (caster_pos + direction * range)
	local duration = (caster_pos - pos):Length2D() / speed
	caster:AddNewModifier(caster, self, "modifier_Middle_seahit_motion", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	caster:EmitSound("Hero_Morphling.Waveform")
	ProjectileManager:ProjectileDodge(caster)
end

---------------------------------------------------------------------
modifier_Middle_seahit_buff = advanced_modifier({})

function modifier_Middle_seahit_buff:IsDebuff()			return false end
function modifier_Middle_seahit_buff:IsHidden() 			return false end
function modifier_Middle_seahit_buff:IsPurgable() 		return false end
function modifier_Middle_seahit_buff:IsPurgeException() 	return false end
---------------------------------------------------------------------
modifier_Middle_seahit_motion = advanced_modifier({})

function modifier_Middle_seahit_motion:IsDebuff()			return false end
function modifier_Middle_seahit_motion:IsHidden() 			return true end
function modifier_Middle_seahit_motion:IsPurgable() 		return false end
function modifier_Middle_seahit_motion:IsPurgeException() 	return false end
function modifier_Middle_seahit_motion:IsStunDebuff()		return true end
--状态
function modifier_Middle_seahit_motion:CheckState() 
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

function modifier_Middle_seahit_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_Middle_seahit_motion:GetModifierDisableTurning() return 1 end
function modifier_Middle_seahit_motion:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_1 end
function modifier_Middle_seahit_motion:IsMotionController() return true end
function modifier_Middle_seahit_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_Middle_seahit_motion:OnCreated(keys)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	self.freezing = ability:GetSpecialValueFor("freezing")
	self.incoming = ability:GetSpecialValueFor("incoming")
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

function modifier_Middle_seahit_motion:OnIntervalThink()
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
	-- local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(),nil, width,DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
	-- table.insert(self.hitted_friendly, caster)
	-- for _, unit in pairs(units) do
	-- 	if not IsInTable(unit, self.hitted_friendly) then
	-- 		unit:AddNewModifier(caster, ability, "modifier_Middle_seahit_Upgrade", {duration=self.wave_duration*gain})
	-- 		table.insert(self.hitted_friendly,unit)
	-- 	end
	-- end
end

function modifier_Middle_seahit_motion:OnDestroy() 
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

function modifier_Middle_seahit_motion:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_Middle_seahit_motion:Advanced_GetModifierIncomingDamage_Percentage(params)
	if not self:GetAbility() then return end
	return -self.incoming
end
----------------------
modifier_Middle_seahit_fly = advanced_modifier({})

function modifier_Middle_seahit_fly:IsDebuff()				return true end
function modifier_Middle_seahit_fly:IsHidden() 			return true end
function modifier_Middle_seahit_fly:IsPurgable() 			return false end
function modifier_Middle_seahit_fly:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_Middle_seahit_fly:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_Middle_seahit_fly:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_Middle_seahit_fly:OnRefresh(keys) self:OnCreated(keys) end
function modifier_Middle_seahit_fly:IsMotionController() return true end
function modifier_Middle_seahit_fly:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_Middle_seahit_fly:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Middle_seahit_fly:OnCreated(keys)
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
function modifier_Middle_seahit_fly:OnIntervalThink()
	if not self:GetAbility() then self:SafeDestroy() return end
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = 150
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self.parent:SetOrigin(next_pos)
end

function modifier_Middle_seahit_fly:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		self.pos = nil
		self.distance = nil 
	end
end