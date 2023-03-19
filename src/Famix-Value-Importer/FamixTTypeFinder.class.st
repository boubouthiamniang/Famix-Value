"
An importer helper to find types in a Famix model, based on the usage of the `FamixTType` trait.
"
Class {
	#name : #FamixTTypeFinder,
	#superclass : #Object,
	#instVars : [
		'model',
		'cache'
	],
	#category : #'Famix-Value-Importer'
}

{ #category : #accessing }
FamixTTypeFinder >> cache [

	^ cache ifNil: [ Dictionary new ]
]

{ #category : #enumerating }
FamixTTypeFinder >> detectType: block [

	^ (self model allUsing: FamixTType) detect: block ifNone: nil
]

{ #category : #API }
FamixTTypeFinder >> findTypeNamed: name [

	"Main API for finding a type, should not be overridden."

	^ self cache at: name ifAbsentPut: [ self parseTypeName: name ]
]

{ #category : #enumerating }
FamixTTypeFinder >> findTypeWithFullName: name [

	^ self detectType: [ :type | type mooseName = name ]
]

{ #category : #enumerating }
FamixTTypeFinder >> findTypeWithName: name [

	^ self detectType: [ :type | type name = name ]
]

{ #category : #enumerating }
FamixTTypeFinder >> model [

	^ model ifNil: [ model := FamixModel new ]
]

{ #category : #enumerating }
FamixTTypeFinder >> model: aFamixModel [

	model := aFamixModel
]

{ #category : #API }
FamixTTypeFinder >> parseTypeName: name [

	"This method can be overriden, e.g. to modify how the search is executed."

	^ self findTypeWithName: name
]