--特效优化 √
Advanced_Dispersion = class({})

LinkLuaModifier("modifier_Advanced_Dispersion_passive", "skills/Advanced_Dispersion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Dispersion_release", "skills/Advanced_Dispersion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Dispersion_receive_point", "skills/Advanced_Dispersion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Dispersion_unlock3_effect", "skills/Advanced_Dispersion", LUA_MODIFIER_MOTION_NONE)


function Advanced_Dispersion:CheckKV(key)
	local table = {

		damage_reflection_pct = 0.5,


	}
	if self:GetUnlock(2)==2 then
		table.damage_reflection_pct = 0.7
	end

	local value = table[key] or -1
	return value

end

function Advanced_Dispersion:UnlockFirstCore(key)
	return true
end
function Advanced_Dispersion:UnlockSecondCore(key)
	return true
end
function Advanced_Dispersion:UnlockThirdCore(key)
	return true
end



function Advanced_Dispersion:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/dispersion/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/spectre/spectre_arcana/spectre_arcana_dispersion.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/dispersion/unlock2/spectre_arcana_dispersion_caster_distort.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/spectre/spectre_arcana/spectre_arcana_v2_dispersion.vpcf", context )

	
	
end


function Advanced_Dispersion:IsHiddenWhenStolen() 		return false end
function Advanced_Dispersion:IsRefreshable() 			return true end
function Advanced_Dispersion:IsStealable() 				return false end
function Advanced_Dispersion:IsNetherWardStealable()	return false end


function Advanced_Dispersion:GetIntrinsicModifierName() return "modifier_Advanced_Dispersion_passive" end


modifier_Advanced_Dispersion_passive = advanced_modifier({})

function modifier_Advanced_Dispersion_passive:IsDebuff()			return false end
function modifier_Advanced_Dispersion_passive:IsHidden() 			return true end
function modifier_Advanced_Dispersion_passive:IsPurgable() 		return false end
function modifier_Advanced_Dispersion_passive:IsPurgeException() 	return false end


function modifier_Advanced_Dispersion_passive:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_Advanced_Dispersion_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	local reduce = (0 - passive:GetSpecialValueFor("damage_reflection_pct"))
	if parent:PassivesDisabled() or parent:IsIllusion() then	
		return 0
	end
	if IsClient() then
		return reduce
	end
	local level = passive.advanced_level  --高阶等级

	local damage_taken = keys.damage - keys.damage%1
	--LV15解锁能量充盈
	if level>=15 and damage_taken<50 then
		damage_taken = 50
	end
	if damage_taken<=0 then
		return
	end
	--不反弹刃甲 刃甲2
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	--生命丢失不减免
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end
	--print("start dispersion  original_damage+++++++++++",keys.original_damage)
	if not keys.attacker:IsUnit() or not parent:IsAlive() or keys.attacker:IsBoss() then
		return reduce
	end
	--全反射
	local allReceiveChance = 20
	if passive.unlock1 then
		allReceiveChance = 60
	end
	if allReceiveChance>=RandomInt(1, 100) then 
		--LV5解锁全反射+
		if level>=5 then
			damage_taken = damage_taken *1.5
		end
		damage_taken = math.min(damage_taken,parent:GetMaxHealth())
		local modifier = parent:AddNewModifier(parent, passive, "modifier_Advanced_Dispersion_release", {stack =damage_taken})

		--LV20解锁能量破碎
		if level>=20 and keys.damage>=500 and 40>=RandomInt(1, 100) then
			modifier:ReliaseDamage(true)
		end

		

		
		return reduce 
	end
	damage_taken = damage_taken*-reduce*0.01
	damage_taken = math.min(damage_taken,parent:GetMaxHealth())
	damage_taken = damage_taken - damage_taken%1
	
	local modifier = parent:AddNewModifier(parent, passive, "modifier_Advanced_Dispersion_release", {stack =damage_taken})
	--LV20解锁能量破碎
	if level>=20 and keys.damage>=500 and 40>=RandomInt(1, 100) then
		modifier:ReliaseDamage(true)
	end
	
	return reduce
end







function modifier_Advanced_Dispersion_passive:AddStack(stack)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	parent:AddNewModifier(parent, passive, "modifier_Advanced_Dispersion_release", {stack =stack})
end


modifier_Advanced_Dispersion_release = class({})

function modifier_Advanced_Dispersion_release:IsDebuff()			return false end
function modifier_Advanced_Dispersion_release:IsHidden() 			return false end
function modifier_Advanced_Dispersion_release:IsPurgable() 			return false end
function modifier_Advanced_Dispersion_release:IsPurgeException() 	return false end
function modifier_Advanced_Dispersion_release:RemoveOnDeath() 		return false end

function modifier_Advanced_Dispersion_release:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Dispersion_release:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)

	end
end
function modifier_Advanced_Dispersion_release:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	if self:GetStackCount()<100 then
		return
	end
	--释放伤害
	local ability = self:GetAbility()
	local level = ability.advanced_level  --高阶等级
	if ability then
		self:ReliaseDamage(false)
		--莫比乌斯环不清空累计值
		local chance = 20
		--LV10解锁莫比乌斯环环+
		if level>=10 then
			chance = 30
		end
		if chance>=RandomInt(1, 100) then
			return
		end
		self:SetStackCount(0)
	end

end



function modifier_Advanced_Dispersion_release:ReliaseDamage(IsBreak)
	local ability = self:GetAbility()
	local level = ability.advanced_level  --高阶等级
	if ability  then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local max_radius = ability:GetSpecialValueFor("max_radius")
		local min_radius = ability:GetSpecialValueFor("min_radius")+5*level
		local pos = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			max_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		local damage = self:GetStackCount()
		local damageTable = {
			attacker = self:GetParent(),
			damage = self:GetStackCount(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		if ability.unlock1 then
			for i,enemy in pairs(enemies) do
				local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dispersion/unlock1/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(head_particle)

				damageTable.victim = enemy
				damageTable.damage = damage
				ApplyDamage(damageTable)

				if i>=3 then
					break
				end
			end
		elseif ability.unlock2 then
			for i,enemy in pairs(enemies) do
				local head_particle = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(head_particle)
				enemy:AddNewModifier(caster, ability, "modifier_Advanced_Dispersion_receive_point", {duration = 3})

				damageTable.victim = enemy
				damageTable.damage = damage
				ApplyDamage(damageTable)
	

				if i>=3 then
					break
				end
			end
		elseif ability.unlock3 then
			for i,enemy in pairs(enemies) do
				local head_particle = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_v2_dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(head_particle)
				enemy:AddNewModifier(caster, ability, "modifier_Advanced_Dispersion_unlock3_effect", {duration = RandomFloat(0.1, 0.5),stack = damage})
				self:ReliaseUnlock3(enemy,3,damage*0.8)
				if i>=4 then
					break
				end
			end
		else

			for i,enemy in pairs(enemies) do
				damageTable.victim = enemy
				local enemy_pos = enemy:GetAbsOrigin()
				local distance = math.min(max_radius, (caster:GetAbsOrigin() - enemy_pos):Length2D())
				damageTable.damage = damage
				if distance > min_radius then
					--damage_origin = damage_origin * (math.random(ability:GetSpecialValueFor("damage_reflection_min"),100)/100)
					local reduce_bonus = 1 - (distance - min_radius) * (100 - 5) / (max_radius - min_radius) /100
						
					damageTable.damage = math.min(damage * reduce_bonus, caster:GetAgility()*150)			
				end 
				ApplyDamage(damageTable)
				if i>=10 then
					break
				end
			end

		end

		if IsBreak then
			self:SetStackCount(self:GetStackCount()*0.7)
		end
		-- local modifier = caster:FindModifierByName("modifier_Advanced_Spectral_Dagger_unlock3")
		-- if modifier and GameRules:GetGameTime()>=modifier.timer then
		-- 	if 1==RandomInt(1, 2) then
		-- 		-- 重新随寻一次
		-- 		local enemies = FindUnitsInRadius(
		-- 			self:GetCaster():GetTeamNumber(),	-- int, your team number
		-- 			pos,	-- point, center point
		-- 			nil,	-- handle, cacheUnit. (not known)
		-- 			max_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		-- 			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		-- 			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		-- 			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		-- 			FIND_ANY_ORDER,	-- int, order filter
		-- 			false	-- bool, can grow cache
		-- 		)
		-- 		for index, value in ipairs(enemies) do
		-- 			modifier:GetAbility():CreateDagger(caster,value)
		-- 			modifier.timer = GameRules:GetGameTime()+1
		-- 			break
		-- 		end
			
		-- 	end
		-- end

		
	end
	
end




function modifier_Advanced_Dispersion_release:ReliaseUnlock3(target,count,damage)
	local ability = self:GetAbility()
	local max_radius = ability:GetSpecialValueFor("max_radius")
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		max_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		FIND_ANY_ORDER ,	-- int, order filter
		false	-- bool, can grow cache
	)
	for i,enemy in pairs(enemies) do
		local head_particle = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_v2_dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(head_particle)
		enemy:AddNewModifier(caster, ability, "modifier_Advanced_Dispersion_unlock3_effect", {duration = RandomFloat(0.1, 0.5),stack = damage})
		if count>0 then
			self:ReliaseUnlock3(enemy,count-1,damage*0.8)
		end
		if i>=count then
			break
		end
	end

end





modifier_Advanced_Dispersion_receive_point = class({})

function modifier_Advanced_Dispersion_receive_point:IsDebuff()			return true end
function modifier_Advanced_Dispersion_receive_point:IsHidden() 			return false end
function modifier_Advanced_Dispersion_receive_point:IsPurgable() 		return false end
function modifier_Advanced_Dispersion_receive_point:IsPurgeException() 	return false end
function modifier_Advanced_Dispersion_receive_point:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_Advanced_Dispersion_receive_point:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/dispersion/unlock2/spectre_arcana_dispersion_caster_distort.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, true, false )
	end
end



function modifier_Advanced_Dispersion_receive_point:GetModifierIncomingDamage_Percentage(keys)
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local passive = self:GetAbility()
	local damage_taken = keys.damage - keys.damage%1

	--能量充盈
	if damage_taken<50 then
		damage_taken = 50
	end

	if not IsServer() or caster:PassivesDisabled() or caster:IsIllusion() then	
		return
	end
	--不反弹刃甲 刃甲2
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	--生命丢失不减免
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end
	--print("start dispersion  original_damage+++++++++++",keys.original_damage)
	if not keys.attacker:IsUnit() or not caster:IsAlive() then
		return 0
	end

	damage_taken = damage_taken*0.3
	damage_taken = math.min(damage_taken,caster:GetMaxHealth())
	damage_taken = damage_taken - damage_taken%1
	
	caster:AddNewModifier(caster, passive, "modifier_Advanced_Dispersion_release", {stack =damage_taken})

	local head_particle = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(head_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(head_particle)

	return 0
end





modifier_Advanced_Dispersion_unlock3_effect = class({})

function modifier_Advanced_Dispersion_unlock3_effect:IsDebuff()			return true end
function modifier_Advanced_Dispersion_unlock3_effect:IsHidden() 			return false end
function modifier_Advanced_Dispersion_unlock3_effect:IsPurgable() 		return false end
function modifier_Advanced_Dispersion_unlock3_effect:IsPurgeException() 	return false  end
function modifier_Advanced_Dispersion_unlock3_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Dispersion_unlock3_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)

	end
end
function modifier_Advanced_Dispersion_unlock3_effect:OnDestroy()
	if IsServer() then
		local damageTable = {
			attacker = self:GetCaster(),
			victim = self:GetParent(),
			damage = self:GetStackCount(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)
	end
end