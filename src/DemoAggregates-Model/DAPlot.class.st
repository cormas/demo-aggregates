Class {
	#name : 'DAPlot',
	#superclass : 'CMCell',
	#instVars : [
		'tree'
	],
	#category : 'DemoAggregates-Model',
	#package : 'DemoAggregates-Model'
}

{ #category : 'aspects' }
DAPlot >> aspectDefault: look [

	<aspect>
	look color: (tree
			 ifTrue: [ Color fromHexString: '2C9931' ]
			 ifFalse: [ Color fromHexString: 'F6EABD' ])
]

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

{ #category : 'accessing' }
DAPlot >> tree [

	^ tree
]

{ #category : 'accessing' }
DAPlot >> tree: aBoolean [

	tree := aBoolean
]
