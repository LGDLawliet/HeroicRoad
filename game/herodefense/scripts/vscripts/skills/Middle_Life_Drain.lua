
Middle_Life_Drain = class({})

LinkLuaModifier("modifier_Middle_Life_Drain_enemy", "skills/Middle_Life_Drain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Life_Drain_enemy_sub", "skills/Middle_Life_Drain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Life_Drain_enemy_mark", "skills/Middle_Life_Drain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Life_Drain_friend", "skills/Middle_Life_Drain", LUA_MODIFIER_MOTION_NONE)

function Middle_Life_Drain:IsHiddenWhenStolen() 	return false end
function Middle_Life_Drain:IsRefreshable() 			return true end
function Middle_Life_Drain:IsStealable() 			return true end
function Middle_Life_Drain:IsNetherWardStealable()	return true end



function Middle_Life_Drain:CastFilterResultTarget(target)
	if target == self:GetCaster() or target:IsBuilding() or target:IsOther() or target:IsCourier() then
		return UF_FAIL_CUSTOM
	end
	-- if IsServer() then
	-- 	local buffs = self:GetCaster():FindAllModifiersByName("modifier_Middle_Life_Drain_enemy")
	-- 	for _, buff in pairs(buffs) do
	-- 		if target:entindex() == buff:GetStackCount() then
	-- 			return UF_FAIL_CUSTOM
	-- 		end
	-- 	end
	-- end
end

function Middle_Life_Drain:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end
function Middle_Life_Drain:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf", context )
end

function Middle_Life_Drain:OnSpellStart()
	local caster = self:GetCaster()
	self.caster = caster
	local target = self:GetCursorTarget()
	local target_ent = target:entindex()
	if IsEnemy(caster, target) then
		self.buff = caster:AddNewModifier(caster, self, "modifier_Middle_Life_Drain_enemy", {duration = self:GetChannelTime(),target = target_ent})
	else
		self.buff = caster:AddNewModifier(target, self, "modifier_Middle_Life_Drain_friend", {duration = self:GetChannelTime(),target = target_ent})
	end
	caster:EmitSound("Hero_Pugna.LifeDrain.Cast")
	target:EmitSound("Hero_Pugna.LifeDrain.Target")
	target:EmitSound("Hero_Pugna.LifeDrain.Loop")
	if not caster:HasModifier("modifier_Middle_Life_Drain_enemy") then
		caster:EmitSound("Hero_Pugna.LifeDrain.Loop")
	end
end

function Middle_Life_Drain:OnChannelFinish()

	if IsServer() then
		if self.buff and not self.buff:IsNull() then
			self.buff:SetDuration( 0, true )
			self.buff = nil
		end
		-- local buff = self.caster:FindModifierByName("modifier_Middle_Life_Drain_enemy")
		-- if buff then
		-- 	buff:SetDuration( 0, true )
		-- end
		-- local buff2 = self.caster:FindAllModifiersByName("modifier_Middle_Life_Drain_enemy_sub")
		-- -- local buff2 = self.caster:FindModifierByName("modifier_Middle_Life_Drain_enemy_sub")
		-- Timers:CreateTimer(FrameTime(), function()
		-- 	for _, modifier in pairs(buff2) do
		-- 		modifier:SetDuration( 0, true )
		-- 	end
		-- 		-- buff2:SetDuration( 0, true )
		-- 		return nil
		-- 	end
		-- )
		-- local buff3 = self.caster:FindModifierByName("modifier_Middle_Life_Drain_friend")
		-- if buff3 then
		-- 	buff3:SetDuration( 0, true )
		-- end
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
	end
end


modifier_Middle_Life_Drain_enemy = class({})

function modifier_Middle_Life_Drain_enemy:IsDebuff()			return false end
function modifier_Middle_Life_Drain_enemy:IsHidden() 			return true end
function modifier_Middle_Life_Drain_enemy:IsPurgable() 		return false end
function modifier_Middle_Life_Drain_enemy:IsPurgeException() 	return false end
function modifier_Middle_Life_Drain_enemy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Middle_Life_Drain_enemy:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		self.time = self:GetAbility():GetSpecialValueFor("proliferation_interval") / self:GetAbility():GetSpecialValueFor("tick_rate")
		self.Counter = 0
		self.target = EntIndexToHScript(keys.target)
		if not self.target or self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		local caster = self:GetAbility():GetCaster()
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_CENTER_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		-- local ent = keys.target
		-- if self:GetCaster() ~= self:GetAbility():GetCaster() then
		-- 	ent = self:GetCaster():entindex()
		-- end
		-- self:SetStackCount(ent)
	end
end

function modifier_Middle_Life_Drain_enemy:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self.target
	if not target or target:IsNull() then
		self:SafeDestroy()
		return
	end
	self.Counter = self.Counter + 1
	target:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Life_Drain_enemy_mark", {duration = self:GetAbility():GetSpecialValueFor("tick_rate")})
	if self.Counter>= self.time then
		self.Counter = 0
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("break_range"), DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)    
		-- print(#enemies)           
			   for _,target in pairs(enemies) do
					   if not target:IsMagicImmune()  and not target:HasModifier("modifier_Middle_Life_Drain_enemy_mark")  then        
						local target_ent = target:entindex()   
						caster:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Life_Drain_enemy_sub", {duration = math.min(self:GetRemainingTime(),5),target = target_ent})
						   break
					   end
			   end
	end
	local dis = math.max(self:GetAbility():GetSpecialValueFor("break_range") + self:GetCaster():GetCastRangeBonus(),100)
	if caster:IsSilenced() or IsHardDisabled(caster) or (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (dis) or not target:IsAlive() or target:IsOutOfGame() then
		self:SafeDestroy()
		return
	end
	-- if not caster:CanEntityBeSeenByMyTeam(target) then
	-- 	self:SafeDestroy()
	-- 	return
	-- end
	local ability = self:GetAbility()
	local dmg = (ability:GetSpecialValueFor("health_drain") + ability:GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / ability:GetSpecialValueFor("tick_rate"))

	local damageTable = {
						victim = target,
						attacker = caster,
						damage = dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)

	if caster:GetHealth() ~= caster:GetMaxHealth() then
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		HealWithGain(dmg_done,caster,caster,ability)
	else
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(1,0,0))
		caster:SetMana(math.min(caster:GetMaxMana(), caster:GetMana() + dmg_done*0.05))
	end
end

function modifier_Middle_Life_Drain_enemy:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.target = nil
		self.pfx = nil
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
		self:GetAbility():EndChannel(true)
	end
end



---------------------------------------------------------------------



modifier_Middle_Life_Drain_enemy_sub = class({})

function modifier_Middle_Life_Drain_enemy_sub:IsDebuff()			return false end
function modifier_Middle_Life_Drain_enemy_sub:IsHidden() 			return true end
function modifier_Middle_Life_Drain_enemy_sub:IsPurgable() 		return false end
function modifier_Middle_Life_Drain_enemy_sub:IsPurgeException() 	return false end
function modifier_Middle_Life_Drain_enemy_sub:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Middle_Life_Drain_enemy_sub:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		self.target = EntIndexToHScript(keys.target)
		if not self.target or self.target:IsNull() then
			self:SafeDestroy()
			return
		end
		local caster = self:GetAbility():GetCaster()
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		-- local ent = keys.target
		-- if self:GetCaster() ~= self:GetAbility():GetCaster() then
		-- 	ent = self:GetCaster():entindex()
		-- end
		-- self:SetStackCount(ent)
	end
end

function modifier_Middle_Life_Drain_enemy_sub:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self.target
	if not target or target:IsNull() then
		self:SafeDestroy()
		return
	end
	target:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Life_Drain_enemy_mark", {duration = self:GetAbility():GetSpecialValueFor("tick_rate")})
	local dis = math.max(self:GetAbility():GetSpecialValueFor("break_range") + self:GetCaster():GetCastRangeBonus(),100)
	if caster:IsSilenced() or IsHardDisabled(caster) or (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (dis) or not target:IsAlive() or target:IsOutOfGame() then
		self:SafeDestroy()
		return
	end
	if not caster:CanEntityBeSeenByMyTeam(target) then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	local dmg = (ability:GetSpecialValueFor("health_drain") + ability:GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / ability:GetSpecialValueFor("tick_rate"))
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)

	if caster:GetHealth() ~= caster:GetMaxHealth() then
		HealWithGain(dmg_done,caster,caster,ability)
	else

		caster:SetMana(math.min(caster:GetMaxMana(), caster:GetMana() + dmg_done*0.05))
	end
end

function modifier_Middle_Life_Drain_enemy_sub:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
		self.target = nil
		-- self.pfx = nil
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
		-- self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
	end
end


modifier_Middle_Life_Drain_enemy_mark = class({})

function modifier_Middle_Life_Drain_enemy_mark:IsDebuff()			    return false end
function modifier_Middle_Life_Drain_enemy_mark:IsHidden() 			return true end
function modifier_Middle_Life_Drain_enemy_mark:IsPurgable() 		    return false end
function modifier_Middle_Life_Drain_enemy_mark:IsPurgeException() 	return false end



--------------------------------------------------------------------

modifier_Middle_Life_Drain_friend = class({})

function modifier_Middle_Life_Drain_friend:IsDebuff()			return false end
function modifier_Middle_Life_Drain_friend:IsHidden() 			return true end
function modifier_Middle_Life_Drain_friend:IsPurgable() 		return false end
function modifier_Middle_Life_Drain_friend:IsPurgeException() 	return false end
function modifier_Middle_Life_Drain_friend:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Middle_Life_Drain_friend:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		self.target = EntIndexToHScript(keys.target)
		local caster = self:GetAbility():GetCaster()
		local pfx_name ="particles/units/heroes/hero_pugna/pugna_shard_life_drain.vpcf"
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		-- local ent = keys.target
		-- if self:GetCaster() ~= self:GetAbility():GetCaster() then
		-- 	ent = self:GetCaster():entindex()
		-- end
		-- self:SetStackCount(ent)
	end
end

function modifier_Middle_Life_Drain_friend:OnIntervalThink()
	local caster = self:GetAbility():GetCaster()
	local target = self.target
	local dis = math.max(self:GetAbility():GetSpecialValueFor("break_range") + self:GetCaster():GetCastRangeBonus(),100)
	if caster:IsSilenced() or IsHardDisabled(caster) or (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (dis) or not target:IsAlive() or target:IsOutOfGame() then
		self:SafeDestroy()
		return
	end
	if not caster:CanEntityBeSeenByMyTeam(target) then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	local dmg = (ability:GetSpecialValueFor("health_drain") + ability:GetSpecialValueFor("intelligence_index")*caster:GetIntellect(false))/ (1.0 / ability:GetSpecialValueFor("tick_rate"))

	dmg = dmg * 0.5
	local damageTable = {
		victim = caster,
		attacker = caster,
		damage = dmg,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
		ability = self:GetAbility(), --Optional.
		}
	ApplyDamage(damageTable)

	if target:GetHealth() ~= target:GetMaxHealth() then
		HealWithGain(dmg,caster,target,ability)
	else
		self:SafeDestroy()
		return
	end
end

function modifier_Middle_Life_Drain_friend:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
		self.target = nil
		-- self.pfx = nil
		self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Cast")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Target")
		self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
		-- self:GetCaster():StopSound("Hero_Pugna.LifeDrain.Loop")
		self:GetAbility():EndChannel(true)
	end
end

