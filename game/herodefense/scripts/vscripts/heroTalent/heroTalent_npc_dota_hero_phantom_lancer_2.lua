LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_2", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom", "heroTalent/heroTalent_npc_dota_hero_phantom_lancer_2", LUA_MODIFIER_MOTION_NONE)


heroTalent_npc_dota_hero_phantom_lancer_2 = class({})



function heroTalent_npc_dota_hero_phantom_lancer_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_illusion_destroy.vpcf", context )

end

function heroTalent_npc_dota_hero_phantom_lancer_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_phantom_lancer_2" end

modifier_heroTalent_npc_dota_hero_phantom_lancer_2 = class({})
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:IsDebuff()      return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:IsHidden()      return true end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:IsPurgable()    return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:IsPurgeException()  return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	local chance = 15
	if caster:GetSecondsPerAttack(false)<=0.1 then
		chance = 7.5
	end
	if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
		if not caster:IsApplyModifier()  then
			return
		end
		if not keys.target or keys.target:IsNull() then
			return
		end
		self:CallPhantom(keys.target)



				
		
	end

	
end


function modifier_heroTalent_npc_dota_hero_phantom_lancer_2:CallPhantom(target)
	local caster = self:GetCaster()
	local ability = self
	local pos = target:GetOrigin() + Vector(RandomInt(-400, 400),RandomInt(-400, 400),0)
	-- local forward = caster:GetForwardVector()
	local duration = 10
	local unit  = CreateUnitByName("npc_hd_double", pos, true, caster, caster, caster:GetTeamNumber())
	unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom", {duration=duration,target = target:entindex()})
	unit:SetForwardVector(CalculateDirection(target,pos))
	unit:SetOriginalModel(caster.origin_model_name)
	unit:SetModelScale(caster:GetModelScale())
	local hModel = caster:FirstMoveChild()
	while hModel ~= nil do
		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
			local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = hModel:GetModelName(), origin = unit:GetAbsOrigin() })
			-- hWearable:SetRenderColor(vRBG.x, vRBG.y, vRBG.z)
			hWearable:FollowEntity(unit, true)
		end
		hModel = hModel:NextMovePeer()
	end
end















modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom = modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom or advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:IsPurgeException()	return false end
-- function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetStatusEffectName() return "particles/status_fx/status_effect_phantom_lancer_illusion.vpcf" end
-- function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetPriority() return 10000 end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:OnCreated(keys)
	self.attack_rate =  self:GetCaster():GetSecondsPerAttack(false)
	if IsServer() then

		self:GetParent():SetHullRadius(0)
		-- self:GetParent():SetModelScale(0.9)

		self:StartIntervalThink(0.01)

	
		self.target =  EntIndexToHScript(keys.target)
		self:GetParent():SetForceAttackTarget( self.target ) 

	end

end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetModifierBaseAttackTimeConstant() return self.attack_rate end


function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:OnDestroy()
	if IsServer() then
		-- self:GetParent():ForceKill(false)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_illusion_destroy.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:OnIntervalThink()

	local caster = self:GetCaster()

	if not caster or not caster:IsAlive() then
		self:SafeDestroy()
		return
	end
	if not self.target then
		return
	end
	if self.target:IsNull() or not self.target:IsAlive() then
		self:SafeDestroy()
		return
	end

end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,           --取消移动速度限制
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
end


function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:Advanced_GetModifierAttackRangeOverride()
	return 250
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetModifierMoveSpeed_AbsoluteMin()
	return 1500
end


function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetModifierModelChange(params)
	-- return "models/creeps/omniknight_golem/omniknight_golem.vmdl"
	if IsServer() then
		return self:GetCaster().origin_model_name
	end
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetActivityTranslationModifiers()	
	if self:GetCaster():GetUnitName()=="npc_dota_hero_phantom_assassin" then

		return "haste"
	end
	return "run_fast" 
end
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local parent = self:GetParent()
	if keys.attacker ~= parent then
		return
	end
	local damage = 0
	if self.attack_rate<=0.1 then
		damage = self:GetCaster():GetAgility()*3
	else
		damage = self:GetCaster():GetAgility()*1.5
	end
	local damageTable = {
		victim =keys.target,
		attacker = self:GetCaster(),
		damage =damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
	}

	ApplyDamage( damageTable )
	

	self:IncrementStackCount()
	if self:GetStackCount()>=3 then
		self:SafeDestroy()
	end
	


end


function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:GetAttackSound()
	return "Hero_PhantomLancer.Attack"
end
-- advanced_modifier
function modifier_heroTalent_npc_dota_hero_phantom_lancer_2_phantom:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
	}
end

