

Middle_Bristle_Back = class({})

LinkLuaModifier("modifier_Middle_Bristle_Back_passive", "skills/Middle_Bristle_Back", LUA_MODIFIER_MOTION_NONE)


function Middle_Bristle_Back:IsHiddenWhenStolen() 		return false end
function Middle_Bristle_Back:IsRefreshable() 			return true end
function Middle_Bristle_Back:IsStealable() 			return false end
function Middle_Bristle_Back:IsNetherWardStealable()	return false end
function Middle_Bristle_Back:GetIntrinsicModifierName() return "modifier_Middle_Bristle_Back_passive" end



modifier_Middle_Bristle_Back_passive = advanced_modifier({})

function modifier_Middle_Bristle_Back_passive:IsDebuff()			return false end
function modifier_Middle_Bristle_Back_passive:IsHidden() 			return true end
function modifier_Middle_Bristle_Back_passive:IsPurgable() 		return false end
function modifier_Middle_Bristle_Back_passive:IsPurgeException() 	return false end
function modifier_Middle_Bristle_Back_passive:RemoveOnDeath()  return false end
function modifier_Middle_Bristle_Back_passive:OnCreated()
	if IsFountain then
		self:StartIntervalThink(1)
	end
end



function modifier_Middle_Bristle_Back_passive:OnIntervalThink()
	local release = 0.05 *self:GetCaster():GetMaxHealth()
	if self:GetStackCount()>=release  then
		local gain = self:GetStackCount()/release 
		self:SetStackCount(0)
		self:start(gain)
	end
end

function modifier_Middle_Bristle_Back_passive:start(gain)
	if IsClient() then
		return
	end
	local caster = self:GetCaster()
	local damage = self:GetAbility():GetSpecialValueFor("damage_index")*caster:GetStrength()*gain
	EmitSoundOn("Hero_Bristleback.QuillSpray.Cast", caster)
	local pfx_name = "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf"
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback") then
		pfx_name = "particles/econ/items/bristleback/bristle_spikey_spray/bristle_spikey_quill_spray.vpcf"
		damage = damage *1.3
	end

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT, caster)
	-- ParticleManager:SetParticleControl(pfx, 60, Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
	-- ParticleManager:SetParticleControl(pfx, 61, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500,
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	  local i = self:GetAbility():GetSpecialValueFor("effect_number")
	  local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
	}
	ApplyDamage(damageTable) 
	for _,enemy in pairs(enemies) do
		i=i-1
		damageTable.victim = enemy
		ApplyDamage(damageTable) 
		if i<1 then
			break
		end
	end
end


function modifier_Middle_Bristle_Back_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	if parent:PassivesDisabled() then
		return 0
	end

	if IsClient() then
		if  parent:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback_2") then
			return  (0 - passive:GetSpecialValueFor("back_damage_reduction"))
		end
		return 0
	end
	if not  keys.attacker then
		return 0
	end
	if  keys.attacker:IsBuilding() or parent:IsIllusion() then
		return
	end
	-- print("back damage ="..keys.damage)
	local cast_angle = VectorToAngles(parent:GetForwardVector() * -1)
	local angle = VectorToAngles((keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
	local degree = math.abs(AngleDiff(cast_angle[2], angle[2]))
	local min_degree = passive:GetSpecialValueFor("side_angle")/2
	if parent:HasModifier("modifier_heroTalent_npc_dota_hero_bristleback_2") then
		degree = 0
	end
	if degree <= min_degree then
		local reduce = 0
		parent:EmitSound("Hero_Bristleback.Bristleback")
		if degree > passive:GetSpecialValueFor("back_angle")/2 then  --如果大于后背的角度进行边减免
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_side_dmg.vpcf", PATTACH_CUSTOMORIGIN, parent)
			ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)
			local stack = math.min( keys.damage * (passive:GetSpecialValueFor("side_damage_reduction") / 100),parent:GetMaxHealth())
			self:SetStackCount(self:GetStackCount() + stack)
			reduce = (0 - passive:GetSpecialValueFor("side_damage_reduction"))
		else    --如果是后背角度进行背减免
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_CUSTOMORIGIN, parent)
			ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)
			local stack = math.min( keys.damage * (passive:GetSpecialValueFor("back_damage_reduction") / 100),parent:GetMaxHealth())
			self:SetStackCount(self:GetStackCount() + stack)
			reduce = (0 - passive:GetSpecialValueFor("back_damage_reduction"))
		end
		return reduce
	end
end



function modifier_Middle_Bristle_Back_passive:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




