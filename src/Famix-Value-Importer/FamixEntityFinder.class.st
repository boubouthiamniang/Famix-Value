"
An importer helper to find types in a Famix model, based on the usage of the `FamixTType` trait.
"
Class {
	#name : #FamixEntityFinder,
	#superclass : #Object,
	#instVars : [
		'model',
		'cache'
	],
	#category : #'Famix-Value-Importer'
}

{ #category : #accessing }
FamixEntityFinder >> cache [

	^ cache ifNil: [ cache := Dictionary new ]
]

{ #category : #enumerating }
FamixEntityFinder >> detectType: block [

	^ (self model allUsing: FamixTType) detect: block ifNone: nil
]

{ #category : #API }
FamixEntityFinder >> findMethodWithSignature: signature in: class [

	| candidates |
	class methods
		detect: [ :method | method signature = signature ]
		ifOne: [ :method | ^ method ].
	"signature might not exactly match due to representation format"
	candidates := self
		              findMethodsWithName:
		              (self methodNameFromSignature: signature)
		              in: class.
	candidates size = 1 ifTrue: [ ^ candidates anyOne ].
	"method might be overloaded, find the one with matching signature"
	candidates := candidates select: [ :method | 
		              self signatureOf: method matches: signature ].
	candidates size = 1 ifTrue: [ ^ candidates anyOne ].
	candidates ifEmpty: [ 
		NotFound signalFor: signature in: class methods ].
	"consider returning a specific candidate; TODO: better"
	self error: 'found multiple methods matching signature: ' , signature
]

{ #category : #API }
FamixEntityFinder >> findMethodsWithName: name in: class [

	self flag: #VerveineJ. "should not have to use a Set for methods"
	^ class methods asSet select: [ :method | method name = name ]
]

{ #category : #API }
FamixEntityFinder >> findTypeNamed: name [

	"Main API for finding a type, should not be overridden."

	^ self cache at: name ifAbsentPut: [ self parseTypeName: name ]
]

{ #category : #enumerating }
FamixEntityFinder >> findTypeWithMooseName: name [

	^ self detectType: [ :type | type mooseName = name ]
]

{ #category : #enumerating }
FamixEntityFinder >> findTypeWithName: name [

	^ self detectType: [ :type | type name = name ]
]

{ #category : #enumerating }
FamixEntityFinder >> methodNameFromSignature: signature [

	self subclassResponsibility
]

{ #category : #accessing }
FamixEntityFinder >> model [

	^ model ifNil: [ model := FamixModel new ]
]

{ #category : #accessing }
FamixEntityFinder >> model: aFamixModel [

	model := aFamixModel
]

{ #category : #enumerating }
FamixEntityFinder >> parseTypeName: name [

	"This method can be overriden to modify how the search is executed."

	^ self findTypeWithName: name
]

{ #category : #matching }
FamixEntityFinder >> signatureOf: method matches: signature [

	self subclassResponsibility
]