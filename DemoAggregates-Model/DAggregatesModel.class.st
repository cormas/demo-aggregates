"
DemoAggregatesModel represents a landscape with trees and groves that expands.
"
Class {
	#name : 'DAggregatesModel',
	#superclass : 'CMAbstractModel',
	#instVars : [
		'thePlots',
		'theGroves'
	],
	#category : 'DemoAggregates-Model',
	#package : 'DemoAggregates-Model'
}

{ #category : 'as yet unclassified' }
DAggregatesModel class >> aboutThisModel [

	^ ''
]

{ #category : 'as yet unclassified' }
DAggregatesModel class >> prefix [

	^ 'DA'
]

{ #category : 'aggregates' }
DAggregatesModel >> buildForests [
	"Release all the groves, then creates the Aggregates from trees. Each aggregate must be bigger than 2 cells"

	self releaseAggregateType: DAGrove.
	self
		createAggregates: DAGrove
		from: DAPlot
		verifying: [ :aCell | aCell tree ]
		minimumSize: 2.
	self theGroves do: [ :agg | "self spaceModel meanCompactness: DAGrove"
		agg initNeighbourhood ]
]

{ #category : 'aggregates' }
DAggregatesModel >> buildSmallForests [
	"Create the Aggregates from trees. Each aggregate must be bigger than 2 cells and not belonging to an existing grove"

	self
		createAggregates: DAGrove
		from: DAPlot
		verifying: [ :aCell | aCell tree and: [ aCell belongsToGrove not ] ]
		minimumSize: 2.
	self theGroves do: [ :agg |
		agg initNeighbourhood ]
]

{ #category : 'probes' }
DAggregatesModel >> grovesAverageSize [

	<probeNamed: 'Average size of the groves' color: 'FF9900'>
	^ (self theGroves collect: [ :each | each size ]) average
]

{ #category : 'initialization' }
DAggregatesModel >> initForest [
	"1st init: just creates a grid with some trees"

	<init>
	self
		createGridNumberOfRows: 20
		numberOfColumns: 20
		neighbourhood: 4
		closed: true.
	(self pickRandomCells: (self cells size / 5) rounded) do: #beTree.

	self buildForests.
	DAPlot activePovSelector: #povGrove
]

{ #category : 'initialization' }
DAggregatesModel >> initSquareForests [
	"3rd init: just creates a grid and divided it by 3 x 5 aggregates"

	<init>
	"creates the grid"
	self
		createGridNumberOfRows: 20
		numberOfColumns: 20
		neighbourhood: 4
		closed: true.
	"creates 15 regular aggregates"
	self
		createAggregates: DAGrove
		horizontalDividers: 5
		verticalDividers: 3.
	"set some trees"	
	(self pickRandomCells: (self cells size / 15) rounded) do: #beTree.
	self theGroves first beTree.
	(self theGroves at: 8) beTree.
	self theGroves last beTree.
	"Remove previous aggregates and creates the groves"
	self buildForests.
	DAPlot activePovSelector: #povGrove.
]

{ #category : 'initialization' }
DAggregatesModel >> initialize [

	super initialize.

	thePlots := OrderedCollection new.
	theGroves := OrderedCollection new
]

{ #category : 'probes' }
DAggregatesModel >> nbOfGroves [

	<probeNamed: 'Number of groves' color: '00b44c'>
	^ self theGroves size
]

{ #category : 'control' }
DAggregatesModel >> stepMerge [
	"Each cell has a small probability of changing its state. 
	Then each grove expands on 10% of its external cells. 
	Then, the existing aggregates are sorted from the biggest to the smallest, then each one updates its components: may integrate a smaller ones in contact (merging) or be eaten by biggers.
	Finally the scheduler checks for new groves that have been born not in contact to the previous ones "

	<control>
	self thePlots do: [ :c | c changeState ].
	self theGroves do: [ :a | a expand ].
	self buildSmallForests.
	(self theGroves asSortedCollection: [ :a :b | a size > b size ]) do:
		#mergeWithNeighbours
]

{ #category : 'control' }
DAggregatesModel >> stepRebuild [
	"Each cell has a small probability of changing its state. 
	Then each grove expands on 10% of its external cells. 
	Finally, the aggregates are rebuilt"

	<control>
	self thePlots do: [ :c | c changeState ].
	self theGroves do: [ :a | a expand ].
	self buildForests
]

{ #category : 'accessing' }
DAggregatesModel >> theGroves [
	<getterFor: #DAGrove>

	^ theGroves
]

{ #category : 'accessing' }
DAggregatesModel >> theGroves: anObject [

	theGroves := anObject
]

{ #category : 'accessing' }
DAggregatesModel >> thePlots [

	<getterFor: #DAPlot>
	^ thePlots
]

{ #category : 'probes' }
DAggregatesModel >> totalSurrounds [

	<probeNamed: 'Size of the groves'' surrounds' color: '3498DB'>
	^ (self theGroves collect: [ :each | each surroundSize ]) sum
]
