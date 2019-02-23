.data
start: .asciiz "Enter your name to begin: "
name: .space 10
.align 2
arr1: .asciiz "[ "
comma: .asciiz " , "
arr2: .asciiz " ]"
player: .asciiz "You rolled the following: : "
cpu: .asciiz "\nYour opponent rolled the following: "
info: .asciiz "\nDice arrays are numbered starting at one \n"
prompt: .asciiz "Pick a dice (1-5) to reroll, enter 0 or press close to end rerolling"
fiveK: .asciiz "\nYou rolled five of a kind"
fiveKO: .asciiz "\nYour opponent rolled five of a kind"
fourK: .asciiz "\nYou rolled four of a kind"
fourKO: .asciiz "\nYour opponent rolled four of a kind"
pair: .asciiz "\nYou rolled a pair"
pairO: .asciiz "\nYour opponent rolled a pair"
twopair: .asciiz "\nYou rolled two pairs"
twopairO: .asciiz "\nYour oppenent rolled two pairs"
threeK: .asciiz "\nYou rolled three of a kind"
threeKO: .asciiz "\nYour opponent rolled three of a kind"
Win: .asciiz "\nYou win"
Lose: .asciiz "\nYou Lose"
Tie: .asciiz "\nIt's a tie"
fh: .asciiz "\nYou rolled a full house"
fhO: .asciiz "\nYour opponent rolled a full house"

.text
la $a0, start #display starting message
la $a1, name
li $a2, 100
li $v0 54
syscall

bne $a1, -2, rng #exit if cancel chosen
exit:
li $v0, 10
syscall

rng:
li $a0, 1	#rng
li $a1, 6
li $v0, 42
syscall
beqz $t0 one
jr $ra

one:
li $t0, 1
one2:
jal rng
addi $s0, $a0, 1 #store first number
beq $t0, 10, reroll

two:
jal rng
addi $s1, $a0, 1 #store 2nd number
beq $t0, 10, reroll


three:
jal rng
addi $s2, $a0, 1 #store 3 number
beq $t0, 10, reroll

four:
jal rng
addi $s3, $a0, 1 #store 4 number
beq $t0, 10, reroll

five:
jal rng
addi $s4, $a0, 1 #store 5 number
beq $t0, 10, reroll

Cone:
jal rng
addi $s5, $a0, 1 #store first number
jal rng

Ctwo:
addi $s6, $a0, 1 #store 2nd number
jal rng

Cthree:
addi $s7, $a0, 1 #store 3 number
jal rng

Cfour:
addi $t6, $a0, 1 #store 4 number
jal rng

Cfive:
addi $t7, $a0, 1 #store 5 number

jal display

reroll:		#prompt player to select which dice to reroll and go regen theose dice
li $t0, 10
la $a0, prompt
li $v0, 51
syscall
beq $a0, 1, one2
beq $a0, 2, two
beq $a0, 3, three
beq $a0, 4, four
beq $a0, 5, five

jal display

bne $s0, $s1, SevenP #check for five of a kind
bne $s1, $s2, SevenP
bne $s2, $s3, SevenP
bne $s3, $s4, SevenP
li $t4, 8
la $a0, fiveK
li $v0, 4
syscall
j EightO

SevenP: #four of a kind
bne $s0, $s1, Seven2
bne $s1, $s2, Seven1
bne $s1, $s3, Seven1.2
li $t4, 7
la $a0, fourK
li $v0, 4
syscall
j EightO
Seven1:
bne $s1, $s3, Seven2
bne $s1, $s4, Seven2
li $t4, 7
la $a0, fourK
li $v0, 4
syscall
j EightO
Seven1.2:
bne $s1, $s4, Seven2
li $t4, 7
la $a0, fourK
li $v0, 4
syscall
j EightO
Seven2:
bne $s0, $s2, Seven3
bne $s2, $s3, Seven3
bne $s2, $s4, Seven3
li $t4, 7
la $a0, fourK
li $v0, 4
syscall
j EightO
Seven3:
bne $s1, $s2, SixP
bne $s2, $s3, SixP
bne $s2, $s4, SixP
li $t4, 7
la $a0, fourK
li $v0, 4
syscall
j EightO

SixP: #full house
bne $s0, $s1, sixThreeone
beq $s1, $s2, onetwothree
beq $s1, $s3, onetwofour
beq $s1, $s4, onetwofive
sixThreeone:
bne $s0, $s2, sixThreetwo
beq $s2, $s3, onethreefour
beq $s2, $s4, onethreefive
sixThreetwo:
bne $s1, $s2, sixfourtwo
beq $s2, $s3, twothreefour
beq $s2, $s4, twothreefive
sixfourtwo:
bne $s1, $s3, foursixThree
beq $s3, $s4, twofourfive
foursixThree:
bne $s2, $s3, FiveP
bne $s3, $s4, FiveP
bne $s0, $s1, FiveP
onetwothree:
bne $s3, $s4, FiveP
j sixThreePTrue
onetwofour:
bne $s2, $s4, FiveP
j sixThreePTrue
onetwofive:
bne $s2, $s3, FiveP
j sixThreePTrue
onethreefour:
bne $s1, $s4, FiveP
j sixThreePTrue
onethreefive:
bne $s1, $s3, FiveP
j sixThreePTrue
twothreefour:
bne $s0, $s4, FiveP
j sixThreePTrue
twothreefive:
bne $s0, $s3, FiveP
j sixThreePTrue
twofourfive:
bne $s0, $s2, FiveP
j sixThreePTrue
sixThreePTrue:
li $t4, 6
la $a0, fh
li $v0, 4
syscall
j EightO

FiveP:
FourP:
ThreeP: #three of a kind
bne $s0, $s1, threeone
beq $s1, $s2, ThreePTrue
beq $s1, $s3, ThreePTrue
beq $s1, $s4, ThreePTrue
threeone:
bne $s0, $s2, threetwo
beq $s2, $s3, ThreePTrue
beq $s2, $s4, ThreePTrue
threetwo:
bne $s1, $s2, fourtwo
beq $s2, $s3, ThreePTrue
beq $s2, $s4, ThreePTrue
fourtwo:
bne $s1, $s3, fourthree
beq $s3, $s4, ThreePTrue
fourthree:
bne $s2, $s3, TwoP
bne $s3, $s4, TwoP
ThreePTrue:
li $t4, 3
la $a0, threeK
li $v0, 4
syscall
j EightO

TwoP: #two pair
bne $s0, $s1, onethree
beq $s2, $s3, twotrue
beq $s3, $s4, twotrue
beq $s2, $s4, twotrue
onethree:
bne $s0, $s2, onefour
beq $s1, $s3, twotrue
beq $s1, $s4, twotrue
beq $s3, $s4, twotrue
onefour:
bne $s0, $s3, onefive
beq $s1, $s2, twotrue
beq $s1, $s4, twotrue
beq $s2, $s4, twotrue
onefive:
bne $s0, $s4, twothree
beq $s1, $s2, twotrue
beq $s1, $s3, twotrue
beq $s3, $s2, twotrue
twothree:
bne $s1, $s2, twofour
beq $s3, $s4, twotrue
twofour:
bne $s1, $s3, twofive
beq $s2, $s4, twotrue
twofive:
bne $s1, $s4, OneP
beq $s2, $s3, twotrue
twotrue:
li $t4, 2
la $a0, twopair
li $v0, 4
syscall
j EightO

OneP: #one pair
beq $s0, $s1, OnePT
beq $s0, $s2, OnePT
beq $s0, $s3, OnePT
beq $s0, $s4, OnePT
beq $s1, $s2, OnePT
beq $s1, $s3, OnePT
beq $s1, $s4, OnePT
beq $s2, $s3, OnePT
beq $s2, $s4, OnePT
beq $s3, $s4, OnePT
j EightO
OnePT:
li $t4, 1
la $a0, pair
li $v0, 4
syscall

EightO:
bne $t6 $t7, SevenO #check for five of a kind
bne $t7, $s5, SevenO
bne $s5, $s6, SevenO
bne $s6, $s7, SevenO
li $t5, 8
la $a0, fiveKO
li $v0, 4
syscall
j temp

SevenO: #four kind
bne $t6, $t7, Seven2O
bne $t7, $s5, Seven1O
bne $t7, $s6, Seven1.2O
li $t5, 7
la $a0, fourKO
li $v0, 4
syscall
j temp
Seven1O:
bne $t7, $s6, Seven2O
bne $t7, $s7, Seven2O
li $t5, 7
la $a0, fourKO
li $v0, 4
syscall
j temp
Seven1.2O:
bne $t7, $s7, Seven2O
li $t5, 7
la $a0, fourKO
li $v0, 4
syscall
j temp
Seven2O:
bne $t6, $s5, Seven3O
bne $s5, $s6, Seven3O
bne $s5, $s7, Seven3O
li $t5, 7
la $a0, fourKO
li $v0, 4
syscall
j temp
Seven3O:
bne $t7, $s5, SixO
bne $s5, $s6, SixO
bne $s5, $s7, SixO
li $t5, 7
la $a0, fourKO
li $v0, 4
syscall
j temp

SixO: #full house
bne $t6, $t7, sixThreeoneO
beq $t7, $s5, onetwothreeO
beq $t7, $s6, onetwofourO
beq $t7, $s7, onetwofiveO
sixThreeoneO:
bne $t6, $s5, sixThreetwoO
beq $s5, $s6, onethreefourO
beq $s5, $s7, onethreefiveO
sixThreetwoO:
bne $t7, $s5, sixfourtwoO
beq $s5, $s6, twothreefourO
beq $s5, $s7, twothreefiveO
sixfourtwoO:
bne $t7, $s6, foursixThreeO
beq $s6, $s7, twofourfiveO
foursixThreeO:
bne $s5, $s6, FiveO
bne $s6, $s7, FiveO
bne $t6, $t7, FiveO
onetwothreeO:
bne $s6, $s7, FiveO
j sixThreeOTrue
onetwofourO:
bne $s5, $s7, FiveO
j sixThreeOTrue
onetwofiveO:
bne $s5, $s6, FiveO
j sixThreeOTrue
onethreefourO:
bne $t7, $s7, FiveO
j sixThreeOTrue
onethreefiveO:
bne $t7, $s6, FiveO
j sixThreeOTrue
twothreefourO:
bne $t6, $s7, FiveO
j sixThreeOTrue
twothreefiveO:
bne $t6, $s6, FiveO
j sixThreeOTrue
twofourfiveO:
bne $t6, $s5, FiveO
j sixThreeOTrue
sixThreeOTrue:
li $t5, 6
la $a0, fhO
li $v0, 4
syscall
j temp 

FiveO:
FourO:
ThreeO: #three kind
bne $t6, $t7, threeoneO
beq $t7, $s5, ThreeOTrue
beq $t7, $s6, ThreeOTrue
beq $t7, $s7, ThreeOTrue
threeoneO:
bne $t6, $t5, threetwoO
beq $s5, $s6, ThreeOTrue
beq $s5, $s7, ThreeOTrue
threetwoO:
bne $t7, $s5, fourtwoO
beq $s5, $s6, ThreeOTrue
beq $s5, $s7, ThreeOTrue
fourtwoO:
bne $t7, $s6, fourthreeO
beq $s6, $s7, ThreeOTrue
fourthreeO:
bne $s5, $s6, TwoO
bne $s6, $s7, TwoO
ThreeOTrue:
li $t5, 3
la $a0, threeKO
li $v0, 4
syscall
j temp
TwoO: #two pair
bne $t6, $t7, onethreeO
beq $s5, $s6, twotrueO
beq $s6, $s7, twotrueO
beq $s7, $s6, twotrueO
onethreeO:
bne $t6, $s5, onefourO
beq $t7, $s6, twotrueO
beq $t7, $s7, twotrueO
beq $s6, $s7, twotrueO
onefourO:
bne $t6, $s6, onefiveO
beq $t7, $s5, twotrueO
beq $t7, $s7, twotrueO
beq $s5, $s7, twotrueO
onefiveO:
bne $t6, $s7, twothreeO
beq $t7, $s5, twotrueO
beq $t7, $s6, twotrueO
beq $s6, $s5, twotrueO
twothreeO:
bne $t7, $s5, twofourO
beq $s6, $s7, twotrueO
twofourO:
bne $t7, $s6, twofiveO
beq $s5, $s7, twotrueO
twofiveO:
bne $t7, $s7, OneO
beq $s5, $s6, twotrueO
twotrueO:
li $t5, 2
la $a0, twopairO
li $v0, 4
syscall
j temp
OneO: #pair
beq $t6, $t7, OneOT
beq $t6, $s5, OneOT
beq $t6, $s6, OneOT
beq $t6, $s7, OneOT
beq $t7, $s5, OneOT
beq $t7, $s6, OneOT
beq $t7, $s7, OneOT
beq $s5, $s6, OneOT
beq $s5, $s7, OneOT
beq $s6, $s7, OneOT
j temp
OneOT:
li $t5, 1
la $a0, pairO
li $v0, 4
syscall

temp: #determine winner by comparing value of hand
beq $t5, $t4, T
blt $t5, $t4, W
b L

W:
la $a0, Win
li $v0, 4
syscall
j exit
L:
la $a0, Lose
li $v0, 4
syscall
j exit
T:
la $a0, Tie
li $v0, 4
syscall
j exit

display:

la $a0, player
li $v0, 4
syscall
la $a0, arr1
li $v0, 4
syscall
move $a0, $s0
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $s1
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $s2
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $s3
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $s4
li $v0, 1
syscall
la $a0, arr2
li $v0, 4
syscall

la $a0, cpu #output opponent's rolls
li $v0, 4
syscall
la $a0, arr1
li $v0, 4
syscall
move $a0, $t6
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $t7
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $s5
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $s6
li $v0, 1
syscall
la $a0, comma
li $v0, 4
syscall
move $a0, $s7
li $v0, 1
syscall
la $a0, arr2
li $v0, 4
syscall
la $a0, info
li $v0, 4
syscall
jr $ra
