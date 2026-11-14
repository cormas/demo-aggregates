Class {
	#name : 'DAGrove',
	#superclass : 'CMSpatialEntityAggregate',
	#category : 'DemoAggregates-Model',
	#package : 'DemoAggregates-Model'
}

{ #category : 'aspects' }
DAGrove >> aspectDefault: look [
	"Show the plots of the grove, with a line around them"

	<aspect>
	look
		borderColor: Color black;
		borderThickness: 0.1
]

{ #category : 'aspects' }
DAGrove >> aspectFilled: look [
	"Show the grove as one solid shape, with a line around it"

	<aspect>
	look
		color: (Color fromHexString: '486862');
		borderColor: Color black;
		borderThickness: 0.1
]

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

	self isDead ifTrue: [ ^ nil ].
	self neighbourhood do: [ :ag | self mergeWith: ag ]
]

{ #category : 'environment - distance' }
DAGrove >> surroundSize [
 ^surround size
]

{ #category : 'control' }
DAGrove >> update [
	"Updates by integrating its surrounded plots in tree. This is a recursive method"

	| surroundedTrees |
	surroundedTrees := self surround select: [ :c |
		                   c tree and: [ c belongsToGrove not ] ].
	surroundedTrees ifEmpty: [ ^ self ].
	self addComponents: surroundedTrees.
	self update
]
