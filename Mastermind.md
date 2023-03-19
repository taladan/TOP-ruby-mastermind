## Links

So, having never played this game before, I'm going to take some time to break down the rules of it. Let's start with the pertinent links:

- [Mastermind Game description at Wikipedia](<https://en.wikipedia.org/wiki/Mastermind_(board_game)>)
- [Article suggested on the TOP assignment page](https://puzzling.stackexchange.com/questions/546/clever-ways-to-solve-mastermind) - Clever ways to solve MM
- [Found game online with linked rules](https://webgamesonline.com/mastermind/rules.php) - These are closer to English.

## Needs

- Gameboard to track pieces
- track and store number of guesses and which guesses the were
- generate a random 'secret'.
- compare guesses to 'secret' with the capability of displaying the result of the comparison (correct color & position - non-white, correct color - white, incorrect color - empty space)

### Assets

#### Game pieces

"\u2b24" - Large (black) circle - large filled circle: ⬤
"\u25ef" - Large (white) circle - large empty circe: ◯
"\u25cb" - (white) circle - empty circle: ○
"\u25cf" - (black) circle - filled circle: ●

#### Box characters:

"\u2554" - Double down and right:╔
"\u2557" - Double down and left: ╗
"\u255a" - Double up and right: ╚
"\u255d" - Double up and left: ╝
"\u2550" - Double horizontal: ═
"\u2560" - Double vertical and right: ╠
"\u2563" - Double vertical and left: ╣
"\u2564" - Down single and horizontal double: ╤
"\u2567" - Up single and horizontal double: ╧
"\u2551" - Double vertical: ║
"\u2502" - Light vertical: │
"\u256a" - Vertical single and horizontal double: ╪

╔════════════╤════════╗
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╠════════════╪════════╣
║⬤ ⬤ ⬤ ⬤ ● ● ● ● ║
╚════════════╧════════╝
╔═══════════╗
║⬤ ⬤ ⬤ ⬤║
╚═══════════╝
