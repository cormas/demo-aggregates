Class {
	#name : 'DAPlot',
	#superclass : 'CMSpatialEntityElement',
	#instVars : [
		'tree'
	],
	#category : 'DemoAggregates-Model',
	#package : 'DemoAggregates-Model'
}

{ #category : 'accessing' }
DAPlot >> beEmpty [

	tree := false
]

{ #category : 'accessing' }
DAPlot >> beTree [
	tree := true
]

{ #category : 'testing' }
DAPlot >> belongsToGrove [
	^self belongsToAggregateType: DAGrove
]

{ #category : 'control' }
DAPlot >> changeState [

	
	"The cell has a small probability of changing its state "
	
	self random < 5.0e-3 ifTrue: [self tree: self tree not]
]

{ #category : 'accessing' }
DAPlot >> forestSurroundingRatio [
"Returns the number of neighbour cells that belong to a grove, divided by the size of the neighbourhood"
	^(self neighbourhood select: [:n | n belongsToGrove]) size
		/ self neighbourhood size
]

{ #category : 'initialization' }
DAPlot >> initialize [ 

	super initialize.
	tree := false.
]

{ #category : 'pov' }
DAPlot >> povGrove [

	<pov>
	^ self belongsToGrove
		  ifTrue: [ (self getAggregateType: DAGrove) povId "CMPointOfView color: (Color fromHexString: '486862')" ]
		  ifFalse: [ self povTree ]
]

{ #category : 'pov' }
DAPlot >> povTree [

	<pov>
	^ tree
		  ifTrue: [ CMPointOfView color: (Color fromHexString: '2C9931') ]
		  ifFalse: [ CMPointOfView color: (Color fromHexString: 'F6EABD') ]
]

{ #category : 'accessing' }
DAPlot >> tree [

	^ tree
]

{ #category : 'accessing' }
DAPlot >> tree: aBoolean [

	tree := aBoolean
]
