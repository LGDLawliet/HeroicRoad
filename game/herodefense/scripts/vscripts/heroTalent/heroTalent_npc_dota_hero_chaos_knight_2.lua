heroTalent_npc_dota_hero_chaos_knight_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_chaos_knight_2", "heroTalent/heroTalent_npc_dota_hero_chaos_knight_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_chaos_knight_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_chaos_knight_2"
end

function heroTalent_npc_dota_hero_chaos_knight_2:OnHeroLevelUp()
	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	self:ChaosAtb()

	if not self.check then
		if caster:GetLevel() >= self:GetSpecialValueFor("level") then
			for i=1, self:GetSpecialValueFor("count") do
				caster:AddItemByName("item_hd_risk_dice")
			end
			self.check = true
		end
	end
end

function heroTalent_npc_dota_hero_chaos_knight_2:ChaosAtb()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local ability = self

	local down_pct = ability:GetSpecialValueFor("down_pct") * 0.01
	local trans_pct = ability:GetSpecialValueFor("trans_pct") * 0.01


	local str = caster:GetBaseStrength()
	local agi = caster:GetBaseAgility()
	local int = caster:GetBaseIntellect()


	local roll = RandomInt(1, 3)

	local pool = 0

	if roll == 1 then
		local agi_loss = agi * down_pct
		local int_loss = int * down_pct
		
		pool = agi_loss + int_loss
		
		caster:SetBaseAgility(agi - agi_loss)
		caster:SetBaseIntellect(int - int_loss)
		caster:SetBaseStrength(str + (pool * trans_pct))
		
		print("敏捷-" .. agi_loss .. " 智力-" .. int_loss .. " 力量+" .. (pool * trans_pct))

	elseif roll == 2 then
		local str_loss = str * down_pct
		local int_loss = int * down_pct
		
		pool = str_loss + int_loss
		
		caster:SetBaseStrength(str - str_loss)
		caster:SetBaseIntellect(int - int_loss)
		caster:SetBaseAgility(agi + (pool * trans_pct))
		
		print("力量-" .. str_loss .. " 智力-" .. int_loss .. " 敏捷+" .. (pool * trans_pct))
	else
		local str_loss = str * down_pct
		local agi_loss = agi * down_pct
		
		pool = str_loss + agi_loss
		
		caster:SetBaseStrength(str - str_loss)
		caster:SetBaseAgility(agi - agi_loss)
		caster:SetBaseIntellect(int + (pool * trans_pct))
		
		print("力量-" .. str_loss .. " 敏捷-" .. agi_loss .. " 智力+" .. (pool * trans_pct))
	end
    
    caster:CalculateStatBonus(true)
end