package com.waterquality.service;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/** Approximate capital or regional-center coordinates, used only for map display. */
public final class IndiaCoordinates {
    private static final Map<String, double[]> CENTERS;
    static {
        Map<String, double[]> centers = new HashMap<String, double[]>();
        centers.put("Andhra Pradesh", new double[] {16.5062, 80.6480});
        centers.put("Arunachal Pradesh", new double[] {27.0844, 93.6053});
        centers.put("Assam", new double[] {26.1445, 91.7362});
        centers.put("Bihar", new double[] {25.5941, 85.1376});
        centers.put("Chandigarh", new double[] {30.7333, 76.7794});
        centers.put("Chhattisgarh", new double[] {21.2514, 81.6296});
        centers.put("Delhi", new double[] {28.6139, 77.2090});
        centers.put("Goa", new double[] {15.4909, 73.8278});
        centers.put("Gujarat", new double[] {23.2156, 72.6369});
        centers.put("Haryana", new double[] {29.0588, 76.0856});
        centers.put("Himachal Pradesh", new double[] {31.1048, 77.1734});
        centers.put("Jharkhand", new double[] {23.3441, 85.3096});
        centers.put("Karnataka", new double[] {12.9716, 77.5946});
        centers.put("Kerala", new double[] {8.5241, 76.9366});
        centers.put("Madhya Pradesh", new double[] {23.2599, 77.4126});
        centers.put("Maharashtra", new double[] {19.0760, 72.8777});
        centers.put("Manipur", new double[] {24.8170, 93.9368});
        centers.put("Meghalaya", new double[] {25.5788, 91.8933});
        centers.put("Mizoram", new double[] {23.7271, 92.7176});
        centers.put("Nagaland", new double[] {25.6747, 94.1100});
        centers.put("Odisha", new double[] {20.2961, 85.8245});
        centers.put("Punjab", new double[] {31.6340, 74.8723});
        centers.put("Rajasthan", new double[] {26.9124, 75.7873});
        centers.put("Sikkim", new double[] {27.3389, 88.6065});
        centers.put("Tamil Nadu", new double[] {13.0827, 80.2707});
        centers.put("Telangana", new double[] {17.3850, 78.4867});
        centers.put("Tripura", new double[] {23.8315, 91.2868});
        centers.put("Uttar Pradesh", new double[] {26.8467, 80.9462});
        centers.put("Uttarakhand", new double[] {30.3165, 78.0322});
        centers.put("West Bengal", new double[] {22.5726, 88.3639});
        centers.put("Andaman and Nicobar Islands", new double[] {11.6234, 92.7265});
        centers.put("Dadra and Nagar Haveli and Daman and Diu", new double[] {20.2766, 73.0083});
        centers.put("Jammu and Kashmir", new double[] {33.7782, 76.5762});
        centers.put("Ladakh", new double[] {34.1526, 77.5771});
        centers.put("Lakshadweep", new double[] {10.5667, 72.6417});
        centers.put("Puducherry", new double[] {11.9416, 79.8083});
        CENTERS = Collections.unmodifiableMap(centers);
    }

    private IndiaCoordinates() { }

    public static double[] forState(String state) {
        double[] coordinates = CENTERS.get(state);
        return coordinates == null ? new double[] {22.0, 79.0} : coordinates.clone();
    }
}
