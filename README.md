# Demo-aggregates
Simple demo model using SpatialEntityAggregate in CORMAS
Init with squareForest set 3 rectangles of forest:
![init](https://github.com/user-attachments/assets/611982ae-7b5b-45ed-bf64-df5dc54b1733)

There is 2 possible steps:
* ## stepRebuild:
  each cell has a small probability of changing its state. 
	Then each grove expands on 10% of its external cells. 
	Finally, the aggregates are rebuilt
* ## stepMerge:
  each cell has a small probability of changing its state. 
	Then each grove expands on 10% of its external cells. 
	Finally, the existing aggregates are sorted from the biggest to the smallest, and each one updates its components: it may integrate the smaller ones in contact (merging) or be eaten by biggers. At the end, the scheduler checks for new groves that have been born not in contact to the previous ones

![merge](https://github.com/user-attachments/assets/8223dfce-d28e-45c4-8a65-914fa3e15aff)

> Here the central grove (yellow) has grown faster than the others and absorbed its neighbour (the red grove)
