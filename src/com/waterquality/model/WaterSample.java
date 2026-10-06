package com.waterquality.model;

public final class WaterSample {
    private final String state;
    private final String city;
    private final String waterSource;
    private final String collectionDate;
    private final double ph;
    private final double turbidity;
    private final double tds;
    private final double dissolvedOxygen;
    private final double temperature;
    private final double hardness;
    private final double freeChlorine;
    private final boolean coliformDetected;

    public WaterSample(String state, String city, String waterSource,
            String collectionDate, double ph, double turbidity, double tds,
            double dissolvedOxygen, double temperature, double hardness,
            double freeChlorine, boolean coliformDetected) {
        this.state = state;
        this.city = city;
        this.waterSource = waterSource;
        this.collectionDate = collectionDate;
        this.ph = ph;
        this.turbidity = turbidity;
        this.tds = tds;
        this.dissolvedOxygen = dissolvedOxygen;
        this.temperature = temperature;
        this.hardness = hardness;
        this.freeChlorine = freeChlorine;
        this.coliformDetected = coliformDetected;
    }

    public String getState() { return state; }
    public String getCity() { return city; }
    public String getWaterSource() { return waterSource; }
    public String getCollectionDate() { return collectionDate; }
    public double getPh() { return ph; }
    public double getTurbidity() { return turbidity; }
    public double getTds() { return tds; }
    public double getDissolvedOxygen() { return dissolvedOxygen; }
    public double getTemperature() { return temperature; }
    public double getHardness() { return hardness; }
    public double getFreeChlorine() { return freeChlorine; }
    public boolean isColiformDetected() { return coliformDetected; }
}
