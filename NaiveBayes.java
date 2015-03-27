//package com.mobiusinversion.machine.learning;

/**
 * Created with IntelliJ IDEA.
 * User: david
 * Date: 10/6/13
 * Time: 5:53 PM
 * 2013 Copyright David Williams
 * david@davidgeorgewilliams.com
 */

import java.util.*;

public class NaiveBayes {

    private Set<String> featureSet;
    private Map<String, Integer> categoryCounts = new HashMap<String, Integer>();
    private Map<String, HashMap<String, HashMap<String, Integer>>> categoryFeatureCounts = new HashMap<String, HashMap<String, HashMap<String, Integer>>>();
    private Integer totalObservations = 0;
    private float smoothingFactor;

    public NaiveBayes(Set<String> featureSet, float smoothingFactor) {
        this.featureSet = featureSet;
        this.smoothingFactor = smoothingFactor;
    }

    private void incrementCount(String key, Map<String, Integer> data) {
        if (data.containsKey(key)) {
            data.put(key, data.get(key) + 1);
        } else {
            data.put(key, 1);
        }
    }

    public synchronized void insert(String category, Map<String,String> data) {

        totalObservations += 1;

        incrementCount(category, categoryCounts);

        if(!categoryFeatureCounts.containsKey(category))
            categoryFeatureCounts.put(category, new HashMap<String, HashMap<String, Integer>>());

        Map<String, HashMap<String,Integer>> featureCounts = categoryFeatureCounts.get(category);

        for (String key : data.keySet()) {

            if (!featureCounts.containsKey(key))
                featureCounts.put(key, new HashMap<String, Integer>());

            incrementCount(data.get(key), featureCounts.get(key));

        }

    }

    public synchronized Map<String, Double> classify(Map<String,String> data) {

        Map<String, Double> rankings = new HashMap<String, Double>();

        for (String key : categoryCounts.keySet()) {
            rankings.put(key, getScore(key, data));
        }

        return rankings;

    }

    // Naive Scoring:
    // p(c|f_1, ... f_n) =~ p(c) * p(f_1|c) ... * p(f_n|c)
    private Double getScore(String category, Map<String, String> features) {

        // Laplace Smoothing
        // Assume we have seen alpha observations of each feature within each class.
        // We adjust the number of times we saw this category, and the total observations accordingly.
        // Also, using the sum of log probabilities does not change rankings but gives good numerical stability.

        Integer distinctFeatures = featureSet.size();

        Integer categoryCount = categoryCounts.get(category);

        Integer distinctCategories = categoryCounts.size();

        float smoothedCategoryCount = categoryCount + smoothingFactor * distinctFeatures;

        float smoothedTotalObservations = totalObservations + smoothingFactor * distinctCategories * distinctFeatures;

        Map<String, HashMap<String, Integer>> featureCountsGivenCategory = categoryFeatureCounts.get(category);

        double logSmoothedCategoryCount = Math.log(smoothedCategoryCount);

        double score = logSmoothedCategoryCount - Math.log(smoothedTotalObservations);

        for (String key : featureSet) {

            String value = features.get(key);

            Map<String, Integer> featureValueCounts = featureCountsGivenCategory.get(key);

            Integer featureValueCount = featureValueCounts.get(value);

            featureValueCount = featureValueCount == null ? 0 : featureValueCount;

            double smoothedFeatureValueCount = featureValueCount + smoothingFactor;

            score += Math.log(smoothedFeatureValueCount) - logSmoothedCategoryCount;

        }

        return score;
    }

/*
    public static void main(String[] args) {
        Set<String> featureSet = new HashSet<>(new ArrayList<>(Arrays.asList("color", "legs")));

        NaiveBayes bayes = new NaiveBayes(featureSet, 1.0);

        Map<String, String> zebra = new HashMap<>();
        zebra.put("color", "black and white");
        zebra.put("legs",  "four");
        bayes.insert("zebra", zebra);

        Map<String, String> human = new HashMap<>();
        human.put("color", "tan");
        human.put("legs", "two");
        bayes.insert("human", human);

        Map<String, String> horse = new HashMap<>();
        horse.put("color", "brown");
        horse.put("legs",  "four");
        bayes.insert("horse", horse);

        Map<String, String> penguin = new HashMap<>();
        penguin.put("color", "black and white");
        penguin.put("legs", "two");
        bayes.insert("penguin", penguin);

        Map<String, String> unknown = new HashMap<>();
        unknown.put("color", "black and white");
        unknown.put("legs", "three");

        Map<String, Double> prediction = bayes.classify(unknown);
        System.out.println(prediction);

    }*/
}




