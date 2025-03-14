Class {
	#name : 'DAGrove',
	#superclass : 'CMSpatialEntityAggregate',
	#category : 'DemoAggregates-Model',
	#package : 'DemoAggregates-Model'
}

{ #category : 'environment - distance' }
DAGrove >> expand [
	"A grove expands on 10% of its external cells"

	| collec |
		collec := self 
			          selectRandomlyFrom: self surround
			          size: (self surround size / 10) ceiling.
	collec do: [ :c | c tree: true ]
]

{ #category : 'environment - distance' }
DAGrove >> surroundSize [
 ^surround size
]
