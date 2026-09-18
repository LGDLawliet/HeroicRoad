LinkLuaModifier("modifier_chaotic_chronocube_thinker", "chaotic_spell/class_8/chaotic_chronocube", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_chronocube_buff", "chaotic_spell/class_8/chaotic_chronocube", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_chronocube_debuff", "chaotic_spell/class_8/chaotic_chronocube", LUA_MODIFIER_MOTION_NONE)





chaotic_chronocube = class({})

function chaotic_chronocube:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_chronocube.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_faceless_chronosphere.vpcf", context )



	
end


function chaotic_chronocube:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end
function chaotic_chronocube:CastFilterResultLocation( vLoc )
	vLoc = SnapToGrid( self:GetSpecialValueFor("width"), vLoc)
	if IsClient() then
		if self.custom_indicator then
			self.custom_indicator:Register( vLoc )
		end
	end
	if not IsServer() then return end

	if IsValid(self.modifier) then
		
		local result = self.modifier:CheckPos(vLoc)
		if result==1 then
			return UF_SUCCESS
		elseif result==2 then
			self.error = "DOTA_HUB_CANT_CAST_Same_Pos"
			return UF_FAIL_CUSTOM
		elseif result==3 then
			self.error = "DOTA_HUB_CANT_CAST_Un_Connection"
			return UF_FAIL_CUSTOM
		end
	end

	return UF_SUCCESS
end
function chaotic_chronocube:GetCustomCastErrorLocation( vLoc )
	return self.error
end

function chaotic_chronocube:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_sector_square.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleShouldCheckFoW(self.effect_cast,false)
		
	local radius = self:GetSpecialValueFor("width")
	ParticleManager:SetParticleControl( self.effect_cast, 6, Vector(radius,radius,0))
	ParticleManager:SetParticleControl( self.effect_cast, 61, Vector(49,0,106))

end


function chaotic_chronocube:UpdateCustomIndicator( loc )
	-- local caster = self:GetCaster()
	-- loc = loc or caster:GetAbsOrigin()
	-- local pos = SnapToGrid( self:GetSpecialValueFor("width"), loc)
	ParticleManager:SetParticleControl( self.effect_cast, 0,loc)
end
function chaotic_chronocube:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, true ) 
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end




function chaotic_chronocube:GetAOERadius()
	return 100
end

-- 
function chaotic_chronocube:GetBehavior()
	if self:GetCaster():HasModifier("modifier_chaotic_chronocube_buff") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE  + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT
	end
	return self.BaseClass.GetBehavior(self)
end






function chaotic_chronocube:GetManaCost(iLevel)
	if self:GetCaster():HasModifier("modifier_chaotic_chronocube_buff") then
		return 0
	end
	return self.BaseClass.GetManaCost(self,iLevel)
end


function chaotic_chronocube:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_chaotic_chronocube_buff") then
		return 0
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function chaotic_chronocube:Spawn()
	self.dataRecordList = {}
end

function chaotic_chronocube:OnSpellStart()
	local caster = self:GetCaster()
	local pos = SnapToGrid( self:GetSpecialValueFor("width"), self:GetCursorPosition())


	-- CreateModifierThinker(caster, self, "modifier_chaotic_chronocube_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)



	-- SnapToGrid(radius, self:GetCursorPosition())


	if not IsValid(self.modifier) then
		local cooldown_record = self:GetCooldownTimeRemaining()
		self:EndCooldown()
		self.modifier = caster:AddNewModifier(caster, self, "modifier_chaotic_chronocube_buff", {duration =self:GetSpecialValueFor("time_require"),cooldown_record=cooldown_record})
	end

	if IsValid(self.modifier) then
		
		self.modifier:InitPos(pos)

		local count = self.modifier:GetStackCount()
		if count<=0 then
			self.modifier:SafeDestroy()
		end

	end




end





modifier_chaotic_chronocube_buff = advanced_modifier({})

function modifier_chaotic_chronocube_buff:IsHidden() return false end
function modifier_chaotic_chronocube_buff:IsPurgable() return false end
function modifier_chaotic_chronocube_buff:IsDebuff() return false end
function modifier_chaotic_chronocube_buff:OnCreated(keys)
	-- self.sunbeam_bonus_day_vison = self:GetAbility():GetSpecialValueFor("sunbeam_bonus_day_vison")
	if IsServer() then
		local count = self:GetAbility():GetSpecialValueFor("count")
		if self:GetAbility():GetRuneType()==1 then
			count = count + self:GetAbility():GetSpecialValueFor("rune_1_bonus")
		end
		self:SetStackCount(count)
		self.posRecord = {}
		self.cooldown_record = keys.cooldown_record
		-- self:PlayEffect(self:GetParent())
	end
end
function modifier_chaotic_chronocube_buff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end

		self:InitEffect()
		local stack =self:GetStackCount()
		if stack>=1 then
			local ability = self:GetAbility()
			local cooldown_reduction = math.min(ability:GetSpecialValueFor("cooldown_reduction")*stack,ability:GetSpecialValueFor("cooldown_reduction_max"))*0.01
			self.cooldown_record = self.cooldown_record *(1-cooldown_reduction)
		end
		ability:StartCooldown(self.cooldown_record)

		-- ParticleManager:DestroyParticle(self.effect_cast1,false)
	end
end
function modifier_chaotic_chronocube_buff:InitPos(location)
	local particle_cast = "particles/ui_mouseactions/custom_sector_square.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,nil )
	ParticleManager:SetParticleShouldCheckFoW(effect_cast,false)
		
	local radius = self:GetAbility():GetSpecialValueFor("width")
	ParticleManager:SetParticleControl( effect_cast, 0, location)
	ParticleManager:SetParticleControl( effect_cast, 6, Vector(radius,radius,0))
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(49,0,106))
	if not self.firstZ then
		self.firstZ = location.z
	end
	local data = {
		particleID = effect_cast,
		pos = location
	}
	data.pos.z = self.firstZ
	table.insert(self.posRecord,data)
	self:DecrementStackCount()
end

function modifier_chaotic_chronocube_buff:InitEffect()
	for _, data in ipairs(self.posRecord) do
		ParticleManager:DestroyParticle(data.particleID,true)
	end

	-- local particleName = "particles/units/heroes/hero_faceless_void/faceless_void_chronocube.vpcf"
	-- local radius = self:GetAbility():GetSpecialValueFor("width")
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local duration = ability:GetSpecialValueFor("duration")

	caster:EmitSound("Hero_FacelessVoid.Chronosphere.MaceOfAeons")
	local radius =  ability:GetSpecialValueFor("width")
	for _, data in ipairs(self.posRecord) do
		local pos = data.pos
		CreateModifierThinker(caster, ability, "modifier_chaotic_chronocube_thinker", {duration = duration,radius= radius}, pos, caster:GetTeamNumber(), false)

		-- local effect_cast = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN,nil )
	
		
		-- ParticleManager:SetParticleControl( effect_cast, 0, pos)
		-- ParticleManager:SetParticleControl( effect_cast, 4, Vector(radius,radius,0))
		-- DestroyParticleByDelay(effect_cast,1.5)
		-- EmitSoundOnLocationWithCaster(pos, "Hero_AbyssalUnderlord.Firestorm", caster)
		-- local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius*2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		-- for _, unit in ipairs(enemies) do
		-- 	if not unitList[unit] and self:IsUnitInsideBlock(unit, pos, radius) then
		-- 		unitList[unit] = true
		-- 	end
		-- end
	end


	
end


function modifier_chaotic_chronocube_buff:IsUnitInsideBlock(unit, blockPosition, blockSize)
    local unitPosition = unit:GetAbsOrigin()
    local xMin = blockPosition.x - blockSize
    local xMax = blockPosition.x + blockSize
    local yMin = blockPosition.y - blockSize
    local yMax = blockPosition.y + blockSize

    if unitPosition.x >= xMin and unitPosition.x <= xMax and unitPosition.y >= yMin and unitPosition.y <= yMax then
        -- 单位在方块内
        return true
    else
        -- 单位不在方块内
        return false
    end
end


function modifier_chaotic_chronocube_buff:CheckPos(vLoc)
    local radius = self:GetAbility():GetSpecialValueFor("width")

	-- print("---------------")
	-- 检测两遍 先检测有没有相同坐标 再检测相邻
    for _, data in pairs(self.posRecord) do
        local distance = (vLoc - data.pos):Length2D()
		if distance<=10 then
			return 2
		end
        
    end
	for _, data in pairs(self.posRecord) do
        local distance = (vLoc - data.pos):Length2D()
        if distance < (radius*2+10) then
            -- 传入的坐标与某个记录的坐标相连
            return 1
        end
    end


    -- 传入的坐标与任何记录的坐标都不相连
    return 3

end









modifier_chaotic_chronocube_thinker = class({})

function modifier_chaotic_chronocube_thinker:OnCreated(keys)
	if IsServer() then

		self.radius = keys.radius
		local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronocube.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end

function modifier_chaotic_chronocube_thinker:IsAura() return self:GetAbility() and true end
function modifier_chaotic_chronocube_thinker:GetAuraDuration() return 0.1 end
function modifier_chaotic_chronocube_thinker:GetModifierAura() return "modifier_chaotic_chronocube_debuff" end
function modifier_chaotic_chronocube_thinker:GetAuraRadius() return self.radius*2 end
function modifier_chaotic_chronocube_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_chaotic_chronocube_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_chaotic_chronocube_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_chronocube_thinker:GetAuraEntityReject(unit)
	local parent = self:GetParent()
	-- local unitList = {}
	-- local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius*2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- for _, unit in ipairs(enemies) do
	-- 	if not unitList[unit] and self:IsUnitInsideBlock(unit, parent:GetAbsOrigin(), self.radius) then
	-- 		unitList[unit] = true
	-- 	end
	-- end
	
	-- local caster = self:GetCaster()
	-- local ability = self:GetAbility()
	-- for unit, value in pairs(unitList) do
	-- 	unit:AddNewModifier(caster, ability, "modifier_chaotic_chronocube_debuff", {duration =0.06})
	-- end
	if self:IsUnitInsideBlock(unit, parent:GetAbsOrigin(), self.radius) then
		return false
	end

	return true
end

function modifier_chaotic_chronocube_thinker:OnDestroy(  )

    UTIL_Remove(self:GetParent())
end

function modifier_chaotic_chronocube_thinker:IsUnitInsideBlock(unit, blockPosition, blockSize)
    local unitPosition = unit:GetAbsOrigin()
    local xMin = blockPosition.x - blockSize
    local xMax = blockPosition.x + blockSize
    local yMin = blockPosition.y - blockSize
    local yMax = blockPosition.y + blockSize

    if unitPosition.x >= xMin and unitPosition.x <= xMax and unitPosition.y >= yMin and unitPosition.y <= yMax then
        -- 单位在方块内
        return true
    else
        -- 单位不在方块内
        return false
    end
end





modifier_chaotic_chronocube_debuff = class({})

function modifier_chaotic_chronocube_debuff:OnCreated()
	if IsServer() and self:IsMotionController() then
		self:GetParent():InterruptMotionControllers(false)
		self.abs = self:GetParent():GetAbsOrigin()

		-- self:StartIntervalThink(FrameTime())
	end
end

function modifier_chaotic_chronocube_debuff:OnIntervalThink()

	self:GetParent():InterruptMotionControllers(false)
	-- self:GetParent():SetOrigin(self.abs)
end

function modifier_chaotic_chronocube_debuff:OnDestroy()
	if IsServer()  then
		if self:IsMotionController() then
			FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*caster:HDGetPrimaryStatValue()
		if ability:GetRuneType()==2 then
			damage = damage * (1+ability:GetSpecialValueFor( "rune_2_bonus" )*0.01)
		end
		local damageTable = {
			victim = self:GetParent(),
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
		}
		ApplyDamage(damageTable)
	end
end

function modifier_chaotic_chronocube_debuff:IsHidden() 			return false end
function modifier_chaotic_chronocube_debuff:IsPurgable() 			return false end
function modifier_chaotic_chronocube_debuff:IsPurgeException() 	return false end
function modifier_chaotic_chronocube_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_chaotic_chronocube_debuff:IsDebuff() return true end
function modifier_chaotic_chronocube_debuff:IsStunDebuff()	return true end
function modifier_chaotic_chronocube_debuff:IsMotionController() return true end
function modifier_chaotic_chronocube_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_chaotic_chronocube_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_chaotic_chronocube_debuff:StatusEffectPriority() return 16 end
function modifier_chaotic_chronocube_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true, 
		[MODIFIER_STATE_INVISIBLE] = false, 
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	if self:GetAbility():GetRuneType()==2 then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
	end
	return state
end
