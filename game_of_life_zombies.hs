import Control.Concurrent (threadDelay)
import System.Random (randomRIO)

type Grid = [[Char]]

-- Function to print the grid
printGrid :: Grid -> IO ()
printGrid = mapM_ putStrLn

-- Function to generate a random initial grid
generateRandomGrid :: Int -> Int -> Float -> Float -> IO Grid
generateRandomGrid rows cols percentHumans percentZombies = do
    cells <- sequence [randomCell percentHumans percentZombies | _ <- [1..rows * cols]]
    return $ chunksOf cols cells

-- Function to generate a random cell
randomCell :: Float -> Float -> IO Char
randomCell percentHumans percentZombies = do
    rand <- randomRIO (0.0, 1.0)
    if rand < percentHumans
        then return 'H'
        else if rand < percentHumans + percentZombies
            then return 'Z'
            else return ' '

-- Function to split a list into chunks of fixed size
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)

-- Function to update a cell in the grid
updateCell :: Int -> Int -> Char -> Grid -> Grid
updateCell x y value grid = take y grid ++ [take x (grid !! y) ++ [value] ++ drop (x + 1) (grid !! y)] ++ drop (y + 1) grid

-- Function to count the number of live cells (humans)
countLiveNeighbors :: Int -> Int -> Grid -> Int
countLiveNeighbors x y grid = length $ filter (== 'H') $ concatMap (take 3 . drop (x - 1)) (take 3 $ drop (y - 1) grid)

-- Function to apply the rules of the game
applyRules :: Grid -> Grid
applyRules grid = [[determineCellState x y grid | x <- [0..cols-1]] | y <- [0..rows-1]]
    where rows = length grid
          cols = length (head grid)
          determineCellState x y grid
              | currentCell == 'H' && (liveNeighbors == 2 || liveNeighbors == 3) = 'H' -- Human survives
              | currentCell == 'Z' && (liveNeighbors > 0) = 'Z' -- Zombie survives
              | currentCell == ' ' && liveNeighbors == 3 = 'H' -- Dead cell becomes human
              | otherwise = ' ' -- Cell dies
              where currentCell = grid !! y !! x
                    liveNeighbors = countLiveNeighbors x y grid

-- Function to simulate the game
simulateGame :: Grid -> Grid -> Int -> IO ()
simulateGame prevGrid grid generation = do
    printGrid grid
    threadDelay 1000000 -- Delay in microseconds (1 second)
    let newGrid = applyRules grid
    if checkIfFinished newGrid
        then putStrLn $ "Simulation finished after " ++ show generation ++ " generations."
        else if newGrid == prevGrid
                then putStrLn "Simulation reached a stable state."
                else simulateGame grid newGrid (generation + 1)

-- Function to check if the simulation has ended
checkIfFinished :: Grid -> Bool
checkIfFinished grid = notElem 'H' (concat grid) && notElem 'Z' (concat grid)

main :: IO ()
main = do
    putStrLn "Percentage of humans (0.0 - 1.0): "
    percentHumans <- readLn
    let percentZombies = 1 - percentHumans
        rows = 20
        cols = 50
    initialGrid <- generateRandomGrid rows cols percentHumans percentZombies
    simulateGame initialGrid initialGrid 0
