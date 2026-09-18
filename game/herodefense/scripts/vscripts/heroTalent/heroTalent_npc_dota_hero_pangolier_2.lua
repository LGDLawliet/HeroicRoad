
heroTalent_npc_dota_hero_pangolier_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_2_check", "heroTalent/heroTalent_npc_dota_hero_pangolier_2", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage", "heroTalent/heroTalent_npc_dota_hero_pangolier_2", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_2_order", "heroTalent/heroTalent_npc_dota_hero_pangolier_2", LUA_MODIFIER_MOTION_NONE) 
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_2_roll_cd", "heroTalent/heroTalent_npc_dota_hero_pangolier_2", LUA_MODIFIER_MOTION_NONE) 

function heroTalent_npc_dota_hero_pangolier_2:GetAbilityTextureName() return "pangolier_gyroshell" end
function heroTalent_npc_dota_hero_pangolier_2:IsHiddenWhenStolen() return false end
function heroTalent_npc_dota_hero_pangolier_2:IsStealable() return true end
function heroTalent_npc_dota_hero_pangolier_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_pangolier_2_order"
end



modifier_heroTalent_npc_dota_hero_pangolier_2_order = class({})

function modifier_heroTalent_npc_dota_hero_pangolier_2_order:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_pangolier_2_order:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_order:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_order:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_order:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_order:SpellToTarget()
	if IsServer() then
		local caster = self:GetCaster()
		local loop_sound = "Hero_Pangolier.Gyroshell.Loop" 
		caster:Purge(false, true, false, false, false)
		EmitSoundOn(loop_sound, caster)	
		local ability = caster:FindAbilityByName("aghsfort_pangolier_gyroshell")
		local hAbility
		if not ability then
			hAbility = caster:AddAbility( "aghsfort_pangolier_gyroshell" )
			hAbility:UpgradeAbility( true )
		else
			hAbility = ability
		end
		
		if hAbility ~= nil then
			-- PlayerResource:SetCameraTarget( caster:GetPlayerOwnerID(), caster )
			-- PlayerResource:SetOverrideSelectionEntity( caster:GetPlayerOwnerID(), caster )
			local vDir = caster:GetForwardVector()
			local vTargetPos = caster:GetAbsOrigin() + vDir
			local kv = {}
			kv[ "duration" ] = -1
			kv[ "vTargetX" ] = vTargetPos.x
			kv[ "vTargetY" ] = vTargetPos.y
			kv[ "vTargetZ" ] = vTargetPos.z
			caster:AddNewModifier( caster, hAbility, "modifier_pangolier_gyroshell", kv )
			caster:AddNewModifier( caster, hAbility, "modifier_heroTalent_npc_dota_hero_pangolier_2_check", {duration = 10} )
			local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf"

			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleControl( effect_cast, 1, caster:GetOrigin() )
			ParticleManager:SetParticleControl( effect_cast, 1, Vector(200,0,0) )
			ParticleManager:ReleaseParticleIndex( effect_cast )

		else
			print( "Start - Can't find ability" )
		end
	end

end



function modifier_heroTalent_npc_dota_hero_pangolier_2_order:EndSpell()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_pangolier_2_check")
	if modifier then
		modifier:SafeDestroy()
	end
end






modifier_heroTalent_npc_dota_hero_pangolier_2_check = class({})

function modifier_heroTalent_npc_dota_hero_pangolier_2_check:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_pangolier_2_check:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_check:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_check:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_check:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_check:OnCreated(keys)
	
	if IsServer() then
		-- print(IsValid(self:GetParent()))
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*1.2,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		
		self:StartIntervalThink(0.02)
	end
end
function modifier_heroTalent_npc_dota_hero_pangolier_2_check:OnIntervalThink()
	local caster = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*1.2
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 250, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if not unit:HasModifier("modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage") then
			self.damageTable.victim = unit
			ApplyDamage(self.damageTable)
			unit:AddNewModifier( caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage", {duration = 1.5} )
		end
	end
end



function modifier_heroTalent_npc_dota_hero_pangolier_2_check:OnDestroy()
	if IsServer() then
		local hHero = self:GetParent()
		hHero:RemoveAbility( "pangolier_gyroshell" )
		hHero:RemoveAbility( "aghsfort_pangolier_gyroshell" )
		hHero:RemoveModifierByName( "modifier_pangolier_gyroshell" )
	end
end

function modifier_heroTalent_npc_dota_hero_pangolier_2_check:CheckState()
	local state = 
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
	return state
end





modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage = class({})

function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_pangolier_2_no_damage:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
