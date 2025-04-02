Class {
	#name : 'DAGrove',
	#superclass : 'CMSpatialEntityAggregate',
	#category : 'DemoAggregates-Model',
	#package : 'DemoAggregates-Model'
}

{ #category : 'initialize' }
DAGrove >> beTree [

	self elementaryComponents do: [ :c | c beTree ].
]

{ #category : 'control' }
DAGrove >> expand [
	"A grove expands on 10% of its external cells"

	| collec |
	collec := self
		          selectRandomlyFrom: self surround
		          size: (self surround size / 10) ceiling.
	collec do: [ :c | c tree: true ].
	self addComponents: collec.
	self update.
]

{ #category : 'control' }
DAGrove >> mergeWithNeighbours [
	"This grove merges with the other groves connected to it (they are destroyed)"

	| surroundingCells surroundingGroves |
	self destroyed ifTrue: [ ^ nil ].
	surroundingCells := self surround select: [ :c |
		                    c aggregates anySatisfy: [ :ag |
			                    ag class = self class ] ].
	surroundingGroves := Set new.
	surroundingCells do: [ :c | surroundingGroves addAll: c aggregates ].
	surroundingGroves do: [ :ag |
		self destroyed ifFalse: [ self mergeWith: ag ] ]
]

{ #category : 'environment - distance' }
DAGrove >> surroundSize [
 ^surround size
]

{ #category : 'control' }
DAGrove >> update [
	"Updates by integrating its surrounded plots in tree. Recursivity"

	| surroundedTrees |
	surroundedTrees := self surround select: [ :c | c tree and: [c belongsToGrove not]].
	surroundedTrees ifEmpty: [ ^ self ].
	self addComponents: surroundedTrees.
	self update
]
