#-----------------------------------------------------------------
#---- fractal-XTree.sh
#---- by Simon Hougard // Dec. 9th 2020
#---- based on Marc Clifton's work: https://www.codeproject.com/Articles/3412/Create-a-Fractal-Christmas-Tree
#----
#---- creates a Christmas Tree by recursively drawing sub-branches
#You can customize your Fractal Xmas Tree by running fractal-Xtree.sh with up to 4 arguments in that order:")
# - size of the tree (integer bigger that 2)
# - percentage of where new sub-branches must grow on a main branch (between 1 and 99)
# - percentage of size of sub-branches compared to their main branch (between 1 and 99)
# - how deep the recursivity can go to create sub-branches of sub-branches (integer bigger than 1)
#Example:
# - python3 (or whichever alias you use to launch python scripts) fractal-Xtree.sh 40 25 30 5
# - python3 fractal-Xtree.sh 20 35 50 5
# - python3 fractal-Xtree.sh 70 25 40 10
# - python3 fractal-Xtree.sh 200 20 40 10
# - python3 fractal-Xtree.sh 100 20 60 10 (a pretty dense one!)
# - python3 fractal-Xtree.sh 80 60 60 10 (not really looking like a Xmas tree!!)

import sys

#Default values
starting_branch_size = 50           # tree size
branches_break_point_ratio = 33     # percentage of where new sub-branches must grow on a main branch
new_branch_size_ratio = 50          # percentage of size of sub-branches compared to their main branch
fractal_tree_depth = 10             # used to tell when to stop the recursivity

#Reading command line arguments (if existing)
try:
    starting_branch_size = int(sys.argv[1])         #Reading the first argument (size of the tree)
except IndexError:
    print("You can customize your Fractal Xmas Tree by running fractal-Xtree.sh with up to 4 arguments in that order:")
    print(" - size of the tree (integer bigger that 2)")
    print(" - percentage of where new sub-branches must grow on a main branch (between 1 and 99)")
    print(" - percentage of size of sub-branches compared to their main branch (between 1 and 99)")
    print(" - how deep the recursivity can go to create sub-branches of sub-branches (integer bigger than 1)")
    print("For example: fractal-Xtree.sh 40 25 30 5")
    print("Using the default value size of the tree: " + str(starting_branch_size))
if starting_branch_size < 2:
    sys.exit("Tree size too small, minimum is 2")
    

try:
    branches_break_point_ratio = int(sys.argv[2])   #Reading the second argument (percentage of where to grow sub-branches)
except IndexError:
    print("Using the default percentage value for where sub-branches must grow: " + str(branches_break_point_ratio))

try:
    new_branch_size_ratio = int(sys.argv[3])        #Reading the third argument (percentage of the size of sub-branches)
except IndexError:
    print("Using the default percentage value for the size of sub-branches: " + str(new_branch_size_ratio))

try:
    fractal_tree_depth = int(sys.argv[4])           #Reading the fourth argument (max depth of recursivity)
except IndexError:
    print("Using the default value for depth of the recursivity: " + str(fractal_tree_depth))

#Setting up other variables
char_buffer_dimension = 2 * starting_branch_size    # used to create a square buffer matrix of dimension "char_buffer_dimension" where the tree will be drawn before being output to the command line
break_point_character = "+"                         # character used at each point where new sub-branches will grow
branch_character = ["|", "-"]                       # holds in first the character used for branches growing vertically , and in second the character used for branches growing horizontally
branch_last_character = "o"                         # character used at the end of each branch (after all, a Xmas tree needs decorations!!)
last_row_used = 0                                   # used to track the last row used to draw the tree in the buffer matrix in order to not output empty rows
min_col_used = char_buffer_dimension                # used to track the first column used to draw the tree in the buffer matrix in order to not output spaces on the left of the tree
max_col_used = 0                                    # used to track the last column used to draw the tree in the buffer matrix in order to not output spaces on the right of the tree

#Creating the square buffer Matrix of dimension "char_buffer_dimension" where the tree will be drawn before being output to the command line
charBuffer = [[" " for i in range(char_buffer_dimension)] for j in range(char_buffer_dimension)]

#------------------- Recursive function to draw branches and create sub-branches by calling itself -------------------
def fractal_xtree(branch_length, branch_origin_x, branch_origin_y, branch_h_vector, branch_v_vector, fractal_depth):
    #Arguments of the function:
    # - branch_length: how long is the current branch to be drawn and split in sub-branches
    # - branch_origin_x: x coordinate of the starting point of the current branch
    # - branch_origin_y: y coordinate of the starting point of the current branch
    # - branch_h_vector: indicates if the branch must be drawn in the +x direction (=1), in the -x direction (=-1), or not along the x axis (=0)
    # - branch_v_vector: indicates if the branch must be drawn in the +y direction (=1), in the -y direction (=-1), or not along the y axis (=0)
    # - fractal_depth: indicates if more sub-branches must be drawn (>0), or not (=0)

    #------------------- Draw the branch -------------------
    x = branch_origin_x #get x coordinate of the starting point of the current branch
    y = branch_origin_y #get y coordinate of the starting point of the current branch
    current_branch_char = branch_character[abs(branch_v_vector)]    #select the appropriate character depending on the orientation of the branch
    for k in range(1, branch_length):                               #iterate over the size of the branch to be drawn
        charBuffer[x][y] = current_branch_char                      #input ("draw") the appropriate character in the buffer matrix
        if 0 < x < char_buffer_dimension - 1:
            x += branch_h_vector                                    #change the x coordinate to the position where to draw the next part of the branch. "branch_h_vector" value can be -1 (going left), 0 (not moving horizontally) or 1 (going right)
        if 0 < y < char_buffer_dimension - 1:
            y += branch_v_vector                                    #change the y coordinate to the position where to draw the next part of the branch. "branch_v_vector" value can be -1 (going down), 0 (not moving vertically) or 1 (going up)
    charBuffer[x][y] = branch_last_character                        #putting the "Xmas decoration" at the end of the branch
    global last_row_used, min_col_used, max_col_used                #we want to modify the global variables "last_row_used", "min_col_used" and "max_col_used" on the next line
    last_row_used = max(last_row_used, x)                           #tracking the last row used to draw the tree in the buffer matrix in order to not output empty rows
    min_col_used = min(min_col_used, y)                             #tracking the first column used to draw the tree in the buffer matrix in order to not output spaces on the left of the tree
    max_col_used = max(max_col_used, y)                             #tracking the last column used to draw the tree in the buffer matrix in order to not output spaces on the right of the tree

    #------------------- Create Sub-Branches -------------------
    #recursively creates sub-branches if the current branch is long enough and if we have not reach the max depth of the fractal tree
    remaining_branch_length = branch_length     #we will move along the branch each time we create sub-branches. The remaning_branch_length will be used to know if there is enough space remaining to add new sub-branches
    bp_x = branch_origin_x                      #get x coordinate of the starting point of the current branch (bp_x will hold the x coordinate of breaking points where new sub-branches must grow)
    bp_y = branch_origin_y                      #get y coordinate of the starting point of the current branch (bp_y will hold the y coordinate of breaking points where new sub-branches must grow)

    while remaining_branch_length > 1:
        #get the length of branch before and after the break point (where sub-branches should be created)
        length_before_break_point = int(remaining_branch_length * branches_break_point_ratio / 100)
        length_after_break_point = remaining_branch_length - length_before_break_point
        #print("remaining_branch_length: " + str(remaining_branch_length))
        #print("length_before_break_point: " + str(length_before_break_point) + " / length_after_break_point: " + str(length_after_break_point))

        #if the length after the breaking point equals to the remaining length of the branch --> there is no room to grow new sub-branches --> exit the loop
        if length_after_break_point == remaining_branch_length:
            #print("breaking the while loop")
            break

        #get the breaking point coordinates
        bp_x += length_before_break_point * branch_h_vector #bp_x initially holds the x coordinate of the starting point of the branch. By adding the distance from the starting point to the breaking point in the correct direction (given by branch_h_vector) we get the x coordinate of the breaking point
        bp_y += length_before_break_point * branch_v_vector #bp_x initially holds the y coordinate of the starting point of the branch. By adding the distance from the starting point to the breaking point in the correct direction (given by branch_v_vector) we get the y coordinate of the breaking point
        if 0 <= bp_x < char_buffer_dimension and 0 <= bp_y < char_buffer_dimension and fractal_depth > 1:
            charBuffer[bp_x][bp_y] = break_point_character  #"draws" the character of the breaking point only if its coordinate are in the buffer matrix space and if the fractal_depth is stricly above 1

        #get the starting points of the 2 new sub-branches. The starting points of the 2 sub-branches are on each side of the breaking point from where they grow
        sp1_x = bp_x + branch_v_vector  #x coordinate of the starting point of the first sub-branch
        sp1_y = bp_y + branch_h_vector  #y coordinate of the starting point of the first sub-branch
        sp2_x = bp_x - branch_v_vector  #x coordinate of the starting point of the second sub-branch
        sp2_y = bp_y - branch_h_vector  #y coordinate of the starting point of the second sub-branch

        #get the length of the sub-branches
        sub_branch_length = int(remaining_branch_length * new_branch_size_ratio / 100)

        #get the orientation of the sub-branches depending on the orientation of the current branch
        sb1_h_vector = branch_v_vector      #horizontal vector of the first sub-branch
        sb1_v_vector = branch_h_vector      #vertical vector of the first sub-branch
        sb2_h_vector = - branch_v_vector    #horizontal vector of the second sub-branch
        sb2_v_vector = - branch_h_vector    #vertical vector of the second sub-branch

        #recursively call fractal_xtree to draw the sub-branches (and their sub-branches...) (if their starting point is still inside the canvas)
        if fractal_depth > 1: #we don't create new sub-branches if the fractal_depth is too low
            if 0 <= sp1_x < char_buffer_dimension and 0 <= sp1_y < char_buffer_dimension:
                fractal_xtree(sub_branch_length, sp1_x, sp1_y, sb1_h_vector, sb1_v_vector, fractal_depth - 1)
            if 0 <= sp2_x < char_buffer_dimension and 0 <= sp2_y < char_buffer_dimension:
                fractal_xtree(sub_branch_length, sp2_x, sp2_y, sb2_h_vector, sb2_v_vector, fractal_depth - 1)

        #repeating the process for the rest of the current branch after the break point
        remaining_branch_length = length_after_break_point    

#------------------- Initial call to the recursive "fractal_xtree" function -------------------
#Initial call to the "fractal_xtree" function with the given tree parameters
fractal_xtree(starting_branch_size, 1, char_buffer_dimension // 2 + 1, 1, 0, fractal_tree_depth)

#------------------- Printing the Xmas tree in Command Line -------------------
charBufferToOutput = charBuffer[:-(last_row_used-1)]    #Slicing out the empty rows from the buffer matrix
for row in reversed(charBufferToOutput):                #Iterating over the non-empty rows, in reverse order (otherwise the tree would output upside-down)
    row_output = ""
    rowToOuput = row[min_col_used:(max_col_used+1)]     #Slicing out the empty spaces on the left and right sides of the tree
    for val in rowToOuput:
        row_output += val                               #agregating all the values in one row
    print(row_output)                                   #printing the row


#---- Merry Chrstimas!!! ;)