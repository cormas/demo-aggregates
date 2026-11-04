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

{ #category : 'private' }
DAggregatesModelTest >> assertShowsPlotsAndOutlinesOfGroves [

	| pov |
	self assert: model groves isNotEmpty.
	pov := model groves first activePov.
	self assert: pov hasBorder.
	self deny: pov hasColor.

	self
		assert: (model cells detect: [ :each | each tree ]) activePov color
		equals: (Color fromHexString: '2C9931').
	self
		assert:
		(model cells detect: [ :each | each tree not ]) activePov color
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

{ #category : 'running' }
DAggregatesModelTest >> tearDown [

	DAPlot resetActivePovSelector.
	DAGrove resetActivePovSelector.
	super tearDown
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

	| pov |
	self initializeWith: #initForest.

	DAGrove activePovSelector: #povFilled.
	pov := model groves first activePov.

	self assert: pov hasColor.
	self assert: pov hasBorder
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

	self assert: model groves first activePov hasBorder
]
