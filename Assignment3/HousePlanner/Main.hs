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

-- This function prints the result obtained
printResult x bed hall kitchen bath garden balcony area maxArea  = 
  if (length x /= 0) then do
    let (a,b,c,d,e,f) = x !! 0
    putStrLn $ "Bedroom: " ++ show (bed) ++ " " ++ show a
    putStrLn $ "Hall: " ++ show (hall) ++ " " ++ show b
    putStrLn $ "Kitchen: " ++ show (kitchen) ++ " " ++ show c
    putStrLn $ "Bathroom: " ++ show (bath) ++ " " ++ show d
    putStrLn $ "Garden: " ++ show (garden) ++ " " ++ show e
    putStrLn $ "Balcony: " ++ show (balcony) ++ " " ++ show f
    putStrLn $ "Unused Space: " ++ show (area-maxArea)
  else putStrLn $ "No design possible for the given constraints"

-- get the area which is maximum 
getMaxArea [] _ _ _ _ _ _= 0
getMaxArea ((a,b,c,d,e,f):tp) p q r s t u = do
  let temp = ((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)+(fst(f)*snd(f)*u)):: Integer
  maximum [temp, getMaxArea(tp) p q r s t u]
 
-- From the list of 2 tuples remove all the extra duplicate area dimensions 
rmDup2 [] _ _ =[]
rmDup2 list p q = tempDup2 list [] p q
tempDup2 [] _ _ _= []
tempDup2 ((a,b):tp) l2 p q = 
  if(((fst(b)*snd(b)*q)+(fst(a)*snd(a)*p))  `elem` l2) then 
    tempDup2 tp l2 p q
  else (a,b) : tempDup2 tp (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)):l2) p q

-- From the list of 3 tuples remove all the extra duplicate area dimensions 
rmDup3 [] _ _ _ =[]
rmDup3 list p q r = tempDup3 list [] p q r
tempDup3 [] _ _ _ _= []
tempDup3 ((a,b,c):tp) l2 p q r = 
  if(((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)) `elem` l2) then 
    tempDup3 tp l2 p q r
  else (a,b,c) : tempDup3 tp (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)):l2) p q r

-- From the list of 4 tuples remove all the extra duplicate area dimensions 
rmDup4 [] _ _ _ _=[]
rmDup4 list p q r s = tempDup4 list [] p q r s
tempDup4 [] _ _ _ _ _= []
tempDup4 ((a,b,c,d):tp) l2 p q r s = 
  if(((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s))  `elem` l2) then 
    tempDup4 tp l2 p q r s
  else (a,b,c,d) : tempDup4 tp (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)):l2) p q r s

-- From the list of 5 tuples remove all the extra duplicate area dimensions 
rmDup5 [] _ _ _ _ _=[]
rmDup5 list p q r s t = tempDup5 list [] p q r s t
tempDup5 [] _ _ _ _ _ _= []
tempDup5 ((a,b,c,d,e):tp) l2 p q r s t =
  if(((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t))  `elem` l2) then 
    tempDup5 tp l2 p q r s t
  else  (a,b,c,d,e) : tempDup5 tp (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)):l2) p q r s t
    
-- From the list of 6 tuples remove all the extra duplicate area dimensions 
rmDup6 list p q r s t u = tempDup6 list [] p q r s t u
tempDup6 [] _ _ _ _ _ _ _= []
tempDup6 ((a,b,c,d,e,f):tp) l2 p q r s t u =
  if(((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)+(fst(f)*snd(f)*u))  `elem` l2) then 
    tempDup6 tp l2 p q r s t u
  else  (a,b,c,d,e,f) : tempDup6 tp (((fst(a)*snd(a)*p)+(fst(b)*snd(b)*q)+(fst(c)*snd(c)*r)+(fst(d)*snd(d)*s)+(fst(e)*snd(e)*t)+(fst(f)*snd(f)*u)):l2) p q r s t u

-- Find all possible dimensions given the smallest and largest dimension
getDim x y = 
 if (fst x == fst y) 
  then if(snd x == snd y) then [x]
    else getDim2 x y
   else getDim2 x y ++ getDim l1 y
    where l1 = (fst x + 1, snd x) 

getDim2 x y = 
 if (snd x == snd y)
  then [x]
   else x:getDim2 l1 y
    where l1 = (fst x, snd x + 1)

--Main function
design area c_bed c_hall = do
 let bedroom = getDim (10,10) (15,15)
 let hall = getDim (15,10) (20,15)
 let kitchen = getDim (7,5) (15,13)
 let bathroom = getDim (4,5) (8,9)
 let garden = getDim (10,10) (20,20)
 let balcony = getDim (5,5) (10,10)
 let c_kitchen = ceiling(fromIntegral c_bed/3) :: Integer
 let c_bath = c_bed + 1
 let c_garden = 1
 let c_balcony = 1

 -- Tuples - (bedroom, hall) - Remove duplicate areas
 let l1 = rmDup2 (filter (\(a,b) -> ((fst(a)*snd(a)*c_bed) 
                               + (fst(b)*snd(b))*c_hall) <= area) 
                               ([(u,v) | u <- bedroom, v <- hall])) c_bed c_hall
 
 -- Tuple - (bedroom, hall, kitchen) - Remove duplicate areas 
 -- The constraints are sum of area occupied by bedroom, halls, kitchens shoud not be more than the given area, length of kitchen should not be more than that of bedroom and hall, breadth of kitchen should not be more than that of bedroom and hall 
 let l2 = rmDup3 (filter (\(a,b,c) ->                            
                               (((fst(a)*snd(a)*c_bed) + (fst(b)*snd(b)*c_hall) + (fst(c)*snd(c)*c_kitchen)) <= area)                                    
                               && (fst(c) <= fst(a) && fst(c) <= fst(b)     
                               && snd(c) <= snd(a) && snd(c) <= snd(b)))    
                               ([(a, b, v) | (a,b) <- l1, v <- kitchen]))                   
                               c_bed c_hall c_kitchen    

 -- Tuple - (bedroom, hall, kitchen, bathroom) - Remove duplicate areas
 -- The constraints are sum of area occupied by bedroom, halls, kitchens, bathrooms should not be more than given area, dimension of bathroom should not be more than that of kitchen
 let l3 = rmDup4 (filter (\(a,b,c,d) ->                         
                               (((fst(a)*snd(a)*c_bed) + (fst(b)*snd(b)*c_hall) + (fst(c)*snd(c)*c_kitchen) + (fst(d)*snd(d)*c_bath)) <= area)                                     
                               && (fst(d) <= fst(c) && snd(d) <= snd(c)))   
                               ([(a, b, c, v) | (a,b,c) <- l2, v <- bathroom]))                   
                               c_bed c_hall c_kitchen c_bath  

 -- Tuple - (bedroom, hall, kitchen, bathroom, garden) - Remove duplicate areas
 -- The constraints are sum of area occupied by bedroom, halls, kitchens, bathrooms and garden should not be more than given area                      
 let l4 = rmDup5 (filter (\(a,b,c,d,e) ->                        
                               (((fst(a)*snd(a)*c_bed) + (fst(b)*snd(b)*c_hall)+ (fst(c)*snd(c)*c_kitchen) + (fst(d)*snd(d)*c_bath) + (fst(e)*snd(e)*c_garden)) <= area))                                   
                               ([(a, b, c, d, v) | (a,b,c,d) <- l3, v <- garden]))                    
                               c_bed c_hall c_kitchen c_bath c_garden    

 -- Tuple - (bedroom, hall, kitchen, bathroom, garden, balcony) -- Remove duplicate areas
 -- The constraints are sum of area occupied by bedroom, halls, kitchens, bathrooms, balcony and garden should not be more than given area                      
 let l5 = rmDup6 (filter (\(a,b,c,d,e,f) -> 
                               (((fst(a)*snd(a)*c_bed) + (fst(b)*snd(b)*c_hall) + (fst(c)*snd(c)*c_kitchen) + (fst(d)*snd(d)*c_bath) + (fst(e)*snd(e)*c_garden) + (fst(f)*snd(f)*c_balcony)) <= area))                                    
                               ([(a, b, c, d, e, v) | (a,b,c,d,e) <- l4, v <- balcony])) c_bed c_hall c_kitchen c_bath c_garden c_balcony   
 

 -- calculate max area possible
 let maxArea = getMaxArea l5 c_bed c_hall c_kitchen c_bath c_garden c_balcony
 -- get the dimensions with maximum area
 let result = filter (\(a,b,c,d,e,f) ->                                     
                               ((fst(a)*snd(a)*c_bed) + (fst(b)*snd(b)*c_hall) + (fst(c)*snd(c)*c_kitchen) + (fst(d)*snd(d)*c_bath) + (fst(e)*snd(e)*c_garden) + (fst(f)*snd(f)*c_balcony) == maxArea)) l5

 -- print result
 printResult result c_bed c_hall c_kitchen c_bath c_garden c_balcony area maxArea
 
 
    
