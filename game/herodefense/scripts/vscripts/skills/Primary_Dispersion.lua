---------------------------------------------------------------------
----------------------- Spectre Dispersion --------------------------
---------------------------------------------------------------------

Primary_Dispersion = class({})

LinkLuaModifier("modifier_Primary_Dispersion_passive", "skills/Primary_Dispersion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Dispersion_release", "skills/Primary_Dispersion", LUA_MODIFIER_MOTION_NONE)



function Primary_Dispersion:IsHiddenWhenStolen() 		return false end
function Primary_Dispersion:IsRefreshable() 			return true end
function Primary_Dispersion:IsStealable() 				return false end
function Primary_Dispersion:IsNetherWardStealable()	return false end


function Primary_Dispersion:GetIntrinsicModifierName() return "modifier_Primary_Dispersion_passive" end


modifier_Primary_Dispersion_passive = advanced_modifier({})

function modifier_Primary_Dispersion_passive:IsDebuff()			return false end
function modifier_Primary_Dispersion_passive:IsHidden() 			return true end
function modifier_Primary_Dispersion_passive:IsPurgable() 		return false end
function modifier_Primary_Dispersion_passive:IsPurgeException() 	return false end

function modifier_Primary_Dispersion_passive:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_Primary_Dispersion_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	local reduce = (0 - passive:GetSpecialValueFor("damage_reflection_pct"))
	if parent:PassivesDisabled() or parent:IsIllusion() then	
		return 0
	end
	if IsClient() then
		return reduce
	end
	local damage_taken = keys.damage - keys.damage%1
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end
	if not keys.attacker:IsUnit() or not parent:IsAlive() or keys.attacker:IsBoss() then
		return reduce
	end
	damage_taken = damage_taken*-reduce*0.01
	damage_taken = math.min(damage_taken,parent:GetMaxHealth())
	damage_taken = damage_taken - damage_taken%1
	self:AddStack(damage_taken)
	return reduce
end




function modifier_Primary_Dispersion_passive:AddStack(stack)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	parent:AddNewModifier(parent, passive, "modifier_Primary_Dispersion_release", {stack =stack})
end

modifier_Primary_Dispersion_release = class({})

function modifier_Primary_Dispersion_release:IsDebuff()			return false end
function modifier_Primary_Dispersion_release:IsHidden() 			return false end
function modifier_Primary_Dispersion_release:IsPurgable() 			return false end
function modifier_Primary_Dispersion_release:IsPurgeException() 	return false end
function modifier_Primary_Dispersion_release:RemoveOnDeath() 		return false end

function modifier_Primary_Dispersion_release:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(1)
	end
end
function modifier_Primary_Dispersion_release:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)

	end
end
function modifier_Primary_Dispersion_release:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	if self:GetStackCount()<100 then
		return
	end
	local ability = self:GetParent():FindAbilityByName("Primary_Dispersion")
	if ability and ability:GetLevel() > 0 then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local max_radius = ability:GetSpecialValueFor("max_radius")
		local min_radius = ability:GetSpecialValueFor("min_radius")
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



		self:SetStackCount(0)
	end
	-- if self:GetStackCount() <= 0 then
	-- 	self:SafeDestroy()
	-- end
end
