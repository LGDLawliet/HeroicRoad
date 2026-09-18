heroTalent_npc_dota_hero_shredder_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_shredder_3", "heroTalent/heroTalent_npc_dota_hero_shredder_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_shredder_3_effect", "heroTalent/heroTalent_npc_dota_hero_shredder_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_shredder_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_shredder_3"
end

function heroTalent_npc_dota_hero_shredder_3:Precache( context )
	PrecacheResource( "model", "models/monster/acsu_atlus/acsu_atlus.vmdl", context )
end
function heroTalent_npc_dota_hero_shredder_3:ReleaseLaser(target)
	local caster = self:GetCaster()

	local pos = target:GetAttachmentOrigin(target:ScriptLookupAttachment( "attach_hitloc" ) )
	local vAttachmentSourcePos = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment( "attach_attack2" ) )
	local direction = (pos - vAttachmentSourcePos):Normalized()

	local target_pos = vAttachmentSourcePos+direction*(CalculateDistance(pos,vAttachmentSourcePos))
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/items/tesla_high_energy_gun/effect.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 9, vAttachmentSourcePos )
	ParticleManager:SetParticleControl( pfx, 1, target_pos )
	DestroyParticleByDelay(pfx,2)
	caster:EmitSound("Hero_Tinker.LaserImpact")

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), vAttachmentSourcePos,target_pos,nil, 100,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE)
	local damageTable =
	{
		-- victim = hitEnemy,
		attacker = caster,
		damage = caster:GetAverageTrueAttackDamage(nil)*1.5,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self,
	}
	
	for _, hitEnemy in pairs( tTargets ) do
		damageTable.victim = hitEnemy
		ApplyDamage( damageTable )
		
	end

end


modifier_heroTalent_npc_dota_hero_shredder_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_shredder_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_shredder_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_shredder_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_shredder_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_shredder_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_shredder_3:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		local parent = self:GetParent()
		parent.IsRanger = true
		parent:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK )

		-- parent:SetOriginalModel("models/monster/acsu_atlus/acsu_atlus.vmdl")
		
		self:StartIntervalThink(0.1)	
	end
end


function modifier_heroTalent_npc_dota_hero_shredder_3:OnIntervalThink()
	local parent = self:GetParent()
	parent:UpdateOriginModel()
	self:StartIntervalThink(-1)
	local model = parent:FirstMoveChild()
	-- self.modelName = self.hero:GetModelName()
	local model_list = {}
	while model ~= nil do
		if model:GetClassname() == "dota_item_wearable" then
			-- print(model)
			-- PrintTable(model)
			-- print(model:GetModelName())

			table.insert(model_list,model)
			
		end
		model = model:NextMovePeer()
	end
	for _, model in ipairs(model_list) do
		UTIL_Remove(model)
	end	
end



function modifier_heroTalent_npc_dota_hero_shredder_3:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	
	return decFuncs	
end
function modifier_heroTalent_npc_dota_hero_shredder_3:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	local ability = self:GetAbility()
	if keys.damage<=0 then
		return
	end

	self:IncrementStackCount()
	if self:GetStackCount()>=6 then
		if keys.attacker:GetModelName()~="models/monster/acsu_atlus/acsu_atlus.vmdl" then
			return
		end
		ability:ReleaseLaser(keys.target)
		self:SetStackCount(0)
	end

	
end





function modifier_heroTalent_npc_dota_hero_shredder_3:GetAttackSound()
	return "Hero_Gyrocopter.Attack"
end
function modifier_heroTalent_npc_dota_hero_shredder_3:GetModifierProjectileName()
	return "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_base_attack.vpcf"
end

function modifier_heroTalent_npc_dota_hero_shredder_3:GetModifierModelChange()
	return "models/monster/acsu_atlus/acsu_atlus.vmdl"
end


function modifier_heroTalent_npc_dota_hero_shredder_3:GetModifierProjectileSpeedBonus()
	return 1500
end

function modifier_heroTalent_npc_dota_hero_shredder_3:Advanced_GetModifierAttackRangeOverride() return  800 end



function modifier_heroTalent_npc_dota_hero_shredder_3:GetModifierBaseAttack_BonusDamage() 
	return math.min(self:GetParent():GetPhysicalArmorValue(false),400)
end

function modifier_heroTalent_npc_dota_hero_shredder_3:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
	}
end

