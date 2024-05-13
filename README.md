# Game of Life with Zombies

This program is a Haskell implementation of Conway's Game of Life, a cellular automaton, with the addition of zombies. In this version, the grid consists of cells that can be in one of three states: living human, dead space, or infected zombie. The rules of the game determine how these cells evolve.

## Rules

The rules of the Game of Life with Zombies are as follows:

1. Any live cell (human) with fewer than two live neighbors or one or more infected neighbors (zombies) dies as if caused by under-population or zombie infection.
2. Any live cell (human) with two or three live neighbors lives on to the next generation unless infected by neighboring zombies.
3. Any live cell (human) with more than three live neighbors dies, as if by over-population.
4. Any dead cell with exactly three live neighbors becomes a live cell (human), as if by reproduction.
5. Any infected cell (zombie) remains infected (zombie) in the next generation unless surrounded entirely by living humans, in which case it dies of starvation.


## How to Use

To run the program, compile the Haskell code provided (`game_of_life-zombi3es.hs`) using the GHC compiler. Then, execute the compiled program to start the simulation of the Game of Life with Zombies

## Dependencies

-GHC (Glasgow Haskell Compiler)

