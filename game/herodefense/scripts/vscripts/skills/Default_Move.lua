Default_Move = Default_Move or class({})
require("internal/timers")
LinkLuaModifier("modifier_Default_Move", "skills/Default_Move", LUA_MODIFIER_MOTION_NONE)
--以下是特殊modifier加载
LinkLuaModifier("modifier_stage20_bonus", "skills/Default_Move", LUA_MODIFIER_MOTION_NONE)--长尾传送门：20回合给自选箱子和乱纪元
LinkLuaModifier("modifier_item_hd_Treasure5_oblation", "items/item_hd_Treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Magic_Conversion", "special_gain/creep_special_gain_Magic_Conversion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Spear_aftermove", "skills/Advanced_Spear", LUA_MODIFIER_MOTION_NONE)--长尾传送门：高阶战神之矛
LinkLuaModifier("modifier_Chaotic_Offering_move", "skills/Middle_Chaotic_Offering",  LUA_MODIFIER_MOTION_NONE)--长尾传送门：中高地狱火
LinkLuaModifier("modifier_Chaotic_Offering_move_5", "skills/Advanced_Chaotic_Offering",  LUA_MODIFIER_MOTION_NONE)--长尾传送门：中高地狱火
LinkLuaModifier("modifier_chaotic_buff", "skills/Default_Move",  LUA_MODIFIER_MOTION_NONE)--长尾传送门：乱纪元基础配置
LinkLuaModifier("modifier_creep_act1_treasure_debuff", "creeps_spell/creep_act1_treasure", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dalaoban_jineng", "skills/Default_Move", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_buff_summon", "skills/Default_Move", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_masters_players", "skills/Default_Move", LUA_MODIFIER_MOTION_NONE)

function Default_Move:GetIntrinsicModifierName()
	return "modifier_stage20_bonus"
end

function Default_Move:GetAOERadius()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_queenofpain_2") then
		return 300
	end
	return 1
end

function Default_Move:GetCastRange()
	if IsClient() then		-- Indicating no-remnant maximum range
		local caster = self:GetCaster()
		local range = self:GetSpecialValueFor("cast_range")- caster:GetCastRangeBonus()


		
		range = range + GeDefaultMoveCastRange(caster, {})
 		range = range * (1+GeDefaultMoveCastRangePercentage(caster, {})*0.01)

		return range
	else					-- So you can click wherever and roll in that direction, even if its out of range
		return 30000
	end
end
function Default_Move:GetCooldown(iLevel)
	local caster = self:GetCaster()
	local base_cooldown = 7


	if IsServer() then

		local ability = caster:FindAbilityByName("Advanced_assassinate")
		if ability and not ability:IsCooldownReady() and ability:GetSpecialValueFor("advanced_level")>=15 then
			base_cooldown = 5
		end
		local chaotic_blink_str = caster:FindModifierByName("modifier_item_chaotic_blink_str")
		local chaotic_blink_agi = caster:FindModifierByName("modifier_item_chaotic_blink_agi")
		local chaotic_blink_int = caster:FindModifierByName("modifier_item_chaotic_blink_int")
		if chaotic_blink_str then
			base_cooldown = base_cooldown * (1-chaotic_blink_str.cd)
		end
		if chaotic_blink_agi then
			base_cooldown = base_cooldown * (1-chaotic_blink_agi.cd)
		end
		if chaotic_blink_int then
			base_cooldown = base_cooldown * (1-chaotic_blink_int.cd)
		end
	end
	if caster:HasModifier("modifier_item_hd_hermes_boots") then
		base_cooldown = 3
	end
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_antimage_2") then
		base_cooldown = base_cooldown*0.35
	end
	return base_cooldown
end



function Default_Move:OnSpellStart()
	
	if IsInToolsMode() then
		
		-- local unit = self:GetCaster():SummonUnit("npc_monster_middle_earth_element",100,
		-- self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200),
		-- self:GetCaster():GetForwardVector(),self,0,5000,0,500,20,1,1)
	end
	if IsServer() then


		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()

		local artifact_time_clock = caster:FindModifierByName("modifier_item_hd_time_clock_effects")
		if artifact_time_clock and artifact_time_clock.level >= 30 then
			caster:AddNewModifier(caster,artifact_time_clock:GetAbility(),"modifier_item_hd_time_clock_effects_lv30",{duration = artifact_time_clock.duration_3 + artifact_time_clock.duration_buff_3})
			self:EndCooldown()
			self:StartCooldown(artifact_time_clock.cd_3)
		end

		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_queenofpain_2") then
			self:QueenBlink(target_loc)
			return
		end

		local caster_loc = caster:GetAbsOrigin()
		local speed 			=	self:GetSpecialValueFor("ball_lightning_move_speed")
		local vision 			= 	self:GetSpecialValueFor("ball_lightning_vision_radius")
		
		
		self.traveled 	= 0
		self.distance 	= (target_loc - caster_loc):Length2D()
		local data = self:GetBonusAndCooldown()
		local castrange = data.castRange
		local cooldown = data.cooldown
		FireDefaultMoveEvent(caster,self)


        if self.distance >castrange then
            self.distance  = castrange
        end
		self.distance = math.min(self.distance,2000)
		-- self.distance = 3000
		self.direction 	= (target_loc - caster_loc):Normalized()
		self.dir = CalculateDirection(target_loc, caster_loc)
		-- Play the cast sound



		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_antimage_2") then
			local particle_cast = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"

			local sound_start = "Hero_Antimage.Blink_in"

		
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
			ParticleManager:SetParticleControl( effect_cast, 0, caster_loc )
			ParticleManager:SetParticleControlForward(effect_cast, 0, self.dir)  --方向
			ParticleManager:ReleaseParticleIndex( effect_cast )
		
		
		
			EmitSoundOnLocationWithCaster( caster_loc, sound_start, caster )
	
		else
			caster:EmitSound("Hero_StormSpirit.BallLightning")
			if (target_loc - caster_loc):Length2D() > 130 then
				caster:EmitSound("Hero_StormSpirit.BallLightning.Loop")
			end
			local pfx_min = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_powershot_channel_endcap_model.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx_min, 0, Vector(caster_loc.x-self.dir.x*200, caster_loc.y-self.dir.y*200, caster_loc.z + 128))
			ParticleManager:SetParticleControl(pfx_min, 1, Vector(caster_loc.x-self.dir.x*200, caster_loc.y-self.dir.y*200, caster_loc.z + 128))
			-- ParticleManager:SetParticleControl(pfx_min, 3, Vector(0, 100, 0))
			ParticleManager:SetParticleControlForward(pfx_min, 1, self.dir)  --方向
			ParticleManager:ReleaseParticleIndex(pfx_min)
		end
		

		if cooldown ~=self:GetCooldownTimeRemaining() then
			self:EndCooldown()
			self:StartCooldown(cooldown)
		end
	

		local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_pangolier_2")
		if ability and ability:IsCooldownReady() and not caster:PassivesDisabled() then
			local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_pangolier_2_order")
			if modifier then
				ability:UseResources(true, true, true, true)
				modifier:SpellToTarget()
			end
			speed = speed *0.5
		end

		

        local info = {
            Ability = self,
            vSpawnOrigin = caster_loc,
            vVelocity = self.direction * speed * Vector(1, 1, 0),
            fDistance = self.distance,
            fStartRadius = 0,
            fEndRadius = 0,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            bProvidesVision = true,
            iVisionTeamNumber = caster:GetTeamNumber(),
            iVisionRadius = vision,
            ExtraData =        {
				speed = speed * FrameTime(),
            }
        }
    
		--这里本来是用于造成线性伤害的投掷物  但伤害去除了 只剩下其另一个功能 施法者跟随移动
        self.projectileID = ProjectileManager:CreateLinearProjectile(info)

		caster:AddNewModifier(caster, self, "modifier_Default_Move", {})
		--防止声音不消失
		Timers:CreateTimer(0.6, function()
			self:GetCaster():StopSound("Hero_StormSpirit.BallLightning.Loop")
			self:GetCaster():StopSound("Hero_StormSpirit.BallLightning")
		end)


		self:CheckBlinkCooldown()

		--长尾传送门：高阶战神之矛高阶LV10 LV20效果
		--新LV20战神步伐+
		local ability = self:GetCaster():FindAbilityByName("Advanced_Spear")
		if ability then
			if ability.advanced_level>=10 then
				self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Spear_aftermove", {})
			end
			if ability.advanced_level>=20 then
				if not ability:IsCooldownReady() then
					if ability:GetAutoCastState() then
						self.cd_reduce = 4.5
					else
						self.cd_reduce = 1.5
					end
					local newCooldown = ability:GetCooldownTimeRemaining() - self.cd_reduce
					if newCooldown > 0 then
						ability:EndCooldown()
						ability:StartCooldown(newCooldown)
					else
						ability:EndCooldown()
					end
				end
			end
		end

		--长尾传送门：中高地狱火烈焰爆发
		local chaotic_offering = self:GetCaster():FindModifierByName("modifier_Chaotic_Offering_move") or self:GetCaster():FindModifierByName("modifier_Chaotic_Offering_move_5")
		if chaotic_offering then
			chaotic_offering:Fireblast()
		end
		
		--长尾传送门：act3风
		local act3_wind = self:GetCaster():FindModifierByName("modifier_item_act3_wind")
		if act3_wind and act3_wind:GetAbility() then
			if act3_wind:GetAbility():GetCurrentCharges() >= act3_wind.check4 then
				if act3_wind.chance_4 >= math.random(1,100) then
					self:EndCooldown()
					act3_wind.move_dis_2 = act3_wind.move_dis_2 + act3_wind.need_2
					act3_wind.move_dis_1 = act3_wind.move_dis_1 + act3_wind.need_2
					act3_wind.move_dis_grow = act3_wind.move_dis_grow + act3_wind.need_2
				end
			end
		end

		local rattletrap_2 = self:GetCaster():FindModifierByName("modifier_item_rattletrap_2")
		if rattletrap_2 and rattletrap_2.stage and rattletrap_2.stage >= 3 then
			local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 10000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if enemy and enemy[1] then
				rattletrap_2:Rocket(enemy[1]:GetAbsOrigin(), enemy[1])
			end
		end

		local void_spirit_4 = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_void_spirit_4")
		if void_spirit_4 then
			void_spirit_4:CreateRemnant()
		end
	end
end

function Default_Move:GetBonusAndCooldown()
	local caster = self:GetCaster()
	local castrange = self:GetSpecialValueFor("cast_range")
	local cooldown = self:GetCooldownTimeRemaining()
	castrange = castrange + GeDefaultMoveCastRange(caster, {})
	local ability = caster:FindAbilityByName("Advanced_assassinate")
	if ability and not ability:IsCooldownReady() and ability.advanced_level>=15 then
		castrange = castrange + 500
	end
	castrange = castrange * (1+GeDefaultMoveCastRangePercentage(caster, {})*0.01)

	if caster:HasModifier("modifier_item_hd_travel_boots") or caster:HasModifier("modifier_item_hd_travel_boots_lv2") then  --远行鞋特效
		cooldown = cooldown - 1
	end
	local modifier = caster:FindModifierByName("modifier_FellOmen_Bad_19")
	if modifier then
		cooldown = cooldown * (1+modifier.bonus)
	end



	local data = {
		cooldown = cooldown,
		castRange = castrange,
	}
	return data

end


function Default_Move:QueenBlink(target_loc)
	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	self.distance 	= (target_loc - caster_loc):Length2D()
	local data = self:GetBonusAndCooldown()
	local castrange = data.castRange
	local cooldown = data.cooldown
	
	
	if self.distance >castrange then
		self.distance  = castrange
	end

	self.distance = math.min(self.distance,2000)
	self.direction 	= (target_loc - caster_loc):Normalized()
	self.dir = CalculateDirection(target_loc, caster_loc)
	-- Play the cast sound




	if cooldown ~=self:GetCooldownTimeRemaining() then
		self:EndCooldown()
		self:StartCooldown(cooldown)
	end
	local target_pos = caster_loc+self.dir *self.distance
	caster:Purge(false, true, true, true, true)
	ProjectileManager:ProjectileDodge(caster) --弹道躲闪
	FindClearSpaceForUnit( caster,target_pos, true )
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_blink_shard_start.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, caster_loc)
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector(300,0,0))
	ParticleManager:ReleaseParticleIndex(nFXIndex)


	

	local new_pos =  self:GetCaster():GetOrigin()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_blink_shard_start.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0,new_pos)
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector(300,0,0))
	ParticleManager:ReleaseParticleIndex(nFXIndex)

	local enemies_start = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil,300,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	 DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damage = caster:GetIntellect(false) *4
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_queenofpain_2"),
	}

	for _,enemy in pairs(enemies_start) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)

	end
	local enemies_end = FindUnitsInRadius(caster:GetTeamNumber(), new_pos, nil,300,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	 DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies_end) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)

	end
	EmitSoundOnLocationWithCaster( caster_loc, "Hero_QueenOfPain.Blink_out.Shard",caster )
	EmitSoundOnLocationWithCaster( new_pos, "Hero_QueenOfPain.Blink_in.Shard",caster )
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, caster_loc)
	ParticleManager:SetParticleControl( nFXIndex, 1,new_pos)
	ParticleManager:ReleaseParticleIndex(nFXIndex)

	self:CheckBlinkCooldown()
end

function Default_Move:CheckBlinkCooldown()



	local caster = self:GetCaster()
	if not self:IsCooldownReady() then
		local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_queenofpain_2")
		if ability and ability:GetCurrentAbilityCharges()>=1 then
			ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()-1)
			self:EndCooldown()
			return
		end
		local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_antimage_2")
		if ability and ability:GetCurrentAbilityCharges()>=1 then
			ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()-1)
			self:EndCooldown()
			return
		end

		local item_hd_blink = caster:FindItemInInventory("item_hd_blink")
		if item_hd_blink and item_hd_blink:IsCooldownReady() then
			item_hd_blink:StartCooldown(self:GetCooldownTimeRemaining())
			self:EndCooldown()


		else
			local item_hd_arcana_blink = caster:FindItemInInventory("item_hd_arcana_blink")
			if item_hd_arcana_blink and item_hd_arcana_blink:IsCooldownReady() then
				item_hd_arcana_blink:StartCooldown(self:GetCooldownTimeRemaining())
				self:EndCooldown()
			else
				local modifier = caster:FindModifierByName("modifier_item_hd_arcana_blink_active")
				if modifier and modifier:GetRemainingTime()<=0 then
					modifier:SetDuration(self:GetCooldownTimeRemaining(), true)
					self:EndCooldown()
				end
			end
		end
	
	end
	
end










function Default_Move:OnProjectileThink_ExtraData(location, ExtraData)
	-- Move the caster as long as he has not reached the distance he wants to go to, and he still has enough mana
	local caster = self:GetCaster()

	if (self.traveled + ExtraData.speed < self.distance) and caster:IsAlive()  then
		-- Destroy the trees in the way

		-- Set the caster slightly forwards
		caster:SetAbsOrigin(Vector(location.x, location.y, GetGroundPosition(location, caster).z))
		caster:Purge(false, true, true, true, true)


		-- Calculate the new travel distance
		self.traveled = self.traveled + ExtraData.speed

		self.units_traveled_in_last_tick = ExtraData.speed

	else

		-- Get rid of the Ball
		if caster:FindModifierByName("modifier_Default_Move") then
			caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.01}) --提供相位，防止卡位
			caster:FindModifierByName("modifier_Default_Move"):SafeDestroy()
		end
		local modifier = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_pangolier_2_order")
		if modifier then
			modifier:EndSpell()
		end
		ProjectileManager:DestroyLinearProjectile(self.projectileID)
		local caster_loc = caster:GetAbsOrigin()
		--施法结束后同样创造一个特效
		local pfx_min = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6_shock_cloud.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_min, 1, Vector(caster_loc.x+self.dir.x*300, caster_loc.y+self.dir.y*300, caster_loc.z + 128))
		-- ParticleManager:SetParticleControl(pfx_min, 3, Vector(0, 100, 0))
		ParticleManager:SetParticleControlForward(pfx_min, 1, Vector(-self.dir.x,-self.dir.y,self.dir.z))  --方向
		
	end
end




--- BALL LIGHTNING MODIFIER
modifier_Default_Move = modifier_Default_Move or class({})

-- Modifier properties
function modifier_Default_Move:IsDebuff() 	return false end
function modifier_Default_Move:IsHidden() 	return true end
function modifier_Default_Move:IsPurgable() return false end

function modifier_Default_Move:GetEffectName()
	return "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
end

-- Once again with the Rubick exceptions...
function modifier_Default_Move:OnCreated()
	self:StartIntervalThink(1)

end

function modifier_Default_Move:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then
		self:SafeDestroy()
	end
end

function modifier_Default_Move:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local pos =caster:GetOrigin()
	if caster:HasModifier("modifier_heroTalent_npc_dota_hero_antimage_2") then
		local particle_end = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
		local sound_end = "Hero_Antimage.Blink_out"
		local effect_cast = ParticleManager:CreateParticle( particle_end, PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl( effect_cast, 0, pos )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		EmitSoundOnLocationWithCaster( pos, sound_end, caster )
	else
		caster:StopSound("Hero_StormSpirit.BallLightning.Loop")
		caster:StopSound("Hero_StormSpirit.BallLightning")
	
	end


	ProjectileManager:ProjectileDodge(caster) --弹道躲闪
	FindClearSpaceForUnit( caster,pos, true )

	GridNav:DestroyTreesAroundPoint(pos, 250, true)

	--圣物：翁加，寒冬巨刃
	local artifact_4 = caster:FindModifierByName("modifier_item_hd_ice_bite_effects")
	if artifact_4 and artifact_4.level >= 30 then
		artifact_4:ApplyWindPressure()
	end
end


function modifier_Default_Move:GetEffectAttachType()
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_Default_Move:DeclareFunctions()
	local funcs	=	{
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, --免疫物理
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,  --免疫魔法
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,     --免疫纯粹
	}
	return funcs
end


function modifier_Default_Move:GetAbsoluteNoDamagePhysical()return 1 end
function modifier_Default_Move:GetAbsoluteNoDamageMagical()return 1 end
function modifier_Default_Move:GetAbsoluteNoDamagePure()return 1 end

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------以下是特殊内容modifier-------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
modifier_dalaoban_jineng = advanced_modifier({})

function modifier_dalaoban_jineng:IsDebuff() return false end
function modifier_dalaoban_jineng:IsHidden() return true end
function modifier_dalaoban_jineng:IsPurgable() return false end
function modifier_dalaoban_jineng:RemoveOnDeath() return false end
function modifier_dalaoban_jineng:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount,
    }
end

function modifier_dalaoban_jineng:Advanced_GetChaotic_Era_Spell_GenerateCount()
	return 3
end

-------------------------------------------------------------------------------------------------------------------
modifier_masters_players = advanced_modifier({})
function modifier_masters_players:GetTexture() return "dark_seer/ds_2022_immortal/ds_2022_immortal_wall_of_replica" end
function modifier_masters_players:IsDebuff() return false end
function modifier_masters_players:IsHidden() return false end
function modifier_masters_players:IsPurgable() return false end
function modifier_masters_players:RemoveOnDeath() return false end
function modifier_masters_players:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_masters_players:GetEffectName() return "particles/rebuild/particle_effect/attach_92/effect_lv2_buff_beams.vpcf" end
function modifier_masters_players:OnCreated()
    if not IsServer() then return end
	self:GetParent():AddItemByName("item_hd_dust")
end

---------------------------------------------------------------------------------------------------------------------
modifier_stage20_bonus = advanced_modifier({})

function modifier_stage20_bonus:IsDebuff() return false end
function modifier_stage20_bonus:IsHidden() return true end
function modifier_stage20_bonus:IsPurgable() return false end
function modifier_stage20_bonus:RemoveOnDeath() return false end
function modifier_stage20_bonus:OnCreated()
	
	self.trigger = false
	if IsServer() then
		self:StartIntervalThink(0.5)
		--成就cy syd
		if tostring(PlayerResource:GetSteamID(self:GetParent():GetPlayerOwnerID()))=="76561198097596443" then
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_masters_players",{})
		end
	end
end

function modifier_stage20_bonus:OnIntervalThink()

	if Game_State:IsInChaoticEra() and self.trigger == false then
        -- 乱纪元信件
		self:GetParent():AddItemByName("item_chaotic_class_choice")
		self.trigger = true
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chaotic_buff", {})
		--定制cy当0当1不如当3
		if tostring(PlayerResource:GetSteamID(self:GetParent():GetPlayerOwnerID()))=="76561198160215930" then
			--print("ID通过，定制生效")
			local monster_numbers = self:GetParent():AddNewModifier(nil,nil,"modifier_revtel_investments",{})--兵营
			local monster_gold = self:GetParent():AddNewModifier(nil,nil,"modifier_artifact_barracks",{})--资产
			local monster_up = self:GetParent():AddNewModifier(nil,nil,"modifier_word_step_to_the_top",{})--巅峰
			local monster_slow = self:GetParent():AddNewModifier(nil,nil,"modifier_word_bulky",{})--笨重
			--local monster_lost = self:GetParent():AddNewModifier(nil,nil,"modifier_forgotten_individuals",{})--遗忘
			--local monster_break = self:GetParent():AddNewModifier(nil,nil,"modifier_the_more_the_better",{})--多多2

			monster_numbers:SetStackCount(5)
			monster_gold:SetStackCount(5)
			monster_up:SetStackCount(5)
			monster_slow:SetStackCount(5)
			--monster_lost:SetStackCount(5)
			--monster_break:SetStackCount(2)

			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_dalaoban_jineng",{})
			--print("状态添加完成")
		end
		--定制cy奶爸
		if tostring(PlayerResource:GetSteamID(self:GetParent():GetPlayerOwnerID()))=="76561199144907040" then
			local monster_numbers = self:GetParent():AddNewModifier(nil,nil,"modifier_revtel_investments",{})--兵营
			local monster_gold = self:GetParent():AddNewModifier(nil,nil,"modifier_artifact_barracks",{})--资产

			monster_numbers:SetStackCount(3)
			monster_gold:SetStackCount(3)
	
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_dalaoban_jineng",{})
		end
		
		self:StartIntervalThink(-1)
    end
end

function modifier_stage20_bonus:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
end

function modifier_stage20_bonus:OnWaveEnd()
	if IsServer() and _G.GAME_ROUND == 20 and  _G.GAME_END_WAVE_Trigger == true then
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_hd_Treasure5_oblation",{})
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_hd_Treasure4_oblation",{})
	end
end

-------------------------------------------------------------------------------------------------------------------
------乱基础属性调整
---1力=30血+0.15回血
---1敏=0.1护甲+0.6攻速
---1智=12蓝+0.05回蓝→→→→12蓝+0.05回蓝+0.07%技能增强+0.06%冷却缩减（至多到80%，40%）

modifier_chaotic_buff = advanced_modifier({})

function modifier_chaotic_buff:IsDebuff() return false end
function modifier_chaotic_buff:IsHidden() return false end
function modifier_chaotic_buff:IsPurgable() return false end
function modifier_chaotic_buff:RemoveOnDeath() return false end
function modifier_chaotic_buff:OnCreated()
	self.parent = self:GetParent()
	self.cd = math.min(self.parent:GetIntellect(false)* 0.03,30)
	self.move = 100
	self:StartIntervalThink(2)
end

function modifier_chaotic_buff:OnIntervalThink()
	self.cd = math.min(self.parent:GetIntellect(false)* 0.03,30)
	self.move = 100
end

function modifier_chaotic_buff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM,
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		MODIFIER_EVENT_ON_ChaoticEraRoundChange={nil,nil},
		MODIFIER_EVENT_ON_DEATH = {nil,nil},
		MODIFIER_SPECIAL_ChaoticEra_GetAdditionalShopItem = {self:GetParent(),nil},
	}
	return funcs
end
function modifier_chaotic_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_chaotic_buff:GetChaoticEraAdditionalShopItem(keys)
  local list = {}
  local data = {
    item_name = "item_chaotic_class_choice_later",
    cost = 4000,
    type = "special",
    level  = 1,
  }
  table.insert(list,data)
  return list
end
function modifier_chaotic_buff:OnChaoticEraRoundChange(keys)
    local round = keys.round
	local classlevel = math.min(math.floor(round/3), 9)
	if round%3 == 0 then
		self:GetParent():AddItemByName("item_chaotic_skill_book_"..classlevel)
	end
end
function modifier_chaotic_buff:OnDeath(keys)
	if not IsServer() then return end
	local unit = keys.unit
	local parent = self:GetParent()
	if not IsEnemy(unit, parent) then return end
	
	local skill_book_chance = 1
	local skill_book_general_chance = 1
	local round = GetWave()
	if round <= 8 then
		skill_book_chance = 18
		skill_book_general_chance = 5
	elseif round > 8 and round <= 16 then
		skill_book_chance = 15
		skill_book_general_chance = 5
	elseif round >16  and round <= 24 then
		skill_book_chance = 12
		skill_book_general_chance = 5
	elseif round > 24 and round <= 35 then
		skill_book_chance = 6
		skill_book_general_chance = 3
	elseif round > 30 and round <= 35 then
		skill_book_chance = 1
		skill_book_general_chance = 1
	end
	if parent:HasModifier("modifier_novice_player") then
		skill_book_chance = skill_book_chance + 2
		skill_book_general_chance = skill_book_general_chance + 1
	end

	if skill_book_chance >= math.random(1,1000) then
		local item = CreateItem( "item_chaotic_skill_book_random_rune", nil, nil )
		local drop = CreateItemOnPositionSync( parent:GetAbsOrigin(), item )
        self.base_target = parent:GetAbsOrigin()
        self.vector = self.base_target
        self.dropTarget = GetClearSpaceForUnit(parent, self.vector)
    
        item:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
        local pos = item:GetContainer():GetAbsOrigin()
        if pos then
            local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
            ParticleManager:SetParticleControl(pfx_max, 0, pos)
            ParticleManager:SetParticleControl(pfx_max, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx_max)
        end
        local gameEvent={}
        gameEvent["message"] = "#DOTA_HUD_skill_book_drow_info"
		gameEvent["player_id"] = parent:GetPlayerOwnerID()
        gameEvent["locstring_value"] = "#DOTA_Tooltip_ability_"..item:GetAbilityName()
        gameEvent["teamnumber"] = -1
        FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if skill_book_general_chance > 0 then
		if skill_book_general_chance >= math.random(1,1000) then
			local item = CreateItem( "item_chaotic_skill_book_random_general", nil, nil )
			local drop = CreateItemOnPositionSync( parent:GetAbsOrigin(), item )
			self.base_target = parent:GetAbsOrigin()
			self.vector = self.base_target
			self.dropTarget = GetClearSpaceForUnit(parent, self.vector)
		
			item:LaunchLootInitialHeight( false, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边
			local pos = item:GetContainer():GetAbsOrigin()
			if pos then
				local pfx_max = ParticleManager:CreateParticle("particles/neutral_fx/neutral_item_drop_lvl5.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(pfx_max, false)
				ParticleManager:SetParticleControl(pfx_max, 0, pos)
				ParticleManager:SetParticleControl(pfx_max, 1, pos)
				ParticleManager:ReleaseParticleIndex(pfx_max)
			end
			local gameEvent={}
			gameEvent["message"] = "#DOTA_HUD_skill_book_drow_info"
			gameEvent["player_id"] = parent:GetPlayerOwnerID()
			gameEvent["locstring_value"] = "#DOTA_Tooltip_ability_"..item:GetAbilityName()
			gameEvent["teamnumber"] = -1
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end
end
function modifier_chaotic_buff:GetModifierMoveSpeedBonus_Constant()
	return self.move
end
function modifier_chaotic_buff:Advanced_GetModifierCooldownReduction()
	return self.cd
end
function modifier_chaotic_buff:Advanced_GetModifierIncomingDamage_Percentage()
	if IsServer() then
		if not self.parent:IsRangedAttacker() then
			return -20
		end
	end
	return 
end
function modifier_chaotic_buff:AdvancedGetModifierExtraHealthPercentage()
	if not self.parent:IsRangedAttacker() then
		return 15
	end
end
function modifier_chaotic_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		local lvl = self.parent:GetLevel()
		if lvl <= 15 then
			return lvl*2.75
		end
		if lvl >= 16 and lvl <=30 then
			return lvl*2.25
		end
		if lvl >= 31 then
			return lvl*1.25
		end
	end
end
function modifier_chaotic_buff:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	local parent = self:GetParent()
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

	return 16 + parent:GetLevel()*0.3
end

-- function modifier_chaotic_buff:OnAttack(keys)
-- 	if not IsServer() then
-- 		return 
-- 	end
--     local attacker = keys.attacker
--     if attacker ~= self:GetParent() then
-- 		return
-- 	end
-- 	if not attacker:IsRangedAttacker() then
-- 		return
-- 	end
-- 	if attacker:IsInSpecialAttack() then return end
	
-- 	if keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and self:GetAbility():IsTrained() then	

-- 		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange()+53, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
-- 		local target_number = 0
        
-- 		local modifier_keys = {
-- 			duration = 0.1,
-- 			iSpecialAttack = 1,
-- 			iDisableApplyModifier = 1,
-- 			iDisableCleave =1,
-- 			iDisableSplit = 1,
-- 		}

-- 		local attackEffectRecord =attacker:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
-- 		for _, enemy in pairs(enemies) do
-- 			if enemy ~= keys.target then
-- 				attacker.split_shot_target = true
-- 				attacker:PerformAttack(enemy, false, false, true, false, true, false, false)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
-- 				attacker.split_shot_target = false
					
-- 				target_number = target_number + 1
				
-- 				if target_number >= 1 then
-- 					break
-- 				end
-- 			end
-- 		end
-- 		if IsValid(attackEffectRecord) then
-- 			attackEffectRecord:Destroy()
-- 		end
-- 		return
-- 	end
-- end
function modifier_chaotic_buff:OnAttackLanded(keys)
    if not IsServer() then
        return
    end
	local attacker = keys.attacker
	local ability = self:GetAbility()
    if attacker ~= self:GetParent() then return end
	if attacker:IsInSpecialAttack() then return end
    local cleave_pct = 0.4
	if attacker:IsRangedAttacker() then
		cleave_pct = 0.3
	end

	local modifier = attacker:FindModifierByName("modifier_item_hd_woodknife_effects")
	if modifier and modifier.cleave_10 then
		cleave_pct = cleave_pct + modifier.cleave_10
	end
	--OnAttackLanded中，original_damage=damage，且为开始伤害计算前的数值（用人话说就是（攻击力+临时攻击力*暴击+普通附加伤害），不涉及任何护甲、增伤减伤等计算
	local cleave_damage = keys.damage * cleave_pct
	-- print("攻击暴击伤害"..keys.damage.."×分裂倍数"..cleave_pct.."=分裂伤害"..cleave_damage)
	local target = keys.target
    local number = 6

	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do
		if enemy ~= target then
			AttackCleaveDelay(attacker, enemy, ability, cleave_damage)
			i = i +1 
			if i >= number then
				break
			end
		end
	end
end
