!classDefinition: #PPLSTests category: #PPLS!
TestCase subclass: #PPLSTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 00:28:13'!
test01ALiteralExpressionKnowsItsValue


 self assert: (LiteralExpr withValue: 3 ) getValue equals: 3 .

 self assert: (LiteralExpr withValue: true) getValue . 



! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 00:44:12'!
test02aVariableExpressionCanOnlyBeCreatedWithASymbol


 self assert: (VariableExpr withName: #x) getName equals: #x .

 self       	should: [ VariableExpr withName: '=' ] 
		raise: Error-MessageNotUnderstood 
		withMessageText: VariableExpr variableNameMustBeASymbol! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 12:16:17'!
test03anIfExpressionCanBeAskedForItsSubExpressions

	| ifexpr ifCondition ifTrueBranch ifFalseBranch |


	ifCondition := LiteralExpr withValue: true.
	ifTrueBranch := LiteralExpr withValue: 1.
	ifFalseBranch := LiteralExpr withValue: 0.
	
	ifexpr:= IfExpr withCondition:ifCondition ifTrue: ifTrueBranch ifFalse:ifFalseBranch . 

	self assert: (ifexpr condition) equals: ifCondition .
	self assert: (ifexpr trueBranch) equals:ifTrueBranch .
	self assert: (ifexpr falseBranch) equals: ifFalseBranch .
	! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 12:30:13'!
test04aCallExprCanBeAskedForItsFuntionAndArguments

	| callExpr  arg1 	 arg2 |
	
	arg1 := LiteralExpr withValue: 1.
	arg2 := LiteralExpr withValue: 0.	
	
	
	callExpr:= CallExpr withFunction: #= andArguments: {arg1. arg2 } asOrderedCollection .


	self assert: (callExpr function) equals: #= .
	self assert: (callExpr arguments) equals:{arg1. arg2 } asOrderedCollection ..! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 12:49:34'!
test05aLetExpressionCanHaveMultipleBindings

	| callExpr  bind1 	 bind2 letExpr bindingsList |
	
	bind1 := LiteralExpr withValue: 1.
	bind2 := LiteralExpr withValue: 0.	
	
	bindingsList := {Binding name:#x with: bind1. Binding name:#y with: bind2} asOrderedCollection.
	
	callExpr:= CallExpr withFunction: #+ andArguments: {VariableExpr withName: #x. VariableExpr withName: #y}asOrderedCollection .
	
	
	
	letExpr:= LetExpr binding: bindingsList in: {callExpr} asOrderedCollection . 


	
	self assert: (letExpr bindings) equals: bindingsList .
	
	self assert: (letExpr body) equals: {callExpr} asOrderedCollection ! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 13:08:21'!
test06aFunctionExpression

	| callExpr1  callExpr2 lit1 	 argumentsList fnExp var1 var2 |
	
	
	
	lit1 := LiteralExpr withValue: 1.
	
	var1 := VariableExpr withName: #x.
	var2 := VariableExpr withName: #y.
	
	
	callExpr1:= CallExpr withFunction: #+ andArguments: {var1. var2}asOrderedCollection .
	callExpr2:= CallExpr withFunction: #= andArguments: {var1. lit1}asOrderedCollection .
	
	argumentsList := {#x . #y} asOrderedCollection.
	
	fnExp := FunctionExpr withArguments: argumentsList andBody: {callExpr1. callExpr2. }asOrderedCollection .
	

	self assert: (fnExp arguments) equals: argumentsList .
	
	self assert: (fnExp body) equals: {callExpr1. callExpr2. }asOrderedCollection .	! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 13:59:41'!
test07ParserWorksForLiteralExpressions

	| program parsedProgram |
	
	program:= {3. true. false. 1010101} asOrderedCollection .
	
	parsedProgram:= (HOPPLParser new) parse: program.
	
	
	self assert: (parsedProgram first isKindOf: LiteralExpr).
	self assert: (parsedProgram first getValue ) equals: 3.
	
	self assert: (parsedProgram second isKindOf: LiteralExpr).
	self assert: (parsedProgram second getValue ) equals: true.
	
	self assert: (parsedProgram third isKindOf: LiteralExpr).
	self assert: (parsedProgram third getValue ) equals: false.
	
	self assert: (parsedProgram fourth isKindOf: LiteralExpr).
	self assert: (parsedProgram fourth getValue ) equals: 1010101.! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 14:02:33'!
test08ParserWorksForVariableExpression

	| program parsedProgram |
	
	program:= {#x. #myVariable} asOrderedCollection .
	
	parsedProgram:= (HOPPLParser new) parse: program.
	
	
	self assert: (parsedProgram first isKindOf: VariableExpr).
	self assert: (parsedProgram first getName) equals: #x.
	
	self assert: (parsedProgram second isKindOf: VariableExpr).
	self assert: (parsedProgram second getName ) equals: #myVariable.! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 15:42:22'!
test09ParserWorksForIfExpression

	| program parsedProgram |
	
	 "[[if, condition, then, else]]"
	program:= {{#if . true. 1. 0.} asOrderedCollection }asOrderedCollection . 
	
	parsedProgram:= (HOPPLParser new) parse: program.
	
	
	self assert: (parsedProgram first isKindOf: IfExpr ).
	
	self assert: (parsedProgram first condition isKindOf: Expression).
	
	self assert: (parsedProgram first trueBranch isKindOf: Expression).
	
	self assert: (parsedProgram first falseBranch isKindOf: Expression).
	
! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 16:19:22'!
test10ParserWorksForCallExpression

	| program parsedProgram arguments |
	
	 "[[+, 1 , 2]]  or [[myfunction, 1, 2, 3, 4, x, y]]"
	program:= {{#myFunction . 1. true. 0.} asOrderedCollection } asOrderedCollection . 
	
	parsedProgram:= (HOPPLParser new) parse: program.
	
	
	self assert: (parsedProgram first isKindOf: CallExpr  ).
	
	self assert: (parsedProgram first function isKindOf: Symbol).
	
	self assert: (parsedProgram first arguments isKindOf: OrderedCollection).
	
	arguments := parsedProgram first arguments. 
	arguments removeAllSuchThat: [:x | (x isKindOf: Expression ) not].
	
	self assert: (arguments size = 3). 
	
! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 16:40:19'!
test11ParserWorksForLetExpression

	| program bindings letbody parsedProgram parsedBindings parsedBody |
	
	 "[ [let, [lista de bindings] , [cuerpo del let] ] ]  or [ [let, [x,4,y,10], [+, x, y] ] ]"
	
	bindings:= {#x. 10. #y. 5} asOrderedCollection . 
	letbody:={#if. false. #x. #y}.
	program:= {{#let . bindings. letbody} asOrderedCollection } asOrderedCollection . 
	
	parsedProgram:= (HOPPLParser new) parse: program.
	
	
	self assert: (parsedProgram first isKindOf: LetExpr  ).
	
	self assert: (parsedProgram first bindings isKindOf: OrderedCollection).
	
	self assert: (parsedProgram first body isKindOf: OrderedCollection).
	
	parsedBindings := parsedProgram first bindings. 
	parsedBindings removeAllSuchThat: [:x | (x isKindOf: Binding ) not].
	
	self assert: (parsedBindings size = 2). 
	
	
	parsedBody := parsedProgram first body. 
	parsedBody removeAllSuchThat: [:x | (x isKindOf: Expression ) not].
	
	self assert: (parsedBindings size = 1). 
	
! !

!PPLSTests methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 16:25:31'!
test12ParserWorksForFunctionExpression

	| program parsedProgram arguments |
	
	 "[[defn, #myFunction , [arguments], [body] ]]  or [ [defn, 
													#sumaresta, 
													[x ,y, z], 
													[let , a , [+, x, y], [
															a-z
															]
														]
													]"
	
	program:= {{#myFunction . 1. true. 0.} asOrderedCollection } asOrderedCollection . 
	
	parsedProgram:= (HOPPLParser new) parse: program.
	
	
	self assert: (parsedProgram first isKindOf: CallExpr  ).
	
	self assert: (parsedProgram first function isKindOf: Symbol).
	
	self assert: (parsedProgram first arguments isKindOf: OrderedCollection).
	
	arguments := parsedProgram first arguments. 
	arguments removeAllSuchThat: [:x | (x isKindOf: Expression ) not].
	
	self assert: (arguments size = 3). 
	
! !


!classDefinition: #Binding category: #PPLS!
Object subclass: #Binding
	instanceVariableNames: 'name expression'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!Binding methodsFor: 'initialization' stamp: 'CR 7/6/2026 12:50:53'!
initializeName: aVariableName with: anExpressionToBind 

	name := aVariableName.
	expression := anExpressionToBind.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Binding class' category: #PPLS!
Binding class
	instanceVariableNames: ''!

!Binding class methodsFor: 'instance creation' stamp: 'CR 7/6/2026 12:50:13'!
name: aVariableName with: anExpressionToBind
 
	^self new initializeName: aVariableName with: anExpressionToBind ! !


!classDefinition: #Expression category: #PPLS!
Object subclass: #Expression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!


!classDefinition: #CallExpr category: #PPLS!
Expression subclass: #CallExpr
	instanceVariableNames: 'functionName argumentsList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!CallExpr methodsFor: 'initialization' stamp: 'CR 7/6/2026 12:31:44'!
initializeWithFunction: aFunctionName andArguments: anArgumentsList 

	functionName := aFunctionName.
	argumentsList := anArgumentsList.! !


!CallExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 12:32:40'!
arguments
	^argumentsList .! !

!CallExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 12:32:24'!
function

	^functionName! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallExpr class' category: #PPLS!
CallExpr class
	instanceVariableNames: ''!

!CallExpr class methodsFor: 'instance creation' stamp: 'CR 7/6/2026 12:31:30'!
withFunction: aFunctionName andArguments: anArgumentsList 

	^self new initializeWithFunction: aFunctionName andArguments: anArgumentsList ! !


!classDefinition: #FunctionExpr category: #PPLS!
Expression subclass: #FunctionExpr
	instanceVariableNames: 'argumentsList functionBody'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!FunctionExpr methodsFor: 'initialization' stamp: 'CR 7/6/2026 13:09:36'!
initializeWithArguments: anArgumentsList andBody: aFunctionBody 
	
	argumentsList := anArgumentsList.
	functionBody := aFunctionBody.! !


!FunctionExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 13:11:00'!
arguments
	^argumentsList .! !

!FunctionExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 13:11:15'!
body
	^functionBody .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FunctionExpr class' category: #PPLS!
FunctionExpr class
	instanceVariableNames: ''!

!FunctionExpr class methodsFor: 'instance creation' stamp: 'CR 7/6/2026 13:08:53'!
withArguments: argumentsList andBody: aFunctionBody 
	
	^self new initializeWithArguments: argumentsList andBody: aFunctionBody ! !


!classDefinition: #IfExpr category: #PPLS!
Expression subclass: #IfExpr
	instanceVariableNames: 'condition trueBranch falseBranch'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!IfExpr methodsFor: 'initialization' stamp: 'CR 7/6/2026 12:17:30'!
initializeWithCondition: ifCondition ifTrue: ifTrueBranch ifFalse: ifFalseBranch 


	condition := ifCondition.
	trueBranch := ifTrueBranch.
	falseBranch := ifFalseBranch.! !


!IfExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 12:17:48'!
condition

	^condition! !

!IfExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 12:18:14'!
falseBranch

	^falseBranch! !

!IfExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 12:18:05'!
trueBranch

	^trueBranch! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IfExpr class' category: #PPLS!
IfExpr class
	instanceVariableNames: ''!

!IfExpr class methodsFor: 'instance creation' stamp: 'CR 7/6/2026 12:16:35'!
withCondition: ifCondition ifTrue: ifTrueBranch ifFalse: ifFalseBranch 

	^self new initializeWithCondition: ifCondition ifTrue: ifTrueBranch ifFalse: ifFalseBranch ! !


!classDefinition: #LetExpr category: #PPLS!
Expression subclass: #LetExpr
	instanceVariableNames: 'bindingsList letBody'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!LetExpr methodsFor: 'initialization' stamp: 'CR 7/6/2026 12:52:25'!
initializeBinding: aBindingsList in: aLetBody 

	bindingsList := aBindingsList .
	letBody := aLetBody.! !


!LetExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 12:52:55'!
bindings
	
	^bindingsList ! !

!LetExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 12:53:15'!
body
	
	^letBody ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LetExpr class' category: #PPLS!
LetExpr class
	instanceVariableNames: ''!

!LetExpr class methodsFor: 'instance creation' stamp: 'CR 7/6/2026 12:51:32'!
binding: bindingsList in: aLetBody 

	^self new initializeBinding: bindingsList in: aLetBody ! !


!classDefinition: #LiteralExpr category: #PPLS!
Expression subclass: #LiteralExpr
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!LiteralExpr methodsFor: 'initialization' stamp: 'CR 7/6/2026 00:27:07'!
initializeWithValue: aValue 

	value := aValue.! !


!LiteralExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 00:29:09'!
getValue

	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LiteralExpr class' category: #PPLS!
LiteralExpr class
	instanceVariableNames: ''!

!LiteralExpr class methodsFor: 'instance creation' stamp: 'CR 7/6/2026 00:26:49'!
withValue: aValue 

	^self new initializeWithValue: aValue ! !


!classDefinition: #VariableExpr category: #PPLS!
Expression subclass: #VariableExpr
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!VariableExpr methodsFor: 'initialization' stamp: 'CR 7/6/2026 00:39:56'!
initializeWithName: aVariableName 
	
	aVariableName isSymbol ifFalse:[ self error: self class variableNameMustBeASymbol].
	name := aVariableName.! !


!VariableExpr methodsFor: 'accessing' stamp: 'CR 7/6/2026 00:42:19'!
getName
	^name! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'VariableExpr class' category: #PPLS!
VariableExpr class
	instanceVariableNames: ''!

!VariableExpr class methodsFor: 'instance creation' stamp: 'CR 7/6/2026 00:36:04'!
withName: aSymbol 
	
	^self new initializeWithName: aSymbol ! !


!VariableExpr class methodsFor: 'error handling' stamp: 'CR 7/6/2026 00:43:54'!
variableNameMustBeASymbol
	^'Variable name must be a Symbol!! #myVariable'! !


!classDefinition: #HOPPLParser category: #PPLS!
Object subclass: #HOPPLParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!

!HOPPLParser methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 13:27:02'!
parse: aProgram 

	|newProgram |	

	newProgram:= OrderedCollection new. 
	
	aProgram do: [:instruction | newProgram add:(self parseInstruction: instruction) ].
	
	^newProgram
	
	! !

!HOPPLParser methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 16:08:32'!
parseCall: anInstruction 

	|arguments function |	
	
	function:= anInstruction removeFirst.

	arguments:= OrderedCollection new.
	
	anInstruction do:[:x | arguments add: (self parseInstruction: x)].
	
	
	^CallExpr withFunction: function andArguments: arguments.! !

!HOPPLParser methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 16:05:45'!
parseIf: anInstruction

	^ IfExpr withCondition: (self parseInstruction: anInstruction second )
				ifTrue: (self parseInstruction: anInstruction third )
				ifFalse:(self parseInstruction: anInstruction fourth )! !

!HOPPLParser methodsFor: 'as yet unclassified' stamp: 'CR 7/6/2026 16:06:10'!
parseInstruction: anInstruction

	(anInstruction isKindOf: OrderedCollection) ifTrue:[
		
		anInstruction first isSymbol ifTrue:[
			
			(anInstruction first = #if ) ifTrue: [				^ self parseIf: anInstruction		.			].
			
			^self parseCall: anInstruction . 
					
		] .
	].
	
	anInstruction isSymbol ifTrue:[^VariableExpr withName: anInstruction ].
	^LiteralExpr withValue: anInstruction .! !


!classDefinition: #Machine category: #PPLS!
Object subclass: #Machine
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PPLS'!
