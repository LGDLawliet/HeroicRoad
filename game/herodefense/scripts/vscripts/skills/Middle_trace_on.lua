local trace_equipment = {
	level1 = {
		"item_hd_trace_speed1",
		"item_hd_trace_power1",
		"item_hd_trace_defense1",
        "item_hd_trace_spell1",
	},
	level2 = {
        "item_hd_trace_speed2",
		"item_hd_trace_power2",
		"item_hd_trace_defense2",
        "item_hd_trace_spell2",
	},
	level3 = {
        "item_hd_trace_speed3",
		"item_hd_trace_power3",
		"item_hd_trace_defense3",
        "item_hd_trace_spell3",
	},


}--随机投影结果表


function GiveRandomLevel(level)
    local bonus_level = level
    local random_index = RandomInt(1, 1000)
    local now_index = 0
	-- DeepPrint(level)


    for i = 1, #bonus_level-1, 1 do
        now_index = now_index+bonus_level[i]
        if now_index>=random_index and random_index<=now_index+bonus_level[i+1] then
            return i
        end
    end
	return 1
    
end--取随机数，1000代表三位如50.5%（505之于1000）
-----------------------------------------------------------------------------------------------------------------

Middle_trace_on = class({})

LinkLuaModifier("modifier_Middle_trace_on", "skills/Middle_trace_on", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function Middle_trace_on:GetIntrinsicModifierName()
	return "modifier_Middle_trace_on"
end


modifier_Middle_trace_on = advanced_modifier({})

function modifier_Middle_trace_on:IsDebuff() return false end
function modifier_Middle_trace_on:IsHidden() return true end
function modifier_Middle_trace_on:IsPurgable() return false end


function modifier_Middle_trace_on:OnCreated(keys)
    self.ability = self:GetAbility()
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.chance = self.ability:GetSpecialValueFor("chance")
    if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self:StartIntervalThink(0.5)
	end
end

function modifier_Middle_trace_on:OnIntervalThink()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() and Game_State:IsInBattle() then
        --if self:GetAbility():IsCooldownReady() then

            local level1 = self:GetAbility():GetSpecialValueFor("level1")*10
            local level2 = self:GetAbility():GetSpecialValueFor("level2")*10
            local level3 = self:GetAbility():GetSpecialValueFor("level3")*10
            local level4 = 0
            
            local level = {
                level1,
                level2,
                level3,
                level4,
            }

            local string = "level"..GiveRandomLevel(level)
            local TraceClass = trace_equipment[string]
            --self:GetCaster():AddItemByName(TraceClass[RandomInt(1, #TraceClass)])

            --------

			--local newItem = CreateItem( "item_mana_potion", nil, nil )


            local newItem = CreateItem( TraceClass[RandomInt(1, #TraceClass)], nil, nil )
			local drop = CreateItemOnPositionSync( self:GetCaster():GetAbsOrigin(), newItem )

            local friendly_heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			for _, friendly_hero in ipairs(friendly_heros) do
				if friendly_hero~=self:GetParent() then
					self.closest_hero = friendly_hero
					break
				end
			end

            if self:GetAbility():GetAutoCastState() and self.closest_hero ~= nil then
                self.base_target = self.closest_hero:GetAbsOrigin()
            else
                self.base_target = self:GetCaster():GetAbsOrigin()
            end

			self.vector = self.base_target + RandomVector( RandomFloat( 500,600 ) ) --产生一个新坐标
			self.dropTarget = GetClearSpaceForUnit(self:GetCaster(), self.vector)

			newItem:LaunchLootInitialHeight( true, 50 , 50 , 0.1 , self.dropTarget )   --丢过去 传入是否自动拾取 高度  时间 左边

            if self.chance <= RandomInt(0, 100)then
                self:GetAbility():StartCooldown(30)
            end
			
			local item = newItem:GetContainer()
			Timers:CreateTimer(self.duration, function()--超出时间未拾取，道具消失

				if item and not item:IsNull() then
					local hContainedItem = item:GetContainedItem()  --由绑定单位获取到道具实体
					if hContainedItem  then
						local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/spring_2021/blink_dagger_spring_2021_start_sparkles.vpcf", PATTACH_CUSTOMORIGIN, nil ) 
						ParticleManager:SetParticleControl( nFXIndex, 0, item:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
						EmitSoundOn( "Hero_QueenOfPain.Blink_in", item )
						UTIL_Remove( item )

					end
				end
			end)
		end

	end
end
