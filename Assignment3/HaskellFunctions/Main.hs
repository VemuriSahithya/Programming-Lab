import Data.List
import Data.Set (Set)
import Data.Int
import Data.Char
import System.IO 
import Data.List (maximumBy)
import Data.Function (on)
import System.Random
import Control.Monad.State
import Data.IORef
import System.IO.Unsafe
import qualified Data.Set as Set

--Few sets for which operations can be applied upon
s1 = Set.empty
s2 = Set.fromList [1,2,3,4,5,6,7,8]
s3 = Set.fromList [3,4,5,6,7,8,9,10]
s4 = Set.fromList ["a","b","c","de"]
s5 = Set.fromList ["170101077","a","b","gh"]
s6 = Set.fromList "To create a dream house with the best utilization of space, a good design is necessary."
s7 = Set.fromList "Write a program in Haskell to suggest the best possible design of a house in the available space"

-- This function checks whether a set is empty or not
ifEmpty :: Set a -> Bool
ifEmpty a = Set.null a

-- This function returns the union of two sets 
unionSets :: Ord(a) => Set a -> Set a -> Set a
unionSets s1 s2 = do
                Set.fromList(x1 ++ x2)
                where x1 = Set.toList(s1)
                      x2 = Set.toList(s2)

-- This function sorts the list of intersection of sets
intersect2 :: Ord a => [a] -> [a] -> [a]
intersect2 (x:xs) (y:ys) 
 | x == y    = x : intersect2 xs ys
 | x < y     = intersect2 xs (y:ys)
 | x > y     = intersect2 (x:xs) ys
intersect2 _ _ = []

-- This function finds the sorted list after intersection of sets
intersect1 :: Ord a => [a] -> [a] -> [a]
intersect1 xs ys = intersect2 (sort xs) (sort ys)

--This function returns the intersection of two sets
intersectSets :: Ord(a) => Set a -> Set a -> Set a 
intersectSets s1 s2 = do
                    Set.fromList (intersect1 x1 x2)
                    where x1 = Set.toList s1
                          x2 = Set.toList s2

-- This function subtracts the one set from another set
subtractSets :: Ord(a) => Set a -> Set a -> Set a
subtractSets s1 s2 = do
                    Set.fromList(x1 \\ x2)
                    where x1 = Set.toList(s1)
                          x2 = Set.toList(s2)

-- This function returns a set after addition  of sets
-- addSets :: Ord(a) => Set a -> Set a -> Set a 
-- addSets s1 s2 = unionSets s1 s2
-- addelem :: Int -> [Int] -> [Int] 

addelem a [] = []
addelem a (x:xs) = (a+x:addelem a xs)

addSets :: [Int] -> [Int] -> [Int]
addSets [] s2 = []
addSets (x:xs) s2 = addelem x s2 ++ addSets xs s2

