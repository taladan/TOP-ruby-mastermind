## Links
So, having never played this game before, I'm going to take some time to break down the rules of it.  Let's start with the pertinent links:

- [Mastermind Game description at Wikipedia](https://en.wikipedia.org/wiki/Mastermind_(board_game))
- [Article suggested on the TOP assignment page](https://puzzling.stackexchange.com/questions/546/clever-ways-to-solve-mastermind) -  Clever ways to solve MM
- [Found game online with linked rules](https://webgamesonline.com/mastermind/rules.php)  -  These are closer to English.


## Needs
- Gameboard to track pieces
- track and store number of guesses and which guesses the were
- generate a random 'secret'.
- compare guesses to 'secret' with the capability of displaying the result of the comparison (correct color & position - non-white, correct color - white, incorrect color - empty space)


Empty circle:  "○"
Filled circle: "●"

### This is how each run of comparisons should work 

Let's assume we have a code set of:
my_code = [1,2,3,4]
player_guess = "5621"

format_guess(player_guess)
returns:  player_guess = [5, 6, 2, 1]


 Test each member of player guess against code array
 is 5 in my_code?
	 no -> push " " onto results
 is 6 in my_code?
	 no -> push " " onto results
 is 2 in my_code?
	 yes!
		 is 2 in position 3 in my_code?
			 no - > push "○" onto results
 is 1 in my_code?
	 yes!
		 is 1 in position 3 in my_code?
			 no -> push "○" onto results

Return results = `[" ", " ", "○","○"]`

We will trim any blank spaces out of the return results before display.

prompt player for another guess:
player_guess = "1523"

Test each memeber again:
is 1 in my_code?
	yes!
		 is 1 in position 0 in my_code?
			 yes -> push ""●" onto results
Is 5 in my_code?
	 no -> push "  " onto results
Is 2 in my_code?
	yes!
	is 2 in position 2 in my_code?
		 no -> push "○" onto results
is 3 in my_code?
	yes!
	is 3 in position 3 in my_code?
		 no -> push "○" onto results
return results = `["●", "  ", "○", "○"]`

#### Edge cases:

With our current pattern of matching player guesses to cypher:
```ruby
def determine_positions(guess_array, cypher)
  right_guess_wrong_space = "\u25cb"
  right_guess_right_space = "\u25cf"
  wrong_guess = " "

  results = []
  guess_array.each_with_index do |guess, index|
    if cypher.include?(guess)
      if guess == cypher[index]
        results.push(right_guess_right_space)
      else
        results.push(right_guess_wrong_space)
      end
    else
      results.push(wrong_guess)
    end
  end
  results
end
```

We have an edge case to deal with.  What if the cypher is something like `[6,5,2,2]`, and our player  guesses `[2,6,6,5]` we get invalid results: `["○", "○", "○", "○"]`

So, our problem lies in when there are duplicates either in the player guess or the cypher.  If there are duplicates in either or both, we need to track which index we're using/matching against and when it is matched, remove that from future matches so we don't get false positives.

We can clone the cypher into a new variable within the determine_positions method:

`working_cypher = cypher.clone`

And this way we can remove elements from the working cypher while leaving the original cypher in tact.  Theoretically this should allow us to  iterate through the player guesses, when it determines it has found one of the numbers in the player guess inside of the working_cypher, we can extract that number from the working cypher for future iterations within the context of determine_position and it shouldn't match any duplicates from the player's guess.  The issue that we will need to do is replace the matched number (correct index or no) with a character that can't possibly match, but will keep the indexing in the working cypher correct.