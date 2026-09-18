
heroTalent_npc_dota_hero_pangolier = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_check", "heroTalent/heroTalent_npc_dota_hero_pangolier", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_no_damage", "heroTalent/heroTalent_npc_dota_hero_pangolier", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_order", "heroTalent/heroTalent_npc_dota_hero_pangolier", LUA_MODIFIER_MOTION_NONE) 
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_pangolier_roll_cd", "heroTalent/heroTalent_npc_dota_hero_pangolier", LUA_MODIFIER_MOTION_NONE) 

function heroTalent_npc_dota_hero_pangolier:GetAbilityTextureName() return "pangolier_gyroshell" end
function heroTalent_npc_dota_hero_pangolier:IsHiddenWhenStolen() return false end
function heroTalent_npc_dota_hero_pangolier:IsStealable() return true end


function heroTalent_npc_dota_hero_pangolier:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_pangolier_order")
	if modifier then
		modifier:SpellToTarget( pos )
	end
	
end


function heroTalent_npc_dota_hero_pangolier:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_pangolier_order"
end



modifier_heroTalent_npc_dota_hero_pangolier_order = class({})

function modifier_heroTalent_npc_dota_hero_pangolier_order:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_pangolier_order:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_order:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_order:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_order:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_order:OnCreated()
	if IsServer() then
		self.currentOrder = 0
		self.currentPos = self:GetParent():GetAbsOrigin()
	end
end
function modifier_heroTalent_npc_dota_hero_pangolier_order:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end
function modifier_heroTalent_npc_dota_hero_pangolier_order:OnOrder( params )
	if not IsServer() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if params.unit~=self:GetParent() then return end
	local ability = self:GetAbility()

	if not ability:IsCooldownReady() then
		return
	end
	if not ability:GetAutoCastState() then
		return
	end
	local parent = self:GetParent()
	if  parent:IsRooted() then
		return  
	end
	-- right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self.currentOrder = self.currentOrder +1
		
		Timers:CreateTimer(0.3, function()
			self.currentOrder = self.currentOrder - 1
		end)
		
		if self.currentOrder>=2 and CalculateDistance(self.currentPos,params.new_pos)<=30 then
			-- self:GetAbility():UseResources(true, true, true,true)
			-- print(ability:GetCooldown(ability:GetLevel()) * self:GetParent():GetCooldownReduction())
			ability:UseResources(true, true, true, true)
			self:SpellToTarget( params.new_pos )
		end
		self.currentPos = params.new_pos
		
	end
end

function modifier_heroTalent_npc_dota_hero_pangolier_order:SpellToTarget(pos)
	if IsServer() then
		local caster = self:GetCaster()
		local loop_sound = "Hero_Pangolier.Gyroshell.Loop" 
		caster:Purge(false, true, false, false, false)
		-- caster:AddNewModifier(caster, ability, roll_modifier, {duration = ability_duration ,stun_duration = 1 })
		-- caster:AddNewModifier(caster, ability, "modifier_modifier_heroTalent_npc_dota_hero_pangolier_check", {duration = ability_duration})
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
			caster:AddNewModifier( caster, hAbility, "modifier_heroTalent_npc_dota_hero_pangolier_check", {duration = 10} )
			-- local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf"

			-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
			-- ParticleManager:SetParticleControl( effect_cast, 1, caster:GetOrigin() )
			-- ParticleManager:SetParticleControl( effect_cast, 1, Vector(200,0,0) )
			-- ParticleManager:ReleaseParticleIndex( effect_cast )

		else
			print( "Start - Can't find ability" )
		end
	end

end










modifier_heroTalent_npc_dota_hero_pangolier_check = class({})

function modifier_heroTalent_npc_dota_hero_pangolier_check:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_pangolier_check:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_check:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_check:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_check:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_check:OnCreated(keys)
	
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
function modifier_heroTalent_npc_dota_hero_pangolier_check:OnIntervalThink()
	local caster = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*1.2
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 250, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if not unit:HasModifier("modifier_heroTalent_npc_dota_hero_pangolier_no_damage") then
			self.damageTable.victim = unit
			ApplyDamage(self.damageTable)
			if IsValid(unit) and unit:IsAlive() then
				unit:AddNewModifier( caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_pangolier_no_damage", {duration = 1.5} )
			end
			
		end
	end
end



function modifier_heroTalent_npc_dota_hero_pangolier_check:OnDestroy()
	if IsServer() then
		local hHero = self:GetParent()
		hHero:RemoveAbility( "pangolier_gyroshell" )
		hHero:RemoveAbility( "aghsfort_pangolier_gyroshell" )
		hHero:RemoveModifierByName( "modifier_pangolier_gyroshell" )
	end
end


function modifier_heroTalent_npc_dota_hero_pangolier_check:CheckState()
	local state = 
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
	return state
end

modifier_heroTalent_npc_dota_hero_pangolier_no_damage = class({})

function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_pangolier_no_damage:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
