"
I test how the demo shows its plots and groves.

## Responsibility:

- Check the points of view that each init method selects.
- Check that rebuilding the groves keeps the selected point of view.
- Check what the points of view of a grove specify.

## Collaborators:

- `DAggregatesModel`: the model under test, initialized through a `CMSimulation`.
- `DAPlot` and `DAGrove`: the entities whose points of view are selected.

## Public API and Key Messages

Run me as any `TestCase`. I reset the selected points of view after each test, as they are kept on the classes.

## Internal Representation

- `model`: the `DAggregatesModel` under test.
"
Class {
	#name : 'DAggregatesModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'DemoAggregates-Model-Tests',
	#package : 'DemoAggregates-Model-Tests'
}

{ #category : 'tests' }
DAggregatesModelTest >> assertShowsPlotsAndOutlinesOfGroves [

	| observer groveLook |
	self assert: model groves isNotEmpty.
	observer := CMObserver new.
	groveLook := observer lookOf: model groves first.
	self assert: groveLook borderThickness > 0.
	self assert: groveLook color alpha equals: 0.
	self
		assert:
		(observer lookOf: (model cells detect: [ :each | each tree ])) color
		equals: (Color fromHexString: '2C9931').
	self
		assert:
			(observer lookOf: (model cells detect: [ :each | each tree not ]))
				color
		equals: (Color fromHexString: 'F6EABD')
]

{ #category : 'private' }
DAggregatesModelTest >> initializeWith: anInitSelector [

	model := DAggregatesModel new.
	(CMSimulation for: model)
		randomSeed: 42;
		activeInitSelector: anInitSelector;
		activeControlSelector: #stepRebuild;
		initializeSimulation
]

{ #category : 'tests' }
DAggregatesModelTest >> testExpandAddsCellsToTheGrove [

	| grove sizeBefore |
	model := DAggregatesModel new.
	model
		createGridNumberOfRows: 5
		numberOfColumns: 5
		neighbourhood: 4
		closed: true.
	grove := model
		         createAggregate: DAGrove
		         from: { (model cellAt: 3 at: 3) }.
	sizeBefore := grove size.

	grove expand.

	self assert: grove size > sizeBefore
]

{ #category : 'tests' }
DAggregatesModelTest >> testFilledGroveHasAColorAndAnOutline [

	| observer look |
	self initializeWith: #initForest.
	observer := CMObserver new.
	observer perspective: model perspectiveFilledGroves.
	look := observer lookOf: model groves first.
	self assert: look color alpha > 0.
	self assert: look borderThickness > 0
]

{ #category : 'tests' }
DAggregatesModelTest >> testInitForestShowsPlotsAndOutlinesOfGroves [

	self initializeWith: #initForest.

	self assertShowsPlotsAndOutlinesOfGroves
]

{ #category : 'tests' }
DAggregatesModelTest >> testInitSquareForestsShowsPlotsAndOutlinesOfGroves [

	self initializeWith: #initSquareForests.

	self assertShowsPlotsAndOutlinesOfGroves
]

{ #category : 'tests' }
DAggregatesModelTest >> testRebuildingTheGrovesKeepsTheirOutlines [

	self initializeWith: #initForest.
	model buildForests.
	self assert:
		(CMObserver new lookOf: model groves first) borderThickness > 0
]
