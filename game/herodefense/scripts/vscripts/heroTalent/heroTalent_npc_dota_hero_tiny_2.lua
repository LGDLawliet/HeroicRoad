--
heroTalent_npc_dota_hero_tiny_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_tiny_2", "heroTalent/heroTalent_npc_dota_hero_tiny_2", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_tiny_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_tiny_2"
end
function heroTalent_npc_dota_hero_tiny_2:OnCustomDataSettlement()

	if self:GetCaster():GetAverageTrueAttackDamage(nil)>=10000 then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("giant_1")
		end
	end

end



modifier_heroTalent_npc_dota_hero_tiny_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_tiny_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_tiny_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_tiny_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_tiny_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_tiny_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_tiny_2:GetPriority() return 1 end
function modifier_heroTalent_npc_dota_hero_tiny_2:OnCreated(keys)
	self.bonus_damage = 20
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"giant_1") then
			self.bonus_damage = 22
		end
		self.hero =  self:GetParent()
		-- self:GetAbility():StartCooldown(10)
	
		-- self.draw = false
		self.modelName = self.hero:GetModelName()
		Timers:CreateTimer(0.3, function()
			
			-- 这里是因为最后一个就是武器了 所以这样弄
			local model = self.hero:FirstMoveChild()
			-- self.modelName = self.hero:GetModelName()
			local model_name
			while model ~= nil do
				if model:GetClassname() == "dota_item_wearable" then
					-- print(model)
					-- PrintTable(model)
					model_name  = model:GetModelName()
					-- print(model:GetModelName())
					-- self.lastModel = model
				end
				model = model:NextMovePeer()
			end
			-- self.lastModel:AddEffects(EF_NODRAW) -- Set model hidden
			-- local name = "models/heroes/tiny/tiny_01/tiny_01_tree.vmdl"
			-- self.model = GameRules:AttachWearableWithScale(self.hero, name,nil,1)
            -- self.wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny/tiny_01/tiny_01_tree.vmdl", targetname=DoUniqueString("prop_dynamic")})
			self.wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model_name, targetname=DoUniqueString("prop_dynamic")})



            self.wearable:FollowEntity(self.hero, true)
			-- self.model:AddEffects(EF_NODRAW)
            self:StartIntervalThink(0)
		end)
	
	end

end
--由于这个模型是主动创建 所以单位变身时候需要把这个模型隐藏
function modifier_heroTalent_npc_dota_hero_tiny_2:OnIntervalThink()
    if self.modelName~= self.hero:GetModelName() then
        self.wearable:AddEffects(EF_NODRAW)
    else
        self.wearable:RemoveEffects(EF_NODRAW)
    end
end

function modifier_heroTalent_npc_dota_hero_tiny_2:DeclareFunctions()
	local funcs = {
		-- MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_tiny_2:GetActivityTranslationModifiers( params )
	return "tree"
end
function modifier_heroTalent_npc_dota_hero_tiny_2:GetAttackSound()
	if IsServer() then
		if self.modelName~= self.hero:GetModelName() then
			return 
		else
			return "Hero_Tiny_Tree.Attack"
		end
	end
	
end
function modifier_heroTalent_npc_dota_hero_tiny_2:GetModifierDamageOutgoing_Percentage()
	return self.bonus_damage or 20
end
function modifier_heroTalent_npc_dota_hero_tiny_2:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end
	if self:GetParent():IsDisableCleave() then
		return
	end
	if self:GetParent():IsRangedAttacker() then
		return
	end

	local cleave_damage = keys.damage * 0.5
	local target = keys.target
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = cleave_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
		end
	end
	-- local pos = self:GetCaster():GetAbsOrigin()
	-- local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_great_cleave_crit.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControl(pfx, 0, Vector(pos.x,pos.y,pos.y+100))
	-- -- local pfx = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf", PATTACH_ABSORIGIN, keys.target)
	-- -- ParticleManager:SetParticleControl(pfx, 0, keys.target:GetAbsOrigin())
	-- ParticleManager:ReleaseParticleIndex(pfx)
end



function modifier_heroTalent_npc_dota_hero_tiny_2:Advanced_GetModifierAttackRangeBonus()
	return 200
end


function modifier_heroTalent_npc_dota_hero_tiny_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end
