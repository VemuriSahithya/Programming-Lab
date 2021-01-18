import Data.List
import Data.Int
import Data.Char
import System.IO 
import Data.List (maximumBy)
import Data.Function (on)
import System.Random
import Control.Monad.State
import Data.IORef
import System.IO.Unsafe

-- This function randomly shuffles the list in a random order
randomShuffle l = 
    if length l > 2 then do
        i <- System.Random.randomRIO (0, length(l)-1)
        rs <- randomShuffle (take i l ++ drop (i+1) l)
        return (l!!i : rs) 
    else return l

-- teams stores the fixtures of all teams from date 1 to 3.
teams :: IORef [[[Char]]]

-- Initialize a new reference of the variable with NULL value.
{-# NOINLINE teams #-}
teams = unsafePerformIO (newIORef [])


--This function print the each fixture list.   
showAllFixtures [] = do 
    putStrLn "" 

showAllFixtures (x:ls) = do
    let temp = x!!0 ++ " vs "++ x!!1 ++ "  " ++ x!!2 ++ "-12-2020  " ++ x!!3 
    putStrLn temp
    showAllFixtures ls

--  This function recursively schedules for each slot and date
setSlots [] slot date = do
    temp <-readIORef teams    
    if(temp == []) then do putStrLn ""
    else showAllFixtures temp
    

setSlots list slot date = do    

    --selects two teams from the list of teams
    let topTeams = take 2 list
    let curSlot = if slot<=2 
                        then slot
                        else 1
    -- set the time according to the slot
    let curTime =if curSlot /= 1
                        then ["19:30"]
                        else  ["09:30"]
     -- check the current date, if slot number is greater than two then date should be increased
    let curDate = if slot<=2  
                        then date
                        else date+1 

    -- create the new fixture and then update the fixture list by appending it to the previous list                  
    let newFixture = topTeams ++ [show curDate] ++ curTime
    preFixList <- readIORef teams
    let curFixList = preFixList ++ [newFixture]
    -- Update memory and then drop off both the teams  
    writeIORef teams curFixList
    let newList = drop 2 list
    let nextSlot = curSlot+1
    -- recursively call the setSlots for the rest of the teams
    setSlots newList nextSlot curDate
            
-- This function recursively iterates over the fixtures list and then matches teams name if found
getMatch [] option = do
    putStrLn "Teams is not scheduled yet/Found in the given time 1-3"
    
getMatch (head:tail) option = do
    --check if the fixture contains the fixture of the given teams
    if elem option head then do
        let temp = head!!0 ++ " vs "++ head!!1 ++ "  " ++ head!!2 ++ "-12-2020  " ++ head!!3 
        putStrLn temp   
    else getMatch tail option
          

-- This function prints the fixture of some teams given based on the option arguement
fixture option = do
    let list = ["BS","CM","CH", "CV","CS","DS","EE","HU","MA","ME","PH","ST"]
    --checks whether the number of teams are valid and then calls the setSlots to set all the fixtures  
    if option ==  "all" then do
        let len = length list
        if len `mod` 2/=1 then do 
            writeIORef teams []
            tt <-randomShuffle list
            let t2 = take 12 tt
            let startDate=1
            let slot=1 
            setSlots t2 slot startDate
        else do putStrLn "Invalid no. of teams"
    else do 
        fixtureList <- readIORef teams 
        getMatch fixtureList option


-- This function iteratively goes over to match the date and time of the next fixture, if matches just print the fixture
printNextMatch day time [] =do
    -- If fixture is not found
    putStrLn "There is no match which is scheduled next"          

printNextMatch day time (x:ls) = do
    if day == x!!2 && time == x!!3 then do
        let temp = x!!0 ++ " vs "++ x!!1 ++ "  " ++ x!!2 ++ "-12-2020  " ++ x!!3 
        putStrLn temp
    else printNextMatch day time ls


--This function check if the date and time are valid or not  
ifValidDayTime:: Int -> [Char] -> Int
ifValidDayTime day time = 
    if(day<1 || day>31) then 1
    else if(day>=1 && day<=31 && time>= "00:00" && time <= "23:59") then 0
    else 1


-- This function calls printNextMatch to print the fixture in the format we want
nextMatch day time = do
    fixtureList <- readIORef teams
    let new_time = if length time /= 4 
        then time
        else '0':time
    let flag = (ifValidDayTime day new_time)

    -- If input is valid then find the schedule time of next fixture according to given input.
    if flag /=1 
        then do
    --         -- update the date  
            let curr_day = if new_time>"19:30"
                            then day+1
                            else if new_time<="09:30"
                                then day
                            else day
            let final_day = show curr_day
 -- If time is less than or equal to 9.30 am or greater to 7.30 pm, then next match will be there at 9.30 am else the match will be at 7.30 pm 
            let curTime = if new_time>"19:30"
                           then "09:30"
                           else if new_time<="09:30"
                            then "09:30"
                           else "19:30"
            if(fixtureList == []) then do putStrLn "There is no match which is scheduled next"
            else printNextMatch final_day curTime  fixtureList  
        else putStrLn "Invalid date or time"         
            
------------------------------------------------------------------------------
