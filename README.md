# AoC2022

My code solutions for [Advent of Code 2022](https://adventofcode.com/)

---
- [AoC2022](#aoc2022)
  - [Day-1](#day-1)
    - [Puzzle-1: Elf with most food calories](#puzzle-1-elf-with-most-food-calories)
    - [Puzzle-2: Three Elves with most food calories](#puzzle-2-three-elves-with-most-food-calories)

---

## Day-1

### Puzzle-1: Elf with most food calories

Summary of solution

- Read the input file
  - initially by blocks separated by a double newline `\n\n`, store in a `[String]`, i.e. each elf's 'backpack' food items
  - then, for each backpack, get each individual item and convert to `Int`, this is the calorie value of the food item

Store the data in a set of structs...

``` swift
struct FoodItem {
  var calories: Int
}

struct Backpack {
  var foods: [FoodItem]
  var totalFoodCalories: Int {
    get { return foods.reduce(0) { $0 + $1.calories } }
  }
}

struct Elf {
  var elfNum: Int
  var backpack: Backpack
}
struct ElfExpedition {
  var elves: [Elf]
}
```

To find the elf who has the food items with the most calories, we could iterate over the entire array of elves in the expedition party, keeping a record of the elf with the highest number of calories.

This seemed a little cumbersome so I decided to create a custom sort for `ElfExpedition` and although not required for the solution, I allowed for the elf array to be sorted in `ASC` or `DESC` order.

``` swift
enum SortOrder {
  case ASC
  case DESC
}

extension ElfExpedition {
  mutating func sortByBackpackCalories(sortOrder: SortOrder) {
    if sortOrder == .ASC {
      elves.sort { $0.backpack.totalFoodCalories < $1.backpack.totalFoodCalories }
    }
    else {
      elves.sort { $0.backpack.totalFoodCalories > $1.backpack.totalFoodCalories }
    }
  }
}
```

The elf with the food items having the highest calories is found by...

``` swift
elfExpedition.sortByBackpackCalories(sortOrder: .DESC)
  
let d1p1Ans = elfExpedition.elves.first?.backpack.totalFoodCalories ?? 0
```

### Puzzle-2: Three Elves with most food calories

Summary of solution

- Use the sorted array from puzzle-1, then simply add the backpack calories for the top three items in the array

``` swift
let top3 = elfExpedition.elves.count > 3 ? Array(elfExpedition.elves.prefix(3)) : elfExpedition.elves
let d1p2Ans = top3.reduce(0) { $0 + $1.backpack.totalFoodCalories}
```

> **NOTE:** Prior to starting today's puzzles, I did not know that puzzle-2 would ask for the top-X number of entries in the array; so by luck the custom sort that I created made the second part very easy.

---
