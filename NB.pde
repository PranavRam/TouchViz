import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.NaiveBayes;
import weka.core.Attribute;
import weka.core.FastVector;
import weka.core.Instance;
import weka.core.Instances;
class NB {
	Instances isTrainingSet = null;
	FastVector fvWekaAttributes = null;
	Classifier cModel = null;
	public NB(){

	}

	public void setupFeatureVector(){
		// Declare two numeric attributes
		Attribute Attribute1 = new Attribute("firstNumeric");
		Attribute Attribute2 = new Attribute("secondNumeric");
		
		// Declare a nominal attribute along with its values
		FastVector fvNominalVal = new FastVector(3);
		fvNominalVal.addElement("blue");
		fvNominalVal.addElement("gray");
		fvNominalVal.addElement("black");
		Attribute Attribute3 = new Attribute("aNominal", fvNominalVal);
		
		// Declare the class attribute along with its values
		FastVector fvClassVal = new FastVector(2);
		fvClassVal.addElement("positive");
		fvClassVal.addElement("negative");
		Attribute ClassAttribute = new Attribute("theClass", fvClassVal);
		
		// Declare the feature vector
		fvWekaAttributes = new FastVector(4);
		fvWekaAttributes.addElement(Attribute1);    
		fvWekaAttributes.addElement(Attribute2);    
		fvWekaAttributes.addElement(Attribute3);    
		fvWekaAttributes.addElement(ClassAttribute);
		
		// Create an empty training set
		isTrainingSet = new Instances("Rel", fvWekaAttributes, 10);       
		
		// Set class index
		isTrainingSet.setClassIndex(3);
	}

	public void buildClassifier(){
		// Create the instance
		Instance iExample = new Instance(4);
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(0), 1.0);      
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(1), 0.5);      
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(2), "gray");
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(3), "positive");
		
		// add the instance
		isTrainingSet.delete();
		isTrainingSet.add(iExample);
		cModel = (Classifier)new NaiveBayes();
		try{
			cModel.buildClassifier(isTrainingSet);
		}
		catch(Exception e){
			System.out.println(e);
		}
	}

	public void testClassifier(){
		try{
			Evaluation eTest = new Evaluation(isTrainingSet);
			eTest.evaluateModel(cModel, isTrainingSet);

			// Print the result à la Weka explorer:
			String strSummary = eTest.toSummaryString();
			System.out.println(strSummary);
			
			// Get the confusion matrix
			double[][] cmMatrix = eTest.confusionMatrix();
			for(int row_i=0; row_i<cmMatrix.length; row_i++){
			  for(int col_i=0; col_i<cmMatrix.length; col_i++){
			    System.out.print(cmMatrix[row_i][col_i]);
			    System.out.print("|");
			  }
			  System.out.println();
			}
    }
    catch(Exception e){
    	System.out.println(e);
    }
	}

	public void classify(){
		// Specify that the instance belong to the training set
		 // in order to inherit from the set description
		 Instance iUse = new Instance(4);
		 iUse.setValue((Attribute)fvWekaAttributes.elementAt(0), 1.0);      
		 iUse.setValue((Attribute)fvWekaAttributes.elementAt(1), 0.5);      
		 iUse.setValue((Attribute)fvWekaAttributes.elementAt(2), "gray");
		 
		 iUse.setDataset(isTrainingSet);
		 
		 // Get the likelihood of each classes
		 // fDistribution[0] is the probability of being “positive”
		 // fDistribution[1] is the probability of being “negative”
		 try{
			 double[] fDistribution = cModel.distributionForInstance(iUse);
			 println(fDistribution);
		 }
		 catch(Exception e){
		 	println(e);
		 }
	}
}
