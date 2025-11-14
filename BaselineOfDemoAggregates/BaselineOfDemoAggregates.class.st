Class {
	#name : 'BaselineOfDemoAggregates',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDemoAggregates',
	#package : 'BaselineOfDemoAggregates'
}

{ #category : 'baselines' }
BaselineOfDemoAggregates >> baseline: spec [

	<baseline>
	spec for: #common do: [

		"Packages"
		spec
			package: 'DemoAggregates-Model'";
			package: 'DemoAggregates-Model-Tests' with: [ spec requires: #( 'DemoAggregates-Model' ) ]" ]
]
