import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

class BlobDetection {
PImage findConnectedComponents(PImage input, boolean onlyBiggest){
// First pass: label the pixels and store labels' equivalences
int [] labels= new int [input.width*input.height];
List<TreeSet<Integer>> labelsEquivalences= new ArrayList<TreeSet<Integer>>();
int currentLabel=1;
// TODO!
// Second pass: re-label the pixels by their equivalent class
// if onlyBiggest==true, count the number of pixels for each label
// TODO!
// Finally,
// if onlyBiggest==false, output an image with each blob colored in one uniform color
// if onlyBiggest==true, output an image with the biggest blob colored in white and the others in black
// TODO!
}
}
