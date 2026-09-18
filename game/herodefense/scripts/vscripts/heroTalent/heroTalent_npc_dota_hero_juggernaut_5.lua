LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_juggernaut_5", "heroTalent/heroTalent_npc_dota_hero_juggernaut_5.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heroTalent_npc_dota_hero_juggernaut_5 == nil then
	heroTalent_npc_dota_hero_juggernaut_5 = class({})
end

function heroTalent_npc_dota_hero_juggernaut_5:OnSpellStart()
	local caster = self:GetCaster()
	-- [[local side = 300
	-- local number = 1 --设置怪物生成数量
	-- local min_index = 1000  --词条强化最小系数
	-- local max_index =1000  --词条强化最大系数
	-- local gain_class = GAIN_CLASS_ENDLESS           --词条库
	-- local health_bar_type = 0
	-- CreatePortalSPawner("npc_monster_challenge_002",1,number,
	-- caster:GetAbsOrigin(),--这是坐标点 第一个随机是哪个区域（水晶，森林，虚空），第二个参数随机1-7，然后取表中的KV
	-- nil,side,0,--生成传送门
	-- min_index,max_index,        --词条强化最小系数与最大系数
	-- gain_class,             --词条的库
	-- 4,  --难度系数，通常由苦难挑战添加
	-- nil,
	-- 0,--血条类型
	-- wave--无尽波数
	-- ) --生成传送门]]
	-- local initStack = self:GetStackCount()
	-- if IsServer() then
	-- 	self.tmpvar = 12
	-- end
	-- self:SetStackCount(self.tmpvar)
	-- if IsClient() then
	-- 	self.tmpvar = self:GetStackCount()
	-- end
	-- self:SetStackCount(initStack)
	caster:AddSkillPoints(25)
	uimanager:RefreshTalentTree(caster:GetPlayerID())
	uimanager:OpenTalentTree(caster:GetPlayerID())
	--caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_juggernaut_5", {duration = 1})
end

---------------------------------------------------------------------
--Modifiers
if modifier_heroTalent_npc_dota_hero_juggernaut_5 == nil then
	modifier_heroTalent_npc_dota_hero_juggernaut_5 = advanced_modifier({})
end
function modifier_heroTalent_npc_dota_hero_juggernaut_5:OnCreated(params)
	if IsServer() then
	end
	self.flag = false
	
end
function modifier_heroTalent_npc_dota_hero_juggernaut_5:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_juggernaut_5:OnDestroy()
	if IsServer() then
	end
end
function modifier_heroTalent_npc_dota_hero_juggernaut_5:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()},
	}
end

function modifier_heroTalent_npc_dota_hero_juggernaut_5:AdvancedGetModifierTotal_ConstantBlock(keys)
	return keys.damage
end
function modifier_heroTalent_npc_dota_hero_juggernaut_5:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_ROOTED] = true, } end
function modifier_heroTalent_npc_dota_hero_juggernaut_5:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
	if not self.flag then
		self.start_high = self:GetParent():GetAbsOrigin().z
		self.high = self.start_high
		self.end_high = self.start_high + 1000
		self.forward = "up"
		self:StartIntervalThink(FrameTime())
		self.flag = true
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT,0.3)
	end
	
end

function modifier_heroTalent_npc_dota_hero_juggernaut_5:OnIntervalThink()
	if self.high <= self.end_high and self.forward == "up" then
		self:GetParent():SetAbsOrigin(Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, self.high))
		self.high = self.high + 30
		if self.high >= self.end_high - 5 then
			self.forward = "down"
		end
	end
	if self.high >= self.start_high and self.forward == "down" then
		self:GetParent():SetAbsOrigin(Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, self.high))
		self.high = self.high - 40 
		if self.high <= self.start_high + 5 then
			self.forward = "over"
		end
	end
	if self.forward == "over" then
		local nearby_enemy_units = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(), 
            self:GetParent():GetAbsOrigin(), 
            nil, 
            150, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            FIND_CLOSEST, 
            false
        )
			if #nearby_enemy_units > 0 then
				for i = 1, math.min(#nearby_enemy_units, 5), 1 do
					local damageTable = {
						victim = nearby_enemy_units[i],
						attacker = self:GetParent(),
						damage = self:GetParent():GetAverageTrueAttackDamage(nil)*5,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self, --Optional.
						hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
					}
					ApplyDamage(damageTable)
				end
			end
		self:GetParent():RemoveGesture(ACT_DOTA_ATTACK_EVENT)
		self:SafeDestroy()
		return nil
	end
	self:SetDuration(1,true)
	return FrameTime()
end