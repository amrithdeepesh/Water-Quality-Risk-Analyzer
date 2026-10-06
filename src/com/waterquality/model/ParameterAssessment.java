package com.waterquality.model;

public final class ParameterAssessment {
    private final String name;
    private final String value;
    private final String status;
    private final String recommendation;
    private final int severity;

    public ParameterAssessment(String name, String value, String status,
            String recommendation, int severity) {
        this.name = name;
        this.value = value;
        this.status = status;
        this.recommendation = recommendation;
        this.severity = severity;
    }

    public String getName() { return name; }
    public String getValue() { return value; }
    public String getStatus() { return status; }
    public String getRecommendation() { return recommendation; }
    public int getSeverity() { return severity; }

    public String getStatusCssClass() {
        return status.toLowerCase(java.util.Locale.ROOT);
    }
}
