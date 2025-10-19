## 81e321d - Update t8_UNKNOWN.json
- headbutt throw now works at wall
- db2,4 cancels to n 5 frames earlier
- db2,4,2f new cancel
- JAG2+4 now wallsplats
- 3+4 hold now hits airborne
- 1+3+4 extended hitbox duration, increased dmg from 25 to 35

## dc12b2c - Update t8_UNKNOWN.json
last update broke mod due to file corruption within a save. fixed AK again, temporarily disabled ff3+4 cancel for maintenence

- d4,4,3+4 now new reaction on hit

## 69aa8e3 - Revert "Clive and AK cleanup"
This reverts commit c5a731424540081da4d1dc26786d95bcd44fdadb.

## c5a7314 - Clive and AK cleanup
Clive:
- fixed jump blue spark 1+2

AK:
- smoothed out several stance transition cancels from previous update
- added ff3+4 cancel into throw on airborne hit
- removed 4,3,f cancel for now as there is no good way to cancel into stance
- ws3,1+2 smoothed out

## fa13cbf - Update t8_UNKNOWN.json
- JAG2,df new cancel
- 4,3,f new cancel
- ws3,1+2 new cancel
- 1+2,2,f new cancel
- d4,4,3+4,f new cancel
- b1+2 removed scaling on counter hit

## b595bc2 - Create t8_UNKNOWN.json
First armor king changes:
- cd1 slightly faster recovery to make heatburst slightly easier to connect
- db2,3 now tornadoes on hit
- db2,4 now strong aerial tailspins
- ub1 now convertss to wall throw (needs anim clean up)
- JAG2+4 air throw now wall splats/breaks
- 3+4 hold connects on airborne opponents
