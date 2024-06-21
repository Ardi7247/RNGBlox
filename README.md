# Random's Goal
My random library is a simple, object-oriented module for seeded pseudo-random number/value generation in luau. (Roblox)

# Features

## Constructor
### Random.new(seed?, iterations?)
<details>
<summary>Documentation</summary>
(seed: number?, iterations: number?) -> (RNG)
</details>
Basic constructor for an RNG object with optional parameters.

## Methods
### RNG:GetIteration()
(self: RNG) -> (number)
### RNG:GetSeed()
(self: RNG) -> (number)

### RNG:Clone()
<details>
<summary>Documentation</summary>
(self: RNG) -> (RNG)
</details>
Will return a cloned version of the RNG object.

### RNG:LoadState(Iterations)
<details>
<summary>Documentation</summary>
(self: RNG, Iterations: number) -> ()
</details>
Load a specific state to the RNG object. Either from another object's RNG.State.Iteration or manually setting the number of iterations.

### RNG:NextNumber(min?, max?)
<details>
<summary>Documentation</summary>
(self: RNG, min: number?, max: number?) -> (number)
</details>
Returns a pseudorandom number uniformly distributed between [0, 1] or [min, max]

### RNG:NextInteger(min, max)
<details>
<summary>Documentation</summary>
(self: RNG, min: number, max: number) -> (number)
</details>
Returns a pseudorandom integer uniformly distributed between [min, max]

### RNG:NextUnitVector3()
<details>
<summary>Documentation</summary>
(self: RNG) -> (Vector3)
</details>
Returns a pseudorandom Vector3 with a magnitude of 1.

### RNG:NextUnitVector2()
<details>
<summary>Documentation</summary>
(self: RNG) -> (Vector2)
</details>
Returns a pseudorandom Vector2 with a magnitude of 1.

### RNG:NextColorHSV(...?)
<details>
<summary>Documentation</summary>
> @param MinHue > Number? > Default 0 <br>
> @param MaxHue > Number? > Default 1 <br>
> @param MinSaturation > Number? > Default 0 <br>
> @param MaxSaturation > Number? > Default 1 <br>
> @param MinValue > Number? > Default 0 <br>
> @param MaxValue > Number? > Default 1 <br>
<br>
(self: RNG, ...) -> (Color3)
</details>
Returns a pseudorandom H,S,V Color3 depending on parameters.

### RNG:NextColorRGB(...?)
<details>
<summary>Documentation</summary>
> @param MinR > Number? > Default 0 <br>
> @param MaxR > Number? > Default 255 <br>
> @param MinSaturation > Number? > Default 0 <br>
> @param MaxSaturation > Number? > Default 255 <br>
> @param MinValue > Number? > Default 0 <br>
> @param MaxValue > Number? > Default 255 <br>
<br>
(self: RNG, ...) -> (Color3)
</details>
Returns a pseudorandom R,G,B Color3 depending on parameters.

### RNG:NextBrickColor()
<details>
<summary>Documentation</summary>
(self: RNG) -> (BrickColor)
</details>
Returns a pseudorandom BrickColor picked from all available brick colors.

### RNG:Shuffle(table)
<details>
<summary>Documentation</summary>
(self: RNG, tb: {}) -> ()
</details>
Randomly shuffles a table using the RNG object.

### RNG:RandValueAndIndexFromList(table)
<details>
<summary>Documentation</summary>
(self: RNG, tb: {}) -> (any, any)
</details>

Returns two values: (value, index) which are randomly picked from a table such that table[index] = value. Index or value can be of any type.
