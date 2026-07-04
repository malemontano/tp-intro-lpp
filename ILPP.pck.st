'From Cuis7.9 [latest update: #8037] on 4 July 2026 at 5:00:29 pm'!
'Description '!
!provides: 'ILPP' 1 3!
!requires: 'ProbabilityDistributions' 1 2 nil!
SystemOrganization addCategory: #ILPP!


!classDefinition: #Expression category: #ILPP!
Object subclass: #Expression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!
!classDefinition: 'Expression class' category: #ILPP!
Expression class
	instanceVariableNames: ''!

!classDefinition: #Evaluate category: #ILPP!
Expression subclass: #Evaluate
	instanceVariableNames: 'expression environment address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!
!classDefinition: 'Evaluate class' category: #ILPP!
Evaluate class
	instanceVariableNames: ''!

!classDefinition: #Machine category: #ILPP!
Object subclass: #Machine
	instanceVariableNames: 'controlStack valueStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!
!classDefinition: 'Machine class' category: #ILPP!
Machine class
	instanceVariableNames: ''!

!classDefinition: #TPTest category: #ILPP!
TestCase subclass: #TPTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ILPP'!
!classDefinition: 'TPTest class' category: #ILPP!
TPTest class
	instanceVariableNames: ''!


!Expression methodsFor: 'as yet unclassified' stamp: 'mm 2/Jul/2026, 11:02:19 pm (UTC)'!
evaluate: anInstruction
	| expression environment address |
	expression := anInstruction second.
	environment := anInstruction third.
	address := anInstruction fourth.
	
	expression isSymbol! !

!Evaluate methodsFor: 'as yet unclassified' stamp: 'mm 3/Jul/2026, 12:14:48 am (UTC)'!
initializeWithExpression: anExpression withEnv: anEnvironment andAddress: anAddress 
	expression := anExpression .
	environment := anEnvironment .
	address := anAddress .! !

!Evaluate methodsFor: 'as yet unclassified' stamp: 'mm 3/Jul/2026, 12:39:34 am (UTC)'!
xxx: aMachine 
	aMachine xxxevaluate: expression .! !

!Evaluate class methodsFor: 'instance creation' stamp: 'mm 3/Jul/2026, 12:13:30 am (UTC)'!
expression: anExpression withEnv: anEnvironment andAddress: anAddress 
	^self new initializeWithExpression: anExpression  withEnv: anEnvironment andAddress: anAddress ! !

!Machine methodsFor: 'as yet unclassified' stamp: 'mm 3/Jul/2026, 12:28:28 am (UTC)'!
initializeWithControlStack: aControlStack  
	controlStack := aControlStack .
	valueStack := OrderedCollection new.
	! !

!Machine methodsFor: 'as yet unclassified' stamp: 'mm 3/Jul/2026, 12:47:50 am (UTC)'!
resume
	|  instruction |
	
	[controlStack notEmpty] whileTrue: [
		instruction := controlStack removeLast.
		instruction xxx: self.	
		
		].
	^{'done'. valueStack last. }! !

!Machine methodsFor: 'as yet unclassified' stamp: 'mm 3/Jul/2026, 12:46:38 am (UTC)'!
xxxevaluate: aValue 
	valueStack add: aValue ! !

!Machine class methodsFor: 'as yet unclassified' stamp: 'mm 2/Jul/2026, 11:42:22 pm (UTC)'!
withControlStack: aControlStack 
	^self new initializeWithControlStack: aControlStack ! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'mm 3/Jul/2026, 12:19:51 am (UTC)'!
test01SeCreaBienLaMaquina
	| aControlStack m env expr ev |
	env := Dictionary new.
	expr := 1 + 2.
	
	ev := Evaluate expression: expr withEnv: env andAddress: 0.
	"_, e, env, addr "
	aControlStack := {ev}.
	
	m := Machine withControlStack: aControlStack.
	
	self assert: m class equals: Machine.
	self assert: env class equals: Dictionary.
	self assert: ev class equals: Evaluate.
	
	! !

!TPTest methodsFor: 'as yet unclassified' stamp: 'mm 4/Jul/2026, 7:59:21 pm (UTC)'!
test02ResumeFuncionaParaEv
	| aControlStack m env expr ev result |
	env := Dictionary new.
	ev := Evaluate expression: 2 withEnv: env andAddress: 0.
	"_, e, env, addr "
	aControlStack := {ev} asOrderedCollection.
	m := Machine withControlStack: aControlStack.
	result := m resume.
	self assert: result equals: {'done'. 3}.
	self assert: 1 equals: 1.
	
	ev := Evaluate expression:  expr withEnv: env andAddress: 0.
	"_, e, env, addr "
	aControlStack := {ev} asOrderedCollection.
	m := Machine withControlStack: aControlStack.
	result := m resume.
	self assert: result equals: {'done'. 3}
	! !
