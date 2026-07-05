!classDefinition: #TPTest category: #ILPP!
TestCase subclass: #TPTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!TPTest methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:23:35'!
test01SeCreaBienLaMaquina
	| aControlStack m env expr ev |
	env := Dictionary new.
	expr := 1 + 2.
	
	ev := LiteralExpr value: 3.
	aControlStack := {ev}.
	
	m := Machine withControlStack: aControlStack environment: env.
	
	self assert: m class equals: Machine.
	self assert: env class equals: Dictionary.
	self assert: ev class equals: LiteralExpr.
	
	! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:23:35'!
test02CanEvaluateLiteralExpr
	| aControlStack m env expr result |
	env := Dictionary new.
	expr := LiteralExpr value:3.
	
	aControlStack := {expr} asOrderedCollection.
	
	m := Machine withControlStack: aControlStack environment: env.
	result := m resume.
	
	self assert: result equals: {'done'. 3}.

	
	
	! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:37:58'!
test03CanEvaluateVariableExpr

	| aControlStack m env expr result |

	
	expr := VariableExpr name: #x.
	env := Dictionary new. env at:#x put: 4.
	
	aControlStack := {expr} asOrderedCollection.
	
	m := Machine withControlStack: aControlStack environment: env.
	
	result := m resume.
	self assert: result equals: {'done'. 4}.! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:34:04'!
test04CanEvaluateIfExpr

	| aControlStack m env expr result |

	env := Dictionary new. 
	
	expr := IfExpr condition: (LiteralExpr value: true) ifTrue: (LiteralExpr value: 1) ifFalse: (LiteralExpr value: 0).
	
	aControlStack := {expr} asOrderedCollection.
	
	m := Machine withControlStack: aControlStack environment: env.
	
	result := m resume.
	self assert: result equals: {'done'. 1}.

	
	! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:37:45'!
test04_BCanEvaluateIfExpr

	| aControlStack m env expr result |

	env := Dictionary new. env at: #x put: true.
	
	expr := IfExpr condition: (VariableExpr name: #x ) ifTrue: (LiteralExpr value: 1) ifFalse: (LiteralExpr value: 0).
	
	
	aControlStack := {expr} asOrderedCollection.
	
	m := Machine withControlStack: aControlStack environment: env.
	
	result := m resume.
	self assert: result equals: {'done'. 1}.

	
	! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 21:43:51'!
test05CanEvaluateLetExpr

	| aControlStack m env expr result binds body xExpr yExpr|

	env := Dictionary new. env at: #x put: true.
	xExpr:= VariableExpr name:#x. 
	yExpr := VariableExpr name:#y. 
	binds:= {{xExpr. LiteralExpr value:true }. {{yExpr. LiteralExpr value:5 }}}asOrderedCollection .
	
	body:= {IfExpr condition: xExpr ifTrue: yExpr ifFalse: (LiteralExpr value:0)}asOrderedCollection . 
	
	expr:= LetExpr withBinds: binds andBody:  body. 
	
	aControlStack := {expr} asOrderedCollection.
	
	m := Machine withControlStack: aControlStack environment: env.
	
	result := m resume.
	self assert: result equals: {'done'. 5}.

	
	! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 21:07:57'!
testxxCanEvaluateCallExpr

	| aControlStack m env expr result |

	env := Dictionary new. env at: #+ put: ([: x : y | x + y]).
	
	expr := CallExpr withFunctionName: (VariableExpr name: #+) andArguments: ({LiteralExpr value: 1. LiteralExpr value: 2.}asOrderedCollection) . 
	
	aControlStack := {expr} asOrderedCollection.
	
	m := Machine withControlStack: aControlStack environment: env.
	
	result := m resume.
	self assert: result equals: {'done'. 3}.

	
	! !


!classDefinition: #Continuation category: #ILPP!
Object subclass: #Continuation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!Continuation methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 22:21:38'!
evaluateIn: aMachine

	self subclassResponsibility 

! !


!classDefinition: #IfContinuation category: #ILPP!
Continuation subclass: #IfContinuation
	instanceVariableNames: 'trueBranch falseBranch'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!IfContinuation methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:26:12'!
evaluateIn: aMachine

	
	aMachine continueIfWithTrueBranch: trueBranch andFalseBranch: falseBranch .! !

!IfContinuation methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:13:55'!
initalizeWithTrueBranch: aTrueBranch andFalseBranch: aFalseBranch 
	
	trueBranch:= aTrueBranch.
	falseBranch:= aFalseBranch.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IfContinuation class' category: #ILPP!
IfContinuation class
	instanceVariableNames: ''!

!IfContinuation class methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:12:59'!
withTrueBranch: aTrueBranch andFalseBranch: aFalseBranch 

	^self new initalizeWithTrueBranch: aTrueBranch andFalseBranch: aFalseBranch.! !


!classDefinition: #LetContinuation category: #ILPP!
Continuation subclass: #LetContinuation
	instanceVariableNames: 'bindsList expressionsList bindIndex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!LetContinuation methodsFor: 'initialization' stamp: 'CR 7/4/2026 22:26:35'!
evaluateIn: aMachine


	aMachine continueLetBindingIndex: bindIndex withBindings: bindsList body: expressionsList ! !

!LetContinuation methodsFor: 'initialization' stamp: 'CR 7/4/2026 22:17:49'!
initializeWithBindings: aBindsList body: anExpressionsList toBind: aBindIndex 

	bindsList := aBindsList.
	expressionsList := anExpressionsList.
	bindIndex := aBindIndex.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LetContinuation class' category: #ILPP!
LetContinuation class
	instanceVariableNames: ''!

!LetContinuation class methodsFor: 'instance creation' stamp: 'CR 7/4/2026 22:49:10'!
withBindings: aBindsList body: anExpressionsList toBind: aBindIndex andEnvironment: anEnvironment 

	^self new initializeWithBindings: aBindsList body: anExpressionsList toBind: aBindIndex ! !


!classDefinition: #Expression category: #ILPP!
Object subclass: #Expression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!Expression methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:33:46'!
evaluateIn: aMachine

 self subclassResponsibility ! !


!classDefinition: #CallExpr category: #ILPP!
Expression subclass: #CallExpr
	instanceVariableNames: 'functionName argumentList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!CallExpr methodsFor: 'initialization' stamp: 'CR 7/4/2026 20:21:53'!
initializeWithFunctionName: aFunctionName andArguments: anArgumentList 

	functionName := aFunctionName.
	argumentList := anArgumentList.! !


!CallExpr methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 20:23:21'!
evaluateIn: aMachine 
	
	aMachine evaluateCallWithFunction: functionName andArguments: argumentList .
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallExpr class' category: #ILPP!
CallExpr class
	instanceVariableNames: ''!

!CallExpr class methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 20:21:31'!
withFunctionName: aFunctionName andArguments: anArgumentList 
	^self new initializeWithFunctionName: aFunctionName andArguments: anArgumentList .! !


!classDefinition: #IfExpr category: #ILPP!
Expression subclass: #IfExpr
	instanceVariableNames: 'conditionToEvaluate trueBranch falseBranch'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!IfExpr methodsFor: 'initialization' stamp: 'CR 7/4/2026 18:57:09'!
initializeWithCondition: aConditionToEvaluate ifTrue: aTrueBranch ifFalse: aFalseBranch 

	conditionToEvaluate := aConditionToEvaluate.
	trueBranch := aTrueBranch.
	falseBranch := aFalseBranch.! !


!IfExpr methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:59:36'!
evaluateIn: aMachine 

	aMachine evaluateIfWithCondition: conditionToEvaluate ifTrue: trueBranch ifFalse:falseBranch.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IfExpr class' category: #ILPP!
IfExpr class
	instanceVariableNames: ''!

!IfExpr class methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:56:03'!
condition: aConditionToEvaluate ifTrue: trueBranch ifFalse: falseBranch 
	
	^self new initializeWithCondition: aConditionToEvaluate ifTrue: trueBranch ifFalse: falseBranch ! !


!classDefinition: #LetExpr category: #ILPP!
Expression subclass: #LetExpr
	instanceVariableNames: 'bindsList expressionsList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!LetExpr methodsFor: 'initialization' stamp: 'CR 7/4/2026 21:47:01'!
initializeWithBinds: aBindsList andBody: anExpressionsList 

	bindsList := aBindsList.
	expressionsList := anExpressionsList.! !


!LetExpr methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 21:48:29'!
evaluateIn: aMachine 
	
	aMachine evaluateLetExprWith: bindsList andBody:expressionsList ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LetExpr class' category: #ILPP!
LetExpr class
	instanceVariableNames: ''!

!LetExpr class methodsFor: 'instance creation' stamp: 'CR 7/4/2026 21:46:36'!
withBinds: aBindsList andBody: anExpressionsList 
	
	^self new initializeWithBinds: aBindsList andBody: anExpressionsList ! !


!classDefinition: #LiteralExpr category: #ILPP!
Expression subclass: #LiteralExpr
	instanceVariableNames: 'value environment address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!LiteralExpr methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:43:57'!
evaluateIn: aMachine 

	aMachine evaluateLiteralExprWithValue: value .! !

!LiteralExpr methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:06:35'!
initializeWithValue: aConstantValue  
	value := aConstantValue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LiteralExpr class' category: #ILPP!
LiteralExpr class
	instanceVariableNames: ''!

!LiteralExpr class methodsFor: 'instance creation' stamp: 'CR 7/4/2026 18:06:21'!
value: aConstantValue  
	^self new initializeWithValue: aConstantValue  ! !


!classDefinition: #VariableExpr category: #ILPP!
Expression subclass: #VariableExpr
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!VariableExpr methodsFor: 'initialization' stamp: 'CR 7/4/2026 18:30:56'!
initializeWithName: aVariableName 

	name := aVariableName.! !


!VariableExpr methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:40:24'!
evaluateIn: aMachine 

	aMachine evaluateVariableExprWIthName: name. 
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'VariableExpr class' category: #ILPP!
VariableExpr class
	instanceVariableNames: ''!

!VariableExpr class methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:30:19'!
name: aVariableName 
	^self new initializeWithName: aVariableName .! !


!classDefinition: #Machine category: #ILPP!
Object subclass: #Machine
	instanceVariableNames: 'controlStack valueStack environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:33:13'!
continueIfWithTrueBranch: trueBranch andFalseBranch: falseBranch 
	
	| evaluatedCondition |
	
	evaluatedCondition:= valueStack removeLast.
	
	evaluatedCondition ifTrue: [controlStack add: trueBranch ] ifFalse: [controlStack add: falseBranch]! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 22:27:04'!
continueLetBindingIndex: bindIndex1 withBindings: bindsList2 body: expressionsList3 
	self shouldBeImplemented.! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 20:37:07'!
evaluateCallWithFunction: aFunctionName andArguments: anArgumentList
	
	[anArgumentList notEmpty] whileTrue:
		 [controlStack add: (anArgumentList removeLast).].
		
	controlStack add: aFunctionName. 
	! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 19:09:54'!
evaluateIfWithCondition: aConditionToEvaluate ifTrue: aTrueBranch ifFalse: aFalseBranch 
	
	| ifContinuation |
	
	ifContinuation:= IfContinuation withTrueBranch: aTrueBranch andFalseBranch: aFalseBranch .
	
	controlStack add:ifContinuation.
	
	controlStack add: aConditionToEvaluate. 
	! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 22:49:10'!
evaluateLetExprWith: aBindsList andBody: anExpressionsList
	
	| bindExpression newEnvironment |
	
	bindExpression:= aBindsList first second.
	
	newEnvironment:= environment copy. 
	
	controlStack add: (LetContinuation withBindings: aBindsList body: anExpressionsList toBind: 1 andEnvironment: newEnvironment). 
	
	controlStack add: bindExpression . 
	
	! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:43:56'!
evaluateLiteralExprWithValue: aValue 
	valueStack add: aValue ! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 21:04:46'!
evaluateVariableExprWIthName: aVariableName
 
	| value |
	
	(environment includesKey: aVariableName) 
		ifTrue: [value:= environment at:aVariableName.] 
		ifFalse: [].

	
	valueStack add: value.
		
	! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:27:46'!
initializeWithControlStack: aControlStack environment: anEnvironment
   
	controlStack := aControlStack .
	environment:= anEnvironment .
	valueStack := OrderedCollection new.
	! !

!Machine methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 21:44:55'!
resume
	|  instruction |
	
	[controlStack notEmpty] whileTrue: [
		instruction := controlStack removeLast.
		instruction evaluateIn: self.	
		
		].
	^{'done'. valueStack last. }! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Machine class' category: #ILPP!
Machine class
	instanceVariableNames: ''!

!Machine class methodsFor: 'as yet unclassified' stamp: 'CR 7/4/2026 18:25:51'!
withControlStack: aControlStack environment: anEnvironment  
	^self new initializeWithControlStack: aControlStack environment: anEnvironment ! !
