--
heroTalent_npc_dota_hero_sven_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_sven_2", "heroTalent/heroTalent_npc_dota_hero_sven_2", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_sven_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_sven_2"
end

function heroTalent_npc_dota_hero_sven_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_impact_b.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/talent/sven_2/effect_crit.vpcf", context )

end


modifier_heroTalent_npc_dota_hero_sven_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_sven_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_sven_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_sven_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_sven_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_sven_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_sven_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.hero =  self:GetParent()
		-- self.nFXIndex = ParticleManager:CreateParticle( "particles/test_effect/abaddon_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon", self:GetCaster():GetAbsOrigin(), true )

		-- self:AddParticle( self.nFXIndex, false, false, -1, true, false )

		self.timer = 0
		self:GetAbility():StartCooldown(7)--这里设置冷却
		
		self.draw = false
		self.modelName = self.hero:GetModelName()
		-- local name = "models/items/sven/sven_ti7_immortal_sword/sven_ti7_immortal_sword.vmdl"
		local name = "models/items/tiny/tiny_prestige/tiny_prestige_sword.vmdl"
		-- self.model = GameRules:AttachWearableWithScale(self.hero, name,nil,2)
		-- self.model:AddEffects(EF_NODRAW)
		-- _G.GAME_X = 0
		-- _G.GAME_Y = 0
		-- _G.GAME_Z = 0
		self.hide = true
		self.bonus_attack = false
		self.chance = 1

		Timers:CreateTimer(0.3, function()
			
			-- 这里是因为最后一个就是武器了 所以这样弄
			local model = self.hero:FirstMoveChild()
			-- self.modelName = self.hero:GetModelName()
			while model ~= nil do
				if model:GetClassname() == "dota_item_wearable" then
					-- print(model)
					-- PrintTable(model)
					-- print(model:GetModelName())
					self.lastModel = model
				end
				model = model:NextMovePeer()
			end
			-- self.lastModel:AddEffects(EF_NODRAW) -- Set model hidden
			-- local name = self.lastModel:GetModelName()
			-- local name = "models/items/sven/sven_ti7_immortal_sword/sven_ti7_immortal_sword.vmdl"
			self.model = GameRules:AttachWearableWithScale(self.hero, name,nil,4)
			self.model:AddEffects(EF_NODRAW)
			self.hAttachment = self:GetParent():ScriptLookupAttachment( "attach_weapon" )
			self.hAttachment_sword = self:GetParent():ScriptLookupAttachment( "attach_sword" )
			self:StartIntervalThink(0)
			-- self.hAttachment_sword_end = self:GetParent():ScriptLookupAttachment( "attach_sword_end" )

		end)
	
	end
end
--由于这个模型是主动创建 所以单位变身时候需要把这个模型隐藏
function modifier_heroTalent_npc_dota_hero_sven_2:OnIntervalThink()
	if self.hide then
		self.model:AddEffects(EF_NODRAW)
	else
		
		self.model:RemoveEffects(EF_NODRAW)
		-- local pos = self.lastModel:GetAbsOrigin()
		-- local angle = self.lastModel:GetAngles()
		local angle =self:GetParent():GetAttachmentAngles(self.hAttachment_sword)
		-- local dir = AnglesToVector(angle)
		-- local pos = RotatePosition(Vector(0,0,0), QAngle(_G.GAME_X, _G.GAME_Y, _G.GAME_Z), dir)
		-- angle = VectorToAngles(pos)
		local pos=self.hero:GetAttachmentOrigin(self.hAttachment)
		-- local pos1 = self.hero:GetAttachmentOrigin(self.hAttachment_sword)
		-- local pos2= self.hero:GetAttachmentOrigin(self.hAttachment_sword_end)
		-- print(pos1)
		-- print(pos2)
		-- local dir = CalculateDirection(pos1,pos2)
		-- print(dir)
		-- local angle = VectorToAngles(dir)
		-- self.model:SetForwardVector(dir)
		
		self.model:SetAngles(angle.x, angle.y, angle.z)
		self.model:SetAbsOrigin(pos)
		if self.chance==1 then
			self.timer =  math.min(self.timer +FrameTime()*2,self.attack_rate)
			self.model:SetAbsScale(0.5+self.timer/self.attack_rate*3.5)
			
			if self.timer==self.attack_rate then
				self.chance=0
				self.timer = 0
			end
		else
			self.timer =  math.min(self.timer +FrameTime()*2,self.attack_rate)
			self.model:SetAbsScale(math.max(4-self.timer/self.attack_rate*3.5,0.1))
		end
	
		-- self.attack_rate =  self:GetCaster():GetSecondsPerAttack(false)
	end
end

-- function modifier_heroTalent_npc_dota_hero_sven_2:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_EVENT_ON_ATTACK_LANDED,
-- 		MODIFIER_EVENT_ON_ATTACK_START,
-- 		MODIFIER_EVENT_ON_ATTACK_CANCELLED,
-- 	}

-- 	return funcs
-- end
function modifier_heroTalent_npc_dota_hero_sven_2:Advanced_GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetLevel()
end


function modifier_heroTalent_npc_dota_hero_sven_2:ADDeclareFunctions()
	local funcs ={

		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_CANCELLED = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK_START = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}


    }
    return funcs
    
end


function modifier_heroTalent_npc_dota_hero_sven_2:OnAttackStart(keys)
	if not IsServer() then return end
	
	-- "Does not work against wards, buildings and allies."
    if self.hero == keys.attacker then
		if self.hero:PassivesDisabled() then
			return
		end
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(true, true, true,true)
			
			self.bonus_attack = true
			if self.hero.origin_model_name==self.hero:GetModelName() then
				self.hide = false
				self.model:RemoveEffects(EF_NODRAW)
				self.model:SetAbsScale(0.5)
				self.attack_rate =  self:GetCaster():GetSecondsPerAttack(false)*0.7
				self.timer = 0
				self.chance = 1
				Timers:CreateTimer(self.attack_rate, function()
					self.hide = true
				end)
			end
			
		end
    end
end

function modifier_heroTalent_npc_dota_hero_sven_2:OnAttackCancelled(keys)
	if not IsServer() then return end
	
	if self.hero == keys.attacker then
		if self.hide==false then
			self.hide = true
			self.model:RemoveEffects(EF_NODRAW)
		 end
	 end
end




function modifier_heroTalent_npc_dota_hero_sven_2:OnAttackLanded(keys)
	if IsServer() then
		
		if keys.attacker==self:GetParent() then
			if keys.attacker:IsInSpecialAttack() then
				return
			end
			local ability = self:GetAbility()
			local cooldown = ability:GetCooldownTimeRemaining()
			local reduce = ability:GetSpecialValueFor("CDreduce")
			local new_time = cooldown-reduce
			self.limit = ability:GetSpecialValueFor("limit")
			if cooldown <= reduce then
				return
			end
			ability:EndCooldown()
			if cooldown > reduce and new_time>0 then
				ability:StartCooldown(new_time)
			end
			if not self:GetParent():IsRealHero() then
				return false
			end
			if self.bonus_attack then
				-- self.nFXIndex = ParticleManager:CreateParticle( "particles/test_effect/abaddon_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
				-- ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon", self:GetCaster():GetAbsOrigin(), true )
				local parent = self:GetParent()
				local pfx = ParticleManager:CreateParticle("particles/rebuild/talent/sven_2/effect_crit.vpcf", PATTACH_CUSTOMORIGIN, keys.attacker)
				ParticleManager:SetParticleControl(pfx, 0,keys.attacker:GetAbsOrigin())
				ParticleManager:SetParticleControlForward(pfx, 0, (keys.target:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized())
				ParticleManager:ReleaseParticleIndex(pfx)

				local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
				keys.target:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				local count = 0
				
				
				for i, unit in ipairs (enemies) do
					if unit~=keys.target then
						local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_impact_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
						ParticleManager:SetParticleControl(nFXIndex,0,unit:GetOrigin())
						ParticleManager:SetParticleControl(nFXIndex,1,Vector(1,1,1))
						ParticleManager:SetParticleControl(nFXIndex,2,unit:GetOrigin()+Vector(0,0,64))
						-- articleManager:SetParticleControlEnt( nFXIndex, 0,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
						-- ParticleManager:SetParticleControlEnt( nFXIndex,1,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
						-- ParticleManager:SetParticleControlEnt( nFXIndex,4,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
						
						-- ParticleManager:SetParticleControlEnt(nFXIndex, 2, unit, PATTACH_CUSTOMORIGIN, "attach_hitloc", unit:GetAbsOrigin(), true)
						ParticleManager:ReleaseParticleIndex(nFXIndex)
	
						
						Timers:CreateTimer(RandomFloat(0, 0.25), function()
							
							parent:EmitSound("Hero_FacelessVoid.TimeLockImpact")
							local modifier_keys = {
								duration = 0.1,
								iSpecialAttack = 1,
								iDisableApplyModifier = 0,
								iDisableCleave =0,
								iDisableSplit = 0,
						
							}
							local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
							parent:PerformAttack(unit, false, true, true, true, false, false, true)--对一单位执行攻击。
							if IsValid(attackEffectRecord) then
								attackEffectRecord:Destroy()
							end
						end)
						count = count + 1
						if count>=self.limit then
							break
						end
					end
				
				end
				self.bonus_attack = false
			end
		end
	end
end



