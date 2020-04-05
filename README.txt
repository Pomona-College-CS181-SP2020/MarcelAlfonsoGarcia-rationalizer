This is my version of the rationalizer idea!

Rationalizer
Description
An interactive application for scaling recipes. Anyone can input the
ingredient list for a recipe and scale it up or down.

Some user stories:

I can enter any number of ingredients with quantities like "2 Tbsp
vanilla" or "1 C sugar" or "one pound flour".

Once I've entered a recipe, I can scale it as much as is
feasible. (E.g., a recipe with 2 eggs in it can be halved but not
quartered.)

When I enter unidentifiable entries, e.g., "some potatoes", I am
shown a warning that this entry couldn't be processed and so is
unscalable.

Plan
This project is probably best written in Elm, though PureScript would
work well, too. There are tools that convert Haskell to JS; they are
meant to work well, but I don't know them. Idris is another
interesting option.

There are three fundamental parts:

the user interface logic
the representation of a list of ingredients
the scaling logic
Getting the representation right is the key move. You'll start with a
list of strings, but you'll need to move to something much more
informative!

Timeline
Work through the Elm tutorial. Look at some existing Elm projects
(I can point you in the right direction).
Mock up an interface on paper, then in HTML and CSS.
Allow interactive entry for a fixed number of ingredients.
Allow ingredients to be added or removed.
Allow ingredients to be rearranged.
Parse ingredients into a meaningful
Determine whether ingredients can be scaled.
Actually scale recipes.
Success criteria
The user stories in the description must work.

MUST HAVE: clean, interactive UI

good, clear error messages
doesn't ever erase user input
GOOD TO HAVE: use HTTPS

STRETCH: some form of persistence, whether in localStorage
(JS-accessible storage per user) or in a database that allows sharing

STRETCH: some notion of user, with a collection of recipes
comes with difficult security work

STRETCH: ability to search all recipes

STRETCH: support mappings between volume and weight for some
ingredients (a tricky question!)

STRETCH: support ranges in weights, e.g., "a 2-4lb pumpkin"

STRETCH: provide warnings for tricky scaling
heavily scaling recipes with watery veg like pumpkin and peppers is nonlinear
scaling recipes with browning before braising may require multiple steps
scaling down below 2g or 1/8tsp is hard to measure
