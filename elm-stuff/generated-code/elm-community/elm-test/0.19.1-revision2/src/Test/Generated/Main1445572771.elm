module Test.Generated.Main1445572771 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.emptyRecipe] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 374529710760801, processes = 4, paths = ["C:\\Users\\Marcel Alfonso\\Desktop\\MarcelAlfonsoGarcia-rationalizer\\tests\\Example.elm"]}