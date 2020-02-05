from clips import Environment, Symbol
from image_process_contour import processImage
import sys, io

environment = Environment()

def processFacts(length_list,slope_list):
    global environment
    countour_points = len(length_list)
    #print(length_list, slope_list, countour_points)
    if countour_points == 4:
        for i in range(countour_points):
            environment.assert_string('(raw_input (nth '+str(i+1)+') (length '+str(length_list[i])+') (slope '+str(slope_list[i])+'))')
    else:
        for i in range(countour_points):
            environment.assert_string('(raw_input (nth '+str(i+1)+') (length '+str(length_list[i])+'))')

def runKBS(inputFactList):
    print("DEBUG: ", inputFactList)
    global environment
    # load constructs into the environment
    environment.clear()
    environment.load('shape.clp')

    # reset
    environment.reset()

    # assert facts
    print(processFacts(inputFactList[0],inputFactList[1]))



    # execute the activations in the agenda
    print(environment.run())

def main():
    sys.stdout = io.StringIO()
    print("hehe")

    length_slope_tuple = processImage("jajar-genjang.jpg")
    a=runKBS(length_slope_tuple)

    output = sys.stdout.getvalue().split('\n')
    sys.stdout = sys.__stdout__
    print(output)


main()