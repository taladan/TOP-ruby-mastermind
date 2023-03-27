# Mastermind

## Initial thoughts

## Links

So, having never played this game before, I'm going to take some time to break down the rules of it. Let's start with the pertinent links:

- [Mastermind Game description at Wikipedia](<https://en.wikipedia.org/wiki/Mastermind_(board_game)>)
- [Article suggested on the TOP assignment page](https://puzzling.stackexchange.com/questions/546/clever-ways-to-solve-mastermind) - Clever ways to solve MM
- [Found game online with linked rules](https://webgamesonline.com/mastermind/rules.php) - These are closer to English.

## Needs

- track and store number of guesses and which guesses the were
- generate a random 'secret'.
- compare guesses to 'secret' with the capability of displaying the result of the comparison (correct number & position - filled circle, correct number - empty circle, incorrect number - no indicator)

### Assets

#### Game pieces

"\u25cb" - (white) circle - empty circle: ○
"\u25cf" - (black) circle - filled circle: ●


## Though process so far

I initially thought that I'd get through this without needing to touch OOP. Boy was I wrong!  Once I got into the section of code where it was time to generate the code to break, I realized that my code was becoming unwieldy and would rapidly expand into the 'difficult to navigate' territory.  

Once I got to code generation, I realized that it made more sense to break the code out into its own logical object to be able to deal with the various options that are avaiable in gameplay.  According to the rules of the game, players can choose to play with duplicates and blanks allowed in the code, or not.  That was not too difficult to implement, but realizing that because the player could choose to either break the code or make the code, I would have to set up a method to allow the computer to generate a cypher, as well as a method to allow the player to pick a cypher it simply made more sense to set up an object to handle the cypher logic.

### Computer generates cypher

```ruby
def breaker_generate()

	# Returns an array of 4 random numbers between 1 and 6 (inclusive)
	
	cypher = []
	
	valid_pool = set_pool()
	
	  
	
		if @duplicates
		
			@length.times { |i| cypher.push(valid_pool.sample()) }
		
		else
		
			@length.times { |i| cypher = valid_pool.sample(@length) }
		
		end
	
		@cypher = cypher
	
		cypher
	
end
```

### Player generates cypher

```ruby
def maker_generate()

	cypher = []
	
	valid_pool = set_pool()
	
	  
	
	if @duplicates
	
		@length.times do |i|
		
			clear_screen()
			
			choice = validate_choice(valid_pool)
			
			puts "Adding #{choice} to code."
			
			cypher.push(choice)
			
			sleep(1)
			
		end
	
	# remove members of the pool when prompting
	
	else
	
		@length.times do |i|
		
			clear_screen()
			
			choice = validate_choice(valid_pool)
			
			puts "Adding #{choice} to code."
			
			cypher.push(choice)
			
			_ = valid_pool.delete(choice)
			
			sleep(1)
			
		end
			
	end
	
	@cypher = cypher
	
	cypher

end
```

### Player objects

Currently I am using the player object to store the configuration data that the player chooses for the game:

- Are duplicates allowed?
- Are spaces allowed?
- How many turns (8-12)?
- Length of the code to break (max 6, default 4)?
- role (maker or breaker)
- guess history & outcomes

## Computer objects
The computer will inherit from the player class, simply to store guess history and outcomes as a separate object from the player (it just doesn't need all the config data duplicated).



## The problem now

So, the problem I am facing now is dealing with the actual game turns.  

### Computer guesses
I would like to implement Donald Knuth's five-guess algorithm (though I suspect with blanks added into the mix, it won't be able to always hit the answer in 5 guesses).  To be able to implement a solver however, I will need to pass the game options to the computer object for it to solve.  I should be able to do this by passing Player.config to either the instantiation of the computer object or the method call to begin the solve. 

This program describes the Five−Guess Algorithm made by Knuth

#### Variables:
`m = number of 'pins' (length of code)`

`n = number of 'colors' in our case 6 colors if blanks are not allowed, 7 if they are`

`a/na = are duplicate colors (numbers/blanks) allowed? a = yes, na = no`
 
```pseudocode
function Mastermind(n , m, a / na){
	total_codes = GetTotalCodes (n , m, a / na)
	knuth_codes = total_codes
	possible_codes = total_codes
	mastermind_code = GetMastermindCode( total_codes )
	WHILE mastermind_code has not been cracked :
		code = GetCode( knuth_codes , possible_codes )
		feedback = GuessCode( mastermind_code , code )
		IF feedback == (m cp and 0 wp) :
			mastermind_code has been cracked
		ELSE:
			PruneList ( code , feedback , knuth_codes )
		ENDIF
	ENDWHILE
	return number of guesses needed to crack the code
}

function PruneList ( last_guess , feedback , knuth_codes){
	FOR each code in knuth_codes :
		retrieved_feedback = GuessCode( code , last_guess )
		IF retrieved_feedback != feedback :
			remove code from knuth_codes
		ENDIF
	ENDFOR
}

function GetMastermindCode( total_codes ){
	return a random code from total_codes
}

function GetTotalCodes (n , m, a / na){
	return l i s t of a l l codes that can be made
	with the rules specified by the user .
}

function GetCode( knuth_codes , possible_codes ){
	guess_codes = MiniMax( knuth_codes , possible_codes )
	code = GetGuessCodeFromList ( knuth_codes , guess_codes )
	remove code from possible_codes
	return code
}

function GetGuessCodeFromList ( knuth_codes , guess_codes){
	return the f i r s t knuth_code we can find in guess_codes
	return the f i r s t code in guess_codes i f we could not find a knuth_code
}

function MiniMax( knuth_codes , possible_codes ){
	FOR each code in possible_codes :
		FOR each code_to_crack in knuth_codes :
			feedback = GuessCode( code_to_crack , code )
			times_found [ feedback]++
		ENDFOR
		maximum = GetMaxValue( times_found )
		scores [ code ] = maximum
	ENDFOR
 
	minimum = GetMinValue ( scores )
 
	FOR each code in possible_codes :
		IF scores [ code ] == minimum:
			add code to guess_codes
		ENDIF
	ENDFOR
	return guess_codes
}

function GuessCode( code_to_crack , code){
	compare code_to_crack and code
	return number of cp and wp
}
```

### Player guesses
