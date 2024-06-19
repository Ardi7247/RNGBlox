--!strict
--!native

export type RNG = {
	Clone: (self:RNG)->(RNG);
	LoadState: (
		self:RNG,
		Iterations:number
	)->();
	
	NextNumber: (
		self:RNG,
		min:number?,
		max:number?
	)->(number);
	NextInteger: (
		self:RNG,
		min:number,
		max:number
	)->(number);
	NextUnitVector3: (self:RNG)->(Vector3);
	NextUnitVector2: (self:RNG)->(Vector2);
	NextColorHSV: (
		self:RNG,
		MinHue: number?,
		MaxHue: number?,
		MinSaturation: number?,
		MaxSaturation: number?,
		MinValue: number?,
		MaxValue: number?
	) -> (Color3);
	NextColorRGB: (
		self:RNG,
		MinR: number?,
		MaxR: number?,
		MinG: number?,
		MaxG: number?,
		MinB: number?,
		MaxB: number?
	) -> (Color3);
	NextBrickColor: (self:RNG) -> (BrickColor);
	
	Shuffle: (
		self:RNG,
		tb: {}
	) -> ();
	RandValueAndIndexFromList: (
		self:RNG,
		tb: {}
	) -> (any,any);
	
	State:{
		Iteration:number;
		Seed:number;
	};
	
	[any]: Random; -- Someday I'll do this in less of a hack way
}

local BrickColors = {}

for i = 1, 1032 do
	local color = BrickColor.new(i)
	if table.find(BrickColors,color) then
		continue
	end
	table.insert(BrickColors,color)
end

local function Clone(self:RNG):RNG
	return New(self.RNG:Clone(), self.State)
end

local function LoadState(self:RNG,state:number)
	local stepsNeeded = state-self.State.Iteration
	if stepsNeeded < 0 then
		self.RNG = Random.new(self.State.Seed)
		self.State.Iteration = 0
		stepsNeeded = state
	elseif stepsNeeded == 0 then
		return
	end
	for i = 1, stepsNeeded do
		self.RNG:NextNumber()
	end
	self.State.Iteration = state
end

local function NextNumber(self:RNG,min:number?,max:number?):number
	self.State.Iteration += 1
	return(self.RNG:NextNumber(min or 0,max or 1))
end

local function NextInteger(self:RNG,min:number,max:number):number
	self.State.Iteration += 1
	return(self.RNG:NextInteger(min,max))
end

local function NextUnitVector3(self:RNG):Vector3
	self.State.Iteration += 1
	return(self.RNG:NextUnitVector())
end

local function NextUnitVector2(self:RNG):Vector2
	local r = self:NextNumber()*math.pi*2
	return(Vector2.new(math.cos(r),math.sin(r)))
end

local function NextColor(
	self:RNG,
	RGB:boolean,
	MinHue: number?,
	MaxHue: number?,
	MinSaturation: number?,
	MaxSaturation: number?,
	MinValue: number?,
	MaxValue: number?
): Color3
	-- Ahoy, fellow scripter. Ye've found yerself at th' color function.
	-- Tharr be a great deal o' added complexity from abstraction, matey.
	-- Yarghh, Below there be code to set default values fer RGB/HSV if no range is provided.
	local MinHue:number = MinHue or 0
	local MaxHue:number = MaxHue or RGB and 255 or 1
	
	local MinSaturation:number = MinSaturation or 0
	local MaxSaturation:number = MaxSaturation or RGB and 255 or 1
	
	local MinValue:number = MinValue or 0
	local MaxValue:number = MaxValue or RGB and 255 or 1
	
	local Hue = self:NextNumber(MinHue,MaxHue)
	local Saturation = self:NextNumber(MinSaturation,MaxSaturation)
	local Value = self:NextNumber(MinValue,MaxValue)
	if RGB then
		return(Color3.fromRGB(Hue, Saturation, Value))
	end
	
	return(Color3.fromHSV(Hue, Saturation, Value))
end

local function NextColorHSV(
	self:RNG,
	MinHue: number?,
	MaxHue: number?,
	MinSaturation: number?,
	MaxSaturation: number?,
	MinValue: number?,
	MaxValue: number?
):Color3
	return(NextColor(
		self,
		false,
		MinHue,
		MaxHue,
		MinSaturation,
		MaxSaturation,
		MinValue,
		MaxValue
	))
end
local function NextColorRGB(
	self:RNG,
	MinR: number?,
	MaxR: number?,
	MinG: number?,
	MaxG: number?,
	MinB: number?,
	MaxB: number?
):Color3
	return(NextColor(
		self,
		true,
		MinR,
		MaxR,
		MinG,
		MaxG,
		MinB,
		MaxB
		))
end

local function NextBrickColor(self:RNG):BrickColor
	return BrickColors[self:NextInteger(1,#BrickColors)]
end

local function ShuffleTable(self:RNG, tb:{})
	local RandSeed = self:NextInteger(0,math.huge)
	local TemporaryRNG = Random.new(RandSeed)
	TemporaryRNG:Shuffle(tb)
end

local function PickFromList(self:RNG, tb:{}): (any,any)
	local indexes = {}
	for index, value in pairs(tb) do
		table.insert(indexes,index)
	end
	local selectedIndex = indexes[self:NextInteger(1,#indexes)]
	return tb[selectedIndex], selectedIndex
end

function New(
	rng:Random,
	State:{
		Seed:number;
		Iteration:number?;
	}
):RNG
	local object = {
		
		State = {
			Iteration = 0;
			Seed = State.Seed
		};
		
		RNG = rng;
		Clone = Clone;
		LoadState = LoadState;

		NextNumber = NextNumber;
		NextInteger = NextInteger;
		NextUnitVector3 = NextUnitVector3;
		NextUnitVector2 = NextUnitVector2;
		
		NextColorHSV = NextColorHSV;
		NextColorRGB = NextColorRGB;
		NextBrickColor = NextBrickColor;
		
		Shuffle = ShuffleTable;
		RandValueAndIndexFromList = PickFromList;
		
	}
	
	if State.Iteration then
		object:LoadState(State.Iteration)
	end
	
	return object
end

return {
	new = function(seed:number?,iterations:number?):RNG
		local seed = seed or Random.new():NextInteger(0,math.huge)
		local iterations = iterations or 0
		local RNG = Random.new(seed)
		return(New(RNG, {
			Seed = seed;
			Iteration = iterations;
		}))
	end;
}

