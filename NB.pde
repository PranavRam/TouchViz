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
		Attribute Attribute1 = new Attribute("symboling");
		Attribute Attribute2 = new Attribute("normalized-losses");
		Attribute Attribute10 = new Attribute("wheel-base");
		Attribute Attribute11 = new Attribute("length");
		Attribute Attribute12 = new Attribute("width");
		Attribute Attribute13 = new Attribute("height");
		Attribute Attribute14 = new Attribute("curb-weigh");
		Attribute Attribute17 = new Attribute("engine-size");
		Attribute Attribute19 = new Attribute("bore");
		Attribute Attribute20 = new Attribute("stroke");
		Attribute Attribute21 = new Attribute("compression-ratio");
		Attribute Attribute22 = new Attribute("horsepower");
		Attribute Attribute23 = new Attribute("peak-rpm");
		Attribute Attribute24 = new Attribute("city-mpg");
		Attribute Attribute25 = new Attribute("highway-mpg");
		Attribute Attribute26 = new Attribute("price");
		
		// Declare a nominal attribute along with its values
		FastVector fvNominalVal1 = new FastVector(22);
		String[] manufacturers = {"alfa-romero", "audi", "bmw", "chevrolet", "dodge", "honda", "isuzu", "jaguar", "mazda", "mercedes-benz", "mercury", "mitsubishi", "nissan", "peugot", "plymouth", "porsche", "renault", "saab", "subaru", "toyota", "volkswagen", "volvo"};
		for(String manufacturer : manufacturers){
			fvNominalVal1.addElement(manufacturer);
		}
		Attribute Attribute3 = new Attribute("make", fvNominalVal1);


		FastVector fvNominalVal2 = new FastVector(2);
		fvNominalVal2.addElement("gas");
		fvNominalVal2.addElement("diesel");
		Attribute Attribute4 = new Attribute("fuel-type", fvNominalVal2);
		
		FastVector fvNominalVal3 = new FastVector(2);
		fvNominalVal3.addElement("std");
		fvNominalVal3.addElement("turbo");
		Attribute Attribute5 = new Attribute("aspiration", fvNominalVal3);

		FastVector fvNominalVal4 = new FastVector(3);
		fvNominalVal4.addElement("two");
		fvNominalVal4.addElement("four");
		fvNominalVal4.addElement("?");
		Attribute Attribute6 = new Attribute("num-of-doors", fvNominalVal4);

		FastVector fvNominalVal5 = new FastVector(5);
		fvNominalVal5.addElement("convertible");
		fvNominalVal5.addElement("hatchback");
		fvNominalVal5.addElement("sedan");
		fvNominalVal5.addElement("wagon");
		fvNominalVal5.addElement("hardtop");
		Attribute Attribute7 = new Attribute("body-style", fvNominalVal5);

		FastVector fvNominalVal6 = new FastVector(3);
		fvNominalVal6.addElement("rwd");
		fvNominalVal6.addElement("fwd");
		fvNominalVal6.addElement("4wd");
		Attribute Attribute8 = new Attribute("drive-wheels", fvNominalVal6);

		FastVector fvNominalVal7 = new FastVector(2);
		fvNominalVal7.addElement("front");
		fvNominalVal7.addElement("rear");
		Attribute Attribute9 = new Attribute("engine-location", fvNominalVal7);
		
		FastVector fvNominalVal8 = new FastVector(7);
		String[] engineTypes = {"dohc", "ohcv", "ohc", "l", "rotor", "ohcf", "dohcv"};
		for(String engineType : engineTypes){
			fvNominalVal8.addElement(engineType);
		}
		Attribute Attribute15 = new Attribute("engine-type", fvNominalVal8);

		FastVector fvNominalVal9 = new FastVector(7);
		String[] cylinders = {"four", "six", "five", "three", "twelve", "two", "eight"};
		for(String cylinder : cylinders){
			fvNominalVal9.addElement(cylinder);
		}
		Attribute Attribute16 = new Attribute("num-of-cylinders", fvNominalVal9);

		FastVector fvNominalVal10 = new FastVector(8);
		String[] fuelSystems = {"mpfi", "2bbl", "mfi", "1bbl", "spfi", "4bbl", "idi", "spdi"};
		for(String fuelSystem : fuelSystems){
			fvNominalVal10.addElement(fuelSystem);
		}
		Attribute Attribute18 = new Attribute("fuel-system", fvNominalVal10);

		// Declare the class attribute along with its values
		FastVector fvClassVal = new FastVector(10);
		fvClassVal.addElement("0");
		fvClassVal.addElement("1");
		fvClassVal.addElement("2");
		fvClassVal.addElement("3");
		fvClassVal.addElement("4");
		fvClassVal.addElement("5");
		fvClassVal.addElement("6");
		fvClassVal.addElement("7");
		fvClassVal.addElement("8");
		fvClassVal.addElement("9");
		Attribute ClassAttribute = new Attribute("theClass", fvClassVal);
		
		// Declare the feature vector
		fvWekaAttributes = new FastVector(27);
		fvWekaAttributes.addElement(Attribute1);    
		fvWekaAttributes.addElement(Attribute2);    
		fvWekaAttributes.addElement(Attribute3);
		fvWekaAttributes.addElement(Attribute4);
		fvWekaAttributes.addElement(Attribute5);
		fvWekaAttributes.addElement(Attribute6);
		fvWekaAttributes.addElement(Attribute7);
		fvWekaAttributes.addElement(Attribute8);
		fvWekaAttributes.addElement(Attribute9);
		fvWekaAttributes.addElement(Attribute10);
		fvWekaAttributes.addElement(Attribute11);
		fvWekaAttributes.addElement(Attribute12);
		fvWekaAttributes.addElement(Attribute13);
		fvWekaAttributes.addElement(Attribute14);
		fvWekaAttributes.addElement(Attribute15);
		fvWekaAttributes.addElement(Attribute16);
		fvWekaAttributes.addElement(Attribute17);
		fvWekaAttributes.addElement(Attribute18);
		fvWekaAttributes.addElement(Attribute19);
		fvWekaAttributes.addElement(Attribute20);
		fvWekaAttributes.addElement(Attribute21);
		fvWekaAttributes.addElement(Attribute22);
		fvWekaAttributes.addElement(Attribute23);
		fvWekaAttributes.addElement(Attribute24);
		fvWekaAttributes.addElement(Attribute25);
		fvWekaAttributes.addElement(Attribute26);
		fvWekaAttributes.addElement(ClassAttribute);
		
		// Create an empty training set
		isTrainingSet = new Instances("Rel", fvWekaAttributes, 100);       
		
		// Set class index
		isTrainingSet.setClassIndex(26);
	}

	public void clearTrainingSet(){
		isTrainingSet.delete();
	}

	private Instance getInstanceFor(JSONObject data){
		Instance iExample = new Instance(27);
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(0), data.getFloat("symboling"));      
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(1), data.getFloat("normalized-losses"));      
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(2), data.getString("make"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(3), data.getString("fuel-type"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(4), data.getString("aspiration"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(5), data.getString("num-of-doors"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(6), data.getString("body-style"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(7), data.getString("drive-wheels"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(8), data.getString("engine-location"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(9), data.getFloat("wheel-base"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(10), data.getFloat("length"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(11), data.getFloat("width"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(12), data.getFloat("height"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(13), data.getFloat("curb-weigh"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(14), data.getString("engine-type"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(15), data.getString("num-of-cylinders"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(16), data.getFloat("engine-size"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(17), data.getString("fuel-system"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(18), data.getFloat("bore"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(19), data.getFloat("stroke"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(20), data.getFloat("compression-ratio"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(21), data.getFloat("horsepower"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(22), data.getFloat("peak-rpm"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(23), data.getFloat("city-mpg"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(24), data.getFloat("highway-mpg"));
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(25), data.getFloat("price"));
		return iExample;
	}
	private Instance getInstanceFor(JSONObject data, String className){
		Instance iExample = getInstanceFor(data);
		iExample.setValue((Attribute)fvWekaAttributes.elementAt(26), className);

		return iExample;
	}
	public void addToTrainingSet(JSONObject data, String className){
		Instance iExample = getInstanceFor(data, className);
		isTrainingSet.add(iExample);
	}

	public void buildClassifier(){
		// Create the instance
		// isTrainingSet.delete();
		// Instance iExample = new Instance(4);
		// iExample.setValue((Attribute)fvWekaAttributes.elementAt(0), 3);      
		// iExample.setValue((Attribute)fvWekaAttributes.elementAt(1), 88.6);      
		// iExample.setValue((Attribute)fvWekaAttributes.elementAt(2), "convertible");
		// iExample.setValue((Attribute)fvWekaAttributes.elementAt(3), "0");
		
		// add the instance
		// isTrainingSet.add(iExample);
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

	public double[] classify(JSONObject data){
		// Specify that the instance belong to the training set
		 // in order to inherit from the set description
		 Instance iUse = getInstanceFor(data);
		 iUse.setDataset(isTrainingSet);
		 // println(iUse.value(0));
		 // Get the likelihood of each classes
		 // fDistribution[0] is the probability of being “positive”
		 // fDistribution[1] is the probability of being “negative”
		 try{
			 double[] fDistribution = cModel.distributionForInstance(iUse);
			 // println(fDistribution);
			 return fDistribution;
		 }
		 catch(Exception e){
		 	println("Help "+e);
		 }

		 return null;
	}
}
