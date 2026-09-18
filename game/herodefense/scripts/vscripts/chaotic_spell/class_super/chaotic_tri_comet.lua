
chaotic_tri_comet = class({})
LinkLuaModifier("modifier_chaotic_tri_comet", "chaotic_spell/class_super/chaotic_tri_comet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_comet_coming", "chaotic_spell/class_super/chaotic_tri_comet", LUA_MODIFIER_MOTION_NONE)

function chaotic_tri_comet:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_tri_comet/fly_effect/fly_effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_tri_comet/blast_effect.vpcf", context )
end

function chaotic_tri_comet:GetIntrinsicModifierName()
	return "modifier_chaotic_tri_comet"
end
function chaotic_tri_comet:GetManaCost()
	return self:GetSpecialValueFor("mana_cost")
end
function chaotic_tri_comet:GetCastRange ()
	return self:GetSpecialValueFor("find_radius")  - self:GetCaster():GetCastRangeBonus()
end

-----------------------------------------------------------
modifier_chaotic_tri_comet = advanced_modifier({})

function modifier_chaotic_tri_comet:IsHidden() return true end
function modifier_chaotic_tri_comet:IsPurgable() return false end
function modifier_chaotic_tri_comet:IsPurgeException() return false end
function modifier_chaotic_tri_comet:IsDebuff() return false end

function modifier_chaotic_tri_comet:OnCreated(keys)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

	if IsServer() then
        self.mana_cost = self.ability:GetManaCost(self.ability:GetLevel())
		self.cost = self.ability:GetSpecialValueFor("cost") 
        self.damage = self.ability:GetSpecialValueFor("damage")
        self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
        self.find_radius = self.ability:GetSpecialValueFor("find_radius")
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.duration = self.ability:GetSpecialValueFor("duration")
        self.count = self.ability:GetSpecialValueFor("count")

        if self.ability:GetRuneType() == 1 then
            self.count = self.count - self.ability:GetSpecialValueFor("rune_1_count")
            self.radius = self.radius - self.ability:GetSpecialValueFor("rune_1_radius")
            self.damage = self.damage * (1-self.ability:GetSpecialValueFor("rune_1_damage")*0.01)
            self.bonus_damage = self.bonus_damage * (1-self.ability:GetSpecialValueFor("rune_1_damage")*0.01)
        end

        if self.ability:GetRuneType() == 2 then
            self.damage = self.damage * (1+self.ability:GetSpecialValueFor("rune_2_damage")*0.01)
            self.bonus_damage = self.bonus_damage * (1+self.ability:GetSpecialValueFor("rune_2_damage")*0.01)
        end

        self:StartIntervalThink(0.1)
	end
end

function modifier_chaotic_tri_comet:OnRefresh(keys)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()

	if IsServer() then
        self.mana_cost = self.ability:GetManaCost(self.ability:GetLevel())
		self.cost = self.ability:GetSpecialValueFor("cost") 
        self.damage = self.ability:GetSpecialValueFor("damage")
        self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
        self.find_radius = self.ability:GetSpecialValueFor("find_radius")
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.duration = self.ability:GetSpecialValueFor("duration")
        self.count = self.ability:GetSpecialValueFor("count")
        self.cooldown = self.ability:GetSpecialValueFor("cooldown")

        if self.ability:GetRuneType() == 1 then
            self.count = self.count - self.ability:GetSpecialValueFor("rune_1_count")
            self.radius = self.radius - self.ability:GetSpecialValueFor("rune_1_radius")
            self.damage = self.damage * (1-self.ability:GetSpecialValueFor("rune_1_damage")*0.01)
            self.bonus_damage = self.bonus_damage * (1-self.ability:GetSpecialValueFor("rune_1_damage")*0.01)
        end
        if self.ability:GetRuneType() == 2 then
            self.damage = self.damage * (1+self.ability:GetSpecialValueFor("rune_2_damage")*0.01)
            self.bonus_damage = self.bonus_damage * (1+self.ability:GetSpecialValueFor("rune_2_damage")*0.01)
        end

	end
end

function modifier_chaotic_tri_comet:OnIntervalThink()
    if not self.ability:GetAutoCastState() then return end
    if not self.caster:IsAlive() then return end
    if not self.ability:IsCooldownReady() then return end

    local trigger = self.caster:FindModifierByName("modifier_hd_trigger")
	if trigger and trigger:GetStackCount() >= self.cost then
        local damage = self.damage + self.bonus_damage*self.parent:HDGetPrimaryStatValue()
        local targets = {}
        local enemies = FindUnitsInRadius(
            self.caster:GetTeamNumber(), 
            self.caster:GetOrigin(), 
            nil, 
            self.find_radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false
        )
        if #enemies <= 0 then return end
        for _,enemy in pairs(enemies) do
            if self.ability:GetRuneType() == 2 then
                if enemy:HasModifier("modifier_hd_freezing_frozen") then
                    table.insert(targets, enemy)
                end
            else
                if enemy:HasModifier("modifier_hd_freezing") then
                    table.insert(targets, enemy)
                end
            end
        end
        if #targets <= 0 then return end
        
        trigger:SetStackCount(trigger:GetStackCount() - self.cost)
        self.ability:StartCooldown(self.cooldown)

        for i,enemy in pairs(targets) do
            self:CometComming({
                pos = enemy:GetOrigin(), 
                radius = self.radius,
                damage = damage,
            })
            if i >= self.count then break end
        end

    elseif self.ability:IsOwnersManaEnough() then
        local damage = self.damage + self.bonus_damage*self.parent:HDGetPrimaryStatValue()
        local targets = {}
        local enemies = FindUnitsInRadius(
            self.caster:GetTeamNumber(), 
            self.caster:GetOrigin(), 
            nil, 
            self.find_radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false
        )
        if #enemies <= 0 then return end
        for _,enemy in pairs(enemies) do
            if self.ability:GetRuneType() == 2 then
                if enemy:HasModifier("modifier_hd_freezing_frozen") then
                    table.insert(targets, enemy)
                end
            else
                if enemy:HasModifier("modifier_hd_freezing") then
                    table.insert(targets, enemy)
                end
            end
        end
        if #targets <= 0 then return end
        
        self.caster:SpendMana(self.ability:GetManaCost(self.ability:GetLevel()), self.ability)
        self.ability:StartCooldown(self.cooldown*2)

        for i,enemy in pairs(targets) do
            self:CometComming({
                pos = enemy:GetOrigin(), 
                radius = self.radius,
                damage = damage
            })
            if i >= self.count then break end
        end
    end
end

--pos 目标区域
--radius 爆炸范围
--damage 算好了的伤害
function modifier_chaotic_tri_comet:CometComming(keys)
    if not IsServer() then return end
    if not keys.pos then return end
    if not self:GetAbility() then return end

	local pos = keys.pos
	
	if self.ability:GetRuneType() == 1 then
		-- 产生3个彗星：主目标位置一个，以及在半径为400的圆内随机取一个直径的两端各一个额外彗星
		CreateModifierThinker(self.caster, self.ability, "modifier_chaotic_tri_comet_coming", {
			duration = 0.3,
			radius = keys.radius,
			damage = keys.damage,
		}, 
		pos, 
		self.caster:GetTeamNumber(), 
		false
		)
		
		-- 随机生成一个角度以确定直径方向
		local angle = RandomFloat(0, 2 * math.pi)
		local radius = 400 -- 半径为400的圆
		
		-- 计算直径两端的位置
		local endpoint1 = Vector(
			pos.x + radius * math.cos(angle),
			pos.y + radius * math.sin(angle),
			pos.z
		)
		
		local endpoint2 = Vector(
			pos.x - radius * math.cos(angle),
			pos.y - radius * math.sin(angle),
			pos.z
		)
		
		-- 延迟0.2秒创建两个额外的彗星
		self.caster:GameTimer(0.1, function()
            if not self or not self.ability then return end
			-- 在直径第一个端点处创建彗星
			CreateModifierThinker(self.caster, self.ability, "modifier_chaotic_tri_comet_coming", {
				duration = 0.3,
				radius = keys.radius,
				damage = keys.damage,
			}, 
			endpoint1, 
			self.caster:GetTeamNumber(), 
			false
			)
			
			-- 在直径第二个端点处创建彗星
			CreateModifierThinker(self.caster, self.ability, "modifier_chaotic_tri_comet_coming", {
				duration = 0.3,
				radius = keys.radius,
				damage = keys.damage,
			}, 
			endpoint2, 
			self.caster:GetTeamNumber(), 
			false
			)
		end)
	else
		-- 原有的单个彗星逻辑
		CreateModifierThinker(self.caster, self.ability, "modifier_chaotic_tri_comet_coming", {
			duration = 0.3,
			radius = keys.radius,
			damage = keys.damage,
		}, 
		pos, 
		self.caster:GetTeamNumber(), 
		false
		)
	end
end


modifier_chaotic_tri_comet_coming = advanced_modifier({})

function modifier_chaotic_tri_comet_coming:OnCreated(keys)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.duration = self.ability:GetSpecialValueFor("duration")

	if IsServer() then
		self.radius = keys.radius

        self.damagetable = {
            attacker = self.caster,
            damage = keys.damage,
            damage_type = self.ability:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
            ability = self.ability,
        }

        local dir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
        local parent = self:GetParent()
        local pos = parent:GetAbsOrigin()
        local pfx_name = "particles/rebuild/chaotic_spell/chaotic_tri_comet/fly_effect/fly_effect.vpcf"
        local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, pos+dir*400+Vector(0,0,1500))
        ParticleManager:SetParticleControl(pfx, 1, pos)
        ParticleManager:SetParticleControlForward(pfx, 1, -dir)
        ParticleManager:SetParticleControl(pfx, 2, Vector(0.3,0,0))
        ParticleManager:SetParticleControl(pfx, 61, Vector(0,1,0))
        ParticleManager:ReleaseParticleIndex(pfx)
        parent:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
        end
end



function modifier_chaotic_tri_comet_coming:OnDestroy()
    if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability then
			return
		end

		parent:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
		local pfx_name = "particles/rebuild/chaotic_spell/chaotic_tri_comet/blast_effect.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0,parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 3,parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 60,Vector(self.radius,0,0))
		ParticleManager:ReleaseParticleIndex(pfx)


		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		local frozen_duration = self.duration*caster:GetModifierStatusNegativeGainIndex(0.7)
		for _, enemy in ipairs(enemies) do
            enemy:ApplyMergeDamage(self.damagetable)
            if enemy:IsAlive() and self.ability:GetRuneType() ~= 2 then
                enemy:AddNewModifier(caster, ability, "modifier_hd_freezing_frozen", {
                    duration = frozen_duration*enemy:GetHDStatusResistanceIndex(0.5),
                })
            end
		end

		ScreenShake(self:GetParent():GetOrigin(), 100.0, 100.0, 0.3, 1200.0, 0, true )
		UTIL_Remove(self:GetParent())
	end
end