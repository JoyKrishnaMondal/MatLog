cli = require "cli-color"

_ = require "prelude-ls"

median = require "median"

EOL = ((require "os").EOL)


Main = {}

Main.DocString =->

	Doc = "----------------------------------------------------------------------------------#{EOL}

	MatLog is a tiny module to succiently view 2D matrices on the terminal. It comes with 2 functions - Init and PrintMat. #{EOL + EOL}

	Pass your 2D matrix to PrintMat to print the matrix on the terminal.#{EOL + EOL}

	Init allows you to customize the printing - you can control two variables by passing their values using a JSON.#{EOL + EOL}

	1# MaxSigFig - For Significant Figures. #{EOL}
	2# Blanks    - Spacing between columns. #{EOL + EOL}

	The function PrintMat also factors out the most common exponent so you get to see the most relevant values - while saving space. #{EOL + EOL}

	---------------------------------------------------------------------------------- "

	console.log Doc

	return

Main.MaxSigFig = 1

Main.Blanks = 0


Main.Init = (Json = {MaxSigFig:1,Blanks:0}) ->


	for Keys,Values of Json
		
		if not ((typeof Values) is "number")

			console.error ((cli.redBright "Error: ") + (cli.greenBright Keys) + (cli.red " should be a numerical value"))

		else 

			if not (Values is undefined)

				@[Keys] = Values

	return

Main.CleanMat = (Mat) -> 
	
	SF = @MaxSigFig

	I = 0

	Iₙ = Mat.length

	while I < Iₙ

		K = 0
		Elem = Mat[I]
		Kₙ = Elem.length

		while K < Kₙ

			CurrentElem = Elem[K]

			if typeof CurrentElem is "string"
				CurrentElem = parseFloat CurrentElem

			Elem[K] = parseFloat CurrentElem.toPrecision SF


			K += 1
		I += 1

	Mat

FindExponent = (Num)->

	OutCome = (Num.toExponential!).match /(.*)e(.*)/

	_.map parseFloat, [OutCome[1],OutCome[2]]



Main.ExpoAnalysis = (Matrix) ->


	dLoop = (f) -> _.map _.map f

	ValAnPower   =    Matrix    |> dLoop FindExponent

	ExpoMat      =  ValAnPower  |> dLoop (x) -> x[1]


	MedianBase = ExpoMat |> _.flatten |> median



	Output = []
	
	{abs,pow} = Math

	SF = @MaxSigFig 
	I = 0
	Iₙ	 = ExpoMat.length

	while I < Iₙ

		Elem = ValAnPower[I]
		Row = []
		K = 0
		Kₙ = Elem.length

		while K < Kₙ

			X = Elem[K]

			ColPower = X[1] - MedianBase

			DPValue = parseFloat ((X[0]*pow 10,ColPower).toPrecision SF)

			if (abs ColPower) > SF

				Input =  DPValue |> (.toExponential!)

			else

				Input = DPValue.toString!

			Row.push Input

			K += 1

		Output.push Row

		I += 1

	(DisplayMat:Output,Base:MedianBase)




Main.FindMaxColumnLength = (Mat) ->

	ColumnLen = []

	Iₙ = Mat.length

	I = 0

	MaxRowSize = 0

	while I < Iₙ

		Elem = Mat[I]

		Kₙ = Elem.length

		K = 0
		

		while K < Kₙ

			Len = Elem[K] |> (.length)

			if ColumnLen[K] is undefined

				ColumnLen[K] = 0

			if ColumnLen[K] < Len

				ColumnLen[K] = Len

			K += 1
		
			if MaxRowSize < Kₙ
				MaxRowSize = Kₙ

		I += 1

	

	*"ColumnLen":ColumnLen
		"MaxRowSize":MaxRowSize


Main.PrintMat = (Mat)->

	if !((Array.isArray Mat[0]) is true)
		console.log Mat # Function defaults to normal displaying if 1D Array.
		return

	{DisplayMat,Base} =  Mat |> @CleanMat |> @ExpoAnalysis

	{ColumnLen,MaxRowSize}  = DisplayMat |> @FindMaxColumnLength


	stdout = process.stdout

	Iₙ = DisplayMat.length

	TerminalHorSize = stdout.columns

	MinSizeForColon = TerminalHorSize*0.75

	I = 0

	while I < Iₙ

		CursorPos = 0

		K = 0

		Elem = DisplayMat[I]
		Kₙ = Elem.length

		while K < MaxRowSize
			ColMaxSize = ColumnLen[K]

			if K < Kₙ

				CurrentNumber = Elem[K]
				SizeOfStringToBeDisplayed = CurrentNumber.length
				BlankSize = ColMaxSize - SizeOfStringToBeDisplayed

			else
				CurrentNumber = "-"
				BlankSize = ColMaxSize - 1


			BlankSize += @Blanks  
			J = 0

			Spaces  = ""

			while J <= BlankSize
				Spaces += " "
				J += 1

			CursorPos += ColMaxSize + BlankSize + 1

			stdout.write Spaces + CurrentNumber

			
			K += 1
		
		if (CursorPos%TerminalHorSize) > MinSizeForColon
			EndLine = "; " + EOL
		else
			EndLine = EOL

		stdout.write EndLine
		
		I += 1

	Math.pow 10,Base |> (x) -> "*" + x.toExponential! + EOL |>stdout.write 
	console.log 
	return

Public = {}

Public.DocString = Main.DocString

Public.Init = Main.Init.bind Main

Public.PrintMat = Main.PrintMat.bind Main

module.exports = Public