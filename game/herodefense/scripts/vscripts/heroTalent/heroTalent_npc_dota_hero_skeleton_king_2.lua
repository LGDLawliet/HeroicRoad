heroTalent_npc_dota_hero_skeleton_king_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skeleton_king_2", "heroTalent/heroTalent_npc_dota_hero_skeleton_king_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom", "heroTalent/heroTalent_npc_dota_hero_skeleton_king_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_skeleton_king_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_skeleton_king_2"
end



function heroTalent_npc_dota_hero_skeleton_king_2:Precache( context )
	PrecacheResource( "model", "models/items/wraith_king/arcana/wraith_king_arcana.vmdl", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_weapon_blur_attack2_reverse.vpcf", context )



end


modifier_heroTalent_npc_dota_hero_skeleton_king_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_skeleton_king_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_skeleton_king_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		local pos = caster:GetOrigin()
		self.unit  = CreateUnitByName("npc_hd_sk_double", pos, true, caster, caster, caster:GetTeamNumber())
		self.unit:SetOrigin(pos)
		self.unit:SetForwardVector(-caster:GetForwardVector())
		self.unit:SetParent(caster,nil)
		self.unit:AddNewModifier(caster, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom", {})

		
	end

end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2:GetPhantom()
	return self.unit
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_2:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -15
end


function modifier_heroTalent_npc_dota_hero_skeleton_king_2:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom = modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom or class({})
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:IsPurgeException()	return false end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:GetStatusEffectName() return "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf" end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:OnCreated(keys)
	if IsServer() then
		-- local caster = self:GetCaster()
		-- self.type = keys.type
		self:GetParent():SetHullRadius(0)
		-- self:GetParent():SetModelScale(0.9)
		self.caster = self:GetCaster()
		self:StartIntervalThink(1.5)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_core_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head_fx", self:GetParent():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
		self.type = 0

		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
	-- if self:GetStackCount()==2 then
	-- 	self.height_offect = 300
	-- end
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:OnIntervalThink()

	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not caster or not ability then
		self:SafeDestroy()
		return
	end
	if not caster:IsAlive() then
		self.type = 0
		return
	end
	local parent = self:GetParent()
	if caster:HasModifier("modifier_Advanced_reincarnation_unlock3") then
		self:StartIntervalThink(20)
		return
	end
	
	if self.type==0 then
		local pos = caster:GetOrigin()
		local units = FindUnitsInLine(caster:GetTeamNumber(), pos, pos-caster:GetForwardVector()*700,nil, 350,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
		if #units>0 then
			
			
			parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1.7)
			parent:EmitSound("Hero_SkeletonKing.PreAttack")
			self.type = 1
			self:StartIntervalThink(0.5)
		end
	else
		local pos = caster:GetOrigin()
		local units = FindUnitsInLine(caster:GetTeamNumber(), pos, pos-caster:GetForwardVector()*700,nil, 350,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
		if #units>0 then
			local damageTable = {
				-- victim = enemy,
				attacker = caster,
				damage = caster:GetAverageTrueAttackDamage(nil)*0.6,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
				}
	
			for _, unit in ipairs(units) do
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
			
		end
		parent:EmitSound("Hero_SkeletonKing.Attack")
		self.type = 0
		self:StartIntervalThink(1.5)
	end




	
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end
function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:GetVisualZDelta( params )

	return -300
end



function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:GetOverrideAnimation(params)
	return ACT_DOTA_IDLE_STATUE
end

function modifier_heroTalent_npc_dota_hero_skeleton_king_2_phantom:GetModifierInvisibilityLevel()return 1 end



