# 4/5/2020
Form looks messy, cannot figure out how to use elm's form to create textboxes automatically
 -- Fixed by changing to etaque/elm-form and following a basic guide

# 4/8/2020
Travis CI doesn't work at all

# 4/9/2020
Travis CI doesn't work at all
Unable to meaningfully validate inputs, i.e. can only check if they are strings but cannot check that value is correct
  Soln: Had to create lists for numbers and amounts and ensure that the inputs where in those lists

# 4/14/2020
Travis CI refuses to work with current setup
When running elm-test, process runs for a long time even though there is one Test
  Soln: There was an error with the parser I was using
Having problems formatting error messages to look nicely

# 4/18/2020
Having a lot of problems getting Node and npm installed properly
  Soln: Had to reinstall multiple times, ended up getting a tool to manage my versions
Still no progress in getting Travis CI to work
  Soln: Had to change Travis to run with elm 0.19.0 and node_js 9

# 4/19/2020
Travis CI seems to accept elm now, but is failing when trying to run elm-format
Can validate amounts inputs but cannot parse them into usable Floats
 Soln: Matched user input with an element of my list of acceptable inputs and given the index of the element I could determine the value (required sorting my list of acceptable amount inputs)
Having problems formatting error messages to look nicely

#4/25/2020
Travis CI seems to accept elm now, but is failing when trying to run elm-format
Struggling to get elm-format running on my computer

# 5/2/2020
Travis CI seems to accept elm now, but is failing when trying to run elm-format
Cannot figure out how to add the first ingredient input fields without using scale
Making the conversions will require a lot of graph algorithms work
Having problems formatting error messages to look nicely
