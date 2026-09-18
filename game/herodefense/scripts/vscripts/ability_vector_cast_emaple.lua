--//替换 "particles/ui_mouseactions/range_finder_cone.vpcf" 路径下的原版特效
--[[
<!-- kv3 encoding:text:version{e21c7f3c-8a33-41c5-9977-a76d3a32aa0d} format:vpcf61:version{39d3ce1d-9442-4407-9b78-8317145b1732} -->
{
	_class = "CParticleSystemDefinition"
	m_bShouldHitboxesFallbackToRenderBounds = false
	m_nMaxParticles = 1
	m_flConstantRadius = 15.0
	m_ConstantColor = [ 255, 0, 0, 255 ]
	m_nBehaviorVersion = 12
	m_nInitialParticles = 1
	m_controlPointConfigurations =
	[
		{
			m_name = "preview"
		},
	]
	m_PreEmissionOperators =
	[
		{
			_class = "C_OP_DistanceBetweenCPsToCP"
			m_nStartCP = 1
			m_nEndCP = 2
			m_nOutputCP = 10
			m_flInputMin = 1.0
			m_flInputMax = 2.0
			m_flOutputMax = 4.0
		},
		{
			_class = "C_OP_SelectivelyEnableChildren"
			m_nNumChildrenToEnable =
			{
				m_nType = "PF_TYPE_CONTROL_POINT_COMPONENT"
				m_nMapType = "PF_MAP_TYPE_DIRECT"
				m_flLiteralValue = 1.0
				m_NamedValue = ""
				m_nControlPoint = 10
				m_nScalarAttribute = 3
				m_nVectorAttribute = 6
				m_nVectorComponent = 0
				m_flRandomMin = 0.0
				m_flRandomMax = 1.0
				m_bHasRandomSignFlip = false
				m_nRandomSeed = -1
				m_nRandomMode = "PF_RANDOM_MODE_CONSTANT"
				m_flLOD0 = 0.0
				m_flLOD1 = 0.0
				m_flLOD2 = 0.0
				m_flLOD3 = 0.0
				m_nNoiseInputVectorAttribute = 0
				m_flNoiseOutputMin = 0.0
				m_flNoiseOutputMax = 1.0
				m_flNoiseScale = 0.1
				m_vecNoiseOffsetRate = [ 0.0, 0.0, 0.0 ]
				m_flNoiseOffset = 0.0
				m_nNoiseOctaves = 1
				m_nNoiseTurbulence = "PF_NOISE_TURB_NONE"
				m_nNoiseType = "PF_NOISE_TYPE_PERLIN"
				m_nNoiseModifier = "PF_NOISE_MODIFIER_NONE"
				m_flNoiseTurbulenceScale = 1.0
				m_flNoiseTurbulenceMix = 0.5
				m_flNoiseImgPreviewScale = 1.0
				m_bNoiseImgPreviewLive = true
				m_flNoCameraFallback = 0.0
				m_bUseBoundsCenter = false
				m_nInputMode = "PF_INPUT_MODE_CLAMPED"
				m_flMultFactor = 1.0
				m_flInput0 = 0.0
				m_flInput1 = 1.0
				m_flOutput0 = 0.0
				m_flOutput1 = 1.0
				m_flNotchedRangeMin = 0.0
				m_flNotchedRangeMax = 1.0
				m_flNotchedOutputOutside = 0.0
				m_flNotchedOutputInside = 1.0
				m_nRoundType = "PF_ROUND_TYPE_NEAREST"
				m_nBiasType = "PF_BIAS_TYPE_STANDARD"
				m_flBiasParameter = 0.0
				m_Curve =
				{
					m_spline = [  ]
					m_tangents = [  ]
					m_vDomainMins = [ 0.0, 0.0 ]
					m_vDomainMaxs = [ 0.0, 0.0 ]
				}
			}
		},
	]
	m_Operators =
	[
		{
			_class = "C_OP_EndCapTimedDecay"
		},
	]
	m_Children =
	[
		{
			m_ChildRef = resource:"particles/ui_mouseactions/range_finder_cone_body.vpcf"
		},
		{
			m_ChildRef = resource:"particles/ui_mouseactions/range_finder_cone_end.vpcf"
		},
		{
			m_ChildRef = resource:"particles/ui_mouseactions/range_finder_cone_start.vpcf"
		},
		{
			m_ChildRef = resource:"particles/ui_mouseactions/range_finder_cone_arrows.vpcf"
		},
	]
}
]]


--[[
	给插件用的定义
]]
---@class CAR_VectorAbility:CDOTA_Ability_Lua
CAR_VectorAbility = {}

---@available:server
---@return Vector
function CAR_VectorAbility:GetVectorCastPosition() end

---@available:client
---@return Vector
function CAR_VectorAbility:GetVectorLocator() end

---@available:client
---@see CAR_VectorAbility "重写这个方法来更改指示器"
---@return string,boolean @particlename,preindicator , preindicator shows during cast
function CAR_VectorAbility:GetVectorIndicator() end

---@available:client
---@see CAR_VectorAbility "重写这个方法来更新指示器"
---@param location Vector
---@param indicator integer
---@param isvectorcast boolean
function CAR_VectorAbility:UpdateIndicator(location, indicator, isvectorcast) end

--[[
	监听矢量施法事件
	也可以用modifier event "OnOrder" 替代
]]
---
if IsServer() then
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(function(context, event)
		local ability = EntIndexToHScript(event.entindex_ability)
		if ability and ability.__vectorability then
			if event.order_type == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION then
				print(Vector(event.position_x, event.position_y, event.position_z))
				ability.__vtarget = Vector(event.position_x, event.position_y, event.position_z)
			end
		end
		return true
	end, GameRules:GetGameModeEntity())
end
---
---@type fun(initializer:fun(ability:CAR_VectorAbility):void):CAR_VectorAbility
VectorAbility = setmetatable({
	---@available:client
	GetClickBehaviors = function(self)
		if not IsClient() then return -1 end
		local player = Entities:GetLocalPlayer()
		return player:GetClickBehaviors()
	end,
	GetVectorIndicator = function(self)
		return "particles/ui_mouseactions/range_finder_cone.vpcf"
	end,
	UpdateIndicator = function(self, location, indicator, isvectorcast)
		ParticleManager:SetParticleControl(self.__indicator, 1, self.__target)
		ParticleManager:SetParticleControl(self.__indicator, 2, location)
		ParticleManager:SetParticleControl(self.__indicator, 3, Vector(128, 128, 0))
		ParticleManager:SetParticleControl(self.__indicator, 4, Vector(100, 255, 0))
		ParticleManager:SetParticleControl(self.__indicator, 6, Vector(1, 0, 0))
	end
}, {
	__call = function(class, initializer)
		local ability = {}
		if type(initializer) == 'function' then
			initializer(ability)
		else
			error("initializer must be a function")
		end
		---
		local interface = IsServer()
			and
			{
				__vectorability = true,
				__vtarget = Vector(0, 0, 0),
				OnSpellStart = function(self)
					if type(self.__OnSpellStart) == 'function' then
						self:__OnSpellStart()
					end
					self.__vtarget = Vector(0, 0, 0)
				end,
				GetVectorCastPosition = function(self)
					return self.__vtarget
				end
			}
			or
			{
				__vectorability = true,
				__target = Vector(0, 0, 0),
				__indicator = -1,
				__lastframe = -1,

				GetVectorLocator = function(self)
					return self.__target
				end,
				CastFilterResultLocation = function(self, location)
					self.__lastframe = GetFrameCount()
					local behavior = class:GetClickBehaviors()
					local isvectorcast = behavior == DOTA_CLICK_BEHAVIOR_VECTOR_CAST
					--
					if not isvectorcast then
						self.__target = location
					end
					if self.__indicator == -1 then
						local particlename, preindicator = (self.GetVectorIndicator and self:GetVectorIndicator() or class.GetVectorIndicator(self))
						if isvectorcast or preindicator then
							local particle = ParticleManager:CreateParticle(particlename, PATTACH_WORLDORIGIN, nil)
							ParticleManager:SetParticleShouldCheckFoW(particle, false)
							self.__indicator = particle
						end
					end
					if self.__indicator ~= -1 then
						if self.UpdateIndicator then
							self:UpdateIndicator(location, self.__indicator, isvectorcast)
						else
							class.UpdateIndicator(self, location, self.__indicator, isvectorcast)
						end
					end

					--
					if type(self.__CastFilterResultLocation) == 'function' then
						return self:__CastFilterResultLocation(location)
					end
				end,
				GetBehavior = function(self)
					if GetFrameCount() > self.__lastframe + 1 then
						ParticleManager:DestroyParticle(self.__indicator, true)
						self.__indicator = -1
						self.__target = Vector(0, 0, 0)
					end
					return self.BaseClass.GetBehavior(self)
				end,
			}
		for i, f in pairs(interface) do
			if not ability[i] or type(ability[i]) == type(f) then
				if type(ability[i]) == 'function' then
					ability['__' .. i] = ability[i]
					ability[i] = f
				else
					ability[i] = f
				end
			end
		end
		return ability
	end
})



--[[
	Example:
	需要把类方法的定义写在初始化回调里
	不写也行
	但是别覆盖几个最重要的方法（OnSpellStart CastFilterResultLocation GetBehavior )
]]
ability_vector_cast_example = VectorAbility(function(ability)
	function ability:OnSpellStart()
		local cursor = self:GetCursorPosition()
		local target = self:GetVectorCastPosition()
		local len = Clamp((cursor - target):Length2D(), 100, 1000)
		local particle = ParticleManager:CreateParticle(
			"particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, cursor)
		ParticleManager:SetParticleControl(particle, 1, Vector(len, 0, 0))
	end

	function ability:GetCastRange(location, target)
		return 1000
	end

	-- 第二个返回值决定这个特效什么时候开始显示，返回true就在第一段时就显示
	function ability:GetVectorIndicator()
		return "particles/ui_mouseactions/range_finder_aoe.vpcf", true
	end

	function ability:UpdateIndicator(location, indicator, isvectorcast)
		if isvectorcast then
			local locator = self:GetVectorLocator()
			local len = Clamp((location - locator):Length2D(), 100, 1000)
			ParticleManager:SetParticleControl(indicator, 2, locator)
			ParticleManager:SetParticleControl(indicator, 3, Vector(len, 0, 0))
		else
			ParticleManager:SetParticleControl(indicator, 2, location)
			ParticleManager:SetParticleControl(indicator, 3, Vector(100, 0, 0))
		end
	end
end)

function CDOTA_Ability_Lua:GetSpecialVarValueFor(name)
	self.variable[name].value = self:GetAbilitySpecialValueFor(name)
	self.variable[name].mul = 1
	return self.variable[name].value
end
