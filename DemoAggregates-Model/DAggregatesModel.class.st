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
	"Create the Aggregates from trees. Each aggregate must be bigger than 25 cells, then set the compactness of the groves"

	self releaseAggregateType: DAGrove.
	self
		createAggregates: DAGrove
		from: DAPlot
		verifying: [ :aCell | 
			aCell tree ]	
			minimumSize: 2.
	"self theGroves do: [ :agg | agg initNeighbourhood ].
	self spaceModel meanCompactness: DAGrove"
]

{ #category : 'aggregates' }
DAggregatesModel >> buildForestsAndMeadows [
	"Create the Aggregates from trees and no trees. Each aggregate must be bigger than 2 cells, then set the compactness of the groves"

	self releaseAggregateType: DAGrove.
	self createAggregates: DAGrove from: DAPlot attribute: #tree minimumSize: 2.
	"self theGroves do: [ :agg | agg initNeighbourhood ].
	self spaceModel meanCompactness: DAGrove"
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
	DAPlot activePovSelector: #povTree
]

{ #category : 'initialization' }
DAggregatesModel >> initForestAndMeadows [
"2nd init: creates groves & meadows"

	<init>
	self
		createGridNumberOfRows: 20
		numberOfColumns: 20
		neighbourhood: 4
		closed: true.
	(self pickRandomCells: (self cells size / 5) rounded) do: #beTree.

	self buildForestsAndMeadows.
	DAPlot activePovSelector: #povTree
]

{ #category : 'initialization' }
DAggregatesModel >> initSquareForests [
"3rd init: just creates a grid and divided it by 3 x 5 aggregates"

	<init>
	self
		createGridNumberOfRows: 20
		numberOfColumns: 20
		neighbourhood: 4
		closed: true.
	self
		createAggregates: DAGrove
		horizontalDividers: 5
		verticalDividers: 3.
	(self pickRandomCells: (self cells size / 15) rounded) do: #beTree.
	self theGroves first elementaryComponents do: [ :c | c beTree ].
	(self theGroves at: 8) elementaryComponents do: [ :c | c beTree ].
	self theGroves last elementaryComponents do: [ :c | c beTree ].

	DAPlot activePovSelector: #povTree
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

{ #category : 'initialization' }
DAggregatesModel >> stepForest [

	<control>
"Each cell has a small probability of changing its state. Then each grove expands on external cells that are mostly surrounded by groves. Finally, the aggregates are rebuilt"
	self thePlots do: [:c | c changeState].
	self theGroves do: [:a | a expand].
	self buildForests
]

{ #category : 'initialization' }
DAggregatesModel >> stepForestAndMeadows [
	"Each cell has a small probability of changing its state. Then each grove expands on external cells that are mostly surrounded by groves. Finally, the aggregates are rebuilt"

	<control>
	self thePlots do: [ :c | c changeState ].
	self theGroves do: [ :a | a expand ].
	self buildForestsAndMeadows
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
