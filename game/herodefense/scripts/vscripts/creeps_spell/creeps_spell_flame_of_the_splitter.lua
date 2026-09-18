
creeps_spell_flame_of_the_splitter = class({})
LinkLuaModifier("modifier_creeps_spell_flame_of_the_splitter", "creeps_spell/creeps_spell_flame_of_the_splitter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_flame_of_the_splitter_debuff", "creeps_spell/creeps_spell_flame_of_the_splitter", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_creeps_spell_flame_of_the_splitter_death", "creeps_spell/creeps_spell_flame_of_the_splitter", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_flame_of_the_splitter:GetIntrinsicModifierName()
	return "modifier_creeps_spell_flame_of_the_splitter"
end
function creeps_spell_flame_of_the_splitter:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_flame_of_the_splitter/ambient/effect_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_flame_of_the_splitter/hit_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_flame_of_the_splitter/flame_laungh/effect.vpcf", context )


end






-- Fury Swipes modifier buff
modifier_creeps_spell_flame_of_the_splitter = advanced_modifier({})
function modifier_creeps_spell_flame_of_the_splitter:IsDebuff()return false end
function modifier_creeps_spell_flame_of_the_splitter:IsHidden()return true end
function modifier_creeps_spell_flame_of_the_splitter:IsPurgable() return false end
function modifier_creeps_spell_flame_of_the_splitter:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
	}
end

-- 分裂者的烈焰：中阶火元素死亡时将死亡之火附着到击杀者身上，并在状态创建5秒后爆炸，造成火元素全额攻击力*1的物理伤害。
-- 可以叠加，每次叠加不会刷新倒计时，但会使伤害变为目前的1.5倍。
-- 如果被附着火焰的人使+用’急行’，可以将火焰甩开并掉落到出发点1000范围内最近的友军身上（但如果没有其他友军则甩不开）。


function modifier_creeps_spell_flame_of_the_splitter:OnDeath(keys)
	if IsServer() then
		local target = keys.attacker
		if not target then
			return
		end
		local modifier = target:FindModifierByName("modifier_creeps_spell_flame_of_the_splitter_debuff")
		if modifier then
			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_creeps_spell_flame_of_the_splitter_debuff", {duration = modifier:GetRemainingTime()})
		else
			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_creeps_spell_flame_of_the_splitter_debuff", {duration =  self:GetAbility():GetSpecialValueFor("duration")})
		end
		
	end
end





modifier_creeps_spell_flame_of_the_splitter_debuff = advanced_modifier({})
function modifier_creeps_spell_flame_of_the_splitter_debuff:IsDebuff()return true end
function modifier_creeps_spell_flame_of_the_splitter_debuff:IsHidden()return false end
function modifier_creeps_spell_flame_of_the_splitter_debuff:IsPurgable() return false end
function modifier_creeps_spell_flame_of_the_splitter_debuff:OnCreated(keys)
	self.damage_index = self:GetAbility():GetSpecialValueFor("damage_index")
	self.damage_mul = self:GetAbility():GetSpecialValueFor("damage_mul")

	if IsServer() then
		self.damage_type = self:GetAbility():GetAbilityDamageType()
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self:IncrementStackCount()
		if keys.stack then
			self:SetStackCount(keys.stack)
		end
		local parent = self:GetParent()
		parent:EmitSound("fire_ball.hit")
		self.damage = self:GetCaster():GetAverageTrueAttackDamage(nil)
		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/creeps_spell_flame_of_the_splitter/ambient/effect_explosion.vpcf", PATTACH_POINT_FOLLOW,parent)
		ParticleManager:SetParticleControlEnt(self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle,2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 60, Vector(self:GetStackCount()*30,0,0))
		self:AddParticle(self.particle, true, false, -1, true, false)
		self:StartIntervalThink(self:GetRemainingTime()-FrameTime())
	end

	local stack = self:GetStackCount()-1
	if stack>=1 then
		for i = 1, stack, 1 do
			self.damage_index = self.damage_index * self.damage_mul
		end
	end

end

function modifier_creeps_spell_flame_of_the_splitter_debuff:OnRefresh(keys)
	
	if IsServer() then
		self:GetParent():EmitSound("fire_ball.hit")
		self:IncrementStackCount()
		ParticleManager:SetParticleControl(self.particle, 60, Vector(self:GetStackCount()*30,0,0))
	end
	self.damage_index = self.damage_index * self.damage_mul
end

function modifier_creeps_spell_flame_of_the_splitter_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if caster and ability then
		local damageTable = {
			victim = parent,
			attacker = self:GetCaster(),
			damage = caster:GetAverageTrueAttackDamage(nil)*self.damage_index,
			damage_type = self.damage_type ,
			ability = ability, --Optional.
		}
		ApplyDamage(damageTable)
	else
		local damageTable = {
			victim = self:GetParent(),
			attacker =nil,
			damage = self.damage_mul*self.damage_index,
			damage_type = self.damage_type ,
			ability = nil, --Optional.
		}
		ApplyDamage(damageTable)
	end

	self:GetParent():EmitSound("fire_ball.explosion")

	local particle = ParticleManager:CreateParticle("particles/rebuild/spell/creeps_spell_flame_of_the_splitter/hit_effect/effect.vpcf", PATTACH_POINT_FOLLOW,parent)
	ParticleManager:SetParticleControl(particle, 0,  parent:GetAbsOrigin())
	DestroyParticleByDelay(particle,4)
end


function modifier_creeps_spell_flame_of_the_splitter_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_creeps_spell_flame_of_the_splitter_debuff:OnTooltip()
    return self.damage_index
end

function modifier_creeps_spell_flame_of_the_splitter_debuff:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE = {self:GetParent(), nil},
	}
end


function modifier_creeps_spell_flame_of_the_splitter_debuff:OnCastDefaultMove(keys)

	local parent = self:GetParent()
	if keys.caster == parent then
		local ability = self:GetAbility()
		local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius , 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if unit~=parent then
				local modifier = unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_creeps_spell_flame_of_the_splitter_debuff", {duration = self:GetRemainingTime(),stack = self:GetStackCount()})
				if modifier then
					parent:EmitSound("fire_ball.laungh")

					local particle = ParticleManager:CreateParticle("particles/rebuild/spell/creeps_spell_flame_of_the_splitter/flame_laungh/effect.vpcf", PATTACH_POINT_FOLLOW,parent)
					ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
					DestroyParticleByDelay(particle,3)
					self:Destroy()
					break
				end
			end
		end
	end


	-- self:GetParent():EmitSound("fire_ball.explosion")
end